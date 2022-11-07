/// <summary>
/// TableExtension TOR Gen. Ledg. Setup (ID 50459) extends Record General Ledger Setup.
/// </summary>
tableextension 50459 "TOR Gen. Ledg. Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Exchange Rate One Day Before"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exchange Rate One Day Before';
        }
        field(50001; "Bal. Account No. Add. Post"; Code[20])
        {
            Caption = 'Bal. Account No. Add. Post';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
        }
        field(50002; "Dim. Cost Reclassification"; Code[20])
        {
            Caption = 'Dim. Cost Reclassification';
            TableRelation = Dimension.Code;
        }
        field(50003; "Department G/L Account Cost"; Code[20])
        {
            Caption = 'Department G/L Account Cost';
        }

    }
}
