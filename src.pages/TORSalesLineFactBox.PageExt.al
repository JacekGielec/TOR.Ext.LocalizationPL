pageextension 50514 TORSalesLineFactBox extends "Sales Line FactBox"
{
    layout
    {
        addafter(UnitofMeasureCode)
        {
            field("Item Qty."; ItemQty())
            {
                ApplicationArea = all;
                Caption = 'Item Qty.';
                DrillDown = true;

                trigger OnDrillDown()
                var
                    iles: page "Item Ledger Entries";
                    ile: Record "Item Ledger Entry";
                begin
                    CurrPage.SaveRecord();
                    ile.SetCurrentKey("Item No.", Open);
                    ile.SetRange("Item No.", Rec."No.");
                    ile.SetRange(Open, true);
                    Clear(iles);
                    iles.SetTableView(ile);
                    iles.Run();
                    CurrPage.Update(true);

                end;
            }
        }
    }

    local procedure ItemQty(): Decimal
    var
        item: Record Item;
    begin
        if item.get(Rec."No.") then begin
            item.CalcFields(Inventory);
            exit(item.Inventory);
        end;
    end;
}