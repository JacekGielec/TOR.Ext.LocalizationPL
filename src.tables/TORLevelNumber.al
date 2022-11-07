table 50454 "TOR Level Number"
{
    DataClassification = ToBeClassified;

    FIELDS
    {
        field(1; Level; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Symbol; Text[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                NumberingOfLevel2.SETRANGE(Level, Level);
                NumberingOfLevel2.SETRANGE(Symbol, Symbol);
                NumberingOfLevel2.SETFILTER("Line No.", '<> %1', "Line No.");
                IF NumberingOfLevel2.FIND('-') THEN
                    ERROR(Text001, Symbol);
            end;
        }
    }
    KEYS
    {
        key(key1; Level, "Line No.")
        {
            Clustered = true;
        }
    }
    FIELDGROUPS
    {
    }

    VAR
        NumberingOfLevel2: Record "TOR Level Number";
        Text001: Label 'ENU=The number %1 already exists;PLK=Liczba %1 ju¾ istnieje.';
        Text002: Label 'ENU=The number %1 does not exist;PLK=Liczba %1 nie istnieje.';
        Text003: Label 'ENU=There is no next symbol for number %1;PLK=Brak nast©pnego symbolu dla liczby %1.';
        Text004: Label 'ENU=There are no numbers for level %1;PLK=Brak liczb dla poziomu %1';
        Text005: Label 'ENU=There is not previous symbol for number %1;PLK=Brak poprzedniego symbolu dla liczby %1';

    PROCEDURE NextSymbol(Level2: Integer; Symbol2: Text[10]): Text[10];
    BEGIN
        NumberingOfLevel2.SETRANGE(Level, Level2);
        NumberingOfLevel2.SETRANGE(Symbol, DELCHR(Symbol2, '<>'));
        IF NumberingOfLevel2.FIND('-') THEN BEGIN
            NumberingOfLevel2.SETRANGE(Symbol);
            IF NumberingOfLevel2.NEXT <> 0 THEN
                EXIT(NumberingOfLevel2.Symbol)
            ELSE
                ERROR(Text003, Symbol2);
        END ELSE
            ERROR(Text002, Symbol2);
    END;

    PROCEDURE FirstSymbol(Level2: Integer): Text[10];
    BEGIN
        NumberingOfLevel2.SETRANGE(Level, Level2);
        NumberingOfLevel2.SETRANGE(Symbol);
        IF NumberingOfLevel2.FIND('-') THEN
            EXIT(NumberingOfLevel2.Symbol)
        ELSE
            ERROR(Text004, Level2);
    END;

    PROCEDURE PrevSymbol(Level2: Integer; Symbol2: Text[10]): Text[10];
    BEGIN
        NumberingOfLevel2.SETRANGE(Level, Level2);
        NumberingOfLevel2.SETRANGE(Symbol, DELCHR(Symbol2, '<>'));
        IF NumberingOfLevel2.FIND('-') THEN BEGIN
            NumberingOfLevel2.SETRANGE(Symbol);
            IF NumberingOfLevel2.NEXT(-1) <> 0 THEN
                EXIT(NumberingOfLevel2.Symbol)
            ELSE
                ERROR(Text005, Symbol2);
        END ELSE
            ERROR(Text002, Symbol2);
    END;

    PROCEDURE ID();
    BEGIN
    END;

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