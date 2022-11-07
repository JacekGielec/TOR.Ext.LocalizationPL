codeunit 50542 TORBalanceSheetManagement
{
    trigger OnRun()
    begin

    end;

    PROCEDURE BalanceSelection(VAR BalanceLine: Record "TOR Balance Sheet Line");
    VAR
        BalanceBatch: Record "TOR Balance Sheet Batch";
        Text002: Label 'Default';
        Text003: Label 'Default Balance';
    BEGIN
        //BalanceSelected := TRUE;
        BalanceBatch.RESET;
        IF BalanceBatch.COUNT = 0 THEN BEGIN
            BalanceBatch.INIT;
            BalanceBatch.Name := Text002;
            BalanceBatch.Description := Text003;
            BalanceBatch.INSERT;
            COMMIT;
        END ELSE
            BalanceBatch.FINDFIRST;
        BalanceLine.FILTERGROUP := 2;
        BalanceLine.SETRANGE("Batch Name", BalanceBatch.Name);
        BalanceLine.FILTERGROUP := 0;
        //END;
    END;

    PROCEDURE CheckName(CurrentBalanceName: Code[20]; VAR BalancelLine: Record "TOR Balance Sheet Line");
    VAR
        BalanceBatch: Record "TOR Balance Sheet Batch";
    BEGIN
        BalanceBatch.GET(CurrentBalanceName);
    END;

    PROCEDURE SetName(CurrentBalanceName: Code[20]; VAR BalanceLine: Record "TOR Balance Sheet Line");
    BEGIN
        BalanceLine.FILTERGROUP := 2;
        BalanceLine.SETRANGE("Batch Name", CurrentBalanceName);
        BalanceLine.FILTERGROUP := 0;
        IF BalanceLine.FINDSET THEN;
    END;

    PROCEDURE LookupName(VAR CurrentBalanceName: Code[20]; VAR BalanceLine: Record "TOR Balance Sheet Line");
    VAR
        BalanceBatch: Record "TOR Balance Sheet Batch";
    BEGIN
        COMMIT;
        IF PAGE.RUNMODAL(0, BalanceBatch) = ACTION::LookupOK THEN BEGIN
            CurrentBalanceName := BalanceBatch.Name;
            SetName(CurrentBalanceName, BalanceLine);
        END;
    END;

    PROCEDURE OpenBalance(VAR CurrentBalanceName: Code[20]; VAR BalanceLine: Record "TOR Balance Sheet Line"; BalanceSide: Enum "TOR Assets/Liabilities");
    BEGIN
        CheckBalanceName(BalanceLine.GETRANGEMAX("Batch Name"), CurrentBalanceName);
        BalanceLine.FILTERGROUP := 2;
        BalanceLine.SETRANGE("Batch Name", CurrentBalanceName);
        BalanceLine.SETRANGE("Assets/Liabilities", BalanceSide);
        BalanceLine.FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE CheckBalanceName(CurrentBalanceTempName: Code[20]; VAR CurrentBalanceName: Code[20]);
    VAR
        BalanceBatch: Record "TOR Balance Sheet Batch";
    BEGIN
        BalanceBatch.GET(CurrentBalanceTempName);
        CurrentBalanceName := BalanceBatch.Name;
    END;

    PROCEDURE CalculateBalanceSheet(VAR BalanceLine2: Record "TOR Balance Sheet Line"; DateFilter: Text; CompPeriodDateFilter: Text);
    VAR
        BalanceLine: Record "TOR Balance Sheet Line";
        BalanceLine1: Record "TOR Balance Sheet Line";
        BalanceLineElement: Record "TOR Balance Sheet Calc. Setup";
        PLLine: Record "TOR Profit & Loss Line";
        GLAccount: Record "G/L Account";
        ProfitLossManagement: Codeunit TORProfitSheetManagement;
        Level: Integer;
        LineNo: Integer;
        MaxLevelNo: Integer;
        GLAccValue: Decimal;
        Text0001: Label 'Calculation setup for line %1 of Balance %2 does not exist.';
        Text0002: Label 'Subitem for line %1 of Balance %2 does not exist.';
        Text0003: Label 'In setup for line %1 of balance %2 the line %3 does not exist.';
        Text0004: Label 'In setup for line %1 of balance %2 the line %3 of P&L %4 does not exist.';
        Text0005: Label 'Profit & Loss %1 does not exist.;PLK=Rachunek zysk¢w i strat %1 nie istnieje.';
    BEGIN
        BalanceLine.SETCURRENTKEY("Batch Name", "Level No.");
        BalanceLine.SETRANGE("Batch Name", BalanceLine2."Batch Name");
        IF BalanceLine.FINDLAST THEN
            MaxLevelNo := BalanceLine."Level No."
        ELSE
            MaxLevelNo := 0;
        BalanceLine.RESET;
        BalanceLine.SETRANGE("Batch Name", BalanceLine2."Batch Name");
        BalanceLine2.COPYFILTER("Global Dimension 1 Filter", BalanceLine."Global Dimension 1 Filter");
        BalanceLine2.COPYFILTER("Global Dimension 2 Filter", BalanceLine."Global Dimension 2 Filter");
        BalanceLine1.SETRANGE("Batch Name", BalanceLine2."Batch Name");
        //GLAccount.SETRANGE("Account Type", GLAccount."Account Type"::Posting);
        FOR Level := MaxLevelNo DOWNTO 1 DO BEGIN
            BalanceLine.SETRANGE("Level No.", Level);
            IF BalanceLine.FINDSET THEN
                REPEAT
                    IF BalanceLine.Type = BalanceLine.Type::Sum THEN BEGIN
                        BalanceLine1.SETRANGE("Assets/Liabilities", BalanceLine."Assets/Liabilities");
                        BalanceLine1.SETRANGE("Level No.", BalanceLine."Level No." + 1);
                        BalanceLine1.SETFILTER("Path Symbol", BalanceLine."Path Symbol" + '*');
                        IF BalanceLine1.FINDSET THEN BEGIN
                            BalanceLine."Comparison Balance" := 0;
                            BalanceLine.Balance := 0;
                            REPEAT
                                BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" + BalanceLine1."Comparison Balance";
                                BalanceLine.Balance := BalanceLine.Balance + BalanceLine1.Balance;
                            UNTIL BalanceLine1.NEXT = 0;
                            BalanceLine.MODIFY;
                        END ELSE
                            ERROR(Text0002, BalanceLine."Line No.", BalanceLine."Batch Name");
                        BalanceLine1.SETRANGE("Level No.");
                        BalanceLine1.SETRANGE("Assets/Liabilities");
                        BalanceLine1.SETRANGE("Path Symbol");
                    END ELSE BEGIN
                        BalanceLineElement.SETRANGE("BS Batch Name", BalanceLine2."Batch Name");
                        BalanceLineElement.SETRANGE("BS Line No.", BalanceLine."Line No.");
                        BalanceLineElement.SETRANGE("BS Assets/Liabilities", BalanceLine."Assets/Liabilities");
                        // BalanceLineElement.SETRANGE("Source Type",BalanceLine.Type);
                        IF BalanceLineElement.FINDSET THEN BEGIN
                            BalanceLine."Comparison Balance" := 0;
                            BalanceLine.Balance := 0;
                            REPEAT
                                CASE BalanceLineElement."Source Type" OF
                                    BalanceLineElement."Source Type"::"G/L Account":
                                        BEGIN
                                            //GLAccount.GET(BalanceLineElement."Source Code");
                                            GLAccount.SetFilter("No.", BalanceLineElement."Source Code");
                                            GLAccount.FindFirst();
                                            BalanceLine.COPYFILTER("Global Dimension 1 Filter", GLAccount."Global Dimension 1 Filter");
                                            BalanceLine.COPYFILTER("Global Dimension 2 Filter", GLAccount."Global Dimension 2 Filter");
                                            GLAccount.SETFILTER("Date Filter", DateFilter);
                                            GLAccount.CALCFIELDS("Balance at Date", "Net Change", "Debit Amount", "Credit Amount",
                                              "ITI Customer Debit Amount", "ITI Customer Credit Amount", "ITI Vendor Credit Amount", "ITI Vendor Debit Amount");
                                            GLAccValue := 0;
                                            CASE BalanceLineElement."Amount Type" OF
                                                BalanceLineElement."Amount Type"::"Balance at Date":
                                                    GLAccValue := GLAccount."Balance at Date";
                                                BalanceLineElement."Amount Type"::"Customer Debit":
                                                    GLAccValue := GLAccount."ITI Customer Debit Amount";
                                                BalanceLineElement."Amount Type"::"Customer Credit":
                                                    GLAccValue := GLAccount."ITI Customer Credit Amount";
                                                BalanceLineElement."Amount Type"::"Vendor Debit":
                                                    GLAccValue := GLAccount."ITI Vendor Debit Amount";
                                                BalanceLineElement."Amount Type"::"Vendor Credit":
                                                    GLAccValue := GLAccount."ITI Vendor Credit Amount";
                                                BalanceLineElement."Amount Type"::"Negative Balance at Date":
                                                    IF GLAccount."Balance at Date" < 0 THEN
                                                        GLAccValue := GLAccount."Balance at Date";
                                                BalanceLineElement."Amount Type"::"Positive Balance at Date":
                                                    IF GLAccount."Balance at Date" > 0 THEN
                                                        GLAccValue := GLAccount."Balance at Date";
                                            END;
                                            IF (BalanceLineElement.Operation = BalanceLineElement.Operation::"+") THEN
                                                BalanceLine.Balance := BalanceLine.Balance + GLAccValue
                                            ELSE
                                                BalanceLine.Balance := BalanceLine.Balance - GLAccValue;

                                            GLAccount.SETFILTER("Date Filter", CompPeriodDateFilter);
                                            GLAccount.CALCFIELDS("Balance at Date", "Net Change", "Debit Amount", "Credit Amount",
                                              "iti Customer Debit Amount", "iti Customer Credit Amount", "iti Vendor Credit Amount", "iti Vendor Debit Amount");
                                            GLAccValue := 0;
                                            CASE BalanceLineElement."Amount Type" OF
                                                BalanceLineElement."Amount Type"::"Balance at Date":
                                                    GLAccValue := GLAccount."Balance at Date";
                                                BalanceLineElement."Amount Type"::"Customer Debit":
                                                    GLAccValue := GLAccount."iti Customer Debit Amount";
                                                BalanceLineElement."Amount Type"::"Customer Credit":
                                                    GLAccValue := GLAccount."iti Customer Credit Amount";
                                                BalanceLineElement."Amount Type"::"Vendor Debit":
                                                    GLAccValue := GLAccount."iti Vendor Debit Amount";
                                                BalanceLineElement."Amount Type"::"Vendor Credit":
                                                    GLAccValue := GLAccount."iti Vendor Credit Amount";
                                                BalanceLineElement."Amount Type"::"Negative Balance at Date":
                                                    IF GLAccount."Balance at Date" < 0 THEN
                                                        GLAccValue := GLAccount."Balance at Date";
                                                BalanceLineElement."Amount Type"::"Positive Balance at Date":
                                                    IF GLAccount."Balance at Date" > 0 THEN
                                                        GLAccValue := GLAccount."Balance at Date";
                                            END;
                                            IF (BalanceLineElement.Operation = BalanceLineElement.Operation::"+") THEN
                                                BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" + GLAccValue
                                            ELSE
                                                BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" - GLAccValue;
                                        END;
                                    BalanceLineElement."Source Type"::"Balance Sheet Line":
                                        BEGIN
                                            EVALUATE(LineNo, BalanceLineElement."Source Code");
                                            IF BalanceLine1.GET(BalanceLineElement."BS Batch Name", BalanceLineElement."BS Assets/Liabilities", LineNo)
                                            THEN BEGIN
                                                IF (BalanceLineElement.Operation = BalanceLineElement.Operation::"+") THEN BEGIN
                                                    BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" + BalanceLine1."Comparison Balance";
                                                    BalanceLine.Balance := BalanceLine.Balance + BalanceLine1.Balance;
                                                END ELSE BEGIN
                                                    BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" - BalanceLine1."Comparison Balance";
                                                    BalanceLine.Balance := BalanceLine.Balance - BalanceLine1.Balance;
                                                END;
                                            END ELSE
                                                ERROR(Text0003, BalanceLineElement."BS Line No.", BalanceLineElement."BS Batch Name", BalanceLineElement."Source Code");
                                        END;
                                    BalanceLineElement."Source Type"::"Profit & Loss Line":
                                        BEGIN
                                            PLLine.SETRANGE("Batch Name", BalanceLineElement."Profit & Loss Name");
                                            BalanceLine.COPYFILTER("Global Dimension 1 Filter", PLLine."Global Dimension 1 Filter");
                                            BalanceLine.COPYFILTER("Global Dimension 2 Filter", PLLine."Global Dimension 2 Filter");
                                            IF PLLine.FINDFIRST THEN
                                                ProfitLossManagement.CalculatePLS(PLLine, DateFilter, CompPeriodDateFilter)
                                            ELSE
                                                ERROR(Text0005, BalanceLineElement."Profit & Loss Name");
                                            EVALUATE(LineNo, BalanceLineElement."Source Code");
                                            IF PLLine.GET(BalanceLineElement."Profit & Loss Name", LineNo) THEN BEGIN
                                                IF (BalanceLineElement.Operation = BalanceLineElement.Operation::"+") THEN BEGIN
                                                    BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" + PLLine."Comparison Period Amount";
                                                    BalanceLine.Balance := BalanceLine.Balance + PLLine.Amount;
                                                END ELSE BEGIN
                                                    BalanceLine."Comparison Balance" := BalanceLine."Comparison Balance" - PLLine."Comparison Period Amount";
                                                    BalanceLine.Balance := BalanceLine.Balance - PLLine.Amount;
                                                END;
                                            END ELSE
                                                ERROR(Text0004, BalanceLineElement."BS Line No.", BalanceLineElement."BS Batch Name",
                                                               BalanceLineElement."Source Code", BalanceLineElement."Profit & Loss Name");
                                        END;
                                END;
                            UNTIL BalanceLineElement.NEXT = 0;

                            IF (BalanceLine."Set Zero" = BalanceLine."Set Zero"::"When negative amount") THEN BEGIN
                                IF BalanceLine.Balance < 0 THEN
                                    BalanceLine.Balance := 0;
                                IF BalanceLine."Comparison Balance" < 0 THEN
                                    BalanceLine."Comparison Balance" := 0;

                            END;
                            IF (BalanceLine."Set Zero" = BalanceLine."Set Zero"::"When positive amount") THEN BEGIN
                                IF BalanceLine.Balance > 0 THEN
                                    BalanceLine.Balance := 0;
                                IF BalanceLine."Comparison Balance" > 0 THEN
                                    BalanceLine."Comparison Balance" := 0;

                            END;

                            BalanceLine.MODIFY;

                        END;
                    END;
                UNTIL BalanceLine.NEXT = 0;
        END;
    END;
}