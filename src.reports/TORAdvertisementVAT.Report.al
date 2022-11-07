report 50466 "TOR Advertisement VAT"
{
    ApplicationArea = Basic, Suite;
    Caption = 'TOR Advertisement VAT';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            RequestFilterFields = "No.", "Date Filter";

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
                    field(CostGLAccountNoFilter; CostGLAccountNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost G/L Account No. Filter';
                        TableRelation = "G/L Account" where("No." = filter('406-1*'), "Account Type" = const(Posting));
                    }
                    field(VATGLAccountNoFilter; VATGLAccountNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'VAT G/L Account No. Filter';
                        TableRelation = "G/L Account" where("No." = filter('223*'), "Account Type" = const(Posting));
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
            CompInf.Get();
            VATGLAccountNoFilter := '223-7-1-23';
            CostGLAccountNoFilter := '406-1-03';
            GLAccountNoFilter := '408-*';
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        GLEntry2: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        d: Decimal;
    begin
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine.DeleteAll();

        GLAccountNoFilter := "G/L Account".GetFilter("No.");

        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccountNoFilter <> '' then
            GLAccount.SetFilter("No.", GLAccountNoFilter)
        else
            GLAccount.SetFilter("No.", '408-*');

        Buf.Reset();
        buf.DeleteAll();

        VATPostingSetup.SetRange("Advertisement VAT", true);
        VATPostingSetup.FindFirst();


        if GLAccount.FindSet(false, false) then
            repeat
                if (CopyStr(GLAccount."No.", 1, 1) <> '4') then
                    error('Działanie tylko dla kont grupy 4');

                if StrPos(CostGLAccountNoFilter, GLAccount."No.") <= 0 then
                    GetGLEntry(GLAccount."No.");
            until GLAccount.Next() = 0;

        buf.reset;
        if buf.FindFirst() then
            repeat
                VATEntry.SetRange("Document No.", buf."Document No.");
                if VATEntry.IsEmpty then begin
                    GLEntry2.SetRange("G/L Account No.", VATGLAccountNoFilter);
                    GLEntry2.SetRange("Document No.", buf."Document No.");
                    GLEntry2.SetRange(Description, buf.Description);
                    GLEntry2.SetRange("Posting Date", buf."Posting Date");
                    GLEntry2.CalcSums(Amount);
                    d := GLEntry2.Amount;
                    d := buf."VAT Amount" + d;

                    CreateJnlLine(buf, buf.Amount, d);
                end;
            until buf.Next() = 0;

        OnAfterPreReport;
    end;

    var
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";

        GLSetup: Record "General Ledger Setup";
        CompInf: Record "Company information";
        GenJnlLine: Record "Gen. Journal Line";
        VATPostingSetup: Record "VAT Posting Setup";
        CostGLAccountNoFilter: text[20];
        VATGLAccountNoFilter: Text[20];
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
        GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
        GLEntry.SetRange("G/L Account No.", AccNo);
        GLEntry.Setfilter("Posting Date", "G/L Account".GetFilter("Date Filter"));
        if DocumentNo <> '' then
            GLEntry.SetRange("Document No.", DocumentNo);

        if glentry.FindFirst() then
            repeat
                if strpos(GLEntry."Document No.", 'RW') > 0 then begin
                    GLEntry.CalcFields("Shortcut Dimension 3 Code");
                    if GLEntry."Shortcut Dimension 3 Code" = 'PO' then begin
                        buf.setrange("Posting Date", GLEntry."Posting Date");
                        buf.SetRange("Document No.", GLEntry."Document No.");
                        buf.setrange(Description, GLEntry.Description);
                        buf.setrange("Dimension Set ID", GLEntry."Dimension Set ID");
                        if not buf.FindFirst() then begin
                            buf."Entry No." := GLEntry."Entry No.";
                            buf."Document No." := GLEntry."Document No.";
                            buf."G/L Account No." := GLEntry."G/L Account No.";
                            buf.Description := GLEntry.Description;
                            Buf."Dimension Set ID" := GLEntry."Dimension Set ID";
                            buf."Posting Date" := GLEntry."Posting Date";
                            buf.Amount := GLEntry.Amount;
                            buf."VAT Amount" := round(buf.Amount * VATPostingSetup."VAT %" / 100);
                            buf.Insert();
                        end else begin
                            buf.Amount += GLEntry.Amount;
                            buf."VAT Amount" := round(buf.Amount * VATPostingSetup."VAT %" / 100);
                            buf.Modify();
                        end;
                    end;
                end;
            until glentry.Next() = 0;
    end;

    local procedure CreateJnlLine(var buf: Record "G/L Entry" temporary; BaseAmount: Decimal; d: Decimal)
    begin

        CreatejnlLine2(buf, d);
        CreatejnlLineVAT(buf, -BaseAmount, -d);
    end;

    local procedure CreateJnlLine2(var buf: Record "G/L Entry" temporary; d: Decimal)
    begin
        GenJnlLine.init;
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        lineno += 10;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Document No." := buf."Document No.";
        GenJnlLine.validate("Posting Date", buf."Posting Date");
        GenJnlLine.validate("Account No.", CostGLAccountNoFilter);
        GenJnlLine.Validate("Dimension Set ID", buf."Dimension Set ID");

        GenJnlLine.Description := buf.Description;
        GenJnlLine.Validate(amount, d);
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine.insert;
    end;

    local procedure CreateJnlLineVAT(var buf: Record "G/L Entry" temporary; BaseAmount: Decimal; d: Decimal)
    begin
        GenJnlLine.init;
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        lineno += 10;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Document No." := buf."Document No.";
        GenJnlLine.validate("Posting Date", buf."Posting Date");
        GenJnlLine.validate("Account No.", VATGLAccountNoFilter);
        GenJnlLine.Description := buf.Description;
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
        GenJnlLine."VAT Bus. Posting Group" := 'KRAJ';
        GenJnlLine.validate("VAT Prod. Posting Group", 'REK23P');
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';

        GenJnlLine."VAT Registration No." := CompInf."VAT Registration No.";
        GenJnlLine."ITI VAT Registration No." := CompInf."VAT Registration No.";
        GenJnlLine."ITI VAT Settlement Date" := buf."Posting Date";
        GenJnlLine."ITI Address" := CompInf.Address;
        GenJnlLine."ITI City" := CompInf.City;
        GenJnlLine."ITI Name" := CompInf.Name;
        GenJnlLine."ITI Doc. Receipt/Sales Date" := buf."Posting Date";
        GenJnlLine."ITI Post Code" := CompInf."Post Code";



        GenJnlLine.Validate(amount, d);
        GenJnlLine.validate("VAT Base Amount", BaseAmount);


        GenJnlLine.insert;
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

