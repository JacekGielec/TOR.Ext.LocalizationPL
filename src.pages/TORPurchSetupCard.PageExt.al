pageextension 50481 "TOR Purch. Setup Card" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("ITI Get Doc. Exch.R. for Date")
        {
            field("Exchange Rate One Day Before"; Rec."Exchange Rate One Day Before")
            {
                ApplicationArea = All;
            }
        }
    }
}
