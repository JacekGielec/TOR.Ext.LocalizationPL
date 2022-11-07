// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			15.01.21		dho     Creation on Request of Kurt Marschall

/// <summary>
/// PageExtension TOR Sales Order Subform (ID 50450) extends Record Sales Order Subform.
/// </summary>
pageextension 50450 "TOR Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Item Tracking Code Exist"; ItemTrackingCodeExists())
            {
                Caption = 'Item Tracking Code Exists';
                ApplicationArea = all;
            }
        }
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Amount Including VAT';
            }
        }

        modify("Line Discount %")
        {
            trigger OnAssistEdit()
            var
                p: page TorManyDiscSalesLine;
            begin
                Rec.TestField("Unit Price");
                Rec.TestStatusOpen();
                Clear(p);
                p.LookupMode := true;
                p.SetRecord(Rec);
                if p.RunModal() = Action::LookupOK then
                    CurrPage.Update(false);
            end;
        }
    }

    local procedure ItemTrackingCodeExists(): Boolean
    var
        item: Record item;
    begin
        if Rec.Type <> Rec.Type::Item then
            exit(false);

        if not item.Get(Rec."No.") then
            exit(false);

        exit(item."Item Tracking Code" <> '');
    end;
}