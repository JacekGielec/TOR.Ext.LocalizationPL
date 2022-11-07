/// <summary>
/// PageExtension TOR Sales Order List (ID 50479) extends Record Sales Order List.
/// </summary>
pageextension 50479 "TOR Sales Order List" extends "Sales Order List"
{
    layout
    {
        addafter("External Document No.")
        {
            field("e-invoice"; Rec."e-invoice")
            {
                ApplicationArea = all;
            }
        }
        modify("Ship-to Code")
        {
            Visible = true;
        }
        modify("Salesperson Code")
        {
            Visible = true;
        }
    }
}
