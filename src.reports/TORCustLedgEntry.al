report 50465 TORCustLedgEntry
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORCustLedgEntry.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'TOR Cust. Ledger Entry';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(Header; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(CompanyName; CompanyDisplayName) { }
            column(PrintAmountInLCY; PrintAmountInLCY) { }
            column(TableCaptnCustFilter; Customer.TableCaption + ': ' + CustFilter) { }
            column(CustFilter; CustFilter) { }
            column(PrintDetails; PrintDetails) { }
            column(AgedAccReceivableCptn; AgedAccReceivableCptnLbl) { }
            column(CurrReportPageNoCptn; CurrReportPageNoCptnLbl) { }
            column(AllAmtinLCYCptn; AllAmtinLCYCptnLbl) { }
            column(AgedOverdueAmtCptn; AgedOverdueAmtCptnLbl) { }
            column(AmtLCYCptn; AmtLCYCptnLbl) { }
            column(RemAmtCptn; RemAmtCptnLbl) { }
            column(DueDateCptn; DueDateCptnLbl) { }
            column(DocNoCptn; DocNoCptnLbl) { }
            column(PostingDateCptn; PostingDateCptnLbl) { }
            column(OriginalAmtCptn; AmountCptnLbl) { }
            column(DebitAmountCptn; DebitAmountCptnLbl) { }
            column(CreditAmountCptn; CreditAmountCptnLbl) { }
            column(CurrencyCptn; CurrencyCptnLbl) { }
            column(TotalLCYCptn; TotalLCYCptnLbl) { }
            column(QtyDaysCptn; QtyDaysCptnLbl) { }
            column(CloseAtDateCptn; CloseAtDateCptnLbl) { }
            column(NewPagePercustomer; NewPagePercustomer) { }
            column(GrandTotalCLE5RemAmt; GrandTotalCustLedgEntry."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            dataitem(Customer; Customer)
            {
                RequestFilterFields = "No.", "Date Filter";
                column(PageGroupNo; PageGroupNo) { }
                column(CustomerPhoneNoCaption; FieldCaption("Phone No.")) { }
                column(CustomerContactCaption; FieldCaption(Contact)) { }
                column(CustomerBalance; Balance) { }
                column(CustomerOverdue; "Balance Due") { }

                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");

                    trigger OnAfterGetRecord()
                    var
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        InsertTemp("Cust. Ledger Entry");


                        CustLedgEntry.SetCurrentKey("Closed by Entry No.");
                        CustLedgEntry.SetRange("Closed by Entry No.", "Entry No.");
                        if CustLedgEntry.FindSet(false, false) then
                            repeat
                                IF CustLedgEntry."Closed at Date" <= EndingDate then
                                    InsertTemp2(CustLedgEntry, "Entry No.", -CustLedgEntry."Closed by Amount");
                            until CustLedgEntry.Next() = 0;

                        CustLedgEntry.Reset();
                        CustLedgEntry.SetRange("Entry No.", "Closed by Entry No.");
                        if CustLedgEntry.FindSet(false, false) then
                            repeat
                                IF "Closed at Date" <= EndingDate then
                                    InsertTemp2(CustLedgEntry, "Entry No.", "Closed by Amount");
                            until CustLedgEntry.Next() = 0;
                        //CurrReport.Skip();

                    end;

                    trigger OnPreDataItem()
                    begin
                        //SetFilter("Document No.", 'FS/21/07/0225');
                        SetFilter("Posting Date", Customer.GetFilter("Date Filter"));
                        //SetFilter("Date Filter", Customer.GetFilter("Date Filter"));
                        Customer.CopyFilter("Currency Filter", "Currency Code");
                        Customer.CopyFilter("Currency Filter", "Currency Code");
                        SetFilter("Document Type", '%1|%2', "Document Type"::"Credit Memo", "Document Type"::Invoice);
                    end;
                }
                dataitem(CurrencyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    //PrintOnlyIfDetail = true;
                    dataitem(TempCustLedgEntryLoop; "Integer")
                    {

                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                        //---zapisy ktorymi zostal zamkniety zapis nadrzedny
                        dataitem(TempCustLedgEntryLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(CLE2DocNo; TempDtldCustLedgEntry."Document No.") { }
                            column(CLE2PostingDate; Format(TempDtldCustLedgEntry."Posting Date")) { }
                            column(CLE2CurrrencyCode; GetCurrencyCode(TempDtldCustLedgEntry."Currency Code")) { }
                            column(CLE2DebitAmount; TempDtldCustLedgEntry."Debit Amount")
                            {
                                AutoFormatExpression = CurrencyCode;
                                AutoFormatType = 1;
                            }
                            column(CLE2CreditAmount; TempDtldCustLedgEntry."Credit Amount")
                            {
                                AutoFormatExpression = CurrencyCode;
                                AutoFormatType = 1;
                            }

                            column(CustLedgEntryNo; TempDtldCustLedgEntry."Cust. Ledger Entry No.") { }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not TempDtldCustLedgEntry.FindSet(false, false) then
                                        CurrReport.Break();
                                end else
                                    if TempDtldCustLedgEntry.Next() = 0 then
                                        CurrReport.Break();

                            end;

                            trigger OnPostDataItem()
                            begin
                            end;

                            trigger OnPreDataItem()
                            begin
                                TempDtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", TempCustLedgEntry."Entry No.");
                            end;
                        }


                        //+++

                        column(Name1_Cust; Customer.Name)
                        {
                            IncludeCaption = true;
                        }
                        column(No_Cust; Customer."No.")
                        {
                            IncludeCaption = true;
                        }
                        column(CustomerPhoneNo; Customer."Phone No.") { }
                        column(CustomerContactName; Customer.Contact) { }
                        column(CLERemAmtLCY; CustLedgEntryEndingDate."Remaining Amt. (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(CLERemAmt; CustLedgEntryEndingDate."Remaining Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(CLEAmtLCY; CustLedgEntryEndingDate."Amount (LCY)")
                        {
                            AutoFormatType = 1;
                        }
                        column(CLEDueDate; Format(CustLedgEntryEndingDate."Due Date")) { }
                        column(CLEDocNo; CustLedgEntryEndingDate."Document No.") { }
                        column(CLEPostingDate; Format(CustLedgEntryEndingDate."Posting Date")) { }
                        column(CLECloseDate; format(custledgentryendingdate."Closed at Date")) { }
                        column(RemAmt_CLEEndDate; CustLedgEntryEndingDate."Remaining Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(CLEAmount; CustLedgEntryEndingDate.Amount)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Name_Cust; StrSubstNo(Text005, Customer.Name)) { }
                        column(CLECurrrencyCode; GetCurrencyCode(CustLedgEntryEndingDate."Currency Code")) { }
                        column(CLEDebitAmount; CustLedgEntryEndingDate."Debit Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(CLECreditAmount; CustLedgEntryEndingDate."Credit Amount")
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(CLEQtyDays; CalcQtyDays(CustLedgEntryEndingDate)) { }
                        column(TotalCheck; CustFilterCheck) { }
                        column(DebitAmount; DebitAmount)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(CreditAmount; CreditAmount)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }



                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not TempCustLedgEntry.FindSet(false, false) then
                                    CurrReport.Break();
                            end else
                                if TempCustLedgEntry.Next() = 0 then
                                    CurrReport.Break();

                            CustLedgEntryEndingDate := TempCustLedgEntry;


                            CustLedgEntryEndingDate.CalcFields("Debit Amount", "Credit Amount", "Remaining Amount");
                            DebitAmount += CustLedgEntryEndingDate."Debit Amount";
                            CreditAmount += CustLedgEntryEndingDate."Credit Amount";
                        end;

                        trigger OnPostDataItem()
                        begin
                            if not PrintAmountInLCY then
                                UpdateCurrencyTotals;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not PrintAmountInLCY then begin
                                if (TempCurrency.Code = '') or (TempCurrency.Code = GLSetup."LCY Code") then
                                    TempCustLedgEntry.SetFilter("Currency Code", '%1|%2', GLSetup."LCY Code", '')
                                else
                                    TempCustLedgEntry.SetRange("Currency Code", TempCurrency.Code);
                            end;

                            PageGroupNo := NextPageGroupNo;
                            if NewPagePercustomer and (NumberOfCurrencies > 0) then
                                NextPageGroupNo := PageGroupNo + 1;

                            CustLedgEntryEndingDate.SetRange("Date Filter", 0D, EndingDate);

                        end;
                    }



                    trigger OnAfterGetRecord()
                    begin
                        Clear(TotalCustLedgEntry);

                        if Number = 1 then begin
                            if not TempCurrency.FindSet(false, false) then
                                CurrReport.Break();
                        end else
                            if TempCurrency.Next() = 0 then
                                CurrReport.Break();

                        if TempCurrency.Code <> '' then
                            CurrencyCode := TempCurrency.Code
                        else
                            CurrencyCode := GLSetup."LCY Code";

                        NumberOfCurrencies := NumberOfCurrencies + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        NumberOfCurrencies := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if NewPagePercustomer then
                        PageGroupNo += 1;
                    TempCurrency.Reset();
                    TempCurrency.DeleteAll();
                    TempCustLedgEntry.Reset();
                    TempCustLedgEntry.DeleteAll();
                    DebitAmount := 0;
                    CreditAmount := 0;
                end;
            }
            dataitem(CurrencyTotals; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(CurrNo; Number = 1)
                {
                }
                column(TempCurrCode; TempCurrency2.Code)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(CurrSpecificationCptn; CurrSpecificationCptnLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not TempCurrency2.FindSet(false, false) then
                            CurrReport.Break();
                    end else
                        if TempCurrency2.Next() = 0 then
                            CurrReport.Break();

                    TempCurrencyAmount.SetRange("Currency Code", TempCurrency2.Code);
                    if TempCurrencyAmount.FindSet(false, false) then
                        repeat
                        until TempCurrencyAmount.Next() = 0;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AmountsinLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                    }
                    field(perCustomer; NewPagePercustomer)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Customer';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
        end;
    }

    labels
    {
        BalanceCaption = 'Balance';
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);

        GLSetup.Get();

        EndingDate := Customer.GetRangeMax("Date Filter");
        //CustLedgEntryEndingDate.SetRange("Date Filter", 0D, EndingDate);

        PageGroupNo := 1;
        NextPageGroupNo := 1;
        CustFilterCheck := (CustFilter <> 'No.');

        CompanyDisplayName := COMPANYPROPERTY.DisplayName;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        CustLedgEntryEndingDate: Record "Cust. Ledger Entry";
        TotalCustLedgEntry: Record "Cust. Ledger Entry";
        GrandTotalCustLedgEntry: Record "Cust. Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedCustomerLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        CustFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        EntryNo: Integer;
        PrintDetails: Boolean;
        NewPagePercustomer: Boolean;
        CurrencyCode: Code[10];
        Text005: Label 'Total for %1';
        NumberOfCurrencies: Integer;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CustFilterCheck: Boolean;
        AgedAccReceivableCptnLbl: Label 'Zapisy nabywców';
        CurrReportPageNoCptnLbl: Label 'Page';
        AllAmtinLCYCptnLbl: Label 'All Amounts in LCY';
        AgedOverdueAmtCptnLbl: Label 'Zapisy księgi nabywcy';
        AmtLCYCptnLbl: Label 'Original Amount ';
        AmountCptnLbl: Label 'Amount';
        RemAmtCptnLbl: Label 'Rem. Amount';
        DebitAmountCptnLbl: Label 'Debit Amount';
        CreditAmountCptnLbl: Label 'Credit Amount';
        QtyDaysCptnLbl: Label 'Qty. Days';
        DueDateCptnLbl: Label 'Due Date';
        DocNoCptnLbl: Label 'Document No.';
        PostingDateCptnLbl: Label 'Posting Date';
        CurrencyCptnLbl: Label 'Currency Code';
        TotalLCYCptnLbl: Label 'Total (LCY)';
        CloseAtDateCptnLbl: Label 'Close at Date';
        CurrSpecificationCptnLbl: Label 'Currency Specification';
        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        CompanyDisplayName: Text;
        DebitAmount: Decimal;
        CreditAmount: Decimal;


    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        Currency: Record Currency;
    begin
        with TempCustLedgEntry do begin
            if Get(CustLedgEntry."Entry No.") then
                exit;
            TempCustLedgEntry := CustLedgEntry;
            Insert;
            if PrintAmountInLCY then begin
                Clear(TempCurrency);
                TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
                if TempCurrency.Insert() then;
                exit;
            end;

            if TempCurrency.Get("Currency Code") then
                exit;
            if TempCurrency.Get('') and ("Currency Code" = GLSetup."LCY Code") then
                exit;
            if TempCurrency.Get(GLSetup."LCY Code") and ("Currency Code" = '') then
                exit;
            if "Currency Code" <> '' then
                Currency.Get("Currency Code")
            else begin
                Clear(Currency);
                Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            end;
            TempCurrency := Currency;
            TempCurrency.Insert();

        end;
    end;

    local procedure InsertTemp2(var CustLedgEntry: Record "Cust. Ledger Entry"; entno: Integer; am: Decimal)
    begin
        entryno += 1;
        TempDtldCustLedgEntry.Init();
        TempDtldCustLedgEntry."Entry No." := entryno;
        TempDtldCustLedgEntry."Cust. Ledger Entry No." := entno;
        TempDtldCustLedgEntry."Posting Date" := CustLedgEntry."Posting Date";
        TempDtldCustLedgEntry."Document No." := CustLedgEntry."Document No.";
        TempDtldCustLedgEntry."Credit Amount" := am;

        TempDtldCustLedgEntry.Insert();

        CreditAmount += am;
    end;

    local procedure Pct(a: Decimal; b: Decimal): Text[30]
    begin
        if b <> 0 then
            exit(Format(Round(100 * a / b, 0.1), 0, '<Sign><Integer><Decimals,2>') + '%');
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.Insert() then;
        with TempCurrencyAmount do begin

            "Currency Code" := CurrencyCode;

        end;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewPagePercust: Boolean)
    begin
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        NewPagePercustomer := NewPagePercust;
    end;

    local procedure CalcQtyDays(cle: Record "Cust. Ledger Entry"): Integer
    var
        d: Date;
        i: Integer;
    begin
        if cle.Open then
            exit;
        if cle."Closed at Date" = 0D then
            exit;
        i := cle."Closed at Date" - cle."Due Date";
        if i < 0 then
            i := 0;
        exit(i);

    end;

    local procedure GetCurrencyCode(c: code[10]): Code[10];
    begin
        if c = '' then
            exit(GLSetup."LCY Code");
        exit(c);
    end;
}



