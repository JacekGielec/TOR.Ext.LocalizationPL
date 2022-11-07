/// <summary>
/// PageExtension TOR General Journal (ID 50471) extends Record General Journal.
/// </summary>
pageextension 50485 "TOR Item List DI" extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("Item Tracking Code Exists"; ItemTrackingCodeExists())
            {
                ApplicationArea = all;
                Caption = 'Item Tracking Code Exists';
            }
        }
        addafter("Product Group")
        {
            field("Commission Group Code"; Rec."EOS Commission Group Code")
            {
                ApplicationArea = All;
            }
            field("ITI PKWiU"; Rec."ITI PKWiU")
            {
                ApplicationArea = all;
            }
        }
    }

    local procedure ItemTrackingCodeExists(): Boolean
    begin
        exit(Rec."Item Tracking Code" <> '')
    end;

}

