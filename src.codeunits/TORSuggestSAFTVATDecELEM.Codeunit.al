codeunit 50460 "TOR SuggestSAFTVATDecElem"
{
    TableNo = "ITI SAF-T VAT Header";
    trigger OnRun()
    begin
        SAFTVATElementCalcLibrary.InitTempSAFTVATLine(Rec, TempSAFTVATLine);
        SuggestElementP_51(Rec);
        SuggestElementP_53(Rec);
        SuggestElementP_62(Rec);
        //SuggestElementP_68(Rec);
        //SuggestElementP_69(Rec);
        FinalizeProcess(Rec);
    end;

    var
        TempSAFTVATLine: Record "ITI SAF-T VAT Line" temporary;
        SAFTVATElementCalcLibrary: Codeunit "ITI SAFTVATElementCalcLibrary";
        SuggestionFinishedMsg: Label 'Declaration''s Elements Suggestion for SAF-T VAT for period: %1 - %2 (%3) has been finished.';

    local procedure SuggestElementP_51(SAFTVATHeader: Record "ITI SAF-T VAT Header");
    begin
        // <xsd:element name="P_51" type="etd:TKwotaCNieujemna">
        // <xsd:annotation>
        // <xsd:documentation>Wysokość podatku podlegająca wpłacie do urzędu skarbowego</xsd:documentation>
        // </xsd:annotation>
        // <!--Jeżeli różnica kwot pomiędzy P_38 i P_48 jest większa od 0, wówczas P_51 = P_38 - P_48 - P_49 - P_50, w przeciwnym wypadku należy wykazać 0.-->
        if SAFTVATHeader."Declaration Required" then
            if SAFTVATElementCalcLibrary.CheckifGreaterThanElement(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Declaration", 'P_38', TempSAFTVATLine.Type::"VAT Declaration", 'P_48') then
                EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_51',
                  SAFTVATElementCalcLibrary.CalculateMathOperation(TempSAFTVATLine, 'P_38 - P_48 - P_49 - P_50', TempSAFTVATLine.Type::"VAT Declaration"))
            else
                EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_51', 0);
    end;

    local procedure SuggestElementP_53(SAFTVATHeader: Record "ITI SAF-T VAT Header");
    begin
        // <xsd:element name="P_53" type="etd:TKwotaCNieujemna" minOccurs="0">
        // <xsd:annotation>
        // <xsd:documentation>Wysokość nadwyżki podatku naliczonego nad należnym</xsd:documentation>
        // </xsd:annotation>
        // <!--Jeżeli P_51 > 0 to P_53 = 0 w przeciwnym wypadku jeżeli (P_48 + P_49 + P_50  + P_52) – P_38 >  0 to P_53 = P_48 - P_38 + P_49 + P_50  + P_52 w pozostałych przypadkach P_53 = 0.-->
        // </xsd:element>
        if SAFTVATHeader."Declaration Required" then
            if SAFTVATElementCalcLibrary.CheckIfGreaterThanZero(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Declaration", 'P_51') then
                EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_53', 0)
            else begin
                EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_53', SAFTVATElementCalcLibrary.CalculateMathOperation(TempSAFTVATLine, 'P_48 - P_38 + P_49 + P_50 + P_52', TempSAFTVATLine.Type::"VAT Declaration"));
                if SAFTVATElementCalcLibrary.CheckIfSmallerThanZero(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Declaration", 'P_53') then
                    EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_53', 0);
            end;
    end;

    local procedure SuggestElementP_62(SAFTVATHeader: Record "ITI SAF-T VAT Header");
    begin
        // <xsd:element name="P_62" type="etd:TKwotaCNieujemna" minOccurs="0">
        // <xsd:annotation>
        // <xsd:documentation>Wysokość nadwyżki podatku naliczonego nad należnym do przeniesienia na następny okres rozliczeniowy</xsd:documentation>
        // </xsd:annotation>
        // <!--Od kwoty wykazanej w P_53 należy odjąć kwotę z P_54.-->
        // </xsd:element>
        if SAFTVATHeader."Declaration Required" then
            EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_62',
                SAFTVATElementCalcLibrary.CalculateMathOperation(TempSAFTVATLine, 'P_53 - P_54', TempSAFTVATLine.Type::"VAT Declaration"));
    end;

    local procedure SuggestElementP_68(SAFTVATHeader: Record "ITI SAF-T VAT Header");
    begin
        // <xsd:sequence minOccurs="0">
        // <xsd:element name="P_68">
        // <xsd:annotation>
        // <xsd:documentation>Wysoko˜† korekty podstawy opodatkowania, o kt¢rej mowa w art. 89a ust. 1 ustawy</xsd:documentation>
        // </xsd:annotation>
        // <xsd:simpleType>
        // <xsd:restriction base="etd:TKwotaC">
        // <xsd:maxInclusive value="0"/>
        // </xsd:restriction>
        // </xsd:simpleType>
        // </xsd:element>
        if SAFTVATHeader."Declaration Required" then
            if SAFTVATElementCalcLibrary.CheckIfSmallerThanZero(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Sales and Purchase", 'P_68') then
                EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_68',
                       SAFTVATElementCalcLibrary.GetSAFTVATLineCalcDetailAmount(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Sales and Purchase", 'P_68'))
    end;

    local procedure SuggestElementP_69(SAFTVATHeader: Record "ITI SAF-T VAT Header");
    begin
        // <xsd:element name="P_69">
        // <xsd:annotation>
        // <xsd:documentation>Wysoko˜† korekty podatku nale¾nego, o kt¢rej mowa w art. 89a ust. 1 ustawy</xsd:documentation>
        // </xsd:annotation>
        // <xsd:simpleType>
        // <xsd:restriction base="etd:TKwotaC">
        // <xsd:maxInclusive value="0"/>
        // </xsd:restriction>
        // </xsd:simpleType>
        // </xsd:element>
        // </xsd:sequence>
        if SAFTVATHeader."Declaration Required" then
            IF SAFTVATElementCalcLibrary.CheckIfSmallerThanZero(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Sales and Purchase", 'P_69') then
                EvaluateValueToElement(SAFTVATHeader."Record ID", 'P_69',
                       SAFTVATElementCalcLibrary.GetSAFTVATLineCalcDetailAmount(TempSAFTVATLine, TempSAFTVATLine.Type::"VAT Sales and Purchase", 'P_69'))
    end;

    local procedure EvaluateValueToElement(SAFTVATHeaderID: Integer; ElementName: Text[10]; Value: Decimal);
    var
        SAFTVATLine: Record "ITI SAF-T VAT Line";
        EvaluateSAFTElementValue: Codeunit "ITI Evaluate SAF-T El. Value";
        UpdateSAFTVATLineCalcDetail: Codeunit "ITIUpdateSAFTVATLineCalcDetail";
        TextValue: Text[250];
    begin
        TextValue := Format(Value);
        SAFTVATLine.SetRange("SAF-T VAT Header Record ID", SAFTVATHeaderID);
        SAFTVATLine.SetRange(Type, SAFTVATLine.Type::"VAT Declaration");
        SAFTVATLine.SetRange("Element Name", ElementName);
        if SAFTVATLine.FindFirst() then begin
            EvaluateSAFTElementValue.EvaluateAndFormatElementToTextWithCheck(SAFTVATLine."Version Code", ElementName, TextValue, SAFTVATLine.Value, Value);
            UpdateSAFTVATLineCalcDetail.DeleteAndInsertNewSAFTVATLineCalcDetail(SAFTVATLine, Value);
            SAFTVATLine.Modify();
        end;
    end;

    local procedure FinalizeProcess(SAFTVATHeader: Record "ITI SAF-T VAT Header");
    begin
        Message(SuggestionFinishedMsg, SAFTVATHeader."Starting Date", SAFTVATHeader."ending Date", SAFTVATHeader."Submission Purpose");
    end;


}
