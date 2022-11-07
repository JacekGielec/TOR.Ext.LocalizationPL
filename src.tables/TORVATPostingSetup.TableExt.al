tableextension 50478 "TOR VAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        field(50000; "Advertisement VAT"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Advertisement VAT';
        }
    }
}