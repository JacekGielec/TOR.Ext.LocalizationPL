// +---------------------------------------------------------+
// | Torggler                                                |
// +---------------------------------------------------------+
// Module					Date			ID		Description
// TG-TDAG00000-001			05.02.21		dho         creation

/// <summary>
/// Enum East / West (ID 50450).
/// </summary>
enum 50450 "East / West"
{
    Extensible = true;
    Caption = 'East / West';

    value(0; None) { }
    value(1; East)
    {
        Caption = 'East';
    }
    value(2; West)
    {
        Caption = 'West';
    }
}