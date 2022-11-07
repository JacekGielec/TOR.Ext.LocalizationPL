// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			08.02.21		dho         creation

/// <summary>
/// PageExtension TOR Registered Whse. Picks (ID 50465) extends Record Registered Whse. Picks.
/// </summary>
pageextension 50465 "TOR Registered Whse. Picks" extends "Registered Whse. Picks"
{
    layout
    {
        addafter("Location Code")
        {
            field("Customer Code"; Rec.getCustomerCode())
            {
                ApplicationArea = All;
                ToolTip = 'Customer Code';
                Caption = 'Customer Code';
            }
            field("Customer Name"; Rec.getCustomerName())
            {
                ApplicationArea = All;
                ToolTip = 'Customer Name';
                Caption = 'Customer Name';
            }
        }
    }
}