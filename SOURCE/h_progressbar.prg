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

FUNCTION _DefineProgressBar ( ControlName, ParentForm, x, y, w, h, lo, hi, ;
      tooltip, vertical, smooth, HelpId, invisible, ;
      value, BackColor, BarColor )

   LOCAL cParentForm, mVar, ControlHandle , k := 0, oControl

   DEFAULT h         TO if( vertical, 120, 25 )
   DEFAULT w         TO if( vertical, 25, 120 )
   DEFAULT lo        TO 0
   DEFAULT hi        TO 100
   DEFAULT value     TO 0
   DEFAULT invisible TO FALSE

   IF oHmgApp():APP264 = TRUE
      ParentForm := oHmgApp():ActiveFormName
   ENDIF

   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined ( ParentForm )
      MsgHMGError("Window: " + ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined ( ControlName,ParentForm )
      MsgHMGError ( "Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   ControlHandle := InitProgressBar ( ParentForm, 0, x, y, w, h ,lo ,hi, vertical, smooth, invisible, value )

   IF oHmgApp():BeginTabActive = TRUE
      aAdd ( oHmgApp():APP142 , Controlhandle )
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      oControl:Type := "PROGRESSBAR"
      oControl:Name :=   ControlName
      oControl:Handle :=  ControlHandle
      oControl:ParentFormHandle :=   ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  ""
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  ""
      :IsDeleted :=  FALSE
      :CTRL014 :=  BackColor
      :CTRL015 :=  BarColor
      :CTRL016 :=  ""
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 := x
      :CTRL020 :=  w
      :CTRL021 := h
      :CTRL022 := 0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=   ''
      :CTRL028 :=  0
      :CTRL029 :=  {FALSE,FALSE,FALSE,FALSE}
      :CTRL030 :=   tooltip
      :CTRL031 :=   Lo
      :CTRL032 :=   Hi
      :CTRL033 :=   ''
      :CTRL034 :=   if(invisible,FALSE,TRUE)
      :CTRL035 :=   HelpId
      :CTRL036 :=   0
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   IF BackColor <> Nil
      IF BackColor[1] <> Nil .AND. BackColor[2] <> Nil .AND. BackColor[3] <> Nil
         SetProgressBarBkColor(ControlHandle,BackColor[1],BackColor[2],BackColor[3])
      ENDIF
   ENDIF

   IF BarColor <> Nil
      IF BarColor[1] <> Nil .AND. BarColor[2] <> Nil .AND. BarColor[3] <> Nil
         SetProgressBarBarColor(ControlHandle,BarColor[1],BarColor[2],BarColor[3])
      ENDIF
   ENDIF

   RETURN Nil
