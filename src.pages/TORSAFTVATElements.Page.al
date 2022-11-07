page 50454 TORSAFTVATElements
{
    Caption = 'TOR SAF-T VAT Elements';
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "ITI SAF-T VAT Element";
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Version Code"; Rec."Version Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Element Name"; Rec."Element Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Consecutive No."; Rec."Consecutive No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value Source"; Rec."Value Source")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value Formula"; Rec."Value Formula")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Data Type"; Rec."Data Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Def. VAT Amount Element Name"; Rec."Def. VAT Amount Element Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Multiple Element"; Rec."Multiple Element")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Not Subject To Report"; Rec."Not Subject To Report")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Sales and Purchase Type"; Rec."VAT Sales and Purchase Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetVersionFilter();
    end;

    local procedure SetVersionFilter();
    var
        SAFTAreaVersion: Record "ITI SAF-T Area Version";
    begin
        SAFTAreaVersion.SETRANGE(Area, SAFTAreaVersion.Area::"SAFT_VAT with VAT Declaration");
        SAFTAreaVersion.SETRANGE("Starting Date", 0D, WORKDATE);
        if SAFTAreaVersion.FINDLAST then
            Rec.SETFILTER("Version Code", SAFTAreaVersion.Code);
    end;
}