pageextension 50505 "TOR Dtld. Cust. Ledg. Entries" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addbefore("Cust. Ledger Entry No.")
        {
            field("ITI Positive"; Rec."ITI Positive")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("ITI Customer Posting Group"; Rec."ITI Customer Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("ITI G/L Account No."; Rec."ITI G/L Account No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }


}