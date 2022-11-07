tableextension 50473 TORDimensionValue extends "Dimension Value"
{
    fields
    {
        field(50000; "G/L Account"; code[20])
        {
            Caption = 'G/L Account';
            TableRelation = "G/L Account";
            trigger OnValidate()
            begin
                TestField("Dimension Value Type", "Dimension Value Type"::Standard);
            end;
        }
        field(50001; Immediately; Boolean)
        {
            Caption = 'Immediately';
            trigger OnValidate()
            begin
                TestField("G/L Account");
            end;
        }
    }

    var
        myInt: Integer;
}