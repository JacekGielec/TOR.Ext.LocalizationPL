/// <summary>
/// Report TOR Pro Forma Sales Invoice (ID 50451).
/// </summary>
report 50451 "TOR Pro Forma Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORProFormaSalesInvoice.rdlc';
    Caption = 'Pro Forma Invoice';

    dataset
    {
        dataitem(Header;
        "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Pro Forma Invoice';

            column(DocumentDate;
            Format("Document Date", 0, 4))
            {
            }
            column(CompanyPicture;
            CompanyInformation.Picture)
            {
            }
            column(CompanyEMail;
            CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage;
            CompanyInformation."Home Page")
            {
            }
            column(CompanyPhoneNo;
            CompanyInformation."Phone No.")
            {
            }
            column(CompanyVATRegNo;
            CompanyInformation.GetVATRegistrationNumber())
            {
            }
            column(CompanyAddress1;
            CompanyAddress[1])
            {
            }
            column(CompanyAddress2;
            CompanyAddress[2])
            {
            }
            column(CompanyAddress3;
            CompanyAddress[3])
            {
            }
            column(CompanyAddress4;
            CompanyAddress[4])
            {
            }
            column(CompanyAddress5;
            CompanyAddress[5])
            {
            }
            column(CompanyAddress6;
            CompanyAddress[6])
            {
            }
            column(CustomerAddress1;
            CustomerAddress[1])
            {
            }
            column(CustomerAddress2;
            CustomerAddress[2])
            {
            }
            column(CustomerAddress3;
            CustomerAddress[3])
            {
            }
            column(CustomerAddress4;
            CustomerAddress[4])
            {
            }
            column(CustomerAddress5;
            CustomerAddress[5])
            {
            }
            column(CustomerAddress6;
            CustomerAddress[6])
            {
            }
            column(CustomerAddress7;
            CustomerAddress[7])
            {
            }
            column(CustomerAddress8;
            CustomerAddress[8])
            {
            }
            column(SellToContactPhoneNoLbl;
            SellToContactPhoneNoLbl)
            {
            }
            column(SellToContactMobilePhoneNoLbl;
            SellToContactMobilePhoneNoLbl)
            {
            }
            column(SellToContactEmailLbl;
            SellToContactEmailLbl)
            {
            }
            column(BillToContactPhoneNoLbl;
            BillToContactPhoneNoLbl)
            {
            }
            column(BillToContactMobilePhoneNoLbl;
            BillToContactMobilePhoneNoLbl)
            {
            }
            column(BillToContactEmailLbl;
            BillToContactEmailLbl)
            {
            }
            column(SellToContactPhoneNo;
            SellToContact."Phone No.")
            {
            }
            column(SellToContactMobilePhoneNo;
            SellToContact."Mobile Phone No.")
            {
            }
            column(SellToContactEmail;
            SellToContact."E-Mail")
            {
            }
            column(BillToContactPhoneNo;
            BillToContact."Phone No.")
            {
            }
            column(BillToContactMobilePhoneNo;
            BillToContact."Mobile Phone No.")
            {
            }
            column(BillToContactEmail;
            BillToContact."E-Mail")
            {
            }
            column(YourReference;
            "Your Reference")
            {
            }
            column(ExternalDocumentNo;
            "External Document No.")
            {
            }
            column(DocumentNo;
            "No.")
            {
            }
            column(CompanyLegalOffice;
            CompanyInformation.GetLegalOffice())
            {
            }
            column(SalesPersonName;
            SalespersonPurchaserName)
            {
            }
            column(ShipmentMethodDescription;
            ShipmentMethodDescription)
            {
            }
            column(Currency;
            CurrencyCode)
            {
            }
            column(CustomerVATRegNo;
            GetCustomerVATRegistrationNumber())
            {
            }
            column(CustomerVATRegistrationNoLbl;
            GetCustomerVATRegistrationNumberLbl())
            {
            }
            column(PageLbl;
            PageLbl)
            {
            }
            column(DocumentTitleLbl;
            DocumentCaption())
            {
            }
            column(YourReferenceLbl;
            FieldCaption("Your Reference"))
            {
            }
            column(ExternalDocumentNoLbl;
            FieldCaption("External Document No."))
            {
            }
            column(CompanyLegalOfficeLbl;
            CompanyInformation.GetLegalOfficeLbl())
            {
            }
            column(SalesPersonLbl;
            SalesPersonLblText)
            {
            }
            column(EMailLbl;
            CompanyInformation.FieldCaption("E-Mail"))
            {
            }
            column(HomePageLbl;
            CompanyInformation.FieldCaption("Home Page"))
            {
            }
            column(CompanyPhoneNoLbl;
            CompanyInformation.FieldCaption("Phone No."))
            {
            }
            column(ShipmentMethodDescriptionLbl;
            DummyShipmentMethod.TableCaption)
            {
            }
            column(CurrencyLbl;
            DummyCurrency.TableCaption)
            {
            }
            column(ItemLbl;
            Item.TableCaption)
            {
            }
            column(TariffLbl;
            Item.FieldCaption("Tariff No."))
            {
            }
            column(UnitPriceLbl;
            Item.FieldCaption("Unit Price"))
            {
            }
            column(CountryOfManufactuctureLbl;
            CountryOfManufactuctureLbl)
            {
            }
            column(AmountLbl;
            Line.FieldCaption(Amount))
            {
            }
            column(VATPctLbl;
            Line.FieldCaption("VAT %"))
            {
            }
            column(VATAmountLbl;
            DummyVATAmountLine.VATAmountText())
            {
            }
            column(TotalWeightLbl;
            TotalWeightLbl)
            {
            }
            column(TotalAmountLbl;
            TotalAmountLbl)
            {
            }
            column(TotalAmountInclVATLbl;
            TotalAmountInclVATLbl)
            {
            }
            column(QuantityLbl;
            Line.FieldCaption(Quantity))
            {
            }
            column(NetWeightLbl;
            Line.FieldCaption("Net Weight"))
            {
            }
            column(DeclartionLbl;
            DeclartionLbl)
            {
            }
            column(SignatureLbl;
            SignatureLbl)
            {
            }
            column(SignatureNameLbl;
            SignatureNameLbl)
            {
            }
            column(SignaturePositionLbl;
            SignaturePositionLbl)
            {
            }
            column(VATRegNoLbl;
            CompanyInformation.GetVATRegistrationNumberLbl())
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
            column(CompanyInfoSWIFTCode;
            GetBankAccountSwift())
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
            column(CompanyInfoSWIFTCode_Caption;
            CompanyInfoSWIFTCode_CaptionLbl)
            {
            }
            dataitem(Line;
            "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(ItemDescription;
                Description)
                {
                }
                column(CountryOfManufacturing;
                Item."Country/Region of Origin Code")
                {
                }
                column(Tariff;
                Item."Tariff No.")
                {
                }
                column(Quantity;
                "Qty. to Invoice")
                {
                }
                column(Price;
                FormattedLinePrice)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(NetWeight;
                "Net Weight")
                {
                }
                column(LineAmount;
                FormattedLineAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(VATPct;
                "VAT %")
                {
                }
                column(VATAmount;
                FormattedVATAmount)
                {
                }
                trigger OnAfterGetRecord()
                var
                    AutoFormatType: Enum "Auto Format";
                begin
                    //Begin TG-TDAG00000-002/dho
                    //Item.Get("No.");
                    Clear(Item);
                    if Line.Type = Line.Type::Item then
                        Item.Get("No.");
                    //End   TG-TDAG00000-002/dho
                    OnBeforeLineOnAfterGetRecord(Header, Line);
                    if Quantity = 0 then begin
                        LinePrice := "Unit Price";
                        LineAmount := 0;
                        VATAmount := 0;
                    end
                    else begin
                        LinePrice := Round(Amount / Quantity, Currency."Unit-Amount Rounding Precision");
                        LineAmount := Round(Amount * "Qty. to Invoice" / Quantity, Currency."Amount Rounding Precision");
                        VATAmount := Round(Amount * "VAT %" / 100 * "Qty. to Invoice" / Quantity, Currency."Amount Rounding Precision");
                        TotalAmount += LineAmount;
                        TotalWeight += Round("Qty. to Invoice" * "Net Weight");
                        TotalVATAmount += VATAmount;
                        TotalAmountInclVAT += Round("Amount Including VAT" * "Qty. to Invoice" / Quantity, Currency."Amount Rounding Precision");
                    end;
                    FormattedLinePrice := Format(LinePrice, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::UnitAmountFormat, CurrencyCode));
                    FormattedLineAmount := Format(LineAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                    FormattedVATAmount := Format(VATAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                end;

                trigger OnPreDataItem()
                begin
                    TotalWeight := 0;
                    TotalAmount := 0;
                    TotalVATAmount := 0;
                    TotalAmountInclVAT := 0;
                    //Begin TG-TDAG00000-002/dho
                    //SetRange(Type, Type::Item);
                    SetFilter(Type, '%1|%2|%3', Type::Item, Type::"G/L Account", Type::"Charge (Item)");
                    //End TG-TDAG00000-002/dho
                    OnAfterLineOnPreDataItem(Header, Line);
                end;
            }
            dataitem(Totals;
            "Integer")
            {
                MaxIteration = 1;

                column(TotalWeight;
                TotalWeight)
                {
                }
                column(TotalValue;
                FormattedTotalAmount)
                {
                }
                column(TotalVATAmount;
                FormattedTotalVATAmount)
                {
                }
                column(TotalAmountInclVAT;
                FormattedTotalAmountInclVAT)
                {
                }
                trigger OnPreDataItem()
                var
                    AutoFormatType: Enum "Auto Format";
                begin
                    FormattedTotalAmount := Format(TotalAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                    FormattedTotalVATAmount := Format(TotalVATAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                    FormattedTotalAmountInclVAT := Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");
                FormatDocumentFields(Header);
                if SellToContact.Get("Sell-to Contact No.") then;
                if BillToContact.Get("Bill-to Contact No.") then;
            end;
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
    trigger OnInitReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        Item: Record Item;
        DummyVATAmountLine: Record "VAT Amount Line";
        DummyShipmentMethod: Record "Shipment Method";
        DummyCurrency: Record Currency;
        Currency: Record Currency;
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        Language: Codeunit Language;
        AutoFormat: Codeunit "Auto Format";
        CompanyAddress: array[8] of Text[100];
        CustomerAddress: array[8] of Text[100];
        SalesPersonLblText: Text[50];
        DocumentTitleLbl: Label 'Pro Forma Invoice';
        PageLbl: Label 'Page';
        CountryOfManufactuctureLbl: Label 'Country';
        TotalWeightLbl: Label 'Total Weight';
        SalespersonPurchaserName: Text;
        ShipmentMethodDescription: Text;
        TotalAmountLbl: Text[50];
        TotalAmountInclVATLbl: Text[50];
        FormattedLinePrice: Text;
        FormattedLineAmount: Text;
        FormattedVATAmount: Text;
        FormattedTotalAmount: Text;
        FormattedTotalVATAmount: Text;
        FormattedTotalAmountInclVAT: Text;
        CurrencyCode: Code[10];
        TotalWeight: Decimal;
        TotalAmount: Decimal;
        DeclartionLbl: Label 'For customs purposes only.';
        SignatureLbl: Label 'For and on behalf of the above named company:';
        SignatureNameLbl: Label 'Name (in print) Signature';
        SignaturePositionLbl: Label 'Position in company';
        SellToContactPhoneNoLbl: Label 'Sell-to Contact Phone No.';
        SellToContactMobilePhoneNoLbl: Label 'Sell-to Contact Mobile Phone No.';
        SellToContactEmailLbl: Label 'Sell-to Contact E-Mail';
        BillToContactPhoneNoLbl: Label 'Bill-to Contact Phone No.';
        BillToContactMobilePhoneNoLbl: Label 'Bill-to Contact Mobile Phone No.';
        BillToContactEmailLbl: Label 'Bill-to Contact E-Mail';
        TotalVATAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        LinePrice: Decimal;
        LineAmount: Decimal;
        VATAmount: Decimal;
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        CompanyInfoSWIFTCode_CaptionLbl: Label 'SWIFT Code';

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        ResponsibilityCenter: Record "Responsibility Center";
        Customer: Record Customer;
        FormatDocument: Codeunit "Format Document";
        FormatAddress: Codeunit "Format Address";
        TotalAmounExclVATLbl: Text[50];
    begin
        //with SalesHeader do begin
        Customer.Get(SalesHeader."Sell-to Customer No.");
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesHeader."Salesperson Code", SalesPersonLblText);
        SalespersonPurchaserName := SalespersonPurchaser.Name;
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");
        ShipmentMethodDescription := ShipmentMethod.Description;
        FormatAddress.GetCompanyAddr(SalesHeader."Responsibility Center", ResponsibilityCenter, CompanyInformation, CompanyAddress);
        FormatAddress.SalesHeaderBillTo(CustomerAddress, SalesHeader);
        if SalesHeader."Currency Code" = '' then begin
            GeneralLedgerSetup.Get();
            GeneralLedgerSetup.TestField("LCY Code");
            CurrencyCode := GeneralLedgerSetup."LCY Code";
            Currency.InitRoundingPrecision();
        end
        else begin
            CurrencyCode := SalesHeader."Currency Code";
            Currency.Get(SalesHeader."Currency Code");
        end;
        FormatDocument.SetTotalLabels(SalesHeader."Currency Code", TotalAmountLbl, TotalAmountInclVATLbl, TotalAmounExclVATLbl);
        //end;
    end;

    local procedure DocumentCaption(): Text
    var
        DocCaption: Text;
    begin
        OnBeforeGetDocumentCaption(Header, DocCaption);
        if DocCaption <> '' then exit(DocCaption);
        exit(DocumentTitleLbl);
    end;

    //Begin TG-TDAG00000-002/dho
    local procedure GetBankAccountName(): Text[100]
    var
        BankAccount: Record "Bank Account";
        BankAccountNo: Code[20];
    begin
        BankAccountNo := Header."Currency Code";
        if Header."Currency Code" = '' then
            BankAccountNo := 'PLN';
        if BankAccount.Get(BankAccountNo) then
            exit(BankAccount.Name);
    end;

    local procedure GetBankAccountNo(): Text[30]
    var
        BankAccount: Record "Bank Account";
        BankAccountNo: Code[20];
    begin
        BankAccountNo := Header."Currency Code";
        if Header."Currency Code" = '' then
            BankAccountNo := 'PLN';
        if BankAccount.Get(BankAccountNo) then
            exit(BankAccount."Bank Account No.");
    end;

    local procedure GetBankAccountSwift(): Code[20]
    var
        BankAccount: Record "Bank Account";
        BankAccountNo: Code[20];
    begin
        BankAccountNo := Header."Currency Code";
        if Header."Currency Code" = '' then
            BankAccountNo := 'PLN';
        if BankAccount.Get(BankAccountNo) then
            exit(BankAccount."SWIFT Code");
    end;

    local procedure GetBankAccountIban(): Code[50]
    var
        BankAccount: Record "Bank Account";
        BankAccountNo: Code[20];
    begin
        BankAccountNo := Header."Currency Code";
        if Header."Currency Code" = '' then
            BankAccountNo := 'PLN';
        if BankAccount.Get(BankAccountNo) then
            exit(BankAccount.IBAN);
    end;
    //End TG-TDAG00000-002/dho

    [IntegrationEvent(false, false)]
    local procedure OnAfterLineOnPreDataItem(var SalesHeader: Record "Sales Header";
    var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDocumentCaption(SalesHeader: Record "Sales Header";
    var DocCaption: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLineOnAfterGetRecord(SalesHeader: Record "Sales Header";
    var SalesLine: Record "Sales Line")
    begin
    end;
}
