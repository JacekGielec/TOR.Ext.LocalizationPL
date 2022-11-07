page 50489 "TOR Profit & Loss Lines"
{
    ApplicationArea = All;
    UsageCategory = Administration;

    //Editable = false;
    Caption = 'Profit & Loss Lines';
    SourceTable = "TOR Profit & Loss Line";
    PageType = List;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;
                repeater(r1)
                {
                    field("Line No."; Rec."Line No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Line Symbol"; Rec."Line Symbol")
                    {
                        ApplicationArea = All;
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;

                    }
                    field(Type; Rec.Type)
                    {
                        ApplicationArea = All;

                    }
                }
            }

        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    END;


}