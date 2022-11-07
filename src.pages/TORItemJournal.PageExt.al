pageextension 50517 "TOR Item Journal" extends "Item Journal"
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