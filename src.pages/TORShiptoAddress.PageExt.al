/// <summary>
/// PageExtension TOR Ship-to Address (ID 50476) extends Record Ship-to Address.
/// </summary>
pageextension 50476 "TOR Ship-to Address" extends "Ship-to Address"
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
