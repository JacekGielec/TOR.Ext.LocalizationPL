//Balance at Date,Customer Debit,Customer Credit,Vendor Debit,Vendor Credit,Negative Balance at Date,Positive Balance at Date
enum 50455 "TOR Balance Amount Type"
{
    Extensible = true;
    Caption = 'Amount Type';

    value(0; "Balance at Date")
    {
        Caption = 'Balance at Date';
    }
    value(1; "Customer Debit")
    {
        Caption = 'Customer Debit';
    }
    value(2; "Customer Credit")
    {
        Caption = 'Customer Credit';
    }
    value(3; "Vendor Debit")
    {
        Caption = 'Vendor Debit';
    }
    value(4; "Vendor Credit")
    {
        Caption = 'Vendor Credit';
    }
    value(5; "Negative Balance at Date")
    {
        Caption = 'Negative Balance at Date';
    }
    value(6; "Positive Balance at Date")
    {
        Caption = 'Positive Balance at Date';
    }
}