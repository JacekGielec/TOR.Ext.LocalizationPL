/// <summary>
/// Codeunit Subscription CU (ID 50000).
/// </summary>
codeunit 50461 "TOR Event Item Jnl. Post Line"
{
    //OnAfterApplyItemLedgEntrySetFilters(ToItemLedgEntry, FromItemLedgEntry, ItemJnlLine);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterApplyItemLedgEntrySetFilters', '', false, false)]
    local procedure OnAfterApplyItemLedgEntrySetFilters(var ItemLedgerEntry2: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        if ItemLedgerEntry."Lot No." = '' then
            exit;

        if ItemLedgerEntry.GetFilter("Lot No.") <> '' then
            exit;

        ItemLedgerEntry2.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
    end;
}