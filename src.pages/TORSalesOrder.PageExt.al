/// <summary>
/// PageExtension TOR Doc. Exchange Rate Factbox (ID 50472) extends Record Sales Order.
/// </summary>
pageextension 50472 "TOR Sales Order" extends "Sales Order"
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
        addafter("Currency Code")
        {
            field("Currency Factor"; GetCurrencyFactor(Rec."Currency Factor"))
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 0 : 4;

                Caption = 'Exchange Rate';
            }
        }
        addafter("Shipping Agent Code")
        {
            field("Transport Cost"; Rec."Transport Cost")
            {
                ApplicationArea = basic, suite;
                Caption = 'Transport Cost';
            }
        }

        addafter(WorkflowStatus)
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

        addbefore(Control1906127307)
        {
            part(InventoryEntriesDtld; "TOR Item Ledger Entries Part")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "item No." = FIELD("No.");
            }
        }
        modify("Location Code")
        {
            Visible = true;
        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        //if CurrPage."Exchange Rate".Page.isVisible() then
        CurrPage."Exchange Rate".Page.UpdateRecords(Rec);
    end;

    local procedure GetCurrencyFactor(d: Decimal): Decimal
    begin
        if d = 0 then
            exit;

        exit(1 / d);
    end;
}