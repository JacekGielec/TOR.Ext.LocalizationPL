/// <summary>
/// PageExtension TOR General Journal (ID 50471) extends Record General Journal.
/// </summary>
pageextension 50487 "TOR Item Journal Template" extends "Item Journal Templates"
{

    layout
    {
        addafter(Type)
        {
            field("Entry Type"; Rec."Entry Type")
            {
                ApplicationArea = all;
            }
        }
        addafter("Entry Type")
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Source Code")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("Gen. Bus. Posting Group")
        {
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
            }
        }

        addafter("Shortcut Dimension 1 Code")
        {
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
                Visible = false;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field(ShortcutDimCode3; ShortcutDimCode[3])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,3';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);

                    OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 3);
                end;
            }
        }
        addafter(ShortcutDimCode3)
        {
            field(ShortcutDimCode4; ShortcutDimCode[4])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);

                    OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 4);
                end;
            }
        }
        addafter(ShortcutDimCode4)
        {
            field(ShortcutDimCode5; ShortcutDimCode[5])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,5';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                //Visible = DimVisible5;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);

                    OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 5);
                end;
            }
        }
        addafter(ShortcutDimCode5)
        {
            field(ShortcutDimCode6; ShortcutDimCode[6])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,6';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);

                    OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 6);
                end;
            }
        }
        addafter(ShortcutDimCode6)
        {
            field(ShortcutDimCode7; ShortcutDimCode[7])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,7';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);

                    OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 7);
                end;
            }
        }
        addafter(ShortcutDimCode7)
        {
            field(ShortcutDimCode8; ShortcutDimCode[8])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,8';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);

                    OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 8);
                end;
            }
        }
    }



    var
        DimMgt: Codeunit DimensionManagement;
        ShortcutDimCode: array[8] of Code[20];


    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var ItemJournalTemplate: Record "Item Journal Template"; var xItemJournalTemplate: Record "Item Journal Template"; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var ItemJournalTemplate: Record "Item Journal Template"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    begin
    end;
}

