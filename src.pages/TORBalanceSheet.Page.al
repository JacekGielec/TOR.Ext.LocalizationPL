page 50486 "TOR Balance Sheet"
{
    ApplicationArea = All;
    UsageCategory = Administration;

    Caption = 'Balance Sheet';
    SaveValues = true;
    SourceTable = "TOR Balance Sheet Line";
    DataCaptionExpression = CaptionText;
    PageType = list;
    AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Field("Batch Name"; CurrentBalanceName)
                {
                    ApplicationArea = all;
                    Caption = 'Batch Name';
                    trigger OnValidate()
                    BEGIN
                        BalanceSheetMgt.CheckName(CurrentBalanceName, Rec);
                        CurrentBalanceNameOnAfterValid;
                    END;

                    trigger OnLookup(var myText: Text): Boolean
                    BEGIN
                        CurrPage.SAVERECORD;
                        BalanceSheetMgt.LookupName(CurrentBalanceName, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;
                }

                Field(BalanceSide; BalanceSide)
                {
                    ApplicationArea = all;
                    Caption = 'Assets/Liabilities';
                    trigger OnValidate()
                    BEGIN
                        CurrPage.SAVERECORD;
                        BalanceSheetMgt.OpenBalance(CurrentBalanceName, Rec, BalanceSide);
                        CurrPage.UPDATE(FALSE);
                    END;
                }

                Field(DateFilter; DateFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Date Filter';
                    trigger OnValidate()
                    BEGIN
                        IF TextManagement.MakeDateFilter(DateFilter) <> 0 THEN
                            ERROR(Text001, DateFilter);
                    END;
                }

                Field(CompPeriodDateFilter; CompPeriodDateFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Comparison Period Date Filter';
                    trigger OnValidate()
                    BEGIN
                        IF TextManagement.MakeDateFilter(CompPeriodDateFilter) <> 0 THEN
                            ERROR(Text001, CompPeriodDateFilter);
                    END;
                }
                field("Assets Amount"; Rec."Assets Amount")
                {
                    ApplicationArea = all;

                }
                field("Liabilities Amount"; Rec."Liabilities Amount")
                {
                    ApplicationArea = all;
                }
                field("Comparison Assets Amount"; Rec."Comparison Assets Amount")
                {
                    ApplicationArea = all;

                }
                field("Comparison Liabilities Amount"; Rec."Comparison Liabilities Amount")
                {
                    ApplicationArea = all;
                }
            }

            Group(g2)
            {
                ShowCaption = false;
                Repeater(r1)
                {
                    Field("Line Symbol"; Rec."Line Symbol")
                    {
                        ApplicationArea = all;
                    }

                    Field(Description; Rec.Description)
                    {
                        ApplicationArea = all;
                    }

                    Field("Description for Negative"; Rec."Description for Negative")
                    {
                        ApplicationArea = all;
                        Visible = false;
                    }
                    Field("Description 2"; Rec."Description 2")
                    {
                        ApplicationArea = all;
                        Visible = FALSE;
                    }

                    Field("Description for Negative 2"; Rec."Description for Negative 2")
                    {
                        ApplicationArea = all;
                        Visible = FALSE;
                    }

                    Field(Type; Rec.Type)
                    {
                        ApplicationArea = all;
                    }
                    Field("Comparison Balance"; Rec."Comparison Balance")
                    {
                        ApplicationArea = all;
                    }
                    Field(Balance; Rec.Balance)
                    {
                        ApplicationArea = all;
                    }
                    field("Set Zero"; Rec."Set Zero")
                    {
                        ApplicationArea = all;
                        Visible = false;
                    }
                    Field("New Page"; Rec."New Page")
                    {
                        ApplicationArea = all;
                    }
                    Field(Hide; Rec.Hide)
                    {
                        ApplicationArea = all;
                    }
                    Field("Line No."; Rec."Line No.")
                    {
                        ApplicationArea = all;
                        Visible = FALSE;
                    }
                    field("Level No."; Rec."Level No.")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            Action("Calculation &Setup")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                Image = SetupList;
                PromotedCategory = Process;
                ShortcutKey = 'F11';
                trigger OnAction()
                VAR
                    BSLineSetup: Record "TOR Balance Sheet Calc. Setup";
                BEGIN
                    Rec.TESTFIELD(Type, Rec.Type::Calculation);
                    BSLineSetup.SETRANGE("BS Batch Name", Rec."Batch Name");
                    BSLineSetup.SETRANGE("BS Assets/Liabilities", Rec."Assets/Liabilities");
                    BSLineSetup.SETRANGE("BS Line No.", Rec."Line No.");
                    PAGE.RUN(PAGE::"TOR Balance Sheet Calc. Setup", BSLineSetup);
                END;
            }
            Action("&Calculate")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                Image = CalculateLines;
                PromotedCategory = Process;
                ShortcutKey = 'F9';
                trigger OnAction()
                BEGIN
                    BalanceSheetMgt.CalculateBalanceSheet(Rec, DateFilter, CompPeriodDateFilter);
                    CurrPage.UPDATE(FALSE);
                END;
            }
            Action("Previous Level")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = PreviousSet;
                PromotedCategory = Process;
                ShortcutKey = 'Ctrl+L';
                trigger OnAction()
                VAR
                    BalanceLine: Record "TOR Balance Sheet Line";
                    NextResult: Integer;
                    LoopControl: Boolean;
                    Text0001: Label 'There isn''t previously balance line to line %1 %2';
                BEGIN
                    BalanceLine.SETRANGE("Batch Name", Rec."Batch Name");
                    BalanceLine.SETRANGE("Assets/Liabilities", Rec."Assets/Liabilities");
                    IF Rec."Line No." > 0 THEN BEGIN
                        BalanceLine.GET(Rec."Batch Name", Rec."Assets/Liabilities", Rec."Line No.");
                        IF BalanceLine.NEXT <> 0 THEN
                            NextResult := BalanceLine."Level No."
                        ELSE
                            NextResult := Rec."Level No.";
                        IF (Rec."Level No." > 1) AND (Rec."Level No." >= NextResult) THEN BEGIN
                            Rec."Level No." := Rec."Level No." - 1;
                            Rec.MODIFY;
                            BalanceLine.GET(Rec."Batch Name", Rec."Assets/Liabilities", Rec."Line No.");
                            IF BalanceLine.NEXT(-1) <> 0 THEN
                                BalanceLine.UpDateNext(Rec, BalanceLine."Level No.", BalanceLine."Path Symbol")
                            ELSE
                                ERROR(Text0001, BalanceLine."Batch Name", BalanceLine."Line No.");
                            CurrPage.UPDATE(FALSE);
                        END;
                    END;
                END;
            }
            Action("Next Level")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = NextSet;
                PromotedCategory = Process;
                trigger OnAction()
                VAR
                    BalanceLine: Record "TOR Balance Sheet Line";
                BEGIN
                    BalanceLine.SETRANGE("Batch Name", Rec."Batch Name");
                    BalanceLine.SETRANGE("Assets/Liabilities", Rec."Assets/Liabilities");
                    IF Rec."Line No." > 0 THEN BEGIN
                        BalanceLine.GET(Rec."Batch Name", Rec."Assets/Liabilities", Rec."Line No.");
                        IF BalanceLine.NEXT(-1) <> 0 THEN BEGIN
                            IF BalanceLine."Level No." >= Rec."Level No." THEN BEGIN
                                Rec."Level No." := Rec."Level No." + 1;
                                Rec.MODIFY;
                                BalanceLine.UpDateNext(Rec, BalanceLine."Level No.", BalanceLine."Path Symbol");
                                CurrPage.UPDATE(FALSE);
                            END;
                        END;
                    END;
                END;
            }
        }
        area(Reporting)
        {
            Action("&Print")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedCategory = Report;
                ShortcutKey = 'Ctrl+P';
                trigger OnAction()
                BEGIN
                    //BalanceReport.SetFilters(DateFilter, CompPeriodDateFilter, CurrentBalanceName);
                    //BalanceReport.RUN;
                    CurrPage.UPDATE(FALSE);
                END;
            }
            Action("G/L Account Usage")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                trigger OnAction()
                VAR
                    GLAccount: Record "G/L Account";
                BEGIN
                    GLAccount.SETRANGE("Income/Balance", GLAccount."Income/Balance"::"Balance Sheet");
                    //REPORT.RUN(REPORT::"TOR BS & PLS G/L Account Usage",TRUE,TRUE,GLAccount);
                END;
            }
        }

    }

    trigger OnOpenPage()
    var
        BalanceSelected: Boolean;
    BEGIN
        BalanceSheetMgt.BalanceSelection(Rec);
        BalanceSheetMgt.OpenBalance(CurrentBalanceName, Rec, BalanceSide);
        IF NOT BalanceName.GET(CurrentBalanceName) THEN
            ERROR(Text002, CurrentBalanceName);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CaptionText := Caption;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        BalanceLine: Record "TOR Balance Sheet Line";
    BEGIN
        BalanceLine.SETRANGE("Batch Name", Rec."Batch Name");
        BalanceLine.SETRANGE("Assets/Liabilities", Rec."Assets/Liabilities");
        IF BalanceLine.COUNT = 0 THEN BEGIN
            Rec."Level No." := 1;
            Rec."Line Symbol" := LevelNumber.FirstSymbol(Rec."Level No.");
            Rec."Path Symbol" := Rec."Line Symbol" + ',';
            Rec.VALIDATE("Line Symbol");
        END ELSE BEGIN
            BalanceLine.GET(xRec."Batch Name", xRec."Assets/Liabilities", xRec."Line No.");
            IF BelowxRec THEN BEGIN
                Rec."Level No." := xRec."Level No.";
                Rec."Line Symbol" := LevelNumber.NextSymbol(Rec."Level No.", DELCHR(xRec."Line Symbol", '<>'));
                Rec."Path Symbol" := Rec.CutString(xRec."Path Symbol", xRec."Level No." - 1);
                Rec."Path Symbol" := Rec."Path Symbol" + Rec."Line Symbol" + ',';
                Rec.VALIDATE("Line Symbol");
            END ELSE BEGIN
                IF BalanceLine.NEXT(-1) <> 0 THEN BEGIN
                    Rec."Level No." := BalanceLine."Level No.";
                    Rec."Line Symbol" := LevelNumber.NextSymbol(Rec."Level No.", DELCHR(BalanceLine."Line Symbol", '<>'));
                    Rec."Path Symbol" := Rec.CutString(BalanceLine."Path Symbol", BalanceLine."Level No." - 1);
                    Rec."Path Symbol" := Rec."Path Symbol" + Rec."Line Symbol" + ',';
                    Rec.VALIDATE("Line Symbol");
                END ELSE BEGIN
                    Rec."Level No." := 1;
                    Rec."Line Symbol" := LevelNumber.FirstSymbol(Rec."Level No.");
                    Rec."Path Symbol" := Rec."Line Symbol" + ',';
                    Rec.VALIDATE("Line Symbol");
                END;
            END;
        END;
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    VAR
        BalanceLine: Record "TOR Balance Sheet Line";
    BEGIN
        IF NOT BelowxRec THEN
            Rec.UpDateNext(xRec, Rec."Level No.", Rec."Path Symbol")
    END;

    trigger OnDeleteRecord(): Boolean
    VAR
        BalanceLine2: Record "TOR Balance Sheet Line";
    BEGIN
        BalanceLine2.SETRANGE("Batch Name", Rec."Batch Name");
        BalanceLine2.SETRANGE("Assets/Liabilities", Rec."Assets/Liabilities");
        BalanceLine2.GET(Rec."Batch Name", Rec."Assets/Liabilities", Rec."Line No.");
        IF BalanceLine2.NEXT <> 0 THEN BEGIN
            IF BalanceLine2."Level No." > Rec."Level No." THEN
                ERROR(Text0001);
            BalanceLine2."Line Symbol" := Rec."Line Symbol";
            BalanceLine2."Path Symbol" := Rec."Path Symbol";
            BalanceLine2.MODIFY;
            IF BalanceLine2.NEXT <> 0 THEN
                Rec.UpDateNext(BalanceLine2, Rec."Level No.", Rec."Path Symbol");
        END;
    END;

    VAR
        BalanceName: Record "TOR Balance Sheet Batch";
        LevelNumber: Record "TOR Level Number";
        BalanceSheetMgt: Codeunit TORBalanceSheetManagement;
        TextManagement: Codeunit "TOR Text Management";
        //BalanceReport: Report 52063180;
        CurrentBalanceName: Code[20];
        BalanceSide: enum "TOR Assets/Liabilities";
        Text001: Label 'The filter %1 is not valid for Date Filter.';
        Text002: Label 'Balance Sheet Batch %1 does not exist.';
        Text0001: Label 'You cannot delete this line, as one or more sublines exists.';
        CaptionText: Text[80];
        DateFilter: Text[30];
        CompPeriodDateFilter: Text[30];

    LOCAL PROCEDURE LookUpDimFilter(Dim: Code[20]; VAR Text: Text[250]): Boolean;
    VAR
        DimVal: Record "Dimension Value";
        DimValList: Page "Dimension Value List";
    BEGIN
        IF Dim = '' THEN
            EXIT(FALSE);
        DimValList.LOOKUPMODE(TRUE);
        DimVal.SETRANGE("Dimension Code", Dim);
        DimValList.SETTABLEVIEW(DimVal);
        IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    END;

    PROCEDURE Caption() CaptionText: Text[80];
    BEGIN
        CaptionText :=
          STRSUBSTNO(
            '%1 %2 %3', Rec."Batch Name", FORMAT(Rec."Assets/Liabilities"), Rec."Line No.");
    END;

    LOCAL PROCEDURE CurrentBalanceNameOnAfterValid();
    BEGIN
        CurrPage.SAVERECORD;
        BalanceSheetMgt.SetName(CurrentBalanceName, Rec);
        CurrPage.UPDATE(FALSE);
    END;



}