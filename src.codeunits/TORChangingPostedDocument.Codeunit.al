#pragma warning disable DOC0101
/// <summary>
/// Codeunit TOR Changing Posted Document (ID 50455).
/// </summary>
codeunit 50455 "TOR Changing Posted Document"
#pragma warning restore DOC0101
{
    Permissions =
        tabledata "Sales Invoice Header" = m,
        tabledata "Sales Cr.Memo Header" = m,
        tabledata "Cust. Ledger Entry" = m,
        tabledata "Value Entry" = m;

    trigger OnRun()
    begin
    end;

    /// <summary>
    /// ChangeSalesPersonOnPostedSalesInvoice.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Invoice Header".</param>
    procedure ChangeSalesPersonOnPostedSalesInvoice(var Rec: Record "Sales Invoice Header")
    var
        FilterPageBuilder: FilterPageBuilder;
        Salesperson: Record "Salesperson/Purchaser";
        VE: Record "Value Entry";
        CLE: Record "Cust. Ledger Entry";
        SalespersonName: Text[100];

        ERRTxt01: Label 'You need to specify the salesperson';
        ERRTxt02: Label 'Salesperson change aborted';
        DIALOGTXT1: Label 'Are you sure you want to change the salesperson for the document %1';
        DIALOGTXT2: Label 'For document %1, the salesperson has been changed from (%2) to (%3)';
        DIALOGTXT3: Label 'Salesperson code %1 does not exist in the Salesperson table';
    begin
        if not Dialog.Confirm(DIALOGTXT1, false, Rec."No.") then
            error(ERRTxt02);

        if Salesperson.Get(Rec."Salesperson Code") then
            SalespersonName := Salesperson.Name
        else
            SalespersonName := '';

        FilterPageBuilder.AddRecord('Salesperson Table', Salesperson);
        FilterPagebuilder.Addfield('Salesperson Table', Salesperson.Code, Rec."Salesperson Code");
        FilterPageBuilder.PageCaption := 'Salesperson Filter Page';
        FilterPagebuilder.RunModal;
        Salesperson.SetView(FilterPagebuilder.Getview('Salesperson Table'));
        if Salesperson.GetFilter(Code) = '' then
            error(ERRTxt01);

        if Salesperson.FindFirst() then begin
            Rec."Salesperson Code" := Salesperson.Code;
            Rec.Modify();

            ve.SetCurrentKey("Document No.");
            ve.SetRange("Document No.", Rec."No.");
            if ve.FindSet() then
                repeat
                    ve."Salespers./Purch. Code" := Salesperson.Code;
                    ve.Modify();
                until ve.Next() = 0;

            cle.SetRange("Document No.", Rec."No.");
            cle.ModifyAll("Salesperson Code", Salesperson.Code);
            Dialog.Message(DIALOGTXT2, Rec."No.", SalespersonName, Salesperson.Name);
        end else
            Dialog.Error(DIALOGTXT3, Salesperson.GetFilter(Code));

    end;

    internal procedure ChangeSalesPersonOnPostedCreditMemo(Rec: Record "Sales Cr.Memo Header")
    var
        FilterPageBuilder: FilterPageBuilder;
        Salesperson: Record "Salesperson/Purchaser";
        VE: Record "Value Entry";
        CLE: Record "Cust. Ledger Entry";
        SalespersonName: Text[100];

        ERRTxt01: Label 'You need to specify the salesperson';
        ERRTxt02: Label 'Salesperson change aborted';
        DIALOGTXT1: Label 'Are you sure you want to change the salesperson for the document %1';
        DIALOGTXT2: Label 'For document %1, the salesperson has been changed from (%2) to (%3)';
        DIALOGTXT3: Label 'Salesperson code %1 does not exist in the Salesperson table';
    begin
        if not Dialog.Confirm(DIALOGTXT1, false, Rec."No.") then
            error(ERRTxt02);

        if Salesperson.Get(Rec."Salesperson Code") then
            SalespersonName := Salesperson.Name
        else
            SalespersonName := '';

        FilterPageBuilder.AddRecord('Salesperson Table', Salesperson);
        FilterPagebuilder.Addfield('Salesperson Table', Salesperson.Code, Rec."Salesperson Code");
        FilterPageBuilder.PageCaption := 'Salesperson Filter Page';
        FilterPagebuilder.RunModal;
        Salesperson.SetView(FilterPagebuilder.Getview('Salesperson Table'));
        if Salesperson.GetFilter(Code) = '' then
            error(ERRTxt01);

        if Salesperson.FindFirst() then begin
            Rec."Salesperson Code" := Salesperson.Code;
            Rec.Modify();

            ve.SetCurrentKey("Document No.");
            ve.SetRange("Document No.", Rec."No.");
            if ve.FindSet() then
                repeat
                    ve."Salespers./Purch. Code" := Salesperson.Code;
                    ve.Modify();
                until ve.Next() = 0;

            cle.SetRange("Document No.", Rec."No.");
            cle.ModifyAll("Salesperson Code", Salesperson.Code);

            Dialog.Message(DIALOGTXT2, Rec."No.", SalespersonName, Salesperson.Name);
        end else
            Dialog.Error(DIALOGTXT3, Salesperson.GetFilter(Code));

    end;

    internal procedure ChangeConfirmationDate(SalesCrMemo: Record "Sales Cr.Memo Header")
    var
        VATEntry: Record "VAT Entry";
        VATEntry2: Record "VAT Entry";
        VATManagement: Codeunit "ITI VATManagement";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin

        VATEntry.SetRange("Document No.", SalesCrMemo."No.");
        if VATEntry.FindSet(false) then begin
            if VATEntry."ITI Postponed VAT" then begin
                VATManagement.RealizeVATEntry(VATEntry, true, 0D);
            end else begin
                VATManagement.ChangeVATDate(VATEntry);
            end;
        end;

        //Commit();

        SalesCrMemoHeader.Get(VATEntry."Document No.");
        if SalesCrMemoHeader."ITI Postponed VAT Realized" then begin
            SalesCrMemoHeader."Confirmation Date" := SalesCrMemoHeader."ITI VAT Settlement Date";
            SalesCrMemoHeader.Confirmed := true;
            SalesCrMemoHeader.Modify();
        end;

    end;
}
