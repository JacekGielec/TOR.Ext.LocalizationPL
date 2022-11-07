/// <summary>
/// PageExtension TOR Gen. Ledg. Setup (ID 50484) extends Record General Ledger Setup.
/// </summary>
pageextension 50484 "TOR Gen. Ledg. Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("LCY Code")
        {
            field("Exchange Rate One Day Before"; Rec."Exchange Rate One Day Before")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Bal. Account No. Add. Post"; Rec."Bal. Account No. Add. Post")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Department G/L Account Cost"; Rec."Department G/L Account Cost")
            {
                ApplicationArea = Basic, Suite;
            }

        }
        addlast(Control1900309501)
        {
            field("Dim. Cost Reclassification"; Rec."Dim. Cost Reclassification")
            {
                ApplicationArea = Basic, Suite;
            }

        }
    }
}
