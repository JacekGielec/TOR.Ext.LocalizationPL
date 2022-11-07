
/// <summary>
/// TableExtension TOR Customer.TableExt.al (ID 50461) extends Record Customer.
/// 
/// </summary>
tableextension 50461 "TOR Customer.TableExt" extends Customer
{
    fields
    {
        field(50000; "Cust. Delivery Document"; Boolean)
        {
            Caption = 'Cust. Delivery Document';
        }

        field(50007; "Factoring Std. Text Code"; Code[20])
        {
            Caption = 'Factoring Std. Text Code';
            TableRelation = "Standard Text";
        }

        field(50008; "Mixer"; Boolean)
        {
            Caption = 'Mixer';
        }

        field(50009; "Pallet Cost Text"; Text[100])
        {
            Caption = 'Pallet Cost Text';
        }
        field(50010; "e-invoice"; Boolean)
        {
            Caption = 'e-invoice';
        }


        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                if "Currency Code" = GLSetup."LCY Code" then
                    Error(ERRCurrencyCode, FieldName("Currency Code"));
            end;
        }
        modify("Customer Posting Group")
        {
            trigger OnAfterValidate()
            var
                CustPostGroup: Record "Customer Posting Group";
            begin
                if Rec."Reminder Terms Code" = '' then begin
                    if CustPostGroup.Get("Customer Posting Group") then
                        Rec."Reminder Terms Code" := CustPostGroup."Reminder Terms Code";
                end;
            end;
        }


    }

    var
        ERRCurrencyCode: Label 'You cannot use LCY in %1';
}
