page 50455 "TOR Item FI Plan Groups"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Item FI Plan Groups';
    InsertAllowed = true;
    PageType = List;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "TOR Item FI Plan Group";
    SourceTableView = SORTING("Code");
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

}

