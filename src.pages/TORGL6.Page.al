page 50505 "TOR GL 6"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(FetData)
            {
                Caption = 'Get Data';
                ApplicationArea = All;
                trigger OnAction()
                var
                    GLAccount: Record "G/L Account";
                    GLEntry: Record "G/L Entry";

                    FPB: FilterPageBuilder;
                    LineNo: Integer;
                    DocTemp: Record "Sales Header" temporary;
                begin
                    FPB.AddRecord('G/L Entry', GLEntry);

                    FPB.Addfield('G/L Entry', GLEntry."Posting Date");
                    FPB.AddField('G/L Entry', GLEntry."Document No.");
                    // FPB.Addfield('Data Filter', GLAccount."Date Filter");

                    FPB.PageCaption := 'G/L Entry Filter Page';
                    FPB.RunModal;


                    Rec.Reset();
                    Rec.DeleteAll();
                    GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                    GLEntry.SetView(FPB.Getview('G/L Entry'));
                    GLEntry.setfilter("Posting Date", GLEntry.GetFilter("Posting Date"));
                    //GLEntry.SetRange("Document No.", GLEntry."Document No.");
                    GLEntry.Setfilter("G/L Account No.", '6*');
                    if GLEntry.FindSet() then
                        repeat
                            DocTemp.SetRange("No.", GLEntry."Document No.");
                            if not DocTemp.FindSet() then begin
                                DocTemp."No." := GLEntry."Document No.";
                                DocTemp.Insert();
                            end;
                        until GLEntry.Next() = 0;

                    DocTemp.Reset();
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("Document No.");
                    if DocTemp.FindSet() then
                        repeat
                            GLEntry.SetRange("Document No.", DocTemp."No.");
                            if glentry.FindSet() then
                                repeat
                                    if not rec.Get(GLEntry."Entry No.") then begin
                                        Rec.TransferFields(GLEntry);
                                        Rec.Insert();
                                    end;
                                until GLEntry.Next() = 0;
                        until DocTemp.Next() = 0;
                    Rec.Reset();
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                ShortCutKey = 'Shift+Ctrl+I';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }


        }
    }

    var
        check: Record "TOR Check 4";

}