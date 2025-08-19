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

#include 'hmg.ch'
*------------------------------------------------------------------------------*
Procedure _DefineHotKey ( cParentForm , nMod , nKey , bAction )
*------------------------------------------------------------------------------*
Local nParentForm , nId , i , nControlCount , k := 0 , z, oControl

   If oHmgApp():APP264 = .T.
      cParentForm := oHmgApp():ActiveFormName
   EndIf

   If ValType ( cParentForm ) == 'U'
      MsgHMGError ("ON KEY: Parent Window Not Specified. Program Terminated")
   EndIf

   // Check if the window/form is defined.
   if ( .not. _IsWindowDefined( cParentForm ) )
      MsgHMGError( "Window: " + cParentForm + " is not defined. Program terminated." )
   Endif

   nParentForm := GetFormHandle ( cParentForm )
   nControlCount := oHmgApp():ControlCount
   z := GetFormIndex (cParentForm)

   For i := 1 To nControlCount
      If ControlByIndex( i ):Type == 'HOTKEY' .and. ControlByIndex( I ):ParentFormHandle == nParentForm .and. ControlByIndex( I ):CTRL007 == nMod .and. ControlByIndex( I ):CTRL008 == nKey
         _EraseControl(i,z)
         Exit
      EndIf
   Next i

   nId := _GetId()

   InitHotKey ( nParentForm , nMod , nKey , nId )

   k := _GetControlFree()

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type :=  "HOTKEY"
      :Name :=   ''
      :Handle := 0
      :ParentFormHandle :=   nParentForm
      :CTRL005 :=   nId
      :CTRL006 :=   bAction
      :CTRL007 :=   nMod
      :CTRL008 :=   nKey
      :CTRL009 :=   ""
      :CTRL010 :=   ""
      :CTRL011 :=  ""
      :CTRL012 :=   ""
      :IsDeleted :=   .F.
      :CTRL014 :=   Nil
      :CTRL015 :=   Nil
      :CTRL016 :=  ""
      :CTRL017 :=   {}
      :CTRL018 :=   0
      :CTRL019 :=  0
      :CTRL020 :=   0
      :CTRL021 :=   0
      :CTRL022 :=  0
      :CTRL023 :=   0
      :CTRL024 :=  0
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=  ''
      :CTRL028 :=   0
      :CTRL029 :=   {.f.,.f.,.f.,.f.}
      :CTRL030 :=   ''
      :CTRL031 :=   0
      :CTRL032 :=   0
      :CTRL033 :=   ''
      :CTRL034 :=   .t.
      :CTRL035 :=    0
      :CTRL036 :=    0
      :CTRL037 :=    0
      :CTRL038 :=    .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

Return
*------------------------------------------------------------------------------*
Procedure _ReleaseHotKey ( cParentForm, nMod , nKey )
*------------------------------------------------------------------------------*
Local i , nParentFormHandle , nControlCount , z

   nParentFormHandle := GetFormhandle ( cParentForm )
   nControlCount := oHmgApp():ControlCount
   z := GetFormIndex (cParentForm)

   For i := 1 To nControlCount
      If ControlByIndex( i ):Type == 'HOTKEY' .and. ControlByIndex( I ):ParentFormHandle == nParentFormHandle .and. ControlByIndex( I ):CTRL007 == nMod .and. ControlByIndex( I ):CTRL008 == nKey
         _EraseControl(i,z)
         Exit
      EndIf
   Next i

Return

*------------------------------------------------------------------------------*
Function _GetHotKey ( cParentForm, nMod , nKey )
*------------------------------------------------------------------------------*
Local i , nParentFormHandle , nControlCount , bRetVal := Nil

   nParentFormHandle := GetFormhandle ( cParentForm )
   nControlCount := oHmgApp():ControlCount

   For i := 1 To nControlCount
      If ControlByIndex( i ):Type == 'HOTKEY' .and. ControlByIndex( I ):ParentFormHandle == nParentFormHandle .and. ControlByIndex( I ):CTRL007 == nMod .and. ControlByIndex( I ):CTRL008 == nKey
         bRetVal := ControlByIndex( I ):CTRL006
         Exit
      EndIf
   Next i

Return ( bRetVal )


*------------------------------------------------------------------------------*
Function _PushKey (nKey)
*------------------------------------------------------------------------------*
   Keybd_Event ( nKey, .F. )
   Keybd_Event ( nKey, .T. )
Return Nil


//*******************************************
//* by Dr. Claudio Soto, April 2016
//*******************************************

//       HMG_PressKey( nVK1, nVK2, ... ) --> return array { nVK1, nVK2, ... }
FUNCTION HMG_PressKey( ... )
LOCAL i, aVK := {}

   FOR i := 1 TO PCount()
      IF ValType( PValue( i ) ) == "N"
         AADD( aVK, PValue( i ) )
      ELSE
         MsgHMGError ("HMG_PressKey: invalid parameter")
      ENDIF
      Keybd_Event( aVK[ i ], .F. )   // KeyDown
   NEXT

   FOR i := HMG_LEN( aVK ) TO 1 STEP -1
      Keybd_Event( aVK[ i ], .T. )   // KeyUp
   NEXT

RETURN aVK


