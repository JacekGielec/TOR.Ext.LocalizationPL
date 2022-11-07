// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			08.02.21		dho     creation

/// <summary>
/// PageExtension TOR Posted Whse. Receipt (ID 50462) extends Record Posted Whse. Receipt.
/// </summary>
pageextension 50462 "TOR Posted Whse. Receipt" extends "Posted Whse. Receipt"
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