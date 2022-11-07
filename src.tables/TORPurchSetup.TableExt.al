tableextension 50458 "TOR Purch. Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Exchange Rate One Day Before"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exchange Rate One Day Before';
        }
    }
}
