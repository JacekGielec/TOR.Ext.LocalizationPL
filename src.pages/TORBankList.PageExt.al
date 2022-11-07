/// <summary>
/// PageExtension TOR Company Information.PageExt (ID 50477) extends Record Company Information.
/// </summary>
pageextension 50478 "TOR Bank List" extends "Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
            }
        }
        addafter(Balance)
        {
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = All;
            }
        }
        modify("Bank Account No.")
        {
            Visible = true;
        }
    }
}



