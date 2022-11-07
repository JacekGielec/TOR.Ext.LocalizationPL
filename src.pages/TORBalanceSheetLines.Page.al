page 50484 "TOR Balance Sheet Lines"
{
    ApplicationArea = All;
    UsageCategory = Administration;

    Editable = false;
    Caption = 'Balance Sheet Lines';
    SourceTable = "TOR Balance Sheet Line";
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