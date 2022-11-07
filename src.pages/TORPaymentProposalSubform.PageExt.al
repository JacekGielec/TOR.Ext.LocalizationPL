pageextension 50516 "TOR Payment Prop. Subform" extends "ITI Payment Proposal Subform"
{
    layout
    {
        modify(RecipientName)
        {
            Visible = true;
        }
        modify(RecipientBankIBAN)
        {
            Visible = true;
        }
    }
}