table 50450 "TOR Check 4"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date';
        }
        field(3; "Document No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
        }
        field(4; "G/L Account No. 4"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No. 4';
        }
        field(5; "G/L Account No. 490"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No. 490';
        }
        field(6; "G/L Account No. 5"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No. 5';
        }

        field(7; "G/L Account No. 7"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No. 7';
        }

        field(8; "OK 4&5"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'OK 4&5';
        }

        field(9; "Dim MPK"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Dim MPK';
        }
        field(10; "Dim 5"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Dim 5';
        }
        field(11; "OK - 4&5"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'OK - 4&5';
        }
        field(12; "G/L Account No. 580"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No. 580';
        }
        field(13; "Circle"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Circle';
        }
        field(14; "Out Of The Circle"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Out Of The Circle';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    internal procedure InsertEntry(DocNo: code[20])
    var
        c: Boolean;
    begin
        GetCircleAccount();
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", docno);
        if GLEntry.FindSet() then
            repeat
                c := false;
                GLEntry.CalcFields("Shortcut Dimension 5 Code");
                SetFilter(DocNo);
                if FindSet() then begin
                    if GLEntry."G/L Account No." = '490-1' then begin
                        "G/L Account No. 490" += GLEntry.Amount;
                        c := true;
                    end else
                        if CopyStr(GLEntry."G/L Account No.", 1, 1) = '4' then begin
                            "G/L Account No. 4" += GLEntry.Amount;
                            c := false;
                        end else
                            if CopyStr(GLEntry."G/L Account No.", 1, 3) = '580' then begin
                                "G/L Account No. 580" += GLEntry.Amount;
                                c := false;
                            end else
                                if CopyStr(GLEntry."G/L Account No.", 1, 1) = '5' then begin
                                    "G/L Account No. 5" += GLEntry.Amount;
                                    c := true;
                                end else
                                    if CopyStr(GLEntry."G/L Account No.", 1, 1) = '7' then begin
                                        "G/L Account No. 7" += GLEntry.Amount;
                                        c := true;
                                    end else
                                        if CopyStr(GLEntry."G/L Account No.", 1, 1) = '6' then
                                            c := true;

                    if (abs("G/L Account No. 4") = Abs("G/L Account No. 490")) and
                   (abs("G/L Account No. 4") = abs("G/L Account No. 5" + "G/L Account No. 7" + "G/L Account No. 580")) then
                        "OK - 4&5" := true
                    else
                        "OK - 4&5" := false;
                    Modify();
                end else begin
                    init;

                    "Dim 5" := GLEntry."Shortcut Dimension 5 Code";
                    "Dim MPK" := GLEntry."Global Dimension 1 Code";
                    "Document No." := GLEntry."Document No.";
                    "Entry No." := GLEntry."Entry No.";
                    "Posting Date" := GLEntry."Posting Date";

                    if GLEntry."G/L Account No." = '490-1' then begin
                        "G/L Account No. 490" := GLEntry.Amount;
                        c := true;
                    end else
                        if CopyStr(GLEntry."G/L Account No.", 1, 1) = '4' then begin
                            "G/L Account No. 4" := GLEntry.Amount;
                            c := false;
                        end else
                            if CopyStr(GLEntry."G/L Account No.", 1, 3) = '580' then begin
                                "G/L Account No. 580" := GLEntry.Amount;
                                c := false;
                            end else
                                if CopyStr(GLEntry."G/L Account No.", 1, 1) = '5' then begin
                                    "G/L Account No. 5" := GLEntry.Amount;
                                    c := true;
                                end else
                                    if CopyStr(GLEntry."G/L Account No.", 1, 1) = '7' then begin
                                        "G/L Account No. 7" := GLEntry.Amount;
                                        c := true;
                                    end else
                                        if CopyStr(GLEntry."G/L Account No.", 1, 1) = '6' then
                                            c := true;

                    if (abs("G/L Account No. 4") = Abs("G/L Account No. 490")) and
                    (abs("G/L Account No. 4") = abs("G/L Account No. 5" + "G/L Account No. 7" + "G/L Account No. 580")) then
                        "OK - 4&5" := true;
                    Insert();
                end;

                //circle
                if c then
                    if GLCircleAccount.Get(GLEntry."G/L Account No.") then
                        Circle += GLEntry.Amount
                    else
                        "Out Of The Circle" += glentry.amount;
                modify;
            until GLEntry.Next() = 0;

        Reset();
        if FindFirst() then
            repeat
                if ("G/L Account No. 4" = 0) and
                ("G/L Account No. 490" = 0) and
                ("G/L Account No. 5" = 0) and
                ("G/L Account No. 7" = 0)
                then
                    Mark(true);
            until Next() = 0;
        MarkedOnly := true;
        DeleteAll();
        Reset();
    end;

    local procedure SetFilter(DocNo: code[20])
    begin
        SetRange("Document No.", DocNo);
        Setrange("Posting Date", GLEntry."Posting Date");

        SetRange("Dim MPK", GLEntry."Global Dimension 1 Code");
        SetRange("Dim 5", GLEntry."Shortcut Dimension 5 Code");
    end;

    local procedure GetCircleAccount()
    var
        AccScheduleLine: Record "Acc. Schedule Line";
        GLAcc: Record "G/L Account";
    begin
        AccScheduleLine.SetRange("Schedule Name", 'ZMIANASTAN');
        AccScheduleLine.SetRange("Totaling Type", AccScheduleLine."Totaling Type"::"Posting Accounts");
        if AccScheduleLine.FindFirst() then
            repeat
                if AccScheduleLine.Totaling <> '' then begin
                    GLAcc.SetFilter("No.", AccScheduleLine.Totaling);
                    if GLAcc.FindFirst() then
                        repeat
                            if not GLCircleAccount.Get(GLAcc."No.") then begin
                                GLCircleAccount."No." := GLAcc."No.";
                                GLCircleAccount.Insert();
                            end;
                        until GLAcc.Next() = 0;
                end;
            until AccScheduleLine.Next() = 0;
    end;

    local procedure CheckSales():Boolean
    var
    ver:Record "Value Entry Relation";
    begin

    end;

    var
        GLCircleAccount: Record "G/L Account" temporary;
        GLEntry: Record "G/L Entry";
}