table 50455 "TOR Profit & Loss Batch"
{
    DataClassification = ToBeClassified;
    Caption = 'Profit & Loss Batch';
    LookupPageID = "TOR Profit & Loss Batch List";

    fields
    {
        field(1; Name; Code[20])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    VAR
        Text001: Label 'You cannot delete %1, %2 when one or more %3 exists.';

        PLSLine: Record "TOR Profit & Loss Line";
    BEGIN
        PLSLine.SETRANGE("Batch Name", Name);
        IF NOT PLSLine.ISEMPTY THEN
            ERROR(Text001, TABLECAPTION, Name, PLSLine.TABLECAPTION);
    END;

    trigger OnRename()
    begin

    end;

}