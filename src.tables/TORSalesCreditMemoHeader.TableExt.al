tableextension 50471 "TOR Sales Cr. Header.TableExt" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50100; "Confirmation Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50101; "Confirmed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Corrected Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Corrected Document No.';
            TableRelation = "Sales Invoice Header";
        }
    }
}

