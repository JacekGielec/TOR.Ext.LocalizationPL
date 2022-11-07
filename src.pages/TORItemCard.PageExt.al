pageextension 50503 TORItemCard extends "Item Card"
{


    layout
    {
        modify("Cost is Adjusted")
        {
            Editable = true;
            /*
            trigger OnAfterValidate()
            var
                ILE: Record "Item Ledger Entry";
            begin
                if not rec."Cost is Adjusted" then begin
                    ile.SetCurrentKey("Item No.");
                    ile.SetRange("Item No.", Rec."No.");
                    ile.ModifyAll("Applied Entry to Adjust", true);
                end;
            end;
            */
        }
        modify("Cost is Posted to G/L")
        {
            Editable = true;
        }
        addafter(Inventory)
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Category Code")
        {
            field("Fi Plan Group Code"; Rec."Fi Plan Group Code")
            {
                ApplicationArea = all;
            }
        }
    }


}