XIncludeFile "GUI_Header.pb"
XIncludeFile "main.pb"
XIncludeFile "einlesen.pb"
XIncludeFile "print.pb"
XIncludeFile "einstellungen.pb"

;GUI Erstellen
Procedure CreateGUI()
  ;mainwindow
  OpenWindow(#GUI_WINDOW, 100, 100, 800, 600, "WZ Liste Deckel", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
  WindowBounds(#GUI_WINDOW,500, 400, #PB_Default, #PB_Default)
  CreateMenu(#GUI_WINDOW_MENU, WindowID(#GUI_WINDOW))
  MenuTitle("Datei")
  MenuItem(#DateiOeffneH, "Heidenhain Datei Laden")
  MenuItem(#DateiOeffneHTextField, "Heidenhain Programm einfügen")
  MenuBar()
  MenuItem(#DateiOeffneT, "TOOL Datei Laden")
  MenuItem(#DateiOeffneTTextField, "TOOL Datei einfügen")
  MenuBar()
  MenuItem(#DateiBeenden, "Beenden")
  
  MenuTitle("Ansicht")
  MenuItem(#AnsichtVerstecken, "Kommentare ohne WZ Nr. Verstecken")
  MenuItem(#AnsichtDoppelt, "Doppelte WZ ausblenden")
  MenuItem(#AnsichtSortieren, "WZ Sortieren")
  SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtVerstecken, AnsichtVerstecken)
  SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtDoppelt, AnsichtDoppelt)
  SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtSortieren, AnsichtSortieren)
  
  ;AnsichtDoppelt Deaktivieren da noch nicht implementiert
  DisableMenuItem(#GUI_WINDOW_MENU, #AnsichtDoppelt, #True)
  
  MenuTitle("Drucken")
  MenuItem(#PrintPrint, "Drucken")
  MenuItem(#PrintEinstellungen, "Druckereinstellungen")
  MenuBar()
  MenuItem(#PrintSchrift, "Schriftart und -größe")
  
  BindMenuEvent(#GUI_WINDOW_MENU, #DateiBeenden, @ProgramEnd())
  BindMenuEvent(#GUI_WINDOW_MENU, #DateiOeffneH, @HOeffnen())
  BindMenuEvent(#GUI_WINDOW_MENU, #DateiOeffneHTextField, @OeffneHTextField())
  BindMenuEvent(#GUI_WINDOW_MENU, #DateiOeffneT, @TOeffnen())
  BindMenuEvent(#GUI_WINDOW_MENU, #DateiOeffneTTextField, @OeffneTTextField())
  
  BindMenuEvent(#GUI_WINDOW_MENU, #AnsichtVerstecken, @ChangeVerstecken())
  BindMenuEvent(#GUI_WINDOW_MENU, #AnsichtDoppelt, @ChangeDoppelt())
  BindMenuEvent(#GUI_WINDOW_MENU, #AnsichtSortieren, @ChangeSortieren())
  
  BindMenuEvent(#GUI_WINDOW_MENU, #PrintPrint, @PrintDefault())
  BindMenuEvent(#GUI_WINDOW_MENU, #PrintEinstellungen, @PrintPref())
  BindMenuEvent(#GUI_WINDOW_MENU, #PrintSchrift, @PrintSchrift())
  
  CreateStatusBar(#GUI_WINDOW_STATUSBAR, WindowID(#GUI_WINDOW))
  AddStatusBarField(#PB_Ignore)
  AddStatusBarField(200)
  AddStatusBarField(150)
  AddStatusBarField(100)
  StatusBarText(#GUI_WINDOW_STATUSBAR, 0, "2018 by Martin Fritz - " + "Version: " + #Version)  
  StatusBarText(#GUI_WINDOW_STATUSBAR, 1, "Schriftart: " + Schriftart)
  StatusBarText(#GUI_WINDOW_STATUSBAR, 2, "Schriftgröße: " + Schriftgroesse)
  SetStatusBarAnsicht()
  
  ListIconGadget(#GUI_WINDOW_LISTICONGADGET, 0, 0, WindowWidth(#GUI_WINDOW, #PB_Window_InnerCoordinate), WindowHeight(#GUI_WINDOW, #PB_Window_InnerCoordinate) - StatusBarHeight(#GUI_WINDOW_STATUSBAR) - MenuHeight(), "WZ Nummer", 100, #PB_ListIcon_GridLines)
  AddGadgetColumn(#GUI_WINDOW_LISTICONGADGET, 1, "Kommentar", 220)
  AddGadgetColumn(#GUI_WINDOW_LISTICONGADGET, 2, "Werkzeug", 220)
  AddGadgetColumn(#GUI_WINDOW_LISTICONGADGET, 3, "Time 1", 70)
  AddGadgetColumn(#GUI_WINDOW_LISTICONGADGET, 4, "Curent Time", 70)
  AddGadgetColumn(#GUI_WINDOW_LISTICONGADGET, 5, "Last Use", 150)
  BindEvent(#PB_Event_SizeWindow, @GUIResizeWindow(), #GUI_WINDOW)
  
  ;ToolWindow
  OpenWindow(#GUI_TOOLWINDOW, 100, 100, 500, 500, "Text Eingabe", #PB_Window_Tool | #PB_Window_WindowCentered | #PB_Window_Invisible, WindowID(#GUI_WINDOW))
  EditorGadget(#GUI_TOOLWINDOW_TEXTAREA, 0, 0, WindowWidth(#GUI_TOOLWINDOW), WindowHeight(#GUI_TOOLWINDOW) - 70)
  ButtonGadget(#GUI_TOOLWINDOW_BUTTON_OK, 10, WindowHeight(#GUI_TOOLWINDOW) - 60, 140, 50, "Einlesen", #PB_Button_Default)
  ButtonGadget(#GUI_TOOLWINDOW_BUTTON_ABBRUCH, 170, WindowHeight(#GUI_TOOLWINDOW) - 60, 140, 50, "Abbrechen")
  ButtonGadget(#GUI_TOOLWINDOW_BUTTON_EINFUEGEN, 340, WindowHeight(#GUI_TOOLWINDOW) - 60, 140, 50, "Einfügen")
  
  BindGadgetEvent(#GUI_TOOLWINDOW_BUTTON_ABBRUCH, @Tollwindow_Abbruch(), #PB_EventType_LeftClick)
  BindGadgetEvent(#GUI_TOOLWINDOW_BUTTON_OK, @Tollwindow_Ok(), #PB_EventType_LeftClick)
  BindGadgetEvent(#GUI_TOOLWINDOW_BUTTON_EINFUEGEN, @Tollwindow_Einfuegen(), #PB_EventType_LeftClick)
EndProcedure

Procedure ProgramEnd()
  End
EndProcedure

Procedure GUIResizeWindow()
  ResizeGadget(#GUI_WINDOW_LISTICONGADGET, 0, 0, WindowWidth(#GUI_WINDOW, #PB_Window_InnerCoordinate), WindowHeight(#GUI_WINDOW, #PB_Window_InnerCoordinate) - StatusBarHeight(#GUI_WINDOW_STATUSBAR) - MenuHeight())
EndProcedure

Procedure OeffneHTextField()
TextFieldTyp.s = "H"
OeffneTextField()
EndProcedure

Procedure OeffneTTextField()
TextFieldTyp.s = "T"
OeffneTextField()
EndProcedure

Procedure OeffneTextField()
  SetGadgetText(#GUI_TOOLWINDOW_TEXTAREA, "")
  SetActiveGadget(#GUI_TOOLWINDOW_TEXTAREA)
  DisableWindow(#GUI_WINDOW, #True)
  HideWindow(#GUI_TOOLWINDOW, #False)
EndProcedure

Procedure Tollwindow_Abbruch()
DisableWindow(#GUI_WINDOW, #False)
HideWindow(#GUI_TOOLWINDOW, #True)
EndProcedure

Procedure Tollwindow_Ok()
DisableWindow(#GUI_WINDOW, #False)
HideWindow(#GUI_TOOLWINDOW, #True)
If TextFieldTyp = "H"
  HEinlesen(#False)
ElseIf TextFieldTyp = "T"
  TEinlesen(#False)
EndIf

EndProcedure 

Procedure Tollwindow_Einfuegen()
  SetGadgetText(#GUI_TOOLWINDOW_TEXTAREA, GetClipboardText())
EndProcedure

Procedure ChangeVerstecken()

  Select GetMenuItemState(#GUI_WINDOW_MENU, #AnsichtVerstecken)
    Case 0
      SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtVerstecken, #True)
      AnsichtVerstecken = #True
    Default
      SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtVerstecken, #False)
      AnsichtVerstecken = #False
  EndSelect
  
  SpeichereEinstellungen()
  SetStatusBarAnsicht()
  
  If ListSize(Werte()) > 0
    HWerteSortieren()
    AddWerteToListIconGadget()
  EndIf
  
EndProcedure

Procedure ChangeDoppelt()
    
  Select GetMenuItemState(#GUI_WINDOW_MENU, #AnsichtDoppelt)
    Case 0
      SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtDoppelt, #True)
      AnsichtDoppelt = #True
    Default
      SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtDoppelt, #False)
      AnsichtDoppelt = #False
  EndSelect
  
  SpeichereEinstellungen()
  SetStatusBarAnsicht()
  
  If ListSize(Werte()) > 0
    HWerteSortieren()
    AddWerteToListIconGadget()
  EndIf
EndProcedure

Procedure ChangeSortieren()
    
  Select GetMenuItemState(#GUI_WINDOW_MENU, #AnsichtSortieren)
    Case 0
      SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtSortieren, #True)
      AnsichtSortieren = #True
    Default
      SetMenuItemState(#GUI_WINDOW_MENU, #AnsichtSortieren, #False)
      AnsichtSortieren = #False
  EndSelect
  
  SpeichereEinstellungen()
  SetStatusBarAnsicht()
  
  If ListSize(Werte()) > 0
    HWerteSortieren()
    AddWerteToListIconGadget()
  EndIf

EndProcedure

; Statusbar Aktualisieren
Procedure SetStatusBarAnsicht()
  Protected Verstecken.s 
  Protected Doppelt.s
  Protected Sortieren.s
  
  Select AnsichtVerstecken
    Case 1
      Verstecken.s = "X"
    Case 0
      Verstecken.s = "  "
  EndSelect
  
  Select AnsichtDoppelt
    Case 1
      Doppelt.s = "X"
    Case 0
      Doppelt.s = "  "
  EndSelect
  
  Select AnsichtSortieren
    Case 1
      Sortieren.s = "X"
    Case 0
      Sortieren.s = "  "
  EndSelect
  
  StatusBarText(#GUI_WINDOW_STATUSBAR, 3, "V[" + Verstecken.s + "] D[" + Doppelt + "] S[" + Sortieren + "]", #PB_StatusBar_Center)
EndProcedure


; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 183
; FirstLine = 49
; Folding = 9-+
; EnableXP