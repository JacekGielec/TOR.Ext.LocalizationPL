// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// PageExtension TOR Vendor List (ID 50458) extends Record Vendor List.
/// </summary>
pageextension 50458 "TOR Vendor List" extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'VAT Registration No.';
                Editable = false;
            }
        }
        addbefore("Balance (LCY)")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
                ToolTip = 'Balance';
                Editable = false;
            }
        }
        addbefore("Balance Due (LCY)")
        {
            field("Balance Due"; Rec."Balance Due")
            {
                ApplicationArea = all;
                ToolTip = 'Balance Due';
                Editable = false;
            }
        }
        addbefore("Payments (LCY)")
        {
            field(Payments; Rec.Payments)
            {
                ApplicationArea = all;
                ToolTip = 'Payments';
                Editable = false;
            }
        }
        addafter("Payments (LCY)")
        {
            field("Open Debit"; GetOpenDebit())
            {
                ApplicationArea = all;
                Caption = 'Open Debit';
                Editable = false;
                trigger OnAssistEdit()
                var
                    VendLedEntry: Record "Vendor Ledger Entry";
                    VendLedEntries: Page "Vendor Ledger Entries";
                begin
                    clear(VendLedEntries);
                    VendLedEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedEntry.SetRange("Vendor No.", Rec."No.");
                    //VendLedEntry.SetRange(Positive, true);
                    VendLedEntry.SetRange(Open, true);
                    VendLedEntries.LookupMode := true;
                    VendLedEntries.SetTableView(VendLedEntry);
                    VendLedEntries.RunModal();
                end;
            }
        }
        addafter("Open Debit")
        {
            field("Open Credit"; GetOpenCredit())
            {
                ApplicationArea = all;
                Caption = 'Open Credit';
                Editable = false;
                trigger OnAssistEdit()
                var
                    VendLedEntry: Record "Vendor Ledger Entry";
                    VendLedEntries: Page "Vendor Ledger Entries";
                begin
                    clear(VendLedEntries);
                    VendLedEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedEntry.SetRange("Vendor No.", Rec."No.");
                    //VendLedEntry.SetRange(Positive, true);
                    VendLedEntry.SetRange(Open, true);
                    VendLedEntries.LookupMode := true;
                    VendLedEntries.SetTableView(VendLedEntry);
                    VendLedEntries.RunModal();
                end;
            }
        }

        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }
    }

    actions
    {
        modify("Ledger E&ntries")
        {
            ApplicationArea = Suite;
        }
    }

    local procedure GetOpenDebit(): Decimal
    var
        VendLedEntry: Record "Vendor Ledger Entry";
        d: Decimal;
    begin
        d := 0;
        VendLedEntry.SetCurrentKey("Vendor No.", Open);
        VendLedEntry.SetRange("Vendor No.", Rec."No.");
        VendLedEntry.SetRange(Positive, true);
        VendLedEntry.SetRange(Open, true);
        if not VendLedEntry.FindSet() then
            exit;

        repeat
            VendLedEntry.CalcFields("Remaining Amount");
            d += VendLedEntry."Remaining Amount";
        until VendLedEntry.Next() = 0;

        exit(d);
    end;

    local procedure GetOpenCredit(): Decimal
    var
        VendLedEntry: Record "Vendor Ledger Entry";
        d: Decimal;
    begin
        d := 0;
        VendLedEntry.SetCurrentKey("Vendor No.", Open);
        VendLedEntry.SetRange("Vendor No.", Rec."No.");
        VendLedEntry.SetRange(Positive, false);
        VendLedEntry.SetRange(Open, true);
        if not VendLedEntry.FindSet() then
            exit;

        repeat
            VendLedEntry.CalcFields("Remaining Amount");
            d += VendLedEntry."Remaining Amount";
        until VendLedEntry.Next() = 0;

        exit(-d);
    end;
}