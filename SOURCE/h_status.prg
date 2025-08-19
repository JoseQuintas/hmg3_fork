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

#include "common.ch"
#include "hmg.ch"

*------------------------------------------------------------------------------*

FUNCTION _StartStatusBar   (         ;
      cParent      , ;
      cFontName   , ;
      nFontSize   , ;
      lBold      , ;
      lItalic      , ;
      lUnderline   , ;
      lStrikeout   , ;
      lTop      ;
      )

   oHmgApp():APP212      := cParent
   oHmgApp():APP213      := cFontname
   oHmgApp():CurrentStatusbarFontSize      := nFontSize
   oHmgApp():APP272      := lBold
   oHmgApp():APP273      := lItalic
   oHmgApp():APP274      := lUnderline
   oHmgApp():APP275      := lStrikeout
   oHmgApp():APP276      := lTop
   oHmgApp():APP143      := {}
   oHmgApp():APP144      := {}
   oHmgApp():APP145      := {}
   oHmgApp():APP146      := {}
   oHmgApp():APP147      := {}
   oHmgApp():APP148      := {}

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _DefineStatusBarItem   (      ;
      cCaption   , ;
      nWidth      , ;
      cImage      , ;
      cStyle      , ;
      cTooltip   , ;
      uAction      ;
      )

   DEFAULT cStyle To ""

   aadd ( oHmgApp():APP143   , cCaption   )
   aadd ( oHmgApp():APP144   , nWidth   )
   aadd ( oHmgApp():APP145   , cImage   )
   aadd ( oHmgApp():APP146   ,  IF ( HMG_UPPER(cStyle) == 'FLAT', 1 , if(HMG_UPPER(cStyle) == 'RAISED', 2 , 0 ) ) )
   aadd ( oHmgApp():APP147   , cTooltip   )
   aadd ( oHmgApp():APP148   , uAction   )

   RETURN HMG_LEN(oHmgApp():APP143)

   *-----------------------------------------------------------------------------*

FUNCTION _EndStatusBar (   cParentForm   , ;
      acCaptions   , ;
      anWidths   , ;
      acImages   , ;
      abActions   , ;
      acToolTips   , ;
      anStyles   , ;
      cFontName   , ;
      nFontSize   , ;
      lFontBold   , ;
      lFontItalic   , ;
      lFontUnderLine   , ;
      lFontStrikeOut   , ;
      lTop      ;
      )

   LOCAL nParentHandle, oControl
   LOCAL nId
   LOCAL i
   LOCAL nTotWidth
   LOCAL nControlHandle
   LOCAL nFontHandle
   LOCAL k
   LOCAL mVar

   IF oHmgApp():APP264 == TRUE
      cParentForm := oHmgApp():ActiveFormName
   ENDIF

   nParentHandle := GetFormHandle ( cParentForm )

   nId := _GetId()

   nTotWidth := 0

   FOR i := 2 To HMG_LEN (anWidths)
      IF ValType ( anWidths [i] ) <> 'N'
         anWidths [i] := 120
      ENDIF
      nTotWidth := nTotWidth + anWidths [i]
   NEXT i

   anWidths [1] := GetWIndowWidth ( nParentHandle ) - nTotWidth

   nControlhandle := InitStatusBar (   nParentHandle   , ;
      nId      , ;
      acCaptions   , ;
      anWidths   , ;
      acImages   , ;
      acToolTips   , ;
      anStyles   , ;
      lTop      ;
      )

   IF ValType(cFontName) != "U" .AND. ValType(nFontSize) != "U"
      nFontHandle := _SetFont (nControlHandle,cFontName,nFontSize,lFontBold,lFontItalic,lFontUnderline,lFontStrikeout)
   ELSE
      nFontHandle := _SetFont (nControlHandle,oHmgApp():APP342,oHmgApp():APP343,lFontBold,lFontItalic,lFontUnderline,lFontStrikeout)
   ENDIF

   k := _GetControlFree()

   mVar := '_' + cParentForm + '_' + "StatusBar"

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type   := "STATUSBAR"
      :Name   := "StatusBar"
      :Handle   := nControlhandle
      :ParentFormHandle   := nParentHandle
      :CTRL005 := nId
      :CTRL006 := abActions
      :CTRL007 := Nil
      :CTRL008 := Nil
      :CTRL009 := Nil
      :CTRL010 := Nil
      :CTRL011 := Nil
      :CTRL012 := Nil
      :IsDeleted := .F.
      :CTRL014 := Nil
      :CTRL015 := Nil
      :CTRL016 := Nil
      :CTRL017 := Nil
      :CTRL018 := Nil
      :CTRL019 := Nil
      :CTRL020 := anWidths
      :CTRL021 := Nil
      :CTRL022 := Nil
      :CTRL023 := -1
      :CTRL024 := -1
      :CTRL025 := Nil
      :CTRL026 := 0
      :CTRL027 := cFontName
      :CTRL028 := nFontSize
      :CTRL029 := { lFontBold , lFontItalic , lFontUnderLine , lFontStrikeOut }
      :CTRL030 := acToolTips
      :CTRL031 := 0
      :CTRL032 := 0
      :CTRL033 := acCaptions
      :CTRL034 := .T.
      :CTRL035 := 0
      :CTRL036 := nFontHandle
      :CTRL037 := 0
      :CTRL038 := .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   RETURN nControlhandle
   *------------------------------------------------------------------------------*

PROCEDURE SetStatusBarSize ( nParentHandle , nStatusHandle , anWidths )

   *------------------------------------------------------------------------------*
   LOCAL i
   LOCAL nTotWidth := 0

   FOR i := 2 To HMG_LEN (anWidths)
      nTotWidth := nTotWidth + anWidths [i]
   NEXT i

   anWidths [1] := GetWindowWidth ( nParentHandle ) - nTotWidth

   InitStatusBarSize ( nStatusHandle , anWidths )

   RETURN
   *---------------------------------------------------------------------------------*

FUNCTION _SetStatusClock ( FormName , Width , ToolTip , action , nIntervalUpdate )

   *---------------------------------------------------------------------------------*
   LOCAL nrItem

   IF Empty (FormName)
      FormName := oHmgApp():APP212
   ENDIF

   IF ValType (Width) == 'U'
      WIDTH := 70
   ENDIF
   IF ValType (ToolTip) == 'U'
      TOOLTIP := 'Clock'
   ENDIF
   IF ValType (Action) == 'U'
      ACTION := ''
   ENDIF
   IF ValType (nIntervalUpdate) == 'U'
      nIntervalUpdate := 1000
   ENDIF

   nrItem  := _DefineStatusBarItem   (      ;
      Time()   , ;
      WIDTH      , ;
      , ;
      , ;
      TOOLTIP   , ;
      ACTION   ;
      )

   _DefineTimer ( 'StatusTimer' , FormName , nIntervalUpdate, {|| _SetItem ( 'StatusBar' , FormName , nrItem  , Time() ) } )

   RETURN Nil
   *---------------------------------------------------------------------------------*

FUNCTION _SetStatusKeybrd ( FormName ,Width , ToolTip , action , nIntervalUpdate )

   *---------------------------------------------------------------------------------*
   LOCAL nrItem1 , nrItem2 , nrItem3

   IF Empty (FormName)
      FormName := oHmgApp():APP212
   ENDIF

   IF ValType (Width) == 'U'
      WIDTH := 75
   ENDIF
   IF ValType (ToolTip) == 'U'
      TOOLTIP := ''
   ENDIF
   IF ValType (Action) == 'U'
      ACTION := ''
   ENDIF
   IF ValType (nIntervalUpdate) == 'U'
      nIntervalUpdate := 200
   ENDIF

   nrItem1 := _DefineStatusBarItem   (      ;
      "NumLock"   , ;
      WIDTH + 20   , ;
      IF ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" )   , ;
         , ;
         TOOLTIP   , ;
         ACTION   ;
         )

      nrItem2 := _DefineStatusBarItem   (      ;
         "CapsLock"   , ;
         WIDTH + 20   , ;
         IF ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" )   , ;
            , ;
            TOOLTIP   , ;
            ACTION   ;
            )

         nrItem3 := _DefineStatusBarItem   (      ;
            "Insert"   , ;
            WIDTH + 20   , ;
            IF ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" )   , ;
               , ;
               TOOLTIP   , ;
               ACTION   ;
               )

            _DefineTimer ( 'StatusKeyBrd' , FormName , nIntervalUpdate , ;
               {|| _SetStatusIcon ( 'StatusBar' , FormName , nrItem1 , IF ( IsNumLockActive(),  "zzz_led_on" , "zzz_led_off" ) ), ;
               _SetStatusIcon ( 'StatusBar' , FormName , nrItem2 , IF ( IsCapsLockActive(), "zzz_led_on" , "zzz_led_off" ) ), ;
               _SetStatusIcon ( 'StatusBar' , FormName , nrItem3 , IF ( IsInsertActive(),   "zzz_led_on" , "zzz_led_off" ) ) ;
               } )

            RETURN Nil
