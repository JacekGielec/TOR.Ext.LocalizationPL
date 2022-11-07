page 50480 LevelNumbers
{
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TOR Level Number";
    DelayedInsert = true;
    PageType = ListPlus;
    AutoSplitKey = true;
    Caption = 'Level Numbers';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;
                Field("Level No."; LevelNo)
                {
                    ApplicationArea = all;
                    TableRelation = Integer.Number WHERE(Number = FILTER(1 .. 10));
                    LookupPageID = "TOR Levels";
                    trigger OnValidate()
                    BEGIN
                        IF (LevelNo > 10) OR (LevelNo < 1) THEN
                            ERROR(Text001);
                        LevelNoOnAfterValidate;
                    END;
                }

                repeater(Control1)
                {
                    ShowCaption = false;
                    Field(Symbol; Rec.Symbol)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    VAR
        OldRec: Record "Tor Level Number";
        LevelNo: Integer;
        Text001: label 'Number must be between 1 an 10.';


    trigger OnOpenPage()
    BEGIN
        LevelNo := 1;
        Rec.SETRANGE(Level, LevelNo);
    END;


    LOCAL PROCEDURE LevelNoOnAfterValidate();
    BEGIN
        Rec.SETRANGE(Level, LevelNo);
        CurrPage.UPDATE(FALSE);
    END;

}