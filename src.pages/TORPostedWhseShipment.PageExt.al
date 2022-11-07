// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			02.02.21		dho     creation

/// <summary>
/// PageExtension TOR Posted Whse. Shipment (ID 50454) extends Record Posted Whse. Shipment.
/// </summary>
pageextension 50454 "TOR Posted Whse. Shipment" extends "Posted Whse. Shipment"
{
    layout
    {
        addafter("Whse. Shipment No.")
        {
            field("Ship-to Code"; Rec.getCustomerCode())
            {
                ApplicationArea = All;
                ToolTip = 'Customer Code';
                Caption = 'Customer Code';
                Editable = false;
            }
            field("Ship-to Name"; Rec.getCustomerName())
            {
                ApplicationArea = All;
                ToolTip = 'Customer Name';
                Caption = 'Customer Name';
                Editable = false;
            }
        }
        addafter("Posting Date")
        {
            field("Salesperson Code"; Rec.getSalespersonCode())
            {
                ApplicationArea = All;
                ToolTip = 'Salesperson Code';
                Caption = 'Salesperson Code';
                Editable = FALSE;
            }
            field("Salesperson Name"; Rec.getSalespersonName())
            {
                ApplicationArea = All;
                ToolTip = 'Salesperson Name';
                Caption = 'Salesperson Name';
                Editable = FALSE;
            }
        }
    }
}