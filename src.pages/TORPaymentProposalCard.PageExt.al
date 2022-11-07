pageextension 50509 "TOR Payment Proposal Card" extends "ITI Payment Proposal Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(VendorPaymentWorksheet)
        {
            action(VendorPaymentWorksheet2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TOR Vendor Payment Worksheet';
                Image = VendorPaymentJournal;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Open the Vendor Payment Worksheet page to view all ledger entries for your vendors.';
                trigger OnAction()
                var
                    ITIVendorPmtWorksheet: Page "ITI Vendor Pmt. Worksheet";
                begin
                    ITIVendorPmtWorksheet.SetBankTransferHeader(Rec);
                    ITIVendorPmtWorksheet.SetBankTransferHeader2(Rec);
                    ITIVendorPmtWorksheet.RunModal();
                end;
            }

            action(SuggestVATAmount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TOR Suggest VAT Amount';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Category5;
                ShortcutKey = 'F11';
                trigger OnAction()
                var
                    DtldLine: Record "ITI Det. Payment Proposal Line";
                    VATMgt: Codeunit "ITI VAT Management";
                    PayPropLine: Record "ITI Payment Proposal Line";
                    d: Decimal;
                begin
                    clear(PayPropLine);
                    CurrPage.ITIPaymentProposalSubform.Page.GetRecord(PayPropLine);
                    DtldLine.SetRange("Document No.", Rec."No.");
                    DtldLine.SetRange("Document Line No.", PayPropLine."Line No.");
                    if dtldline.FindSet(false, false) then begin
                        d := vatmgt.CalculateVATRemainingAmt(DtldLine."Recipient Entry No.");

                        dtldline.validate("VAT Amount", -d);
                        DtldLine.Modify(true);

                        PayPropLine.SetRange("Document No.", Rec."No.");
                        PayPropLine.SetRange("Line No.", PayPropLine."Line No.");
                        if PayPropLine.FindSet(false, false) then begin
                            if d <> 0 then begin
                                PayPropLine.validate("Transfer Type", 'SP');
                                //PayPropLine.Modify();
                            end else
                                PayPropLine.validate("Transfer Type", '');
                            //PayPropLine.Modify();
                        end;
                    end;
                    CurrPage.Update(false);
                end;
            }
        }

        modify(VendorPaymentWorksheet)
        {
            Visible = false;
        }
    }
}