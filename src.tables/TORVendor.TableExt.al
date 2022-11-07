
/// <summary>
/// TableExtension TOR Vendor.TableExt.al (ID 50462) extends Record Vendor.
/// 
/// </summary>
tableextension 50462 "TOR Vendor.TableExt" extends Vendor
{
    fields
    {
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


    }

    var
        ERRCurrencyCode: Label 'You cannot use LCY in %1';
}
