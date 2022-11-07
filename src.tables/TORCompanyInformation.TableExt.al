#pragma warning disable DOC0101
/// <summary>
/// TableExtension TOR Item Journal Line (ID 50455) extends Record Item Journal Line.
/// </summary>
tableextension 50456 "TOR Company Info.TableExt" extends "Company Information"
#pragma warning restore DOC0101
{
    fields
    {
        field(50000; "TOR KRS"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "TOR BDO"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "TOR Reconc. Cont. No."; code[20])
        {
            Caption = 'Reconciliation Cont. No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
    }
}
