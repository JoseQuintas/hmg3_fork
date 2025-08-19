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
#define BM_GETCHECK      240   // ok
#define BST_UNCHECKED    0     // ok
#define BST_CHECKED      1     // ok
#define BM_SETCHECK      241   // ok
#include "hmg.ch"
#include "common.ch"
*-----------------------------------------------------------------------------*
Function _DefineCheckBox ( ControlName, ParentForm, x, y, Caption, Value, ;
                           fontname, fontsize, tooltip, changeprocedure, w, h,;
                           lostfocus, gotfocus, HelpId, invisible, notabstop , bold, italic, underline, strikeout , field  , backcolor , fontcolor , transparent, OnEnter )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k := 0
Local ControlHandle, oControl
Local FontHandle
Local WorkArea
Local cParentTabName := ''
Local cParentWindowName := ''

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

   If ValType ( Field ) != 'U'
      if  HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
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
      ParentForm   := oHmgApp():APP332 [ oHmgApp():FrameLevel ]

      cParentTabName := oHmgApp():APP225
      cParentWindowName := ParentForm
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   Controlhandle := InitCheckBox ( ParentForm, Caption, 0, x, y, '', 0 , w , h, invisible, notabstop )

   if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   endif

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "CHECKBOX"
      :Name :=   ControlName
      :Handle :=   ControlHandle
      :ParentFormHandle :=   ParentForm
      :CTRL005 :=   0
      :CTRL006 :=   OnEnter
      :CTRL007 :=   Field
      :CTRL008 :=   Nil
      :CTRL009 :=   transparent
      :CTRL010 :=   lostfocus
      :CTRL011 :=   gotfocus
      :CTRL012 :=   changeprocedure
      :IsDeleted :=   .F.
      :CTRL014 :=   backcolor
      :CTRL015 :=   fontcolor
      :CTRL016 :=   oHmgApp():ActiveTabButtons
      :CTRL017 :=   {}
      :CTRL018 :=  y
      :CTRL019 :=   x
      :CTRL020 :=  w
      :CTRL021 :=   h
      :CTRL022 :=  0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=   tooltip
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  cParentWindowName
      :CTRL033 :=  Caption
      :CTRL034 :=  if(invisible,FALSE,TRUE)
      :CTRL035 :=  HelpId
      :CTRL036 := FontHandle
      :CTRL037 :=  0
      :CTRL038 :=  .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   if value = .t.
           SendMessage( Controlhandle , BM_SETCHECK  , BST_CHECKED , 0 )
   endif

   if valtype ( Field ) != 'U'
      if k > 0
         aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , k )
      Else
         aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , oHmgApp():ControlCount )
      EndIf
   EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _DefineCheckButton ( ControlName, ParentForm, x, y, Caption, Value, ;
                              fontname, fontsize, tooltip, changeprocedure, ;
                              w, h, lostfocus, gotfocus, HelpId, invisible, ;
                              notabstop , bold, italic, underline, strikeout, OnEnter )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k
Local ControlHandle
Local FontHandle, oControl

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

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
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   Controlhandle := InitCheckButton ( ParentForm, Caption, 0, x, y, '', 0 , w , h, invisible, notabstop )

   if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   endif

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , ControlHandle )
   EndIf

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "CHECKBOX"
      :Name :=   ControlName
      :Handle :=   ControlHandle
      :ParentFormHandle :=   ParentForm
      :CTRL005 :=   0
      :CTRL006 :=  OnEnter
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 := ""
      :CTRL010 :=  lostfocus
      :CTRL011 :=  gotfocus
      :CTRL012 :=  changeprocedure
      :IsDeleted :=  .F.
      :CTRL014 := Nil
      :CTRL015 := Nil
      :CTRL016 := ""
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 := x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := 0
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 := fontname
      :CTRL028 := fontsize
      :CTRL029 := {bold,italic,underline,strikeout}
      :CTRL030 :=   tooltip
      :CTRL031 :=  0
      :CTRL032 :=  0
      :CTRL033 :=  Caption
      :CTRL034 :=   if(invisible,FALSE,TRUE)
      :CTRL035 :=   HelpId
      :CTRL036 :=  FontHandle
      :CTRL037 :=  0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   if value = .t.
           SendMessage( Controlhandle , BM_SETCHECK  , BST_CHECKED , 0 )
   endif

Return Nil
*-----------------------------------------------------------------------------*
Function _DefineImageCheckButton ( ControlName, ParentForm, x, y, Picture, ;
                                   Value, fontname, fontsize, tooltip, ;
                                   changeprocedure, w, h, lostfocus, gotfocus,;
                                   HelpId, invisible, notabstop, notrans, OnEnter )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k := 0, oControl
Local ControlHandle
Local aRet

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

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
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   if IsAppThemed ()
      aRet := InitImageCheckButton ( ParentForm, "", 0, x, y, '', 0, Picture, w, h, invisible, notabstop, .T., notrans )
      Controlhandle := aRet [1]
   else
      aRet := InitImageCheckButton ( ParentForm, "", 0, x, y, '', 0, Picture, w, h, invisible, notabstop, .F., notrans )
      Controlhandle := aRet [1]
   endif

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , ControlHandle )
   EndIf

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( K )

   WITH OBJECT oControl
      :Type :=  "CHECKBOX"
      :Name :=  ControlName
      :Handle :=  ControlHandle
      :ParentFormHandle :=  ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  OnEnter
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  ""
      :CTRL010 :=  lostfocus
      :CTRL011 :=  gotfocus
      :CTRL012 :=  changeprocedure
      :IsDeleted :=  .F.
      :CTRL014 :=  Nil
      :CTRL015 :=  Nil
      :CTRL016 :=  ""
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 :=  x
      :CTRL020 :=  w
      :CTRL021 :=  h
      :CTRL022 :=  0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  Picture
      :CTRL026 :=  4 // BUTTON_IMAGELIST_ALIGN_CENTER
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {.f.,.f.,.f.,.f.}
      :CTRL030 :=  tooltip
      :CTRL031 :=  0
      :CTRL032 :=  notrans // ADD
      :CTRL033 :=  ''
      :CTRL034 :=  if (invisible,FALSE,TRUE)
      :CTRL035 :=  HelpId
      :CTRL036 :=  0
      :CTRL037 :=  aRet [2]
      :CTRL038 :=  .T.
      :CTRL039 :=  1
      :CTRL040 :=  { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   if value = .t.
          SendMessage( Controlhandle , BM_SETCHECK  , BST_CHECKED , 0 )
   endif

Return Nil

Procedure _DataCheckBoxRefresh (i)
Local Field

   Field      := ControlByIndex( I ):CTRL007
   _SetValue ( '' , '' , &Field , i )

Return

Procedure _DataCheckBoxSave ( ControlName , ParentForm)
Local Field , i

   i := GetControlIndex ( ControlName , ParentForm)

   Field := ControlByIndex( I ):CTRL007

   REPLACE &Field WITH _GetValue ( Controlname , ParentForm )

Return

