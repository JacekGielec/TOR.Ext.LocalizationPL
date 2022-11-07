pageextension 50508 "TOR Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        addlast(General)
        {
            field("Bank Trans. Recalculation"; Rec."Bank Trans. Recalculation")
            {
                ApplicationArea = Basic, Suite;
            }
        }

    }
}