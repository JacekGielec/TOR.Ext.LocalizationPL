report 50459 "TOR Check Additional Post"
{
    //AdditionalSearchTerms = 'cost forwarding';
    ApplicationArea = Basic, Suite;
    Caption = 'Check Additional Post';
    //Permissions = TableData "Item Ledger Entry" = rimd,
    //              TableData "Item Application Entry" = r,
    //              TableData "Value Entry" = rimd,
    //              TableData "Avg. Cost Adjmt. Entry Point" = rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

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
                        Caption = 'Journal Template Name';
                        ApplicationArea = All;
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
                        TableRelation = "G/L Account" where("No." = filter('4*'), "Account Type" = const(Posting));
                    }
                    field(DateFilter; GLAccount."Date Filter")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date Filter';
                    }
                    field("DocumentNo"; "DocumentNo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            GLSetup.Get();
            glsetup.TestField("Bal. Account No. Add. Post");
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        GLEntry2: Record "G/L Entry";
        d: Decimal;
    begin
        //OnBeforePreReport(ItemNoFilter, ItemCategoryFilter, PostToGL);
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine.DeleteAll();

        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccountNoFilter <> '' then
            GLAccount.SetFilter("No.", GLAccountNoFilter)
        else
            GLAccount.SetFilter("No.", '4*');

        Buf.Reset();
        buf.DeleteAll();

        if GLAccount.FindSet(false, false) then
            repeat
                if CopyStr(GLAccount."No.", 1, 1) <> '4' then
                    error('Działanie tylko dla kont grupy 4');
                //if GLAccount."No." <> glsetup."Bal. Account No. Add. Post" then begin
                GetGLEntry(GLAccount."No.");
            //end;
            until GLAccount.Next() = 0;



        buf.reset;
        if buf.FindFirst() then
            repeat
                buf.CalcFields("Shortcut Dimension 5 Code");
                GLEntry2.SetRange("G/L Account No.", buf."Shortcut Dimension 5 Code");
                GLEntry2.SetRange("Bal. Account No.", GLSetup."Bal. Account No. Add. Post");
                GLEntry2.SetRange("Document No.", buf."Document No.");
                // GLEntry.setrange("Global Dimension 1 Code", Buf."Global Dimension 1 Code");
                // GLEntry.setrange("Global Dimension 2 Code", Buf."Global Dimension 2 Code");
                // GLEntry.setrange("Shortcut Dimension 3 Code", Buf."Shortcut Dimension 3 Code");
                // GLEntry.setrange("Shortcut Dimension 4 Code", Buf."Shortcut Dimension 4 Code");
                // GLEntry.setrange("Shortcut Dimension 5 Code", Buf."Shortcut Dimension 5 Code");
                // GLEntry.setrange("Shortcut Dimension 6 Code", Buf."Shortcut Dimension 6 Code");
                // GLEntry.setrange("Shortcut Dimension 7 Code", Buf."Shortcut Dimension 7 Code");
                // GLEntry.setrange("Shortcut Dimension 8 Code", Buf."Shortcut Dimension 8 Code");
                GLEntry2.SetRange(Description, buf.Description);
                GLEntry2.SetRange("Posting Date", buf."Posting Date");
                GLEntry2.SetRange("Dimension Set ID", buf."Dimension Set ID");
                GLEntry2.CalcSums(Amount);
                d := GLEntry2.Amount;
                d := buf.Amount - d;
                if d <> 0 then
                    CreateJnlLine(buf, d);
            until buf.Next() = 0;

        OnAfterPreReport;
    end;

    var
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";

        GLSetup: Record "General Ledger Setup";
        GenJnlLine: Record "Gen. Journal Line";
        GLAccountNoFilter: Text[250];
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        LineNo: Integer;
        DocumentNo: code[20];
        Buf: Record "G/L Entry" temporary;


    procedure InitializeRequest(NewItemNoFilter: Text[250])
    begin
        GLAccountNoFilter := NewItemNoFilter;
    end;

    procedure GetGLEntry(AccNo: code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        if AccNo = GLSetup."Bal. Account No. Add. Post" then
            exit;
        GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
        GLEntry.SetRange("G/L Account No.", AccNo);
        GLEntry.Setfilter("Posting Date", GLAccount.GetFilter("Date Filter"));
        if DocumentNo <> '' then
            GLEntry.SetRange("Document No.", DocumentNo);

        if glentry.FindFirst() then
            repeat
                glentry.CalcFields("Shortcut Dimension 3 Code",
                "Shortcut Dimension 4 Code",
                "Shortcut Dimension 5 Code",
                "Shortcut Dimension 6 Code",
                "Shortcut Dimension 7 Code",
                "Shortcut Dimension 8 Code");
                if GLEntry."Shortcut Dimension 5 Code" <> '' then begin
                    //buf.SetRange("Document No.", GLEntry."Document No.");
                    //buf.SetRange("Global Dimension 1 Code", GLEntry."Global Dimension 1 Code");
                    //buf.SetRange("Global Dimension 2 Code", GLEntry."Global Dimension 1 Code");
                    //buf.SetRange("Shortcut Dimension 3 Code", GLEntry."Shortcut Dimension 3 Code");
                    //buf.SetRange("Shortcut Dimension 4 Code", GLEntry."Shortcut Dimension 4 Code");
                    //buf.SetRange("Shortcut Dimension 5 Code", GLEntry."Shortcut Dimension 5 Code");
                    //buf.SetRange("Shortcut Dimension 6 Code", GLEntry."Shortcut Dimension 6 Code");
                    //buf.SetRange("Shortcut Dimension 7 Code", GLEntry."Shortcut Dimension 7 Code");
                    //buf.SetRange("Shortcut Dimension 8 Code", GLEntry."Shortcut Dimension 8 Code");
                    //buf.setrange(Description, GLEntry.Description);
                    buf.setrange("Posting Date", GLEntry."Posting Date");
                    buf.setrange("Dimension Set ID", GLEntry."Dimension Set ID");
                    buf.SetRange("Document No.", GLEntry."Document No.");
                    if not buf.FindFirst() then begin
                        buf."Entry No." := GLEntry."Entry No.";
                        buf."Document No." := GLEntry."Document No.";
                        buf."G/L Account No." := GLEntry."Shortcut Dimension 5 Code";
                        //buf."Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                        //buf."Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                        //buf."Shortcut Dimension 3 Code" := GLEntry."Shortcut Dimension 3 Code";
                        //buf."Shortcut Dimension 4 Code" := GLEntry."Shortcut Dimension 4 Code";
                        //buf."Shortcut Dimension 5 Code" := GLEntry."Shortcut Dimension 5 Code";
                        //buf."Shortcut Dimension 6 Code" := GLEntry."Shortcut Dimension 6 Code";
                        //buf."Shortcut Dimension 7 Code" := GLEntry."Shortcut Dimension 7 Code";
                        //buf."Shortcut Dimension 8 Code" := GLEntry."Shortcut Dimension 8 Code";
                        buf.Description := GLEntry.Description;
                        buf."Posting Date" := GLEntry."Posting Date";
                        buf."Dimension Set ID" := GLEntry."Dimension Set ID";
                        buf.Amount := GLEntry.Amount;
                        buf.Insert();
                    end else begin
                        buf.Amount += GLEntry.Amount;
                        buf.Modify();
                    end;
                end;
            until glentry.Next() = 0;


    end;

    local procedure CreateJnlLine(var buf: Record "G/L Entry" temporary; d: Decimal)
    var
        AccNo: code[20];
    begin
        buf.CalcFields("Shortcut Dimension 5 Code");
        CreatejnlLine2(buf, d, buf."Shortcut Dimension 5 Code", GLSetup."Bal. Account No. Add. Post");
        accno := FindAcc(buf);
        if AccNo <> '' then
            CreatejnlLine2(buf, d, AccNo, buf."Shortcut Dimension 5 Code");
    end;

    local procedure CreateJnlLine2(var buf: Record "G/L Entry" temporary; d: Decimal; AccNo: code[20]; BalAccNo: code[20])
    begin
        GenJnlLine.init;
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        lineno += 10;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Document No." := buf."Document No.";
        GenJnlLine.validate("Posting Date", buf."Posting Date");
        GenJnlLine.validate("Account No.", AccNo);
        GenJnlLine.Description := buf.Description;
        GenJnlLine."Bal. Account No." := BalAccNo;
        GenJnlLine.Validate(amount, d);
        GenJnlLine.Validate("Dimension Set ID", buf."Dimension Set ID");
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine.insert;
    end;

    local procedure FindAcc(var buf: Record "G/L Entry" temporary): Code[20]
    var
        DimVal: Record "Dimension Value";
    begin
        if DimVal.Get(GLSetup."Dim. Cost Reclassification", buf."Shortcut Dimension 5 Code") then
            if DimVal.Immediately then
                exit(DimVal."G/L Account");
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

