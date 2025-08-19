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
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
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

#include "hmg.ch"
#include "common.ch"
#include "fileio.ch"


#define EM_SETBKGNDCOLOR        1091  // ok

*-----------------------------------------------------------------------------*
Function _DefineRichEditBox ( ControlName, ;
            ParentForm, ;
            x, ;
            y, ;
            w, ;
            h, ;
            value, ;
            fontname, ;
            fontsize, ;
            tooltip, ;
            MaxLength, ;
            gotfocus, ;
            change, ;
            lostfocus, ;
            readonly, ;
            break, ;
            HelpId, ;
            invisible, ;
            notabstop , ;
            bold, ;
            italic, ;
            underline, ;
            strikeout , ;
            field, ;
            backcolor, ;
            noHscroll, noVscroll, selectionchange, OnLink, OnVScroll )

*-----------------------------------------------------------------------------*
Local i  , cParentForm , mVar , ContainerHandle := 0 , k := 0
Local ControlHandle, oControl
Local FontHandle
Local WorkArea

DEFAULT invisible    TO .F.
DEFAULT notabstop    TO .F.
DEFAULT W            TO 120
DEFAULT H            TO 240
DEFAULT VALUE        TO ''
DEFAULT noHscroll    TO .F.
DEFAULT noVscroll    TO .F.
DEFAULT MaxLength    TO -1  // 64000

IF MaxLength == 0
   MaxLength := -1   // for compatibility with TextBox and EditBox
ENDIF

   If ValType ( Field ) != 'U'
      if  HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated")
      Else
         WorkArea := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
         If Select (WorkArea) != 0
            Value := &(Field)
         EndIf
      EndIf
   EndIf

   if oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
      if .Not. Empty (oHmgApp():APP224) .And. ValType(FontName) == "U"
         FontName := oHmgApp():APP224
      EndIf
      if .Not. Empty ( oHmgApp():ActiveFontSize ) .And. ValType(FontSize) == "U"
         FontSize := oHmgApp():ActiveFontSize
      EndIf
   endif
   if oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
      x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
      y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
      ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   if valtype(x) == "U" .or. valtype(y) == "U"

      If oHmgApp():APP216 == 'TOOLBAR'
         Break := .T.
      EndIf

      oHmgApp():APP216   := 'RICHEDIT'

      i := GetFormIndex ( cParentForm )

      if i > 0

         ControlHandle := InitRichEditBox ( FormByIndex( I ):FORM087 , 0, x, y, w, h, '', 0 , MaxLength , readonly, invisible, notabstop, noHscroll, noVscroll )
         if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
            FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
         Else
            FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
         endif

         AddSplitBoxItem ( Controlhandle , FormByIndex( I ):FORM087 , w , break , , , , oHmgApp():APP258 )
         Containerhandle := FormByIndex( I ):FORM087

         if HMG_LEN(value) > 0
            SetWindowText ( ControlHandle , value )
         endif

      EndIf

   Else

      ControlHandle := InitRichEditBox ( ParentForm, 0, x, y, w, h, '', 0 , MaxLength , readonly, invisible, notabstop,  noHscroll, noVscroll)
      if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
      Else
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
      endif

      if HMG_LEN(value) > 0
         SetWindowText ( ControlHandle , value )
      endif

   endif

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   If valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif


   RichEditBox_SetRTFTextMode   ( ControlHandle , .T. )   // ADD
   RichEditBox_SetAutoURLDetect ( ControlHandle , .T. )   // ADD

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "RICHEDIT"
      :Name :=  ControlName
      :Handle :=  ControlHandle
      :ParentFormHandle :=  ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  Field
      :CTRL008 :=  NIL
      :CTRL009 :=  ""
      :CTRL010 :=  lostfocus
      :CTRL011 :=  gotfocus
      :CTRL012 :=   change
      :IsDeleted :=  .F.
      :CTRL014 :=  backcolor
      :CTRL015 :=  Nil
      :CTRL016 :=  ""
      :CTRL017 := {}
      :CTRL018 :=  y
      :CTRL019 :=  x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := selectionchange
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=   ContainerHandle
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  tooltip
      :CTRL031 :=  OnLink
      :CTRL032 :=  OnVScroll
      :CTRL033 :=  ''
      :CTRL034 :=   if(invisible,.f.,.t.)
      :CTRL035 :=   HelpId
      :CTRL036 :=   FontHandle
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   if valtype ( Field ) != 'U'
      aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , k )
   EndIf

   if valtype ( BackColor ) == 'A'
      if HMG_LEN ( BackColor ) == 3
         SendMessage ( oControl:Handle , EM_SETBKGNDCOLOR  , 0 , RGB ( BackColor[1] , BackColor[2] , BackColor[3] ) )
      endif
   EndIf

Return Nil
*------------------------------------------------------------------------------*
Procedure _DataRichEditBoxRefresh (i)
*------------------------------------------------------------------------------*
Local Field

   Field      := ControlByIndex( I ):CTRL007
   _SetValue ( '' , '' , &Field , i )

Return
*------------------------------------------------------------------------------*
Procedure _DataRichEditBoxSave ( ControlName , ParentForm)
*------------------------------------------------------------------------------*
Local Field , i

   i := GetControlIndex ( ControlName , ParentForm)

   Field := ControlByIndex( I ):CTRL007

   REPLACE &Field WITH _GetValue ( Controlname , ParentForm )

Return



********************************************************************************************************
* by Dr. Claudio Soto, January 2014
********************************************************************************************************


*-----------------------------------------------------------------------------*
Function RichEditBox_SetCaretPos ( hWndControl , nPos )
*-----------------------------------------------------------------------------*
Local aSelRange := { nPos, nPos}
   RichEditBox_SetSelRange ( hWndControl, aSelRange )
Return Nil


*-----------------------------------------------------------------------------*
Function RichEditBox_GetCaretPos ( hWndControl )
*-----------------------------------------------------------------------------*
Local aSelRange := RichEditBox_GetSelRange ( hWndControl )
Return aSelRange [2]


*-----------------------------------------------------------------------------*
Function RichEditBox_SelectAll ( hWndControl )
*-----------------------------------------------------------------------------*
Local aSelRange := { 0, -1}
   RichEditBox_SetSelRange ( hWndControl, aSelRange )
Return Nil


*-----------------------------------------------------------------------------*
Function RichEditBox_UnSelectAll ( hWndControl )
*-----------------------------------------------------------------------------*
Local nPos := RichEditBox_GetCaretPos ( hWndControl )
   RichEditBox_SetCaretPos ( hWndControl , nPos )
Return Nil



*---------------------------------------------------------------------------------------------------------*
FUNCTION RichEditBox_ReplaceText ( hWndControl, cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
*---------------------------------------------------------------------------------------------------------*
LOCAL lDown := .T.
LOCAL aPos  := {0,0}
   aPos := RichEditBox_GetSelRange ( hWndControl )
   RichEditBox_SetSelRange ( hWndControl, { aPos[1] , aPos[1] } )
   aPos := RichEditBox_FindText ( hWndControl, cFind, lDown, lMatchCase, lWholeWord, lSelectFindText )
   IF aPos[1] <> -1
      RichEditBox_SetSelRange ( hWndControl, aPos )
      RichEditBox_SetText ( hWndControl , .T. , cReplace )
      aPos := RichEditBox_FindText ( hWndControl, cFind, lDown, lMatchCase, lWholeWord, lSelectFindText )
   ENDIF
RETURN aPos


*------------------------------------------------------------------------------------------------------------*
FUNCTION RichEditBox_ReplaceAllText ( hWndControl, cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
*------------------------------------------------------------------------------------------------------------*
LOCAL aPos  := {0,0}
   WHILE aPos [1] <> -1
      aPos := RichEditBox_ReplaceText ( hWndControl, cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
      DO EVENTS
   ENDDO
RETURN aPos



*-----------------------------------------------------------------------------*
Function RichEditBox_AddTextAndSelect ( hWndControl , nPos, cText )
*-----------------------------------------------------------------------------*
Local StartCaretPos, EndCaretPos, DeltaCaretPos

   RichEditBox_SetCaretPos ( hWndControl , -1 )
   StartCaretPos := RichEditBox_GetCaretPos ( hWndControl )

   RichEditBox_SetText ( hWndControl, .T., cText )
   RichEditBox_SetCaretPos ( hWndControl , -1 )
   EndCaretPos := RichEditBox_GetCaretPos ( hWndControl )

   RichEditBox_SetSelRange ( hWndControl, { StartCaretPos, EndCaretPos } )

   IF nPos <= -1 .OR. nPos > EndCaretPos
      RichEditBox_SetSelRange ( hWndControl, { StartCaretPos, -1 } )
   ELSE
      DeltaCaretPos := EndCaretPos - StartCaretPos

      RichEditBox_SelClear ( hWndControl )

      RichEditBox_SetCaretPos ( hWndControl , nPos )
      RichEditBox_SetText ( hWndControl, .T., cText )
      RichEditBox_SetSelRange ( hWndControl, { nPos, nPos + DeltaCaretPos } )
   ENDIF

Return Nil




*----------------------------------------------------------------------------------------------------------*
Function RichEditBox_RTFPrint ( hWndControl, aSelRange, nLeft, nTop, nRight, nBottom, PrintPageCodeBlock )
*----------------------------------------------------------------------------------------------------------*
LOCAL nPageWidth, nPageHeight
LOCAL nNextChar := 0
LOCAL nTextLength := RichEditBox_GetTextLength ( hWndControl )

   DEFAULT aSelRange          TO { 0, -1 }   // select all text
   DEFAULT nLeft              TO 20          // Left   page margin in millimeters
   DEFAULT nTop               TO 20          // Top    page margin in millimeters
   DEFAULT nRight             TO 20          // Right  page margin in millimeters
   DEFAULT nBottom            TO 20          // Bottom page margin in millimeters
   DEFAULT PrintPageCodeBlock TO {|| NIL}

   nPageWidth  := OpenPrinterGetPageWidth()    // in millimeters
   nPageHeight := OpenPrinterGetPageHeight()   // in millimeters

   nRight  := nPageWidth  - nRight
   nBottom := nPageHeight - nBottom

   // Convert millimeters in twips ( 1 inch = 25.4 mm = 1440 twips )
   nLeft   := nLeft   * 1440 / 25.4
   nTop    := nTop    * 1440 / 25.4
   nRight  := nRight  * 1440 / 25.4
   nBottom := nBottom * 1440 / 25.4

   IF aSelRange [2] == -1 .OR. aSelRange [2] > nTextLength
      aSelRange [2] := nTextLength
   ENDIF

   START PRINTDOC
   DO WHILE nNextChar < nTextLength
      START PRINTPAGE
          EVAL ( PrintPageCodeBlock )
          nNextChar := RichEditBox_FormatRange ( hWndControl, OpenPrinterGetPageDC(), nLeft, nTop, nRight, nBottom, aSelRange )
          aSelRange [1] := nNextChar
          DO EVENTS
      END PRINTPAGE
   ENDDO
   END PRINTDOC

Return Nil



*-----------------------------------------------------------------------------*
FUNCTION RichEditBox_LoadFile( hWndControl, cFile, lSelection, nType )
*-----------------------------------------------------------------------------*
LOCAL lSuccess

   IF ValType( lSelection ) <> "L"
      lSelection := .F.
   ENDIF

   IF ValType( nType ) <> "N"
      nType := RICHEDITFILE_RTF
   ENDIF

   lSuccess := RichEditBox_RTFLoadResourceFile( hWndControl, cFile, lSelection )

   IF lSuccess == .F.
      RichEditBox_StreamIn( hWndControl, cFile, lSelection, nType )
   ENDIF

Return Nil



*-----------------------------------------------------------------------------*
FUNCTION RichEditBox_SaveFile( hWndControl, cFile, lSelection, nType )
*-----------------------------------------------------------------------------*
   IF ValType( lSelection ) <> "L"
      lSelection := .F.
   ENDIF

   IF ValType( nType ) <> "N"
      nType := RICHEDITFILE_RTF
   ENDIF

   RichEditBox_StreamOut( hWndControl, cFile, lSelection, nType )

Return Nil

