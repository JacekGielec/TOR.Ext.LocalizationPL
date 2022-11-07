report 50460 "TOR Re-Booking Of Depar. Costs"
{
    //AdditionalSearchTerms = 'cost forwarding';
    ApplicationArea = Basic, Suite;
    Caption = 'Re-booking Of Departmental Costs';
    //Permissions = TableData "Item Ledger Entry" = rimd,
    //              TableData "Item Application Entry" = r,
    //              TableData "Value Entry" = rimd,
    //              TableData "Avg. Cost Adjmt. Entry Point" = rimd;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
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
                    field(JournalTemplateName; JournalTemplateName)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Template Name';
                        TableRelation = "Gen. Journal Template";
                    }
                    field(JournalBatchName; JournalBatchName)
                    {
                        ApplicationArea = all;
                        Caption = 'Journal Batch Name';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            JB: Record "Gen. Journal Batch";
                            JBP: Page "General Journal Batches";
                        begin
                            JB.SetRange("Journal Template Name", JournalTemplateName);
                            jbp.SetTableView(jb);
                            jbp.LookupMode := true;

                            if jbp.RunModal() = Action::LookupOK then begin
                                JBP.GetRecord(JB);
                                JournalBatchName := JB.Name;
                            end;
                        end;
                    }

                    field(GLAccountNoFilter; GLAccountNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'G/L Account No. Filter';
                        TableRelation = "G/L Account" where("No." = filter('5*'), "Account Type" = const(Posting));
                    }
                    field("Date From"; DateFrom)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date From';
                    }
                    field("Date To"; DateTo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date To';
                    }
                    field("DocumentNoFilter"; "DocumentNoFilter")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                    }
                }
            }
        }



        trigger OnOpenPage()
        begin
            GLSetup.Get();
            glsetup.TestField("Department G/L Account Cost");

        end;
    }

    trigger OnPreReport()
    begin
        //OnBeforePreReport(ItemNoFilter, ItemCategoryFilter, PostToGL);
        GLSetup.TestField("Department G/L Account Cost");
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine.DeleteAll();

        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccountNoFilter <> '' then
            GLAccount.SetFilter("No.", GLAccountNoFilter)
        else
            GLAccount.SetFilter("No.", GLSetup."Department G/L Account Cost");

        CalcSales();
        if TotalSales <> 0 then begin
            if GLAccount.FindSet(false, false) then
                repeat
                    GetGLEntry(GLAccount."No.");
                //end;
                until GLAccount.Next() = 0;
        end;

        OnAfterPreReport;
    end;

    var
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        GenProdPostGroup: Record "Gen. Product Posting Group";
        GLSetup: Record "General Ledger Setup";
        GenJnlLine: Record "Gen. Journal Line";
        GLAccountNoFilter: Text[250];
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        JournalTemplate: Record "Gen. Journal Template";
        JournalBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        DocumentNoFilter: code[20];
        DocumentNo: Code[20];
        PostingSeries: Code[10];
        TotalSales: Decimal;
        DrySales: Decimal;
        WetSales: Decimal;
        GroutSales: Decimal;
        DryWsk: Decimal;
        WetWsk: Decimal;
        GroutWsk: Decimal;
        DateFilter: Text;
        DateFrom: Date;
        DateTo: Date;
        ReBooking: Record TORReBookingOfDepartCosts;

    local procedure CalcSales()
    var
        TotalWsk: Decimal;
    begin
        ClearGLAccount();
        GetAccount();
        if TotalSales = 0 then
            exit;
        WetWsk := WetSales / TotalSales;
        DryWsk := DrySales / TotalSales;
        GroutWsk := GroutSales / TotalSales;
        TotalWsk := WetWsk + DryWsk + GroutWsk;
        if TotalWsk <> 1 then begin
            if WetWsk <> 0 then
                WetWsk += 1 - TotalWsk
            else
                if DryWsk <> 0 then
                    DryWsk += 1 - TotalWsk
                else
                    if GroutWsk <> 0 then
                        GroutWsk += 1 - TotalWsk;
        end;
    end;

    local procedure ClearGLAccount()
    begin
        GLAccount.SetFilter("Date Filter", '%1..%2', DateFrom, DateTo);
    end;

    local procedure GetAccount()
    var
        ValueEntry: Record "Value Entry";
    begin
        GenProdPostGroup.SetRange("Production Type", GenProdPostGroup."Production Type"::Wet, GenProdPostGroup."Production Type"::Grout);
        if GenProdPostGroup.FindSet() then
            repeat
                ValueEntry.SetRange("Gen. Prod. Posting Group", GenProdPostGroup.Code);
                ValueEntry.SetRange("Posting Date", DateFrom, DateTo);
                ValueEntry.CalcSums("Sales Amount (Actual)");
                if GenProdPostGroup."Production Type" = GenProdPostGroup."Production Type"::Dry then begin
                    TotalSales += ValueEntry."Sales Amount (Actual)";
                    DrySales += ValueEntry."Sales Amount (Actual)";
                end;
                if GenProdPostGroup."Production Type" = GenProdPostGroup."Production Type"::Wet then begin
                    TotalSales += ValueEntry."Sales Amount (Actual)";
                    WetSales += ValueEntry."Sales Amount (Actual)";
                end;
                if GenProdPostGroup."Production Type" = GenProdPostGroup."Production Type"::Grout then begin
                    TotalSales += ValueEntry."Sales Amount (Actual)";
                    GroutSales += ValueEntry."Sales Amount (Actual)";
                end;
            until GenProdPostGroup.Next() = 0;
    end;

    procedure InitializeRequest(NewItemNoFilter: Text[250])
    begin
        GLAccountNoFilter := NewItemNoFilter;
    end;

    procedure GetGLEntry(AccNo: code[20])
    var
        DryAmount: Decimal;
        WetAmount: Decimal;
        GroutAmount: Decimal;
        CostAmount: Decimal;
        TotalCost: Decimal;
    begin
        GLAccount.Get(AccNo);
        GLAccount.CalcFields("Net Change");
        CostAmount := GLAccount."Net Change";
        if CostAmount = 0 then
            exit;
        DryAmount := Round(CostAmount * DryWsk);
        WetAmount := Round(CostAmount * WetWsk);
        GroutAmount := Round(CostAmount * GroutWsk);

        TotalCost := WetAmount + DryAmount + GroutAmount;

        if TotalCost <> CostAmount then begin
            if WetAmount <> 0 then
                WetAmount += CostAmount - TotalCost
            else
                if DryAmount <> 0 then
                    DryAmount += CostAmount - TotalCost
                else
                    if GroutAmount <> 0 then
                        GroutAmount += CostAmount - TotalCost;
        end;

        if GLAccount."Net Change" <> 0 then begin
            ReBooking.Get(ReBooking."Production Type"::Dry);
            CreateJnlLine(ReBooking."Department G/L Account No.", accno, DryAmount);
            ReBooking.Get(ReBooking."Production Type"::Wet);
            CreateJnlLine(ReBooking."Department G/L Account No.", accno, WetAmount);
            ReBooking.Get(ReBooking."Production Type"::Grout);
            CreateJnlLine(ReBooking."Department G/L Account No.", accno, GroutAmount);
        end;
        //        if d <> 0 then
        //            CreateJnlLine(buf, d);
        //    until buf.Next() = 0;

    end;

    local procedure CreateJnlLine(AccNo: code[20]; BalAccNo: code[20]; d: Decimal)
    begin
        if d = 0 then
            exit;

        if DocumentNo = '' then begin
            gettemplate();
            DocumentNo := getdocumentno();
        end;
        GenJnlLine.init;
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Posting No. Series" := getpostingseries();
        lineno += 10;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.insert(true);
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.validate("Posting Date", GLAccount.GetRangeMax("Date Filter"));
        GenJnlLine.validate("Account No.", AccNo);
        GenJnlLine.Description := StrSubstNo('Przeks. kosztów wydz. m-c %1', Format(DateTo, 0, '<Month,2>-<Year4>'));
        ;
        GenJnlLine."Bal. Account No." := BalAccNo;
        GenJnlLine.Validate(amount, d);
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine.Modify();

    end;

    local procedure GetTemplate()
    begin
        JournalTemplate.Get(JournalTemplateName);
        JournalBatch.get(JournalTemplateName, JournalBatchName);
    end;

    local procedure GetDocumentNo(): Code[20]
    var
        series: Codeunit NoSeriesManagement;
        s: Code[20];

    begin
        s := JournalTemplate."No. Series";
        if JournalBatch."No. Series" <> '' then
            s := JournalBatch."No. Series";
        exit(series.GetNextNo(s, DateTo, true));
    end;

    local procedure GetPostingSeries(): Code[20]
    var
        s: Code[20];

    begin
        s := JournalTemplate."Posting No. Series";
        if JournalBatch."Posting No. Series" <> '' then
            s := JournalBatch."No. Series";
        exit(s);
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPreReport()
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePreReport(ItemNoFilter: Text[250]; ItemCategoryFilter: Text[250]; PostToGL: Boolean)
    begin
    end;
}

