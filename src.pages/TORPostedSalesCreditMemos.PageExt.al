/// <summary>
/// PageExtension TOR Posted Sales Invoice (ID 50473) extends Record Posted Sales Invoice.
/// </summary>
pageextension 50489 "TOR Posted Sales Cr. Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Document Date")
        {
            field("ITI Postponed VAT"; Rec."ITI Postponed VAT")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ITI Postponed VAT Realized"; Rec."ITI Postponed VAT Realized")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ITI VAT Settlement Date"; Rec."ITI VAT Settlement Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ITI VAT Status Code"; Rec."ITI VAT Status Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Confirmed; Rec.Confirmed)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Confirmation Date"; Rec."Confirmation Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }

    }
    actions
    {

        addlast(processing)
        {
            action("Change Salesperson")
            {
                ApplicationArea = basic, suite;
                Caption = 'Change Salesperson';
                image = ChangeCustomer;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ShortcutKey = "Shift+Ctrl+S";

                trigger OnAction()
                var
                    c: Codeunit "TOR Changing Posted Document";
                begin
                    c.ChangeSalesPersonOnPostedCreditMemo(Rec);
                end;
            }
            action("Customer Confirmation")
            {
                ApplicationArea = basic, suite;
                Caption = 'Customer Confirmation';
                image = Confirm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ShortcutKey = "Shift+Ctrl+C";

                trigger OnAction()
                var
                    c: Codeunit "TOR Changing Posted Document";
                begin
                    c.ChangeConfirmationDate(Rec);
                end;
            }

        }
    }
}

