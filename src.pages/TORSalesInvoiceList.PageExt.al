// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho     creation

/// <summary>
/// PageExtension TOR Sales Invoice List (ID 50460) extends Record Sales Invoice List.
/// </summary>
pageextension 50460 "TOR Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        addafter("No.")
        {
            field("TOR Prepayment Invoice"; Rec."TOR Prepayment Invoice")
            {
                ApplicationArea = all;
            }
            field("TOR Retail Sales"; Rec."TOR Retail Sales")
            {
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Amount Including VAT';
                Editable = false;
            }
            field("Total VAT"; getTotalVATAmount())
            {
                ApplicationArea = All;
                ToolTip = 'Total VAT Amount';
                Caption = 'Total VAT';
                Editable = false;
                AutoFormatExpression = Rec."Currency Code";
                AutoFormatType = 1;
            }
        }
    }

    local procedure getTotalVATAmount(): Decimal
    begin
        exit(Rec."Amount Including VAT" - Rec.Amount);
    end;
}