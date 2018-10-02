XIncludeFile "print_Header.pb"
XIncludeFile "einlesen.pb"
XIncludeFile "einstellungen.pb"

Procedure PrintDefault()
  Protected printer.i
  
  printer = DefaultPrinter()
  
  If printer <> 0
    StartPrint()
  Else
    MessageRequester("Fehler", "Drucker nicht gefunden", #PB_MessageRequester_Error)
  EndIf
  
EndProcedure

Procedure PrintPref()
  Protected printer.i
  
  printer.i = PrintRequester()
  
  If printer.i <> 0
    StartPrint()
  EndIf
  
  
EndProcedure


Procedure StartPrint()
  Protected breite.d
  Protected hoehe.d
  Protected breiteText.d
  Protected BreiteTextBox.d
  Protected hoeheText.d
  Protected AktuelleHoehe.d = 0
  
  Protected ParagraphHoehe.d
  Protected ParagraphHoehe1.d
  Protected ParagraphHoehe2.d
  If LoadFont(#Fond1, Schriftart, Schriftgroesse) = #False
    MessageRequester("Fehler", "Konnte Font nicht Laden", #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
  
  StartPrinting("WZ-Liste")
  
  StartVectorDrawing(PrinterVectorOutput(#PB_Unit_Pixel))
  
  VectorFont(FontID(#Fond1))
  VectorSourceColor(RGBA(0,0,0,255))
  
  breite.d = VectorOutputWidth()
  hoehe.d = VectorOutputHeight()
  Debug breite.d
  Debug hoehe.d
  
  breiteText.d = VectorTextWidth("0000", #PB_VectorText_Visible)
  hoeheText.d = VectorTextHeight("0gM*", #PB_VectorText_Visible)
  BreiteTextBox.d = (breite.d - (breiteText.d * 3)) / 2
  ;breiteText.d = breiteText.d + (breiteText.d / 3)
  ;hoeheText.d = hoeheText.d + (hoeheText.d / 3)
  
  ; Überschrift
  AddPathBox(0, AktuelleHoehe.d, breite.d, hoeheText.d)
  VectorSourceColor(RGBA(100,100,100,255))
  FillPath()
  
  VectorSourceColor(RGBA(0,0,0,255))
  AddPathBox(0, AktuelleHoehe.d, breiteText.d, hoeheText.d)
  AddPathBox(breiteText.d, AktuelleHoehe.d, BreiteTextBox.d, hoeheText.d)
  AddPathBox(breiteText + BreiteTextBox, AktuelleHoehe, BreiteTextBox, hoeheText)
  AddPathBox(breiteText + BreiteTextBox * 2, AktuelleHoehe, breiteText, hoeheText)
  AddPathBox(breiteText * 2 + BreiteTextBox * 2, AktuelleHoehe, breiteText, hoeheText)
  MovePathCursor(0, AktuelleHoehe.d)
  DrawVectorParagraph("T", breiteText.d, hoeheText.d, #PB_VectorParagraph_Center)
  
  MovePathCursor(breiteText.d, AktuelleHoehe.d)
  DrawVectorParagraph("Kommentar", BreiteTextBox, hoeheText.d, #PB_VectorParagraph_Center) 
  
  MovePathCursor(breiteText + BreiteTextBox, AktuelleHoehe.d)
  DrawVectorParagraph("Werkzeug", BreiteTextBox, hoeheText.d, #PB_VectorParagraph_Center) 
  
  MovePathCursor(breiteText + BreiteTextBox * 2, AktuelleHoehe.d)
  DrawVectorParagraph("T1", breiteText, hoeheText.d, #PB_VectorParagraph_Center)
  
  MovePathCursor(breiteText * 2 + BreiteTextBox * 2, AktuelleHoehe.d)
  DrawVectorParagraph("CT", breiteText, hoeheText.d, #PB_VectorParagraph_Center)
  
  StrokePath(2)
  
  AktuelleHoehe.d = AktuelleHoehe.d + hoeheText.d
  
  ForEach WerteSortiert()
    
    ParagraphHoehe1 = VectorParagraphHeight(WerteSortiert()\komm, BreiteTextBox, hoehe.d)
    ParagraphHoehe2 = VectorParagraphHeight(GetTWert(#Wz, WerteSortiert()\tool), BreiteTextBox, hoehe.d)
    
    If ParagraphHoehe1 > ParagraphHoehe2
      ParagraphHoehe = ParagraphHoehe1
    Else
      ParagraphHoehe = ParagraphHoehe2
    EndIf
    
    
    AddPathBox(0, AktuelleHoehe.d, breiteText.d, ParagraphHoehe.d)
    AddPathBox(breiteText.d, AktuelleHoehe.d, BreiteTextBox.d, ParagraphHoehe.d)
    AddPathBox(breiteText + BreiteTextBox, AktuelleHoehe, BreiteTextBox, ParagraphHoehe.d)
    AddPathBox(breiteText + BreiteTextBox * 2, AktuelleHoehe, breiteText, ParagraphHoehe.d)
    AddPathBox(breiteText * 2 + BreiteTextBox * 2, AktuelleHoehe, breiteText, ParagraphHoehe.d)
    
    MovePathCursor(0, AktuelleHoehe.d)
    DrawVectorParagraph(WerteSortiert()\tool, breiteText.d, ParagraphHoehe.d, #PB_VectorParagraph_Center)
    
    MovePathCursor(breiteText.d, AktuelleHoehe.d)
    DrawVectorParagraph(WerteSortiert()\komm, BreiteTextBox, ParagraphHoehe.d) 
    
    MovePathCursor(breiteText + BreiteTextBox, AktuelleHoehe.d)
    DrawVectorParagraph(GetTWert(#Wz, WerteSortiert()\tool), BreiteTextBox, ParagraphHoehe.d) 
    
    MovePathCursor(breiteText + BreiteTextBox * 2, AktuelleHoehe.d)
    DrawVectorParagraph(GetTWert(#Time1, WerteSortiert()\tool), breiteText, ParagraphHoehe.d, #PB_VectorParagraph_Center)
    
    MovePathCursor(breiteText * 2 + BreiteTextBox * 2, AktuelleHoehe.d)
    DrawVectorParagraph(GetTWert(#CurTime, WerteSortiert()\tool), breiteText, ParagraphHoehe.d, #PB_VectorParagraph_Center)
    
    AktuelleHoehe.d = AktuelleHoehe.d + ParagraphHoehe.d
  Next
  VectorSourceColor(RGBA(0,0,0,255))
  StrokePath(1)
  
  
  StopVectorDrawing()
  
  StopPrinting()
EndProcedure

Procedure PrintSchrift()
  Protected Ergebniss.i
  Protected DateiE.i
  
  Ergebniss = FontRequester(Schriftart, Schriftgroesse, #PB_FontRequester_Effects)
  
  If Ergebniss = #True
    ;Variablen setzen
    Schriftart = SelectedFontName()
    Schriftgroesse = SelectedFontSize()
    
    ;Speichern
    SpeichereEinstellungen()
    
    ;Anzeige ändern
    StatusBarText(#GUI_WINDOW_STATUSBAR, 1, "Schriftart: " + Schriftart)
    StatusBarText(#GUI_WINDOW_STATUSBAR, 2, "Schriftgröße: " + Schriftgroesse)
  EndIf
  
  
EndProcedure

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 132
; FirstLine = 102
; Folding = -
; EnableXP