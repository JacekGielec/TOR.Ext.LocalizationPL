table 50457 "TOR Profit & Loss Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Profit & Loss Line';

    //LookupPageID = Page50489;

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            TableRelation = "TOR Profit & Loss Batch";
            Caption = 'Batch Name';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Level No."; Integer)
        {
            Caption = 'Level No.';
        }
        field(6; "Line Symbol"; Text[20])
        {
            Caption = 'Line Symbol';
            Editable = false;
            trigger OnValidate()
            BEGIN
                JustText();
            END;

        }
        field(7; "Path Symbol"; Text[250])
        {
            Caption = 'Path Symbol';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            trigger OnValidate()
            BEGIN
                JustText();
            END;
        }
        field(11; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            trigger OnValidate()
            BEGIN
                JustText();
            END;
        }
        field(15; "Description for Negative"; Text[100])
        {
            Description = 'Description for Negative';
            trigger OnValidate()
            BEGIN
                JustText();
            END;
        }
        field(16; "Description for Negative 2"; Text[100])
        {
            Caption = 'Description for Negative 2';

            trigger OnValidate()
            BEGIN
                JustText();
            END;
        }
        field(20; "Comparison Period Amount"; Decimal)
        {
            Caption = 'Comparison Period Amount';
        }
        field(21; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(22; Type; Enum "TOR Balance Type Line")
        {
            Caption = 'Type';

            trigger OnValidate()
            BEGIN
                PLSLineSetup.SETRANGE("PLS Batch Name", "Batch Name");
                PLSLineSetup.SETRANGE("PLS Line No.", "Line No.");
                IF NOT PLSLineSetup.ISEMPTY THEN
                    IF CONFIRM(Text004, FALSE, FIELDCAPTION(Type)) THEN
                        PLSLineSetup.DELETEALL(TRUE)
                    ELSE
                        Type := xRec.Type;
            END;
        }
        field(23; "Set Zero"; Enum "TOR Set Zero")
        {
            Caption = 'Set Zero';

            trigger OnValidate()
            BEGIN
                TESTFIELD(Type, Type::Calculation);
            END;
        }
        field(25; "New Page"; Boolean)
        {
            Caption = 'New Page';
        }
        field(29; "Global Dimension 1 Filter"; Code[20])
        {
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            CaptionClass = '1,3,1';
        }
        field(30; "Global Dimension 2 Filter"; Code[20])
        {
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,3,2';
        }
        field(40; Hide; Boolean)
        {
            Caption = 'Hide';
        }

    }

    keys
    {
        key(Key1; "Batch Name", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Batch Name", "Level No.") { }

    }
    trigger OnInsert()
    begin
        IF "Level No." < 1 THEN
            ERROR(Text001)
        ELSE
            JustText();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        BSLineSetup.SETRANGE("Profit & Loss Name", "Batch Name");
        BSLineSetup.SETRANGE("Source Type", BSLineSetup."Source Type"::"Profit & Loss Line");
        BSLineSetup.SETRANGE("Source Code", FORMAT("Line No."));
        IF BSLineSetup.FINDFIRST THEN
            ERROR(Text002, BSLineSetup."BS Batch Name",
                  BSLineSetup."BS Assets/Liabilities",
                  BSLineSetup."BS Line No.");
        PLSLineSetup.SETRANGE("PLS Batch Name", "Batch Name");
        PLSLineSetup.SETRANGE("Source Type", PLSLineSetup."Source Type"::"Profit & Loss Line");
        PLSLineSetup.SETRANGE("Source Code", FORMAT("Line No."));
        IF PLSLineSetup.FINDFIRST THEN
            ERROR(Text003, PLSLineSetup."PLS Line No.");
        PLSLineSetup.RESET;
        PLSLineSetup.SETRANGE("PLS Batch Name", "Batch Name");
        PLSLineSetup.SETRANGE("PLS Line No.", "Line No.");
        IF PLSLineSetup.FINDFIRST THEN
            PLSLineSetup.DELETEALL(TRUE);
    end;

    trigger OnRename()
    begin

    end;

    VAR
        Text001: Label 'Level no. must be greater than zero.';
        Text002: Label 'You cannot delete this line because it is used in definition of Balance Sheet %1, %2, line %3.';
        Text003: Label 'You cannot delete this line because it is used in definition of line %1.';
        Text004: Label 'If you change the %1 value, all settings will be deleted.\\Do you want to continue?';
        Text005: Label 'Level error between lines %1, %2.';
        Text006: Label 'The Path Symbol %1 has less levels then %2.';
        PLSLineSetup: Record "TOR Profit & Loss Calc. Setup";
        BSLineSetup: Record "TOR Balance Sheet Calc. Setup";

    PROCEDURE JustText();
    VAR
        NSpace: Text[50];
    BEGIN
        IF ("Level No." > 0) THEN BEGIN
            IF ("Line Symbol" <> '') THEN BEGIN
                "Line Symbol" := DELCHR("Line Symbol", '<>');
                NSpace := '';
                "Line Symbol" := PADSTR(NSpace, ("Level No." - 1) + ("Level No." - 1)) + "Line Symbol";
            END;

            IF (Description <> '') THEN BEGIN
                Description := DELCHR(Description, '<>');
                NSpace := '';
                Description := PADSTR(NSpace, ("Level No." - 1) + ("Level No." - 1)) + Description;
            END;
            IF ("Description 2" <> '') THEN BEGIN
                "Description 2" := DELCHR("Description 2", '<>');
                NSpace := '';
                "Description 2" := PADSTR(NSpace, ("Level No." - 1) + ("Level No." - 1)) + "Description 2";
            END;
            IF ("Description for Negative" <> '') THEN BEGIN
                "Description for Negative" := DELCHR("Description for Negative", '<>');
                NSpace := '';
                "Description for Negative" := PADSTR(NSpace, ("Level No." - 1) + ("Level No." - 1)) + "Description for Negative";
            END;
            IF ("Description for Negative 2" <> '') THEN BEGIN
                "Description for Negative 2" := DELCHR("Description for Negative 2", '<>');
                NSpace := '';
                "Description for Negative 2" := PADSTR(NSpace, ("Level No." - 1) + ("Level No." - 1)) + "Description for Negative 2";
            END;

        END;
    END;

    PROCEDURE UpDateNext(Rec2: Record "TOR Profit & Loss Line"; Level2: Integer; PathSymbol2: Text[250]);
    VAR
        PLLine: Record "TOR Profit & Loss Line";
        LineNumbering: Record "TOR Level Number";
        LevelDiff: Integer;
        xLevel: Integer;
        xPathSymbol: Text[250];
    BEGIN
        xLevel := Level2;
        xPathSymbol := PathSymbol2;
        PLLine.SETRANGE("Batch Name", Rec2."Batch Name");
        PLLine.GET(Rec2."Batch Name", Rec2."Line No.");
        REPEAT
            LevelDiff := PLLine."Level No." - xLevel;
            IF LevelDiff > 1 THEN
                ERROR(Text005, xPathSymbol, PLLine."Path Symbol");
            IF LevelDiff = 1 THEN BEGIN
                PLLine."Line Symbol" := LineNumbering.FirstSymbol(PLLine."Level No.");
                PLLine."Path Symbol" := xPathSymbol + PLLine."Line Symbol" + ',';
            END;
            IF LevelDiff = 0 THEN BEGIN
                PLLine."Line Symbol" := LineNumbering.NextSymbol(PLLine."Level No.", PrevSymbol(xPathSymbol));
                PLLine."Path Symbol" := CutString(xPathSymbol, PLLine."Level No." - 1)
                  + PLLine."Line Symbol" + ',';
            END;
            IF LevelDiff < 0 THEN BEGIN
                PLLine."Path Symbol" := CutString(xPathSymbol, PLLine."Level No.");
                PLLine."Line Symbol" := LineNumbering.NextSymbol(PLLine."Level No.", PrevSymbol(PLLine."Path Symbol"));
                PLLine."Path Symbol" := CutString(PLLine."Path Symbol", PLLine."Level No." - 1)
                  + PLLine."Line Symbol" + ',';
            END;
            PLLine.VALIDATE("Line Symbol");
            PLLine.MODIFY;
            xLevel := PLLine."Level No.";
            xPathSymbol := PLLine."Path Symbol";
        UNTIL PLLine.NEXT = 0;
    END;

    PROCEDURE CutString(CheckedString: Text[250]; Level: Integer): Text[250];
    VAR
        CheckedString2: Text[250];
        Pointer: Integer;
        Stop: Boolean;
        Level2: Integer;
    BEGIN
        Level2 := 0;
        Pointer := 1;
        WHILE NOT Stop DO BEGIN
            IF Level2 < Level THEN BEGIN
                IF Pointer <= STRLEN(CheckedString) THEN BEGIN
                    CheckedString2 := CheckedString2 + COPYSTR(CheckedString, Pointer, 1);
                    IF CheckedString[Pointer] = ',' THEN
                        Level2 := Level2 + 1;
                END ELSE
                    ERROR(Text006, CheckedString, Level);
            END ELSE
                Stop := TRUE;
            Pointer := Pointer + 1;
        END;
        EXIT(CheckedString2);
    END;

    PROCEDURE PrevSymbol(CheckedString: Text[250]): Text[250];
    VAR
        CheckedString2: Text[250];
        Pointer: Integer;
        Stop: Boolean;
    BEGIN
        Pointer := STRLEN(CheckedString);
        WHILE NOT Stop DO BEGIN
            Pointer := Pointer - 1;
            IF Pointer > 0 THEN BEGIN
                IF CheckedString[Pointer] = ',' THEN
                    Stop := TRUE
            END ELSE
                Stop := TRUE;
        END;
        IF Pointer > 0 THEN BEGIN
            Pointer := Pointer + 1;
            CheckedString2 := COPYSTR(CheckedString, Pointer, STRLEN(CheckedString) - Pointer);
        END ELSE
            CheckedString2 := COPYSTR(CheckedString, 1, STRLEN(CheckedString) - 1);
        EXIT(CheckedString2);
    END;

}