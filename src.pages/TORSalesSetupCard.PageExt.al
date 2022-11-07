/// <summary>
/// PageExtension TOR Salesperson Card (ID 50480) extends Record Salesperson/Purchaser Card.
/// </summary>
pageextension 50480 "TOR Sales Setup Card" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("ITI Get Doc. Exch.R. for Date")
        {
            field("Exchange Rate One Day Before"; Rec."Exchange Rate One Day Before")
            {
                ApplicationArea = All;
            }
            field("Def. Rem. Resp. Person Code"; Rec."Def. Rem. Resp. Person Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
