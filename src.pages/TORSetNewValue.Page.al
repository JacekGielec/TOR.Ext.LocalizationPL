page 50496 "TOR Set New Value"
{
    Caption = 'Set New Value';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(OldValue; OldValue)
                {
                    Caption = 'Old Value';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(NewValue; NewValue)
                {
                    Caption = 'New Value';
                    ApplicationArea = Basic, Suite;
                    Visible = not IsChangeVendor;
                }
                field(NewVendor; NewVendor)
                {
                    Caption = 'New Vendor';
                    ApplicationArea = Basic, Suite;
                    Visible = IsChangeVendor;
                    TableRelation = Vendor;

                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode(true);
    end;

    trigger OnOpenPage()
    begin

    end;

    var
        NewValue: Text;
        Oldvalue: Text;
        IsChangeVendor: Boolean;
        NewVendor: Code[20];

    procedure SetValues(_OldValue: text; _NewValue: Text)
    begin
        NewValue := _NewValue;
        Oldvalue := _OldValue;
    end;

    procedure SetVendorValues(_OldValue: text; _NewValue: Text; _IsChangeVendor: Boolean)
    begin
        NewVendor := _NewValue;
        Oldvalue := _OldValue;
        IsChangeVendor := _ischangevendor;
    end;

    procedure GetValues(var NewDocumentValue: Text)
    begin
        NewDocumentValue := NewValue;
    end;

    procedure GetValuesVendor(var NewVendorValue: Text)
    begin
        NewVendorValue := NewVendor;
    end;
}

