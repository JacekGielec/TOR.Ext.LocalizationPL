codeunit 50543 TORProfitSheetManagement
{
    trigger OnRun()
    begin

    end;

    PROCEDURE PLSelection(VAR PLSLine: Record "TOR Profit & Loss Line");
    VAR
        PLSBatch: Record "TOR Profit & Loss Batch";
        Text002: Label 'Default';
        Text003: Label 'Default Profit & Loss';
    BEGIN
        PLSBatch.RESET;
        IF PLSBatch.COUNT = 0 THEN BEGIN
            PLSBatch.INIT;
            PLSBatch.Name := Text002;
            PLSBatch.Description := Text003;
            PLSBatch.INSERT;
            COMMIT;
        END ELSE
            PLSBatch.FINDFIRST;
        PLSLine.FILTERGROUP := 2;
        PLSLine.SETRANGE("Batch Name", PLSBatch.Name);
        PLSLine.FILTERGROUP := 0;
    END;

    PROCEDURE CheckName(CurrentPLName: Code[20]; VAR PLLine: Record "TOR Profit & Loss Line");
    VAR
        PLBatch: Record "TOR Profit & Loss Batch";
    BEGIN
        PLBatch.GET(CurrentPLName);
    END;

    PROCEDURE SetName(CurrentPLName: Code[20]; VAR PLLine: Record "TOR Profit & Loss Line");
    BEGIN
        PLLine.FILTERGROUP := 2;
        PLLine.SETRANGE("Batch Name", CurrentPLName);
        PLLine.FILTERGROUP := 0;
        IF PLLine.FIND('-') THEN;
    END;

    PROCEDURE LookupName(VAR CurrentPLName: Code[20]; VAR PLLine: Record "TOR Profit & Loss Line");
    VAR
        PLBatch: Record "TOR Profit & Loss Batch";
    BEGIN
        COMMIT;
        IF PAGE.RUNMODAL(0, PLBatch) = ACTION::LookupOK THEN BEGIN
            CurrentPLName := PLBatch.Name;
            SetName(CurrentPLName, PLLine);
        END;
    END;

    PROCEDURE OpenPL(VAR CurrentPLName: Code[20]; VAR PLSLine: Record "TOR Profit & Loss Line");
    BEGIN
        CheckPLName(PLSLine.GETRANGEMAX("Batch Name"), CurrentPLName);
        PLSLine.FILTERGROUP := 2;
        PLSLine.SETRANGE("Batch Name", CurrentPLName);
        PLSLine.FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE CheckPLName(CurrentPLTempName: Code[20]; VAR CurrentPLName: Code[20]);
    VAR
        PLSBatch: Record "TOR Profit & Loss Batch";
    BEGIN
        PLSBatch.GET(CurrentPLTempName);
        CurrentPLName := PLSBatch.Name;
    END;

    PROCEDURE CalculatePLS(VAR PLLine2: Record "TOR Profit & Loss Line"; DateFilter: Text; CompPeriodDateFilter: Text);
    VAR
        PLLine: Record "TOR Profit & Loss Line";
        PLLine1: Record "TOR Profit & Loss Line";
        PLSLineSetup: Record "TOR Profit & Loss Calc. Setup";
        GLAccount: Record "G/L Account";
        Level: Integer;
        LineNo: Integer;
        MaxLevelNo: Integer;
        GLAccValue: Decimal;
        Text0001: Label 'There is no calculation setup for item %1 of P&L %2.';
        Text0002: Label 'There is no subitem for line %1 of P&L %2.';
    BEGIN
        PLLine.SETCURRENTKEY("Batch Name", "Level No.");
        PLLine.SETRANGE("Batch Name", PLLine2."Batch Name");
        IF PLLine.FINDLAST THEN
            MaxLevelNo := PLLine."Level No."
        ELSE
            MaxLevelNo := 0;
        PLLine.RESET;
        PLLine.SETRANGE("Batch Name", PLLine2."Batch Name");
        PLLine2.COPYFILTER("Global Dimension 1 Filter", PLLine."Global Dimension 1 Filter");
        PLLine2.COPYFILTER("Global Dimension 2 Filter", PLLine."Global Dimension 2 Filter");
        PLLine1.SETRANGE("Batch Name", PLLine2."Batch Name");

        FOR Level := MaxLevelNo DOWNTO 1 DO BEGIN
            PLLine.SETRANGE("Level No.", Level);
            IF PLLine.FINDSET THEN
                REPEAT
                    IF PLLine.Type = PLLine.Type::Sum THEN BEGIN
                        PLLine1.SETRANGE("Level No.", PLLine."Level No." + 1);
                        PLLine1.SETFILTER("Path Symbol", PLLine."Path Symbol" + '*');
                        IF PLLine1.FINDSET THEN BEGIN
                            PLLine.Amount := 0;
                            PLLine."Comparison Period Amount" := 0;
                            REPEAT
                                PLLine.Amount := PLLine.Amount + PLLine1.Amount;
                                PLLine."Comparison Period Amount" := PLLine."Comparison Period Amount" + PLLine1."Comparison Period Amount";
                            UNTIL PLLine1.NEXT = 0;
                            PLLine.MODIFY;
                        END ELSE
                            ERROR(Text0002, PLLine."Line No.", PLLine."Batch Name");
                        PLLine1.SETRANGE("Level No.");
                        PLLine1.SETRANGE("Path Symbol");
                    end else
                        if PLLine.Type = PLLine.Type::Value then begin

                        END ELSE BEGIN
                            PLSLineSetup.SETRANGE("PLS Batch Name", PLLine."Batch Name");
                            PLSLineSetup.SETRANGE("PLS Line No.", PLLine."Line No.");
                            IF PLSLineSetup.FINDSET THEN BEGIN
                                PLLine.Amount := 0;
                                PLLine."Comparison Period Amount" := 0;
                                REPEAT
                                    CASE PLSLineSetup."Source Type" OF
                                        PLSLineSetup."Source Type"::"G/L Account":
                                            BEGIN
                                                GLAccount.GET(PLSLineSetup."Source Code");
                                                PLLine.COPYFILTER("Global Dimension 1 Filter", GLAccount."Global Dimension 1 Filter");
                                                PLLine.COPYFILTER("Global Dimension 2 Filter", GLAccount."Global Dimension 2 Filter");
                                                GLAccount.SETFILTER("Date Filter", CompPeriodDateFilter);
                                                GLAccount.CALCFIELDS("Net Change", "Balance at Date");
                                                GLAccValue := 0;
                                                CASE PLSLineSetup."Amount Type" OF
                                                    PLSLineSetup."Amount Type"::"Net Change":
                                                        GLAccValue := GLAccount."Net Change";
                                                    PLSLineSetup."Amount Type"::"Negative Net Change":
                                                        IF GLAccount."Balance at Date" > 0 THEN
                                                            GLAccValue := GLAccount."Balance at Date";
                                                    PLSLineSetup."Amount Type"::"Positive Net Change":
                                                        IF GLAccount."Balance at Date" < 0 THEN
                                                            GLAccValue := GLAccount."Balance at Date";
                                                END;
                                                IF (PLSLineSetup.Operation = PLSLineSetup.Operation::"+") THEN
                                                    PLLine."Comparison Period Amount" := PLLine."Comparison Period Amount" + GLAccValue
                                                ELSE
                                                    PLLine."Comparison Period Amount" := PLLine."Comparison Period Amount" - GLAccValue;
                                                GLAccount.SETFILTER("Date Filter", DateFilter);
                                                GLAccount.CALCFIELDS("Net Change", "Balance at Date");
                                                GLAccValue := 0;
                                                CASE PLSLineSetup."Amount Type" OF
                                                    PLSLineSetup."Amount Type"::"Net Change":
                                                        GLAccValue := GLAccount."Net Change";
                                                    PLSLineSetup."Amount Type"::"Negative Net Change":
                                                        IF GLAccount."Balance at Date" > 0 THEN
                                                            GLAccValue := GLAccount."Balance at Date";
                                                    PLSLineSetup."Amount Type"::"Positive Net Change":
                                                        IF GLAccount."Balance at Date" < 0 THEN
                                                            GLAccValue := GLAccount."Balance at Date";
                                                END;
                                                IF (PLSLineSetup.Operation = PLSLineSetup.Operation::"+") THEN
                                                    PLLine.Amount := PLLine.Amount + GLAccValue
                                                ELSE
                                                    PLLine.Amount := PLLine.Amount - GLAccValue;
                                            END;

                                        PLSLineSetup."Source Type"::"Profit & Loss Line":
                                            BEGIN
                                                EVALUATE(LineNo, PLSLineSetup."Source Code");
                                                PLLine1.GET(PLSLineSetup."PLS Batch Name", LineNo);
                                                IF (PLSLineSetup.Operation = PLSLineSetup.Operation::"+")
                                                THEN BEGIN
                                                    PLLine.Amount := PLLine.Amount + PLLine1.Amount;
                                                    PLLine."Comparison Period Amount" := PLLine."Comparison Period Amount" + PLLine1."Comparison Period Amount";
                                                END ELSE BEGIN
                                                    PLLine.Amount := PLLine.Amount - PLLine1.Amount;
                                                    PLLine."Comparison Period Amount" := PLLine."Comparison Period Amount" - PLLine1."Comparison Period Amount";
                                                END;
                                            END;

                                    END;
                                    PLLine.MODIFY;
                                UNTIL PLSLineSetup.NEXT = 0;
                                IF (PLLine."Set Zero" = PLLine."Set Zero"::"When negative amount") THEN BEGIN
                                    IF PLLine.Amount < 0 THEN
                                        PLLine.Amount := 0;
                                    IF PLLine."Comparison Period Amount" < 0 THEN
                                        PLLine."Comparison Period Amount" := 0;
                                    PLLine.MODIFY;
                                END;
                                IF (PLLine."Set Zero" = PLLine."Set Zero"::"When positive amount") THEN BEGIN
                                    IF PLLine.Amount > 0 THEN
                                        PLLine.Amount := 0;
                                    IF PLLine."Comparison Period Amount" > 0 THEN
                                        PLLine."Comparison Period Amount" := 0;
                                    PLLine.MODIFY;
                                END;
                            END;
                        END;
                UNTIL PLLine.NEXT = 0;
        END;
    END;

}