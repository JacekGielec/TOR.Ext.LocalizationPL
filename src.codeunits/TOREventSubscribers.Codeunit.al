// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			25.02.21		dho     Added Subscriber OnAfterSetupNewLine_DoNotSetDocumentType
// TG-TDAG00000-002         03.03.21        dho     Added Subscriber OnBeforeVATRegistrationValidation_CheckIfDuplicate
// TG-TDAG00000-003         04.03.21        dho     Added Subscriber OnValidateItemNoOnAfterGetItem_SetItemNo2
// TG-TDAG00000-004         11.03.21        dho     Added Subscriber OnFormatAddrOnAfterGetCountry_ClearName2 - Name 2 should not be printed on documents
// TG-TDAG00000-005         15.03.21        dho     Added Subscriber OnPostSalesLineOnAfterTestSalesLine_CheckLineAmount
// TG-TDAG00000-006         15.03.21        dho     Changed Error in Warning in OnPostSalesLineOnAfterTestSalesLine_CheckLineAmount -> Damian

/// <summary>
/// Codeunit TOR Event Subscribers (ID 50451).
/// </summary>
codeunit 50451 "TOR Event Subscribers"
{
    trigger OnRun()
    begin

    end;
    //Begin TG-TDAG00000-001/dho
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine_DoNotSetDocumentType(var GenJournalLine: Record "Gen. Journal Line"; GenJournalTemplate: Record "Gen. Journal Template"; GenJournalBatch: Record "Gen. Journal Batch"; LastGenJournalLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean)
    begin
        if GenJournalLine."Document Type" <> GenJournalLine."Document Type"::" " then
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::" ");
    end;
    //End TG-TDAG00000-001/dho
    //Begin TG-TDAG00000-002/dho
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeVATRegistrationValidation', '', false, false)]
    local procedure OnBeforeVATRegistrationValidation_CheckIfDuplicate(var Customer: Record Customer; IsHandled: Boolean)
    var
        CheckCustomer: Record Customer;
        ErrMsg: Label 'Customer with VAT Registration No. %1 already exists.', Comment = '%1 = VAT Registration No.', MaxLength = 999, Locked = false;
    begin
        CheckCustomer.SetRange("VAT Registration No.", Customer."VAT Registration No.");
        if not CheckCustomer.IsEmpty then
            Error(ErrMsg, Customer."VAT Registration No.");

    end;
    //End TG-TDAG00000-002/dho
    //Begin TG-TDAG00000-003/dho
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnValidateItemNoOnAfterGetItem', '', false, false)]
    local procedure OnValidateItemNoOnAfterGetItem_SetItemNo2(var ItemJournalLine: Record "Item Journal Line"; Item: Record Item)
    begin
        ItemJournalLine.Validate("TOR Item No. 2", Item."No. 2");
    end;
    //End TG-TDAG00000-003/dho
    //Begin TG-TDAG00000-004/dho
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnAfterFormatAddress', '', false, false)]
    local procedure OnAfterFormatAddress_ClearName2(var AddrArray: array[8] of Text[100]; Name: Text[100]; Name2: Text[100]; Contact: Text[100]; Addr: Text[100]; Addr2: Text[50]; City: Text[50]; PostCode: Code[20]; County: Text[50]; CountryCode: Code[10]; LanguageCode: Code[10])
    var
        ind: Integer;
    begin
        if StrLen(Name2) > 0 then begin
            ind := 1;
            repeat
                if AddrArray[ind] = Name2 then begin
                    Clear(AddrArray[ind]);
                    ind := 8;
                end;
                ind += 1;
            until ind = 9;
            CompressArray(AddrArray);
        end;
    end;
    //End TG-TDAG00000-004/dho
    //Begin TG-TDAG00000-005/dho
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterTestSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnAfterTestSalesLine_CheckLineAmount(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        ErrLbl: Label 'Document No. %1, Line No. %2: Line Amount is 0!', Comment = '%1 = Document No., %2 = Line No.', MaxLength = 999, Locked = false;
        WarningLbl: Label 'Document No. %1, Line No. %2: Line Amount is 0! Do you want to go on and post anyway?', Comment = '%1 = Document No., %2 = Line No.', MaxLength = 999, Locked = false;
    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] then
            if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Line Amount" <= 0) then
                //Begin TG-TDAG00000-006/dho
                if not Confirm(WarningLbl, false, SalesHeader."No.", SalesLine."Line No.") then
                    //Begin TG-TDAG00000-006/dho
                    Error(ErrLbl, SalesHeader."No.", SalesLine."Line No.");
    end;
    //End TG-TDAG00000-005/dho

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure OnBeforeVendLedgEntryModify(FromVendLedgEntry: Record "Vendor Ledger Entry"; var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Description := FromVendLedgEntry.Description;
    end;

    //OnAfterValidateReminderLevel(Rec, ReminderLevel);
    [EventSubscriber(ObjectType::Table, Database::"Reminder Header", 'OnAfterValidateReminderLevel', '', false, false)]
    local procedure OnAfterValidateReminderLevel(ReminderLevel: Record "Reminder Level"; var ReminderHeader: Record "Reminder Header")
    var
        Cont: Record Contact;
    begin
        if ReminderLevel."Responsible Person Code" = '' then
            exit;

        if not Cont.get(ReminderLevel."Responsible Person Code") then
            exit;

        ReminderHeader.validate("Responsible Person Code", ReminderLevel."Responsible Person Code");
    end;

    //OnBeforeTestNoSeries(Rec, IsHandled);
    [EventSubscriber(ObjectType::Table, Database::"Reminder Header", 'OnBeforeTestNoSeries', '', false, false)]
    local procedure OnBeforeTestNoSeries(var ReminderHeader: Record "Reminder Header"; var IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cont: Record Contact;
    begin
        SalesSetup.Get();
        if SalesSetup."Def. Rem. Resp. Person Code" = '' then
            exit;

        if not Cont.get(SalesSetup."Def. Rem. Resp. Person Code") then
            exit;

        ReminderHeader."Responsible Person Code" := SalesSetup."Def. Rem. Resp. Person Code";
        ReminderHeader."Responsible Person Name" := Cont.Name;
        ReminderHeader."Responsible Person Mail" := Cont."E-Mail";
        ReminderHeader."Resp. Person Mobile Phone No." := Cont."Mobile Phone No.";
        ReminderHeader."Responsible Person Phone No." := Cont."Phone No.";
    end;

    //OnAfterPostGenJnlLine(GenJnlLine5, SuppressCommit, GenJnlPostLine);

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJnlLine', '', false, false)]
    local procedure OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        TORGenJnlPostBatch: Codeunit "Gen.Jnl.-Post Batch Add. Func.";
    begin
        TORGenJnlPostBatch.PostAddPost(GenJournalLine, GenJnlPostLine);
    end;

    //OnAfterRunWithCheck(GenJnlLine);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterRunWithCheck', '', false, false)]
    local procedure OnAfterPostGenJnlLine2(var GenJnlLine: Record "Gen. Journal Line"; sender: Codeunit "Gen. Jnl.-Post Line")
    var
        TORGenJnlPostBatch: Codeunit "Gen.Jnl.-Post Batch Add. Func.";
    begin
        TORGenJnlPostBatch.PostAddPost(GenJnlLine, sender);
    end;

}