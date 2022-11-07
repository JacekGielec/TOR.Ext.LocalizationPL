tableextension 50481 "TOR Dtld SAF-T VAT Entry" extends 52063277
{
    DrillDownPageID = "ITI Detailed SAF-T VAT Entries";
    LookupPageID = "ITI Detailed SAF-T VAT Entries";

    fields
    {
        // Add changes to table fields here
    }

    keys
    {
        key(Key10; "SAF-T VAT Entry No.", "Element Name")
        {
        }
    }
    var
        myInt: Integer;
}