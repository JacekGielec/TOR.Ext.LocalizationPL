
/// <summary>
/// TableExtension TOR Customer.TableExt.al (ID 50461) extends Record Customer.
/// 
/// 20210522 Add new field Reminder Group Code
/// </summary>
tableextension 50465 "TOR CustPostingGroup.TableExt" extends "Customer Posting Group"
{
    fields
    {
        field(50000; "TOR Retail Sales"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "TOR Posted Invoice Nos."; Code[20])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        //20210522
        field(50002; "Reminder Terms Code"; Code[10])
        {
            Caption = 'Reminder Terms Code';
            TableRelation = "Reminder Terms";
        }
    }


}
