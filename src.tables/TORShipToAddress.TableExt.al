tableextension 50452 "Ship-To Address.TableExt.al" extends "Ship-to Address"
{
    fields
    {
        field(50000; "DI Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';

            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                sp: Record "Salesperson/Purchaser";
            begin
                sp.Get(rec."DI Salesperson Code");
                "DI Salesperson Name" := sp.Name;
            end;
        }
        field(50001; "DI Salesperson Name"; Text[100])
        {
            Caption = 'Salesperson Name';
            Editable = false;

        }
    }
}
