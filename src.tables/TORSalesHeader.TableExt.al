
/// <summary>
/// TableExtension TOR Sales Header.TableExt (ID 50466) extends Record Sales Header.
/// </summary>
tableextension 50466 "TOR Sales Header.TableExt" extends "Sales Header"
{
    fields
    {
        field(50000; "TOR Retail Sales"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "TOR Prepayment Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
                SalesSetup: Record "Sales & Receivables Setup";
                CustPostGroup: Record "Customer Posting Group";
            begin
                SalesSetup.Get();
                if "TOR Prepayment Invoice" then begin
                    SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
                    "Posting No. Series" := SalesSetup."Posted Prepmt. Inv. Nos."
                end else begin
                    CustPostGroup.get("Customer Posting Group");
                    if CustPostGroup."TOR Posted Invoice Nos." <> '' then
                        "Posting No. Series" := CustPostGroup."TOR Posted Invoice Nos."
                    else
                        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Invoice Nos.");
                end;
            end;
        }
        field(50010; "e-invoice"; Boolean)
        {
            Caption = 'e-invoice';
        }
        field(50011; "Transport Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transport Cost';
        }
        field(50102; "Corrected Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Corrected Document No.';
            TableRelation = "Sales Invoice Header";

            trigger OnLookup()
            var
                SalesInvHeader: Record "Sales Invoice Header";
                PostedSalesInvoices: Page "Posted Sales Invoices";
                IsHandled: Boolean;
            begin
                IsHandled := false;
                //OnBeforeLookupAppliesToDocNo(Rec, CustLedgEntry, IsHandled);
                if IsHandled then
                    exit;

                TestField("Sell-to Customer No.");
                SalesInvHeader.SetCurrentKey("Sell-to Customer No.");
                SalesInvHeader.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                PostedSalesInvoices.SetTableView(SalesInvHeader);
                PostedSalesInvoices.LookupMode(true);
                if PostedSalesInvoices.RunModal = ACTION::LookupOK then begin
                    PostedSalesInvoices.GetRecord(SalesInvHeader);
                    "Corrected Document No." := SalesInvHeader."No.";
                end;
                Clear(PostedSalesInvoices);
            end;

        }


        modify("Applies-to Doc. No.")
        {

            trigger OnAfterValidate()
            begin
                if Rec."document type" = rec."Document Type"::"Credit Memo" then
                    if rec."Applies-to Doc. No." <> '' then
                        "Corrected Document No." := Rec."Applies-to Doc. No.";
            end;
        }

    }
}

