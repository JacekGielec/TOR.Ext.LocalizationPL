/// <summary>
/// PageExtension TOR Company Information.PageExt (ID 50477) extends Record Company Information.
/// </summary>
pageextension 50492 "TOR Reminder Levels PageExt" extends "Reminder Levels"
{
    layout
    {
        addafter("No.")
        {
            field("Responsible Person Code"; Rec."Responsible Person Code")
            {
                ApplicationArea = All;
            }
        }
    }
}



