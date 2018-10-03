XIncludeFile "einlesen_Header.pb"
XIncludeFile "einstellungen.pb"

Procedure HOeffnen()
  Protected file.s
  Protected zeilen.i
  
  file.s = OpenFileRequester(".H Datei öffnen", "", "Heidenhain Datei|*.H;*.h", 0)
  If file.s = ""
    Debug "Auswahl abgebrochen"
    ProcedureReturn 0   
  EndIf
  
  zeilen.i = ReadFile(#PB_Any, file.s)
  
  If zeilen.i = 0
    Debug "Datei konnte nicht geladen werden"
    ProcedureReturn 0  
  EndIf
  
  HEinlesen(zeilen.i)
EndProcedure

Procedure TOeffnen()
  Protected file.s
  Protected zeilen.i
  
  file.s = OpenFileRequester(".T Datei öffnen", "", "TOOL Datei|*.T;*.t;*.txt;*.TXT", 0)
  If file.s = ""
    Debug "Auswahl abgebrochen"
    ProcedureReturn 0   
  EndIf
  
  zeilen.i = ReadFile(#PB_Any, file.s)
  
  If zeilen.i = 0
    Debug "Datei konnte nicht geladen werden"
    ProcedureReturn 0  
  EndIf
  
  TEinlesen(zeilen.i)
EndProcedure

Procedure HEinlesen(datei.i)
  Protected linie.s
  ClearList(Werte())
  PosNr.d = 0
  PosName.d = 0
  PosTime1.d = 0
  PosCurTime.d = 0
  
  If datei.i <> #False
    Repeat
      linie.s = ReadString(datei.i, ReadStringFormat(datei.i))  
      HEinlesen_logik(linie.s)
    Until Eof(datei.i)
    CloseFile(datei.i)
  ElseIf datei.i = #False; Eingabe über EditorGadget
    For I = 0 To CountGadgetItems(#GUI_TOOLWINDOW_TEXTAREA)
      linie.s = GetGadgetItemText(#GUI_TOOLWINDOW_TEXTAREA, I)
      HEinlesen_logik(linie.s)
    Next
  EndIf
  
  HWerteSortieren()
  AddWerteToListIconGadget()
EndProcedure

Procedure TEinlesen(datei.i)
  Protected linie.s
  ClearList(TWerte())
  
  If datei.i <> #False
    Repeat
      linie.s = ReadString(datei.i, ReadStringFormat(datei.i))  
      TEinlesen_logik(linie.s)
    Until Eof(datei.i)
    CloseFile(datei.i)
  ElseIf datei.i = #False; Eingabe über EditorGadget
    For I = 0 To CountGadgetItems(#GUI_TOOLWINDOW_TEXTAREA)
      linie.s = GetGadgetItemText(#GUI_TOOLWINDOW_TEXTAREA, I)
      TEinlesen_logik(linie.s)
    Next
  EndIf
  AddWerteToListIconGadget()
EndProcedure

Procedure TEinlesen_logik(linie.s)
  
  If PosNr.d <> 0 And PosName.d <> 0 And PosTime1 <> 0 And PosCurTime <> 0 And PosLastUse <> 0
    If Trim(linie.s) <> "[End]" Or Trim(linie.s) = ""
      AddElement(TWerte())
      TWerte()\Nr = Mid(linie.s, PosNr, FindString(linie.s, " ", PosNr) - PosNr)
      TWerte()\Wz = Mid(linie.s, PosName, FindString(linie.s, " ", PosName) - PosName)
      TWerte()\Time1 = Mid(linie.s, PosTime1, FindString(linie.s, " ", PosTime1) - PosTime1)
      TWerte()\CurTime = Mid(linie.s, PosCurTime, FindString(linie.s, " ", PosCurTime) - PosCurTime)
      TWerte()\LastUse = ParseDate("%yyyy.%mm.%dd",Mid(linie.s, PosLastUse, FindString(linie.s, " ", PosLastUse) - PosLastUse))
      ;Debug "Mid:" + Mid(linie.s, PosLastUse, FindString(linie.s, " ", PosLastUse) - PosLastUse)
      ;Debug TWerte()\LastUse
      ;Debug TWerte()\Nr + "; " + TWerte()\Wz + "; " + TWerte()\Time1 + "; " + TWerte()\CurTime
    EndIf
    
  Else
    PosNr = FindString(linie.s, "T")
    PosName = FindString(linie.s, "NAME")
    PosTime1 = FindString(linie.s, "TIME1")
    PosCurTime = FindString(linie.s, "CUR.TIME")
    PosLastUse = FindString(linie.s, "LAST_USE")
  EndIf
  
EndProcedure

Procedure HEinlesen_logik(linie.s)
  Protected tool.s
  Protected pos.i
  
  linie.s = Trim(linie.s)
  pos.i = FindString(linie.s, " ")
  linie.s = Mid(linie.s, pos.i)
  linie.s = Trim(linie.s)
  
  pos.i = FindString(linie.s, "*")
  
  If pos.i = 1
    ;Debug "Kommentar hinzugefügt"
    AddKommentar(linie.s)
  EndIf
  
  ;TOOL CALL
  If FindString(linie.s, "TOOL CALL")
    
    
    pos.i = FindString(linie.s, "TOOL CALL")
    tool.s = Mid(linie.s, pos.i + 9)
    tool.s = Trim(tool.s)
    tool.s = Left(tool.s, FindString(tool.s, " ")-1)
    ;Debug tool.s
    If tool.s <> "Z" And Left(tool.s, 1) <> "F" And Left(tool.s, 1) <> "S" And Left(tool.s, 2) <> "DR" And Left(tool.s, 2) <> "DL"
      
      AddTool(tool.s)
    EndIf
    
  EndIf
EndProcedure

Procedure AddKommentar(komm.s)
  
  AddElement(Werte())
  Werte()\komm = komm.s
  Werte()\id = WzIdZwischenspeicher.s
EndProcedure

Procedure AddWerteToListIconGadget()
  ClearGadgetItems(#GUI_WINDOW_LISTICONGADGET)
  
  ForEach WerteSortiert()   
    AddGadgetItem(#GUI_WINDOW_LISTICONGADGET, -1, WerteSortiert()\tool + Chr(10) + WerteSortiert()\komm + Chr(10) + GetTWert(#Wz, WerteSortiert()\tool)  + Chr(10) + GetTWert(#Time1, WerteSortiert()\tool) + Chr(10) + GetTWert(#CurTime, WerteSortiert()\tool) + Chr(10) + GetTWert(#LastUse, WerteSortiert()\tool))
  Next
  
EndProcedure

Procedure AddTool(tool.s)
  ;Declare *LastElement
  
  If ListSize(Werte()) <> 0
    LastElement(Werte())
    Werte()\tool = tool.s
    Werte()\id = tool.s
    WzIdZwischenspeicher.s = tool.s
  Else
    AddElement(Werte())
    Werte()\tool = tool.s
    Werte()\id = tool.s
    WzIdZwischenspeicher.s = tool.s
  EndIf
  
EndProcedure

Procedure.s GetTWert(Wert.i, Nr.s)
  Protected zwert.s
  Protected zeit.i
  
  ForEach TWerte()
    If Nr.s = TWerte()\Nr
      Select Wert.i
        Case #Wz
          ProcedureReturn TWerte()\Wz
        Case #Time1
          ProcedureReturn TWerte()\Time1
        Case #CurTime
          ProcedureReturn TWerte()\CurTime
        Case #LastUse
          zwert.s = FormatDate("%dd.%mm.%yyyy",TWerte()\LastUse)
          
          If zwert.s = "00.00.0000"
            ProcedureReturn ""
          Else
            zeit.i = (Date() - Date(Year(TWerte()\LastUse), Month(TWerte()\LastUse), Day(TWerte()\LastUse), 0, 0, 0)) / (3600*24)
            ProcedureReturn zwert.s + " - (" + Str(zeit.i) + " Tage)"
          EndIf
          
      EndSelect
      
    EndIf
  Next
  
  ProcedureReturn ""
EndProcedure

Procedure HWerteSortieren()
  Protected NewList ZwischenSpeicher.komm()
  Protected *first.komm
  Protected *zwischenS.komm
  Protected ztool.s, zkommentar.s
  
  CopyList(Werte(), WerteSortiert())
    
  If AnsichtVerstecken = #True
    
    ForEach WerteSortiert()
      If WerteSortiert()\tool = ""
        DeleteElement(WerteSortiert())
      EndIf
      
    Next
  EndIf
  
  If AnsichtSortieren = #True
    ForEach WerteSortiert()
      WerteSortiert()\idDouble = Val(WerteSortiert()\id)
    Next
    
    SortStructuredList(WerteSortiert(), #PB_Sort_Ascending, OffsetOf(komm\idDouble), TypeOf(komm\idDouble))
  EndIf
  
  If AnsichtDoppelt = #True
    
    While ListSize(WerteSortiert()) > 0      
      *first = FirstElement(WerteSortiert())
      
      ;Wenn das Element keinem Werkzeug zugeordnet ist wird es einfach kopiert.
      If WerteSortiert()\tool = ""
        *zwischenS = AddElement(ZwischenSpeicher())
        *zwischenS\tool = *first\tool
        *zwischenS\id = *first\id
        *zwischenS\idDouble = *first\idDouble
        *zwischenS\komm = *first\komm
        
        DeleteElement(WerteSortiert())
      ; Das Element wird kopiert und nach weiteren Einträgen mit dieser Werkzeugnummer gesucht.
      Else
        ztool.s = *first\tool; Das zu suchende Werkzeug
        zkommentar.s = *first\komm
        *zwischenS = AddElement(ZwischenSpeicher())
        *zwischenS\tool = *first\tool
        *zwischenS\id = *first\id
        *zwischenS\idDouble = *first\idDouble
        *zwischenS\komm = *first\komm
        
        DeleteElement(WerteSortiert(), 1)
        
        ForEach WerteSortiert()
          If ztool = WerteSortiert()\tool; Dem Eintrag ist ein Werkzeug zugeordnet
            If LCase(*zwischenS\komm) = LCase(zkommentar.s)
              DeleteElement(WerteSortiert())
            Else
              *zwischenS\komm = *zwischenS\komm + " ; " + WerteSortiert()\komm
              DeleteElement(WerteSortiert())
            EndIf
            
          ElseIf ztool = WerteSortiert()\id; einfacher Kommentar
            AddElement(ZwischenSpeicher())
            ZwischenSpeicher()\tool = WerteSortiert()\tool
            ZwischenSpeicher()\id = WerteSortiert()\id
            ZwischenSpeicher()\idDouble = WerteSortiert()\idDouble
            ZwischenSpeicher()\komm = WerteSortiert()\komm
        
            DeleteElement(WerteSortiert(), 1)
          EndIf
          
        Next
        
      EndIf
      
    Wend
    CopyList(ZwischenSpeicher(), WerteSortiert())
  EndIf
  
EndProcedure



; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 270
; FirstLine = 181
; Folding = z4
; EnableXP