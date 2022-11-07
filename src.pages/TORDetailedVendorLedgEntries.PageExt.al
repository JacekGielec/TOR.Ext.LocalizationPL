pageextension 50507 "TOR Dtld. Vend. Ledg. Entries" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addbefore("Vendor Ledger Entry No.")
        {
            field("ITI Positive"; Rec."ITI Positive")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("ITI Vendor Posting Group"; Rec."ITI Vendor Posting Group")
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