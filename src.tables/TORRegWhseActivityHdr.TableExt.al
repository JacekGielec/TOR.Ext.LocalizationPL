// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			08.02.21		dho         creation

/// <summary>
/// TableExtension TOR Reg. Whse. Activity Hdr. (ID 50454) extends Record Registered Whse. Activity Hdr..
/// </summary>
tableextension 50454 "TOR Reg. Whse. Activity Hdr." extends "Registered Whse. Activity Hdr."
{
    /// <summary>
    /// getCustomerNo.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getCustomerCode(): Code[20]
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        RegisteredWhseActivityLine.SetRange("No.", Rec."No.");
        if RegisteredWhseActivityLine.FindFirst() then begin
            PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", RegisteredWhseActivityLine."Whse. Document No.");
            if PostedWhseShipmentHeader.FindFirst() then
                exit(PostedWhseShipmentHeader.getCustomerCode());
        end;
    end;

    /// <summary>
    /// getCustomerName.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure getCustomerName(): Text
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        RegisteredWhseActivityLine.SetRange("No.", Rec."No.");
        if RegisteredWhseActivityLine.FindFirst() then begin
            PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", RegisteredWhseActivityLine."Whse. Document No.");
            if PostedWhseShipmentHeader.FindFirst() then
                exit(PostedWhseShipmentHeader.getCustomerName());
        end;
    end;
}