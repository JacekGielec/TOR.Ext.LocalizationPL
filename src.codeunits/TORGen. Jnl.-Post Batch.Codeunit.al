codeunit 50457 "Gen.Jnl.-Post Batch Add. Func."
{
    trigger OnRun()
    begin

    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        AddPostMandatoryErr: Label 'Additional posting is mandatory for account %1.\You have to add dimension value for dimension %2 %3.';


    procedure PostAddPost(var AddGenJnlLine: Record "Gen. Journal Line"; _GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GLSetup.Get();
        GenJnlPostLine := _GenJnlPostLine;
        //Message(AddGenJnlLine."Account No." + ' ' + AddGenJnlLine."Bal. Account No.");
        PostAddPost2(AddGenJnlLine);
        PostBalAddPost2(AddGenJnlLine);
        PostAddPost2_2(AddGenJnlLine);
        PostBalAddPost2_2(AddGenJnlLine);
    end;

    local procedure PostAddPost2(var AddGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        DimValue: Record "Dimension Value";
        AccNo: Code[20];
        IsHandled: Boolean;
        SuppressCommit: Boolean;
    begin
        if (AddGenJnlLine."Account Type" <> AddGenJnlLine."Account Type"::"G/L Account") then
            EXIT;

        if AddGenJnlLine."Posting Date" = ClosingDate(AddGenJnlLine."Posting Date") then
            exit;

        if GLAcc.get(AddGenJnlLine."Account No.") then
            if not glacc."Add. Post. Code Mandatory" then
                exit;


        IsHandled := false;

        OnBeforePostAdd(AddGenJnlLine, IsHandled);

        if IsHandled then
            exit;

        GLSetup.TestField("Bal. Account No. Add. Post");
        GLSetup.TestField("Dim. Cost Reclassification");
        //tutaj sprawdzic czy jest potrzeba dodatkowego ksiegowania sprawdzajac czy jest wymiar 5
        AccNo := GetAccount(AddGenJnlLine."Dimension Set ID");
        if AccNo = '' then
            Error(AddPostMandatoryErr, AddGenJnlLine."Account No.", GLSetup."Dim. Cost Reclassification", AddGenJnlLine."Document No.");

        GenJnlLine2.Init();
        GenJnlLine2.TransferFields(AddGenJnlLine);
        GenJnlLine2."Line No." := GenJnlLine2."Line No." + 10010;
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Account No.", accno);
        GenJnlLine2."Bal. Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Bal. Account No.", GLSetup."Bal. Account No. Add. Post");
        GenJnlLine2."Shortcut Dimension 1 Code" := AddGenJnlLine."Shortcut Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := AddGenJnlLine."Shortcut Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := AddGenJnlLine."Dimension Set ID";
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        GenJnlLine2."VAT Bus. Posting Group" := '';
        GenJnlLine2."Gen. Bus. Posting Group" := '';
        GenJnlLine2."Bal. VAT Bus. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Bus. Posting Group" := '';
        GenJnlLine2."Gen. Posting Type" := GenJnlLine2."Gen. Posting Type"::" ";
        GenJnlLine2."Bal. Gen. Posting Type" := GenJnlLine2."Bal. Gen. Posting Type"::" ";
        GenJnlLine2."Gen. Prod. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Prod. Posting Group" := '';
        GenJnlLine2."VAT Prod. Posting Group" := '';
        GenJnlLine2."Bal. VAT Prod. Posting Group" := '';
        if AddGenJnlLine."Currency Code" <> '' then begin
            GenJnlLine2.Validate("Currency Code", AddGenJnlLine."Currency Code");
            GenJnlLine2.Validate("Currency Factor", AddGenJnlLine."Currency Factor");
        end;
        PrepareGenJnlLineAddCurr(GenJnlLine2);
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        OnAfterPostAdd(AddGenJnlLine, SuppressCommit);
    end;

    local procedure PostBalAddPost2(var AddGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        DimValue: Record "Dimension Value";

        AccNo: Code[20];
        IsHandled: Boolean;
        SuppressCommit: Boolean;
    begin
        if AddGenJnlLine."Bal. Account No." = '' then
            exit;
        if (AddGenJnlLine."Bal. Account Type" <> AddGenJnlLine."Bal. Account Type"::"G/L Account") then
            EXIT;

        if GLAcc.get(AddGenJnlLine."Bal. Account No.") then
            if not glacc."Add. Post. Code Mandatory" then
                exit;


        IsHandled := false;

        OnBeforePostAddBal(AddGenJnlLine, IsHandled);

        if IsHandled then
            exit;

        GLSetup.TestField("Bal. Account No. Add. Post");
        GLSetup.TestField("Dim. Cost Reclassification");
        //tutaj sprawdzic czy jest potrzeba dodatkowego ksiegowania sprawdzajac czy jest wymiar 5
        AccNo := GetAccount(AddGenJnlLine."Dimension Set ID");
        if AccNo = '' then
            Error(AddPostMandatoryErr, AddGenJnlLine."Bal. Account No.", GLSetup."Dim. Cost Reclassification");


        GenJnlLine2.Init();
        GenJnlLine2.TransferFields(AddGenJnlLine);
        GenJnlLine2."Line No." := GenJnlLine2."Line No." + 10020;
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Account No.", accno);
        GenJnlLine2."Bal. Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Bal. Account No.", GLSetup."Bal. Account No. Add. Post");
        GenJnlLine2."VAT Bus. Posting Group" := '';
        GenJnlLine2."Gen. Bus. Posting Group" := '';
        GenJnlLine2."Bal. VAT Bus. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Bus. Posting Group" := '';
        GenJnlLine2."Gen. Posting Type" := GenJnlLine2."Gen. Posting Type"::" ";
        GenJnlLine2."Bal. Gen. Posting Type" := GenJnlLine2."Bal. Gen. Posting Type"::" ";
        GenJnlLine2."Gen. Prod. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Prod. Posting Group" := '';
        GenJnlLine2."VAT Prod. Posting Group" := '';
        GenJnlLine2."Bal. VAT Prod. Posting Group" := '';

        GenJnlLine2.Validate(Amount, -AddGenJnlLine.Amount);
        GenJnlLine2."Shortcut Dimension 1 Code" := AddGenJnlLine."Shortcut Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := AddGenJnlLine."Shortcut Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := AddGenJnlLine."Dimension Set ID";
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        if AddGenJnlLine."Currency Code" <> '' then begin
            GenJnlLine2.Validate("Currency Code", AddGenJnlLine."Currency Code");
            GenJnlLine2.Validate("Currency Factor", AddGenJnlLine."Currency Factor");
        end;

        PrepareGenJnlLineAddCurr(GenJnlLine2);
        GenJnlPostLine.RunWithCheck(GenJnlLine2);
        OnAfterPostAddBal(AddGenJnlLine, SuppressCommit);
    end;

    local procedure PostAddPost2_2(var AddGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        DimValue: Record "Dimension Value";
        AccNo: Code[20];
        AccNo2: Code[20];
        IsHandled: Boolean;
        SuppressCommit: Boolean;
    begin
        if (AddGenJnlLine."Account Type" <> AddGenJnlLine."Account Type"::"G/L Account") then
            EXIT;

        if GLAcc.get(AddGenJnlLine."Account No.") then
            if not glacc."Add. Post. Code Mandatory" then
                exit;


        IsHandled := false;

        OnBeforePostAdd2(AddGenJnlLine, IsHandled);

        if IsHandled then
            exit;

        GLSetup.TestField("Bal. Account No. Add. Post");
        GLSetup.TestField("Dim. Cost Reclassification");
        //tutaj sprawdzic czy jest potrzeba dodatkowego ksiegowania sprawdzajac czy jest wymiar 5
        AccNo2 := GetAccount(AddGenJnlLine."Dimension Set ID");
        AccNo := GetAccount2(AddGenJnlLine."Dimension Set ID");
        if AccNo = '' then
            exit;

        GenJnlLine2.Init();
        GenJnlLine2.TransferFields(AddGenJnlLine);
        GenJnlLine2."Line No." := GenJnlLine2."Line No." + 10010;
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Account No.", accno);
        GenJnlLine2."Bal. Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Bal. Account No.", accno2);
        GenJnlLine2."Shortcut Dimension 1 Code" := AddGenJnlLine."Shortcut Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := AddGenJnlLine."Shortcut Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := AddGenJnlLine."Dimension Set ID";
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        GenJnlLine2."VAT Bus. Posting Group" := '';
        GenJnlLine2."Gen. Bus. Posting Group" := '';
        GenJnlLine2."Bal. VAT Bus. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Bus. Posting Group" := '';
        GenJnlLine2."Gen. Posting Type" := GenJnlLine2."Gen. Posting Type"::" ";
        GenJnlLine2."Bal. Gen. Posting Type" := GenJnlLine2."Bal. Gen. Posting Type"::" ";
        GenJnlLine2."Gen. Prod. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Prod. Posting Group" := '';
        GenJnlLine2."VAT Prod. Posting Group" := '';
        GenJnlLine2."Bal. VAT Prod. Posting Group" := '';

        PrepareGenJnlLineAddCurr(GenJnlLine2);
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        OnAfterPostAdd2(AddGenJnlLine, SuppressCommit);
    end;

    local procedure PostBalAddPost2_2(var AddGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        DimValue: Record "Dimension Value";

        AccNo: Code[20];
        AccNo2: Code[20];
        IsHandled: Boolean;
        SuppressCommit: Boolean;
    begin
        if AddGenJnlLine."Bal. Account No." = '' then
            exit;
        if (AddGenJnlLine."Bal. Account Type" <> AddGenJnlLine."Bal. Account Type"::"G/L Account") then
            EXIT;

        if GLAcc.get(AddGenJnlLine."Bal. Account No.") then
            if not glacc."Add. Post. Code Mandatory" then
                exit;


        IsHandled := false;

        OnBeforePostAddBal2(AddGenJnlLine, IsHandled);

        if IsHandled then
            exit;

        GLSetup.TestField("Bal. Account No. Add. Post");
        GLSetup.TestField("Dim. Cost Reclassification");
        //tutaj sprawdzic czy jest potrzeba dodatkowego ksiegowania sprawdzajac czy jest wymiar 5
        AccNo2 := GetAccount(AddGenJnlLine."Dimension Set ID");
        AccNo := GetAccount2(AddGenJnlLine."Dimension Set ID");
        if AccNo = '' then
            exit;

        GenJnlLine2.Init();
        GenJnlLine2.TransferFields(AddGenJnlLine);
        GenJnlLine2."Line No." := GenJnlLine2."Line No." + 10020;
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Account No.", accno);
        GenJnlLine2."Bal. Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2.Validate("Bal. Account No.", AccNo2);
        GenJnlLine2."VAT Bus. Posting Group" := '';
        GenJnlLine2."Gen. Bus. Posting Group" := '';
        GenJnlLine2."Bal. VAT Bus. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Bus. Posting Group" := '';
        GenJnlLine2."Gen. Posting Type" := GenJnlLine2."Gen. Posting Type"::" ";
        GenJnlLine2."Bal. Gen. Posting Type" := GenJnlLine2."Bal. Gen. Posting Type"::" ";
        GenJnlLine2."Gen. Prod. Posting Group" := '';
        GenJnlLine2."Bal. Gen. Prod. Posting Group" := '';
        GenJnlLine2."VAT Prod. Posting Group" := '';
        GenJnlLine2."Bal. VAT Prod. Posting Group" := '';

        GenJnlLine2.Validate(Amount, -AddGenJnlLine.Amount);
        GenJnlLine2."Shortcut Dimension 1 Code" := AddGenJnlLine."Shortcut Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := AddGenJnlLine."Shortcut Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := AddGenJnlLine."Dimension Set ID";
        GenJnlLine2."Allow Zero-Amount Posting" := true;

        PrepareGenJnlLineAddCurr(GenJnlLine2);
        GenJnlPostLine.RunWithCheck(GenJnlLine2);
        OnAfterPostAddBal2(AddGenJnlLine, SuppressCommit);
    end;

    local procedure PrepareGenJnlLineAddCurr(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GLSetup."Additional Reporting Currency" <> '') and
           (GenJnlLine."Recurring Method" in
            [GenJnlLine."Recurring Method"::"B  Balance",
             GenJnlLine."Recurring Method"::"RB Reversing Balance"])
        then begin
            GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
            if (GenJnlLine.Amount = 0) and
               (GenJnlLine."Source Currency Amount" <> 0)
            then begin
                GenJnlLine."Additional-Currency Posting" :=
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                GenJnlLine.Amount := GenJnlLine."Source Currency Amount";
                GenJnlLine."Source Currency Amount" := 0;
            end;
        end;
    end;

    local procedure GetAccount(DimSetID: integer): code[20]
    var
        DimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetDimensionSet(DimSetEntry, DimSetID);
        if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 1 Code" then begin
            DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
            if DimSetEntry.FindSet() then
                exit(DimSetEntry."Dimension Value Code");
        end else
            if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 2 Code" then begin
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
                if DimSetEntry.FindSet() then
                    exit(DimSetEntry."Dimension Value Code");
            end else
                if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 3 Code" then begin
                    DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    if DimSetEntry.FindSet() then
                        exit(DimSetEntry."Dimension Value Code");
                end else
                    if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 4 Code" then begin
                        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                        if DimSetEntry.FindSet() then
                            exit(DimSetEntry."Dimension Value Code");
                    end else
                        if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 5 Code" then begin
                            DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                            if DimSetEntry.FindSet() then
                                exit(DimSetEntry."Dimension Value Code");
                        end else
                            if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 6 Code" then begin
                                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                                if DimSetEntry.FindSet() then
                                    exit(DimSetEntry."Dimension Value Code");
                            end else
                                if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 7 Code" then begin
                                    DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                                    if DimSetEntry.FindSet() then
                                        exit(DimSetEntry."Dimension Value Code");
                                end else
                                    if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 8 Code" then begin
                                        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                                        if DimSetEntry.FindSet() then
                                            exit(DimSetEntry."Dimension Value Code");
                                    end;
    end;

    local procedure GetAccount2(DimSetID: integer): code[20]
    var
        DimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetDimensionSet(DimSetEntry, DimSetID);
        if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 1 Code" then begin
            DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
            if DimSetEntry.FindSet() then
                exit(FindAccount2(GLSetup."Shortcut Dimension 1 Code", DimSetEntry."Dimension Value Code"));
        end else
            if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 2 Code" then begin
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
                if DimSetEntry.FindSet() then
                    exit(FindAccount2(GLSetup."Shortcut Dimension 2 Code", DimSetEntry."Dimension Value Code"));
            end else
                if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 3 Code" then begin
                    DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    if DimSetEntry.FindSet() then
                        exit(FindAccount2(GLSetup."Shortcut Dimension 3 Code", DimSetEntry."Dimension Value Code"));
                end else
                    if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 4 Code" then begin
                        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                        if DimSetEntry.FindSet() then
                            exit(FindAccount2(GLSetup."Shortcut Dimension 4 Code", DimSetEntry."Dimension Value Code"));
                    end else
                        if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 5 Code" then begin
                            DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                            if DimSetEntry.FindSet() then
                                exit(FindAccount2(GLSetup."Shortcut Dimension 5 Code", DimSetEntry."Dimension Value Code"));
                        end else
                            if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 6 Code" then begin
                                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                                if DimSetEntry.FindSet() then
                                    exit(FindAccount2(GLSetup."Shortcut Dimension 6 Code", DimSetEntry."Dimension Value Code"));
                            end else
                                if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 7 Code" then begin
                                    DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                                    if DimSetEntry.FindSet() then
                                        exit(FindAccount2(GLSetup."Shortcut Dimension 7 Code", DimSetEntry."Dimension Value Code"));
                                end else
                                    if GLSetup."Dim. Cost Reclassification" = GLSetup."Shortcut Dimension 8 Code" then begin
                                        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                                        if DimSetEntry.FindSet() then
                                            exit(FindAccount2(GLSetup."Shortcut Dimension 8 Code", DimSetEntry."Dimension Value Code"));
                                    end;
    end;

    local procedure FindAccount2(DimCode: code[20]; DimValueCode: Code[20]): code[20]
    var
        DimVal: Record "Dimension Value";
    begin
        DimVal.setrange("Dimension Code", DimCode);
        dimval.setrange(Code, DimValueCode);
        if DimVal.FindFirst() then
            if (DimVal.Immediately and (DimVal."G/L Account" <> '')) then
                exit(DimVal."G/L Account");

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostAdd(var AddGenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostAdd(GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostAddBal(var AddGenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostAddBal(GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostAdd2(var AddGenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostAdd2(GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostAddBal2(var AddGenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostAddBal2(GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean)
    begin
    end;
}