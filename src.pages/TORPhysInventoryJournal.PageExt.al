// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			04.03.21		dho         creation

/// <summary>
/// PageExtension TOR Phys. Inventory Journal (ID 50469) extends Record Phys. Inventory Journal.
/// </summary>
pageextension 50469 "TOR Phys. Inventory Journal" extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Item No.")
        {
            field("TOR Item No. 2"; Rec."TOR Item No. 2")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number 2 of the item on the journal line.';
                Editable = false;
            }
            field(ItemTrackingRequired; ItemTrackingRequired())
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Caption = 'Item Tracking Required';
            }
        }
    }

    actions
    {
        addafter(CalculateInventory)
        {
            action(AddItemTruckingLine)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Add Item Trucking Line';
                Ellipsis = true;
                Image = CalculateInventory;
                Promoted = true;
                PromotedCategory = Category5;
                Scope = Repeater;

                trigger OnAction()
                begin
                    AddItemTruckingLine();
                end;
            }
        }

        modify(Print)
        {
            Visible = false;
        }

        addafter(Print)
        {
            action("TOR Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ItemJournalTemplate: Record "Item Journal Template";
                    ItemJournalBatch: Record "Item Journal Batch";

                begin
                    ItemJournalTemplate.Get(rec."Journal Template Name");
                    ItemJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                    REPORT.RunModal(ItemJournalTemplate."Test Report ID", true, false, ItemJournalBatch);
                end;
            }
        }
    }

    local procedure AddItemTruckingLine()
    var
        TrackingSpecification: Record "Tracking Specification";
        TrackingSpecification2: Record "Tracking Specification";
        Item: Record Item;
        EntryNo: Integer;
    begin
        if Rec.Quantity <= 0 then
            exit;

        if item.get(Rec."Item No.") then begin

            item.testfield("Item Tracking Code");
            TrackingSpecification.SetRange("Item No.", Rec."Item No.");
            TrackingSpecification.SetRange("Location Code", Rec."Location Code");
            TrackingSpecification.SetRange("Source Type", 83);
            TrackingSpecification.SetRange("Source Subtype", 2);
            TrackingSpecification.setrange("Source ID", Rec."Journal Template Name");
            TrackingSpecification.SetRange("Source Batch Name", Rec."Journal Batch Name");
            TrackingSpecification.SetRange("Source Ref. No.", Rec."Line No.");
            if TrackingSpecification.IsEmpty then begin
                if TrackingSpecification2.FindLast() then
                    entryno := TrackingSpecification2."Entry No." + 1
                else
                    EntryNo := 1;
                TrackingSpecification.init;
                TrackingSpecification."Entry No." := EntryNo;
                TrackingSpecification."Item No." := Rec."Item No.";
                TrackingSpecification."Location Code" := Rec."Location Code";
                TrackingSpecification."Source Type" := 83;
                TrackingSpecification."Source Subtype" := 2;
                TrackingSpecification."Source ID" := Rec."Journal Template Name";
                TrackingSpecification."Source Batch Name" := Rec."Journal Batch Name";
                TrackingSpecification."Source Ref. No." := Rec."Line No.";
                TrackingSpecification.Validate("Quantity (Base)", Rec.Quantity);
                TrackingSpecification.Validate("Lot No.", '20200601');
                TrackingSpecification.Validate("Expiration Date", 20211231D);

                TrackingSpecification.insert(true);
            end;
        end;

    end;

    local procedure ItemTrackingRequired(): Boolean
    var
        Item: Record Item;
    begin
        if item.get(Rec."Item No.") then
            exit(item."Item Tracking Code" <> '');
    end;
}