/// <summary>
/// PageExtension TOR Company Information.PageExt (ID 50477) extends Record Company Information.
/// </summary>
pageextension 50493 "TOR Reminder Header PageExt" extends Reminder
{
    layout
    {
        addafter(Posting)
        {
            group("Responsible Person")
            {
                Caption = 'Responsible Person';
                field("Responsible Person Code"; Rec."Responsible Person Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsible Person Name"; Rec."Responsible Person Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsible Person Phone No."; Rec."Responsible Person Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Resp. Person Mobile Phone No."; Rec."Resp. Person Mobile Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsible Person Mail"; Rec."Responsible Person Mail")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}


