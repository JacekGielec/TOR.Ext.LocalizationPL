/// <summary>
/// PageExtension TOR Ship-to Address List (ID 50475) extends Record Ship-to Address List.
/// </summary>
pageextension 50475 "TOR Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        addafter("Location Code")
        {
            field("DI Salesperson Code"; Rec."DI Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'ToolTip: DI Salesperson Code';
            }
        }

        addafter("DI Salesperson Code")
        {
            field("DI Salesperson Name"; Rec."DI Salesperson Name")
            {
                ApplicationArea = All;
            }
        }

    }

}
