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

FUNCTION _DefineTimer ( ControlName ,ParentForm , Interval , ProcedureName )

   LOCAL mVar , k := 0
   LOCAL FontHandle, oControl
   LOCAL id

   IF oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
   ENDIF

   IF .NOT. _IsWindowDefined ( ParentForm )
      MsgHMGError( "Window: " + ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined ( ControlName, ParentForm )
      MsgHMGError ( "Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   Id := _GetId()
   InitTimer ( GetFormhandle(ParentForm) , id , Interval )

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "TIMER"
      :Name :=   ControlName
      :Handle :=   0
      :ParentFormHandle :=   GetFormhandle(HMG_UPPER(ParentForm))
      :CTRL005 :=   id
      :CTRL006 :=  ProcedureName
      :CTRL007 :=  {}
      :CTRL008 :=  Interval
      :CTRL009 :=  ""
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  ""
      :IsDeleted :=  .F.
      :CTRL014 := Nil
      :CTRL015 := Nil
      :CTRL016 := ""
      :CTRL017 := {}
      :CTRL018 :=  0
      :CTRL019 :=  0
      :CTRL020 := 0
      :CTRL021 :=  0
      :CTRL022 :=  0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=  ''
      :CTRL028 :=  0
      :CTRL029 :=  {.f.,.f.,.f.,.f.}
      :CTRL030 :=  ''
      :CTRL031 :=   0
      :CTRL032 :=   0
      :CTRL033 :=   ''
      :CTRL034 :=   .t.
      :CTRL035 :=   0
      :CTRL036 :=   FontHandle
      :CTRL037 :=  0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   RETURN Nil
