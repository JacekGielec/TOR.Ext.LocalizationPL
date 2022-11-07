pageextension 50499 "TOR Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        addafter("Applies-to Doc. No.")
        {
            field("Corrected Document No."; Rec."Corrected Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}