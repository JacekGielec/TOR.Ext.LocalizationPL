
/// <summary>
/// TableExtension TOR Sales Header.TableExt (ID 50466) extends Record Sales Header.
/// </summary>
tableextension 50467 "TOR Sales Inv. Header.TableExt" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "TOR Retail Sales"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "TOR Prepayment Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "e-invoice"; Boolean)
        {
            Caption = 'e-invoice';
        }

    }


}
