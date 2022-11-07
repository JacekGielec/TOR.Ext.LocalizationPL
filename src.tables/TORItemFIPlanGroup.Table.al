table 50458 "TOR Item FI Plan Group"
{
    Caption = 'Item FI Plan Group';
    LookupPageID = "TOR Item FI Plan Groups";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }

    }

    trigger OnInsert()
    begin
        TestField(Code);
    end;



}

