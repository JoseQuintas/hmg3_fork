/*----------------------------------------------------------------------------
HMG - Harbour Windows GUI library source code

Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
http://sites.google.com/site/hmgweb/

Head of HMG project:

2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
http://sites.google.com/site/hmgweb/

2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
http://srvet.blogspot.com

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this software; see the file COPYING. IF not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
visit the web site http://www.gnu.org/).

As a special exception, you have permission for additional uses of the text
contained in this release of HMG.

The exception is that, IF you link the HMG library with other
files to produce an executable, this does not by itself cause the resulting
executable to be covered by the GNU General Public License.
Your use of that executable is in no way restricted on account of linking the
HMG library code into it.

Parts of this project are based upon:

"Harbour GUI framework for Win32"
Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
Copyright 2001 Antonio Linares <alinares@fivetech.com>
www - http://www.harbour-project.org

"Harbour Project"
Copyright 1999-2008, http://www.harbour-project.org/

"WHAT32"
Copyright 2002 AJ Wos <andrwos@aust1.net>

"HWGUI"
Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

#include "common.ch"
#include "hmg.ch"

*-----------------------------------------------------------------------------*

FUNCTION _DefineToolBar (   cControlName      , ;
      cParentWindowName   , ;
      nButtonWidth      , ;
      nButtonHeight      , ;
      lFlat         , ;
      lBottom         , ;
      lRightText      , ;
      lBorder         , ;
      cFontName      , ;
      nFontSize      , ;
      lBold         , ;
      lItalic         , ;
      lUnderLine      , ;
      lStrikeOut      , ;
      cToolTip      , ;
      cGripperText      , ;
      lBreak         , ;
      nImageWidth      , ;
      nImageHeight      , ;
      lStrictWidth        ;
      )
   *-----------------------------------------------------------------------------*
   * Local Variables
   LOCAL nParentWindowHandle
   LOCAL nControlHandle, oControl
   LOCAL mVar
   LOCAL k
   LOCAL nId
   LOCAL nFontHandle
   LOCAL aTemp := {}
   LOCAL lSplitBoxActive

   DEFAULT nImageWidth   To -1
   DEFAULT nImageHeight   To -1

   * Set Public ToolBar Support Variables
   oHmgApp():APP309   := 0
   oHmgApp():APP313   := cGripperText
   oHmgApp():APP261   := lBreak

   lSplitBoxActive := oHmgApp():APP262   // ADD

   IF lSplitBoxActive == .T.
      oHmgApp():APP216   := 'TOOLBAR'
   ENDIF

   * IF inside DEFINE WINDOW structure gets window name

   IF oHmgApp():APP264 = .T.
      cParentWindowName := oHmgApp():ActiveFormName
   ENDIF

   oHmgApp():APP311 := cParentWindowName

   * Error Checking

   IF .NOT. _IsWindowDefined ( cParentWindowName )
      MsgHMGError("Window: "+ cParentWindowName + " is not defined. Program terminated")
      ExitProcess(0)
      RETURN Nil
   ENDIF

   IF _IsControlDefined ( cControlName , cParentWindowName )
      MsgHMGError ("Control: " + cControlName + " Of " + cParentWindowName + " Already defined. Program Terminated")
      ExitProcess(0)
      RETURN Nil
   ENDIF

   * Create Public control variable
   mVar := '_' + cParentWindowName + '_' + cControlName

   * GET Parent Window Handle
   nParentWindowHandle := GetFormHandle ( cParentWindowName )
   oHmgApp():APP312 := nParentWindowHandle

   * GET Id For Control
   nId := _GetId()

   * Create Control
   aTemp := InitToolBar ( nParentWindowHandle , nId , nButtonWidth , nButtonHeight , lBorder , lFlat , lBottom , lRightText , lSplitBoxActive , nImageWidth , nImageHeight , lStrictWidth )

   nControlHandle := atemp[1]

   oHmgApp():APP315   := aTemp [2]
   oHmgApp():APP300   := aTemp [3]

   oHmgApp():APP310 := nControlHandle

   * Set Font
   IF ValType(cFontName) != "U" .AND. ValType(nFontSize) != "U"
      nFontHandle := _SetFont (nControlHandle,cFontName,nFontSize,lbold,litalic,lunderline,lstrikeout)
   ELSE
      nFontHandle := _SetFont (nControlHandle,oHmgApp():APP342,oHmgApp():APP343,lbold,litalic,lunderline,lstrikeout)
   ENDIF

   IF ValType(cToolTip) != "U"
      SetToolTip ( nControlHandle , cToolTip , GetFormToolTipHandle (cParentWindowName) )
   ENDIF

   * GET Position In Control Arrays
   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   oControl:Type := "TOOLBAR"
   oControl:Name := cControlName
   oControl:Handle := nControlHandle
   oControl:ParentFormHandle := nParentWindowHandle
   oControl:CTRL005 := nId
   oControl:CTRL006 := Nil
   oControl:CTRL007 := {}
   oControl:CTRL008 := Nil
   oControl:CTRL009 := ""
   oControl:CTRL010 := ""
   oControl:CTRL011 := ""
   oControl:CTRL012 := ""
   oControl:IsDeleted := .F.
   oControl:CTRL014 := Nil
   oControl:CTRL015 := Nil
   oControl:CTRL016 := ""
   oControl:CTRL017 := {}
   oControl:CTRL018 := IF (VALTYPE (lBottom) == "L",         lBottom,         .F.)   // ADD
   oControl:CTRL019 := IF (VALTYPE (lSplitBoxActive) == "L", lSplitBoxActive, .F.)   // ADD
   oControl:CTRL020 := nButtonWidth
   oControl:CTRL021  := nButtonHeight
   oControl:CTRL022 := 0
   oControl:CTRL023 := -1
   oControl:CTRL024 := -1
   oControl:CTRL025 := ""
   oControl:CTRL026 := 0
   oControl:CTRL027 := ""
   oControl:CTRL028 := 0
   oControl:CTRL029 := {.f.,.f.,.f.,.f.}
   oControl:CTRL030 := ""
   oControl:CTRL031 := 0
   oControl:CTRL032 := 0
   oControl:CTRL033 := ""
   oControl:CTRL034 := .t.
   oControl:CTRL035 := 0
   oControl:CTRL036 := 0
   oControl:CTRL037 := 0
   oControl:CTRL038 := .T.
   oControl:CTRL039 := 0
   oControl:CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _DefineToolButton ( cControlName , ;
      cPicture , ;
      cCaption , ;
      bAction , ;
      lSeparator , ;
      lAutoSize , ;
      lCheck , ;
      lGroup , ;
      lDropdown , ;
      lWholeDropDown , ;
      cToolTip , ;
      notrans )

   LOCAL nId, xTmp
   LOCAL nControlHandle, oControl
   LOCAL cParentWindowName
   LOCAL nParentWindowHandle
   LOCAL mVar
   LOCAL k
   LOCAL i
   LOCAL c
   LOCAL nToolBarIndex
   LOCAL nButtonPos

   * Gets Toolbar Parent Window Name
   cParentWindowName := oHmgApp():APP311

   * Error Checking

   IF .NOT. _IsWindowDefined ( cParentWindowName )
      MsgHMGError("Window: "+ cParentWindowName + " is not defined. Program terminated")
      ExitProcess(0)
      RETURN Nil
   ENDIF

   IF _IsControlDefined ( cControlName , cParentWindowName )
      MsgHMGError ("Control: " + cControlName + " Of " + cParentWindowName + " Already defined. Program Terminated")
      ExitProcess(0)
      RETURN Nil
   ENDIF

   IF lDropdown == .T. .AND. ValType(bAction) = 'U'
      MsgHMGError ("Control: " + cControlName + " Of " + cParentWindowName + ". ToolBar DropDown buttons must have an associated action (Use WholeDropDown style for no action). Program Terminated")
      ExitProcess(0)
      RETURN Nil
   ENDIF

   * GET Parent Window Handle
   nParentWindowHandle := oHmgApp():APP312

   * Create Public control variable
   mVar := '_' + cParentWindowName + '_' + cControlName

   * GET Id
   nId := _GetId()

   * Increment ToolBar Button Count
   oHmgApp():APP309++

   * Create Control
   nControlHandle := InitToolButton (      ;
      oHmgApp():APP310   , ;
      cPicture         , ;
      cCaption         , ;
      nId            , ;
      lSeparator         , ;
      lAutoSize         , ;
      lCheck            , ;
      lGroup            , ;
      lDropdown         , ;
      lWholeDropDown         , ;
      oHmgApp():APP315   , ;
      oHmgApp():APP300, ;
      notrans )

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   oControl:Type := "TOOLBUTTON"
   oControl:Name :=  cControlName
   oControl:Handle      [k] :=  nControlHandle
   ControlByIndex( K ):ParentFormHandle :=  nParentWindowHandle
   oControl:CTRL005 :=  nId
   oControl:CTRL006 :=  bAction
   oControl:CTRL007 :=  {}
   oControl:CTRL008 :=  oHmgApp():APP309   // ToolBar Button Count
   oControl:CTRL009 :=  ""
   oControl:CTRL010 :=  ""
   oControl:CTRL011 :=  ""
   oControl:CTRL012 :=  ""
   oControl:IsDeleted :=  .F.
   oControl:CTRL014 :=  Nil
   oControl:CTRL015 :=  Nil
   oControl:CTRL016 := ""
   oControl:CTRL017 := {}
   oControl:CTRL018 := Nil
   oControl:CTRL019 := Nil
   oControl:CTRL020 := 0
   oControl:CTRL021 := 0
   oControl:CTRL022 := 0
   oControl:CTRL023 := -1
   oControl:CTRL024 := -1
   oControl:CTRL025 := cPicture
   oControl:CTRL026 := oHmgApp():APP310   // ToolBar Handle
   oControl:CTRL027 := ''
   oControl:CTRL028 := 0
   oControl:CTRL029 := {.f.,.f.,.f.,.f.}
   oControl:CTRL030 := cToolTip
   oControl:CTRL031 := 0
   oControl:CTRL032 := notrans
   oControl:CTRL033 := cCaption
   oControl:CTRL034 := .t.
   oControl:CTRL035 := 0
   oControl:CTRL036 := 0
   oControl:CTRL037 := 0
   oControl:CTRL038 := .T.
   oControl:CTRL039 := 0
   oControl:CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

   IF ValType ( cCaption ) != 'U'

      SetToolButtonCaption ( ControlByIndex( K ):CTRL026 , ControlByIndex( K ):CTRL005 , cCaption)   // ADD HMG 3.0.45
      cCaption := HMG_UPPER ( cCaption )

      i := HB_UAT ( '&' , cCaption )

      IF i > 0
         c := ASC ( HB_USUBSTR ( cCaption , i+1 , 1 ) )

         IF c >= 48 .AND. c <= 90

            xTmp := ControlByHandle( oHmgApp():APP310 )
            nToolBarIndex := iif( xTmp == Nil, 0, xTmp:Index )
            nButtonPos := oHmgApp():APP309

            IF lWholeDropDown == .T.
               bAction := { || _DropDownShortcut ( nId , nParentWindowHandle , nToolBarIndex , nButtonPos ) }
            ENDIF

            _DefineHotKey ( cParentWindowName , MOD_ALT , c , bAction )

         ENDIF
      ENDIF

   ENDIF

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _EndToolBar ()

   *-----------------------------------------------------------------------------*
   LOCAL i

   ActivateToolBar ( oHmgApp():APP310 )

   IF oHmgApp():APP262 == .T.
      i := GetFormIndex ( oHmgApp():APP222 )

      AddSplitBoxItem ( oHmgApp():APP310 , ;
         FormByIndex( I ):FORM087 ,  ;
         GetToolBarWidth(oHmgApp():APP310) , ;
         oHmgApp():APP261 , ;
         oHmgApp():APP313 , ;
         GetToolBarWidth(oHmgApp():APP310) , ;
         GetToolBarHeight(oHmgApp():APP310) , ;
         oHmgApp():APP258 ;
         )

   ENDIF

   RETURN Nil

   // #define WM_USER     1024        // ok (MinGW)
#define WM_USER         0x0400        // ok
#define TB_SETHOTITEM    (WM_USER+72)   // ok

   *------------------------------------------------------------------------------*

PROCEDURE _DropDownShortcut ( nToolButtonId , nParentWindowHandle , i , nButtonPos )

   *------------------------------------------------------------------------------*
   LOCAL aPos := { 0 , 0 , 0 , 0 }
   LOCAL aSize
   LOCAL x, xTmp

   xTmp := ControlByBlock( { | e | E:CTRL005 == nToolButtonId } )
   x  := iif( xTmp == Nil, 0, xTmp:Index )

   IF x > 0 .AND. ControlByIndex( x ):Type = "TOOLBUTTON"
      aPos:= {0,0,0,0}
      GetWindowRect(ControlByIndex( i ):Handle,aPos)
      aSize := GetToolButtonSize ( ControlByIndex( i ):Handle , ControlByIndex( X ):CTRL008 - 1 )

      SendMessage( ControlByIndex( i ):Handle , TB_SETHOTITEM, nButtonPos - 1 ,  0 )

      TrackPopupMenu ( ControlByIndex( X ):CTRL032 , aPos[1] + aSize [1] , aPos[2] + aSize [2] + ( aPos[4] - aPos[2] - aSize [2] ) / 2 , nParentWindowHandle )

      SendMessage( ControlByIndex( i ):Handle , TB_SETHOTITEM, -1 ,  0 )

   ENDIF

   RETURN

   // by Dr. Claudio Soto (May 2014)
   *------------------------------------------------------------------------------*

PROCEDURE RepositionToolBar (nIndex)

   *------------------------------------------------------------------------------*
   LOCAL nRow, nCol, cFormName

   DEFAULT nIndex TO oHmgApp():LastActiveFormIndex
   IF nIndex > 0
      cFormName := GetFormNameByIndex (nIndex)
      IF BT_StatusBarHeight (cFormName) > 0 .AND. BT_ToolBarBottomHeight (cFormName) > 0
         nCol := GETWINDOWCOL (BT_ToolBarBottomHandle(cFormName))
         ScreenToClient (GetFormHandle(cFormName), @nCOL, NIL)
         nRow := BT_ClientAreaHeight(cFormName) - BT_ToolBarBottomHeight(cFormName) - BT_StatusBarHeight (cFormName)
         SetWindowPos (BT_ToolBarBottomHandle(cFormName), 0, nCol, nRow, 0, 0, SWP_NOSIZE + SWP_NOZORDER)
      ENDIF
   ENDIF

   RETURN
