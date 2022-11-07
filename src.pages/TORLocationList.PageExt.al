pageextension 50511 "TOR Location List" extends "Location List"
{
    layout
    {
        addafter(name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = all;
            }
        }
    }
}