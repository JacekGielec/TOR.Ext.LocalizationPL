tableextension 50457 "TOR Sales Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Exchange Rate One Day Before"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exchange Rate One Day Before';
        }
        field(50001; "Def. Rem. Resp. Person Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default Reminder Responsible Person Code';
            TableRelation = Contact;
        }
    }
}
