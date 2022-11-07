page 50490 "TOR Profit & Loss Calc. Setup"
{
    DelayedInsert = true;
    Caption = 'Profit & Loss Calc. Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TOR Profit & Loss Calc. Setup";

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
                    Field("PLS Batch Name"; Rec."PLS Batch Name")
                    {
                        ApplicationArea = all;
                    }
                    Field("PLS Line No."; Rec."PLS Line No.")
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