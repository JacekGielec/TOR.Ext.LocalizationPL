pageextension 50483 "TOR Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Currency Factor"; GetCurrencyFactor(Rec."Currency Factor"))
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 4;

                Caption = 'Exchange Rate';
            }
        }
        /*
        addafter("Posting Description")
        {
            field("ITI Vendor Bank Account Code"; Rec."ITI Vendor Bank Account Code")
            {
                ApplicationArea = all;
            }
            field("Bank Account No."; GetBankAccNo())
            {
                ApplicationArea = all;
                Editable = false;
            }

            field("ITI SP Created Manually"; Rec."ITI SP Created Manually")
            {
                ApplicationArea = all;
            }
        }
        */
        modify("VAT Bus. Posting Group")
        {
            trigger OnAssistEdit()
            var
                Vend: Record Vendor;
                Line: Record "Purchase Line";
                VatPostingSetup: Record "VAT Posting Setup";
            begin
                vend.get(Rec."Buy-from Vendor No.");
                vend.TestField("VAT Bus. Posting Group");
                if vend."VAT Bus. Posting Group" <> Rec."VAT Bus. Posting Group" then begin
                    Rec."VAT Bus. Posting Group" := vend."VAT Bus. Posting Group";
                    Rec.Modify();


                    Line.SetRange("Document Type", Rec."Document Type");
                    line.SetRange("Document No.", Rec."No.");
                    if line.FindSet() then
                        repeat
                            if line.Type <> line.Type::" " then begin
                                line."VAT Bus. Posting Group" := vend."VAT Bus. Posting Group";
                                VatPostingSetup.Get(Line."VAT Bus. Posting Group", line."VAT Prod. Posting Group");

                                line."VAT Calculation Type" := VatPostingSetup."VAT Calculation Type";
                                line."VAT %" := VatPostingSetup."VAT %";
                                Line."VAT Identifier" := VatPostingSetup."VAT Identifier";
                                line.Validate("Direct Unit Cost");
                                line.Modify();
                            end;
                        until line.Next() = 0;
                end;
            end;
        }
    }

    local procedure GetCurrencyFactor(d: Decimal): Decimal
    begin
        if d = 0 then
            exit;

        exit(1 / d);
    end;

    /*
    local procedure GetBankAccNo(): Text[50]
    var
        VendBank: Record "Vendor Bank Account";
    begin
        if VendBank.get(Rec."Pay-to Vendor No.", Rec."ITI Vendor Bank Account Code") then
            exit(VendBank.GetBankAccountNo());
    end;
    */
}
