report 50467 "TOR Cust. Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORCustReconciliation.rdlc';
    Caption = 'Customer - Bal. Reconciliation';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Print Statements", Blocked;
            column(DocumentNo; DocumentNo_CaptionLbl)
            {
            }
            column(PaymentTermsDescCaption; PaymentTermsDescCaptionLbl)
            {
            }
            column(HomePage_Caption; HomePage_CaptionLbl)
            {
            }
            column(EMail_Caption; Email_CaptionLbl)
            {
            }
            column(CustomerAddr; CustAddr1[1])
            {
            }
            column(CompAddr; CompAddr1[1])
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(UserID; USERID)
                    {
                    }
                    column(UserID_Caption; USERID_CaptionLbl)
                    {
                    }
                    column(COMPANYNAME; COMPANYNAME)
                    {
                    }
                    column(COMPANYNAME_Caption; COMPANYNAME_CaptionLbl)
                    {
                    }
                    column(Page_Caption; Page_CaptionLbl)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(HomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(EMail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(Document_Caption; STRSUBSTNO(Document_CaptionLbl, CopyText))
                    {
                    }
                    column(ContractingPartyTitle; ContractingPartyTitleLbl)
                    {
                    }
                    column(ContractorNo; Customer."No.")
                    {
                    }
                    column(ContractingAddr1; CustAddr[1])
                    {
                    }
                    column(ContractingAddr2; CustAddr[2])
                    {
                    }
                    column(ContractingAddr3; CustAddr[3])
                    {
                    }
                    column(ContractingAddr4; CustAddr[4])
                    {
                    }
                    column(ContractingAddr5; CustAddr[5])
                    {
                    }
                    column(ContractingAddr6; CustAddr[6])
                    {
                    }
                    column(ContractingAddr7; CustAddr[7])
                    {
                    }
                    column(ContractingAddr8; CustAddr[8])
                    {
                    }
                    column(Company_Title; CompanyTitle)
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompanyInfoRegNo; CompanyInfo."Registration No.")
                    {
                    }
                    column(CompanyInfoSWIFTCode; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(Addr_Info; AddrInfo)
                    {
                    }
                    column(Court_Info; CourtInfo)
                    {
                    }
                    column(DocDate_Header; DocDate_Header_CaptionLbl)
                    {
                    }
                    column(PostingDate_Header; PostingDate_Header_CaptionLbl)
                    {
                    }
                    column(DueDate_Header; DueDate_Header_CaptionLbl)
                    {
                    }
                    column(TempDate_Header; '')
                    {
                    }
                    column(VATDate_Header; '')
                    {
                    }
                    column(VATRegNo; Customer."VAT Registration No.")
                    {
                    }
                    column(OrderNo_Header; '')
                    {
                    }
                    column(QuoteNo_Header; '')
                    {
                    }
                    column(PaymentTerm_Header; PaymentTerms.Description)
                    {
                    }
                    column(PaymentMethod_Header; PaymentMethod.Code)
                    {
                    }
                    column(ShipmentMethod_Header; ShipmentMethod.Description)
                    {
                    }
                    column(VATRegNo_Caption; VATRegNo_CaptionLbl)
                    {
                    }
                    column(CompanyInfoPhoneNo_Caption; CompanyInfoPhoneNo_CaptionLbl)
                    {
                    }
                    column(CompanyInfoRegNo_Caption; CompanyInfoRegNo_CaptionLbl)
                    {
                    }
                    column(CompanyInfoBankName_Caption; CompanyInfoBankName_CaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccNo_Caption; CompanyInfoBankAccNo_CaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNo_Caption; CompanyInfoVATRegNo_CaptionLbl)
                    {
                    }
                    column(CompanyInfoSWIFTCode_Caption; CompanyInfoSWIFTCode_CaptionLbl)
                    {
                    }
                    column(ContractorNo_Caption; ContractorNo_CaptionLbl)
                    {
                    }
                    column(OrderNo_Caption; OrderNo_CaptionLbl)
                    {
                    }
                    column(DocDate_Header_Caption; DocDate_Header_CaptionLbl)
                    {
                    }
                    column(DueDate_Header_Caption; DueDate_Header_CaptionLbl)
                    {
                    }
                    column(VATDate_Header_Caption; VATDate_Header_CaptionLbl)
                    {
                    }
                    column(TempDate_Header_Caption; TempDate_Header_CaptionLbl)
                    {
                    }
                    column(PaymentMethod_Header_Caption; PaymentMethod_Header_CaptionLbl)
                    {
                    }
                    column(DocumentNo_Caption; DocumentNo_CaptionLbl)
                    {
                    }
                    column(PostingDate_Header_Caption; PostingDate_Header_CaptionLbl)
                    {
                    }
                    column(QuoteNo_Header_Caption; QuoteNo_Header_CaptionLbl)
                    {
                    }
                    column(ShipmentMethod_Header_Caption; ShipmentMethod_Header_CaptionLbl)
                    {
                    }
                    column(CustomerLastStatementNo; Customer."Last Statement No.")
                    {
                    }
                    column(StatementNo_Caption; StatementNo_CaptionLbl)
                    {
                    }
                    column(Section_Number; Number)
                    {
                    }
                    column(LawText_Caption; LawText)
                    {
                    }
                    column(ConfirmationText_Caption; STRSUBSTNO(Text003, ReturnDate - ReconcileDate, LongReconcileDate))
                    {
                    }
                    column(OnBaseCaption; Text015)
                    {
                    }
                    column(MutualBalance_Caption; MutualBalance_CaptionLbl)
                    {
                    }
                    column(CompanyAddr9; CompanyAddr[9])
                    {
                    }
                    column(CompanyAddr10; CompanyAddr[10])
                    {
                    }
                    column(CompanyAddr11; CompanyAddr[11])
                    {
                    }
                    column(CompanyAddr12; CompanyAddr[12])
                    {
                    }
                    column(CompanyInfoFaxNo_Caption; CompanyInfoFaxNo_CaptionLbl)
                    {
                    }
                    column(CustAddr9; CustAddr[9])
                    {
                    }
                    column(CustAddr10; CustAddr[10])
                    {
                    }
                    column(CustAddr11; CustAddr[11])
                    {
                    }
                    column(CustAddr12; CustAddr[12])
                    {
                    }
                    column(Group2Field18; AddrInfo)
                    {
                    }
                    column(Group2Field19; AddrInfo)
                    {
                    }
                    column(CopyText_Caption; CopyText)
                    {
                    }
                    column(TodayFormatted_Header; FORMAT(TODAY, 0, '<day,2>-<month,2>-<year4>'))
                    {
                    }
                    column(Group3Field25; AddrInfo)
                    {
                    }
                    column(Group3Field26; AddrInfo)
                    {
                    }
                    column(Group3Field27; AddrInfo)
                    {
                    }
                    column(Group3Field28; AddrInfo)
                    {
                    }
                    column(Group4Field7; AddrInfo)
                    {
                    }
                    column(Group4Field8; AddrInfo)
                    {
                    }
                    column(Group4Field9; AddrInfo)
                    {
                    }
                    column(Group4Field10; AddrInfo)
                    {
                    }
                    column(Group4Field11; AddrInfo)
                    {
                    }
                    column(Group4Field12; AddrInfo)
                    {
                    }
                    column(PrintAmountsInCurrency; PrintAmountsInCurrency)
                    {
                    }
                    column(Accountant_Caption; Accountant_CaptionLbl)
                    {
                    }
                    column(Name_Caption; Name_CaptionLbl)
                    {
                    }
                    column(Signature_Caption; Signature_CaptionLbl)
                    {
                    }
                    dataitem(TotalInCurrency; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(CompanyInfo_Name; CompanyInfo.Name)
                        {
                        }
                        column(Customer_Name; Customer.Name)
                        {
                        }
                        column(DebitAmount; DebitAmount)
                        {
                        }
                        column(CreditAmount; CreditAmount)
                        {
                        }
                        column(Final_Balance_Caption; STRSUBSTNO(Text011, GetCurrCode(CurrencyBuf.Code)))
                        {
                        }
                        column(InAccordance_Caption; InAccordance_CaptionLbl)
                        {
                        }
                        column(Debit_Caption; Debit_CaptionLbl)
                        {
                        }
                        column(Credit_Caption; Credit_CaptionLbl)
                        {
                        }
                        column(TotalInCurrency_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                OK := CurrencyBuf.FINDFIRST
                            else
                                OK := CurrencyBuf.NEXT <> 0;
                            if not OK then
                                CurrReport.BREAK;
                            if PrintAmountsInCurrency and (CurrencyBuf.Code <> '') then begin
                                TotalAmount := CVMgt.CalcCVDebt(Customer."No.", VendorNo, CurrencyBuf.Code, ReconcileDate, false);
                                DebitCreditCalc(Customer."No.", VendorNo, CurrencyBuf.Code, ReconcileDate, false);
                            end else
                                DebitCreditCalc(Customer."No.", VendorNo, '', ReconcileDate, true);
                        end;
                    }
                    dataitem(Footer; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(BalanceAcceptance_Caption; STRSUBSTNO(Text007, ReturnDate) + Text008 + STRSUBSTNO(Text009, Contact."Mobile Phone No."))
                        {
                        }
                        column(OurFax_Caption; STRSUBSTNO(Text006, Contact."E-Mail"))
                        {
                        }
                        column(OutAddress_Caption; STRSUBSTNO(Text005, CompanyInfo.Address, CompanyInfo.City, CompanyInfo."Post Code"))
                        {
                        }
                        column(ConfirmBalance_Caption; STRSUBSTNO(Text004, ReconcileDate, ReturnDate))
                        {
                        }
                        column(Footer_Number; Number)
                        {
                        }
                    }
                    dataitem(Currencies; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        dataitem(CVLedgEntryBuf; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(OpenDocuments_Caption; STRSUBSTNO(Text013, CurrencyBuf.Code))
                            {
                            }
                            column(and_Caption; and_CaptionLbl)
                            {
                            }
                            column(Amount_Caption; Amount_CaptionLbl)
                            {
                            }
                            column(CurrencyCode_Caption; CurrencyCode_CaptionLbl)
                            {
                            }
                            column(DocumentType_Caption; DocumentType_CaptionLbl)
                            {
                            }
                            column(RemainingAmount_Caption; RemainingAmount_CaptionLbl)
                            {
                            }
                            column(RemainingAmtLCY_Caption; RemainingAmtLCY_CaptionLbl)
                            {
                            }
                            column(Currencies_Number; Number)
                            {
                            }
                            column(Document_Date_CVLedgEntry; CVLedgEntry."Document Date")
                            {
                            }
                            column(Document_Type_CVLedgEntry; FORMAT(CVLedgEntry."Document Type"))
                            {
                            }
                            column(Currency_Code_CVLedgEntry; CVLedgEntry."Currency Code")
                            {
                            }
                            column(Due_Date_CVLedgEntry; CVLedgEntry."Due Date")
                            {
                            }
                            column(Amount_CVLedgEntry; CVLedgEntry.Amount)
                            {
                            }
                            column(Remaining_Amount_CVLedgEntry; CVLedgEntry."Remaining Amount")
                            {
                            }
                            column(Remaining_Amt_LCY_CVLedgEntry; CVLedgEntry."Remaining Amt. (LCY)")
                            {
                            }
                            column(Document_No_CVLedgEntry; CVLedgEntry."Document No.")
                            {
                            }
                            column(Number_CVLedgEntryBuf; Number)
                            {
                            }
                            column(TotalCurrency_Caption; STRSUBSTNO(Text012, GetCurrCode(CurrencyBuf.Code)))
                            {
                            }
                            column(TotalLCY_Caption; STRSUBSTNO(Text012, Text014))
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    OK := CVLedgEntry.FINDFIRST
                                else
                                    OK := CVLedgEntry.NEXT <> 0;
                                if not OK then
                                    CurrReport.BREAK;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CVLedgEntry.SETCURRENTKEY("Document Date");
                                if PrintAmountsInCurrency then
                                    CVLedgEntry.SETFILTER("Currency Code", '%1', CurrencyBuf.Code);
                            end;
                        }
                        dataitem(Total; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                            column(TotalAmount; TotalAmount)
                            {
                            }
                            column(Total_Number; Number)
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                if not PrintAmountsInCurrency or LCYEntriesOnly then
                                    CurrReport.BREAK;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                OK := CurrencyBuf.FINDFIRST
                            else
                                OK := CurrencyBuf.NEXT <> 0;
                            if not OK then
                                CurrReport.BREAK;

                            LCYEntriesOnly := (CurrencyBuf.Code = '') and (CurrencyBuf.COUNT = 1);
                            if PrintAmountsInCurrency then begin
                                TotalAmount := CVMgt.CalcCVDebt(Customer."No.", VendorNo, CurrencyBuf.Code, ReconcileDate, false);
                                if PrintAmountsInCurrency then
                                    CVLedgEntry.SETFILTER("Currency Code", '%1', CurrencyBuf.Code);
                                if (TotalAmount = 0) and CVLedgEntry.ISEMPTY then
                                    CurrReport.SKIP;
                            end else
                                TotalAmount := TotalAmountLCY;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (TotalAmountLCY = 0) and CVLedgEntry.ISEMPTY or (not PrintDetails) then
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(TotalLCY; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(TotalAmountLCY; TotalAmountLCY)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CVLedgEntry.RESET;
                            if (TotalAmountLCY = 0) and CVLedgEntry.ISEMPTY or (not PrintDetails) then
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        CopyText := Text016;
                        ChangeCustCompanyAddr(CompanyAddr, CustAddr)
                    end else begin
                        CopyText := Text017;
                        ChangeCustCompanyAddr(CustAddr, CompanyAddr);
                        OutputNo += 1;
                        CompAddr1[1] := CustAddr1[1];
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(CopyLoop.Number, 1, 2);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                CompanyAddr[9] := CompanyInfo."Phone No.";
                CompanyAddr[10] := CompanyInfo."Fax No.";
                CompanyAddr[11] := CompanyInfo."E-Mail";
                CompanyAddr[12] := CompanyInfo."VAT Registration No.";

                FormatAddr.Customer(CustAddr, Customer);
                CustAddr[9] := Customer."Phone No.";
                CustAddr[10] := Customer."Fax No.";
                CustAddr[11] := Customer."E-Mail";
                CustAddr[12] := Customer."VAT Registration No.";

                FormatAddr.Customer(CustAddr1, Customer);
                FormatAddr.Company(CompAddr1, CompanyInfo);

                /*
                if IncludeVendDebts then
                    VendorNo := GetLinkedVendor
                else
                    VendorNo := '';
*/
                TotalAmountLCY := CVMgt.CalcCVDebt(Customer."No.", VendorNo, '', ReconcileDate, true);

                if PrintOnlyNotZero and (TotalAmountLCY = 0) then
                    CurrReport.SKIP;
                DebitCreditCalc(Customer."No.", VendorNo, '', ReconcileDate, true);

                CVMgt.FillCVBuffer(CurrencyBuf, CVLedgEntry, Customer."No.", VendorNo, ReconcileDate, PrintAmountsInCurrency);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ReconcileDate; ReconcileDate)
                    {
                        Caption = 'Reconcile Date';
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            if ReconcileDate = 0D then
                                ERROR(Text002);
                            ReturnDate := CALCDATE('<7D>', ReconcileDate);
                        end;
                    }
                    field(ReturnDate; ReturnDate)
                    {
                        Caption = 'Return Date';
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            if ReturnDate = 0D then
                                ERROR(Text001);
                            if ReturnDate <= ReconcileDate then
                                ERROR(Text018);
                        end;
                    }
                    field(IncludeVendDebts; IncludeVendDebts)
                    {
                        Caption = 'Include Vendor Debts';
                        ApplicationArea = Basic, Suite;
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        Caption = 'Print Details';
                        ApplicationArea = Basic, Suite;
                    }
                    field(PrintOnlyNotZero; PrintOnlyNotZero)
                    {
                        Caption = 'Print Only Not Zero';
                        ApplicationArea = Basic, Suite;
                    }
                    field(PrintAmountsInCurrency; PrintAmountsInCurrency)
                    {
                        Caption = 'Print Amounts In Currency';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
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
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                end;
        end;

        AddrInfo := STRSUBSTNO('%1 %2', CompanyInfoPhoneNo_CaptionLbl, CompanyInfo."Phone No.") + ', '
          + STRSUBSTNO('%1 %2', CompanyInfoFaxNo_CaptionLbl, CompanyInfo."Fax No.") + ', '
          + STRSUBSTNO('Internet: %1', CompanyInfo."Home Page") + ', ' + STRSUBSTNO('E-mail: %1', CompanyInfo."E-Mail");
        CourtInfo := STRSUBSTNO('%1: %2', 'KRS', CompanyInfo.ITIGetCourtRegistrationNoFromGovRepSetup());


    end;

    trigger OnPreReport()
    begin
        if ReturnDate = 0D then
            ERROR(Text001);
        if ReconcileDate = 0D then
            ERROR(Text002);

        LongReconcileDate := FORMAT(ReconcileDate, 0, '<day,2>-<month,2>-<year4>');

        EVALUATE(ReportID, COPYSTR(CurrReport.OBJECTID(false), 8));
        AdditionalTranslatedText.RESET;
        AdditionalTranslatedText.SETRANGE("Report ID", ReportID);
        AdditionalTranslatedText.SETRANGE("Language Code", Languages.Code);
        AdditionalTranslatedText.SETFILTER("From Date", '<%1', ReconcileDate);
        if AdditionalTranslatedText.FINDLAST then
            LawText := AdditionalTranslatedText.Text;

        if not Contact.Get(CompanyInfo."TOR Reconc. Cont. No.") then
            Contact.init;
    end;

    var
        PaymentMethod: Record "Payment Method";
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        CurrencyBuf: Record Currency temporary;
        CVLedgEntry: Record "CV Ledger Entry Buffer" temporary;
        Contact: Record Contact;
        FormatAddr: Codeunit "Format Address";
        CVMgt: Codeunit "ITI CustVendManagement";
        AddrInfo: Text[250];
        CourtInfo: Text[250];
        CustAddr: array[12] of Text[100];
        CustAddr1: array[12] of Text[100];
        CompanyAddr: array[12] of Text[100];
        CompAddr1: array[12] of Text[100];
        CopyText: Text[30];
        LongReconcileDate: Text[30];
        VendorNo: Code[20];
        OutputNo: Integer;
        COMPANYNAME_CaptionLbl: Label 'Company Name';
        USERID_CaptionLbl: Label 'User ID';
        CopyText_CaptionLbl: Label 'Copy';
        Page_CaptionLbl: Label 'Page No.';
        Document_CaptionLbl: Label 'Balance Reconciliation';
        CompanyTitle: Label 'Company';
        CompanyInfoPhoneNo_CaptionLbl: Label 'Phone No.';
        CompanyInfoFaxNo_CaptionLbl: Label 'Fax No.';
        Email_CaptionLbl: Label 'E-mail';
        HomePage_CaptionLbl: Label 'Homepage';
        CompanyInfoVATRegNo_CaptionLbl: Label 'VAT Registration No.';
        CompanyInfoBankName_CaptionLbl: Label 'Bank Name';
        CompanyInfoBankAccNo_CaptionLbl: Label 'Account No.';
        CompanyInfoSWIFTCode_CaptionLbl: Label 'SWIFT Code';
        CompanyInfoRegNo_CaptionLbl: Label 'Registration No.';
        ContractorNo_CaptionLbl: Label 'Customer No.';
        VATRegNo_CaptionLbl: Label 'VAT Registration No.';
        DocumentNo_CaptionLbl: Label 'Document No.';
        OrderNo_CaptionLbl: Label 'Order No.';
        PostingDate_Header_CaptionLbl: Label 'Posting Date';
        DocDate_Header_CaptionLbl: Label 'Document Date';
        DueDate_Header_CaptionLbl: Label 'Due Date';
        VATDate_Header_CaptionLbl: Label 'VAT Date';
        PaymentTerm_Header_CaptionLbl: Label 'Payment Term';
        PaymentMethod_Header_CaptionLbl: Label 'Payment Method';
        QuoteNo_Header_CaptionLbl: Label 'Quote No.';
        ContractingPartyTitleLbl: Label 'Customer';
        TempDate_Header_CaptionLbl: Label 'Sales Date';
        ShipmentMethod_Header_CaptionLbl: Label 'Shipment Method';
        EquityCapital_CaptionLbl: Label 'Equity Capital';
        PaymentTermsDescCaptionLbl: Label 'Payment Terms';
        ReturnDate: Date;
        ReconcileDate: Date;
        PrintOnlyNotZero: Boolean;
        PrintAmountsInCurrency: Boolean;
        OK: Boolean;
        LCYEntriesOnly: Boolean;
        IncludeVendDebts: Boolean;
        PrintDetails: Boolean;
        MutualBalance_CaptionLbl: Label 'For mutual balance reconcile between';
        StatementNo_CaptionLbl: Label 'Statement No.';
        InAccordance_CaptionLbl: Label 'In accordance with data of';
        Debit_CaptionLbl: Label 'Debit';
        Credit_CaptionLbl: Label 'Credit';
        Accountant_CaptionLbl: Label 'Accountant';
        Name_CaptionLbl: Label '(Name)';
        Signature_CaptionLbl: Label '(Signature)';
        and_CaptionLbl: Label 'and';
        Amount_CaptionLbl: Label 'Amount';
        CurrencyCode_CaptionLbl: Label 'Currency Code';
        DocumentType_CaptionLbl: Label 'Document Type';
        RemainingAmount_CaptionLbl: Label 'Remaining Amount';
        RemainingAmtLCY_CaptionLbl: Label 'Remaining Amt. (LCY)';
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountLCY: Decimal;
        Text001: Label 'You must specify Return Date';
        Text002: Label 'You must specify Reconcile Date';
        Text003: Label 'we ask You for confirmation in %1 days in B section, cohesion of following balances, appeared in our books on the day %2';
        Text004: Label 'Please confirm balance at %1 and return to us until %2';
        Text005: Label 'To our address %1, %2, %3';
        Text006: Label 'Or to E-mail %1';
        Text007: Label 'If we don''t receive your answer until %1, we suppose you accept balance mentioned in this document.';
        Text008: Label ' If You find any differences in the balance, we kindly ask you to add comments and explanations.';
        Text009: Label ' If you have any question, please call to our accountant by phone %1.';
        Text011: Label 'Final balance amount, %1';
        Text012: Label 'Total %1';
        Text013: Label 'Open documents in details %1';
        Text014: Label 'LCY';
        Text015: Label 'On a base of art. 26 about accountancy (Act Register No. 152 from 2009 year item 1223 with subsequent changes)';
        Text016: Label 'A Section';
        Text017: Label 'B Section';
        Text018: Label 'Return Date must be more than Reconcile Date.';
        Languages: Record Language;
        LawText: Text;
        AdditionalTranslatedText: Record "ITI Additional Translated Text";
        ReportID: Integer;

    procedure GetCurrCode("Code": Code[10]): Code[10]
    begin
        if Code = '' then
            exit(GLSetup."LCY Code");
        exit(Code);
    end;

    procedure ChangeCustCompanyAddr(CompanyData: array[8] of Text[1024]; CustomerData: array[8] of Text[1024])
    begin
        CompanyAddr[1] := CompanyData[1];
        CompanyAddr[2] := CompanyData[2];
        CompanyAddr[3] := CompanyData[3];
        CompanyAddr[4] := CompanyData[4];
        CompanyAddr[5] := CompanyData[5];
        CompanyAddr[6] := CompanyData[6];
        CompanyAddr[7] := CompanyData[7];
        CompanyAddr[8] := CompanyData[8];

        CustAddr[1] := CustomerData[1];
        CustAddr[2] := CustomerData[2];
        CustAddr[3] := CustomerData[3];
        CustAddr[4] := CustomerData[4];
        CustAddr[5] := CustomerData[5];
        CustAddr[6] := CustomerData[6];
        CustAddr[7] := CustomerData[7];
        CustAddr[8] := CustomerData[8];
    end;

    procedure DebitCreditCalc(CustNo: Code[20]; VendNo: Code[20]; CurrencyCode: Code[10]; Date: Date; InLCY: Boolean)
    var
        DebitCredit: Option Debit,Credit;
    begin
        DebitAmount := CVMgt.CalcCVCreditDebit(CustNo, VendNo, CurrencyCode, Date, InLCY, DebitCredit::Debit);
        CreditAmount := CVMgt.CalcCVCreditDebit(CustNo, VendNo, CurrencyCode, Date, InLCY, DebitCredit::Credit);
    end;
}