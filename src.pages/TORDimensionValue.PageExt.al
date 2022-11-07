pageextension 50496 TORDimensionValues extends "Dimension Values"
{
    layout
    {
        addafter(Totaling)
        {
            field("G/L Account"; Rec."G/L Account")
            {
                ApplicationArea = basic, suite;
            }
            field(Immediately; Rec.Immediately)
            {
                ApplicationArea = basic, suite;
            }
        }
    }
}