pageextension 50515 "TOR G/L Account List" extends "Chart of Accounts"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("ITI Customer Debit Amount"; Rec."ITI Customer Debit Amount")
            {
                ApplicationArea = all;
            }
            field("ITI Customer Credit Amount"; Rec."ITI Customer Credit Amount")
            {
                ApplicationArea = all;
            }
            field("ITI Vendor Debit Amount"; Rec."ITI Vendor Debit Amount")
            {
                ApplicationArea = all;
            }
            field("ITI Vendor Credit Amount"; Rec."ITI Vendor Credit Amount")
            {
                ApplicationArea = all;
            }
        }
    }

}