page 50494 "TOR VAT Application Worksheet"
{
    Caption = 'TOR VAT Application Worksheet';
    UsageCategory = Tasks;
    ApplicationArea = Basic, Suite;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "VAT Entry";
    SourceTableView = sorting(Type, "Document No.", "Posting Date", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
                      where("Unrealized VAT Entry No." = const(0));
    Permissions = TableData 21 = m,
                TableData 17 = m,
                TableData 25 = m,
                TableData 380 = m,
                TableData 112 = m,
                TableData 114 = m,
                TableData 122 = m,
                TableData 124 = m,
                TableData 254 = m;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TypeFilter; TypeFilter)
                {
                    Caption = 'Type Filter';
                    OptionCaption = 'Purchase,Sales,Both';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetTypeFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(DocTypeFilter; DocTypeFilter)
                {
                    Caption = 'Document Type Filter';
                    OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetDocTypeFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(PostponedVATFilter; PostponedVATFilter)
                {
                    Caption = 'Postponed VAT Filter';
                    OptionCaption = ' ,No,Yes';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetPostponedVATFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(PostingDateFilter; PostingDateFilter)
                {
                    Caption = 'Posting Date Filter';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetPostingDateFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(VATDateFilter; VATDateFilter)
                {
                    Caption = 'VAT Settlement Date Filter';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetVATSettlementDateFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(DocRcptSalesDateFilter; DocRcptSalesDateFilter)
                {
                    Caption = 'Doc. Receipt/Sales Date Filter';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetPurchDocRecSaleDateFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(VATBusGroupFilter; VATBusGroupFilter)
                {
                    Caption = 'VAT Bus. Posting Group Filter';
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        VATBusPostingGroup.Reset();
                        if Page.RunModal(0, VATBusPostingGroup) = Action::LookupOK then begin
                            Text := VATBusPostingGroup.Code;
                            SetVATBusGroupFilter();
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetVATBusGroupFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(VATProdGroupFilter; VATProdGroupFilter)
                {
                    Caption = 'VAT Prod. Posting Group Filter';
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        VATProdPostingGroup.Reset();
                        if Page.RunModal(0, VATProdPostingGroup) = Action::LookupOK then begin
                            Text := VATProdPostingGroup.Code;
                            SetVATProdGroupFilter();
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetVATProdGroupFilter();
                        UpdateAfterFilterValidate();
                    end;
                }
                field(SkipInVATRegFilter; SkipInVATRegFilter)
                {
                    Caption = 'Skip in VAT Register Filter';
                    OptionCaption = ' ,No,Yes';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetSkipRegFilter();
                        UpdateAfterFilterValidate();
                    end;
                }

                field(ClosedEntryFilter; ClosedEntryFilter)
                {
                    Caption = 'Closed';
                    OptionCaption = 'No,Yes,Both';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SetClosedFilter();
                        UpdateAfterFilterValidate();
                    end;
                }

            }
            repeater(Control1470000)
            {
                Editable = false;
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    HideValue = "Document No.HideValue";
                    ApplicationArea = Basic, Suite;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Document Receipt/Sales Date"; Rec."ITI Doc. Receipt/Sales Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Settlement Date"; Rec."ITI VAT Settlement Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Postponed VAT"; Rec."ITI Postponed VAT")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Skip in VAT Register"; Rec."ITI Skip in VAT Register")
                {

                    ApplicationArea = Basic, Suite;
                }
                field("Remaining Unrealized Amount"; Rec."Remaining Unrealized Amount")
                {
                    Caption = 'Unrealized VAT';
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Base"; Rec."ITI VAT Base")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Amount"; Rec."ITI VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Postponed VAT Base"; Rec."ITI Postponed VAT Base")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Postponed VAT Amount"; Rec."ITI Postponed VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Base (Non Deductible)"; Rec."ITI VAT Base (Non Deductible)")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Amount (Non Deductible)"; Rec."ITI VAT Amount (Non Deduct.)")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Closed; Rec.Closed)
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Rev. Charge Curr. Difference"; Rec."ITI Rev. Chrg Curr. Difference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec."ITI Name")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec."ITI Address")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field(City; Rec."ITI City")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."ITI Post Code")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Correction Reason"; Rec."ITI Correction Reason")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("ITI SAFT Ext. Document No."; Rec."ITI SAFT Ext. Document No.")
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                }
                field("ITI VAT Attribute Set ID"; Rec."ITI VAT Attribute Set ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control1470002)
            {
                ShowCaption = false;
                fixed(Control52063046)
                {
                    ShowCaption = false;
                    group(Normal)
                    {
                        Caption = 'Normal';
                        field(VATBase; TotalVATBase)
                        {
                            AutoFormatType = 1;
                            Caption = 'VAT Base';
                            Editable = false;
                            ApplicationArea = Basic, Suite;
                        }
                        field(VATAmount; TotalVATAmount)
                        {
                            AutoFormatType = 1;
                            Caption = 'VAT Amount';
                            Editable = false;
                            ApplicationArea = Basic, Suite;
                        }
                    }
                    group(Postponed)
                    {
                        Caption = 'Postponed';
                        field(PostponedVATBase; TotalPostponedVATBase)
                        {
                            AutoFormatType = 1;
                            Caption = 'Postponed VAT Base';
                            Editable = false;
                            ApplicationArea = Basic, Suite;
                        }
                        field(PostponedVATAmount; TotalPostponedVATAmount)
                        {
                            AutoFormatType = 1;
                            Caption = 'Postponed VAT Amount';
                            Editable = false;
                            ApplicationArea = Basic, Suite;
                        }
                    }
                    group("Non Deductible")
                    {
                        Caption = 'Non Deductible';
                        field(TotalNonDeductibleVATBase; TotalNonDeductibleVATBase)
                        {
                            AutoFormatType = 1;
                            Caption = 'Non Deductible VAT Base';
                            Editable = false;
                            ApplicationArea = Basic, Suite;
                        }
                        field(TotalNonDeductibleVATAmount; TotalNonDeductibleVATAmount)
                        {
                            AutoFormatType = 1;
                            Caption = 'Non Deductible VAT Amount';
                            Editable = false;
                            ApplicationArea = Basic, Suite;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Change VAT Settlement Date")
                {
                    Caption = 'Change VAT Settlement Date';
                    Image = InteractionTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        VATManagement.ChangeVATDate(VATEntry);
                        TempVATEntry2.Reset();
                        TempVATEntry2.DeleteAll();
                    end;
                }


                action("Change Document Date")
                {
                    Caption = 'Change Document Date';
                    Image = InteractionTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        ChangeDocumentDate(VATEntry);
                    end;
                }
                action("Change Document Receipt/Sales Date")
                {
                    Caption = 'Change Document Receipt/Sales Date';
                    Image = InteractionTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        ChangeReceiptSalesDate(VATEntry);
                    end;
                }
                action("Postpone VAT")
                {
                    Caption = 'Postpone VAT';
                    Image = Interaction;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        VATManagement.PostponeVATEntry(VATEntry, false, 0D);
                        TempVATEntry2.Reset();
                        TempVATEntry2.DeleteAll();
                    end;
                }
                action("Realize Postponed VAT")
                {
                    Caption = 'Realize Postponed VAT';
                    Image = InteractionLog;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        VATManagement.RealizeVATEntry(VATEntry, false, 0D);
                        TempVATEntry2.Reset();
                        TempVATEntry2.DeleteAll();
                    end;
                }
                action(AdjustRevChargeVATExchRate)
                {
                    Caption = 'Adjust Reverse Charge VAT  Exch. Rate';
                    Image = AdjustExchangeRates;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        AdjustRevChargeExchRate: Page "ITI AdjRevChargeExchRate";
                    begin
                        Rec.TestField("VAT Calculation Type", Rec."VAT Calculation Type"::"Reverse Charge VAT");
                        AdjustRevChargeExchRate.SetValues(Rec);
                        AdjustRevChargeExchRate.Run();
                    end;
                }
                action("SkipInVATRegister")
                {
                    Caption = 'Skip in VAT Register';
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        VATManagement.ChangeSkipInVATReg(VATEntry, true);
                        TempVATEntry2.Reset();
                        TempVATEntry2.DeleteAll();
                    end;
                }
                action("IncludeInVATRegister")
                {
                    Caption = 'Include in VAT Register';
                    Image = ChangeTo;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        VATManagement.ChangeSkipInVATReg(VATEntry, false);
                        TempVATEntry2.Reset();
                        TempVATEntry2.DeleteAll();
                    end;
                }

                action("ChangeExtDocNo")
                {
                    Caption = 'Change Ext. Document No.';
                    Image = ChangeTo;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        ChangeExtDocumentNo(VATEntry);
                        //TempVATEntry2.Reset();
                        //TempVATEntry2.DeleteAll();
                    end;
                }
                action("ChangeVendor")
                {
                    Caption = 'Change Vendor No.';
                    Image = ChangeTo;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ApplicationArea = Basic, Suite;


                    trigger OnAction()
                    var
                        VATEntry: Record "VAT Entry";
                    begin
                        CurrPage.SetSelectionFilter(VATEntry);
                        ChangeVendorNo(VATEntry);
                        //TempVATEntry2.Reset();
                        //TempVATEntry2.DeleteAll();
                    end;
                }
            }


        }
        area(Navigation)
        {
            action("VAT Attributes")
            {
                Caption = 'VAT Attributes';
                AccessByPermission = TableData "ITI VAT Attribute" = R;
                Image = Versions;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;
                ShortCutKey = 'Ctrl+Q';

                trigger OnAction()
                begin
                    ShowEditEntryVATAttribute();
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }

            action("VAT Attribute Overview")
            {
                Caption = 'VAT Entries Attribute Overview';
                ApplicationArea = All;
                Image = ShowMatrix;
                ToolTip = 'View an overview of VAT entries and VAT Attributes.';

                trigger OnAction()
                begin
                    Page.Run(Page::"ITI VAT Entries Att. Overview", Rec);
                end;
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
        "Document No.HideValue" := false;
        //CalcTotalAmounts();
        DocumentNoC1470010OnFormat();
    end;

    trigger OnOpenPage()
    begin
        ClosedEntryFilter := ClosedEntryFilter::No;
        SetAllFilters();
        CalcTotalAmounts2();
    end;

    var
        TempDtldVATEntry: Record "ITI Detailed VAT Entry";
        TempVATEntry2: Record "VAT Entry" temporary;
        TempDtldVATEntry2: Record "ITI Detailed VAT Entry";
        VATBusPostingGroup: Record "VAT Business Posting Group";
        VATProdPostingGroup: Record "VAT Product Posting Group";
        FilterTokens: Codeunit "Filter Tokens";
        VATManagement: Codeunit "ITI VATManagement";
        Navigate: Page Navigate;
        TotalPostponedVATBase: Decimal;
        TotalPostponedVATAmount: Decimal;
        TotalVATBase: Decimal;
        TotalVATAmount: Decimal;
        TotalNonDeductibleVATBase: Decimal;
        TotalNonDeductibleVATAmount: Decimal;
        TypeFilter: Option Purchase,Sales,Both;
        PostingDateFilter: Text;
        DocRcptSalesDateFilter: Text;
        VATDateFilter: Text;
        PostponedVATFilter: Option " ",No,Yes;
        DocTypeFilter: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        VATBusGroupFilter: Text;
        VATProdGroupFilter: Text;
        [InDataSet]
        "Document No.HideValue": Boolean;
        [InDataSet]
        "Document No.Emphasize": Boolean;
        ClosedEntryFilter: Option No,Yes,Both;
        SkipInVATRegFilter: Option " ",No,Yes;
        DocumentDateCannotBeEmptyErr: Label 'Document Date must not be empty!';
        ExtDocNoCannotBeEmptyErr: Label 'Ext Document No. must not be empty';
        VendorNoCannotBeEmptyErr: Label 'Vendor No. must not be empty';
        VatRegistrationNoErr: Label 'You can change Vendor No. with the some vat registration no.';

    procedure CalcTotalAmounts()
    begin
        TempDtldVATEntry.Reset();
        TempDtldVATEntry.SetCurrentKey("Realized VAT Entry", Type, "Document No.", "Posting Date", "Document Receipt/Sales Date",
            "VAT Settlement Date", "Postponed VAT", "Document Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group");
        TempDtldVATEntry.CopyFilters(TempDtldVATEntry2);
        if TempDtldVATEntry.CalcSums("VAT Base", "VAT Amount", "Postponed VAT Base", "Postponed VAT Amount", "VAT Base (Non Deductible)", "VAT Amount (Non Deductible)") then begin
            TotalPostponedVATBase := TempDtldVATEntry."Postponed VAT Base";
            TotalPostponedVATAmount := TempDtldVATEntry."Postponed VAT Amount";
            TotalVATBase := TempDtldVATEntry."VAT Base";
            TotalVATAmount := TempDtldVATEntry."VAT Amount";
            TotalNonDeductibleVATBase := TempDtldVATEntry."VAT Base (Non Deductible)";
            TotalNonDeductibleVATAmount := TempDtldVATEntry."VAT Amount (Non Deductible)";
        end else begin
            TotalPostponedVATBase := 0;
            TotalPostponedVATAmount := 0;
            TotalVATBase := 0;
            TotalVATAmount := 0;
            TotalNonDeductibleVATBase := 0;
            TotalNonDeductibleVATAmount := 0;
        end;
    end;

    procedure CalcTotalAmounts2()
    var
        vatentry: Record "VAT Entry";
    begin
        TotalPostponedVATBase := 0;
        TotalPostponedVATAmount := 0;
        TotalVATBase := 0;
        TotalVATAmount := 0;
        TotalNonDeductibleVATBase := 0;
        TotalNonDeductibleVATAmount := 0;

        VATEntry.CopyFilters(Rec);

        if vatentry.FindSet() then
            repeat
                vatentry.CalcFields("ITI VAT Base", "ITI VAT Amount", "ITI Postponed VAT Base", "ITI Postponed VAT Amount", "ITI VAT Base (Non Deductible)", "ITI VAT Amount (Non Deduct.)");
                TotalPostponedVATBase += VATEntry."iti Postponed VAT Base";
                TotalPostponedVATAmount += VATEntry."iti Postponed VAT Amount";
                TotalVATBase += VATEntry."iti VAT Base";
                TotalVATAmount += VATEntry."iti VAT Amount";
                TotalNonDeductibleVATBase += VATEntry."iti VAT Base (Non Deductible)";
                TotalNonDeductibleVATAmount += VATEntry."ITI VAT Amount (Non Deduct.)";
            until vatentry.next = 0;


    end;

    procedure SetAllFilters()
    begin
        SetTypeFilter();
        SetPostingDateFilter();
        SetPurchDocRecSaleDateFilter();
        SetVATSettlementDateFilter();
        SetPostponedVATFilter();
        SetDocTypeFilter();
        SetVATBusGroupFilter();
        SetVATProdGroupFilter();
        SetClosedFilter();
        SetSkipRegFilter();
    end;

    procedure SetTypeFilter()
    begin
        Rec.FilterGroup(2);
        case TypeFilter of
            TypeFilter::Purchase:
                begin
                    Rec.SetRange(Type, Rec.Type::Purchase);
                    TempDtldVATEntry2.SetRange(Type, Rec.Type::Purchase);
                end;
            TypeFilter::Sales:
                begin
                    Rec.SetRange(Type, Rec.Type::Sale);
                    TempDtldVATEntry2.SetRange(Type, Rec.Type::Sale);
                end;
            TypeFilter::Both:
                begin
                    Rec.SetFilter(Type, '%1..%2', Rec.Type::Purchase, Rec.Type::Sale);
                    TempDtldVATEntry2.SetFilter(Type, '%1..%2', Rec.Type::Purchase, Rec.Type::Sale);
                end;
        end;
        Rec.FilterGroup(0);
    end;

    procedure SetPostingDateFilter()
    begin
        Rec.FilterGroup(2);
        FilterTokens.MakeDateFilter(PostingDateFilter);
        Rec.SetFilter("Posting Date", PostingDateFilter);
        Rec.SetFilter("ITI Date Filter", PostingDateFilter);
        TempDtldVATEntry2.SetFilter("Posting Date", PostingDateFilter);
        PostingDateFilter := Rec.GetFilter("Posting Date");
        Rec.FilterGroup(0);
    end;

    procedure SetPurchDocRecSaleDateFilter()
    begin
        Rec.FilterGroup(2);
        FilterTokens.MakeDateFilter(DocRcptSalesDateFilter);
        Rec.SetFilter("ITI Doc. Receipt/Sales Date", DocRcptSalesDateFilter);
        TempDtldVATEntry2.SetFilter("Document Receipt/Sales Date", DocRcptSalesDateFilter);
        DocRcptSalesDateFilter := Rec.GetFilter("ITI Doc. Receipt/Sales Date");
        Rec.FilterGroup(0);
    end;

    procedure SetVATSettlementDateFilter()
    begin
        Rec.FilterGroup(2);
        FilterTokens.MakeDateFilter(VATDateFilter);
        Rec.SetFilter("ITI VAT Settlement Date", VATDateFilter);
        TempDtldVATEntry2.SetFilter("VAT Settlement Date", VATDateFilter);
        VATDateFilter := Rec.GetFilter("ITI VAT Settlement Date");
        Rec.FilterGroup(0);
    end;

    procedure SetPostponedVATFilter()
    begin
        Rec.FilterGroup(2);
        if PostponedVATFilter = PostponedVATFilter::" " then begin
            Rec.SetRange("ITI Postponed VAT");
            TempDtldVATEntry2.SetRange("Postponed VAT");
        end else begin
            Rec.SetRange("ITI Postponed VAT", PostponedVATFilter = PostponedVATFilter::Yes);
            TempDtldVATEntry2.SetRange("Postponed VAT", PostponedVATFilter = PostponedVATFilter::Yes);
        end;
        Rec.FilterGroup(0);
    end;

    procedure SetDocTypeFilter()
    begin
        Rec.FilterGroup(2);
        if DocTypeFilter <> 0 then begin
            Rec.SetRange("Document Type", DocTypeFilter);
            TempDtldVATEntry2.SetRange("Document Type", DocTypeFilter);
        end else begin
            Rec.SetRange("Document Type");
            TempDtldVATEntry2.SetRange("Document Type");
        end;
        Rec.FilterGroup(0);
    end;

    procedure SetVATBusGroupFilter()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("VAT Bus. Posting Group", VATBusGroupFilter);
        TempDtldVATEntry2.SetFilter("VAT Bus. Posting Group", VATBusGroupFilter);
        VATBusGroupFilter := Rec.GetFilter("VAT Bus. Posting Group");
        Rec.FilterGroup(0);
    end;

    procedure SetVATProdGroupFilter()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("VAT Prod. Posting Group", VATProdGroupFilter);
        TempDtldVATEntry2.SetFilter("VAT Prod. Posting Group", VATProdGroupFilter);
        VATProdGroupFilter := Rec.GetFilter("VAT Prod. Posting Group");
        Rec.FilterGroup(0);
    end;

    procedure SetClosedFilter()
    begin
        case ClosedEntryFilter of
            ClosedEntryFilter::No:
                Rec.SetFilter(Closed, '%1', false);
            ClosedEntryFilter::Yes:
                Rec.SetFilter(Closed, '%1', true);
            ClosedEntryFilter::Both:
                Rec.SetRange(Closed);
        end;
    end;

    local procedure IsFirstLine(DocNo: Code[20]; EntryNo: Integer): Boolean
    var
        VATEntry: Record "VAT Entry";
    begin
        TempVATEntry2.Reset();
        TempVATEntry2.SetCurrentKey(Closed, Type, "Document No.", "Posting Date",
          "ITI Postponed VAT", "Document Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group");
        TempVATEntry2.CopyFilters(Rec);
        TempVATEntry2.SetRange("Document No.", DocNo);
        if not TempVATEntry2.FindFirst() then begin
            VATEntry.SetCurrentKey(Closed, Type, "Document No.", "Posting Date",
              "ITI Postponed VAT", "Document Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group");
            VATEntry.CopyFilters(Rec);
            VATEntry.SetRange("Document No.", DocNo);
            if VATEntry.FindSet() then;
            TempVATEntry2 := VATEntry;
            if TempVATEntry2.Insert() then;
        end;
        if TempVATEntry2."Entry No." = EntryNo then
            exit(true);
    end;

    procedure UpdateAfterFilterValidate()
    begin
        CalcTotalAmounts2();
        CurrPage.Update(false);
    end;

    local procedure DocumentNoC1470010OnFormat()
    begin
        if IsFirstLine(Rec."Document No.", Rec."Entry No.") then
            "Document No.Emphasize" := true
        else
            "Document No.HideValue" := true;
    end;

    procedure SetSkipRegFilter()
    begin

        case SkipInVATRegFilter of
            SkipInVATRegFilter::No:
                Rec.SetFilter("ITI Skip in VAT Register", '%1', false);
            SkipInVATRegFilter::Yes:
                Rec.SetFilter("ITI Skip in VAT Register", '%1', true);
            SkipInVATRegFilter::" ":
                Rec.SetRange("ITI Skip in VAT Register");
        end;

        TempDtldVATEntry2.SetFilter("Skip in VAT Register", Rec.GetFilter("ITI Skip in VAT Register"));

        //CalcTotalAmounts();
    end;

    procedure SetNewVATDateFilter(NewVATDateFilter: Text[250])
    begin
        VATDateFilter := NewVATDateFilter;
        TypeFilter := TypeFilter::Both;
    end;

    local procedure ShowEditEntryVATAttribute()
    var
        UpdateVATAttrInPstdEntrie: Codeunit "ITI UpdateVATAttrInPstdEntries";
    begin
        UpdateVATAttrInPstdEntrie.Run(Rec);
    end;


    local procedure CheckIfOldSPAttributeExist(OldID: Integer; NewID: Integer): Boolean
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        VATAttributeValue: Record "ITI VAT Attribute Value";
        VATAttributeManagement: Codeunit "ITI VATAttributeManagement";
    begin
        if GeneralLedgerSetup.Get() then begin
            VATAttributeValue.SetRange("VAT Attribute Code", GeneralLedgerSetup."ITI SP VAT Attribute");
            if VATAttributeValue.FindFirst() then
                if not VATAttributeManagement.CheckIfVATAttrExist(OldID, VATAttributeValue."VAT Attribute Code", VATAttributeValue.Code) then
                    if VATAttributeManagement.CheckIfVATAttrExist(NewID, VATAttributeValue."VAT Attribute Code", VATAttributeValue.Code) then
                        exit(true);
        end;
    end;

    local procedure ChangeDocumentDate(var VATEntry: Record "VAT Entry")
    var
        GLEntry: Record "G/L Entry";
        VendEntry: Record "Vendor Ledger Entry";
        CustEntry: Record "Cust. Ledger Entry";
        DtldVATEntry: Record "ITI Detailed VAT Entry";
        SetVATDates: Page "ITI Set VAT Settlement Dates";
        SetDocumentDate: Page "TOR Set Document Date";
        PostingDate: Date;
        DocumentDate: Date;
    begin

        if not VATEntry.FindSet() then
            exit;
        if VATEntry."Document No." = '' then
            exit;
        SetDocumentDate.SetValues(VATEntry."Document Date");
        if SetDocumentDate.RunModal() = ACTION::LookupOK then begin
            SetDocumentDate.GetValues(DocumentDate);
            if DocumentDate = 0D then
                Error(DocumentDateCannotBeEmptyErr);
        end else
            exit;

        GLEntry.SetCurrentKey("Document No.");
        CustEntry.SetCurrentKey("Document No.");
        VendEntry.SetCurrentKey("Document No.");

        //VATEntry.FindSet(true,true);
        //Error(format(VATEntry.Count));
        VATEntry.ModifyAll("Document Date", DocumentDate);

        GLEntry.SetRange("Document No.", VATEntry."Document No.");
        GLEntry.ModifyAll("Document Date", DocumentDate);

        CustEntry.SetRange("Document No.", VATEntry."Document No.");
        CustEntry.ModifyAll("Document Date", DocumentDate);

        VendEntry.SetRange("Document No.", VATEntry."Document No.");
        VendEntry.ModifyAll("Document Date", DocumentDate);
    end;

    local procedure ChangeReceiptSalesDate(var VATEntry: Record "VAT Entry")
    var
        DtldVATEntry: Record "ITI Detailed VAT Entry";
        SetVATDates: Page "ITI Set VAT Settlement Dates";
        SetDocumentDate: Page "TOR Set Document Date";
        PostingDate: Date;
        DocumentDate: Date;
    begin

        if not VATEntry.FindSet() then
            exit;
        if VATEntry."Document No." = '' then
            exit;
        SetDocumentDate.SetValues(VATEntry."ITI Doc. Receipt/Sales Date");
        if SetDocumentDate.RunModal() = ACTION::LookupOK then begin
            SetDocumentDate.GetValues(DocumentDate);
            if DocumentDate = 0D then
                Error(DocumentDateCannotBeEmptyErr);
        end else
            exit;

        VATEntry.ModifyAll("ITI Doc. Receipt/Sales Date", DocumentDate);
    end;

    local procedure ChangeExtDocumentNo(var VATEntry: Record "VAT Entry")
    var
        //DtldVATEntry: Record "ITI Detailed VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        GLEntry: Record "G/L Entry";
        SetNewValue: Page "TOR Set New Value";
        NewValue: Text;
    //DocumentDate: Date;
    begin

        if not VATEntry.FindSet() then
            exit;
        if VATEntry."Document No." = '' then
            exit;
        SetNewValue.SetValues(vatentry."External Document No.", VATEntry."External Document No.");
        if SetNewValue.RunModal() = ACTION::LookupOK then begin
            SetNewValue.GetValues(NewValue);
            if NewValue = '' then
                Error(ExtDocNoCannotBeEmptyErr);
        end else
            exit;

        VATEntry.ModifyAll("External Document No.", NewValue);
        VendLedgEntry.SetRange("Document No.", VATEntry."Document No.");
        VendLedgEntry.ModifyAll("External Document No.", NewValue);
        if PurchInvHeader.Get(VATEntry."Document No.") then begin
            PurchInvHeader."ITI SAFT Ext. Document No." := NewValue;
            PurchInvHeader.Modify();
        end;
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", VATEntry."Document No.");
        GLEntry.ModifyAll("External Document No.", NewValue);
    end;

    local procedure ChangeVendorNo(var VATEntry: Record "VAT Entry")
    var
        //DtldVATEntry: Record "ITI Detailed VAT Entry";
        Vend: Record Vendor;
        Vend2: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        GLEntry: Record "G/L Entry";
        SetNewValue: Page "TOR Set New Value";
        NewValue: Text;
        OldValue: Text;
    //DocumentDate: Date;
    begin

        if not VATEntry.FindSet() then
            exit;
        if VATEntry."Document No." = '' then
            exit;
        VATEntry.TestField(type, vatentry.Type::Purchase);

        SetNewValue.SetVendorValues(vatentry."Bill-to/Pay-to No.", VATEntry."Bill-to/Pay-to No.", true);
        if SetNewValue.RunModal() = ACTION::LookupOK then begin
            SetNewValue.GetValuesVendor(NewValue);
            if NewValue = '' then
                Error(VendorNoCannotBeEmptyErr);
        end else
            exit;

        Vend.Get(vatentry."Bill-to/Pay-to No.");
        Vend2.get(NewValue);
        if vend."VAT Registration No." <> vend2."VAT Registration No." then
            Error(VatRegistrationNoErr);


        VATEntry.ModifyAll("Bill-to/Pay-to No.", NewValue);
        VendLedgEntry.SetRange("Document No.", VATEntry."Document No.");
        if VendLedgEntry.FindSet() then begin
            VendLedgEntry."Vendor No." := NewValue;
            VendLedgEntry.Modify();

            DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
            if DtldVendLedgEntry.FindSet() then
                repeat
                    DtldVendLedgEntry."Vendor No." := NewValue;
                    DtldVendLedgEntry.Modify();
                until DtldVendLedgEntry.Next() = 0;
        end;
        if PurchInvHeader.Get(VATEntry."Document No.") then begin
            PurchInvHeader."Buy-from Vendor No." := NewValue;
            PurchInvHeader.Modify();
        end;
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", VATEntry."Document No.");
        if GLEntry.FindSet() then
            repeat
                if GLEntry."Source No." = vatentry."Bill-to/Pay-to No." then begin
                    GLEntry."Source No." := NewValue;
                    GLEntry.Modify();
                end;
            until GLEntry.Next() = 0;
        //GLEntry.ModifyAll("External Document No.", NewValue);
    end;
}