// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			18.02.21		dho     Imported Reports from Torggler Warehouse Shipment_IT (from IT.Integro)

/// <summary>
/// Report TOR Posted Whse. Shipment (ID 50453).
/// </summary>
report 50453 "TOR Posted Whse. Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORPostedWhseShipment.rdlc';
    ApplicationArea = Warehouse;
    Caption = 'Warehouse Posted Shipment';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Posted Whse. Shipment Header";
        "Posted Whse. Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            dataitem("Integer";
            "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                column(CompanyName;
                CompanyName)
                {
                }
                column(TodayFormatted;
                Format(Today, 0, 4))
                {
                }
                column(AssgndUID_PostedWhseShptHeader;
                "Posted Whse. Shipment Header"."Assigned User ID")
                {
                }
                column(LocCode_PostedWhseShptHeader;
                "Posted Whse. Shipment Header"."Location Code")
                {
                }
                column(No_PostedWhseShptHeader;
                "Posted Whse. Shipment Header"."No.")
                {
                }
                column(BinMandatoryShow1;
                not Location."Bin Mandatory")
                {
                }
                column(BinMandatoryShow2;
                Location."Bin Mandatory")
                {
                }
                column(AssgndUID_PostedWhseShptHeaderCaption;
                "Posted Whse. Shipment Header".FieldCaption("Assigned User ID"))
                {
                }
                column(LocCode_PostedWhseShptHeaderCaption;
                "Posted Whse. Shipment Header".FieldCaption("Location Code"))
                {
                }
                column(No_PostedWhseShptHeaderCaption;
                "Posted Whse. Shipment Header".FieldCaption("No."))
                {
                }
                column(ShelfNo_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Shelf No."))
                {
                }
                column(ItemNo_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Item No."))
                {
                }
                column(Desc_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption(Description))
                {
                }
                column(UOM_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Unit of Measure Code"))
                {
                }
                column(Qty_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption(Quantity))
                {
                }
                column(SourceNo_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Source No."))
                {
                }
                column(SourceDoc_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Source Document"))
                {
                }
                column(ZoneCode_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Zone Code"))
                {
                }
                column(BinCode_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Bin Code"))
                {
                }
                column(LocCode_PostedWhseShptLineCaption;
                "Posted Whse. Shipment Line".FieldCaption("Location Code"))
                {
                }
                column(CurrReportPAGENOCaption;
                CurrReportPAGENOCaptionLbl)
                {
                }
                column(WarehousePostedShipmentCaption;
                WarehousePostedShipmentCaptionLbl)
                {
                }
                column(TotalWeight;
                TotalWeightTxt)
                {
                }
                column(ShipToAddr1;
                ShipToAddr[1])
                {
                }
                column(ShipToAddr2;
                ShipToAddr[2])
                {
                }
                column(ShipToAddr3;
                ShipToAddr[3])
                {
                }
                column(ShipToAddr4;
                ShipToAddr[4])
                {
                }
                column(ShipToAddr5;
                ShipToAddr[5])
                {
                }
                column(ShipToAddr6;
                ShipToAddr[6])
                {
                }
                column(ShipToAddr7;
                ShipToAddr[7])
                {
                }
                column(ShipToAddr8;
                ShipToAddr[8])
                {
                }
                column(ShiptoAddrCaption;
                ShiptoAddressTxt)
                {
                }
                dataitem("Posted Whse. Shipment Line";
                "Posted Whse. Shipment Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = "Posted Whse. Shipment Header";
                    DataItemTableView = SORTING("No.", "Line No.");

                    column(ShelfNo_PostedWhseShptLine;
                    "Shelf No.")
                    {
                    }
                    column(ItemNo_PostedWhseShptLine;
                    "Item No.")
                    {
                    }
                    column(Desc_PostedWhseShptLine;
                    Description)
                    {
                    }
                    column(UOM_PostedWhseShptLine;
                    "Unit of Measure Code")
                    {
                    }
                    column(LocCode_PostedWhseShptLine;
                    "Location Code")
                    {
                    }
                    column(Qty_PostedWhseShptLine;
                    Quantity)
                    {
                    }
                    column(SourceNo_PostedWhseShptLine;
                    "Source No.")
                    {
                    }
                    column(SourceDoc_PostedWhseShptLine;
                    "Source Document")
                    {
                    }
                    column(ZoneCode_PostedWhseShptLine;
                    "Zone Code")
                    {
                    }
                    column(BinCode_PostedWhseShptLine;
                    "Bin Code")
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                    end;
                }
            }
            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                if HideCompanyName("No.") then
                    CompanyName := ''
                else
                    CompanyName := COMPANYPROPERTY.DisplayName();
                TotalWeight := GetTotalWeight("No.");
                if TotalWeight = 0 then
                    TotalWeightTxt := ''
                else
                    TotalWeightTxt := TotalWeightCaptionLbl + FORMAT(TotalWeight) + KGCaptionLbl;
                GetCustomerShipToAddress("No.");
            end;
        }
    }
    requestpage
    {
        Caption = 'Warehouse Posted Shipment';

        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    var
        Location: Record Location;
        FormatAddr: Codeunit "Format Address";
        CurrReportPAGENOCaptionLbl: Label 'Page';
        WarehousePostedShipmentCaptionLbl: Label 'Warehouse Posted Shipment';
        ShipToAddr: array[8] of Text[50];
        CompanyName: Text;
        TotalWeightTxt: Text;
        TotalWeight: Decimal;
        ShiptoAddressTxt: Text;
        TotalWeightCaptionLbl: Label 'Total Weight: ';
        KGCaptionLbl: Label 'kg';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init()
        else
            if Location.Code <> LocationCode then Location.Get(LocationCode);
    end;

    local procedure HideCompanyName(WhseShipmentNo: Code[20]): Boolean
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        Customer: Record Customer;
    begin
        PostedWhseShipmentLine.Reset();
        PostedWhseShipmentLine.SetRange("No.", WhseShipmentNo);
        if PostedWhseShipmentLine.FindSet() then
            repeat
                if PostedWhseShipmentLine."Destination Type" = PostedWhseShipmentLine."Destination Type"::Customer then
                    if Customer.Get(PostedWhseShipmentLine."Destination No.") then
                        if Customer."Hide Comp. Name on Whse Shpt." then exit(true);
            until PostedWhseShipmentLine.Next() = 0;
    end;

    local procedure GetTotalWeight(WhseShipmentNo: Code[20]): Decimal
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        Item: Record Item;
        TotWeight: Decimal;
    begin
        TotWeight := 0;
        PostedWhseShipmentLine.Reset();
        PostedWhseShipmentLine.SetRange("No.", WhseShipmentNo);
        if PostedWhseShipmentLine.FindSet() then
            repeat
                if PostedWhseShipmentLine."Unit of Measure Code" = 'KG' then
                    TotWeight += PostedWhseShipmentLine.Quantity
                else
                    if Item.Get(PostedWhseShipmentLine."Item No.") then
                        if Item."Net Weight" = 0 then
                            exit(0)
                        else
                            if PostedWhseShipmentLine."Unit of Measure Code" = Item."Base Unit of Measure" then
                                TotWeight += PostedWhseShipmentLine.Quantity * Item."Net Weight"
                            else
                                exit(0);
            until PostedWhseShipmentLine.Next() = 0;
        exit(TotWeight);
    end;

    local procedure GetCustomerShipToAddress(WhseShipmentNo: Code[20])
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        PostedWhseShipmentLine.Reset();
        PostedWhseShipmentLine.SetRange("No.", WhseShipmentNo);
        if PostedWhseShipmentLine.FindFirst() then
            if PostedWhseShipmentLine."Posted Source Document" = PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment" then
                if SalesShipmentHeader.Get(PostedWhseShipmentLine."Posted Source No.") then FormatAddr.SalesShptShipTo(ShipToAddr, SalesShipmentHeader);
        if ShipToAddr[1] <> '' then
            ShiptoAddressTxt := ShiptoAddrCaptionLbl
        else
            ShiptoAddressTxt := '';
    end;
}
