pageextension 50494 "TOR Extended Text Line" extends "Extended Text Lines"
{
    layout
    {
        addafter(Text)
        {
            field(LongText; Rec.LongText)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}