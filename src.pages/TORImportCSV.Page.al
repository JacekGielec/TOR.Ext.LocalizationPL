// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

/// <summary>
/// Page CSV Buffer (ID 50100).
/// </summary>
page 50498 "TOR CSV Buffer"
{
    ApplicationArea = all;
    Caption = 'TOR Import from CSV file';
    PageType = List;
    SourceTable = "CSV Buffer";
    SourceTableTemporary = true;
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = all;
                }
                field(Value; Rec.Value)
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
            action("Payroll Import 231-1")
            {
                Caption = 'Payroll Import 231-1';
                Image = Import;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    PayrollSetup();
                    if UploadIntoStream('CSV File', '', '', FileName, InS) then begin
                        Rec.LoadDataFromStream(InS, ';');
                        PayrollImport(4, '404-1-01', '231-1', '');
                        PayrollImport(5, '404-1-02', '231-1', 'Wynagrodzenie za czas choroby');
                        PayrollImport(6, '234-1', '231-1', '');
                        PayrollImport(6, '231-1', '234-1', '');
                    end;
                end;
            }
            action("Payroll Import 221-1")
            {
                Caption = 'Payroll Import 221-1';
                Image = Import;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    PayrollSetup();
                    if UploadIntoStream('CSV File', '', '', FileName, InS) then begin
                        Rec.LoadDataFromStream(InS, ';');
                        PayrollImport(13, '405-1-01', '221-1', '');
                    end;
                end;

            }
            action("Payroll Import 221-2")
            {
                Caption = 'Payroll Import 221-2';
                Image = Import;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    PayrollSetup();
                    if UploadIntoStream('CSV File', '', '', FileName, InS) then begin
                        Rec.LoadDataFromStream(InS, ';');
                        PayrollImport(14, '405-1-02', '221-2', '');
                    end;
                end;
            }

            action("Payroll Import PIT-4")
            {
                Caption = 'Payroll Import PIT-4';
                Image = Import;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    PayrollSetup();
                    if UploadIntoStream('CSV File', '', '', FileName, InS) then begin
                        Rec.LoadDataFromStream(InS, ';');
                        PayrollImport(25, '', '850-0', 'ZFŚS');
                        PayrollImport(27, '', '249-03', 'Zobowiązania');
                        PayrollImport(31, '', '249-01', 'Ubezpieczenia');

                        PayrollImport(15, '231-1', '', '');
                        PayrollImport(16, '231-1', '', '');
                        PayrollImport(17, '231-1', '', '');
                        PayrollImport(19, '231-1', '', '');
                        PayrollImport(21, '231-1', '', '');
                        PayrollImport(22, '231-1', '', '');
                        PayrollImport(24, '231-1', '', '');
                        PayrollImport(25, '231-1', '', '');
                        //PayrollImport(26, '231-1', '', '');
                        PayrollImport(27, '231-1', '', '');
                        PayrollImport(30, '231-1', '', '');
                        PayrollImport(31, '231-1', '', '');

                        PayrollImport(22, '', '221-2', 'PPK');
                        PayrollImport(20, '', '221-1', 'ZUS');
                        PayrollImport(21, '', '220-02', 'PIT-4');

                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Value := Rec.Value.TrimEnd('"').TrimStart('"');
    end;

    var
        LineNo: Integer;
        GenJnlLnie: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlTemplate: Record "Gen. Journal Template";

        DimVal: Record "Dimension Value";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        InS: Instream;
        DocNo: Text;
        v: Text;
        Dim1: code[20];
        FileName: Text;
        k, i : Integer;
        d: Decimal;

    local procedure PayrollSetup()
    begin
        Rec.Reset();
        Rec.DeleteAll();


        //wynagrodzenie ze stosunku pracy
        GenJnlBatch.SetRange(name, 'PK-W');
        if not GenJnlBatch.FindFirst() then
            Error('Brak instancji dziennika PK-W');

        LineNo := 0;
        //Rec.SetRange("Field No.", 1);
        //rec.SetFilter(Value, '<>%1', '');
        //rec.SetRange("Line No.", 7, 500);
        GenJnlLnie.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
        GenJnlLnie.SetRange("Journal Batch Name", GenJnlBatch.Name);
        GenJnlLnie.DeleteAll();
        docno := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WorkDate(), true);
    end;

    local procedure PayrollImport(ColNo: Integer; AccNo: code[20]; BalAccNo: Code[20]; Desc: Text[100])
    var
        dt: Boolean;
        ct: Boolean;
    begin
        if Rec.FindSet() then
            repeat
                dim1 := GetCol(1);
                if DimVal.Get('CC', dim1) then begin
                    v := GetCol(ColNo);

                    if (v <> '') and (dim1 <> '') then begin
                        lineno += 10000;
                        GenJnlLnie.Init();
                        GenJnlLnie.validate("Journal Template Name", GenJnlBatch."Journal Template Name");
                        GenJnlLnie.validate("Journal Batch Name", GenJnlBatch.Name);
                        GenJnlLnie."Line No." := LineNo;
                        GenJnlLnie.Validate("Posting Date", WorkDate());
                        GenJnlLnie."Document No." := DocNo;
                        GenJnlLnie."Posting No. Series" := GenJnlBatch."Posting No. Series";
                        if (accno <> '') and (balaccno <> '') then begin
                            GenJnlLnie.Validate("Account No.", AccNo);
                            GenJnlLnie."Bal. Account No." := BalAccNo;
                            dt := true;
                            ct := false;
                        end else begin
                            if accno <> '' then begin
                                GenJnlLnie.Validate("Account No.", AccNo);
                                dt := true;
                                ct := false;
                            end else begin
                                if BalAccNo <> '' then begin
                                    GenJnlLnie.Validate("Account No.", balAccNo);
                                    dt := false;
                                    ct := true;
                                end;
                            end;
                        end;
                        GenJnlLnie.Validate("Gen. Prod. Posting Group", '');
                        if Desc = '' then
                            GenJnlLnie.Description := 'Wynagrodzenie'
                        else
                            GenJnlLnie.Description := Desc;

                        Evaluate(d, v);
                        if ct then
                            d *= -1;

                        d := Round(d);
                        if d <> 0 then begin
                            GenJnlLnie.Validate(amount, d);
                            if Dim1 <> '' then
                                GenJnlLnie.Validate("Shortcut Dimension 1 Code", Dim1);

                            GenJnlLnie.insert;
                        end;
                    end;
                end;
            until rec.Next() = 0;
    end;


    local procedure GetCol(ColNo: Integer): Text
    begin
        Rec.SetRange("Field No.", colno);
        if rec.get(rec."Line No.", ColNo) then
            exit(Rec.Value.TrimEnd('"').TrimStart('"'));

    end;


}