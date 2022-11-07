page 50451 "TOR Check 4"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TOR Check 4";

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

                field("Dim MPK"; Rec."Dim MPK")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No. 4"; Rec."G/L Account No. 4")
                {
                    ApplicationArea = all;
                }
                field("Dim 5"; Rec."Dim 5")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No. 490"; Rec."G/L Account No. 490")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No. 5"; Rec."G/L Account No. 5")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No. 580"; Rec."G/L Account No. 580")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No. 7"; Rec."G/L Account No. 7")
                {
                    ApplicationArea = all;
                }

                field("OK - 4&5"; Rec."OK - 4&5")
                {
                    ApplicationArea = all;
                }
                field(Circle; Rec.Circle)
                {
                    ApplicationArea = all;
                }
                field("Out Of The Circle"; Rec."Out Of The Circle")
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
                    FPB.AddRecord('G/L Account', GLAccount);
                    FPB.Addfield('G/L Account', GLAccount."No.");
                    // FPB.Addfield('Data Filter', GLAccount."Date Filter");

                    FPB.PageCaption := 'G/L Account Filter Page';
                    FPB.RunModal;


                    check.Reset();
                    check.DeleteAll();

                    GLAccount.SetView(FPB.Getview('G/L Account'));
                    GLEntry.setfilter("Posting Date", GLAccount.GetFilter("Date Filter"));
                    if GLAccount.FindSet() then
                        repeat
                            GLEntry.SetRange("G/L Account No.", GLAccount."No.");
                            if GLEntry.FindSet() then
                                repeat
                                    DocTemp.SetRange("No.", GLEntry."Document No.");
                                    if not DocTemp.FindSet() then begin
                                        DocTemp."No." := GLEntry."Document No.";
                                        DocTemp.Insert();
                                    end;
                                until GLEntry.Next() = 0;
                        until GLAccount.Next() = 0;

                    DocTemp.Reset();
                    if DocTemp.FindSet() then
                        repeat
                            Rec.InsertEntry(DocTemp."No.");
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