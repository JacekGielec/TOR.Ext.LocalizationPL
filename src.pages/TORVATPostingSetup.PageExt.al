pageextension 50504 "TOR VAT Posting Setup" extends "VAT Posting Setup"
{
    layout
    {
        addlast(content)
        {
            field("Advertisement VAT"; Rec."Advertisement VAT")
            {
                ApplicationArea = all;
            }
        }
    }
}