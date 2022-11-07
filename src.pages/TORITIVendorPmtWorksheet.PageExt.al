pageextension 50501 "TOR.ITI Vendor Pmt. Worksheet" extends "ITI Vendor Pmt. Worksheet"
{

    layout
    {
        modify(TransferAmount)
        {
            BlankZero = true;
        }
        modify("ITI VAT Amount")
        {
            BlankZero = true;
        }

        addafter(OnHold)
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = all;
            }
        }


    }



    trigger OnOpenPage()
    begin
        Clear(BankAccount);
        SetShowEntriesOption();
        SetShowEntriesOption2();
        UpdateTotals();
    end;

    protected var
        BankAccount: Record "Bank Account";
        BankTransferHeader2: Record "ITI Payment Proposal Header";

    procedure SetShowEntriesOption2()
    begin
        Rec.FilterGroup(2);

        //Rec.SetCurrentkey(Positive, Open, "Due Date", "Vendor No.", "Currency Code", "Pmt. Discount Date");
        Rec.SetRange("due date", 0D, WorkDate());
        Rec.SetRange("currency code", BankTransferHeader2."Sender Bank Currency Code");
        Rec.FilterGroup(0);
    end;

    procedure SetBankTransferHeader2(NewBankTransferHeader: Record "ITI Payment Proposal Header")
    begin
        BankTransferHeader2 := NewBankTransferHeader;
    end;

}