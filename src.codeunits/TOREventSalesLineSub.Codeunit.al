/// <summary>
/// Codeunit TOR Event Sales Header Sub DI (ID 50452).
/// </summary>
codeunit 50458 "TOR Event Sales Line"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure OnAfterValidateLineDiscount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if CurrFieldNo = Rec.FieldNo("Line Discount %") then begin
            Rec."Line Discount % 1" := 0;
            Rec."Line Discount % 2" := 0;
            Rec."Line Discount % 3" := 0;
            Rec."Line Discount % 4" := 0;

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        item: Record Item;
    begin
        if Rec.Type <> rec.Type::Item then
            exit;

        if item.Get(Rec."No.") then
            //if Rec."Location Code" = '' then
                Rec."Location Code" := item."Location Code";
    end;
}