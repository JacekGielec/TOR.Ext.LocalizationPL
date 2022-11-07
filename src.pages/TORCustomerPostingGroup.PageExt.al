/// <summary>
/// PageExtension TOR Company Information.PageExt (ID 50477) extends Record Company Information.
/// 20210522 Add field
/// </summary>
pageextension 50491 "TOR Cust. Post. Group.PageExt" extends "Customer Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Retail Sales"; Rec."TOR Retail Sales")
            {
                ApplicationArea = All;
            }

            field("Posted Invoice Nos."; Rec."TOR Posted Invoice Nos.")
            {
                ApplicationArea = all;
            }
            field("Reminder Terms Code"; Rec."Reminder Terms Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
