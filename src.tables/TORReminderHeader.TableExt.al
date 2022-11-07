tableextension 50469 "TOR Reminder Header TableExt" extends "Reminder Header"
{
    fields
    {
        field(50450; "Responsible Person Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person Code';
            TableRelation = Contact;

            trigger OnValidate()
            var
                Cont: Record Contact;
            begin
                Cont.Get("Responsible Person Code");
                "Responsible Person Name" := cont.Name;
                "Responsible Person Mail" := cont."E-Mail";
                "Responsible Person Phone No." := cont."Phone No.";
                "Resp. Person Mobile Phone No." := cont."Mobile Phone No.";
            end;
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