// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// PageExtension TOR Vendor Lookup (ID 50457) extends Record Vendor Lookup.
/// </summary>
pageextension 50457 "TOR Vendor Lookup" extends "Vendor Lookup"
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