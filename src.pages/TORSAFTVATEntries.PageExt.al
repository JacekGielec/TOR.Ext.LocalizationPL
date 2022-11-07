pageextension 50506 "TOR SAF-T Entries VAT" extends "ITI SAF-T VAT Entries"
{
    layout
    {
        addafter("Declaration Required")
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
            /*
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = all;
            }
            */
            field("Document Receipt/Sales Date"; Rec."Document Receipt/Sales Date")
            {
                ApplicationArea = all;
            }
            field("Sales Document No."; Rec."Sales Document No.")
            {
                ApplicationArea = all;
            }
            field("Purchase Document No."; Rec."Purchase Document No.")
            {
                ApplicationArea = all;
            }
            /*
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = all;
            }
            */
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}