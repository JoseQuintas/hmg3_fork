* AutoAdjust (c) 2007-2015 MigSoft / Danny / Pablo César
*-------------------------------------------------------*

Function AutoAdjust( cForm )
Local hWnd := GetFormHandle( cForm )

Local i,;                    // From no
      k,;                    // Control no
      ParentForm,;
      ControlCount,;
      ControlName,;
      ControlType,;
      nWidth,;
      nHeight,;
      lvisible := .T.,;
      nDivw,;
      nDivh

IF GetDesktopWidth() < GetWindowWidth ( hWnd )
   nWidth := GetDesktopWidth()
ELSE
   nWidth := GetWindowWidth ( hWnd )
ENDIF

IF GetDesktopHeight() < GetWindowHeight ( hWnd )
   nHeight := GetDesktopHeight()
ELSE
   nHeight := GetWindowHeight( hWnd )
ENDIF

IF IsWindowVisible( hWnd ) .AND. ! IsAppXPThemed()
   HideWindow ( hWnd )
ELSE
   lvisible := .F.
ENDIF

oFormTmp := FormByHandle( hWnd )
i := iif( xTmp == Nil, 0, oFormTmp:Index )

ParentForm := FormByIndex( I ):Name

IF FormByIndex( I ):VirtualWidth > 0 .AND. FormByIndex( I ):VirtualHeight > 0
   nDivw := nWidth  / FormByIndex( I ):VirtualWidth
   nDivh := nHeight / FormByIndex( I ):VirtualHeight
ELSE
   nDivw := 1
   nDivh := 1
ENDIF

ControlCount := oHmgApp():ControlCount()

FOR k := 1 To ControlCount
    ControlName := ControlByIndex( K ):Name

    IF _IsControlDefined ( ControlName, ParentForm )
       ControlType := ControlByIndex( K ):Name

       IF !EMPTY( ControlName ) .AND. !( ControlType $ "MENU,HOTKEY,TOOLBAR,MESSAGEBAR,ITEMMESSAGE,TIMER" )

          DO CASE
             CASE ControlType $ "RADIOGROUP,TEXT,BUTTON"
                  _SetControlSizePos( ControlName, ParentForm,;
                   _GetControlRow( ControlName, ParentForm ) * nDivh, ;   // row
                   _GetControlCol ( ControlName, ParentForm ) * nDivw ,;  // column
                   _GetControlWidth( ControlName, ParentForm ) * nDivw,;  // with
                   _GetControlHeight ( ControlName, ParentForm ) )        // height

             CASE ControlType == "SLIDER"
                  _SetControlSizePos ( ControlName, ParentForm,;
                  _GetControlRow ( ControlName, ParentForm ) * nDivh, _GetControlCol ( ControlName, ParentForm ) * nDivw,;
                  _GetControlWidth ( ControlName, ParentForm ) * nDivw, _GetControlHeight ( ControlName, ParentForm ) * nDivh )

             CASE ControlType == "STATUSBAR"
                  // do nothing

             CASE !ControlType $ "TOOLBUTTON"
                  _SetControlSizePos ( ControlName, ParentForm,;
                  _GetControlRow ( ControlName, ParentForm ) * nDivh, _GetControlCol ( ControlName, ParentForm ) * nDivw,;
                  _GetControlWidth ( ControlName, ParentForm ) * nDivw, _GetControlHeight ( ControlName, ParentForm ) * nDivh )
          OTHERWISE
             IF EMPTY( ControlByIndex( K ):CTRL028 )
                _SetFontSize ( ControlName, ParentForm , 8 * nDivh )
             ELSE
                _SetFontSize ( ControlName, ParentForm , ControlByIndex( K ):CTRL028 * nDivh )
             ENDIF
          ENDCASE
       ENDIF
    ENDIF
NEXT k

FormByIndex( I ):FORM092 := nWidth
FOrmByIndex( I ):FORM091 := nHeight

IF lvisible
   ShowWindow ( hWnd )
ENDIF
Return Nil

FUNCTION ISAPPXPTHEMED()
RETURN ( OS_ISWINXP_OR_LATER() ;     // <= hrb\contrib/hbwin/legacycv.c
         .AND. IsAppThemed() )       // <= HMG\h_window.prg
