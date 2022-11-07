
/*
pageextension 50489 "Sales Bud. Overview Ext." extends "Sales Budget Overview"
{
    layout
    {
        addafter(ItemFilter)
        {
            field(SalespersonFilter; SalespersonFilter)
            {
                ApplicationArea = SalesBudget;
                Caption = 'Salesperson Filter';
                ToolTip = 'Specifies which salesperson to include in the budget overview.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    SalespersonList: Page "Salespersons/Purchasers";
                begin
                    SalespersonList.LookupMode(true);
                    if SalespersonList.RunModal = ACTION::LookupOK then begin
                        Text := SalespersonList.GetSelectionFilter;
                        exit(true);
                    end;
                end;

                trigger OnValidate()
                begin
                    SalespersonFilterOnAfterValidate();
                end;
            }
            field(CommissionsItemGroupFilter; CommissionsItemGroupFilter)
            {
                ApplicationArea = SalesBudget;
                Caption = 'Commissions Item Group Filter';
                ToolTip = 'Specifies which Commissions Item Group to include in the budget overview.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    CommGroupList: Page "EOS Commissions Group";
                    CommGroup: Record "EOS Commission Group";
                begin
                    CommGroupList.LookupMode(true);
                    CommGroup.SetRange("Group Type", CommGroup."Group Type"::Product);
                    CommGrouplist.SetTableView(CommGroup);
                    if CommGroupList.RunModal = ACTION::LookupOK then begin
                        //Text := CommGroupList.GetSelectionFilter;
                        exit(true);
                    end;
                end;

                trigger OnValidate()
                begin
                    SalespersonFilterOnAfterValidate();
                end;
            }
        }
        modify(LineDimCode)
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                NewCode: Text[30];
            begin
                NewCode := GetDimSelection(LineDimCode, ItemBudgetName);
                if NewCode <> LineDimCode then begin
                    Text := NewCode;
                    exit(true);
                end;
            end;

        }
        modify(ColumnDimCode)
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                NewCode: Text[30];
            begin
                NewCode := GetDimSelection(ColumnDimCode, ItemBudgetName);
                if NewCode <> ColumnDimCode then begin
                    Text := NewCode;
                    exit(true);
                end;
            end;


        }
    }

    actions
    {
        // Add changes to page actions here
    }

    procedure GetDimSelection(OldDimSelCode: Text[30]; ItemBudgetName: Record "Item Budget Name"): Text[30]
    var
        Item: Record Item;
        Cust: Record Customer;
        Vend: Record Vendor;
        Salesperson: Record "Salesperson/Purchaser";
        ComItemGroup: Record "EOS Commission Group";
        Location: Record Location;
        DimSelection: Page "Dimension Selection";
    begin
        GetGLSetup;
        DimSelection.InsertDimSelBuf(false, Item.TableCaption, Item.TableCaption);
        DimSelection.InsertDimSelBuf(false, Cust.TableCaption, Cust.TableCaption);
        DimSelection.InsertDimSelBuf(false, Location.TableCaption, Location.TableCaption);
        DimSelection.InsertDimSelBuf(false, Vend.TableCaption, Vend.TableCaption);
        //---jg
        DimSelection.InsertDimSelBuf(false, Salesperson.TableCaption, Salesperson.TableCaption);
        DimSelection.InsertDimSelBuf(false, ComItemGroup.TableCaption, ComItemGroup.TableCaption);
        //+++
        DimSelection.InsertDimSelBuf(false, Text003, Text003);
        if GLSetup."Global Dimension 1 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLSetup."Global Dimension 1 Code", '');
        if GLSetup."Global Dimension 2 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLSetup."Global Dimension 2 Code", '');
        if ItemBudgetName."Budget Dimension 1 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, ItemBudgetName."Budget Dimension 1 Code", '');
        if ItemBudgetName."Budget Dimension 2 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, ItemBudgetName."Budget Dimension 2 Code", '');
        if ItemBudgetName."Budget Dimension 3 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, ItemBudgetName."Budget Dimension 3 Code", '');

        DimSelection.LookupMode := true;
        if DimSelection.RunModal = ACTION::LookupOK then
            exit(DimSelection.GetDimSelCode);
        exit(OldDimSelCode);
    end;

    local procedure GetGLSetup()
    begin
        if GLSetupRead then
            exit;
        GLSetup.Get();
        GLSetupRead := true;
    end;

    local procedure SalespersonFilterOnAfterValidate()
    begin
        Error('Procedure SalespersonFilterOnAfterValidate not implemented.');
    end;

    var
        ItemBudgetName: Record "Item Budget Name";
        ItemBudgetManagement: Codeunit "Item Budget Management";
        SalespersonFilter: Text;
        CommissionsItemGroupFilter: Text;
        LineDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3",A0;
        ColumnDimOption2: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3",A1;
        LineDimCode: Text[30];
        ColumnDimCode: Text[30];
        Text001: Label 'DEFAULT';
        Text002: Label 'Default budget';
        GLSetup: Record "General Ledger Setup";
        PrevItemBudgetName: Record "Item Budget Name";
        Text003: Label 'Period';
        Text004: Label '%1 is not a valid line definition.';
        Text005: Label '%1 is not a valid column definition.';
        MatrixMgt: Codeunit "Matrix Management";
        GLSetupRead: Boolean;
        Text006: Label 'Do you want to delete the budget entries shown?';
        Text007: Label '<Sign><Integer Thousand><Decimals,2>, Locked = true';
        GlobalDimOption: Option Item,Customer,Vendor,Period,Location,"Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3",Salesperson,"Commissions Item Group";

}

*/