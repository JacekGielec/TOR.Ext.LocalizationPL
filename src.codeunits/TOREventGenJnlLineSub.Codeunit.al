/// <summary>
/// Codeunit TOR Event Gen. Jnl. Line Sub (ID 50454).
/// </summary>
codeunit 50454 "TOR Event Gen. Jnl. Line Sub"
{
    var
        UpdateExchRateMsg: Label 'Do you want to update the exchange rate?';
        ConfirmChangeSalCrMemoCorrReasonMsg: Label 'When you change %1 field, all purchase credit memo lines will be deleted.\Are you sure you want to change %1?';
        ActionStoppedErr: Label 'Action stopped.';
    //EventSubscriberInstance = StaticAutomatic;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure OnAfterValidatePostingDate(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        UpdateCurrencyFactor(Rec, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Currency Code', false, false)]
    local procedure OnAfterValidateCurrencyCode(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        UpdateCurrencyFactor(Rec, true);
    end;


    local procedure UpdateCurrencyFactor(var GenJnlLine: Record "Gen. Journal Line"; HideValidationDialog: Boolean)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
        CurrencyFactor: Decimal;
        Confirmed: Boolean;
        GLSetup: Record "General Ledger Setup";
    begin
        if GenJnlLine."Currency Code" <> '' then begin
            GLSetup.Get();

            CurrencyDate := GenJnlLine."Posting Date";
            if CurrencyDate = 0D then
                CurrencyDate := WorkDate();

            if GLSetup."Exchange Rate One Day Before" then
                CurrencyDate -= 1;

            CurrencyFactor := CurrencyExchangeRate.ExchangeRate(CurrencyDate, GenJnlLine."Currency Code");
            if GenJnlLine."Currency Factor" <> CurrencyFactor then begin
                if HideValidationDialog then
                    Confirmed := true
                else
                    Confirmed := Confirm(UpdateExchRateMsg, false);
                if Confirmed then
                    GenJnlLine.Validate("Currency Factor", CurrencyFactor)
            end;
        end;
    end;
}