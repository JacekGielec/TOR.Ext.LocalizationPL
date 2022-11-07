/// <summary>
/// Codeunit TOR Event Sales Header Sub DI (ID 50452).
/// </summary>
codeunit 50452 "TOR Event Sales Header Sub DI"
{
    var
        UpdateExchRateMsg: Label 'Do you want to update the exchange rate?';
        ConfirmChangeSalCrMemoCorrReasonMsg: Label 'When you change %1 field, all sales credit memo Lines will be deleted.\Are you sure you want to change %1?';
        ActionStoppedErr: Label 'Action stopped.';
    //EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr', '', true, true)]


    /// <summary>
    /// OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr.
    /// </summary>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="ShipToAddress">Record "Ship-to Address".</param>
    local procedure OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address")
    begin
        if ShipToAddress."DI Salesperson Code" <> '' then begin
            SalesHeader.Validate("Salesperson Code", ShipToAddress."DI Salesperson Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Document Date', false, false)]
    local procedure OnAfterValidateDocumentDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        if SalesSetup."ITI Get Doc. Exch.R. for Date" = SalesSetup."ITI Get Doc. Exch.R. for Date"::"Document Date" then
            UpdateSalesHeaderCurrencyFactor(Rec, true);
    end;

    local procedure UpdateSalesHeaderCurrencyFactor(var SalesHeader: Record "Sales Header"; HideValidationDialog: Boolean)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
        CurrencyFactor: Decimal;
        Confirmed: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesHeader."Currency Code" <> '' then begin
            SalesSetup.Get();
            case SalesSetup."ITI Get Doc. Exch.R. for Date" of
                SalesSetup."ITI Get Doc. Exch.R. for Date"::"Posting Date":
                    CurrencyDate := SalesHeader."Posting Date";
                SalesSetup."ITI Get Doc. Exch.R. for Date"::"Document Date":
                    CurrencyDate := SalesHeader."Document Date";
                SalesSetup."ITI Get Doc. Exch.R. for Date"::"Sales Date":
                    CurrencyDate := SalesHeader."ITI Sales Date";
            end;
            if CurrencyDate = 0D then
                CurrencyDate := WorkDate();

            if SalesSetup."Exchange Rate One Day Before" then
                CurrencyDate -= 1;

            CurrencyFactor := CurrencyExchangeRate.ExchangeRate(CurrencyDate, SalesHeader."Currency Code");
            if SalesHeader."Currency Factor" <> CurrencyFactor then begin
                if HideValidationDialog then
                    Confirmed := true
                else
                    Confirmed := Confirm(UpdateExchRateMsg, false);
                if Confirmed then
                    SalesHeader.Validate("Currency Factor", CurrencyFactor)
            end;
        end;
    end;

    //OnAfterCheckBillToCust(Rec, xRec, Cust);
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCheckBillToCust', '', false, false)]
    local procedure OnAfterCheckBillToCust(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Customer: Record Customer)
    var
        GLSetup: Record "General Ledger Setup";

        ErrCurrencyCode: Label 'Local currency is not allowed!', Comment = '%1 = No.';
    begin
        GLSetup.Get();
        if Customer."Currency Code" = GLSetup."LCY Code" then
            Error(ErrCurrencyCode);

        Customer.TestField("Customer Posting Group");
        Customer.TestField("Gen. Bus. Posting Group");
        Customer.TestField("VAT Bus. Posting Group");
    end;

    //OnAfterSetFieldsBilltoCustomer(Rec, BillToCustomer, xRec);
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure OnAfterSetFieldsBilltoCustomer(var SalesHeader: Record "Sales Header"; Customer: Record Customer; xSalesHeader: Record "Sales Header")
    var
        CustPostGroup: Record "Customer Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesHeader."Customer Posting Group" = '' then
            exit;

        CustPostGroup.SetRange(Code, SalesHeader."Customer Posting Group");
        if not CustPostGroup.FindSet() then
            exit;

        SalesHeader."TOR Retail Sales" := CustPostGroup."TOR Retail Sales";

        //set the default numbering series first
        if xSalesHeader."Bill-to Customer No." <> '' then begin
            SalesSetup.get();
            NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Invoice Nos.");
        end;

        if CustPostGroup."TOR Posted Invoice Nos." <> '' then
            SalesHeader."Posting No. Series" := CustPostGroup."TOR Posted Invoice Nos.";

        SalesHeader."e-invoice" := Customer."e-invoice";
    end;



    //OnRunOnBeforeCheckAndUpdate(SalesHeader);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCheckAndUpdate', '', false, false)]
    local procedure OnRunOnBeforeCheckAndUpdate(SalesHeader: Record "Sales Header")
    var
        GLSetup: Record "General Ledger Setup";

        ErrCurrencyCode: Label 'Posting with local currency is not allowed!', Comment = '%1 = Document No.';
    begin
        GLSetup.Get();
        if SalesHeader."Currency Code" = GLSetup."LCY Code" then
            Error(ErrCurrencyCode);

        SalesHeader.TestField("Customer Posting Group");
        SalesHeader.TestField("Gen. Bus. Posting Group");
        SalesHeader.TestField("VAT Bus. Posting Group");
    end;


}