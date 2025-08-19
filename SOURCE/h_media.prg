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
*-----------------------------------------------------------------------------*

FUNCTION _DefinePlayer(ControlName,ParentForm,file,col,row,w,h,noasw,noasm,noed,nom,noo,nop,sha,shm,shn,shp , HelpId )

   *-----------------------------------------------------------------------------*
   LOCAL hh , mVar , k := 0, oControl

   IF oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
   ENDIF

   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         COL    := col + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         ROW    := row + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   Hh :=InitPlayer ( GetFormHandle(ParentForm)   , ;
      file             , ;
      COL             , ;
      ROW            , ;
      w            , ;
      h            , ;
      noasw            , ;
      noasm            , ;
      noed            , ;
      nom            , ;
      noo            , ;
      nop            , ;
      sha            , ;
      shm            , ;
      shn            , ;
      shp )

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , hh )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "PLAYER"
      :Name :=  ControlName
      :Handle :=  hh
      :ParentFormHandle :=  GetFormHandle(ParentForm)
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  ""
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  ""
      :IsDeleted :=  .F.
      :CTRL014 :=  Nil
      :CTRL015 :=  Nil
      :CTRL016 := ""
      :CTRL017 :=  {}
      :CTRL018 :=  row
      :CTRL019 :=  col
      :CTRL020 := w
      :CTRL021 :=  h
      :CTRL022 := 0
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
      :CTRL035 :=   HelpId
      :CTRL036 :=   0
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION PlayWave(wave,r,s,ns,l,nd)

   *-----------------------------------------------------------------------------*
   IF PCount() == 1
      r := .F.
      s := .F.
      ns := .F.
      l := .F.
      nd := .F.
   ENDIF

   c_PlayWave(wave,r,s,ns,l,nd)

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION PlayWaveFromResource(wave)

   *-----------------------------------------------------------------------------*
   c_PlayWave(wave,.t.,.f.,.f.,.f.,.f.)

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _PlayPlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 1 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _StopPlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 2 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _PausePlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 3 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _ClosePlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 4 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _DestroyPlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 5 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _EjectPlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 6 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerPositionEnd ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 7 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerPositionHome ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 8 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _OpenPlayer ( ControlName , ParentForm, file )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 9, file )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _OpenPlayerDialog ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 10 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _PlayPlayerReverse ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 11 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _ResumePlayer ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 12 )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerRepeatOn ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 13 , .T. )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerRepeatOff ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 13 , .F. )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerSpeed ( ControlName , ParentForm , speed )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , , 14 , speed )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerVolume ( ControlName , ParentForm , volume )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 15 , volume )

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerZoom ( ControlName , ParentForm , zoom )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 16 , zoom )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _SetPlayerSeek ( ControlName , ParentForm , seek )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   mcifunc ( h , 20 , seek )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _GetPlayerLength ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar, nMCILength

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   nMCILength := mcifunc ( h , 17 )
   Return( nMCILength )
   *-----------------------------------------------------------------------------*

FUNCTION _GetPlayerPosition ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar, nMCIPosition

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   nMCIPosition := mcifunc ( h , 18 )
   Return( nMCIPosition )

   *-----------------------------------------------------------------------------*

FUNCTION _GetPlayerVolume ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar, nMCIVolume

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   nMCIVolume := mcifunc ( h , 19 )
   Return( nMCIVolume )

   *-----------------------------------------------------------------------------*

FUNCTION _DefineAnimateBox(ControlName,ParentForm,col,row,w,h,autoplay,center,transparent,file , HelpId )

   *-----------------------------------------------------------------------------*
   LOCAL hh , mVar , k := 0, oControl

   IF oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
   ENDIF

   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         COL    := col + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         ROW    := row + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   hh:=InitAnimate(GetFormHandle(ParentForm),col,row,w,h,autoplay,center,transparent)

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , hh )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "ANIMATEBOX"
      :Name :=  ControlName
      :Handle :=  hh
      :ParentFormHandle := GetFormHandle(ParentForm)
      :CTRL005 := 0
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  Nil
      :CTRL009 :=  ""
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  ""
      :IsDeleted :=  .F.
      :CTRL014 :=  Nil
      :CTRL015 :=  Nil
      :CTRL016 :=  ""
      :CTRL017 :=  {}
      :CTRL018 :=  row
      :CTRL019 :=  col
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := 0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 := 0
      :CTRL027 :=  ''
      :CTRL028 :=  0
      :CTRL029 :=  {.f.,.f.,.f.,.f.}
      :CTRL030 :=  ''
      :CTRL031 :=   0
      :CTRL032 :=   0
      :CTRL033 :=   ''
      :CTRL034 :=   .t.
      :CTRL035 :=   HelpId
      :CTRL036 :=  0
      :CTRL037 :=   0
      :CTRL038 :=  .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   IF valtype(file) <> 'U'
      _OpenAnimateBox ( ControlName , ParentForm , File )
   ENDIF

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _OpenAnimateBox ( ControlName , ParentForm , FileName )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   openanimate ( h , FileName )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _PlayAnimateBox ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   playanimate ( h )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _SeekAnimateBox ( ControlName , ParentForm , Frame )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   seekanimate ( h , Frame )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _StopAnimateBox ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   stopanimate ( h )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _CloseAnimateBox ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   closeanimate ( h )

   RETURN Nil

   *-----------------------------------------------------------------------------*

FUNCTION _DestroyAnimateBox ( ControlName , ParentForm )

   *-----------------------------------------------------------------------------*
   LOCAL h , mVar

   mVar := '_' + ParentForm + '_' + ControlName
   h := ControlByIndex( &mVar ):Handle
   destroyanimate ( h )

   RETURN Nil
