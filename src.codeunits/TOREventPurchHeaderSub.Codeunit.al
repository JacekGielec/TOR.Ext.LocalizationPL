/// <summary>
/// Codeunit TOR Event Purch. Header Sub (ID 50453).
/// </summary>
codeunit 50453 "TOR Event Purch. Header Sub"
{
    var
        UpdateExchRateMsg: Label 'Do you want to update the exchange rate?';
        ConfirmChangeSalCrMemoCorrReasonMsg: Label 'When you change %1 field, all purchase credit memo lines will be deleted.\Are you sure you want to change %1?';
        ActionStoppedErr: Label 'Action stopped.';
    //EventSubscriberInstance = StaticAutomatic;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Document Date', false, false)]
    local procedure OnAfterValidateDocumentDate(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get();
        if PurchSetup."ITI Get Doc. Exch.R. for Date" = PurchSetup."ITI Get Doc. Exch.R. for Date"::"Document Date" then
            UpdatePurchHeaderCurrencyFactor(Rec, true);
    end;

    local procedure UpdatePurchHeaderCurrencyFactor(var PurchHeader: Record "Purchase Header"; HideValidationDialog: Boolean)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
        CurrencyFactor: Decimal;
        Confirmed: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        if PurchHeader."Currency Code" <> '' then begin
            PurchSetup.Get();
            case PurchSetup."ITI Get Doc. Exch.R. for Date" of
                PurchSetup."ITI Get Doc. Exch.R. for Date"::"Posting Date":
                    CurrencyDate := PurchHeader."Posting Date";
                PurchSetup."ITI Get Doc. Exch.R. for Date"::"Document Date":
                    CurrencyDate := PurchHeader."Document Date";
            end;
            if CurrencyDate = 0D then
                CurrencyDate := WorkDate();

            if PurchSetup."Exchange Rate One Day Before" then
                CurrencyDate -= 1;

            CurrencyFactor := CurrencyExchangeRate.ExchangeRate(CurrencyDate, PurchHeader."Currency Code");
            if PurchHeader."Currency Factor" <> CurrencyFactor then begin
                if HideValidationDialog then
                    Confirmed := true
                else
                    Confirmed := Confirm(UpdateExchRateMsg, false);
                if Confirmed then
                    PurchHeader.Validate("Currency Factor", CurrencyFactor)
            end;
        end;
    end;

    //OnAfterCheckBillToCust(Rec, xRec, Cust);
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCheckBuyFromVendor', '', false, false)]
    local procedure OnAfterCheckBillToCust(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    var
        GLSetup: Record "General Ledger Setup";

        ErrCurrencyCode: Label 'Local currency is not allowed!', Comment = '%1 = No.';
    begin
        GLSetup.Get();
        if Vendor."Currency Code" = GLSetup."LCY Code" then
            Error(ErrCurrencyCode);

        Vendor.TestField("Vendor Posting Group");
        Vendor.TestField("Gen. Bus. Posting Group");
        Vendor.TestField("VAT Bus. Posting Group");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnBeforeValidatePostingAndDocumentDate(var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        GLSetup: Record "General Ledger Setup";

        ErrCurrencyCode: Label 'Posting with local currency is not allowed!', Comment = '%1 = Document No.';
    begin
        GLSetup.Get();
        if PurchaseHeader."Currency Code" = GLSetup."LCY Code" then
            Error(ErrCurrencyCode);

        PurchaseHeader.TestField("Vendor Posting Group");
        PurchaseHeader.TestField("Gen. Bus. Posting Group");
        PurchaseHeader.TestField("VAT Bus. Posting Group");
    end;

    //OnBeforeRecreatePurchLinesHandler(Rec, xRec, ChangedFieldName, IsHandled);
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeRecreatePurchLinesHandler', '', false, false)]
    local procedure OnBeforeRecreatePurchLinesHandler(var PurchHeader: Record "Purchase Header"; xPurchHeader: Record "Purchase Header"; ChangedFieldName: Text[100]; var IsHandled: Boolean)
    begin
        if (ChangedFieldName = 'ITI VAT Settlement Date') or (ChangedFieldName = 'Data obowiązku VAT') then
            IsHandled := true;
    end;

}