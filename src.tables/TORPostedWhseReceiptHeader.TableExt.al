// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			08.02.21		dho     creation

/// <summary>
/// TableExtension TOR Posted Whse Receipt Header (ID 50453) extends Record Posted Whse. Receipt Header.
/// </summary>
tableextension 50453 "TOR Posted Whse Receipt Header" extends "Posted Whse. Receipt Header"
{
    /// <summary>
    /// getVendorNo.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getVendorNo(): Code[20]
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PostedWhseReceiptLine.SetRange("No.", Rec."No.");
        if PostedWhseReceiptLine.FindFirst() then
            if PurchRcptHeader.Get(PostedWhseReceiptLine."Posted Source No.") then
                exit(PurchRcptHeader."Buy-from Vendor No.");
    end;

    /// <summary>
    /// getVendorName.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure getVendorName(): Text
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PostedWhseReceiptLine.SetRange("No.", Rec."No.");
        if PostedWhseReceiptLine.FindFirst() then
            if PurchRcptHeader.Get(PostedWhseReceiptLine."Posted Source No.") then
                exit(PurchRcptHeader."Buy-from Vendor Name");
    end;
}