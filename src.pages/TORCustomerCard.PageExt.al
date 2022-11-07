/// +---------------------------------------------------------+
/// | Torggler                                                |
/// +---------------------------------------------------------+
/// Module					Date			ID		Description
/// TG-TDAG00000-001		03.12.20		dho     Added field "E-Mail Invoices"
/// TG-TDAG00000-002        05.01.21        dho     Bugfix: fill field County Name insteat of County
/// TG-TDAG00000-003        18.02.21        dho     Added field "Hide Comp. Name on Whse Shpt."; Rec."Hide Comp. Name on Whse Shpt."
pageextension 50468 "TOR Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'No. 2, old Customer No.';
            }
            field(Mixer; Rec.Mixer)
            {
                ApplicationArea = all;
            }
            field("e-invoice"; Rec."e-invoice")
            {
                ApplicationArea = all;
            }
        }

        addafter("Prices Including VAT")
        {
            field("Factoring Std. Text Code"; Rec."Factoring Std. Text Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }

        addafter("Post Code")
        {
            field("County Code"; Rec."County Code 2")
            {
                ApplicationArea = All;
                ToolTip = 'County Code';
                TableRelation = "TOR County".Code;

                trigger OnValidate()
                var
                    County: Record "TOR County";
                begin
                    if Rec."County Code 2" <> '' then
                        if County.Get(Rec."County Code 2") then
                            Rec.Validate("County Name", County.Name);
                end;
            }

            field("County Name"; Rec."County Name")
            {
                ApplicationArea = All;
                ToolTip = 'County Name';
                TableRelation = "TOR County".Name;

                trigger OnValidate()
                var
                    County: Record "TOR County";
                begin
                    //Begin TG-TDAG00000-002/dho
                    //if Rec.County <> '' then begin
                    //    County.SetRange(Name, Rec.County);
                    if Rec."County Name" <> '' then begin
                        County.SetRange(Name, Rec."County Name");
                        //End TG-TDAG00000-002/dho
                        if County.FindFirst() then
                            Rec.Validate("County Code 2", County.Code);
                    end;
                end;
            }
        }
        //Begin TD-TDAG00000-001/dho
        addafter("E-Mail")
        {
            field("E-mail Invoices"; Rec."E-mail Invoices")
            {
                ApplicationArea = All;
                ToolTip = 'Customer E-mail for Invoices';
            }
        }
        //End TD-TDAG00000-001/dho
        //Begin TD-TDAG00000-003/dho
        addafter("Shipping Advice")
        {
            field("Hide Comp. Name on Whse Shpt."; Rec."Hide Comp. Name on Whse Shpt.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Hide Company Name on Whse Shpt.';
                ToolTip = 'Hide Company Name on Whse Shpt.';
            }
            field("Cust. Delivery Document"; Rec."Cust. Delivery Document")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Pallet Cost Text"; Rec."Pallet Cost Text")
            {
                ApplicationArea = Basic, Suite;
            }

        }
        //End TD-TDAG00000-003/dho


    }

    actions
    {
        // Add changes to page actions here
    }

}