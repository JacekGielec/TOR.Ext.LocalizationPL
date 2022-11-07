Report 50469 "TOR Calc&Post Bank Exch. Diff."
{
    Permissions = TableData 271 = m;
    Caption = 'Calc. & Post Bank Exch. Diff.';
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORCalcPostBankExchDiff.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    //PLK=Oblicz i zaksi©guj bankowe r¢¾n. kursowe];


    DATASET
    {
        DataItem("Bank Account"; "Bank Account")
        {
            RequestFilterFields = "No.";

            Column(No_BankAccount; "No.") { }

            Column(Name_BankAccount; Name) { }

            Column(CurrencyCode_BankAccount; "Currency Code")
            {
                IncludeCaption = true;
            }

            Column(Balance_BankAccount; Balance) { }

            Column(FORMATEndDateReq; '..' + FORMAT(EndDateReq, 0, DateFormat)) { }

            Column(GetAppVersion_CompanyInfo; '') { }

            Column(COMPANYNAME; COMPANYNAME) { }

            Column(TestMode; TestMode) { }

            //Bank Account Ledger Entry
            DataItem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemTableView = SORTING("Bank Account No.", "Posting Date");
                DataItemLink = "Bank Account No." = FIELD("No."),
                            "Currency Code" = FIELD("Currency Code");

                trigger OnPreDataItem()
                BEGIN
                    SETRANGE("Posting Date", 0D, EndDate);
                    IF NOT TestMode THEN
                        SETRANGE(Applied, FALSE);

                    CalculatingNoTotal := COUNT;
                END;

                trigger OnAfterGetRecord()
                VAR
                    ApplBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    AmountLCY: Decimal;
                BEGIN
                    CalculatingNo += 1;
                    Window.UPDATE(2, ROUND(CalculatingNo / CalculatingNoTotal * 10000, 1));

                    IF TestMode THEN BEGIN
                        IF BankAccLedgEntryTemp.GET("Entry No.") THEN
                            "Bank Account Ledger Entry" := BankAccLedgEntryTemp;
                        IF Applied THEN
                            CurrReport.SKIP;
                    END;

                    IF Amount <= 0 THEN
                        CurrReport.SKIP;

                    ExchRate := "Amount (LCY)" / Amount;
                    RemainingAmount := Amount - "Applied Amount";

                    BankAccLedgEntry.RESET;
                    BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");       //FIFO
                    BankAccLedgEntry.COPYFILTERS("Bank Account Ledger Entry");
                    IF BankAccLedgEntry.FINDFIRST THEN
                        REPEAT
                            ExchDiff := 0;

                            IF TestMode THEN
                                IF BankAccLedgEntryTemp.GET(BankAccLedgEntry."Entry No.") THEN
                                    BankAccLedgEntry := BankAccLedgEntryTemp;

                            IF NOT BankAccLedgEntry.Applied AND (BankAccLedgEntry.Amount < 0) THEN BEGIN
                                IF -RemainingAmount <= (BankAccLedgEntry.Amount - BankAccLedgEntry."Applied Amount") THEN BEGIN
                                    AppAmount := BankAccLedgEntry.Amount - BankAccLedgEntry."Applied Amount";
                                    RemainingAmount := RemainingAmount + AppAmount;
                                    BankAccLedgEntry.Applied := TRUE;
                                    IF TestMode THEN BEGIN
                                        BankAccLedgEntryTemp := BankAccLedgEntry;
                                        IF NOT BankAccLedgEntryTemp.MODIFY THEN BEGIN
                                            BankAccLedgEntryTemp.INSERT;
                                            IF BankAccLedgEntryTemp."Posting Date" < StartTempDate THEN
                                                StartTempDate := BankAccLedgEntryTemp."Posting Date";
                                        END;
                                    END;
                                END ELSE BEGIN
                                    AppAmount := -RemainingAmount;
                                    RemainingAmount := 0;
                                END;

                                AmountLCY := BankAccLedgEntry."Amount (LCY)";

                                ApplBankAccountLedgerEntry.SETRANGE("Applied to Entry", BankAccLedgEntry."Entry No.");
                                IF ApplBankAccountLedgerEntry.FINDFIRST THEN
                                    REPEAT
                                        IF TestMode THEN BEGIN
                                            IF NOT BankAccLedgEntryTemp.GET(ApplBankAccountLedgerEntry."Entry No.") THEN
                                                AmountLCY += ApplBankAccountLedgerEntry."Amount (LCY)";
                                        END ELSE
                                            AmountLCY += ApplBankAccountLedgerEntry."Amount (LCY)";
                                    UNTIL ApplBankAccountLedgerEntry.NEXT = 0;

                                IF TestMode THEN BEGIN
                                    BankAccLedgEntryTemp.SETRANGE("Applied to Entry", BankAccLedgEntry."Entry No.");
                                    IF BankAccLedgEntryTemp.FINDFIRST THEN
                                        REPEAT
                                            AmountLCY += BankAccLedgEntryTemp."Amount (LCY)";
                                        UNTIL BankAccLedgEntryTemp.NEXT = 0;
                                    BankAccLedgEntryTemp.SETRANGE("Applied to Entry");
                                END;

                                IF TestMode THEN
                                    IF BankAccLedgEntryTemp.GET(BankAccLedgEntry."Entry No.") THEN
                                        BankAccLedgEntry := BankAccLedgEntryTemp;

                                ExchDiff := -Round((AppAmount * ExchRate - (AmountLCY * (AppAmount / BankAccLedgEntry.Amount))));

                                BankAccLedgEntry."Difference Amount" := BankAccLedgEntry."Difference Amount" + ExchDiff;
                                BankAccLedgEntry."Applied Amount" := BankAccLedgEntry."Applied Amount" + AppAmount;
                                BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry."Remaining Amount" - AppAmount;
                                BankAccLedgEntry."Applied to Entry" := "Entry No.";
                                IF BankAccLedgEntry."Remaining Amount" = 0 THEN
                                    BankAccLedgEntry.Open := FALSE;

                                IF TestMode THEN BEGIN
                                    BankAccLedgEntryTemp := BankAccLedgEntry;
                                    IF NOT BankAccLedgEntryTemp.MODIFY THEN BEGIN
                                        BankAccLedgEntryTemp.INSERT;
                                        IF BankAccLedgEntryTemp."Posting Date" < StartTempDate THEN
                                            StartTempDate := BankAccLedgEntryTemp."Posting Date";
                                    END;
                                END ELSE
                                    BankAccLedgEntry.MODIFY;


                                IF TestMode THEN BEGIN
                                    IF BankAccLedgEntryTemp.GET("Entry No.") THEN
                                        "Bank Account Ledger Entry" := BankAccLedgEntryTemp;
                                END;

                                "Applied Amount" := Amount - RemainingAmount;
                                "Remaining Amount" := RemainingAmount;
                                IF RemainingAmount = 0 THEN BEGIN
                                    Applied := TRUE;
                                    Open := FALSE;
                                    "Applied to Entry" := "Entry No."
                                END;

                                IF TestMode THEN BEGIN
                                    BankAccLedgEntryTemp := "Bank Account Ledger Entry";
                                    IF NOT BankAccLedgEntryTemp.MODIFY THEN BEGIN
                                        BankAccLedgEntryTemp.INSERT;
                                        IF BankAccLedgEntryTemp."Posting Date" < StartTempDate THEN
                                            StartTempDate := BankAccLedgEntryTemp."Posting Date";
                                    END;
                                END;

                            END;
                        UNTIL (RemainingAmount = 0) OR (BankAccLedgEntry.NEXT = 0);
                    IF NOT TestMode THEN
                        MODIFY;
                END;

            }
            DataItem("Bank Account Ledger Entry 2"; "Bank Account Ledger Entry")
            {
                DataItemTableView = SORTING("Bank Account No.", "Posting Date");
                DataItemLink = "Bank Account No." = FIELD("No.");

                Column(EntryNo_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Entry No.")
                {
                    IncludeCaption = true;
                }

                Column(FORMATPostingDate_BankAccLedgEntryTemp; FORMAT(BankAccLedgEntryTemp."Posting Date")) { }

                Column(Amount_BankAccLedgEntryTemp; BankAccLedgEntryTemp.Amount)
                {
                    IncludeCaption = true;
                }
                Column(AmountLCY_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                Column(AppliedAmount_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Applied Amount")
                {
                    IncludeCaption = true;
                }
                Column(DifferenceAmount_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Difference Amount")
                {
                    IncludeCaption = true;
                }
                Column(AppliedToEntry_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Applied to Entry")
                {
                    IncludeCaption = true;
                }

                Column(ExRate; ExRate) { }

                Column(Applied_BankAccLedgEntryTemp; AppliedOpt) { }
                Column(PostedDifference_BankAccLedgEntryTemp; DifferencePostedOpt) { }
                Column(RealizedGains; RealizedGains) { }

                Column(RealizedLosses; RealizedLosses) { }

                //Bank Account Ledger Entry 2
                trigger OnPreDataItem()
                BEGIN
                    IF NOT TestMode THEN
                        CurrReport.BREAK;

                    SETRANGE("Posting Date", StartTempDate, EndDate);

                    CurrReport.CREATETOTALS(BankAccLedgEntryTemp.Amount, BankAccLedgEntryTemp."Amount (LCY)",
                                                       BankAccLedgEntryTemp."Difference Amount");

                    PrintingNoTotal := COUNT;
                END;

                trigger OnAfterGetRecord()
                BEGIN
                    PrintingNo += 1;
                    Window.UPDATE(4, ROUND(PrintingNo / PrintingNoTotal * 10000, 1));

                    IF NOT BankAccLedgEntryTemp.GET("Entry No.") THEN
                        CurrReport.SKIP;

                    IF BankAccLedgEntryTemp."Difference Amount" < 0 THEN
                        RealizedGains -= BankAccLedgEntryTemp."Difference Amount"
                    ELSE
                        RealizedLosses -= BankAccLedgEntryTemp."Difference Amount";

                    IF BankAccLedgEntryTemp.Amount <> 0 THEN
                        ExRate := BankAccLedgEntryTemp."Amount (LCY)" / BankAccLedgEntryTemp.Amount
                    ELSE
                        ExRate := 0;

                    IF BankAccLedgEntryTemp.Applied THEN
                        AppliedOpt := AppliedOpt::Yes
                    ELSE
                        AppliedOpt := AppliedOpt::" ";

                    IF BankAccLedgEntryTemp."Difference Posted" THEN
                        DifferencePostedOpt := DifferencePostedOpt::Yes
                    ELSE
                        DifferencePostedOpt := DifferencePostedOpt::" ";
                END;
            }



            DataItem("Bank Account Ledger Entry 3"; "Bank Account Ledger Entry")
            {
                DataItemTableView = SORTING("Bank Account No.", "Posting Date")
                                 WHERE(Applied = CONST(true),
                                       "Difference Posted" = CONST(false));
                DataItemLink = "Bank Account No." = FIELD("No.");


                Column(EntryNo_BankAccountLedgerEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                Column(FORMATPostingDate_BankAccountLedgerEntry; FORMAT("Posting Date")) { }

                Column(Amount_BankAccountLedgerEntry; "Amount")
                {
                    IncludeCaption = true;
                }
                Column(AmountLCY_BankAccountLedgerEntry; "Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                Column(AppliedAmount_BankAccountLedgerEntry; "Applied Amount")
                {
                    IncludeCaption = true;
                }
                Column(DifferenceAmount_BankAccountLedgerEntry; "Difference Amount")
                {
                    IncludeCaption = true;
                }
                Column(AppliedToEntry_BankAccountLedgerEntry; "Applied to Entry")
                {
                    IncludeCaption = true;
                }
                Column(ExRate2; ExRate) { }

                Column(Applied_BankAccountLedgerEntry; AppliedOpt) { }

                Column(PostedDifference_BankAccountLedgerEntry; DifferencePostedOpt) { }

                Column(RealizedGains2; RealizedGains) { }

                Column(RealizedLosses2; RealizedLosses) { }


                //Bank Account Ledger Entry 3
                trigger OnPreDataItem()
                BEGIN
                    IF TestMode THEN
                        CurrReport.BREAK;

                    SETRANGE("Posting Date", 0D, EndDate);

                    Currency.GET("Bank Account"."Currency Code");

                    Currency.TESTFIELD("Realized Gains Acc.");
                    Currency.TESTFIELD("Realized Losses Acc.");

                    PostingNoTotal := COUNT;

                    RealizedGains := 0;
                    RealizedLosses := 0;
                END;

                trigger OnAfterGetRecord()
                BEGIN
                    PostingNo += 1;
                    Window.UPDATE(3, ROUND(PostingNo / PostingNoTotal * 10000, 1));

                    IF "Difference Amount" <> 0 THEN BEGIN
                        IF "Difference Amount" < 0 THEN
                            RealizedGains -= "Difference Amount"
                        ELSE
                            RealizedLosses -= "Difference Amount";

                        PostDifference("Difference Amount", Amount,
                                       FORMAT("Document Type"), "Document No.", "Posting Date",
                                       "Entry No.", "Dimension Set ID");
                        "Difference Posted" := TRUE;
                        MODIFY;
                    END;

                    IF Amount <> 0 THEN
                        ExRate := "Amount (LCY)" / Amount
                    ELSE
                        ExRate := 0;

                    IF Applied THEN
                        AppliedOpt := AppliedOpt::Yes
                    ELSE
                        AppliedOpt := AppliedOpt::" ";

                    IF "Difference Posted" THEN
                        DifferencePostedOpt := DifferencePostedOpt::Yes
                    ELSE
                        DifferencePostedOpt := DifferencePostedOpt::" ";
                END;

            }


            //Bank Account
            trigger OnPreDataItem()
            BEGIN
                BankAccNoTotal := COUNT;
            END;

            trigger OnAfterGetRecord()
            BEGIN
                RealizedGains := 0;
                RealizedLosses := 0;

                BankAccNo += 1;
                Window.UPDATE(1, ROUND(BankAccNo / BankAccNoTotal * 10000, 1));

                IF TestMode THEN
                    BankAccLedgEntryTemp.DELETEALL;
                StartTempDate := 99991231D;
            END;

        }



    }
    REQUESTPAGE
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    Group("Adjustment Period")
                    {
                        Field(EndDateReq; EndDateReq)
                        {
                            Caption = 'Ending Date';
                            ApplicationArea = Basic, Suite;
                        }

                        Field(PostingDescription; PostingDescription)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posting Description';
                        }

                        Field(PostingDocNo; PostingDocNo)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Document No.';
                        }

                        Field(testmode; testmode)
                        {
                            Caption = 'Test Mode';
                            ApplicationArea = Basic, Suite;
                        }
                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            IF PostingDescription = '' THEN
                PostingDescription := Text001;
            //TestMode := TRUE;
        END;

    }

    LABELS
    {
        Applied_BankAccLedgEntryTempCaption = 'Applied';
        Applied_BankAccountLedgerEntryCaption = 'Applied';
        BankAccLedgEntryAmountLCYCaption = 'Amount (LCY)';
        BankAccLedgEntryAppliedCaption = 'Applied';
        BankAccLedgEntryAppliedAmountCaption = 'Applied Amount';
        BankAccLedgEntryAppliedToEntryCaption = 'Applied To Entry';
        BankAccLedgEntryAmountCaption = 'Amount';
        BankAccLedgEntryDifferenceAmountCaption = 'Difference Amount';
        BankAccLedgEntryEntryNoCaption = 'Entry No.';
        BankAccLedgEntryPostingDateCaption = 'Posting Date';
        CalcPostBankExchDiffCaption = 'Calc. & Post Bank Exch. Diff.';
        PostedDifference_BankAccLedgEntryTempCaption = 'Difference Posted';
        PostedDifference_BankAccountLedgerEntryCaption = 'Difference Posted';
        ExchangeRateCaption = 'Exchange Rate';
        LastPageCaption = 'Last Page';
        PageNoCaption = 'Page';
        PeriodCaption = 'Period:';
        PostedDifferenceCaption = 'Posted Difference';
        RealizedGainsCaption = 'Realized Gains';
        RealizedLossesCaption = 'Realized Losses';
    }

    VAR
        BankAccLedgEntry: Record 271;
        BankAccLedgEntryTemp: Record 271 temporary;
        CompanyInfo: Record 79;
        Currency: Record 4;
        GenJnlLine: Record 81;
        GLSetup: Record 98;
        SalesSetup: Record 311;
        SourceCodeSetup: Record 242;
        TempDimSetEntry: Record 480 temporary;
        DimMgt: Codeunit 408;
        GenJnlPostLine: Codeunit 12;
        UpdateAnalysisView: Codeunit 410;
        AppAmount: Decimal;
        BankAccNo: Decimal;
        BankAccNoTotal: Decimal;
        CalculatingNo: Decimal;
        CalculatingNoTotal: Decimal;
        DateFormat: Text[30];
        EndDate: Date;
        EndDateReq: Date;
        ExchDiff: Decimal;
        ExchRate: Decimal;
        ExRate: Decimal;
        Text000: Label '%1 must be entered.';
        Text001: Label 'Bank Trans. Calc. of %1 %2 %3 %4';
        Text002: Label 'Calculating bank transactions...\\';
        Text003: Label 'Bank Account    @1@@@@@@@@@@@@@\\';
        Text004: Label 'Calculating        @2@@@@@@@@@@@@@\';
        Text005: Label 'Posting          @3@@@@@@@@@@@@@\';
        PostingDateForClosedPeriod: Date;
        PostingDescription: Text[50];
        PostingDocNo: Code[20];
        PostingNo: Decimal;
        PostingNoTotal: Decimal;
        Text006: Label 'Printing          @4@@@@@@@@@@@@@\';
        PrintingNo: Decimal;
        PrintingNoTotal: Decimal;
        RealizedGains: Decimal;
        RealizedLosses: Decimal;
        RemainingAmount: Decimal;
        StartTempDate: Date;
        SumApplied: Decimal;
        SumExDiff: Decimal;
        TestMode: Boolean;
        Window: Dialog;
        WindowText: Text[1024];
        AppliedOpt: Option " ",Yes;
        DifferencePostedOpt: Option " ",Yes;

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    BEGIN
        GLSetup.GET;
        SalesSetup.GET;
        SourceCodeSetup.GET;

        IF EndDateReq = 0D THEN
            EndDate := 99991231D
        ELSE
            EndDate := EndDateReq;

        PostingDateForClosedPeriod := GLSetup.FirstAllowedPostingDate;

        IF PostingDocNo = '' THEN
            ERROR(Text000, GenJnlLine.FIELDCAPTION("Document No."));

        WindowText := Text002 + Text003 + Text004;
        IF TestMode THEN
            WindowText := WindowText + Text006
        ELSE
            WindowText := WindowText + Text005;

        Window.OPEN(WindowText);
    END;

    trigger OnPostReport()
    BEGIN
        Window.CLOSE;

        IF NOT TestMode THEN
            UpdateAnalysisView.UpdateAll(0, TRUE);
    END;




    PROCEDURE PostDifference(Amount: Decimal; BaseAmount: Decimal; DocNo: Code[20]; DocType: Text[30]; PostingDate: Date; BankAccLedgEntryNo: Integer; BankAccLedgEntryDimSetID: Integer);
    BEGIN
        TempDimSetEntry.DELETEALL;
        GenJnlLine.INIT;

        GenJnlLine."Document No." := PostingDocNo;
        GenJnlLine.Description := PostingDescription;
        GenJnlLine.Description := COPYSTR(STRSUBSTNO(PostingDescription,
                                                     "Bank Account"."Currency Code",
                                                     BaseAmount, DocType, DocNo), 1, 50);
        GenJnlLine.TESTFIELD(Description);

        IF GLSetup.IsPostingAllowed(PostingDate) THEN
            GenJnlLine."Posting Date" := PostingDate
        ELSE
            GenJnlLine."Posting Date" := PostingDateForClosedPeriod;

        GenJnlLine."Currency Code" := "Bank Account"."Currency Code";
        GenJnlLine."Exchange Rate Difference" := TRUE;
        GenJnlLine."Allow Zero-Amount Posting" := TRUE;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Code" := SourceCodeSetup."Bank Trans. Recalculation";

        GenJnlLine."Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Amount (LCY)" := ROUND(Amount, Currency."Amount Rounding Precision");
        GenJnlLine.Amount := 0;
        IF Amount > 0 THEN
            GenJnlLine."Account No." := Currency."Realized Losses Acc."
        ELSE
            GenJnlLine."Account No." := Currency."Realized Gains Acc.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := "Bank Account"."No.";
        GenJnlLine."Applied to Bank Entry No." := BankAccLedgEntryNo;

        GetJnlLineDim(GenJnlLine, TempDimSetEntry, BankAccLedgEntryDimSetID);
        PostGenJnlLine(GenJnlLine, TempDimSetEntry);
    END;

    LOCAL PROCEDURE PostGenJnlLine(VAR GenJnlLine: Record 81; VAR DimSetEntry: Record 480);
    BEGIN
        GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimSetEntry);
        GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimSetEntry);
        GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(DimSetEntry);
        GenJnlPostLine.RUN(GenJnlLine);
    END;

    LOCAL PROCEDURE GetJnlLineDim(VAR GenJnlLine: Record 81; VAR DimSetEntry: Record 480; BankAccLedgEntryDimSetID: Integer);
    VAR
        DimSetEntry2: Record 480;
    BEGIN
        DimSetEntry2.SETRANGE("Dimension Set ID", BankAccLedgEntryDimSetID);
        IF DimSetEntry2.FINDFIRST THEN
            REPEAT
                DimSetEntry := DimSetEntry2;
                DimSetEntry.INSERT;
            UNTIL DimSetEntry2.NEXT = 0
    END;

    LOCAL PROCEDURE GetGlobalDimVal(GlobalDimCode: Code[20]; VAR DimSetEntry: Record 480): Code[20];
    VAR
        DimVal: Code[20];
    BEGIN
        IF GlobalDimCode = '' THEN
            DimVal := ''
        ELSE BEGIN
            DimSetEntry.SETRANGE("Dimension Code", GlobalDimCode);
            IF DimSetEntry.FIND('-') THEN
                DimVal := DimSetEntry."Dimension Value Code"
            ELSE
                DimVal := '';
            DimSetEntry.SETRANGE("Dimension Code");
        END;
        EXIT(DimVal);
    END;
}
/*
RDLDATA
{
  <?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
<AutoRefresh>0</AutoRefresh>
<DataSources>
  <DataSource Name="DataSource">
    <ConnectionProperties>
      <DataProvider>SQL</DataProvider>
      <ConnectString />
    </ConnectionProperties>
    <rd:SecurityType>None</rd:SecurityType>
    <rd:DataSourceID>69dc3d20-19fa-4285-8ced-e8af08f8e9bd</rd:DataSourceID>
  </DataSource>
</DataSources>
<DataSets>
  <DataSet Name="DataSet_Result">
    <Query>
      <DataSourceName>DataSource</DataSourceName>
      <CommandText />
    </Query>
    <Fields>
      <Field Name="No_BankAccount">
        <DataField>No_BankAccount</DataField>
      </Field>
      <Field Name="Name_BankAccount">
        <DataField>Name_BankAccount</DataField>
      </Field>
      <Field Name="CurrencyCode_BankAccount">
        <DataField>CurrencyCode_BankAccount</DataField>
      </Field>
      <Field Name="Balance_BankAccount">
        <DataField>Balance_BankAccount</DataField>
      </Field>
      <Field Name="Balance_BankAccountFormat">
        <DataField>Balance_BankAccountFormat</DataField>
      </Field>
      <Field Name="FORMATEndDateReq">
        <DataField>FORMATEndDateReq</DataField>
      </Field>
      <Field Name="GetAppVersion_CompanyInfo">
        <DataField>GetAppVersion_CompanyInfo</DataField>
      </Field>
      <Field Name="COMPANYNAME">
        <DataField>COMPANYNAME</DataField>
      </Field>
      <Field Name="TestMode">
        <DataField>TestMode</DataField>
      </Field>
      <Field Name="EntryNo_BankAccLedgEntryTemp">
        <DataField>EntryNo_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="FORMATPostingDate_BankAccLedgEntryTemp">
        <DataField>FORMATPostingDate_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="Amount_BankAccLedgEntryTemp">
        <DataField>Amount_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="Amount_BankAccLedgEntryTempFormat">
        <DataField>Amount_BankAccLedgEntryTempFormat</DataField>
      </Field>
      <Field Name="AmountLCY_BankAccLedgEntryTemp">
        <DataField>AmountLCY_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="AmountLCY_BankAccLedgEntryTempFormat">
        <DataField>AmountLCY_BankAccLedgEntryTempFormat</DataField>
      </Field>
      <Field Name="AppliedAmount_BankAccLedgEntryTemp">
        <DataField>AppliedAmount_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="AppliedAmount_BankAccLedgEntryTempFormat">
        <DataField>AppliedAmount_BankAccLedgEntryTempFormat</DataField>
      </Field>
      <Field Name="DifferenceAmount_BankAccLedgEntryTemp">
        <DataField>DifferenceAmount_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="DifferenceAmount_BankAccLedgEntryTempFormat">
        <DataField>DifferenceAmount_BankAccLedgEntryTempFormat</DataField>
      </Field>
      <Field Name="AppliedToEntry_BankAccLedgEntryTemp">
        <DataField>AppliedToEntry_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="ExRate">
        <DataField>ExRate</DataField>
      </Field>
      <Field Name="ExRateFormat">
        <DataField>ExRateFormat</DataField>
      </Field>
      <Field Name="Applied_BankAccLedgEntryTemp">
        <DataField>Applied_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="PostedDifference_BankAccLedgEntryTemp">
        <DataField>PostedDifference_BankAccLedgEntryTemp</DataField>
      </Field>
      <Field Name="RealizedGains">
        <DataField>RealizedGains</DataField>
      </Field>
      <Field Name="RealizedGainsFormat">
        <DataField>RealizedGainsFormat</DataField>
      </Field>
      <Field Name="RealizedLosses">
        <DataField>RealizedLosses</DataField>
      </Field>
      <Field Name="RealizedLossesFormat">
        <DataField>RealizedLossesFormat</DataField>
      </Field>
      <Field Name="EntryNo_BankAccountLedgerEntry">
        <DataField>EntryNo_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="FORMATPostingDate_BankAccountLedgerEntry">
        <DataField>FORMATPostingDate_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="Amount_BankAccountLedgerEntry">
        <DataField>Amount_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="Amount_BankAccountLedgerEntryFormat">
        <DataField>Amount_BankAccountLedgerEntryFormat</DataField>
      </Field>
      <Field Name="AmountLCY_BankAccountLedgerEntry">
        <DataField>AmountLCY_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="AmountLCY_BankAccountLedgerEntryFormat">
        <DataField>AmountLCY_BankAccountLedgerEntryFormat</DataField>
      </Field>
      <Field Name="AppliedAmount_BankAccountLedgerEntry">
        <DataField>AppliedAmount_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="AppliedAmount_BankAccountLedgerEntryFormat">
        <DataField>AppliedAmount_BankAccountLedgerEntryFormat</DataField>
      </Field>
      <Field Name="DifferenceAmount_BankAccountLedgerEntry">
        <DataField>DifferenceAmount_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="DifferenceAmount_BankAccountLedgerEntryFormat">
        <DataField>DifferenceAmount_BankAccountLedgerEntryFormat</DataField>
      </Field>
      <Field Name="AppliedToEntry_BankAccountLedgerEntry">
        <DataField>AppliedToEntry_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="ExRate2">
        <DataField>ExRate2</DataField>
      </Field>
      <Field Name="ExRate2Format">
        <DataField>ExRate2Format</DataField>
      </Field>
      <Field Name="Applied_BankAccountLedgerEntry">
        <DataField>Applied_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="PostedDifference_BankAccountLedgerEntry">
        <DataField>PostedDifference_BankAccountLedgerEntry</DataField>
      </Field>
      <Field Name="RealizedGains2">
        <DataField>RealizedGains2</DataField>
      </Field>
      <Field Name="RealizedGains2Format">
        <DataField>RealizedGains2Format</DataField>
      </Field>
      <Field Name="RealizedLosses2">
        <DataField>RealizedLosses2</DataField>
      </Field>
      <Field Name="RealizedLosses2Format">
        <DataField>RealizedLosses2Format</DataField>
      </Field>
    </Fields>
    <rd:DataSetInfo>
      <rd:DataSetName>DataSet</rd:DataSetName>
      <rd:SchemaPath>Report.xsd</rd:SchemaPath>
      <rd:TableName>Result</rd:TableName>
    </rd:DataSetInfo>
  </DataSet>
</DataSets>
<ReportSections>
  <ReportSection>
    <Body>
      <ReportItems>
        <Tablix Name="Table1">
          <TablixBody>
            <TablixColumns>
              <TablixColumn>
                <Width>0.70866in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.7874in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.7874in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.7874in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.7874in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.7874in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.70866in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.47244in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.47244in</Width>
              </TablixColumn>
              <TablixColumn>
                <Width>0.47244in</Width>
              </TablixColumn>
            </TablixColumns>
            <TablixRows>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Bank_Account__No__">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!No_BankAccount.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>2</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Bank_Account_Name">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!Name_BankAccount.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>6</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell />
                  <TablixCell />
                  <TablixCell />
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox15">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style />
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox16">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style />
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Bank_Account__Currency_Code_Caption">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!CurrencyCode_BankAccountCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>2</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Bank_Account__Currency_Code_">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!CurrencyCode_BankAccount.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox37">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox37</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox17">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox18">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox1">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox1</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox110">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox111">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox112">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Period_Caption">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!PeriodCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>2</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="FORMAT_EndDate_0_DateFormat_">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!FORMATEndDateReq.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox10">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox10</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox113">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox114">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox2">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox2</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox116">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox117">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox118">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.27778in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox21">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox21</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox22">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox22</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox23">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox23</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox24">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox24</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox25">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox25</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox26">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox26</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox3">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox3</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox28">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox28</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox29">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox29</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox30">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox30</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.27778in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Entry_No__Caption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!EntryNo_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="FORMAT_BankAccLedgEntryTemp__Posting_Date__0_DateFormat_Caption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!BankAccLedgEntryPostingDateCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp_AmountCaption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!Amount_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Amount__LCY__Caption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!AmountLCY_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Applied_Amount_Caption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!AppliedAmount_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Difference_Amount_Caption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!DifferenceAmount_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Applied_to_Entry_Caption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!AppliedToEntry_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Exchange_RateCaption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!ExchangeRateCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp_AppliedCaption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!Applied_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Posted_DifferenceCaption">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!PostedDifference_BankAccLedgEntryTempCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Bold</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Entry_No__">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!EntryNo_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="FORMAT_BankAccLedgEntryTemp__Posting_Date__0_DateFormat_">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!FORMATPostingDate_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp_Amount">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!Amount_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Amount_BankAccLedgEntryTempFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Amount__LCY__">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!AmountLCY_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!AmountLCY_BankAccLedgEntryTempFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Applied_Amount_">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!AppliedAmount_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!AppliedAmount_BankAccLedgEntryTempFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Difference_Amount_">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!DifferenceAmount_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!DifferenceAmount_BankAccLedgEntryTempFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Applied_to_Entry_">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Code.BlankZero(Fields!AppliedToEntry_BankAccLedgEntryTemp.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="ExRate">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!ExRate.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!ExRateFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp_Applied">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!Applied_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="BankAccLedgEntryTemp__Posted_Difference_">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!PostedDifference_BankAccLedgEntryTemp.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="EntryNo_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!EntryNo_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>EntryNo_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="PostingDate_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!FORMATPostingDate_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>PostingDate_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Amount_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!Amount_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Amount_BankAccountLedgerEntryFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Amount_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="AmountLCY_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!AmountLCY_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!AmountLCY_BankAccountLedgerEntryFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>AmountLCY_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="AppliedAmount_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!AppliedAmount_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!AppliedAmount_BankAccountLedgerEntryFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>AppliedAmount_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="DifferenceAmount_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!DifferenceAmount_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!DifferenceAmount_BankAccountLedgerEntryFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>DifferenceAmount_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="AppliedToEntry_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Code.BlankZero(Fields!AppliedToEntry_BankAccountLedgerEntry.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>AppliedToEntry_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="ExRate2">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!ExRate2.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!ExRate2Format.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Applied_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!Applied_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Applied_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="PostedDifference_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Fields!PostedDifference_BankAccountLedgerEntry.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>PostedDifference_BankAccountLedgerEntry</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox119">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox120">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="SumBankAccLedgEntryTemp_Amount">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Sum(Fields!Amount_BankAccLedgEntryTemp.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Balance_BankAccountFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="SumBankAccLedgEntryTemp__Amount__LCY__">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Sum(Fields!AmountLCY_BankAccLedgEntryTemp.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Balance_BankAccountFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox121">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="SumBankAccLedgEntryTemp__Difference_Amount_">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Sum(Fields!DifferenceAmount_BankAccLedgEntryTemp.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Balance_BankAccountFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox4">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox4</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox123">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox124">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox125">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox7">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox7</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox8">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox8</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="SumAmount_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Sum(Fields!Amount_BankAccountLedgerEntry.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Last(Fields!Amount_BankAccountLedgerEntryFormat.Value)</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="SumAmountLCY_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Sum(Fields!AmountLCY_BankAccountLedgerEntry.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Last(Fields!AmountLCY_BankAccountLedgerEntryFormat.Value)</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox11">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox11</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="SumDifferenceAmount_BankAccountLedgerEntry">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Sum(Fields!DifferenceAmount_BankAccountLedgerEntry.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Last(Fields!DifferenceAmount_BankAccountLedgerEntryFormat.Value)</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox13">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox13</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox14">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox14</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox19">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox19</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox20">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox20</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.27778in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Realized_GainsCaption">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!RealizedGainsCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>3</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox128">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="RealizedGains">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=iif(Fields!TestMode.Value = True, Last(Fields!RealizedGains.Value), 
                                 Last(Fields!RealizedGains2.Value))</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Balance_BankAccountFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox129">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox5">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox5</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox131">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox132">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox133">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.13889in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Realized_LossesCaption">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!RealizedLossesCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>3</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox136">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="RealizedLosses">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=iif(Fields!TestMode.Value = True, Last(Fields!RealizedLosses.Value), 
                                 Last(Fields!RealizedLosses2.Value))</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                  <Format>=Fields!Balance_BankAccountFormat.Value</Format>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox137">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Textbox6">
                        <CanGrow>true</CanGrow>
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <rd:DefaultName>Textbox6</rd:DefaultName>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox139">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox140">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox141">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                </TablixCells>
              </TablixRow>
              <TablixRow>
                <Height>0.41667in</Height>
                <TablixCells>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="CompanyInfo_GetAppVersion">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=First(Fields!GetAppVersion_CompanyInfo.Value)</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>5</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell />
                  <TablixCell />
                  <TablixCell />
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="TextBox146">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value />
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style />
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Middle</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                    </CellContents>
                  </TablixCell>
                  <TablixCell>
                    <CellContents>
                      <Textbox Name="Last_PageCaption">
                        <KeepTogether>true</KeepTogether>
                        <Paragraphs>
                          <Paragraph>
                            <TextRuns>
                              <TextRun>
                                <Value>=Parameters!LastPageCaption.Value</Value>
                                <Style>
                                  <FontFamily>Segoe UI</FontFamily>
                                  <FontSize>8pt</FontSize>
                                  <FontWeight>Normal</FontWeight>
                                </Style>
                              </TextRun>
                            </TextRuns>
                            <Style>
                              <TextAlign>Right</TextAlign>
                            </Style>
                          </Paragraph>
                        </Paragraphs>
                        <Style>
                          <VerticalAlign>Bottom</VerticalAlign>
                          <PaddingLeft>5pt</PaddingLeft>
                          <PaddingRight>5pt</PaddingRight>
                        </Style>
                      </Textbox>
                      <ColSpan>4</ColSpan>
                    </CellContents>
                  </TablixCell>
                  <TablixCell />
                  <TablixCell />
                  <TablixCell />
                </TablixCells>
              </TablixRow>
            </TablixRows>
          </TablixBody>
          <TablixColumnHierarchy>
            <TablixMembers>
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
              <TablixMember />
            </TablixMembers>
          </TablixColumnHierarchy>
          <TablixRowHierarchy>
            <TablixMembers>
              <TablixMember>
                <Group Name="Table1_Group">
                  <GroupExpressions>
                    <GroupExpression>=Fields!No_BankAccount.Value</GroupExpression>
                  </GroupExpressions>
                  <PageBreak>
                    <BreakLocation>Between</BreakLocation>
                  </PageBreak>
                </Group>
                <TablixMembers>
                  <TablixMember>
                    <KeepWithGroup>After</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <KeepWithGroup>After</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <KeepWithGroup>After</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <KeepWithGroup>After</KeepWithGroup>
                  </TablixMember>
                  <TablixMember>
                    <KeepWithGroup>After</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <Group Name="Table1_Details_Group">
                      <DataElementName>Detail</DataElementName>
                    </Group>
                    <TablixMembers>
                      <TablixMember>
                        <Visibility>
                          <Hidden>=iif(Fields!TestMode.Value, False, True)</Hidden>
                        </Visibility>
                      </TablixMember>
                      <TablixMember>
                        <Visibility>
                          <Hidden>=iif(Fields!TestMode.Value, True, False)</Hidden>
                        </Visibility>
                      </TablixMember>
                    </TablixMembers>
                    <DataElementName>Detail_Collection</DataElementName>
                    <DataElementOutput>Output</DataElementOutput>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <Visibility>
                      <Hidden>=iif(Fields!TestMode.Value, False, True)</Hidden>
                    </Visibility>
                    <KeepWithGroup>Before</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <Visibility>
                      <Hidden>=iif(Fields!TestMode.Value, True, False)</Hidden>
                    </Visibility>
                    <KeepWithGroup>Before</KeepWithGroup>
                  </TablixMember>
                  <TablixMember>
                    <KeepWithGroup>Before</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                  <TablixMember>
                    <KeepWithGroup>Before</KeepWithGroup>
                    <KeepTogether>true</KeepTogether>
                  </TablixMember>
                </TablixMembers>
              </TablixMember>
              <TablixMember>
                <KeepWithGroup>Before</KeepWithGroup>
                <KeepTogether>true</KeepTogether>
              </TablixMember>
            </TablixMembers>
          </TablixRowHierarchy>
          <DataSetName>DataSet_Result</DataSetName>
          <Height>5.99727cm</Height>
          <Width>17.19997cm</Width>
          <Style />
        </Tablix>
      </ReportItems>
      <Height>5.99727cm</Height>
      <Style />
    </Body>
    <Width>17.67937cm</Width>
    <Page>
      <PageHeader>
        <Height>50pt</Height>
        <PrintOnFirstPage>true</PrintOnFirstPage>
        <PrintOnLastPage>true</PrintOnLastPage>
        <ReportItems>
          <Textbox Name="ExecutionTimeTextBox">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Globals!ExecutionTime</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                      <FontWeight>Normal</FontWeight>
                      <Format>D</Format>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style>
                  <TextAlign>Right</TextAlign>
                </Style>
              </Paragraph>
            </Paragraphs>
            <Left>13.4cm</Left>
            <Height>10pt</Height>
            <Width>4.27937cm</Width>
            <Style>
              <VerticalAlign>Bottom</VerticalAlign>
              <PaddingLeft>5pt</PaddingLeft>
              <PaddingRight>5pt</PaddingRight>
            </Style>
          </Textbox>
          <Textbox Name="PageCaption1">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Parameters!PageNoCaption.Value &amp; " " &amp; Globals!PageNumber</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                      <FontWeight>Normal</FontWeight>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style>
                  <TextAlign>Right</TextAlign>
                </Style>
              </Paragraph>
            </Paragraphs>
            <Top>10pt</Top>
            <Left>13.4cm</Left>
            <Height>10pt</Height>
            <Width>4.27937cm</Width>
            <ZIndex>1</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
              <PaddingLeft>5pt</PaddingLeft>
              <PaddingRight>5pt</PaddingRight>
            </Style>
          </Textbox>
          <Textbox Name="UserIdTextBox">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=User!UserID</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                      <FontWeight>Normal</FontWeight>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style>
                  <TextAlign>Right</TextAlign>
                </Style>
              </Paragraph>
            </Paragraphs>
            <Top>20pt</Top>
            <Left>13.4cm</Left>
            <Height>10pt</Height>
            <Width>4.27937cm</Width>
            <ZIndex>2</ZIndex>
            <Style>
              <VerticalAlign>Top</VerticalAlign>
              <PaddingLeft>5pt</PaddingLeft>
              <PaddingRight>5pt</PaddingRight>
            </Style>
          </Textbox>
          <Textbox Name="CalcPostBankExchDiffCaption">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Parameters!CalcPostBankExchDiffCaption.Value</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>14pt</FontSize>
                      <FontWeight>Bold</FontWeight>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Height>20pt</Height>
            <Width>12.66395cm</Width>
            <ZIndex>3</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
              <PaddingLeft>5pt</PaddingLeft>
              <PaddingRight>5pt</PaddingRight>
            </Style>
          </Textbox>
          <Textbox Name="COMPANYNAME">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!COMPANYNAME.Value, "DataSet_Result")</Value>
                    <Style>
                      <FontStyle>Normal</FontStyle>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>20pt</Top>
            <Height>10pt</Height>
            <Width>7.5cm</Width>
            <ZIndex>4</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
              <PaddingLeft>5pt</PaddingLeft>
              <PaddingRight>5pt</PaddingRight>
            </Style>
          </Textbox>
        </ReportItems>
        <Style>
          <Border>
            <Style>None</Style>
          </Border>
        </Style>
      </PageHeader>
      <PageHeight>29.7cm</PageHeight>
      <PageWidth>21cm</PageWidth>
      <InteractiveHeight>29.7cm</InteractiveHeight>
      <InteractiveWidth>21cm</InteractiveWidth>
      <LeftMargin>2cm</LeftMargin>
      <RightMargin>1cm</RightMargin>
      <TopMargin>1cm</TopMargin>
      <BottomMargin>1cm</BottomMargin>
      <Style />
    </Page>
  </ReportSection>
</ReportSections>
<ReportParameters>
  <ReportParameter Name="CurrencyCode_BankAccountCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>CurrencyCode_BankAccountCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>CurrencyCode_BankAccountCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="EntryNo_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>EntryNo_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>EntryNo_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="Amount_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>Amount_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>Amount_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="AmountLCY_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>AmountLCY_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>AmountLCY_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="AppliedAmount_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>AppliedAmount_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>AppliedAmount_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="DifferenceAmount_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>DifferenceAmount_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>DifferenceAmount_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="AppliedToEntry_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>AppliedToEntry_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>AppliedToEntry_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="Applied_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>Applied_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>Applied_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="PostedDifference_BankAccLedgEntryTempCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>PostedDifference_BankAccLedgEntryTempCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>PostedDifference_BankAccLedgEntryTempCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="EntryNo_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>EntryNo_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>EntryNo_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="Amount_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>Amount_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>Amount_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="AmountLCY_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>AmountLCY_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>AmountLCY_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="AppliedAmount_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>AppliedAmount_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>AppliedAmount_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="DifferenceAmount_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>DifferenceAmount_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>DifferenceAmount_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="AppliedToEntry_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>AppliedToEntry_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>AppliedToEntry_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="Applied_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>Applied_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>Applied_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryAmountLCYCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryAmountLCYCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryAmountLCYCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryAppliedCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryAppliedCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryAppliedCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryAppliedAmountCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryAppliedAmountCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryAppliedAmountCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryAppliedToEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryAppliedToEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryAppliedToEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryAmountCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryAmountCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryAmountCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryDifferenceAmountCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryDifferenceAmountCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryDifferenceAmountCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryEntryNoCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryEntryNoCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryEntryNoCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="BankAccLedgEntryPostingDateCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>BankAccLedgEntryPostingDateCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>BankAccLedgEntryPostingDateCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="CalcPostBankExchDiffCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>CalcPostBankExchDiffCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>CalcPostBankExchDiffCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="PostedDifference_BankAccountLedgerEntryCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>PostedDifference_BankAccountLedgerEntryCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>PostedDifference_BankAccountLedgerEntryCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="ExchangeRateCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>ExchangeRateCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>ExchangeRateCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="LastPageCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>LastPageCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>LastPageCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="PageNoCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>PageNoCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>PageNoCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="PeriodCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>PeriodCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>PeriodCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="PostedDifferenceCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>PostedDifferenceCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>PostedDifferenceCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="RealizedGainsCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>RealizedGainsCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>RealizedGainsCaption</Prompt>
  </ReportParameter>
  <ReportParameter Name="RealizedLossesCaption">
    <DataType>String</DataType>
    <DefaultValue>
      <Values>
        <Value>RealizedLossesCaption</Value>
      </Values>
    </DefaultValue>
    <Prompt>RealizedLossesCaption</Prompt>
  </ReportParameter>
</ReportParameters>
<Code>Public Function BlankZero(ByVal Value As Decimal)
  if Value = 0 then
      Return ""
  end if
  Return Value
End Function

Public Function BlankPos(ByVal Value As Decimal)
  if Value &gt; 0 then
      Return ""
  end if
  Return Value
End Function

Public Function BlankZeroAndPos(ByVal Value As Decimal)
  if Value &gt;= 0 then
      Return ""
  end if
  Return Value
End Function

Public Function BlankNeg(ByVal Value As Decimal)
  if Value &lt; 0 then
      Return ""
  end if
  Return Value
End Function

Public Function BlankNegAndZero(ByVal Value As Decimal)
  if Value &lt;= 0 then
      Return ""
  end if
  Return Value
End Function
</Code>
<Language>=User!Language</Language>
<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
<rd:ReportUnitType>Cm</rd:ReportUnitType>
<rd:ReportID>6ed90dc7-dadd-4034-a0ad-041a9a107782</rd:ReportID>
</Report>
  END_OF_RDLDATA
}
}

*/
