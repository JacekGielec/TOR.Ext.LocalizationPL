page 50481 "TOR Levels"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = 2000000026;

    Editable = false;
    Caption = 'Levels';
    PageType = List;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;
                field(Number; Rec.Number)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        Rec.SETRANGE(Number, 1, 10);
    END;

}