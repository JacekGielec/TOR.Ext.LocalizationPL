page 50485 "TOR Balances Sheet Batch List"
{
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TOR Balance Sheet Batch";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;
                repeater(r1)
                {
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;

                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}