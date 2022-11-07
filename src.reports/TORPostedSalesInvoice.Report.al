// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			18.02.21		dho     Imported Reports from Torggler_Sales_Invoice_IT (from IT.Integro)
// TG-TDAG00000-002         24.02.21        dho     Added Tariff No. for Customer Posting Group <> NAT
// TG-TDAG00000-003         12.03.21        dho     - Deleted Columns Discount (%) and Unit Price
//                                                  - Display Column PriceWithDiscount insteat of UnitPrice
//                                                  - Used ShortDateFormat for ITI Sales Date
//                                                  - Allways Show VAT also if REVERSE_CHAGE_UE23%

/// <summary>
/// Report TOR Posted Sales Invoice (ID 50450).
/// </summary>
report 50450 "TOR Posted Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORPostedSalesInvoice.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    Caption = 'Invoice';
    EnableHyperlinks = true;
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Integer";
        "Integer")
        {
            DataItemTableView = sorting(Number) order(Ascending) where(Number = filter(1));

            column(CompanyInfo2Picture;
            CompanyInfo2.Picture)
            {
            }
            column(CompanyInfo1Picture;
            CompanyInfo1.Picture)
            {
            }
            column(CompanyInfoPicture;
            CompanyInfo.Picture)
            {
            }
            column(CompanyInfo3Picture;
            CompanyInfo3.Picture)
            {
            }
        }
        dataitem("Sales Invoice Header";
        "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';

            column(No_SalesInvHdr;
            "No.")
            {
            }
            column(InvDiscountAmtCaption;
            InvDiscountAmtCaptionLbl)
            {
            }
            column(DocumentDateCaption;
            DocumentDateCaptionLbl)
            {
            }
            column(PaymentTermsDescCaption;
            PaymentTermsDescCaptionLbl)
            {
            }
            column(ShptMethodDescCaption;
            ShptMethodDescCaptionLbl)
            {
            }
            column(VATPercentageCaption;
            VATPercentageCaptionLbl)
            {
            }
            column(TotalCaption;
            TotalCaptionLbl)
            {
            }
            column(VATBaseCaption;
            VATBaseCaptionLbl)
            {
            }
            column(VATAmtCaption;
            VATAmtCaptionLbl)
            {
            }
            column(VATIdentifierCaption;
            VATIdentifierCaptionLbl)
            {
            }
            column(HomePageCaption;
            HomePageCaptionLbl)
            {
            }
            column(EMailCaption;
            EMailCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote;
            DisplayAdditionalFeeNote)
            {
            }
            column(TotalText;
            TotalText)
            {
            }
            column(PrintSpecyficationVAT;
            PrintSpecyficationVAT)
            {

            }
            dataitem(CopyLoop;
            "Integer")
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop;
                "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    column(HomePage;
                    CompanyInfo."Home Page")
                    {
                    }
                    column(EMail;
                    CompanyInfo."E-Mail")
                    {
                    }
                    column(DocumentCaptionCopyText;
                    StrSubstNo(DocumentCaption(), CopyText))
                    {
                    }
                    column(CustAddr1;
                    CustAddr[1])
                    {
                    }
                    column(CompanyAddr1;
                    CompanyAddr[1])
                    {
                    }
                    column(CustAddr2;
                    CustAddr[2])
                    {
                    }
                    column(CompanyAddr2;
                    CompanyAddr[2])
                    {
                    }
                    column(CustAddr3;
                    CustAddr[3])
                    {
                    }
                    column(CompanyAddr3;
                    CompanyAddr[3])
                    {
                    }
                    column(CustAddr4;
                    CustAddr[4])
                    {
                    }
                    column(CompanyAddr4;
                    CompanyAddr[4])
                    {
                    }
                    column(CustAddr5;
                    CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo;
                    CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6;
                    CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo;
                    CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo;
                    CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName;
                    GetBankAccountName())
                    {
                    }
                    column(CompanyInfoBankAccNo;
                    GetBankAccountIban())
                    {
                    }
                    column(CompanyBDO;
                    CompanyInfo."TOR BDO")
                    {
                    }
                    column(CompanyKRS;
                    CompanyInfo."TOR KRS")
                    {
                    }
                    column(Regon;
                    CompanyInfo."Registration No.")
                    {
                    }
                    column(BilltoCustNo_SalesInvHdr;
                    "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr;
                    Format("Sales Invoice Header"."Posting Date", 0, DateFormat))
                    {
                    }
                    column(VATNoText;
                    VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHdr;
                    "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvHdr;
                    Format("Sales Invoice Header"."Due Date", 0, DateFormat))
                    {
                    }
                    column(SalesPersonText;
                    SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;
                    SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText;
                    ReferenceText)
                    {
                    }
                    column(YourReference_SalesInvHdr;
                    "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText;
                    OrderNoText)
                    {
                    }
                    column(HdrOrderNo_SalesInvHdr;
                    "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(CustAddr7;
                    CustAddr[7])
                    {
                    }
                    column(CustAddr8;
                    CustAddr[8])
                    {
                    }
                    column(CompanyAddr5;
                    CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6;
                    CompanyAddr[6])
                    {
                    }
                    column(DocDate_SalesInvHdr;
                    Format("Sales Invoice Header"."Document Date", 0, DateFormat))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr;
                    "Sales Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo;
                    OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesInvHdr;
                    Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption;
                    PageCaptionCap)
                    {
                    }
                    column(PaymentTermsDesc;
                    PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc;
                    ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;
                    CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCptn;
                    CompanyInfoVATRegNoCptnLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption;
                    CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCptn;
                    CompanyInfoBankNameCptnLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCptn;
                    CompanyInfoBankAccNoCptnLbl)
                    {
                    }
                    column(SalesInvDueDateCaption;
                    SalesInvDueDateCaptionLbl)
                    {
                    }
                    column(InvNoCaption;
                    InvNoCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesInvHdrCaption;
                    "Sales Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption;
                    "Sales Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(UserID;
                    UserId())
                    {
                    }
                    column(UserID_Caption;
                    USERID_CaptionLbl)
                    {
                    }
                    column(COMPANYNAME;
                    CompanyName())
                    {
                    }
                    column(COMPANYNAME_Caption;
                    COMPANYNAME_CaptionLbl)
                    {
                    }
                    column(Company_Title;
                    CompanyTitle)
                    {
                    }
                    column(PrepmtInvoice_Header;
                    PrepmtInvoice)
                    {
                    }
                    column(PrepmtInvoice_Order_No_Header;
                    StrSubstNo(Text017, "Sales Invoice Header"."Prepayment Order No."))
                    {
                    }
                    column(PrepmtInvoice_Due_Date_Header;
                    StrSubstNo(Text018, Format("Sales Invoice Header"."Due Date", 0, DateFormat)))
                    {
                    }
                    column(PrepmtInvoice_Amount_Inc_Vat_Header;
                    StrSubstNo(Text019, Format("Sales Invoice Header"."Amount Including VAT", 0, '<Precision,2:2> <Standard Format,0>'), CurrencyCode))
                    {
                    }
                    column(TempDate_Header;
                    Format("Sales Invoice Header"."Shipment Date", 0, DateFormat))
                    {
                    }
                    column(SalesDate_Header;
                    Format("Sales Invoice Header"."ITI Sales Date", 0, ShortDateFormat))
                    {
                    }
                    column(VATRegNo_Caption;
                    VATRegNo_CaptionLbl)
                    {
                    }
                    column(Duplicate_Caption;
                    StrSubstNo('%1%2%3%4', DuplicateTxt, DateTxt, DuplicateDateTxt, PrepaymentTxt))
                    {
                    }
                    column(ContractingPartyTitle;
                    ContractingPartyTitleLbl)
                    {
                    }
                    column(ContractorNo;
                    "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(OrderNo_Header;
                    "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(QuoteNo_Header;
                    "Sales Invoice Header"."Quote No.")
                    {
                    }
                    column(CompanyInfoRegNo;
                    CompanyInfo."Registration No.")
                    {
                    }
                    column(CompanyInfoSWIFTCode;
                    GetBankAccountSwift())
                    {
                    }
                    column(Addr_Info;
                    AddrInfo)
                    {
                    }
                    column(Court_Info;
                    CourtInfo)
                    {
                    }
                    column(PaymentMethod_Header;
                    PaymentMethod.Code)
                    {
                    }
                    column(CompanyInfoRegNo_Caption;
                    CompanyInfoRegNo_CaptionLbl)
                    {
                    }
                    column(CompanyInfoSWIFTCode_Caption;
                    CompanyInfoSWIFTCode_CaptionLbl)
                    {
                    }
                    column(DocDate_Header_Caption;
                    DocDate_Header_CaptionLbl)
                    {
                    }
                    column(DueDate_Header_Caption;
                    DueDate_Header_CaptionLbl)
                    {
                    }
                    column(SalesDate_Header_Caption;
                    SalesDate_Header_CaptionLbl)
                    {
                    }
                    column(TempDate_Header_Caption;
                    TempDate_Header_CaptionLbl)
                    {
                    }
                    column(PaymentMethod_Header_Caption;
                    PaymentMethod_Header_CaptionLbl)
                    {
                    }
                    column(DocumentNo_Caption;
                    DocumentNo_CaptionLbl)
                    {
                    }
                    column(PostingDate_Header_Caption;
                    PostingDate_Header_CaptionLbl)
                    {
                    }
                    column(QuoteNo_Header_Caption;
                    QuoteNo_Header_CaptionLbl)
                    {
                    }
                    column(ShipmentMethod_Header_Caption;
                    ShipmentMethod_Header_CaptionLbl)
                    {
                    }
                    column(UnitOfMeasureTxtCaption;
                    UnitOfMeasureTxtLbl)
                    {
                    }
                    column(Prepayment_Document_TypeCaption;
                    Prepayment_Document_TypeLbl)
                    {
                    }
                    column(Prepayment_Document_NoCaption;
                    Prepayment_Document_NoLbl)
                    {
                    }
                    column(Prepaymen_Vat_DateCaption;
                    Prepaymen_Vat_DateLbl)
                    {
                    }
                    column(Prepayment_Amount_Including_VATCaption;
                    Prepayment_Amount_Including_VATLbl)
                    {
                    }
                    column(PaymentMethod_Description;
                    PaymentMethod.Description)
                    {
                    }
                    column(LastModifiedBy;
                    getLastModifiedBy())
                    {
                    }
                    column(UserName;
                    GetUserName())
                    {
                    }
                    dataitem(DimensionLoop1;
                    "Integer")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(DimText;
                        DimText)
                        {
                        }
                        column(DimensionLoop1Number;
                        Number)
                        {
                        }
                        column(HeaderDimCaption;
                        HeaderDimCaptionLbl)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet() then CurrReport.Break();
                            end
                            else
                                if not Continue then CurrReport.Break();
                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := CopyStr(DimText, 1, MaxStrLen(OldDimText));
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText := StrSubstNo('%1, %2 %3', DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Invoice Line";
                    "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(LineAmt_SalesInvLine;
                        "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine;
                        Description + ' ' + "Description 2")
                        {
                        }
                        column(No_SalesInvLine;
                        "No.")
                        {
                        }
                        column(Qty_SalesInvLine;
                        Quantity)
                        {
                        }
                        column(UOM_SalesInvLine;
                        "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine;
                        "Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(PriceWithDiscount_SalesInvLine;
                        GetPriceWithDiscount())
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(Discount_SalesInvLine;
                        "Line Discount %")
                        {
                        }
                        column(VATIdentifier_SalesInvLine;
                        "VAT Identifier")
                        {
                        }
                        column(PostedShipmentDate;
                        Format(PostedShipmentDate))
                        {
                        }
                        column(Type_SalesInvLine;
                        Format(Type))
                        {
                        }
                        column(InvDiscLineAmt_SalesInvLine;
                        -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal;
                        TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmount;
                        TotalInvDiscAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_SalesInvLine;
                        Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalAmount;
                        TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_AmtInclVAT;
                        "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine;
                        "Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText;
                        VATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalExclVATText;
                        TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText;
                        TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT;
                        TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT;
                        TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmtAfterInvDiscAmt;
                        -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr;
                        "Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscOnVAT;
                        TotalPaymentDiscOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText_SalesInvLine;
                        TotalInclVATText)
                        {
                        }
                        column(VATAmtText_SalesInvLine;
                        VATAmountLine.VATAmountText())
                        {
                        }
                        column(DocNo_SalesInvLine;
                        "Document No.")
                        {
                        }
                        column(LineNo_SalesInvLine;
                        "Line No.")
                        {
                        }
                        column(UnitPriceCaption;
                        UnitPriceCaptionLbl)
                        {
                        }
                        column(PriceWithDiscountCaption;
                        PriceWithDiscountCaptionLbl)
                        {
                        }
                        column(SalesInvLineDiscCaption;
                        SalesInvLineDiscCaptionLbl)
                        {
                        }
                        column(AmountCaption;
                        AmountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption;
                        PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;
                        SubtotalCaptionLbl)
                        {
                        }
                        column(LineAmtAfterInvDiscCptn;
                        LineAmtAfterInvDiscCptnLbl)
                        {
                        }
                        column(Desc_SalesInvLineCaption;
                        FieldCaption(Description))
                        {
                        }
                        column(No_SalesInvLineCaption;
                        FieldCaption("No."))
                        {
                        }
                        column(Qty_SalesInvLineCaption;
                        FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesInvLineCaption;
                        FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesInvLineCaption;
                        FieldCaption("VAT Identifier"))
                        {
                        }
                        column(IsLineWithTotals;
                        LineNoWithTotal = "Line No.")
                        {
                        }
                        column(VAT_SalesInvLine;
                        Format("VAT %") + ' %')
                        {
                        }
                        column(VATPercentageCaption2;
                        VATPercentageCaption2Lbl)
                        {
                        }
                        column(ShowVAT_Rev_Charge;
                        ShowVATSpec)
                        {
                        }
                        column(EAN_SalesInvLine;
                        GTIN)
                        {
                        }
                        column(EANLbl_SalesInvLineCaption;
                        EANLbl)
                        {
                        }
                        column(AmountBeforeDiscountLbl_SalesInvLineCaption;
                        AmountBeforeDiscountLbl)
                        {
                        }
                        column(AmountBeforeDiscount_SalesInvLine;
                        AmountBeforeDiscount)
                        {
                        }
                        //Begin TG-TDAG00000-002/dho
                        column(Tariff_No;
                        GetTariffNo("No."))
                        {
                        }
                        //End TG-TDAG00000-002/dho
                        dataitem("Sales Shipment Buffer";
                        "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(SalesShptBufferPostDate;
                            Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShptBufferQty;
                            SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShipmentCaption;
                            ShipmentCaptionLbl)
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    SalesShipmentBuffer.Find('-')
                                else
                                    SalesShipmentBuffer.Next();
                            end;

                            trigger OnPreDataItem()
                            begin
                                SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");
                                SetRange(Number, 1, SalesShipmentBuffer.Count());
                            end;
                        }
                        dataitem(DimensionLoop2;
                        "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(DimText_DimLoop;
                            DimText)
                            {
                            }
                            column(LineDimCaption;
                            LineDimCaptionLbl)
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then CurrReport.Break();
                                end
                                else
                                    if not Continue then CurrReport.Break();
                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := CopyStr(DimText, 1, MaxStrLen(OldDimText));
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo('%1, %2 %3', DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then CurrReport.Break();
                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop;
                        "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(TempPostedAsmLineNo;
                            BlanksForIndent() + TempPostedAsmLine."No.")
                            {
                            }
                            column(TempPostedAsmLineQuantity;
                            TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc;
                            BlanksForIndent() + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostAsmLineVartCode;
                            BlanksForIndent() + TempPostedAsmLine."Variant Code")
                            {
                            }
                            column(TempPostedAsmLineUOM;
                            GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }
                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if Number = 1 then
                                    TempPostedAsmLine.FindSet()
                                else
                                    TempPostedAsmLine.Next();
                                if ItemTranslation.Get(TempPostedAsmLine."No.", TempPostedAsmLine."Variant Code", "Sales Invoice Header"."Language Code") then TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then CurrReport.Break();
                                CollectAsmInformation();
                                Clear(TempPostedAsmLine);
                                SetRange(Number, 1, TempPostedAsmLine.Count());
                            end;
                        }
                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll();
                            SalesShipmentBuffer.Reset();
                            SalesShipmentBuffer.DeleteAll();
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            LineNoWithTotal := "Line No.";
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do MoreLines := Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
                            Pos := 0;
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if Type <> Type::" " then Pos += 1;
                            if Type <> Type::Item then "No." := '';
                            PostedShipmentDate := 0D;
                            if Quantity <> 0 then PostedShipmentDate := FindPostedShipmentDate();
                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then "No." := '';
                            if (Type = Type::Item) then
                                GTIN := GetGTIN("No.")
                            else
                                GTIN := '';

                            //---jg
                            if (type = type::Item) and (quantity = 0) then
                                CurrReport.skip;
                            if type = type::"Charge (Item)" then
                                if description = 'KOSZTY PAKOWANIA' then
                                    if cust."Pallet Cost Text" <> '' then
                                        Description := cust."Pallet Cost Text";
                            //+++
                            AmountBeforeDiscount := GetAmountBeforeDiscount("Sales Invoice Line");
                            VATAmountLine.Init();
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                            VATAmountLine.InsertLine();
                            TotalSubTotal += "Line Amount";
                            TotalInvDiscAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                        end;

                        trigger OnPostDataItem()
                        begin
                            SetMandatorySplitPaymentVATClause;
                        end;
                    }
                    dataitem(VATCounter;
                    "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(VATAmtLineVATBase;
                        VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt;
                        VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt;
                        VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt;
                        VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt;
                        VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPer;
                        VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier;
                        VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecificationCptn;
                        VATAmtSpecificationCptnLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption;
                        InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption;
                        LineAmtCaptionLbl)
                        {
                        }
                        column(ShowVAT_Rev_Charge1;
                        ShowVATSpec)
                        {
                        }
                        column(VATClauseSPIdentifier;
                        VATClauseSPValue)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            if (VATAmountLine."VAT Clause Code" = GLSetup."ITI Split Payment VAT Clause") and (GLSetup."ITI Split Payment VAT Clause" <> '') then CurrReport.Skip();
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VATAmountLine.Count());
                        end;
                    }
                    dataitem(VATClauseEntryCounter;
                    "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(VATClauseVATIdentifier;
                        VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATClauseCode;
                        VATAmountLine."VAT Clause Code")
                        {
                        }
                        column(VATClauseDescription;
                        VATClause.Description)
                        {
                        }
                        column(VATClauseDescription2;
                        VATClause."Description 2")
                        {
                        }
                        column(VATClauseAmount;
                        VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption;
                        VATClausesCap)
                        {
                        }
                        column(VATClauseVATIdentifierCaption;
                        VATIdentifierCaptionLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption;
                        VATAmtCaptionLbl)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            if not VATClause.Get(VATAmountLine."VAT Clause Code") then CurrReport.Skip();
                            VATClause.TranslateDescription("Sales Invoice Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            SetRange(Number, 1, VATAmountLine.Count());
                        end;
                    }
                    dataitem(VatCounterLCY;
                    "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(VALSpecLCYHeader;
                        VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate;
                        VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY;
                        VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY;
                        VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATPer_VATCounterLCY;
                        VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATCounterLCY;
                        VATAmountLine."VAT Identifier")
                        {
                        }
                        column(ShowVAT_Rev_Charge2;
                        ShowVATSpec)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            if VATAmountLine."VAT Clause Code" = GLSetup."ITI Split Payment VAT Clause" then CurrReport.Skip();
                            VALVATBaseLCY := VATAmountLine.GetBaseLCY("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", "Sales Invoice Header"."Currency Factor");
                            VALVATAmountLCY := VATAmountLine.GetAmountLCY("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", "Sales Invoice Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or ("Sales Invoice Header"."Currency Code" = '') then CurrReport.Break();
                            SetRange(Number, 1, VATAmountLine.Count());
                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", 1);
                            CalculatedExchRate := Round(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(PaymentReportingArgument;
                    "Payment Reporting Argument")
                    {
                        DataItemTableView = sorting(Key);
                        UseTemporary = true;

                        column(PaymentServiceLogo;
                        Logo)
                        {
                        }
                        column(PaymentServiceURLText;
                        "URL Caption")
                        {
                        }
                        column(PaymentServiceURL;
                        GetTargetURL())
                        {
                        }
                        trigger OnPreDataItem()
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument, "Sales Invoice Header");
                            if IsEmpty() then CurrReport.Break();
                        end;
                    }
                    dataitem(Total;
                    "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(SelltoCustNo_SalesInvHdr;
                        "Sales Invoice Header"."Sell-to Customer No.")
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
                        ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesInvHdrCaption;
                        "Sales Invoice Header".FieldCaption("Sell-to Customer No."))
                        {
                        }
                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then CurrReport.Break();
                        end;
                    }
                    dataitem(LineFee;
                    "Integer")
                    {
                        DataItemTableView = sorting(Number) order(Ascending) where(Number = filter(1 ..));

                        column(LineFeeCaptionLbl;
                        TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayAdditionalFeeNote then CurrReport.Break();
                            if Number = 1 then begin
                                if not TempLineFeeNoteOnReportHist.FindSet() then CurrReport.Break()
                            end
                            else
                                if TempLineFeeNoteOnReportHist.Next() = 0 then CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Comment Line";
                    "Sales Comment Line")
                    {
                        DataItemLink = "No." = field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const("Posted Invoice"));

                        column(SalesCommentLineCaption;
                        SalesCommentLineCaptionLbl)
                        {
                        }
                        column(Sales_Comment_Line_Comment;
                        "Sales Comment Line".Comment)
                        {
                        }
                        trigger OnPreDataItem()
                        begin
                            if not ShowComment then CurrReport.Break();
                        end;
                    }
                    dataitem("Extended Text Header";
                    "Extended Text Header")
                    {
                        dataitem(ExtTxtLine;
                        "Extended Text Line")
                        {
                            DataItemLink = "No." = field("No.");
                            DataItemLinkReference = "Extended Text Header";
                            DataItemTableView = sorting("No.");
                            column(ExtTxt;
                            LongText)
                            {
                            }
                        }
                        trigger OnPreDataItem()
                        begin
                            if Cust."Factoring Std. Text Code" = '' then CurrReport.Break();
                            SetRange("No.", Cust."Factoring Std. Text Code");
                            Setfilter("Language Code", '%1|%2', cust."Language Code", '');
                            SetRange("Sales Invoice", true);
                        end;
                    }
                    dataitem(Signs;
                    "Integer")
                    {
                        DataItemTableView = sorting(Number) order(Ascending) where(Number = const(1));

                        column(Reciver_Caption;
                        Reciver_CaptionLbl)
                        {
                        }
                        column(Drawer_Caption;
                        Drawer_CaptionLbl)
                        {
                        }
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := '';
                        OutputNo += 1;
                    end;
                    TotalSubTotal := 0;
                    TotalInvDiscAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode() then Codeunit.Run(Codeunit::"Sales Inv.-Printed", "Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
                PostSalInvLineL: Record "Sales Invoice Line";
                Handled: Boolean;
            begin
                CurrReport.LANGUAGE := Language.GetLanguageIdOrDefault("Language Code");
                FormatAddressFields("Sales Invoice Header");
                FormatDocumentFields("Sales Invoice Header");
                if not Cust.Get("Bill-to Customer No.") then Clear(Cust);
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                GetLineFeeNoteOnReportHist("No.");
                if LogInteraction then
                    if not IsReportInPreviewMode then
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(SegManagement.SalesInvoiceInterDocType, "No.", 0, 0, Database::Contact, "Bill-to Contact No.", "Salesperson Code", "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(SegManagement.SalesInvoiceInterDocType, "No.", 0, 0, Database::Customer, "Bill-to Customer No.", "Salesperson Code", "Campaign No.", "Posting Description", '');
                Clear(AddrInfo);
                Clear(CourtInfo);
                AddrInfo := StrSubstNo('%1 %2', Text013, CompanyInfo."Phone No.") + ', ' + StrSubstNo('%1 %2', Text014, CompanyInfo."Fax No.") + ', ' + StrSubstNo('Internet: %1', CompanyInfo."Home Page") + ', ' + StrSubstNo('E-mail: %1', CompanyInfo."E-Mail");
#pragma warning disable AL0432
                //CourtInfo := StrSubstNo('%1: %2', 'KRS', CompanyInfo."ITI Registration No. 2");
#pragma warning restore AL0432
                CalcFields("Amount Including VAT");
                PrepmtInvoice := "Prepayment Invoice";
                if PrepmtInvoice then PrepaymentTxt := Text004;
                GLSetup.Get();
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyCode := GLSetup."LCY Code";
                    TotalTxt := StrSubstNo(Text001, GLSetup."LCY Code");
                end
                else begin
                    CurrencyCode := "Currency Code";
                    TotalTxt := StrSubstNo(Text001, "Currency Code");
                end;
                PostSalInvLineL.SetRange("Document No.", "No.");
                PostSalInvLineL.SetFilter("VAT Calculation Type", '%1', PostSalInvLineL."VAT Calculation Type"::"Reverse Charge VAT");
                if PostSalInvLineL.FindFirst() then
                    ShowVATSpec := true
                else
                    ShowVATSpec := false;

                //--jg20210418
                GetBank();
                if ("Sales Invoice Header"."Currency Code" <> '') and GLSetup."Print VAT specification in LCY" then
                    PrintSpecyficationVAT := true;
                //+++
            end;

            trigger OnPreDataItem()
            begin
                if Duplicate then begin
                    DuplicateTxt := Text012 + ' ';
                    DateTxt := Text011 + ' ';
                    DuplicateDateTxt := Format(DuplicateDate, 0, DateFormat) + ' ';
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';

                        trigger OnValidate()
                        begin
                            if NoOfCopies < 0 then NoOfCopies := 0;
                        end;
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies that any notes about additional fees are included on the document.';
                    }
                    field(Duplicate; Duplicate)
                    {
                        Caption = 'Duplicate';
                        ToolTip = 'Duplicate';
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            DuplicateDateEnable := Duplicate;
                            if Duplicate then
                                DuplicateDate := Today()
                            else
                                DuplicateDate := 0D;
                        end;
                    }
                    field(DuplicateDate; DuplicateDate)
                    {
                        Caption = 'Duplicate Date';
                        ToolTip = 'Duplicate Date';
                        Enabled = DuplicateDateEnable;
                        ApplicationArea = Basic, Suite;
                    }
                    field(ShowComment; ShowComment)
                    {
                        Caption = 'Show Notes';
                        ToolTip = 'Show Notes';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
            DuplicateDateEnable := Duplicate;
            if Duplicate then
                DuplicateDate := Today()
            else
                DuplicateDate := 0D;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
        CompanyInfo.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        DateFormat := '<Day,2>.<Month,2>.<Year4>';
        ShortDateFormat := '<Month,2>.<Year4>';
        Duplicate := false;
        VATClauseSPValue := '';
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage() then InitLogInteraction();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        VATClause: Record "VAT Clause";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        Language: Codeunit Language;
        BankAccount: Record "Bank Account";
        PrintSpecyficationVAT: Boolean;
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label 'Sales Invoice';
        PageCaptionCap: Label 'Page';
        Text006: Label 'Total %1 Excl. VAT';
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[50];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        VALExchRate: Text[50];
        Text009: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: Label 'Prepayment Invoice';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: Label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'IBAN No.';
        SalesInvDueDateCaptionLbl: Label 'Due Date';
        InvNoCaptionLbl: Label 'Invoice No.';
        PrepaymentInvNoCaptionLbl: Label 'Prepayment Invoice No.';
        SalesInvPostingDateCptnLbl: Label 'Posting Date';
        HeaderDimCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        PriceWithDiscountCaptionLbl: Label 'Unit Net Price';
        SalesInvLineDiscCaptionLbl: Label 'Discount %';
        AmountCaptionLbl: Label 'Amount';
        VATClausesCap: Label 'VAT Clause';
        PostedShipmentDateCaptionLbl: Label 'Posted Shipment Date';
        SubtotalCaptionLbl: Label 'Subtotal';
        LineAmtAfterInvDiscCptnLbl: Label 'Payment Discount on VAT';
        ShipmentCaptionLbl: Label 'Shipment';
        LineDimCaptionLbl: Label 'Line Dimensions';
        VATAmtSpecificationCptnLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        InvDiscountAmtCaptionLbl: Label 'Invoice Discount Amount';
        DocumentDateCaptionLbl: Label 'Document Date';
        PaymentTermsDescCaptionLbl: Label 'Payment Terms';
        ShptMethodDescCaptionLbl: Label 'Shipment Method';
        VATPercentageCaptionLbl: Label 'VAT %';
        TotalCaptionLbl: Label 'Total';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        HomePageCaptionLbl: Label 'Home Page';
        EMailCaptionLbl: Label 'Email';
        DisplayAdditionalFeeNote: Boolean;
        LineNoWithTotal: Integer;
        VATPercentageCaption2Lbl: Label 'VAT Rate';
        DuplicateTxt: Text[50];
        DateTxt: Text[50];
        DuplicateDateTxt: Text[50];
        DateFormat: Text[30];
        ShortDateFormat: Text[30];
        SalesPostPrepmts: Codeunit "Sales-Post Prepayments";
        PrepaymentTxt: Text[50];
        UnitOfMeasureTranslation: Record "Unit of Measure Translation";
        PrevPrepmt: Record "Sales Line" temporary;
        __: Integer;
        AddrInfo: Text[1024];
        CourtInfo: Text[1024];
        PaymentMethod: Record "Payment Method";
        DuplicateDate: Date;
        Duplicate: Boolean;
        PrintOnlyCopy: Boolean;
        [InDataSet]
        DuplicateDateEnable: Boolean;
        ShowSummaryLCY: Boolean;
        Pos: Integer;
        ShowComment: Boolean;
        TotalPrevPrepmtAmount: Decimal;
        AdvanceInvoice: Boolean;
        PrepmtInvoice: Boolean;
        CurrencyCode: Code[10];
        UnitOfMeasureTxt: Text[30];
        TotalTxt: Text[1024];
        VATClauseSPValue: Code[20];
        Text011: Label 'issued on';
        Text012: Label 'Duplicate';
        Text013: Label 'P';
        Text014: Label 'F';
        Text015: Label 'Equity capital:';
        Text016: Label 'Total to pay: %1 %2';
        Text017: Label 'Advance for Order No. %1';
        Text018: Label 'Advance Payment Date: %1';
        Text019: Label 'Advance Payment Amount: %1 %2';
        Text020: Label 'Order No. %1 Specification';
        Previous_Prapayments_CaptionLbl: Label 'Previous prepayment invoices';
        Reciver_CaptionLbl: Label 'Signature of person authorized to receive invoice';
        Drawer_CaptionLbl: Label 'Signature of person authorized to issue invoice';
        COMPANYNAME_CaptionLbl: Label 'Company Name';
        USERID_CaptionLbl: Label 'User ID';
        Page_CaptionLbl: Label 'Page No.';
        Document_CaptionLbl: Label 'Sales Invoice %1';
        CompanyTitle: Label 'Seller';
        CompanyInfoFaxNo_CaptionLbl: Label 'Fax No.';
        Email_CaptionLbl: Label 'E-mail';
        HomePage_CaptionLbl: Label 'Homepage';
        CompanyInfoSWIFTCode_CaptionLbl: Label 'SWIFT Code';
        CompanyInfoRegNo_CaptionLbl: Label 'Registration No.';
        ContractorNo_CaptionLbl: Label 'Customer';
        VATRegNo_CaptionLbl: Label 'VAT Registration No.';
        DocumentNo_CaptionLbl: Label 'Document No.';
        OrderNo_CaptionLbl: Label 'Order No.';
        PostingDate_Header_CaptionLbl: Label 'Posting Date';
        DocDate_Header_CaptionLbl: Label 'Document Date';
        DueDate_Header_CaptionLbl: Label 'Due Date';
        SalesDate_Header_CaptionLbl: Label 'Sales Date';
        PaymentTerm_Header_CaptionLbl: Label 'Payment Term';
        PaymentMethod_Header_CaptionLbl: Label 'Payment Method';
        QuoteNo_Header_CaptionLbl: Label 'Quote No.';
        ContractingPartyTitleLbl: Label 'Customer';
        TempDate_Header_CaptionLbl: Label 'Sales Date';
        ShipmentMethod_Header_CaptionLbl: Label 'Shipment Method';
        EquityCapital_CaptionLbl: Label 'Equity Capital';
        Prepayment_Document_TypeLbl: Label 'Document Type';
        Prepayment_Document_NoLbl: Label 'Document No.';
        Prepaymen_Vat_DateLbl: Label 'Document Date';
        Prepayment_Amount_Including_VATLbl: Label 'Amount Inc. VAT';
        UnitOfMeasureTxtLbl: Label 'Unit of Measure';
        SalesInvoiceLineVATClasue_CaptionLbl: Label 'VAT Clauses';
        SalesCommentLineCaptionLbl: Label 'Notes';
        ShowVATSpec: Boolean;
        AmountBeforeDiscount: Decimal;
        GTIN: Code[20];
        EANLbl: Label 'EAN';
        AmountBeforeDiscountLbl: Label 'Amount Before Discount';

    /// <summary>
    /// InitLogInteraction. 
    /// </summary>
    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody);
    end;

    local procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then if SalesShipmentHeader.Get("Sales Invoice Line"."Shipment No.") then exit(SalesShipmentHeader."Posting Date");
        if "Sales Invoice Header"."Order No." = '' then exit("Sales Invoice Header"."Posting Date");
        case "Sales Invoice Line".Type of
            "Sales Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Invoice Line");
            "Sales Invoice Line".Type::"G/L Account", "Sales Invoice Line".Type::Resource, "Sales Invoice Line".Type::"Charge (Item)", "Sales Invoice Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Invoice Line");
            "Sales Invoice Line".Type::" ":
                exit(0D);
        end;
        SalesShipmentBuffer.Reset();
        SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next() = 0 then begin
                SalesShipmentBuffer.Get(SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete();
                exit(SalesShipmentBuffer2."Posting Date");
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll();
                exit("Sales Invoice Header"."Posting Date");
            end;
        end
        else
            exit("Sales Invoice Header"."Posting Date");
    end;

    local procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(SalesInvoiceLine2, -Quantity, ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    local procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetFilter("No.", '..%1', "Sales Invoice Header"."No.");
        SalesInvoiceHeader.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.Find('-') then
            repeat
                SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SetRange("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SetRange("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.Next() = 0;
            until SalesInvoiceHeader.Next() = 0;
        SalesShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        SalesShipmentLine.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
        if SalesShipmentLine.Find('-') then
            repeat
                if "Sales Invoice Header"."Get Shipment Used" then CorrectShipment(SalesShipmentLine);
                if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity := SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;
                    if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then AddBufferEntry(SalesInvoiceLine, Quantity, SalesShipmentHeader."Posting Date");
                end;
            until (SalesShipmentLine.Next() = 0) or (TotalQuantity = 0);
    end;

    local procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentKey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line";
    QtyOnShipment: Decimal;
    PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.Modify();
            exit;
        end;
        //with SalesShipmentBuffer do begin
        SalesShipmentBuffer."Document No." := SalesInvoiceLine."Document No.";
        SalesShipmentBuffer."Line No." := SalesInvoiceLine."Line No.";
        SalesShipmentBuffer."Entry No." := NextEntryNo;
        SalesShipmentBuffer.Type := SalesInvoiceLine.Type;
        SalesShipmentBuffer."No." := SalesInvoiceLine."No.";
        SalesShipmentBuffer.Quantity := QtyOnShipment;
        SalesShipmentBuffer."Posting Date" := PostingDate;
        SalesShipmentBuffer.INSERT;
        NextEntryNo := NextEntryNo + 1 //end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        //---jg
        //if "Sales Invoice Header"."Prepayment Invoice" then exit(Text010);

        if "Sales Invoice Header"."Prepayment Invoice" or "Sales Invoice Header"."TOR Prepayment Invoice" then
            exit(Text010);
        //+++
        exit(Text004);
    end;

    /// <summary>
    /// InitializeRequest. 
    /// </summary>

    /// <param name="NewNoOfCopies">Integer.</param>

    /// <param name="NewShowInternalInfo">Boolean.</param>

    /// <param name="NewLogInteraction">Boolean.</param>

    /// <param name="DisplayAsmInfo">Boolean.</param>
    procedure InitializeRequest(NewNoOfCopies: Integer;
     NewShowInternalInfo: Boolean;
     NewLogInteraction: Boolean;
     DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure FormatDocumentFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        //with SalesInvoiceHeader do begin
        FormatDocument.SetTotalLabels(SalesInvoiceHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson, SalesInvoiceHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesInvoiceHeader."Payment Terms Code", SalesInvoiceHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesInvoiceHeader."Shipment Method Code", SalesInvoiceHeader."Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesInvoiceHeader."Payment Method Code", SalesInvoiceHeader."Language Code");
        OrderNoText := FormatDocument.SetText(SalesInvoiceHeader."Order No." <> '', CopyStr(SalesInvoiceHeader.FieldCaption("Order No."), 1, 80));
        ReferenceText := FormatDocument.SetText(SalesInvoiceHeader."Your Reference" <> '', CopyStr(SalesInvoiceHeader.FieldCaption("Your Reference"), 1, 80));
        VATNoText := FormatDocument.SetText(SalesInvoiceHeader."VAT Registration No." <> '', CopyStr(SalesInvoiceHeader.FieldCaption("VAT Registration No."), 1, 80));
        //end;
    end;

    local procedure FormatAddressFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesInvBillTo(CustAddr, SalesInvoiceHeader);
        ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, SalesInvoiceHeader);
    end;

    local procedure CollectAsmInformation()
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DeleteAll();
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then exit;
        //with ValueEntry do begin
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
        ValueEntry.SetRange(Adjustment, false);
        if not ValueEntry.FindSet() then exit;
        //end;
        repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet() then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next() = 0;
                    end;
                end;
        until ValueEntry.Next() = 0;
    end;

    local procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst() then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify();
        end
        else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert();
        end;
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    /// <summary>
    /// BlanksForIndent. 
    /// </summary>
    /// <returns>Return value of type Text[10].</returns>
    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst() then exit;
        if not Customer.Get(CustLedgerEntry."Customer No.") then exit;
        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet() then begin
            repeat
                TempLineFeeNoteOnReportHist.Init();
                TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert();
            until LineFeeNoteOnReportHist.Next() = 0;
        end
        else begin
            LineFeeNoteOnReportHist.SetRange("Language Code", Language.GetUserLanguageCode);
            if LineFeeNoteOnReportHist.FindSet() then
                repeat
                    TempLineFeeNoteOnReportHist.Init();
                    TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert();
                until LineFeeNoteOnReportHist.Next() = 0;
        end;
    end;

    local procedure SetMandatorySplitPaymentVATClause()
    var
        VATAttributeValue: Record "ITI VAT Attribute Value";
        VATAttrMgt: Codeunit "ITI VATAttributeManagement";
    begin
        VATAttributeValue.SetRange("VAT Attribute Code", GLSetup."ITI SP VAT Attribute");
        if not VATAttributeValue.FindFirst() then
            exit;
        if VATAttrMgt.CheckIfVATAttrExist("Sales Invoice Header"."ITI VAT Attribute Set ID", VATAttributeValue."VAT Attribute Code", VATAttributeValue.Code) then begin
            VATAmountLine.Init();
            VATAmountLine."VAT Identifier" := GLSetup."ITI Split Payment VAT Clause";
            VATAmountLine."VAT Clause Code" := GLSetup."ITI Split Payment VAT Clause";
            VATAmountLine.Insert();
        end;
    end;

    local procedure GetGTIN(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit(Item.GTIN);
    end;

    local procedure GetAmountBeforeDiscount(SalesInvLine: Record "Sales Invoice Line"): Decimal
    begin
        if SalesInvLine.Type = SalesInvLine.Type::Item then
            if SalesInvLine.Quantity <> 0 then
                exit(SalesInvLine.Quantity * SalesInvLine."Unit Price")
    end;
    //Begin TG-TDAG00000-002/dho
    local procedure GetTariffNo(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        if Cust."Customer Posting Group" <> 'NAT' then
            if Item.Get(ItemNo) then
                exit(Item."Tariff No.");
    end;

    local procedure GetBankAccountName(): Text[100]
    var
    //BankAccount: Record "Bank Account";
    //BankAccountNo: Code[20];
    begin
        //BankAccountNo := "Sales Invoice Header"."Currency Code";
        //if "Sales Invoice Header"."Currency Code" = '' then BankAccountNo := 'PLN';
        //if BankAccount.Get(BankAccountNo) then 
        exit(BankAccount.Name);
    end;

    local procedure GetBankAccountNo(): Text[30]
    var
    //BankAccount: Record "Bank Account";
    //BankAccountNo: Code[20];
    begin
        //BankAccountNo := "Sales Invoice Header"."Currency Code";
        //if "Sales Invoice Header"."Currency Code" = '' then BankAccountNo := 'PLN';
        //if BankAccount.Get(BankAccountNo) then 
        exit(BankAccount."Bank Account No.");
    end;

    local procedure GetBankAccountSwift(): Code[20]
    var
    //BankAccount: Record "Bank Account";
    //BankAccountNo: Code[20];
    begin
        //BankAccountNo := "Sales Invoice Header"."Currency Code";
        //if "Sales Invoice Header"."Currency Code" = '' then BankAccountNo := 'PLN';
        //if BankAccount.Get(BankAccountNo) then 
        exit(BankAccount."SWIFT Code");
    end;

    local procedure GetBankAccountIban(): Code[50]
    var
    //BankAccount: Record "Bank Account";
    //BankAccountNo: Code[20];
    begin
        //BankAccountNo := "Sales Invoice Header"."Currency Code";
        //if "Sales Invoice Header"."Currency Code" = '' then BankAccountNo := 'PLN';
        //if BankAccount.Get(BankAccountNo) then 
        exit(BankAccount.IBAN);
    end;
    //End TG-TDAG00000-002/dho
    //Begin TG-TDAG00000-003/dho
    local procedure GetPriceWithDiscount(): Decimal
    begin
        if "Sales Invoice Line".Quantity > 0 then exit(Round("Sales Invoice Line"."VAT Base Amount" / "Sales Invoice Line".Quantity, 0.0001));
    end;

    local procedure getLastModifiedBy(): Code[50]
    var
        User: Record User;
    begin
        if User.Get("Sales Invoice Header".SystemModifiedBy) then exit(User."Full Name");
    end;
    //End TG-TDAG00000-003/dho
    //begin jg 20210418
    local procedure GetUserName(): Text[100]
    var
        User: Record User;
    begin
        User.SetRange("User Name", "Sales Invoice Header"."User ID");
        if User.FindSet() then
            exit(User."Full Name");
    end;

    local procedure GetBank()
    var
        BankAccountNo: Code[20];
    begin

        BankAccountNo := "Sales Invoice Header"."Currency Code";
        if "Sales Invoice Header"."Currency Code" = '' then
            BankAccountNo := 'PLN';

        if not BankAccount.Get(BankAccountNo) then
            BankAccount.Init();
        ;
    end;

    //end jg 20210418
}
