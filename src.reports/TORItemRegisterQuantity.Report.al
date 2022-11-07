report 50464 "TOR Item Register - Quantity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORItemRegisterQuantity.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'TOR Item Register - Quantity';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Register"; "Item Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ItemRegFilterCopyText; TableCaption + ': ' + ItemRegFilter)
            {
            }
            column(ItemRegFilter; ItemRegFilter)
            {
            }
            column(No_ItemRegister; "No.")
            {
            }
            column(ItemRegQtyCaption; ItemRegQtyCaptionLbl)
            {
            }
            column(UoMCaption; UoMCaptionLbl)
            { }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
            {
            }
            column(No_ItemRegisterCaption; No_ItemRegisterCaptionLbl)
            {
            }
            column(Drawer_Caption; Drawer_CaptionLbl)
            { }
            column(Warehouseman_Caption; Warehouseman_CaptionLbl)
            { }
            column(Reciver_Caption; Reciver_CaptionLbl)
            { }
            column(UserName; UserName)
            { }
            column(OutputNo; OutputNo)
            { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                column(PostingDate_ItemLedgEntry; format("Posting Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                {
                }
                column(EntryType_ItemLedgEntry; "Entry Type")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ItemLedgEntry; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(ItemDescription; ItemDescription)
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity_ItemLedgEntry; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Unit_of_Measure_Code; item."Base Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(EntryNo_ItemLedgEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(DocNo_ItemLedgEntry; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(Lot_No_; "Lot No.")
                {
                    IncludeCaption = true;
                }
                column(Expiration_Date; "Expiration Date")
                {
                    IncludeCaption = true;
                }
                column(Location_Code; "Location Code")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    //ItemDescription := Description;
                    //if ItemDescription = '' then begin
                    OutputNo += 1;
                    if not Item.Get("Item No.") then
                        Item.Init();
                    ItemDescription := Item.Description;

                    if ItemDescription = Description then
                        Description := '';
                    //end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.", "Item Register"."From Entry No.", "Item Register"."To Entry No.");
                end;
            }
        }
    }

    requestpage
    {

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

    trigger OnPreReport()
    var
        user: Record User;
    begin
        ItemRegFilter := "Item Register".GetFilters;
        user.SetRange("User Name", "Item Register"."User ID");
        if not user.FindFirst() then
            user.Init();
        UserName := user."Full Name";
    end;

    var
        Item: Record Item;
        UserName: Text;
        ItemRegFilter: Text;
        ItemDescription: Text[100];
        ItemRegQtyCaptionLbl: Label 'Item Register - Quantity';
        CurrReportPageNoCaptionLbl: Label 'Page';
        PostingDateCaptionLbl: Label 'Posting Date';
        ItemDescriptionCaptionLbl: Label 'Item Description';
        UoMCaptionLbl: Label 'UoM';
        No_ItemRegisterCaptionLbl: Label 'Register No.';
        Reciver_CaptionLbl: Label 'Receiver signature';
        Drawer_CaptionLbl: Label 'Drawer signature';
        Warehouseman_CaptionLbl: Label 'Warehouseman signature';
        OutputNo: Integer;
}

