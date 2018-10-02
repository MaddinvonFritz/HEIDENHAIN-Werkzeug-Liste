XIncludeFile "einstellungen_header.pb"

Procedure LadeEinstellungen()
  Protected DateiE.i
  
  DateiE.i = OpenPreferences("WZL_Einstellungen.pref")
  
  Schriftgroesse.i = ReadPreferenceInteger("Schriftgroesse", 12)
  Schriftart.s = ReadPreferenceString("Schriftart", "Arial")
  
  AnsichtSortieren.i = ReadPreferenceInteger("AnsichtSortieren", #False)
  AnsichtVerstecken.i = ReadPreferenceInteger("AnsichtVerstecken", #False)
  AnsichtDoppelt.i = ReadPreferenceInteger("AnsichtDoppelt", #False)
  
  ClosePreferences()
EndProcedure

Procedure SpeichereEinstellungen()
  
  DateiE.i = OpenPreferences("WZL_Einstellungen.pref")
  If DateiE.i = #False
    CreatePreferences("WZL_Einstellungen.pref")
  EndIf   
  
  WritePreferenceString("Schriftart", Schriftart)
  WritePreferenceInteger("Schriftgroesse", Schriftgroesse)
  
  WritePreferenceInteger("AnsichtSortieren", AnsichtSortieren)
  WritePreferenceInteger("AnsichtDoppelt", AnsichtDoppelt)
  WritePreferenceInteger("AnsichtVerstecken", AnsichtVerstecken)
  
  ClosePreferences()
EndProcedure

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 30
; FirstLine = 3
; Folding = -
; EnableXP