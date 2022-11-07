/// +---------------------------------------------------------+
/// | Torggler                                                |
/// +---------------------------------------------------------+
/// Module					Date			ID		Description
/// TG-TDAG00000-001		11.05.21		jgi     Added field "SalesPurch. Code Mandatory"
/// TG-TDAG00000-002        23.05.21        jgi     New field Add. post. Code mandatory
pageextension 50488 "TOR G/L Account Card.PageExt" extends "G/L Account Card"
{
    layout
    {
        addlast(Posting)
        {
            field("SalesPurch. Code Mandatory"; Rec."SalesPurch. Code Mandatory")
            {
                ApplicationArea = all;
            }
            field("Add. Post. Code Mandatory"; Rec."Add. Post. Code Mandatory")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}