/// <summary>
/// PageExtension TOR General Journal (ID 50471) extends Record General Journal.
/// </summary>
pageextension 50471 "TOR General Journal" extends "General Journal"
{
    layout
    {
        addbefore("Bal. Account Type")
        {
            field("ITI Bal. Doc. Rcpt/Sales Date"; Rec."ITI Bal. Doc. Rcpt/Sales Date")
            {
                ApplicationArea = All;
                ToolTip = 'ITI Bal. Doc. Rcpt/Sales Date';
            }
        }

        addbefore("Total Debit")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }

            group(TotalDebitDI)
            {
                Caption = 'Total Debit';
                field("Total Debit DI"; GetTotalDebitAmt2())
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the total debit amount in the general journal.';
                }
            }
        }

        addbefore("Total Credit")
        {
            group(TotalCreditDI)
            {
                Caption = 'Total Credit';
                field("Total Credit DI"; GetTotalCreditAmt2())
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the total credit amount in the general journal.';
                }
            }
        }

        addbefore("Control30")
        {
            group("Exchange Rate")
            {
                ShowCaption = false;
                Visible = Rec."Currency Code" <> '';
                field("Currency Exchange"; GetCurrencyFactor(Rec."Currency Factor"))
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 4;

                    Caption = 'Exchange Rate';
                }
            }
        }

        modify("Total Debit")
        {
            Visible = false;
        }

        modify("Total Credit")
        {
            Visible = false;
        }
        /*
        addbefore(Balance)
        {
            field(BalanceBI; BalanceBI + BalanceBI - GetDocumentBalance2())
            {
                ApplicationArea = Basic, Suite;
                //Caption = 'Total Debit';
                Editable = false;
                ToolTip = 'Specifies the total debit amount in the general journal.';
            }
        }

        addbefore("TotalBalance")
        {
            field(TotalBalance2; GetDocumentBalance2())
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Specifies the total credit amount in the general journal.';
            }
        }
        */
    }
    /*
    addafter("Total Credit DI")
    {
        group("Balance DI")
        {
            Caption = 'Balance';
            field(BalanceDI; BalanceDI + Rec."Balance (LCY)" - xRec."Balance (LCY)")
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Balance';
                Editable = false;
                ToolTip = 'Specifies the balance that has accumulated in the general journal on the line where the cursor is.';
            }
        }
    }

    addafter("Balance DI")
    {
        group("Total Balance DI")
        {
            Caption = 'Total Balance';
            field(TotalBalanceDI; TotalBalanceDI + Rec."Balance (LCY)" - xRec."Balance (LCY)")
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Total Balance';
                Editable = false;
                ToolTip = 'Specifies the total balance in the general journal.';
            }
        }
    }
    */

    var
        BalanceDI: Decimal;
        TotalBalanceDI: Decimal;

    local procedure GetCurrencyFactor(d: Decimal): Decimal
    begin
        if d = 0 then
            exit;

        exit(1 / d);
    end;

    local procedure GetTotalDebitAmt2(): Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        //GenJournalLine.SetRange("Document No.", CurrentDocNo);
        GenJournalLine.CalcSums("Debit Amount");
        exit(GenJournalLine."Debit Amount");
    end;

    local procedure GetTotalCreditAmt2(): Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        //GenJournalLine.SetRange("Document No.", CurrentDocNo);
        GenJournalLine.CalcSums("Credit Amount");
        exit(GenJournalLine."Credit Amount");
    end;

    local procedure GetDocumentBalance2(): Decimal
    var
        DocGenJournalLine: Record "Gen. Journal Line";
    begin
        DocGenJournalLine.CopyFilters(Rec);
        //DocGenJournalLine.SetRange("Posting Date", GenJournalLine."Posting Date");
        //if GenJnlTemplate.Get(GenJournalLine."Journal Template Name") and GenJnlTemplate."Force Doc. Balance" then begin
        //    DocGenJournalLine.SetRange("Document No.", GenJournalLine."Document No.");
        //    DocGenJournalLine.SetRange("Document Type", GenJournalLine."Document Type");
        //end;
        DocGenJournalLine.CalcSums("Amount");
        exit(DocGenJournalLine."Amount");
    end;

    var
        CurrentDocNo: Code[20];
}