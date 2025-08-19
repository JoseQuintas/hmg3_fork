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

FUNCTION _DefineMonthCal ( ControlName, ParentForm, x, y, w, h, value, ;
      fontname, fontsize, tooltip, notoday, notodaycircle, ;
      weeknumbers, change, HelpId, invisible, notabstop, ;
      bold, italic, underline, strikeout )
   *-----------------------------------------------------------------------------*
   LOCAL cParentForm , mVar , k := 0
   LOCAL aControlHandle, oControl
   LOCAL cParentTabName

   DEFAULT value     TO Date()
   DEFAULT change    TO ""
   DEFAULT bold      TO FALSE
   DEFAULT italic    TO FALSE
   DEFAULT underline TO FALSE
   DEFAULT strikeout TO FALSE

   IF oHmgApp():APP264 = .T.
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
         cParentTabName := oHmgApp():APP225
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program terminated")
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
      aControlHandle := InitMonthCal ( ParentForm, 0, x, y, w, h , fontname , fontsize , notoday , notodaycircle , weeknumbers, invisible, notabstop, bold, italic, underline, strikeout )
   ELSE
      aControlHandle := InitMonthCal ( ParentForm, 0, x, y, w, h , oHmgApp():APP342 , oHmgApp():APP343 , notoday , notodaycircle , weeknumbers, invisible, notabstop, bold, italic, underline, strikeout )
   ENDIF

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , aControlhandle[1] )
   ENDIF

   SetMonthCal( aControlHandle[1] ,year(value), Month(value), Day(value) )

   IF valtype(tooltip) != "U"
      SetToolTip ( aControlHandle[1] , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   w := GetWindowWidth ( aControlHandle[1] )
   h := GetWindowHeight ( aControlHandle[1] )

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "MONTHCAL"
      :Name :=  ControlName
      :Handle :=  aControlHandle[1]
      :ParentFormHandle :=   ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  ""
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  change
      :IsDeleted :=  .F.
      :CTRL014 :=  Nil
      :CTRL015 :=  Nil
      :CTRL016 :=  ""
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
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  tooltip
      :CTRL031 :=   cParentTabName
      :CTRL032 :=   0
      :CTRL033 :=  ''
      :CTRL034 :=   if(invisible,FALSE,TRUE)
      :CTRL035 :=   HelpId
      :CTRL036 :=   aControlHandle[2]
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   RETURN Nil

   // by Dr. Claudio Soto (April 2013)

FUNCTION GetMonthCalendarColor (cControlName, cParentName, nIndexColor)

   LOCAL RGBcolorRef := DATETIME_GETMONTHCALCOLOR (GetControlHandle (cControlName, cParentName), nIndexColor)

   RETURN { GETRED (RGBcolorRef), GETGREEN (RGBcolorRef), GETBLUE (RGBcolorRef) }

   // by Dr. Claudio Soto (April 2013)

FUNCTION SetMonthCalendarColor (cControlName, cParentName, nIndexColor, aRGBcolor)

   LOCAL RGBcolorRef := DATETIME_SETMONTHCALCOLOR (GetControlHandle (cControlName, cParentName), nIndexColor, RGB (aRGBcolor[1], aRGBcolor[2], aRGBcolor[3]))

   RETURN { GETRED (RGBcolorRef), GETGREEN (RGBcolorRef), GETBLUE (RGBcolorRef) }
