pageextension 50510 "TOR Bank Ledg. Entry" extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter(Open)
        {
            field(Applied; Rec.Applied)
            {
                ApplicationArea = all;
            }
            field("Applied Amount"; Rec."Applied Amount")
            {
                ApplicationArea = all;
            }
            field("Applied to Entry"; Rec."Applied to Entry")
            {
                ApplicationArea = all;
            }
            field("Difference Posted"; Rec."Difference Posted")
            {
                ApplicationArea = all;
            }
            field("Difference Amount"; Rec."Difference Amount")
            {
                ApplicationArea = all;
            }
        }
    }
}