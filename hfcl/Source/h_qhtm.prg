
#include "hmg.ch"

#define WS_BORDER           0x00800000
#define WM_SETREDRAW        0x0b

/******
*
*       Define QHTM control
*
*/
Function _DefineQhtm( ControlName, ParentForm, x, y, w, h, Value, fname, resname, fontname, fontsize, Change, lBorder, bold, italic, underline, strikeout)
Local mVar, k := 0, ControlHandle, FontHandle, nId

   if oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
      if .Not. Empty ( oHmgApp():APP224 ) .And. ValType(FontName) == "U"
         FontName := oHmgApp():APP224
      EndIf
      if .Not. Empty ( oHmgApp():ActiveFontSize ) .And. ValType(FontSize) == "U"
         FontSize := oHmgApp():ActiveFontSize
      EndIf
   endif

   if oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         x  := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         y  := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
         cParentTabName := oHmgApp():APP225
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError(oHmgApp():APP136[1]+ ParentForm + oHmgApp():APP136[2])
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError (oHmgApp():APP136[4] + ControlName + oHmgApp():APP136[5] + ParentForm + oHmgApp():APP136[6])
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm = ParentForm

   ParentForm = GetFormHandle (ParentForm)

   nId := _GetId()

   ControlHandle := CreateQHTM(ParentForm, nId, IIF (lBorder ==.T., WS_BORDER, 0), y, x, w, h)

   if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
     FontHandle := _SetFont (ControlHandle, oHmgApp():APP342, oHmgApp():APP343,bold,italic,underline,strikeout)
   endif


   If ( Valtype( Value ) == 'C' )
      SetWindowText( ControlHandle, Value )
   ElseIf ( Valtype( fname ) == 'C' )
      QHTM_LoadFile( ControlHandle, fname )
   ElseIf ( Valtype( resname ) == 'C' )
      QHTM_LoadRes( ControlHandle, resname )
   Endif

   QHTM_FormCallBack( ControlHandle )

   k := _GetControlFree()
   Public &mVar. := k
   oControl := ControlByIndex( k )

   oControl:Type := 'QHTM'
   oControl:Name := ControlName
   oControl:Handle := ControlHandle
   oControl:ParentForm := ParentForm
   oControl:CTRL005 := nId
   oControl:CTRL006 := ""
   oControl:CTRL007 := {}
   oControl:CTRL008 := Value
   oControl:CTRL009 := ""
   oControl:CTRL010 := ""
   oControl:CTRL011 := ""
   oControl:CTRL012 := Change
   oControl:IsDeleted := .F.
   oControl:CTRL014 := NIL
   oControl:CTRL015 := NIL
   oControl:CTRL016 := ""
   oControl:CTRL017 := {}
   oControl:CTRL018 := x
   oControl:CTRL019 := y
   oControl:CTRL020 := w
   oControl:CTRL021 := h
   oControl:CTRL022 := 0
   oControl:CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
   oControl:CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
   oControl:CTRL025 := ''
   oControl:CTRL026 := 0
   oControl:CTRL027 := fontname
   oControl:CTRL028 := fontsize
   oControl:CTRL029 := {bold,italic,underline,strikeout}
   oControl:CTRL030 := ''
   oControl:CTRL031 := 0
   oControl:CTRL032 := 0
   oControl:CTRL033 := ''
   oControl:CTRL034 := .T.
   oControl:CTRL035 := 0
   oControl:CTRL036 := ''
   oControl:CTRL037 := 0
   oControl:CTRL038 := .T.
   oControl:CTRL039 := 0
   oControl:CTRL040 := ''

Return Nil



/******
*
*       QHTM_LoadFromVal( ControlName, ParentForm, cValue )
*
*       Load web-page from variable
*
*/
Procedure QHTM_LoadFromVal( ControlName, ParentForm, cValue )
Local nHandle := GetControlHandle( ControlName, ParentForm )

If ( nHandle > 0 )
   SetWindowText( nHandle, cValue )
Endif

Return

/******
*
*       QHTM_LoadFromFile( ControlName, ParentForm, cFile )
*
*       Load web-page from file
*
*/
Procedure QHTM_LoadFromFile( ControlName, ParentForm, cFile )
Local nHandle := GetControlHandle( ControlName, ParentForm )

If ( nHandle > 0 )
   QHTM_LoadFile( nHandle, cFile )
Endif

Return

/******
*
*       QHTM_LoadFromRes( ControlName, ParentForm, cResName )
*
*       Load web-page from resource
*
*/
Procedure QHTM_LoadFromRes( ControlName, ParentForm, cResName )
Local nHandle := GetControlHandle( ControlName, ParentForm )

If ( nHandle > 0 )
   QHTM_LoadRes( nHandle, cResName )
Endif

Return

/******
*
*       QHTM_GetLink( lParam )
*
*       Receive QHTM link
*
*/
Function QHTM_GetLink( lParam )
Local cLink := QHTM_GetNotify( lParam )

QHTM_SetReturnValue( lParam, .F. )

Return cLink

/******
*
*       QHTM_ScrollPos( nHandle, nPos )
*
*       nHandle - descriptor of QHTM
*       nPos - old/new position of scrollbar
*
*       Get/Set position of scrollbar QHTM
*
*/
Function QHTM_ScrollPos( nHandle, nPos )
Local nParamCount := PCount()

Switch nParamCount

   Case 0
     nPos := 0
     Exit

   Case 1

     If HB_ISNUMERIC( nHandle )
        nPos := QHTM_GetScrollPos( nHandle )
     Endif
     Exit

   Case 2

     If ( HB_ISNUMERIC( nHandle ) .and. HB_ISNUMERIC( nPos ) )
        QHTM_SetScrollPos( nHandle, nPos )
     Else
        nPos := 0
     Endif

End Switch

Return nPos

/******
*
*       QHTM_ScrollPercent( nHandle, nPercent )
*
*       nHandle  - descriptor of QHTM
*       nPercent - old/new position of scrollbar (in percentage)
*
*       Get/Set position of scrollbar QHTM
*
*/
Function QHTM_ScrollPercent( nHandle, nPercent )
Local nParamCount := PCount(), ;
      nHeight                , ;
      aSize                  , ;
      nPos

If HB_ISNUMERIC( nHandle )

   nHeight := GetWindowHeight( nHandle )
   aSize := QHTM_GetSize( nHandle )

   If ( aSize[ 2 ] > nHeight )
      aSize[ 2 ] -= nHeight
    Endif

Endif

Switch nParamCount

   Case 0
     nPercent := 0
     Exit

   Case 1

     nPos  := QHTM_GetScrollPos( nHandle )
     nPercent := Min( Round( ( ( nPos / aSize[ 2 ] ) * 100 ), 2 ), 100.00 )
     Exit

   Case 2

     If HB_ISNUMERIC( nPercent )
        nPos := Round( ( nPercent * aSize[ 2 ] * 0.01 ), 0 )
        QHTM_SetScrollPos( nHandle, nPos )
     Else
        nPercent := 0
     Endif

End Switch

Return nPercent

/******
*
*       QHTM_EnableUpdate( ControlName, ParentForm, lEnable )
*
*       Enable/disable redraw of control
*
*/
Procedure QHTM_EnableUpdate( ControlName, ParentForm, lEnable )

IF Valtype(lEnable) == "U"
   lEnable := .T.
ENDIF

If ( PCount() < 2 )
   Return
Endif

SendMessage( GetControlHandle( ControlName, ParentForm ), WM_SETREDRAW, Iif( lEnable, 1, 0 ), 0 )

Return


********************************************************************************************

Function QHTM_Zoom ( ControlName, ParentForm, nLevel )
   QHTM_SetZoomLevel(GetControlHandle( ControlName, ParentForm ), nLevel)
Return Nil
