// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// TableExtension TOR Post. Whse. Shipmt. Header (ID 50450) extends Record Posted Whse. Shipment Header.
/// </summary>
tableextension 50450 "TOR Post. Whse. Shipmt. Header" extends "Posted Whse. Shipment Header"
{
    /// <summary>
    /// getSalespersonCode.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getSalespersonCode(): Code[20]
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        PostedWhseShipmentLine.SetRange("No.", Rec."No.");
        if PostedWhseShipmentLine.FindFirst() then
            if SalesShipmentHeader.Get(PostedWhseShipmentLine."Posted Source No.") then
                exit(SalesShipmentHeader."Salesperson Code");
    end;

    /// <summary>
    /// getSalespersonName.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure getSalespersonName(): Text
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        Salesperson: Record "Salesperson/Purchaser";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        PostedWhseShipmentLine.SetRange("No.", Rec."No.");
        if PostedWhseShipmentLine.FindFirst() then
            if SalesShipmentHeader.Get(PostedWhseShipmentLine."Posted Source No.") AND (SalesShipmentHeader."Salesperson Code" <> '')
            AND Salesperson.Get(SalesShipmentHeader."Salesperson Code") then
                exit(Salesperson.Name);
    end;

    /// <summary>
    /// getShipToCode.
    /// </summary>
    /// <returns>Return value of type Code[10].</returns>
    procedure getCustomerCode(): Code[20]
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        PostedWhseShipmentLine.SetRange("No.", Rec."No.");
        if PostedWhseShipmentLine.FindFirst() and SalesShipmentHeader.Get(PostedWhseShipmentLine."Posted Source No.") then
            if SalesShipmentHeader."Ship-to Code" <> '' then
                exit(SalesShipmentHeader."Ship-to Code")
            else
                exit(SalesShipmentHeader."Sell-to Customer No.");
    end;

    /// <summary>
    /// getShipToName.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure getCustomerName(): Text
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        PostedWhseShipmentLine.SetRange("No.", Rec."No.");
        if PostedWhseShipmentLine.FindFirst() AND SalesShipmentHeader.Get(PostedWhseShipmentLine."Posted Source No.") then
            if SalesShipmentHeader."Ship-to Code" <> '' then
                exit(SalesShipmentHeader."Ship-to Name")
            else
                exit(SalesShipmentHeader."Sell-to Customer Name")
    end;

}