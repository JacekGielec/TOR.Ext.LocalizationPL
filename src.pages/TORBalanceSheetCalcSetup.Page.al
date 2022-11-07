page 50483 "TOR Balance Sheet Calc. Setup"
{
    DelayedInsert = true;
    Caption = 'Balance Sheet Calc. Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TOR Balance Sheet Calc. Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(rep1)
                {
                    ShowCaption = false;

                    Field(Operation; Rec.Operation)
                    {
                        ApplicationArea = all;
                    }
                    Field("Source Type"; Rec."Source Type")
                    {
                        ApplicationArea = all;
                    }
                    Field("Profit & Loss Name"; Rec."Profit & Loss Name")
                    {
                        ApplicationArea = all;
                    }
                    Field("Source Code"; Rec."Source Code")
                    {
                        ApplicationArea = all;
                    }
                    Field("Source Name"; Rec."Source Name")
                    {
                        ApplicationArea = all;
                        Visible = false;
                    }
                    Field("Amount Type"; Rec."Amount Type")
                    {
                        ApplicationArea = all;
                    }
                    Field("BS Batch Name"; Rec."BS Batch Name")
                    {
                        ApplicationArea = all;
                    }
                    Field("BS Assets/Liabilities"; Rec."BS Assets/Liabilities")
                    {
                        ApplicationArea = all;
                    }
                    Field("BS Line No."; Rec."BS Line No.")
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