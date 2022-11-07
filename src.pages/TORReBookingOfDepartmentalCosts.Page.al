page 50499 TORReBookingOfDeparCosts
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = TORReBookingOfDepartCosts;
    ;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Production Type"; Rec."Production Type")
                {
                    ApplicationArea = Basic, suite;
                }
                field("Department G/L Account No."; Rec."Department G/L Account No.")
                {
                    ApplicationArea = Basic, suite;
                }
                field("Prod. Cost G/L Account 501"; Rec."Prod. Cost G/L Account 501")
                {
                    ApplicationArea = basic, suite;
                }
                field("Prod. Cost G/L Account No."; Rec."Prod. Cost G/L Account No.")
                {
                    ApplicationArea = basic, suite;
                }
                field("Deviation G/L Account No."; Rec."Deviation G/L Account No.")
                {
                    ApplicationArea = basic, suite;
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