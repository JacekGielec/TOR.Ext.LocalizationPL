table 50452 "TOR Balance Sheet Calc. Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Balance Sheet Calc. Setup';

    FIELDS
    {
        field(1; "BS Batch Name"; Code[20])
        {
            TableRelation = "TOR Balance Sheet Batch";
            Caption = 'Batch Name';
        }
        field(2; "BS Assets/Liabilities"; Enum "TOR Assets/Liabilities")
        {
            Caption = 'Assets/Liabilities';
        }
        field(3; "BS Line No."; Integer)
        {
            TableRelation = "TOR Balance Sheet Line"."Line No." WHERE("Batch Name" = FIELD("BS Batch Name"), "Assets/Liabilities" = FIELD("BS Assets/Liabilities"));

            Caption = 'Line No.';

        }
        field(22; "Source Type"; Enum "TOR Balance Source Type")
        {
            Caption = 'Source Type';

            trigger OnValidate()
            BEGIN
                IF "Source Type" <> xRec."Source Type" THEN BEGIN
                    "Source Code" := '';
                    "Source Name" := '';
                END;
            END;
        }
        field(23; "Profit & Loss Name"; Code[20])
        {
            TableRelation = "TOR Profit & Loss Batch";

            Caption = 'Profit & Loss Name';
        }
        field(30; "Source Code"; Code[20])
        {
            Caption = 'Source Code';

            trigger OnValidate()
            VAR
                LineNo: Integer;
            BEGIN
                IF "Source Code" <> xRec."Source Name" THEN
                    "Source Name" := '';
                CASE "Source Type" OF
                    "Source Type"::"G/L Account":
                        BEGIN
                            IF GLAccount.GET("Source Code") THEN BEGIN
                                GLAccount.TESTFIELD("Income/Balance", GLAccount."Income/Balance"::"Balance Sheet");
                                //GLAccount.TESTFIELD("Account Type", GLAccount."Account Type"::Posting);
                                "Source Name" := GLAccount.Name;
                            END;
                        END;

                    "Source Type"::"Balance Sheet Line":
                        BEGIN
                            EVALUATE(LineNo, "Source Code");
                            IF LineNo >= "BS Line No." THEN
                                ERROR(Text0001);

                            IF BSLine.GET("BS Batch Name", "BS Assets/Liabilities", LineNo) THEN BEGIN
                                LevelNo := BSLine."Level No.";
                                "Source Name" := BSLine.Description;
                            END;
                            BSLine.SETRANGE("Batch Name", "BS Batch Name");
                            BSLine.SETRANGE("Assets/Liabilities", "BS Assets/Liabilities");
                            IF BSLine.FINDFIRST THEN
                                IF BSLine."Level No." > LevelNo THEN
                                    ERROR(Text0006, BSLine."Level No.", LevelNo);
                        END;

                    "Source Type"::"Profit & Loss Line":
                        BEGIN
                            EVALUATE(LineNo, "Source Code");
                            IF PLSLine.GET("Profit & Loss Name", LineNo) THEN
                                "Source Name" := PLSLine.Description;
                        END;
                    //TODO: Oprogramowac

                    "Source Type"::Sheet:
                        begin

                        end;

                END;

            END;

            trigger OnLookup()
            BEGIN
                CASE "Source Type" OF
                    "Source Type"::"G/L Account":
                        BEGIN
                            CLEAR(GLAccountList);
                            GLAccount.SETRANGE("Income/Balance", GLAccount."Income/Balance"::"Balance Sheet");
                            GLAccountList.SETTABLEVIEW(GLAccount);
                            GLAccountList.SETRECORD(GLAccount);
                            GLAccountList.LOOKUPMODE := TRUE;
                            IF GLAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                GLAccountList.GETRECORD(GLAccount);
                                VALIDATE("Source Code", GLAccount."No.");
                            END;
                        END;

                    "Source Type"::"Balance Sheet Line":
                        BEGIN
                            CLEAR(BSLines);
                            BSLine.SETRANGE("Batch Name", "BS Batch Name");
                            BSLine.SETRANGE("Assets/Liabilities", "BS Assets/Liabilities");
                            BSLines.SETTABLEVIEW(BSLine);
                            BSLines.SETRECORD(BSLine);
                            IF BSLines.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                BSLines.GETRECORD(BSLine);
                                EVALUATE("Source Code", FORMAT(BSLine."Line No."));
                                VALIDATE("Source Code");
                            END;
                        END;

                    "Source Type"::"Profit & Loss Line":
                        BEGIN

                            CLEAR(PLSLines);
                            PLSLine.SETRANGE("Batch Name", "Profit & Loss Name");
                            PLSLines.SETTABLEVIEW(PLSLine);
                            PLSLines.SETRECORD(PLSLine);
                            IF PLSLines.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                PLSLines.GETRECORD(PLSLine);
                                EVALUATE("Source Code", FORMAT(PLSLine."Line No."));
                                VALIDATE("Source Code");
                            END;

                        END;
                END;
            END;
        }
        field(31; Operation; Enum "TOR Balance Operation")
        {
            Caption = 'Operation';
        }
        field(40; "Amount Type"; Enum "TOR Balance Amount Type")
        {
            trigger OnValidate()
            VAR
                PLLineElement: Record "TOR Profit & Loss Calc. Setup";
            BEGIN
            END;
        }
        field(45; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
            Editable = false;
        }
    }

    KEYS
    {
        key(key1; "BS Batch Name", "BS Assets/Liabilities", "BS Line No.", "Source Type", "Source Code", "Amount Type")
        {
            Clustered = true;
        }
    }


    var
        GLAccount: Record "G/L Account";
        BSLine: Record "TOR Balance Sheet Line";
        PLSLine: Record "TOR Profit & Loss Line";
        GLAccountList: Page 18;
        BSLines: Page "TOR Balance Sheet Lines";
        PLSLines: Page "TOR Profit & Loss Lines";
        LevelNo: Integer;
        Text0001: Label 'You can only choose the previous Balance entry';
        Text0006: Label 'You cannot use line with lower Level No.. Current Level No. %1, selected Level No. %2.';


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