/// <summary>
/// PageExtension TOR Company Information.PageExt (ID 50477) extends Record Company Information.
/// </summary>
pageextension 50490 "TOR Item Budg. Entries" extends "Item Budget Entries"
{
    layout
    {
        addafter("Source No.")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
            }
        }

    }
}



