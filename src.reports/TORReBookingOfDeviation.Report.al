report 50461 "TOR Re-Booking Of Deviation"
{
    //AdditionalSearchTerms = 'cost forwarding';
    ApplicationArea = Basic, Suite;
    Caption = 'Re-Booking Of Deviation';
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

                }
            }
        }



        trigger OnOpenPage()
        begin

        end;
    }

    trigger OnPreReport()
    begin
        //OnBeforePreReport(ItemNoFilter, ItemCategoryFilter, PostToGL);
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine.DeleteAll();

        //GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        ClearGLAccount();
        GetGLEntry();

        OnAfterPreReport;
    end;

    var
        //GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        GenJnlLine: Record "Gen. Journal Line";
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        JournalTemplate: Record "Gen. Journal Template";
        JournalBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        DocumentNo: Code[20];
        PostingSeries: Code[10];
        DateFilter: Text;
        DateFrom: Date;
        DateTo: Date;
        ReBooking: Record TORReBookingOfDepartCosts;


    local procedure ClearGLAccount()
    begin
        GLAccount.SetFilter("Date Filter", '%1..%2', DateFrom, DateTo);
    end;

    procedure GetGLEntry()
    var
        CostAmount: Decimal;
    begin
        if ReBooking.FindFirst() then
            repeat
                ReBooking.TestField("Deviation G/L Account No.");
                ReBooking.TestField("Prod. Cost G/L Account No.");
                GLAccount.Get(ReBooking."Prod. Cost G/L Account No.");
                GLAccount.CalcFields("Net Change");
                CostAmount := GLAccount."Net Change";
                if CostAmount <> 0 then begin
                    CreateJnlLine(ReBooking."Prod. Cost G/L Account No.", ReBooking."Deviation G/L Account No.", -costamount);
                end;
            until ReBooking.Next() = 0;
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
        GenJnlLine.Description := StrSubstNo('Przeks. odchylen. m-c %1', Format(DateTo, 0, '<Month,2>-<Year4>'));
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

