// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// PageExtension TOR Salesperson Card (ID 50463) extends Record Salesperson/Purchaser Card.
/// </summary>
pageextension 50463 "TOR Salesperson Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter(Name)
        {
            field("East / West"; Rec."East / West")
            {
                ApplicationArea = All;
                ToolTip = 'East / West';
            }
        }
    }
}