pageextension 50502 "TOR Bank Account Card" extends "Bank Account Card"
{
    layout
    {

    }

    actions
    {
        addafter("Receivables-Payables")
        {
            action("TOR Calc & Post Bank Exch. Diff.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TOR Calc & Post Bank Exch. Diff.';
                Image = VendorPaymentJournal;
                Promoted = true;
                PromotedCategory = Category5;
                trigger OnAction()
                var
                    Exch: Report "TOR Calc&Post Bank Exch. Diff.";
                    BA: record "Bank Account";
                begin
                    ba.SetRange("No.", Rec."No.");
                    exch.SetTableView(ba);
                    Exch.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}