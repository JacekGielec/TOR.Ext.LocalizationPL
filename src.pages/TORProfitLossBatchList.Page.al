page 50488 "TOR Profit & Loss Batch List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TOR Profit & Loss Batch";
    Caption = 'Profit & Loss Batch';
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(r1)
                {
                    ShowCaption = false;
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;

                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;

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
}