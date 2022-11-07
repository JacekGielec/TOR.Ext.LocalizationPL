// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho     creation

/// <summary>
/// PageExtension TOR Salespersons (ID 50461) extends Record Salespersons/Purchasers.
/// </summary>
pageextension 50461 "TOR Salespersons" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter(Name)
        {
            field("East / West"; Rec."East / West")
            {
                ApplicationArea = All;
                ToolTip = 'East / West';
            }
        }
    }
}