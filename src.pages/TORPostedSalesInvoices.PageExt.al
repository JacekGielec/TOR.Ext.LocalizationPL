/// <summary>
/// PageExtension TOR Posted Sales Invoice (ID 50473) extends Record Posted Sales Invoice.
/// </summary>
pageextension 50486 "TOR Posted Sales Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        addlast(processing)
        {
            action("Change Salesperson")
            {
                ApplicationArea = basic, suite;
                Caption = 'Change Salesperson';
                image = ChangeCustomer;


                trigger OnAction()
                var
                    c: Codeunit "TOR Changing Posted Document";
                begin
                    c.ChangeSalesPersonOnPostedSalesInvoice(Rec);
                end;
            }
        }
    }
}

