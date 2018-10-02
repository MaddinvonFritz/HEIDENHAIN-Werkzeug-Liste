XIncludeFile "main_Header.pb"
XIncludeFile "GUI.pb"
XIncludeFile "einlesen.pb"
XIncludeFile "einstellungen.pb"

LadeEinstellungen()
CreateGUI()

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
  
End
  

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 9
; EnableXP