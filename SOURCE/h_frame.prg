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

FUNCTION _DefineFrame ( ControlName, ParentForm, x, y, w, h , caption , fontname , fontsize , opaque , bold, italic, underline, strikeout , backcolor , fontcolor , transparent )

   LOCAL cParentForm , mVar , k := 0
   LOCAL ControlHandle, oControl
   LOCAL FontHandle
   LOCAL cParentTabName := ''
   LOCAL cParentWindowName := ''


   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   Controlhandle := InitFrame ( ParentForm, 0, x, y, w, h , caption , '' , 0 , .F. )

   if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   endif

   if oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
      cParentTabName := oHmgApp():APP225
      cParentWindowName := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   endif

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   k := _GetControlFree()

   PUBLIC &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "FRAME"
      :Name :=  ControlName
      :Handle :=  ControlHandle
      :ParentFormHandle :=  ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  transparent
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  ""
      :IsDeleted :=  .F.
      :CTRL014 :=  backcolor
      :CTRL015 :=  fontcolor
      :CTRL016 :=  oHmgApp():ActiveTabButtons
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 :=  x
      :CTRL020 :=  w
      :CTRL021 := h
      :CTRL022 := 0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  ''
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  cParentWindowName
      :CTRL033 :=   Caption
      :CTRL034 :=   .t.
      :CTRL035 :=  0
      :CTRL036 :=   FontHandle
      :CTRL037 :=  Opaque
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   RETURN Controlhandle

FUNCTION _BeginFrame( name , parent , row , col , w , h , caption , fontname , fontsize , opaque , bold, italic, underline, strikeout , backcolor , fontcolor , transparent )

   if oHmgApp():APP264 = .T.
      if .Not. Empty (oHmgApp():APP224) .And. ValType(FontName) == "U"
         FontName := oHmgApp():APP224
      EndIf
      if .Not. Empty ( oHmgApp():ActiveFontSize ) .And. ValType(FontSize) == "U"
         FontSize := oHmgApp():ActiveFontSize
      EndIf
   endif

   if oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         col      := col + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         row      := row + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         Parent   := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   EndIf

   if valtype (parent) == 'U'
      parent := oHmgApp():ActiveFormName
   EndIf

   if valtype (caption) == 'U'
      caption  := ""
      fontname := "Arial"
      fontsize := 1
   EndIf

   if valtype (w) == 'U'
      w := 140
   EndIf

   if valtype (h) == 'U'
      h := 140
   EndIf

   _DefineFrame ( name , parent , col , row , w , h , caption , fontname , fontsize , opaque , bold, italic, underline, strikeout , backcolor , fontcolor , transparent )

   RETURN Nil

