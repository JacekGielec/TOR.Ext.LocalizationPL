/// <summary>
/// PageExtension TOR Purch Order (ID 50482) extends Record Purchase Order.
/// </summary>
pageextension 50482 "TOR Purch Order" extends "Purchase Order"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Currency Factor"; GetCurrencyFactor(Rec."Currency Factor"))
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 4;
                Caption = 'Exchange Rate';
            }
        }
    }
    local procedure GetCurrencyFactor(d: Decimal): Decimal
    begin
        if d = 0 then
            exit;

        exit(1 / d);
    end;
}
