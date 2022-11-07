/// <summary>
/// PageExtension TORRecurringGenJournal (ID 50497) extends Record Recurring General Journal.
/// </summary>
pageextension 50497 TORRecurringGenJournal extends "Recurring General Journal"
{
    layout
    {
        addafter("Expiration Date")
        {
            field("Bal. Account Type"; Rec."Bal. Account Type")
            {
                ApplicationArea = basic, suite;
            }
            field("Bal. Account No."; Rec."Bal. Account No.")
            {
                ApplicationArea = basic, suite;
            }
            field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
            {
                ApplicationArea = basic, suite;
            }
            field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
            {
                ApplicationArea = basic, suite;
            }

            field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
            {
                ApplicationArea = basic, suite;
            }
        }
    }
}