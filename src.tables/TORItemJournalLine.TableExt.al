// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			04.03.21		dho         creation

/// <summary>
/// TableExtension TOR Item Journal Line (ID 50455) extends Record Item Journal Line.
/// </summary>
tableextension 50455 "TOR Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50450; "TOR Item No. 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item No. 2';
            /*
            trigger OnValidate()
            var
                Item: Record Item;
                ErrMsg: Label 'Item No. 2 "%1" not found!', comment = '%1 = Item No. 2 of the item not found';
            begin
                if ("TOR Item No. 2" <> xRec."TOR Item No. 2") then begin
                    Item.SetRange("No. 2", "TOR Item No. 2");
                    If Item.FindFirst() then
                        Rec.Validate("Item No.", Item."No.")
                    else
                        Error(ErrMsg, "TOR Item No. 2");
                end;
            end;
            */
        }

    }

}