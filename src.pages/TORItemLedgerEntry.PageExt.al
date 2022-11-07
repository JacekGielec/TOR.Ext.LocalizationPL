pageextension 50500 "TOR Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = all;
            }
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            action(ShowPR)
            {
                ApplicationArea = All;
                Caption = 'Show PR';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ItemLines;

                trigger OnAction()
                var
                    ItemLedgEntry: Record "Item Ledger Entry";
                    ItemJnlLine: Record "Item Journal Line" temporary;
                    lineno: Integer;
                    i: Integer;
                begin
                    ItemJnlLine.DeleteAll();
                    ItemLedgEntry.CopyFilters(Rec);
                    ItemLedgEntry.SetFilter("Document No.", '%1', 'PR*');

                    Rec.ClearMarks();
                    if ItemLedgEntry.FindSet(false, false) then
                        repeat
                            if ItemLedgEntry."Document No." = 'PR-/22/0119' then begin
                                i := 1;
                            end;
                            ItemJnlLine.SetRange("Document No.", ItemLedgEntry."Document No.");
                            if not ItemJnlLine.FindFirst() then begin
                                ItemJnlLine.Init();
                                lineno += 10000;
                                ItemJnlLine."Document No." := ItemLedgEntry."Document No.";
                                ItemJnlLine."Line No." := lineno;
                                ItemJnlLine.Insert();
                            end;

                            ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                            ItemJnlLine.Amount += round(ItemLedgEntry."Cost Amount (Actual)");
                            ItemJnlLine.Modify();
                        until ItemLedgEntry.Next() = 0;

                    ItemJnlLine.Reset();
                    if ItemJnlLine.FindFirst() then
                        repeat
                            if ItemJnlLine.Amount <> 0 then begin
                                rec.SetRange("Document No.", ItemJnlLine."Document No.");
                                if rec.FindFirst() then
                                    repeat
                                        rec.Mark(true);
                                    until rec.Next() = 0;
                            end;

                        until ItemJnlLine.Next() = 0;
                    rec.SetRange("Document No.");
                    rec.MarkedOnly := true;
                end;
            }

            action(RecalcPR)
            {
                ApplicationArea = All;
                Caption = 'Recalc PR';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ItemLines;
                ShortcutKey = 'f11';

                trigger OnAction()
                var
                    ItemLedgEntry: Record "Item Ledger Entry";
                    ItemJnlLine: Record "Item Journal Line";
                    ValueEntry: Record "Value Entry";
                    d: Decimal;
                    ItemPost: Codeunit "Item Jnl.-Post";

                begin
                    ItemJnlLine.setrange("Journal Template Name", 'REVALUATIO');
                    ItemJnlLine.setrange("Journal Batch Name", 'W');
                    ItemJnlLine.DeleteAll();

                    CurrPage.SetSelectionFilter(ItemLedgEntry);
                    //Clear(ItemJnlLine);
                    if ItemLedgEntry.FindFirst() then
                        repeat
                            IF (CopyStr(ItemLedgEntry."Document No.", 1, 2) <> 'PR') then
                                error('Only For PR* documents');
                            if ItemLedgEntry.Positive then begin
                                ItemJnlLine.Init();
                                ItemJnlLine."Journal Template Name" := 'REVALUATIO';
                                ItemJnlLine."Journal Batch Name" := 'W';
                                ItemJnlLine."Line No." := 10000;
                                ItemJnlLine."Value Entry Type" := ItemJnlLine."Value Entry Type"::Revaluation;
                                ItemJnlLine."Document No." := ItemLedgEntry."Document No.";
                                ItemJnlLine."Posting Date" := ItemLedgEntry."Posting Date";
                                ItemJnlLine.Validate("Item No.", ItemLedgEntry."Item No.");
                                ItemJnlLine.validate("Entry Type", ItemLedgEntry."Entry Type");
                                ItemJnlLine.Validate("Location Code", ItemLedgEntry."Location Code");
                                ItemJnlLine.Validate(Quantity, ItemLedgEntry.Quantity);
                                ItemJnlLine."Source Code" := 'PRZESZACOW';
                                ItemJnlLine.Validate("Applies-to Entry", ItemLedgEntry."Entry No.");


                                ValueEntry.SetCurrentKey("Item Ledger Entry No.");
                                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                                if ValueEntry.FindFirst() then
                                    ItemJnlLine."Gen. Bus. Posting Group" := ValueEntry."Gen. Bus. Posting Group";
                            end else begin
                                ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                                d -= ItemLedgEntry."Cost Amount (Actual)";
                            end;
                        until ItemLedgEntry.Next() = 0;

                    if ItemJnlLine."Document No." <> '' then
                        ItemJnlLine.Validate("Inventory Value (Revalued)", d);

                    if (ItemJnlLine."Document No." <> '') and (d > 0) then begin
                        ItemJnlLine.Insert();
                        ItemPost.Run(ItemJnlLine);
                    end else
                        Message('Nothing to post');
                end;
            }
        }
    }
}