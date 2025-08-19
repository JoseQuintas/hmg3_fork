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
//#include "hfcl.ch"
#include "common.ch"

*-----------------------------------------------------------------------------*
Function _DefineImage ( ControlName, ParentForm, x, y, FileName, w, h, ProcedureName, HelpId, invisible, stretch, transparent, aBKColor, adjustimage, aTranspColor, cToolTip )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k := 0, lActionTooltip, oControl
Local ControlHandle, BackgroundColor, TransparentColor

   if oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
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


   IF ValType(w) == "U" .OR. w == 0
      w := -1
   ENDIF

   IF ValType(h) == "U" .OR. h == 0
      h := -1
   ENDIF

   IF ValType (aBKColor) <> "A"
      BackgroundColor := -1
   ELSE
      BackgroundColor := RGB (aBKColor[1], aBKColor[2], aBKColor[3])
   ENDIF

   IF ValType (aTranspColor) <> "A"
      TransparentColor := -1
   ELSE
      TransparentColor := RGB (aTranspColor[1], aTranspColor[2], aTranspColor[3])
   ENDIF

   IF ValType (ProcedureName) <> "U" .OR. ValType (cToolTip) <> "U"
      lActionTooltip := .T.
   ELSE
      lActionTooltip := .F.
   ENDIF

   if valtype(ProcedureName) == "U"
      ProcedureName := ""
   endif

   ControlHandle := InitImage ( ParentForm, x, y, invisible, lActionTooltip )

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , ControlHandle )
   EndIf


   if ValType( cToolTip ) != "U"
      SetToolTip ( ControlHandle , cToolTip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( K )

   WITH OBJECT oControl
      :Type :=   "IMAGE"
      :Name :=   ControlName
      :Handle :=   ControlHandle
      :ParentFormHandle :=   ParentForm
      :CTRL005 :=   0
      :CTRL006 :=   ProcedureName
      :CTRL007 :=   {}
      :CTRL008 :=   if ( stretch == .t. , 1 , 0 )
      :CTRL009 :=   ""
      :CTRL010 :=   ""
      :CTRL011 :=   ""
      :CTRL012 :=   ""
      :IsDeleted :=   .F.   // Is Deleted
      :CTRL014 :=   Nil
      :CTRL015 :=   Nil
      :CTRL016 :=   ""
      :CTRL017 :=   {}
      :CTRL018 :=   y
      :CTRL019 :=   x
      :CTRL020 :=   w
      :CTRL021 :=   h
      :CTRL022 :=   0
      :CTRL023 :=   if ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=   if ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=   FileName
      :CTRL026 :=   BackgroundColor
      :CTRL027 :=   ''
      :CTRL028 :=   TransparentColor
      :CTRL029 :=   {.f.,.f.,.f.,.f.}
      :CTRL030 :=   cToolTip
      :CTRL031 :=   w   // original Width
      :CTRL032 :=   h   // original Height
      :CTRL033 :=   ''
      :CTRL034 :=   if( invisible, .f., .t.)
      :CTRL035 :=   HelpId
      :CTRL036 :=   if ( adjustimage == .t. , 1 , 0)
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 :=   if ( transparent == .t. , 1 , 0 )
      :CTRL040 :=   { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

      // Dr. Claudio Soto (May 2013)
      :CTRL037 :=   C_SetPicture    ( ControlHandle , FileName , w , h , if ( stretch == .t. , 1 , 0 ) , if ( transparent == .t. , 1 , 0 ), BackgroundColor, if ( adjustimage == .t. , 1 , 0), TransparentColor)
      :CTRL020 :=   GetWindowWidth  ( ControlHandle )
      :CTRL021 :=   GetWindowHeight ( ControlHandle )

   ENDWITH

Return Nil




// by Dr. Claudio Soto (August 2013)

// HMG_GetImageInfo ( [ cFileName | hBitmap ], @nWidth, @nHeight, @aBackColor, [ nRowColor ], [ nColColor ] ) --> Return lBoolean

*-------------------------------------------------------------------------------------------*
FUNCTION HMG_GetImageInfo ( xFile, nWidth, nHeight, aBackColor, nRowColor, nColColor )
*-------------------------------------------------------------------------------------------*
LOCAL hBitmap, cFileName, hDC, BTstruct

   DEFAULT nRowColor TO 0
   DEFAULT nColColor TO 0

   IF HB_ISNUMERIC (xFile)
      hBitmap := xFile
   ELSE
      cFileName := xFile
      hBitmap  := BT_BitmapLoadFile (cFileName)
   ENDIF

   IF hBitmap == 0
      RETURN .F.
   ENDIF

   nWidth   := BT_BitmapWidth  (hBitmap)
   nHeight  := BT_BitmapHeight (hBitmap)

   hDC := BT_CreateDC (hBitmap, BT_HDC_BITMAP, @BTstruct)
       aBackColor := BT_DrawGetPixel (hDC, nRowColor, nColColor)
   BT_DeleteDC (BTstruct)

   BT_BitmapRelease (hBitmap)
RETURN .T.
