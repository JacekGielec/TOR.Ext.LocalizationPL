pageextension 50495 "TOR SAF-T VAT" extends "ITI SAF-T VAT"
{
    actions
    {
        addafter(Export)
        {
            action(ChangeStatus)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Status';
                Enabled = Rec.Status = Rec.Status::Exported;
                Image = Status;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+Shift+F9';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Confirmed;

                end;
            }


        }

        addafter("Calculate&Suggest")
        {
            action("TORCalculate&Suggest")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TOR Calculate & Suggest';
                Enabled = Rec.Status = Rec.Status::Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CalculateVAT;

                trigger OnAction()
                var
                    SuggestSAFTVATDecElem: Codeunit "TOR SuggestSAFTVATDecElem";
                begin
                    Rec.CalculateValues;
                    SuggestSAFTVATDecElem.Run(Rec);
                end;
            }
        }
    }
}