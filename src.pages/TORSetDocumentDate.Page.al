page 50495 "TOR Set Document Date"
{
    Caption = 'Set New Document Date';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocumentDate; DocumentDate)
                {
                    Caption = 'Document Date';
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
        CurrPage.LookupMode(true);
    end;

    trigger OnOpenPage()
    begin

    end;

    var
        DocumentDate: Date;

    procedure SetValues(NewDocumentDate: Date)
    begin
        DocumentDate := NewDocumentDate;
    end;

    procedure GetValues(var NewDocumentDate: Date)
    begin
        NewDocumentDate := DocumentDate;
    end;
}

