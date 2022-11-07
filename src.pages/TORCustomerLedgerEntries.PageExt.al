// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			02.02.21		dho     creation
/// <summary>
/// PageExtension TOR Customer Ledger Entries (ID 50452) extends Record Customer Ledger Entries.
/// </summary>
pageextension 50452 "TOR Customer Ledger Entries" extends "Customer Ledger Entries"
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
        addafter("Salesperson Code")
        {
            field("Salesperson Name"; getSalespersonName(Rec))
            {
                ApplicationArea = All;
                ToolTip = 'Salesperson Name';
                Caption = 'Salesperson Name';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;

    /// <summary>
    /// getOverdueDays.
    /// </summary>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    /// <returns>Return value of type Text.</returns>
    procedure getOverdueDays(var CustLedgerEntry: Record "Cust. Ledger Entry"): Integer
    begin
        CustLedgerEntry.CalcFields("Remaining Amount");
        if (WorkDate() > CustLedgerEntry."Due Date") AND CustLedgerEntry.open then
            exit(WorkDate() - Rec."Due Date");
    end;

    /// <summary>
    /// getSalespersonName.
    /// </summary>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    /// <returns>Return value of type Text.</returns>
    procedure getSalespersonName(var CustLedgerEntry: Record "Cust. Ledger Entry"): Text
    var
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if Salesperson.Get(CustLedgerEntry."Salesperson Code") then
            exit(Salesperson.Name);
    end;

    var
        StyleTxt: Text;
}