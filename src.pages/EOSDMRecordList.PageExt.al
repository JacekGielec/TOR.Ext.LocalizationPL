// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			20.01.21		dho     creation

/// <summary>
/// PageExtension EOS DM Record List (ID 50451) extends Record EOS Data Migration Record List.
/// </summary>
pageextension 50451 "EOS DM Record List" extends "EOS Data Migration Record List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            /*
            action("Copy Bins")
            {
                ApplicationArea = All;
                Caption = 'Move Qty. to new BIN';
                //Promoted = true;
                //PromotedCategory = Process;
                //PromotedIsBig = true;
                Image = BinJournal;
                ToolTip = 'Create new Bins and Copy Qty';

                trigger OnAction()
                var
                    DMRecs: Record "EOS Data Migration Record";
                    TORDHO: Codeunit "TOR DHO";
                begin
                    if not Confirm('Do You want to move all Qty. to new Bin?') then
                        exit;
                    CurrPage.SetSelectionFilter(DMRecs);
                    TORDHO.createNewBinsAndReclassificationJournal(DMRecs);
                end;
            }
            //
            action("Move Qty to EXT/DOMAR")
            {
                ApplicationArea = All;
                Caption = 'Move Qty to EXT/DOMAR';
                Image = BinJournal;
                ToolTip = 'Move Qty to EXT/DOMAR';

                trigger OnAction()
                var
                    DMRecs: Record "EOS Data Migration Record";
                    TORDHO: Codeunit "TOR DHO";
                begin
                    if not Confirm('Do You want to move Qty. to EXT/DOMAR?') then
                        exit;
                    CurrPage.SetSelectionFilter(DMRecs);
                    TORDHO.MoveToDomar(DMRecs);
                end;
            }
            //
            action("Move DAMAGED Qty")
            {
                ApplicationArea = All;
                Caption = 'Move DAMAGED Qty';
                Image = BinJournal;
                ToolTip = 'Move DAMAGED Qty';

                trigger OnAction()
                var
                    DMRecs: Record "EOS Data Migration Record";
                    TORDHO: Codeunit "TOR DHO";
                begin
                    if not Confirm('Do You want to move DAMAGED Qty?') then
                        exit;
                    CurrPage.SetSelectionFilter(DMRecs);
                    TORDHO.MoveToDamaged(DMRecs);
                end;
            }
            */
            //
            action("Import Weights and Volume")
            {
                ApplicationArea = All;
                Caption = 'Import Weights and Volume';
                ToolTip = 'Import Gross Weight, Net Weight and Volume';
                Image = ImportDatabase;

                trigger OnAction()
                var
                    EOSDataMigrationRec: Record "EOS Data Migration Record";
                    TORDHO: Codeunit "TOR DHO";
                begin
                    if not Confirm('Do You want to import Item Weights and Volume?') then
                        exit;
                    EOSDataMigrationRec.SetFilter(Url, 'WeigthVolumeIT*');
                    TORDHO.ImportWeightAndVolumeIT(EOSDataMigrationRec);

                end;
            }
            //
            action("Import Weights and Volume and change BaseUOM to PC")
            {
                ApplicationArea = All;
                Caption = 'Import Weights and Volume and change BaseUOM to PC';
                ToolTip = 'Import Gross Weight, Net Weight, Volume and change BaseUOM to PC';
                Image = ImportDatabase;

                trigger OnAction()
                var
                    EOSDataMigrationRec: Record "EOS Data Migration Record";
                    TORDHO: Codeunit "TOR DHO";
                begin
                    if not Confirm('Do You want to import Item Weights and Volume and Change the BaseUOM to PC?') then
                        exit;
                    EOSDataMigrationRec.SetFilter(Url, 'WeightVolumeIT_ML*');
                    TORDHO.ImportWeightAndVolumeIT(EOSDataMigrationRec, true);

                end;
            }
        }
    }
}