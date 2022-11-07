table 50451 "TOR Balance Sheet Batch"
{
    DataClassification = ToBeClassified;
    LookupPageId = "TOR Balances Sheet Batch List";

    fields
    {
        field(1; Name; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }


    var
        Text001: Label 'You cannot delete %1, %2 when one or more %3 exists.';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    VAR
        BSLine: Record "TOR Balance Sheet Line";
    BEGIN
        BSLine.SETRANGE("Batch Name", Name);
        IF NOT BSLine.ISEMPTY THEN
            ERROR(Text001, TABLECAPTION, Name, BSLine.TABLECAPTION);
    END;


    trigger OnRename()
    begin

    end;

}