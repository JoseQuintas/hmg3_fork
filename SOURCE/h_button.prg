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


#define BUTTON_IMAGELIST_ALIGN_LEFT   0
#define BUTTON_IMAGELIST_ALIGN_RIGHT  1
#define BUTTON_IMAGELIST_ALIGN_TOP    2
#define BUTTON_IMAGELIST_ALIGN_BOTTOM 3
#define BUTTON_IMAGELIST_ALIGN_CENTER 4



*-----------------------------------------------------------------------------*
Function _DefineButton ( ControlName, ParentForm, x, y, Caption, ;
                         ProcedureName, w, h, fontname, fontsize, tooltip, ;
                         gotfocus, lostfocus, flat, NoTabStop, HelpId, ;
                         invisible , bold, italic, underline, strikeout , multiline )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , ControlHandle , FontHandle , k := 0 , cParentTabName
LOCAL oControl

   DEFAULT w         TO 100
   DEFAULT h         TO 28
   DEFAULT lostfocus TO ""
   DEFAULT gotfocus  TO ""
   DEFAULT invisible TO FALSE

   if oHmgApp():APP264 = TRUE
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
      cParentTabName := oHmgApp():APP225
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   Endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   ControlHandle := InitButton ( ParentForm, Caption, 0, x, y ,w ,h,'',0 , flat , NoTabStop, invisible , multiline )

   if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   Endif

   If oHmgApp():BeginTabActive = TRUE
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "BUTTON"
      :Name := ControlName
      :Handle := ControlHandle
      :ParentFormHandle := ParentForm
      :CTRL005 := 0
      :CTRL006 := ProcedureName
      :CTRL007 := {}
      :CTRL008 := Nil
      :CTRL009 := ""
      :CTRL010 := lostfocus
      :CTRL011 := gotfocus
      :CTRL012 := ""
      :IsDeleted := FALSE
      :CTRL014 := Nil
      :CTRL015 := Nil
      :CTRL016 := ""
      :CTRL017 := {}
      :CTRL018 := y
      :CTRL019 := x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := 'T'
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := ""
      :CTRL026 := 0
      :CTRL027 := fontname
      :CTRL028 := fontsize
      :CTRL029 := {bold,italic,underline,strikeout}
      :CTRL030 := tooltip
      :CTRL031 := cParentTabName
      :CTRL032 := 0
      :CTRL033 := Caption
      :CTRL034 := if(invisible,FALSE,TRUE)
      :CTRL035 := HelpId
      :CTRL036 := FontHandle
      :CTRL037 := 0
      :CTRL038 := .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

Return Nil


*-----------------------------------------------------------------------------*
Function _DefineImageButton ( ControlName, ParentForm, x, y, Caption, ;
                              ProcedureName, w, h, image, tooltip, gotfocus, ;
                              lostfocus, flat, notrans, HelpId, invisible, ;
                              notabstop )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , ControlHandle , k := 0
Local nhImage, oControl
Local aRet [2]
Local cParentTabName

   DEFAULT invisible TO FALSE
   DEFAULT notabstop TO FALSE

   if oHmgApp():APP264 = TRUE
      ParentForm := oHmgApp():ActiveFormName
   endif

   if oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
      x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
      y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
      ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      cParentTabName := oHmgApp():APP225
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program terminated" )
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   if ( IsAppThemed() )
      aRet := InitImageButton ( ParentForm, Caption, 0, x, y, w, h, image , flat , notrans, invisible, notabstop , .T. )
   else
      aRet := InitImageButton ( ParentForm, Caption, 0, x, y, w, h, image , flat , notrans, invisible, notabstop , .F. )
   endif

   ControlHandle := aRet [1]
   nhImage := aRet [2]

   If oHmgApp():BeginTabActive = TRUE
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "BUTTON"
      :Name :=   ControlName
      :Handle :=   ControlHandle
      :ParentFormHandle :=   ParentForm
      :CTRL005 :=   0
      :CTRL006 :=   ProcedureName
      :CTRL007 :=   {}
      :CTRL008 :=   Nil
      :CTRL009 :=   ""
      :CTRL010 :=   lostfocus
      :CTRL011 :=   gotfocus
      :CTRL012 :=   ""
      :IsDeleted :=   FALSE
      :CTRL014 :=   NIL
      :CTRL015 :=   Nil
      :CTRL016 :=  ""
      :CTRL017 :=   {}
      :CTRL018 :=   y
      :CTRL019 :=   x
      :CTRL020 :=   w
      :CTRL021 :=   h
      :CTRL022 :=   'I'
      :CTRL023 :=   iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=   iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=   image
      :CTRL026 :=   BUTTON_IMAGELIST_ALIGN_CENTER
      :CTRL027 :=   ''
      :CTRL028 :=   0
      :CTRL029 :=   {.f.,.f.,.f.,.f.}
      :CTRL030 :=    tooltip
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  notrans // ADD
      :CTRL033 :=    Caption
      :CTRL034 :=    if(invisible,FALSE,TRUE)
      :CTRL035 :=    HelpId
      :CTRL036 :=    0
      :CTRL037 := nhImage
      :CTRL038 :=    .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

Return Nil


*-----------------------------------------------------------------------------*
Function _DefineMixedButton ( ControlName, ParentForm, x, y, Caption, ;
         ProcedureName, w, h, fontname, fontsize, tooltip, ;
         gotfocus, lostfocus, flat, NoTabStop, HelpId, ;
         invisible , bold, italic, underline, strikeout , ;
         picture , alignment , multiline, notrans )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , ControlHandle , FontHandle , k := 0 , cParentTabName
Local aRet := {}, oControl
Local aWinver := WindowsVersion()

   if   aWinver [1] = 'Windows 95' ;
      .Or. ;
      aWinver [1] = 'Windows 98' ;
      .Or. ;
      aWinver [1] = 'Windows Me' ;
      .Or. ;
      aWinver [1] = 'Windows NT' ;
      .Or. ;
      aWinver [1] = 'Windows 2000' ;
      .Or. ;
      aWinver [1] = 'Windows Server 2003 family'

      _DefineButton ( ControlName, ParentForm, x, y, Caption, ;
                         ProcedureName, w, h, fontname, fontsize, tooltip, ;
                         gotfocus, lostfocus, flat, NoTabStop, HelpId, ;
                         invisible , bold, italic, underline, strikeout , multiline )
      Return Nil

   endif

DEFAULT w         TO 100
DEFAULT h         TO 28
DEFAULT lostfocus TO ""
DEFAULT gotfocus  TO ""
DEFAULT invisible TO FALSE


   if valtype (alignment) = 'U'
      alignment := BUTTON_IMAGELIST_ALIGN_TOP
   elseif valtype (alignment) = 'C'
      if   ALLTRIM(HMG_UPPER(alignment)) == 'LEFT'
         alignment := BUTTON_IMAGELIST_ALIGN_LEFT
      elseif   ALLTRIM(HMG_UPPER(alignment)) == 'RIGHT'
         alignment := BUTTON_IMAGELIST_ALIGN_RIGHT
      elseif   ALLTRIM(HMG_UPPER(alignment)) == 'TOP'
         alignment := BUTTON_IMAGELIST_ALIGN_TOP
      elseif   ALLTRIM(HMG_UPPER(alignment)) == 'BOTTOM'
         alignment := BUTTON_IMAGELIST_ALIGN_BOTTOM
      else
         alignment := BUTTON_IMAGELIST_ALIGN_TOP
      endif
   else
      alignment := BUTTON_IMAGELIST_ALIGN_TOP
   endif

   if oHmgApp():APP264 = TRUE
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
      cParentTabName := oHmgApp():APP225
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   Endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   aRet := InitMixedButton ( ParentForm, Caption, 0, x, y, w, h, '', 0, flat, NoTabStop, invisible, picture, alignment, multiline, notrans )

   ControlHandle := aRet [1]

   if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   Endif

   If oHmgApp():BeginTabActive = TRUE
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "BUTTON"
      :Name := ControlName
      :Handle := ControlHandle
      :ParentFormHandle := ParentForm
      :CTRL005 := 0
      :CTRL006 := ProcedureName
      :CTRL007 := {}
      :CTRL008 := Nil
      :CTRL009 := ""
      :CTRL010 := lostfocus
      :CTRL011 := gotfocus
      :CTRL012 := ""
      :IsDeleted := FALSE
      :CTRL014 := NIL
      :CTRL015 := Nil
      :CTRL016 := ""
      :CTRL017 := {}
      :CTRL018 := y
      :CTRL019 := x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := 'M'
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := picture
      :CTRL026 := alignment
      :CTRL027 := fontname
      :CTRL028 := fontsize
      :CTRL029 := {bold,italic,underline,strikeout}
      :CTRL030 := tooltip
      :CTRL031 := cParentTabName
      :CTRL032 := notrans // ADD
      :CTRL033 := Caption
      :CTRL034 := if(invisible,FALSE,TRUE)
      :CTRL035 := HelpId
      :CTRL036 := FontHandle
      :CTRL037 := aRet [2]
      :CTRL038 := .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

Return Nil

