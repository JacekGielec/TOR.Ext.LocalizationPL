
/// <summary>
/// TableExtension TOR Customer.TableExt.al (ID 50461) extends Record Customer.
/// 
/// </summary>
tableextension 50463 "TOR GL Account.TableExt" extends "G/L Account"
{
    fields
    {
        field(50000; "SalesPurch. Code Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Salespers./Purch. Code Mandatory';
        }
        field(50002; "Add. Post. Code Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Add. Post. Code Mandatory';
        }

        field(63115; "Customer Credit Amount"; Decimal)
        {
            Caption = 'Customer Credit Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("ITI G/L Account No." = FIELD("No."),
                                                                                                                      "iti positive" = CONST(false),
                                                                                                                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                                                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                                                      "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Editable = false;
        }
        field(63116; "Customer Debit Amount"; Decimal)
        {
            Caption = 'Customer Debit Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("iti G/L Account No." = FIELD("No."),
                                                                                                                      "iti Positive" = CONST(true),
                                                                                                                      "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                                                      "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                                                      "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Editable = false;
        }
        field(63117; "Vendor Credit Amount"; Decimal)
        {
            Caption = 'Vendor Credit Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("iti g/l Account No." = FIELD("No."),
                                                                                                                      "iti Positive" = CONST(false),
                                                                                                                       "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                                                       "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                                                       "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Editable = false;
        }
        field(63118; "Vendor Debit Amount"; Decimal)
        {
            Caption = 'Vendor Debit Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("iti g/l Account No." = FIELD("No."),
                                                                                                                       "iti Positive" = CONST(true),
                                                                                                                       "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                                                       "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                                                       "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Editable = false;
        }

    }
}
