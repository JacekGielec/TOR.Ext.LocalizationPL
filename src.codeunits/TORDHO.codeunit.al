// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			21.01.21		dho         creation

/// <summary>
/// Codeunit TOR DHO (ID 50450).
/// </summary>
codeunit 50450 "TOR DHO"
{
    //TableNo = "EOS Data Migration Record";

    trigger OnRun()
    begin

    end;

    /// <summary>
    /// createNewBinsAndReclassificationJournal.
    /// </summary>
    /// <param name="EOSDataMigrationRecord">Record "EOS Data Migration Record".</param>
    /// <returns>Return value of type Boolean.</returns>
    /*
    procedure createNewBinsAndReclassificationJournal(var EOSDataMigrationRecord: Record "EOS Data Migration Record"): Boolean
    var
        Item: Record Item;
        Log: Codeunit "EOS Data Migration Log";
        Bin: Code[20];
    begin
        LogFile := 'BinAndReclasssification.log';
        Log.Openlog(TempEOSDataMigrationSession);
        //EOSDataMigrationRecord.SetFilter(Url, '%1', 'Inventory*');
        if EOSDataMigrationRecord.FindSet() then
            repeat
                //Check if it's an Inventory Line
                if StrPos(EOSDataMigrationRecord.Url, 'Inventory') > 0 then begin
                    //Find Item
                    item.SetRange("No. 2", CopyStr(EOSDataMigrationRecord.OldCustomerNo, 1, 12));
                    if not item.FindFirst() then
                        Log.Log('Error: Item not found!', EOSDataMigrationRecord.OldCustomerNo)
                    else begin
                        //Find new Bin
                        Bin := getBin(Item."Item Type", EOSDataMigrationRecord.Bin1);
                        if Bin = 'false' then
                            Log.Log('Error: Bin not found!', EOSDataMigrationRecord.OldCustomerNo + ' ' + Item."Item Type" + ' ' + EOSDataMigrationRecord.Bin1)
                        else begin
                            //Create BinContent
                            CreateBinContent(Item, 'MAIN', Bin, true);
                            //Create Item Journal Lines
                            if not CreateItemJournalLine(Item."No.", 'PRZESUNIĘC', 'DOMYŚLNY', 'MAIN', 'MAIN', Bin, 0) then
                                Log.Log('Error: Could not create Item Journal Line!', Item."No.")
                            else
                                Log.Log('Success: Could not create Item Journal Line!', Item."No.");
                        end;
                    end;
                end;
            until EOSDataMigrationRecord.Next() = 0;
        Log.CloseLog(LogFile);
    end;
    */

    /// <summary>
    /// MoveToDomar.
    /// </summary>
    /// <param name="EOSDataMigrationRecord">VAR Record "EOS Data Migration Record".</param>
    /// <returns>Return value of type Boolean.</returns>
    /*
    procedure MoveToDomar(var EOSDataMigrationRecord: Record "EOS Data Migration Record"): Boolean
    var
        Item: Record Item;
        Log: Codeunit "EOS Data Migration Log";
        //Bin: Code[20];
        Quantity: Decimal;
    begin
        LogFile := 'DOMAR.log';
        Log.Openlog(TempEOSDataMigrationSession);
        //EOSDataMigrationRecord.SetFilter(Url, '%1', 'Inventory*');
        if EOSDataMigrationRecord.FindSet() then
            repeat
                //Check if it's an Domar Line
                if StrPos(EOSDataMigrationRecord.Url, 'Domar') > 0 then begin
                    //Find Item
                    item.SetRange("No. 2", CopyStr(EOSDataMigrationRecord.OldCustomerNo, 1, 12));
                    if not item.FindFirst() then
                        Log.Log('Error: Item not found!', EOSDataMigrationRecord.OldCustomerNo)
                    else
                        //Create BinContent
                        if not CreateBinContent(Item, 'MAIN', 'DOMAR', true) then
                            Log.Log('Error: Could not create new Bin Content!', Item."No." + ' ' + 'DOMAR')
                        else begin
                            //Create Item Journal Lines
                            evaluate(Quantity, EOSDataMigrationRecord."Text50 1");
                            if not CreateItemJournalLine(Item."No.", 'PRZESUNIĘC', 'DOMYŚLNY', 'MAIN', 'EXT', 'DOMAR', Quantity) then
                                Log.Log('Error: Could not create Item Journal Line!', EOSDataMigrationRecord.OldCustomerNo)
                            else
                                Log.Log('Success: Item Journal Line created!', EOSDataMigrationRecord.OldCustomerNo);
                        end;
                end;
            until EOSDataMigrationRecord.Next() = 0;
        Log.CloseLog(LogFile);
    end;
    */

    /// <summary>
    /// MoveToDamaged.
    /// </summary>
    /// <param name="EOSDataMigrationRecord">VAR Record "EOS Data Migration Record".</param>
    /// <returns>Return value of type Boolean.</returns>
    /*
    procedure MoveToDamaged(var EOSDataMigrationRecord: Record "EOS Data Migration Record"): Boolean
    var
        Item: Record Item;
        Log: Codeunit "EOS Data Migration Log";
        Bin: Code[20];
        Quantity: Decimal;
    begin
        LogFile := 'DAMAGED.log';
        Log.Openlog(TempEOSDataMigrationSession);
        //EOSDataMigrationRecord.SetFilter(Url, '%1', 'Inventory*');
        if EOSDataMigrationRecord.FindSet() then
            repeat
                //Check if it's an Inventory Line for Damaged Materials
                if StrPos(EOSDataMigrationRecord.Url, 'Inv_Damaged') > 0 then begin
                    //Find Item
                    item.SetRange("No. 2", CopyStr(EOSDataMigrationRecord.OldCustomerNo, 1, 12));
                    if not item.FindFirst() then
                        Log.Log('Error: Item not found!', EOSDataMigrationRecord.OldCustomerNo)
                    else begin
                        //Find new Bin
                        Bin := getBin(Item."Item Type", EOSDataMigrationRecord.Bin1);
                        if Bin = 'false' then
                            Log.Log('Error: Bin not found!', EOSDataMigrationRecord.OldCustomerNo + ' ' + Item."Item Type" + ' ' + EOSDataMigrationRecord.Bin1)
                        else begin
                            //Create BinContent
                            CreateBinContent(Item, 'MAIN', Bin, false);
                            //Create Item Journal Lines
                            evaluate(Quantity, EOSDataMigrationRecord."Text50 1");
                            if not CreateItemJournalLine(Item."No.", 'PRZESUNIĘC', 'DOMYŚLNY', 'MAIN', 'MAIN', Bin, Quantity) then
                                Log.Log('Error: Could not create Item Journal Line!', EOSDataMigrationRecord.OldCustomerNo)
                            else
                                Log.Log('Success: created Bin Content and Item Journal Line!', Item."No.");
                        end;
                    end;
                end;
            until EOSDataMigrationRecord.Next() = 0;
        Log.CloseLog(LogFile);
    end;
    */
    local procedure getBin(ItemType: Code[20]; OldBin: Text[10]): Code[20]
    begin
        case Itemtype of
            'wyr':
                case OldBin of
                    '101':
                        exit('PRO-001');
                    '102':
                        exit('PRO-002');
                    '108':
                        exit('PRO-003');
                    '103':
                        exit('PRO-004');
                    '106', '107':
                        exit('PRO-006');
                    '111', '205':
                        exit('PRO-009');
                end;
            'tow':
                case OldBin of
                    '201':
                        exit('COM-001');
                    '200':
                        exit('COM-002');
                    '204', '7':
                        exit('COM-003');
                    '211', '212':
                        exit('COM-004');
                    '111', '205':
                        exit('PRO-009');
                end;
            'mat':
                case OldBin of
                    '3', '4', '10':
                        exit('OTH-001');
                    '5':
                        exit('OTH-003');
                    '2':
                        exit('PAC-001');
                    '1':
                        exit('RAW-001');
                    '105':
                        exit('SEM-001');
                end;
        end;
        exit('false');
    end;

    local procedure CreateBinContent(var Item: Record Item; Location: Code[10]; BinCode: Code[20]; setDefault: Boolean): Boolean
    var
        BinContent: Record "Bin Content";
    begin
        //check if not empty
        if (Item."No." = '') or (BinCode = 'FALSE') then
            exit(false);
        //delete Default Flag
        if setDefault then begin
            BinContent.SetRange("Location Code", Location);
            BinContent.SetRange("Item No.", Item."No.");
            BinContent.SetRange("Unit of Measure Code", Item."Base Unit of Measure");
            BinContent.SetRange(Default, true);
            if BinContent.FindFirst() then begin
                BinContent.Default := false;
                BinContent.Modify(true);
            end;
        end;
        //create new BinContent Entry
        BinContent.Reset();
        BinContent.Init();
        BinContent.Validate("Location Code", Location);
        BinContent.Validate("Bin Code", BinCode);
        BinContent.Validate("Item No.", Item."No.");
        BinContent.Fixed := true;
        if setDefault then
            BinContent.Default := true;
        exit(BinContent.Insert());
    end;

    local procedure CreateItemJournalLine(ItemNo: code[20]; ItemJournalTemplateName: code[10]; ItemJournalBatchName: code[10]; LocationFrom: code[10]; LocationTo: code[10]; BinTo: code[20]; Quantity: Decimal): Boolean
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalTemplate: Record "Item Journal Template";
        BinContent: Record "Bin Content";
        Item: Record Item;
        LineNo: Integer;
    begin
        //If Location is empty then use MAIN
        if LocationFrom = '' then
            LocationFrom := 'MAIN';
        If LocationTo = '' then
            LocationTo := 'MAIN';
        //Check if Item exists
        if not Item.Get(ItemNo) then
            exit(false);
        //Check if Bins exist
        if not BinContent.Get(LocationTo, BinTo, Item."No.", '', Item."Base Unit of Measure") then
            exit(false);
        if not BinContent.Get(LocationFrom, Item."Item Type", Item."No.", '', Item."Base Unit of Measure") then
            exit(false);
        //Check if ther is Qty
        BinContent.CalcFields("Quantity (Base)");
        if (BinContent."Quantity (Base)" <= 0) then
            exit(false);
        //Get Template and Batch
        if not ItemJournalTemplate.Get(ItemJournalTemplateName) then
            exit(false);
        if not ItemJournalBatch.Get(ItemJournalTemplateName, ItemJournalBatchName) then
            exit(false);
        //Find Next LineNo
        //if LineNo <> 0 then begin
        ItemJournalLine.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);
        if ItemJournalLine.FindLast() then
            LineNo := ItemJournalLine."Line No.";
        //end;
        LineNo += 10000;

        //Create Item Journal Line
        ItemJournalLine.Init();
        //Assign Template
        ItemJournalLine.Validate("Journal Template Name", ItemJournalTemplate.Name);
        //Assign Batch
        ItemJournalLine.Validate("Journal Batch Name", ItemJournalBatch.Name);

        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine."Posting Date" := Today;
        ItemJournalLine."Document Date" := Today;
        ItemJournalLine."Document No." := 'NEW_BIN';
        ItemJournalLine."Reason Code" := 'NEW_BIN';
        ItemJournalLine.Validate("Line No.", LineNo);
        ItemJournalLine.Validate("Item No.", Item."No.");
        ItemJournalLine.Validate("Location Code", LocationFrom);
        ItemJournalLine.Validate("Bin Code", Item."Item Type");
        ItemJournalLine.Validate("New Location Code", LocationTo);
        ItemJournalLine.Validate("New Bin Code", BinTo);
        ItemJournalLine.Validate("Unit of Measure Code", Item."Base Unit of Measure");
        //Set Quantity from
        ItemJournalLine.Validate(Quantity, Quantity);
        //If Quantity = 0 move the whole stock
        if Quantity = 0 then
            ItemJournalLine.Validate(Quantity, BinContent."Quantity (Base)");

        exit(ItemJournalLine.Insert(true));
    end;

    /// <summary>
    /// ImportWeightAndVolumeIT.
    /// </summary>
    /// <param name="Rec">VAR Record "EOS Data Migration Record".</param>
    procedure ImportWeightAndVolumeIT(var Rec: Record "EOS Data Migration Record")
    begin
        ImportWeightAndVolumeIT(Rec, false);
    end;

    /// <summary>
    /// ImportWeightAndVolumeIT.
    /// </summary>
    /// <param name="Rec">VAR Record "EOS Data Migration Record".</param>
    /// <param name="ChangeUOMToPC">Boolean.</param>
    procedure ImportWeightAndVolumeIT(var Rec: Record "EOS Data Migration Record"; ChangeUOMToPC: Boolean)
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if Rec.FindSet() then
            repeat
                //If item exists
                if Item.Get(Rec."Code20 1") then begin
                    if ChangeUOMToPC then begin
                        ItemLedgerEntry.SetRange("Item No.", Item."No.");
                        if ItemLedgerEntry.Count = 0 then
                            Item.Validate("Base Unit of Measure", 'PC')
                        else
                            Message('Item %1 has just Item Ledger Entry.', Item."No.");
                    end;
                    Evaluate(Item."Gross Weight", Rec."Text50 1");
                    Evaluate(Item."Net Weight", Rec."Text50 2");
                    Evaluate(Item."Unit Volume", Rec."Text50 3");
                    Item.Modify(true);
                end;
            until Rec.Next() = 0;
    end;

    var
        TempEOSDataMigrationSession: Record "EOS Data Migration Session" temporary;
        LogFile: Text[250];
}