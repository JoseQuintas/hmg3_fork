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
#include "hmg.ch"
#include "common.ch"
*-----------------------------------------------------------------------------*

FUNCTION _DefineListbox ( ControlName, ParentForm, x, y, w, h, rows, value, ;
      fontname, fontsize, tooltip, changeprocedure, ;
      dblclick, gotfocus, lostfocus, break, HelpId, ;
      invisible, notabstop, sort , bold, italic, ;
      underline, strikeout , backcolor , fontcolor , ;
      multiselect , dragitems )
   *-----------------------------------------------------------------------------*
   LOCAL i , cParentForm , mVar , ControlHandle, oControl
   LOCAL FontHandle , k := 0

   DEFAULT w               TO 120
   DEFAULT h               TO 120
   DEFAULT gotfocus        TO ""
   DEFAULT lostfocus       TO ""
   DEFAULT rows            TO {}
   DEFAULT value           TO 0
   DEFAULT changeprocedure TO ""
   DEFAULT dblclick        TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE
   DEFAULT sort            TO FALSE

   IF oHmgApp():APP264 = TRUE
      ParentForm := oHmgApp():ActiveFormName
      IF .NOT. Empty (oHmgApp():APP224) .AND. ValType(FontName) == "U"
         FONTNAME := oHmgApp():APP224
      ENDIF
      IF .NOT. Empty ( oHmgApp():ActiveFontSize ) .AND. ValType(FontSize) == "U"
         FONTSIZE := oHmgApp():ActiveFontSize
      ENDIF
   ENDIF

   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   ENDIF

   mVar := "_" + ParentForm + "_" + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   IF valtype(x) == "U" .OR. valtype(y) == "U"

      IF oHmgApp():APP216 == "TOOLBAR"
         Break := TRUE
      ENDIF

      i := GetFormIndex ( cParentForm )

      IF i > 0

         IF multiselect == .t.
            ControlHandle := InitMultiListBox ( FormByIndex( I ):FORM087, 0, x, y, w, h, fontname, fontsize, invisible, notabstop, sort , dragitems )
         ELSE
            ControlHandle := InitListBox ( FormByIndex( I ):FORM087 , 0 , 0 , 0 , w , h , '' , 0 , invisible , notabstop, sort , dragitems )
         ENDIF

         IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
            FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
         ELSE
            FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
         ENDIF

         AddSplitBoxItem ( Controlhandle , FormByIndex( I ):FORM087 , w , break , , , , oHmgApp():APP258 )

         oHmgApp():APP216   := "LISTBOX"

      ENDIF

   ELSE

      IF multiselect == .t.
         ControlHandle := InitMultiListBox ( ParentForm, 0, x, y, w, h, fontname, fontsize, invisible, notabstop, sort , dragitems )
      ELSE
         ControlHandle := InitListBox ( ParentForm , 0 , x , y , w , h , '' , 0 , invisible , notabstop, sort , dragitems )
      ENDIF

      IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
      ELSE
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
      ENDIF

   ENDIF

   IF oHmgApp():BeginTabActive = TRUE
      aAdd ( oHmgApp():APP142 , ControlHandle )
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := IF ( multiselect , "MULTILIST" , "LIST" )
      :Name :=  ControlName
      :Handle :=  ControlHandle
      :ParentFormHandle :=  ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  ""
      :CTRL010 :=  lostfocus
      :CTRL011 :=  gotfocus
      :CTRL012 :=  ChangeProcedure
      :IsDeleted :=  FALSE
      :CTRL014 :=  backcolor
      :CTRL015 :=  fontcolor
      :CTRL016 :=  dblclick
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 := x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := 0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := ""
      :CTRL026 :=  0
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  tooltip
      :CTRL031 :=  0
      :CTRL032 :=   0
      :CTRL033 :=  ""
      :CTRL034 :=   if(invisible,FALSE,TRUE)
      :CTRL035 :=  HelpId
      :CTRL036 :=   FontHandle
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   FOR i = 1 to HMG_LEN (rows)
      ListboxAddString (ControlHandle,rows[i])
   NEXT x

   IF multiselect == .t.
      IF value <> Nil
         LISTBOXSETMULTISEL (ControlHandle,Value)
      ENDIF
   ELSE
      IF value <> 0
         ListboxSetCurSel (ControlHandle,Value)
      ENDIF
   ENDIF

   RETURN Nil
