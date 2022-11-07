tableextension 50468 "TOR Reminder Level TableExt" extends "Reminder Level"
{
    fields
    {
        field(50450; "Responsible Person Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Code';
            TableRelation = Contact;
        }
    }
}