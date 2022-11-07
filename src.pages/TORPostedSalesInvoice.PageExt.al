/// <summary>
/// PageExtension TOR Posted Sales Invoice (ID 50473) extends Record Posted Sales Invoice.
/// </summary>
pageextension 50473 "TOR Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("EOS Exclude from Commission")
        {
            field("e-invoice"; Rec."e-invoice")
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
