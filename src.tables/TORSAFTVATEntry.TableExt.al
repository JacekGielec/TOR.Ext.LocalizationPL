tableextension 50480 "TOR SAF-T VAT Entry" extends 52063276
{
    fields
    {
        field(50000; Amount; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("ITI Detailed SAF-T VAT Entry".Amount where("SAF-T VAT Entry No." = field("Entry No."),
            "Element Name" = field("Element Name Filter")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50100; "Element Name Filter"; Code[10])
        {
            Caption = 'Element Name Filter';
            FieldClass = FlowFilter;
            TableRelation = "ITI SAF-T VAT Element"."Element Name" WHERE("Version Code" = FIELD("Version Code"));
        }
    }
}