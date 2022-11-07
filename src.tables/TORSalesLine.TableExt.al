tableextension 50475 TORSalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; "Line Discount % 1"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount % 1';
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                CalcDiscount();
            end;
        }
        field(50001; "Line Discount % 2"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount % 2';
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                CalcDiscount();
            end;
        }
        field(50002; "Line Discount % 3"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount % 3';
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                CalcDiscount();
            end;
        }
        field(50003; "Line Discount % 4"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line Discount % 4';
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                CalcDiscount();
            end;
        }
    }

    var
        myInt: Integer;

    local procedure CalcDiscount()
    var
        d, p, p2 : Decimal;
        d1, d2, d3, d4 : Decimal;
    begin

        p := "Unit Price";
        p2 := p * (1 - "Line Discount % 1" / 100);
        p2 := p2 * (1 - "Line Discount % 2" / 100);
        p2 := p2 * (1 - "Line Discount % 3" / 100);
        p2 := p2 * (1 - "Line Discount % 4" / 100);
        d := p2 / p;
        Validate("Line Discount %", (1 - d) * 100);
    end;
}