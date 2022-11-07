table 50476 TORReBookingOfDepartCosts
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Production Type"; enum "Production Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Production Type';

        }
        field(2; "Department G/L Account No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Department G/L Account No.';
        }
        field(3; "Prod. Cost G/L Account No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Production Cost G/L Account No.';
        }
        field(4; "Deviation G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Deviation G/L Account No.';
        }
        field(5; "Prod. Cost G/L Account 501"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prod. Cost G/L Account 501';
        }
    }

    keys
    {
        key(Key1; "Production Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}