pageextension 50519 "TOR Value Entries" extends "Value Entries"
{
    layout
    {
        addbefore("Gen. Prod. Posting Group")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = all;
            }

        }
    }


}