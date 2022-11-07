/// <summary>
/// PageExtension TOR Sales Invoice (ID 50474) extends Record Sales Invoice.
/// </summary>
pageextension 50474 "TOR Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addafter("No.")
        {
            field("TOR Prepayment Invoice"; Rec."TOR Prepayment Invoice")
            {
                ApplicationArea = all;
            }
            field("TOR Retail Sales"; Rec."TOR Retail Sales")
            {
                ApplicationArea = all;
            }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part("Exchange Rate"; "TOR Doc. Exchange Rate Factbox")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Exchange Rate';
                /*
                SubPageLink = "Currency Code" = field("Currency Code"),
                              "Relational Currency Code" = const(' '),
                              "Starting Date" = field(upperlimit("Posting Date"));
                SubPageView = sorting("Starting Date") order(descending);
                */
                //Visible = false;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //if CurrPage."Exchange Rate".Page.isVisible() then
        CurrPage."Exchange Rate".Page.UpdateRecords(Rec);
    end;
}