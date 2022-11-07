// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			08.02.21		dho     creation

/// <summary>
/// PageExtension TOR Posted Whse. Receipt List (ID 50464) extends Record Posted Whse. Receipt List.
/// </summary>
pageextension 50464 "TOR Posted Whse. Receipt List" extends "Posted Whse. Receipt List"
{
    layout
    {
        addafter("Location Code")
        {
            field("Vendor No."; Rec.getVendorNo())
            {
                ApplicationArea = All;
                ToolTip = 'Vendor No.';
                Caption = 'Vendor No.';
            }
            field("Vendor Name"; Rec.getVendorName())
            {
                ApplicationArea = All;
                ToolTip = 'Vendor Name';
                Caption = 'Vendor Name';
            }
        }
    }
}