// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// TableExtension TOR Salesperson (ID 50451) extends Record Salesperson/Purchaser.
/// </summary>
tableextension 50451 "TOR Salesperson" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50450; "East / West"; Enum "East / West")
        {
            DataClassification = ToBeClassified;
            Caption = 'East / West';
        }
    }

}