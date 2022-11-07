page 50491 "TOR Profit & Loss Statement"
{
    ApplicationArea = All;
    UsageCategory = Administration;

    Caption = 'Profit & Loss Statement';
    SaveValues = true;
    SourceTable = "TOR Profit & Loss Line";
    DataCaptionExpression = CaptionText;
    PageType = List;
    AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Field("Batch Name"; CurrentPLName)
                {
                    ApplicationArea = all;
                    Caption = 'Batch Name';
                    Lookup = true;
                    trigger OnValidate()
                    BEGIN
                        PLMgt.CheckName(CurrentPLName, Rec);
                        CurrentPLNameOnAfterValidate;
                    END;

                    trigger OnLookup(var myText: Text): Boolean
                    BEGIN
                        CurrPage.SAVERECORD;
                        PLMgt.LookupName(CurrentPLName, Rec);
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

                        PLMgt.CalculatePLS(Rec, DateFilter, CompPeriodDateFilter);
                        CurrPage.UPDATE(FALSE);
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
                        PLMgt.CalculatePLS(Rec, DateFilter, CompPeriodDateFilter);
                        CurrPage.UPDATE(FALSE);
                    END;
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
                    Field("Set Zero"; Rec."Set Zero")
                    {
                        ApplicationArea = all;
                    }
                    Field(Amount; Rec.Amount)
                    {
                        ApplicationArea = all;
                        Editable = _Editable;
                    }

                    Field("Comparison Period Amount"; Rec."Comparison Period Amount")
                    {
                        ApplicationArea = all;
                        Editable = _Editable;
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
                    PLSLineSetup: Record "TOR Profit & Loss Calc. Setup";
                BEGIN
                    Rec.TESTFIELD(Type, Rec.Type::Calculation);
                    PLSLineSetup.SETRANGE("PLS Batch Name", Rec."Batch Name");
                    PLSLineSetup.SETRANGE("PLS Line No.", Rec."Line No.");
                    PAGE.RUN(PAGE::"TOR Profit & Loss Calc. Setup", PLSLineSetup);
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
                    PLMgt.CalculatePLS(Rec, DateFilter, CompPeriodDateFilter);
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
                    PLLine: Record "TOR Profit & Loss Line";
                    NextResult: Integer;
                    LoopControl: Boolean;
                    Text0001: Label 'There isn''t previously balance line to line %1 %2';
                BEGIN
                    PLLine.SETRANGE("Batch Name", Rec."Batch Name");
                    IF Rec."Line No." > 0 THEN BEGIN
                        PLLine.GET(Rec."Batch Name", Rec."Line No.");
                        IF PLLine.NEXT <> 0 THEN
                            NextResult := PLLine."Level No."
                        ELSE
                            NextResult := Rec."Level No.";
                        IF (Rec."Level No." > 1) AND (Rec."Level No." >= NextResult) THEN BEGIN
                            Rec."Level No." := Rec."Level No." - 1;
                            Rec.MODIFY;
                            PLLine.GET(Rec."Batch Name", Rec."Line No.");
                            IF PLLine.NEXT(-1) <> 0 THEN
                                PLLine.UpDateNext(Rec, PLLine."Level No.", PLLine."Path Symbol")
                            ELSE
                                ERROR(Text0001, PLLine."Batch Name", PLLine."Line No.");
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
                ShortcutKey = 'Ctrl+R';
                trigger OnAction()
                VAR
                    PLLine: Record "TOR Profit & Loss Line";
                BEGIN
                    PLLine.SETRANGE("Batch Name", Rec."Batch Name");
                    IF Rec."Line No." > 0 THEN BEGIN
                        PLLine.GET(Rec."Batch Name", Rec."Line No.");
                        IF PLLine.NEXT(-1) <> 0 THEN BEGIN
                            IF PLLine."Level No." >= Rec."Level No." THEN BEGIN
                                Rec."Level No." := Rec."Level No." + 1;
                                Rec.MODIFY;
                                PLLine.UpDateNext(Rec, PLLine."Level No.", PLLine."Path Symbol");
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
                    PLSReport.SetTableView(Rec);

                    PLSReport.SetFilters(DateFilter, CompPeriodDateFilter, CurrentPLName);
                    PLSReport.RUN;
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
                    GLAccount.SETRANGE("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
                    //REPORT.RUN(REPORT::"BS & PLS G/L Account Usage",TRUE,TRUE,GLAccount);
                END;
            }
        }
    }


    trigger OnOpenPage()
    var
        PLSelected: Boolean;
    BEGIN
        PLMgt.PLSelection(Rec);
        PLMgt.OpenPL(CurrentPLName, Rec);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CaptionText := Caption;
        _Editable := (Rec.Type = Rec.Type::Description) or (Rec.Type = Rec.Type::Value);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        _Editable := (Rec.Type = Rec.Type::Description) or (Rec.Type = Rec.Type::Value);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        PLLine: Record "TOR Profit & Loss Line";
    BEGIN
        PLLine.SETRANGE("Batch Name", Rec."Batch Name");
        IF PLLine.COUNT = 0 THEN BEGIN
            Rec."Level No." := 1;
            Rec."Line Symbol" := LevelNumber.FirstSymbol(Rec."Level No.");
            Rec."Path Symbol" := Rec."Line Symbol" + ',';
            Rec.VALIDATE("Line Symbol");
        END ELSE BEGIN
            PLLine.GET(xRec."Batch Name", xRec."Line No.");
            IF BelowxRec THEN BEGIN
                Rec."Level No." := xRec."Level No.";
                Rec."Line Symbol" := LevelNumber.NextSymbol(Rec."Level No.", DELCHR(xRec."Line Symbol", '<>'));
                Rec."Path Symbol" := Rec.CutString(xRec."Path Symbol", xRec."Level No." - 1);
                Rec."Path Symbol" := Rec."Path Symbol" + Rec."Line Symbol" + ',';
                Rec.VALIDATE("Line Symbol");
            END ELSE BEGIN
                IF PLLine.NEXT(-1) <> 0 THEN BEGIN
                    Rec."Level No." := PLLine."Level No.";
                    Rec."Line Symbol" := LevelNumber.NextSymbol(Rec."Level No.", DELCHR(PLLine."Line Symbol", '<>'));
                    Rec."Path Symbol" := Rec.CutString(PLLine."Path Symbol", PLLine."Level No." - 1);
                    Rec."Path Symbol" := Rec."Path Symbol" + Rec."Line Symbol" + ',';
                    Rec.VALIDATE("Line Symbol");
                    UpdateNextLine := TRUE;
                END ELSE BEGIN
                    Rec."Level No." := 1;
                    Rec."Line Symbol" := LevelNumber.FirstSymbol(Rec."Level No.");
                    Rec."Path Symbol" := Rec."Line Symbol" + ',';
                    Rec.VALIDATE("Line Symbol");
                    UpdateNextLine := TRUE;
                END;
            END;
        END;
    END;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    VAR
        PLLine: Record "TOR Profit & Loss Line";
    BEGIN
        IF UpdateNextLine THEN
            IF xRec."Line No." > 0 THEN
                Rec.UpDateNext(xRec, Rec."Level No.", Rec."Path Symbol")
            ELSE BEGIN
                PLLine.SETRANGE("Batch Name", Rec."Batch Name");
                IF PLLine.FIND('-') THEN Rec.UpDateNext(PLLine, Rec."Level No.", Rec."Path Symbol")
            END;
        UpdateNextLine := FALSE;
    END;

    trigger OnDeleteRecord(): Boolean
    VAR
        PLLine2: Record "TOR Profit & Loss Line";
    BEGIN
        PLLine2.SETRANGE("Batch Name", Rec."Batch Name");
        PLLine2.GET(Rec."Batch Name", Rec."Line No.");
        IF PLLine2.NEXT <> 0 THEN BEGIN
            IF PLLine2."Level No." > Rec."Level No." THEN
                ERROR(Text0001);
            PLLine2."Line Symbol" := Rec."Line Symbol";
            PLLine2."Path Symbol" := Rec."Path Symbol";
            PLLine2.MODIFY;
            IF PLLine2.NEXT <> 0 THEN
                Rec.UpDateNext(PLLine2, Rec."Level No.", Rec."Path Symbol");
        END;
    END;

    VAR
        LevelNumber: Record "TOR Level Number";
        PLMgt: Codeunit TORProfitSheetManagement;
        TextManagement: Codeunit "TOR Text Management";
        PLSReport: Report "TOR Profit & Loss";
        CurrentPLName: Code[20];
        UpdateNextLine: Boolean;
        Text001: Label 'The filter %1 is not valid for Date Filter.';
        Text0001: Label 'You cannot delete this line, as one or more sublines exists.';
        GlobalDim1Filter: Code[250];
        GlobalDim2Filter: Code[250];
        CaptionText: Text[80];
        DateFilter: Text[30];
        CompPeriodDateFilter: Text[30];
        _Editable: Boolean;

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
          STRSUBSTNO('%1 %2', Rec."Batch Name", Rec."Line No.");
    END;

    LOCAL PROCEDURE CurrentPLNameOnAfterValidate();
    BEGIN
        CurrPage.SAVERECORD;
        PLMgt.SetName(CurrentPLName, Rec);
        CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE GlobalDim2FilterOnAfterValidat();
    BEGIN
        Rec.SETFILTER("Global Dimension 2 Filter", GlobalDim2Filter);
    END;

    LOCAL PROCEDURE GlobalDim1FilterOnAfterValidat();
    BEGIN
        Rec.SETFILTER("Global Dimension 1 Filter", GlobalDim1Filter);
    END;

}