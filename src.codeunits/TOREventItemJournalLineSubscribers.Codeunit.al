/// <summary>
/// Codeunit Subscription CU (ID 50000).
/// </summary>
codeunit 50456 "TOR Event Item Jnl. Line Sub"
{
    //OnAfterSetupNewLine(Rec, LastItemJnlLine, ItemJnlTemplate);
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine(var ItemJournalLine: Record "Item Journal Line"; var LastItemJournalLine: Record "Item Journal Line"; ItemJournalTemplate: Record "Item Journal Template")
    var
        sourcecodesetup: Record "Source Code Setup";
    begin
        ItemJournalLine."Gen. Bus. Posting Group" := ItemJournalTemplate."Gen. Bus. Posting Group";

        ItemJournalLine.Validate("Entry Type", ItemJournalTemplate."Entry Type");
        ItemJournalLine."Location Code" := ItemJournalTemplate."Location Code";


        //ItemJournalLine.Validate("Dimension Set ID", ItemJournalTemplate."Dimension Set ID");
    end;

    //OnBeforeVerifyReservedQty(Rec, xRec, FieldNo("Item No."));
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnBeforeVerifyReservedQty', '', false, false)]
    local procedure OnBeforeVerifyReservedQty(var ItemJournalLine: Record "Item Journal Line"; xItemJournalLine: Record "Item Journal Line"; CalledByFieldNo: Integer)
    var
        ItemjournalTemplate: Record "Item Journal Template";
    begin
        if ItemJournalLine."Dimension Set ID" <> 0 then
            exit;

        if ItemJournalLine."Journal Template Name" = '' then
            exit;

        ItemjournalTemplate.Get(ItemJournalLine."Journal Template Name");
        if ItemjournalTemplate."Dimension Set ID" > 0 then
            ItemJournalLine.Validate("Dimension Set ID", ItemJournalTemplate."Dimension Set ID");
    end;
}