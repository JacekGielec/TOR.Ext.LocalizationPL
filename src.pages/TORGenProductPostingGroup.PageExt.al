pageextension 50498 "Gen. Prod. Post. Group" extends "Gen. Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Production Type"; Rec."Production Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}