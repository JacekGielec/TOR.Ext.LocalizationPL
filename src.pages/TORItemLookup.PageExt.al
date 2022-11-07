// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			04.03.21		dho         creation

/// <summary>
/// PageExtension TOR Item Lookup (ID 50470) extends Record Item Lookup.
/// </summary>
pageextension 50470 "TOR Item Lookup" extends "Item Lookup"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number 2 of the item.';
                Editable = false;
            }
        }
    }
}