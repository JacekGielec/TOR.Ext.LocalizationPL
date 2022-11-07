table 50456 "TOR Profit & Loss Calc. Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Profit & Loss Calc. Setup';

    fields
    {
        field(1; "PLS Batch Name"; Code[20])
        {
            TableRelation = "TOR Profit & Loss Batch";
            Caption = 'PLS Batch Name';
        }
        field(2; "PLS Line No."; Integer)
        {
            TableRelation = "TOR Profit & Loss Line"."Line No." WHERE("Batch Name" = FIELD("PLS Batch Name"));
            Caption = 'Line No.';
        }
        field(3; "Source Type"; Enum "TOR Profit & Loss Source Type")
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
        field(4; "Source Code"; Code[20])
        {
            Caption = 'Source Code';

            trigger OnValidate()
            VAR
                LineNo: Integer;
            BEGIN
                IF "Source Code" <> xRec."Source Code" THEN
                    "Source Name" := '';
                CASE "Source Type" OF
                    "Source Type"::"G/L Account":
                        IF GLAccount.GET("Source Code") THEN BEGIN
                            if Rec."PLS Batch Name" <> 'PORÓWNAWCZY' then
                                GLAccount.TESTFIELD("Income/Balance", GLAccount."Income/Balance"::"Income Statement")
                            else begin
                                if (GLAccount."Income/Balance" <> GLAccount."Income/Balance"::"Income Statement") and
                                (CopyStr(GLAccount."No.", 1, 1) <> '6') then
                                    GLAccount.TESTFIELD("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
                            end;
                            GLAccount.TESTFIELD("Account Type", GLAccount."Account Type"::Posting);
                            "Source Name" := GLAccount.Name;
                        END;
                    "Source Type"::"Profit & Loss Line":
                        BEGIN
                            EVALUATE(LineNo, "Source Code");
                            IF LineNo >= "PLS Line No." THEN
                                ERROR(Text0001);
                            PLSLine.RESET;
                            PLSLine.GET("PLS Batch Name", LineNo);
                            "Source Name" := PLSLine.Description;
                            LevelNo := PLSLine."Level No.";
                            PLSLine.SETRANGE("Line No.");
                            PLSLine.SETRANGE("Batch Name", "PLS Batch Name"); //ITAS
                            PLSLine.SETRANGE("Line No.", "PLS Line No.");
                            PLSLine.FINDFIRST;
                            IF PLSLine."Level No." > LevelNo THEN
                                ERROR(Text0006, PLSLine."Level No.", LevelNo);
                        END;
                END;
            END;

            trigger OnLookup()
            VAR
                PLSLines: Page "TOR Profit & Loss Lines";
            BEGIN
                CASE "Source Type" OF
                    "Source Type"::"G/L Account":
                        BEGIN
                            CLEAR(GLAccountList);
                            GLAccount.SETRANGE("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccountList.SETTABLEVIEW(GLAccount);
                            GLAccountList.SETRECORD(GLAccount);
                            GLAccountList.LOOKUPMODE := TRUE;
                            IF GLAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                GLAccountList.GETRECORD(GLAccount);
                                VALIDATE("Source Code", GLAccount."No.");
                            END;
                        END;

                    "Source Type"::"Profit & Loss Line":
                        BEGIN

                            CLEAR(PLSLines);
                            PLSLine.SETRANGE("Batch Name", "PLS Batch Name");
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
        field(5; Operation; Enum "TOR Balance Operation")
        {
            Caption = 'Operation';
        }
        field(40; "Amount Type"; Enum "TOR Profit & Loss Amount Type")
        {
            Caption = 'Amount Type';

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

    keys
    {
        key(Key1; "PLS Batch Name", "PLS Line No.", "Source Type", "Source Code", "Amount Type")
        {
            Clustered = true;
        }
    }

    var
        PLSLine: Record "TOR Profit & Loss Line";
        GLAccount: Record "G/L Account";
        PLSLines: Page "TOR Profit & Loss Calc. Setup";
        GLAccountList: Page 18;
        LevelNo: Integer;
        Text0001: Label 'ENU=You can only choose previous Profit & Loss entry;PLK=Mo¾na wybra† tylko poprzedni zapis rachunku zysk¢w i strat';
        Text0006: Label 'ENU=You cannot use line with lower Level No.. Current Level No. %1, selected Level No. %2.;PLK=Nie mo¾na korzysta† z wiersza z ni¾szym nr poziomu. Bie¾¥cy Nr poziomu %1, wybrany Nr poziomu %2.';


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