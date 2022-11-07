tableextension 50470 "TOR Iss. Rem. Header TableExt" extends "Issued Reminder Header"
{
    fields
    {
        field(50450; "Responsible Person Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Code';
            TableRelation = Contact;
        }
        field(50451; "Responsible Person Name"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Name';
        }
        field(50452; "Responsible Person Phone No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Phone No.';
        }
        field(50453; "Resp. Person Mobile Phone No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Mobile Phone No.';
        }
        field(50454; "Responsible Person Mail"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Mail';
        }
    }
}