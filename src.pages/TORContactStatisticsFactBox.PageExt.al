pageextension 50518 "TOR Item Reclass Jnl" extends "Item Reclass. Journal"
{
    layout
    {
        addafter(Control1)
        {
            part(InventoryEntriesDtld; "TOR Item Ledger Entries Part")
            {
                ApplicationArea = Suite;
                //Provider=lin
                SubPageLink = "item No." = FIELD("item No.");
            }

        }
    }
}