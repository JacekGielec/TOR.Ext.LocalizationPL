// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// PageExtension TOR Vendor Ledger Entries (ID 50459) extends Record Vendor Ledger Entries.
/// </summary>
pageextension 50459 "TOR Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Due Date")
        {
            field(OverdueDays; getOverdueDays(Rec))
            {
                ApplicationArea = All;
                ToolTip = 'Overdue Days';
                Caption = 'Overdue Days';
                Editable = false;
                StyleExpr = StyleTxt;
            }
        }
        addafter("External Document No.")
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
                ToolTip = 'Document Date';
                Caption = 'Document Date';
                Editable = false;
                StyleExpr = StyleTxt;
            }
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        modify(Description)
        {
            Editable = true;
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;

    /// <summary>
    /// getOverdueDays.
    /// </summary>
    /// <param name="VendorLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure getOverdueDays(var VendorLedgerEntry: Record "Vendor Ledger Entry"): Integer
    begin
        if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice then begin
            VendorLedgerEntry.CalcFields("Remaining Amount");
            if (WorkDate() > VendorLedgerEntry."Due Date") AND VendorLedgerEntry.Open then
                exit(WorkDate() - Rec."Due Date");
        end;
    end;

    var
        StyleTxt: Text;
}