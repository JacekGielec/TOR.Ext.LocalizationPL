// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			08.02.21		dho         creation

/// <summary>
/// PageExtension TOR Registered Pick (ID 50466) extends Record Registered Pick.
/// </summary>
pageextension 50466 "TOR Registered Pick" extends "Registered Pick"
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