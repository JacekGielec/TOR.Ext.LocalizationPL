// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			10.02.21		dho         creation

/// <summary>
/// PageExtension TOR O365 Activities (ID 50467) extends Record O365 Activities.
/// </summary>
pageextension 50467 "TOR O365 Activities" extends "O365 Activities"
{
    layout
    {
        addafter("Sales This Month")
        {
            field("Sales Last Month"; getSalesLastMonth())
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Sales Invoice List";
                ToolTip = 'Specifies the sum of sales in the last month excluding taxes.';
                Caption = 'Sales Last Month';
                AutoFormatExpression = Rec.GetAmountFormat();
                AutoFormatType = 11;
                DecimalPlaces = 0 : 0;

                trigger OnDrillDown()
                var
                    [SecurityFiltering(SecurityFilter::Filtered)]
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetFilter("Document Type", '%1|%2',
                        CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
                    CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CM-1M>', WorkDate()), CalcDate('<-CM-1D>', WorkDate()));
                    PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgerEntry);
                end;

            }
        }
    }

    local procedure getSalesLastMonth(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CM-1M>', WorkDate()), CalcDate('<-CM-1D>', WorkDate()));
        CustLedgerEntry.CalcSums("Sales (LCY)");
        exit(CustLedgerEntry."Sales (LCY)");
    end;
}