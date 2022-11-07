/// <summary>
/// Page TOR Doc. Exchange Rate Factbox (ID 50450).
/// </summary>
page 50450 "TOR Doc. Exchange Rate Factbox"
{
    PageType = CardPart;
    ApplicationArea = Basic, Suite;
    UsageCategory = History;
    SourceTable = "Currency Exchange Rate";
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            field(Lbl; StrSubstNo(ExchangeRateLbl, Rec."Currency Code"))
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                Style = Strong;
                ToolTip = 'Exchange Rate Description';
            }
            field("Exchange Rate"; Rec."Relational Exch. Rate Amount") //Rec.ExchangeRate(Rec."Starting Date", Rec."Currency Code"))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Exchange Rate';
                ToolTip = 'Specifies the exchange rate used in the current document.';
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the currency of the current document.';
                Visible = false;
            }
            field("Relational Currency Code"; Rec."Relational Currency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the currency to which relates to.';
                Visible = false;
            }
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the starting date of the exchange rate rule.';

                trigger OnDrillDown()
                begin
                    Page.Run(PAGE::"Currency Exchange Rates", Rec);
                end;
            }
            field(CreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the date on wich the exchange rate was inserted in the system.';
            }
            field("Exchange Rate Amount"; Rec."Exchange Rate Amount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Exchange Rate Amount.';
                Visible = false;
            }

        }
    }

    trigger OnOpenPage()
    begin
        PageIsVisible := true;
    end;

    /// <summary>
    /// UpdateRecords.
    /// </summary>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    procedure UpdateRecords(var SalesHeader: Record "Sales Header")
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        //if not isVisible() then
        //    exit;
        Rec.Reset();
        Rec.DeleteAll();
        if SalesHeader."Currency Code" = ' ' then
            exit;
        CurrencyExchangeRate.SetRange("Currency Code", SalesHeader."Currency Code");
        CurrencyExchangeRate.setFilter("Starting Date", '<=%1', SalesHeader."Posting Date");
        if CurrencyExchangeRate.FindLast() then begin
            Rec.Init();
            Rec := CurrencyExchangeRate;
            Rec.Insert(true);
        end;
        CurrPage.Update();
    end;

    /// <summary>
    /// UpdateRecords.
    /// </summary>
    /// <param name="InvoiceHeader">VAR Record "Sales Invoice Header".</param>
    procedure UpdateRecords(var InvoiceHeader: Record "Sales Invoice Header")
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        //if not isVisible() then
        //    exit;
        Rec.Reset();
        Rec.DeleteAll();
        if InvoiceHeader."Currency Code" = ' ' then
            exit;
        CurrencyExchangeRate.SetRange("Currency Code", InvoiceHeader."Currency Code");
        CurrencyExchangeRate.setFilter("Starting Date", '<=%1', InvoiceHeader."Posting Date");
        if CurrencyExchangeRate.FindLast() then begin
            Rec.Init();
            Rec := CurrencyExchangeRate;
            Rec.Insert(true);
        end;
        CurrPage.Update();
    end;

    /// <summary>
    /// isVisible.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure isVisible(): Boolean
    begin
        exit(PageIsVisible)
    end;

    /// <summary>
    /// setVisible.
    /// </summary>
    /// <param name="Visible">Boolean.</param>
    procedure setVisible(Visible: Boolean)
    begin
        PageIsVisible := Visible;
    end;

    var
        PageIsVisible: Boolean;
        ExchangeRateLbl: Label 'Exchange Rate at Posting Date from %1 to PLN', Comment = '%1 = Currency', MaxLength = 999, Locked = false;

}