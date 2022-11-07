report 50472 "TOR Balance Sheet"
{
    UsageCategory = Administration;
    ApplicationArea = Report;
    Caption = 'Balance Sheet';
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORBalanceSheet.rdlc';

    dataset
    {
        dataitem("TOR Balance Sheet Line"; "TOR Balance Sheet Line")
        {
            DataItemTableView = SORTING("Batch Name", "Assets/Liabilities", "Line No.");
            Column(DocumentCaption; DocumentCaptionLbl) { }
            Column(PageCaption; PageCaptionLbl) { }
            Column(CompanyName; COMPANYNAME) { }
            Column(TodayFormatted; FORMAT(TODAY, 0, 4)) { }
            Column(Time; TIME) { }
            Column(GetAppVersion_CompanyInfo; '') { }
            Column(CompanyAddr1; CompanyAddr[1]) { }
            Column(CompanyAddr2; CompanyAddr[2]) { }
            Column(CompanyAddr3; CompanyAddr[3]) { }
            Column(CompanyAddr4; CompanyAddr[4]) { }
            Column(CompanyAddr5; CompanyAddr[5]) { }
            Column(CompanyAddr6; CompanyAddr[6]) { }
            Column(DateFilterCaption; DateFilterLbl) { }
            Column(CompPeriodDateFilterCaption; CompPeriodDateFilterLbl) { }
            Column(BatchNameCaption; FIELDCAPTION("Batch Name")) { }
            Column(LineSymbolCaption; FIELDCAPTION("Line Symbol")) { }
            Column(DescriptionCaption; FIELDCAPTION(Description)) { }
            Column(BalanceCaption; FIELDCAPTION(Balance)) { }
            Column(ComparisonBalanceCaption; FIELDCAPTION("Comparison Balance")) { }
            Column(NewPage; "New Page") { }
            Column(Hide; Hide) { }
            Column(LineType; LineType) { }
            Column(AssetsLiabilities; "Assets/Liabilities") { }
            Column(DateFilter; DateFilter) { }
            Column(CompPeriodDateFilter; CompPeriodDateFilter) { }
            Column(Name; "Batch Name") { }
            Column(LineSymbol; "Line Symbol") { }
            Column(Description; LineDescription) { }
            Column(Balance; Balance) { }
            Column(ComparisonBalance; "Comparison Balance") { }
            Column(PageGroupNo; PageGroupNo) { }
            Column(TotalFor; TotalForLbl + STRSUBSTNO(' %1', "Assets/Liabilities")) { }
            Column(TotalAssets; TotalAssets) { }
            Column(TotalAssets2; TotalAssets2) { }
            Column(TotalLiabilities; TotalLiabilities) { }
            Column(TotalLiabilities2; TotalLiabilities2) { }
            Column(ShowAssets; ShowAssets) { }
            Column(ErrorText; STRSUBSTNO(ErrorText, TotalAssets - TotalLiabilities)) { }
            Column(ErrorText2; STRSUBSTNO(ErrorText2, TotalAssets2 - TotalLiabilities2)) { }

            trigger OnPreDataItem()
            BEGIN
                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                PageGroupNo := 1;
                NextPageGroupNo := 1;
            END;

            trigger OnAfterGetRecord()
            BEGIN
                IF (Balance < 0) AND ("Level No." > 1) THEN
                    LineDescription := "Description for Negative" + ' ' +
                      "Description for Negative 2"
                ELSE
                    LineDescription := Description + ' ' +
                      "Description 2";
                LineType := "TOR Balance Sheet Line".Type;

                // <-- NAVP7.10.01
                IF "TOR Balance Sheet Line".Type <> "TOR Balance Sheet Line".Type::Sum THEN BEGIN
                    IF "Assets/Liabilities" = "Assets/Liabilities"::Assets THEN BEGIN
                        TotalAssets := TotalAssets + Balance;
                        TotalAssets2 := TotalAssets2 + "Comparison Balance";
                        ShowAssets := TRUE;
                    END ELSE BEGIN
                        TotalLiabilities := TotalLiabilities + Balance;
                        TotalLiabilities2 := TotalLiabilities2 + "Comparison Balance";
                        ShowAssets := FALSE;
                    END;
                END;
                // --> NAVPL7.10.01

                PageGroupNo := NextPageGroupNo;
                IF "New Page" THEN
                    NextPageGroupNo := PageGroupNo + 1;

                //---jg20191015
                "Line Symbol" := DELCHR("Line Symbol", '=', ' ');
                //+++
            END;
        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Field("Date Filter"; DateFilter)
                    {
                        ApplicationArea = all;
                        trigger OnValidate()
                        BEGIN
                            IF TextManagement.MakeDateFilter(DateFilter) <> 0 THEN
                                ERROR(Text001, DateFilter);
                        END;
                    }
                    Field("Comparison Period Date Filter"; CompPeriodDateFilter)
                    {
                        ApplicationArea = all;
                        trigger OnValidate()
                        BEGIN
                            IF TextManagement.MakeDateFilter(CompPeriodDateFilter) <> 0 THEN
                                ERROR(Text001, CompPeriodDateFilter);
                        END;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        IF BatchName <> '' THEN
            "TOR Balance Sheet Line".SETFILTER("Batch Name", BatchName);
        IF "TOR Balance Sheet Line".GETFILTER("Batch Name") = '' THEN
            ERROR(Text002);
        IF "TOR Balance Sheet Line".FINDFIRST THEN
            BalanceSheetMgt.CalculateBalanceSheet("TOR Balance Sheet Line", DateFilter, CompPeriodDateFilter)
    end;

    var
        Text001: label 'The filter %1 is not valid for Date Filter.';
        Text002: label 'Name filter must not be empty.';
        DocumentCaptionLbl: label 'Balance Sheet';
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        TextManagement: Codeunit "TOR Text Management";
        BalanceSheetMgt: Codeunit TORBalanceSheetManagement;
        CompanyAddr: ARRAY[8] OF Text[50];
        PageCaptionLbl: Label 'Page';
        DateFilter: Text[30];
        CompPeriodDateFilter: Text[30];
        DateFilterLbl: Label 'Date Filter;PLK=Filtr daty';
        CompPeriodDateFilterLbl: Label 'Comparison Period Date Filter;PLK=Filtr daty okresu por¢wnawczego';
        LineDescription: Text[100];
        BatchName: Code[20];
        LineType: Enum "TOR Balance Type Line";
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        TotalAssets: Decimal;
        TotalAssets2: Decimal;
        TotalLiabilities: Decimal;
        TotalLiabilities2: Decimal;
        TotalForLbl: Label '"Total "';
        ShowAssets: Boolean;
        ErrorText: Label '"Error in Balance construction: Assets - Liabilities = %1"';
        ErrorText2: Label '"Error in Balance construction (comparative period): Assets - Liabilities = %1"';

    PROCEDURE SetFilters(NewDateFilter: Text[30]; NewCompPeriodDateFilter: Text[30]; NewBatchName: Code[20]);
    BEGIN
        DateFilter := NewDateFilter;
        CompPeriodDateFilter := NewCompPeriodDateFilter;
        BatchName := NewBatchName;
    END;

}