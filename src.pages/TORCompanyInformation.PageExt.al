/// <summary>
/// PageExtension TOR Company Information.PageExt (ID 50477) extends Record Company Information.
/// </summary>
pageextension 50477 "TOR Company Information" extends "Company Information"
{
    layout
    {
        addafter("VAT Registration No.")
        {
            field("Registration No."; Rec."Registration No.")
            {
                ApplicationArea = All;
            }

            field("TOR KRS"; Rec."TOR KRS")
            {
                ApplicationArea = All;
            }

            field("TOR BDO"; Rec."TOR BDO")
            {
                ApplicationArea = All;
            }


        }

        addafter("Auto. Send Transactions")
        {
            field("TOR Reconc. Cont. No."; Rec."TOR Reconc. Cont. No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
