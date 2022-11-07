tableextension 50484 "TOR Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(50000; "Bank Trans. Recalculation"; Code[10])
        {
            Caption = 'Bank Trans. Recalculation';
            TableRelation = "Source Code";
        }
    }
}