// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// PageExtension TOR Customer Lookup (ID 50455) extends Record Customer Lookup.
/// </summary>
pageextension 50455 "TOR Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'VAT Registration No.';
                Editable = false;
            }
        }
    }

}