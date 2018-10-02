Enumeration
  #Nr
  #Wz
  #Time1
  #CurTime
  #LastUse
EndEnumeration

Structure komm
  tool.s
  id.s
  idDouble.d
  komm.s
EndStructure
Global NewList Werte.komm()
Global NewList WerteSortiert.komm()

Structure tool
  Nr.s
  Wz.s
  Time1.s
  CurTime.s
  LastUse.i
EndStructure
Global NewList TWerte.tool()
Global PosNr.d = 0
Global PosName.d = 0
Global PosTime1.d = 0
Global PosCurTime.d = 0
Global PosLastUse.d = 0

Global WzIdZwischenspeicher.s = ""

Declare.i HOeffnen()
Declare HEinlesen(datei.i)
Declare HEinlesen_logik(linie.s)
Declare.i TOeffnen()
Declare TEinlesen(datei.i)
Declare TEinlesen_logik(linie.s)
Declare AddKommentar(komm.s)
Declare AddWerteToListIconGadget()
Declare AddTool(tool.s)
Declare.s GetTWerT(Wert.i, Nr.s)
Declare HWerteSortieren()
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 5
; EnableXP