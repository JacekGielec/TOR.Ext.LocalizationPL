tableextension 50479 TORItem extends Item
{

    fields
    {
        field(50003; "Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(50004; "Fi Plan Group Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fi Plan Group Code';
            TableRelation = "TOR Item FI Plan Group";
        }
    }
}