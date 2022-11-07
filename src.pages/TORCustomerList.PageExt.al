// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho     creation
// TG-TDAG00000-002			05.04.21		jgi     new fields on page
// TG-TDAG00000-003			14.05.21		jgi     change application area

/// <summary>
/// PageExtension TOR Customer List (ID 50456) extends Record Customer List.
/// </summary>
Pageextension 50456 "TOR Customer List" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field(Mixer; Rec.Mixer)
            {
                ApplicationArea = all;
            }
            field("e-invoice"; Rec."e-invoice")
            {
                ApplicationArea = all;
            }
        }
        addafter("Customer Disc. Group")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'VAT Registration No.';
                Editable = false;
            }
        }

        // TG-TDAG00000-002 BEGIN
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
        addafter("Balance Due (LCY)")
        {
            field("Net Change"; "Net Change")
            {
                ApplicationArea = all;
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
                    CustLedEntry: Record "Cust. Ledger Entry";
                    CustLedEntries: Page "Customer Ledger Entries";
                begin
                    clear(CustLedEntries);
                    CustLedEntry.SetCurrentKey("Customer No.", Open);
                    CustLedEntry.SetRange("Customer No.", Rec."No.");
                    CustLedEntry.SetRange(Open, true);
                    CustLedEntries.LookupMode := true;
                    CustLedEntries.SetTableView(CustLedEntry);
                    CustLedEntries.RunModal();
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
                    CustLedEntry: Record "Cust. Ledger Entry";
                    CustLedEntries: Page "Customer Ledger Entries";
                begin
                    clear(CustLedEntries);
                    CustLedEntry.SetCurrentKey("Customer No.", Open);
                    CustLedEntry.SetRange("Customer No.", Rec."No.");
                    CustLedEntry.SetRange(Open, true);
                    CustLedEntries.LookupMode := true;
                    CustLedEntries.SetTableView(CustLedEntry);
                    CustLedEntries.RunModal();
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
        modify("Sales (LCY)")
        {
            Visible = false;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }
        // TG-TDAG00000-002 END
    }

    // TG-TDAG00000-003 BEGIN
    actions
    {
        modify(CustomerLedgerEntries)
        {
            ApplicationArea = Suite;
            ShortcutKey = "Ctrl+F7";
        }
    }
    // TG-TDAG00000-003 END

    // TG-TDAG00000-002 BEGIN
    local procedure GetOpenDebit(): Decimal
    var
        LedEntry: Record "Cust. Ledger Entry";
        d: Decimal;
    begin
        d := 0;
        LedEntry.SetCurrentKey("Customer No.", Open);
        LedEntry.SetRange("Customer No.", Rec."No.");
        LedEntry.SetRange(Positive, true);
        LedEntry.SetRange(Open, true);
        if not LedEntry.FindSet() then
            exit;

        repeat
            LedEntry.CalcFields("Remaining Amount");
            d += LedEntry."Remaining Amount";
        until LedEntry.Next() = 0;

        exit(d);
    end;

    local procedure GetOpenCredit(): Decimal
    var
        LedEntry: Record "Cust. Ledger Entry";
        d: Decimal;
    begin
        d := 0;
        LedEntry.SetCurrentKey("Customer No.", Open);
        LedEntry.SetRange("Customer No.", Rec."No.");
        LedEntry.SetRange(Positive, false);
        LedEntry.SetRange(Open, true);
        if not LedEntry.FindSet() then
            exit;

        repeat
            LedEntry.CalcFields("Remaining Amount");
            d += LedEntry."Remaining Amount";
        until LedEntry.Next() = 0;

        exit(-d);
    end;
    // TG-TDAG00000-002 END
}
