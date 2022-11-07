page 50501 TorManyDiscSalesLine
{
    PageType = Card;
    SourceTable = "Sales Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Many Sales Line Discount';

    layout
    {
        area(Content)
        {
            group(OrderData)
            {
                Caption = 'Order Data';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group(DiscountGroupName)
            {
                Caption = 'Discount Group Name';
                field("Line Discount % 1"; Rec."Line Discount % 1")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount % 1';
                }
                field("Line Discount % 2"; Rec."Line Discount % 2")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount % 2';
                }
                field("Line Discount % 3"; Rec."Line Discount % 3")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount % 3';
                }
                field("Line Discount % 4"; Rec."Line Discount % 4")
                {
                    ApplicationArea = All;
                    Caption = 'Line Discount % 4';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Price After Disc."; GetUnitPriceAfter())
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Unit Price After Disc.';
                }
                field("Line amount"; Rec."Line amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure GetUnitPriceAfter(): Decimal
    begin
        exit(Round(Rec."Unit Price" * (1 - Rec."Line Discount %" / 100)));
    end;
}