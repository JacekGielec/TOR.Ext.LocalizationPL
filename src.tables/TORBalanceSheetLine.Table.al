table 50453 "TOR Balance Sheet Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Balance Sheet Line';

    LookupPageID = "TOR Balance Sheet Lines";

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            TableRelation = "TOR Balance Sheet Batch";
            Caption = 'Batch Name';
        }
        field(2; "Assets/Liabilities"; Enum "TOR Assets/Liabilities")
        {
            Caption = 'Assets/Liabilities';
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
            begin
                JustText();
            end;
        }
        field(11; "Description 2"; Text[100])
        {
            Caption = 'Description 2';

            trigger OnValidate()
            begin
                JustText();
            end;
        }
        field(15; "Description for Negative"; Text[100])
        {
            Caption = 'Description for Nehative';
            trigger OnValidate()
            begin
                JustText();
            end;
        }
        field(16; "Description for Negative 2"; Text[100])
        {
            Caption = 'Description for Negative 2';

            trigger OnValidate()
            begin
                JustText();
            end;
        }
        field(20; Balance; Decimal)
        {
            Caption = 'Balance';
            Editable = false;
        }
        field(21; "Comparison Balance"; Decimal)
        {
            Caption = 'Comparison Balance';
            Editable = false;
        }
        field(22; Type; Enum "TOR Balance Type Line")
        {
            Caption = 'Type';
            trigger OnValidate()
            VAR
                BalanceLineElement: Record "TOR Balance Sheet Calc. Setup";
            BEGIN
                IF (xRec.Type = xRec.Type::Calculation) AND
                   (Type <> Type::Calculation)
                THEN BEGIN
                    BalanceLineElement.RESET;
                    BalanceLineElement.SETRANGE("BS Batch Name", "Batch Name");
                    BalanceLineElement.SETRANGE("BS Assets/Liabilities", "Assets/Liabilities");
                    BalanceLineElement.SETRANGE("BS Line No.", "Line No.");
                    IF NOT BalanceLineElement.ISEMPTY THEN
                        IF CONFIRM(Text003, TRUE, FIELDCAPTION(Type)) THEN
                            BalanceLineElement.DELETEALL(TRUE)
                        ELSE
                            ERROR('');
                END;
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
        field(23; "Set Zero"; Enum "TOR Set Zero")
        {
            Caption = 'Set Zero';

            trigger OnValidate()
            BEGIN
                TESTFIELD(Type, Type::Calculation);
            END;
        }
        field(30; "Global Dimension 2 Filter"; Code[20])
        {
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,3,2';
        }
        field(50; Hide; Boolean)
        {
            Caption = 'Hide';
        }
        field(51; "Assets Amount"; Decimal)
        {
            Caption = 'Assets Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TOR Balance Sheet Line".Balance WHERE("Batch Name" = FIELD("Batch Name"), "Assets/Liabilities" = filter(Assets), "Level No." = CONST(1)));

        }
        field(52; "Liabilities Amount"; Decimal)
        {
            Caption = 'Liabilities Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TOR Balance Sheet Line".Balance WHERE("Batch Name" = FIELD("Batch Name"), "Assets/Liabilities" = filter(Liabilities), "Level No." = CONST(1)));
        }
        field(53; "Comparison Assets Amount"; Decimal)
        {
            Caption = 'Comparison Assets Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TOR Balance Sheet Line"."Comparison Balance" WHERE("Batch Name" = FIELD("Batch Name"), "Assets/Liabilities" = filter(Assets), "Level No." = CONST(1)));

        }
        field(54; "Comparison Liabilities Amount"; Decimal)
        {
            Caption = 'Comparison Liabilities Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TOR Balance Sheet Line"."Comparison Balance" WHERE("Batch Name" = FIELD("Batch Name"), "Assets/Liabilities" = filter(Liabilities), "Level No." = CONST(1)));
        }
    }

    keys
    {
        key(Key1; "Batch Name", "Assets/Liabilities", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Batch Name", "Level No.")
        {

        }
    }

    var
        Text001: label 'Level no. must be greater than zero.';
        Text002: label 'You cannot delete this line because it is used in definition of page %1, line %2.';
        Text003: label 'If you change the %1 value, all settings will be deleted.\\Do you want to continue?';
        Text004: label 'Level error between lines %1, %2.';
        Text005: label 'The Path Symbol %1 has less levels then %2.';
        Text006: label 'For the value %1 of the field %2, the field %3 cannot be empty.';
        Text007: label 'For the value %1 of the field %2, the field %3 must be empty.';
        Text008: label 'The filter %1 is not valid for %2 field.';

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
    var
        BalanceLineElement: Record "TOR Balance Sheet Calc. Setup";
        Text001: Label 'You cannot delete this line because it is used in definition of page %1, line %2.';
    BEGIN
        BalanceLineElement.RESET;
        BalanceLineElement.SETRANGE("BS Batch Name", "Batch Name");
        BalanceLineElement.SETRANGE("BS Assets/Liabilities", "Assets/Liabilities");
        BalanceLineElement.SETRANGE("Source Type", BalanceLineElement."Source Type"::"Profit & Loss Line");
        BalanceLineElement.SETRANGE("Source Code", FORMAT("Line No."));
        IF BalanceLineElement.FINDFIRST THEN
            ERROR(Text002, BalanceLineElement."BS Assets/Liabilities", BalanceLineElement."BS Line No.");
        BalanceLineElement.SETRANGE("Source Type");
        BalanceLineElement.SETRANGE("Source Code");
        BalanceLineElement.SETRANGE("BS Line No.", "Line No.");
        IF NOT BalanceLineElement.ISEMPTY THEN
            BalanceLineElement.DELETEALL(TRUE);
    END;

    trigger OnRename()
    begin

    end;

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

    PROCEDURE UpDateNext(Rec2: Record "TOR Balance Sheet Line"; Level2: Integer; PathSymbol2: Text[250]);
    VAR
        BalanceLine: Record "TOR Balance Sheet Line";
        LineNumbering: Record "TOR Level Number";
        LevelDiff: Integer;
        xLevel: Integer;
        xPathSymbol: Text[250];
    BEGIN
        xLevel := Level2;
        xPathSymbol := PathSymbol2;
        BalanceLine.SETRANGE("Batch Name", Rec2."Batch Name");
        BalanceLine.SETRANGE("Assets/Liabilities", "Assets/Liabilities");
        BalanceLine.GET(Rec2."Batch Name", Rec2."Assets/Liabilities", Rec2."Line No.");
        REPEAT
            LevelDiff := BalanceLine."Level No." - xLevel;
            IF LevelDiff > 1 THEN
                ERROR(Text004, xPathSymbol, BalanceLine."Path Symbol");
            IF LevelDiff = 1 THEN BEGIN
                BalanceLine."Line Symbol" := LineNumbering.FirstSymbol(BalanceLine."Level No.");
                BalanceLine."Path Symbol" := xPathSymbol + BalanceLine."Line Symbol" + ',';
            END;
            IF LevelDiff = 0 THEN BEGIN
                BalanceLine."Line Symbol" := LineNumbering.NextSymbol(BalanceLine."Level No.", PrevSymbol(xPathSymbol));
                BalanceLine."Path Symbol" := CutString(xPathSymbol, BalanceLine."Level No." - 1)
                  + BalanceLine."Line Symbol" + ',';
            END;
            IF LevelDiff < 0 THEN BEGIN
                BalanceLine."Path Symbol" := CutString(xPathSymbol, BalanceLine."Level No.");
                BalanceLine."Line Symbol" := LineNumbering.NextSymbol(BalanceLine."Level No.", PrevSymbol(BalanceLine."Path Symbol"));
                BalanceLine."Path Symbol" := CutString(BalanceLine."Path Symbol", BalanceLine."Level No." - 1)
                  + BalanceLine."Line Symbol" + ',';
            END;
            BalanceLine.VALIDATE("Line Symbol");
            BalanceLine.MODIFY;
            xLevel := BalanceLine."Level No.";
            xPathSymbol := BalanceLine."Path Symbol";
        UNTIL BalanceLine.NEXT = 0;
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
                    ERROR(Text005, CheckedString, Level);
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
            END
            ELSE
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