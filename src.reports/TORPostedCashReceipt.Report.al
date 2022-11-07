report 50456 "TOR Posted Cash Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src.reports/TORPostedCashReceipt.rdlc';
    PreviewMode = PrintLayout;
    DataAccessIntent = ReadOnly;
    Caption = 'TOR Posted Cash Receipt';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
                    {
                    }
                    column(Outputno; OutputNo)
                    {

                    }
                    column(ShowLines; ShowDetails)
                    {
                    }
                    column(G_L_Register__TABLECAPTION__________GLRegFilter; TableCaption + ': ' + GLRegFilter)
                    {
                    }
                    column(GLRegFilter; GLRegFilter)
                    {
                    }
                    column(G_L_Register__No__; "G/L Register"."No.")
                    {
                    }
                    column(G_L_RegisterCaption; G_L_RegisterCaptionLbl)
                    {
                    }
                    column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                    {
                    }
                    column(ReportTitleCaption; ReportTitleLbl)
                    {

                    }
                    column(WhoPayCaption; WhoPayLbl)
                    {

                    }
                    column(DebitCaption; DebitLbl)
                    {

                    }
                    column(CreditCaption; CreditLbl)
                    {

                    }
                    column(CashCaption; CashLbl)
                    {

                    }
                    column(AccountCaption; AccountLbl)
                    {

                    }
                    column(CreatedByCaption; CreatedByLbl)
                    {

                    }
                    column(PayByCaption; PayByLbl)
                    {

                    }
                    column(G_L_Entry__Posting_Date_Caption; G_L_Entry__Posting_Date_CaptionLbl)
                    {
                    }
                    column(G_L_Entry__Document_Date_Caption; G_L_Entry__Document_Date_CaptionLbl)
                    {

                    }
                    column(G_L_Entry__Document_Type_Caption; G_L_Entry__Document_Type_CaptionLbl)
                    {
                    }
                    column(G_L_Entry__Document_No__Caption; "G/L Entry".FieldCaption("Document No."))
                    {
                    }
                    column(G_L_Entry__G_L_Account_No__Caption; "G/L Entry".FieldCaption("G/L Account No."))
                    {
                    }
                    column(GLAcc_NameCaption; GLAcc_NameCaptionLbl)
                    {
                    }
                    column(G_L_Entry_DescriptionCaption; "G/L Entry".FieldCaption(Description))
                    {
                    }
                    column(G_L_Entry__VAT_Amount_Caption; "G/L Entry".FieldCaption("VAT Amount"))
                    {
                    }
                    column(G_L_Entry__Gen__Posting_Type_Caption; G_L_Entry__Gen__Posting_Type_CaptionLbl)
                    {
                    }
                    column(G_L_Entry__Gen__Bus__Posting_Group_Caption; G_L_Entry__Gen__Bus__Posting_Group_CaptionLbl)
                    {
                    }
                    column(G_L_Entry__Gen__Prod__Posting_Group_Caption; G_L_Entry__Gen__Prod__Posting_Group_CaptionLbl)
                    {
                    }
                    column(G_L_Entry_AmountCaption; "G/L Entry".FieldCaption(Amount))
                    {
                    }
                    column(G_L_Entry__Entry_No__Caption; "G/L Entry".FieldCaption("Entry No."))
                    {
                    }
                    column(G_L_Register__No__Caption; G_L_Register__No__CaptionLbl)
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }
                    column(DocumentDate; DocumentDate)
                    {

                    }
                    column(DocumentNo; DocumentNo)
                    {

                    }
                    column(Who; Who)
                    {

                    }
                    column(Description; Description)
                    {

                    }
                    column(GlAccNo; GlAccNo)
                    {

                    }
                    column(Amount; Amount)
                    {

                    }
                    dataitem("G/L Entry"; "G/L Entry")
                    {
                        DataItemTableView = SORTING("Entry No.");
                        column(G_L_Entry__Posting_Date_; Format("Posting Date"))
                        {
                        }
                        column(G_L_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(G_L_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(G_L_Entry__G_L_Account_No__; GetGLAccNo())
                        {
                        }
                        column(GLAcc_Name; GLAcc.Name)
                        {
                        }
                        column(G_L_Entry_Description; Description)
                        {
                        }
                        column(G_L_Entry__VAT_Amount_; DetailedVATAmount)
                        {
                            AutoCalcField = true;
                        }
                        column(G_L_Entry__Gen__Posting_Type_; "Gen. Posting Type")
                        {
                        }
                        column(G_L_Entry__Gen__Bus__Posting_Group_; "Gen. Bus. Posting Group")
                        {
                        }
                        column(G_L_Entry__Gen__Prod__Posting_Group_; "Gen. Prod. Posting Group")
                        {
                        }
                        column(G_L_Entry_Amount; Amount)
                        {
                        }
                        column(G_L_Entry__Entry_No__; "Entry No.")
                        {
                        }
                        column(G_L_Entry_Amount_Control41; Amount)
                        {
                        }
                        column(G_L_Entry_Amount_Control41Caption; G_L_Entry_Amount_Control41CaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            CurrancyFactor: Decimal;
                        begin
                            if not GLAcc.Get("G/L Account No.") then
                                GLAcc.Init();


                            if not ShowDetails then
                                exit;


                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                            SetFilter("Bal. Account No.", '<>%1', 'KASA*');
                        end;

                    }

                    trigger OnAfterGetRecord()
                    var
                        Cust: Record Customer;
                        Vend: Record Vendor;
                        Bank: Record "Bank Account";
                    begin
                        GLEntry.SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                        GLEntry.SetFilter("Bal. Account No.", '<>%1', 'KASA*');
                        GLEntry.FindSet();

                        case GLEntry."Bal. Account Type" of
                            GLEntry."Bal. Account Type"::"Bank Account":
                                begin
                                    bank.get(glentry."Bal. Account No.");
                                    Who := bank.Name;
                                end;
                            GLEntry."Bal. Account Type"::"Customer":
                                begin
                                    cust.get(glentry."Bal. Account No.");
                                    Who := cust.Name + ' (' + cust."No." + ')';
                                end;
                            GLEntry."Bal. Account Type"::"Vendor":
                                begin
                                    Vend.get(glentry."Bal. Account No.");
                                    Who := Vend.Name + ' (' + Vend."No." + ')';
                                end;
                        end;

                        DocumentNo := GLEntry."Document No.";
                        DocumentDate := GLEntry."Document Date";


                    end;

                }

                trigger OnAfterGetRecord();
                begin
                    if Number > 1 then begin
                        OutputNo += 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    copies := Copies + 1;
                    SetRange(Number, 1, Copies);
                end;
            }


        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control3)
                {
                    Caption = 'Options';
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show details';
                        ToolTip = 'Specifies if the report displays all lines in detail.';
                    }
                    field(Copies; Copies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of copies';
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

    trigger OnPreReport()
    begin
        GLRegFilter := "G/L Register".GetFilters();
        TempPurchInvLinePrinted.DeleteAll();
    end;

    trigger OnInitReport()
    var
    begin
        Copies := 1;

    end;

    var
        GLEntry: Record "G/L Entry";

        GLAcc: Record "G/L Account";
        TempPurchInvLinePrinted: Record "Purch. Inv. Line" temporary;
        GLRegFilter: Text;
        G_L_RegisterCaptionLbl: Label 'G/L Register';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        G_L_Entry__Posting_Date_CaptionLbl: Label 'Posting Date';
        G_L_Entry__Document_Date_CaptionLbl: Label 'Document Date';

        G_L_Entry__Document_Type_CaptionLbl: Label 'Document Type';
        GLAcc_NameCaptionLbl: Label 'Name';
        G_L_Entry__Gen__Posting_Type_CaptionLbl: Label 'Gen. Posting Type';
        G_L_Entry__Gen__Bus__Posting_Group_CaptionLbl: Label 'Gen. Bus. Posting Group';
        G_L_Entry__Gen__Prod__Posting_Group_CaptionLbl: Label 'Gen. Prod. Posting Group';
        G_L_Register__No__CaptionLbl: Label 'Register No.';
        TotalCaptionLbl: Label 'Total';
        G_L_Entry_Amount_Control41CaptionLbl: Label 'Total';
        ReportTitleLbl: Label 'Proof of Payment';
        WhoPayLbl: Label 'Who Pay:';
        DebitLbl: Label 'Debit';
        CreditLbl: Label 'Credit';
        CashLbl: Label 'Cash';
        AccountLbl: Label 'Account';
        CreatedByLbl: Label 'Created by';
        PayByLbl: Label 'Pay by';
        ShowDetails: Boolean;
        Copies: Integer;
        DetailedVATAmount: Decimal;
        DocumentDate: Date;
        DocumentNo: Code[50];
        Who: Text[100];
        Description: Text[100];
        GlAccNo: Code[20];
        Amount: Decimal;
        OutputNo: Integer;


    local procedure DetailsPrinted(PurchInvLine: Record "Purch. Inv. Line"): Boolean
    begin
        if TempPurchInvLinePrinted.get(PurchInvLine."Document No.", PurchInvLine."Line No.") then
            exit(true);
        TempPurchInvLinePrinted."Document No." := PurchInvLine."Document No.";
        TempPurchInvLinePrinted."Line No." := PurchInvLine."Line No.";
        TempPurchInvLinePrinted.Insert();
    end;

    local procedure SetCurrancyFactor(HeaderCurrancyFactor: Decimal): Decimal
    begin
        if HeaderCurrancyFactor = 0 then
            exit(1);
        exit(HeaderCurrancyFactor);
    end;

    local procedure GetGLAccNo(): Code[20]
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.Get("G/L Entry"."Entry No." + 1);
        EXIT(GLEntry."G/L Account No.");
    end;
}

