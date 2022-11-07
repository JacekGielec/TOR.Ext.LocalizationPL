//" ,Net Change,Negative Net Change,Positive Net Change"
enum 50459 "TOR Profit & Loss Amount Type"
{
    Extensible = true;
    Caption = 'Amount Type';

    value(0; " ") { }
    value(1; "Net Change")
    {
        Caption = 'Net Change';
    }
    value(2; "Negative Net Change")
    {
        Caption = 'Negative Net Change';
    }
    value(3; "Positive Net Change")
    {
        Caption = 'Positive Net Change';
    }
}