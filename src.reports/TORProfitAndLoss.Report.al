report 50471 "TOR Profit & Loss"
{
    UsageCategory = Administration;
    ApplicationArea = Report;
    Caption = 'Profit & Loss';
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORProfitAndLoss.rdlc';
    dataset
    {
        DataItem("TOR Profit & Loss Line"; "TOR Profit & Loss Line")
        {
            DataItemTableView = SORTING("Batch Name", "Line No.");
            RequestFilterFields = "Batch Name";

            column(DocumentCaption; DocumentCaptionLbl) { }
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
            Column(BalanceCaption; FIELDCAPTION(Amount)) { }
            Column(CompPeriodAmountCaption; FIELDCAPTION("Comparison Period Amount")) { }
            Column(NewPage; "New Page") { }
            Column(Hide; Hide) { }
            Column(LineType; LineType) { }
            Column(DateFilter; DateFilter) { }
            Column(CompPeriodDateFilter; CompPeriodDateFilter) { }
            Column(Name; "Batch Name") { }
            Column(LineSymbol; "Line Symbol") { }
            Column(Description; LineDescription) { }
            Column(Amount; Amount) { }
            Column(CompPeriodAmount; "Comparison Period Amount") { }
            Column(PageGroupNo; PageGroupNo) { }



            trigger OnPreDataItem()
            BEGIN
                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                PageGroupNo := 1;
                NextPageGroupNo := 1;
            END;

            trigger OnAfterGetRecord()
            BEGIN
                IF (Amount < 0) AND ("Level No." > 1) THEN
                    LineDescription := "Description for Negative" + ' ' +
                      "Description for Negative 2"
                ELSE
                    LineDescription := Description + ' ' +
                      "Description 2";
                LineType := Type;
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

                    Field(DateFilter; DateFilter)
                    {
                        ApplicationArea = all;
                        trigger OnValidate()
                        BEGIN
                            IF TextManagement.MakeDateFilter(DateFilter) <> 0 THEN
                                ERROR(Text001, DateFilter);
                        END;
                    }

                    Field(CompPeriodDateFilter; CompPeriodDateFilter)
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
            "TOR Profit & Loss Line".SETFILTER("Batch Name", BatchName);
        IF "TOR Profit & Loss Line".GETFILTER("Batch Name") = '' THEN
            ERROR(Text002);
        IF "TOR Profit & Loss Line".FINDFIRST THEN
            ProfitLossMgt.CalculatePLS("TOR Profit & Loss Line", DateFilter, CompPeriodDateFilter)
    end;

    var
        Text001: label 'The filter %1 is not valid for Date Filter.';
        Text002: Label 'Name filter must not be empty.';
        DocumentCaptionLbl: Label 'Profit & Loss Statement';
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        TextManagement: Codeunit "TOR Text Management";
        ProfitLossMgt: Codeunit TORProfitSheetManagement;
        CompanyAddr: ARRAY[8] OF Text[50];
        PageCaptionLbl: Label 'Page';
        DateFilter: Text[30];
        CompPeriodDateFilter: Text[30];
        DateFilterLbl: Label 'Date Filter';
        CompPeriodDateFilterLbl: Label 'Comparison Period Date Filter';
        LineDescription: Text[100];
        BatchName: Code[20];
        LineType: Integer;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;

    PROCEDURE SetFilters(NewDateFilter: Text[30]; NewCompPeriodDateFilter: Text[30]; NewBatchName: Code[20]);
    BEGIN
        DateFilter := NewDateFilter;
        CompPeriodDateFilter := NewCompPeriodDateFilter;
        BatchName := NewBatchName;
    END;

}