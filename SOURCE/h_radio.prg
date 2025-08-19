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

#define BM_GETCHECK     240   // ok
#define BST_UNCHECKED   0     // ok
#define BST_CHECKED     1     // ok
#define BM_SETCHECK     241   // ok

#include "hmg.ch"
#include "common.ch"
*-----------------------------------------------------------------------------*

FUNCTION _DefineRadioGroup ( ControlName, ParentForm, x, y, aOptions, Value, ;
      fontname, fontsize, tooltip, change, width, ;
      spacing, HelpId, invisible, notabstop , bold, italic, underline, strikeout , backcolor , fontcolor , transparent , aReadOnly , horizontal )
   *-----------------------------------------------------------------------------*
   LOCAL i , cParentForm , mVar , BackRow , k := 0
   LOCAL aHandles    [ 0 ], oControl
   LOCAL ControlHandle
   LOCAL FontHandle
   LOCAL cParentTabName := ''
   LOCAL cParentWindowName := ''
   LOCAL Z
   LOCAL BackCol

   // mSGiNFO ('Creating Radio ' + IF ( horizontal ,'.T.' , '.F.' )  )

   DEFAULT Width     TO 120
   DEFAULT change    TO ""
   DEFAULT invisible TO FALSE
   DEFAULT notabstop TO FALSE

   IF horizontal
      DEFAULT Spacing To 125
   ELSE
      DEFAULT Spacing To 25
   ENDIF

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
         cParentWindowName := ParentForm
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   BackRow := y
   BackCol := x

   IF horizontal

      ControlHandle := InitRadioGroup ( ParentForm, aOptions[1], 0, x, y , '' , 0 , Spacing, invisible, notabstop )

   ELSE

      ControlHandle := InitRadioGroup ( ParentForm, aOptions[1], 0, x, y , '' , 0 , width, invisible, notabstop )

   ENDIF

   IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   ELSE
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   aAdd ( aHandles , ControlHandle )

   FOR i = 2 to HMG_LEN (aOptions)

      IF horizontal
         x = x + Spacing
      ELSE
         y = y + Spacing
      ENDIF

      IF horizontal

         ControlHandle := InitRadioButton ( ParentForm, aOptions[i], 0, x, y , '' , 0 , Spacing, invisible )

      ELSE

         ControlHandle := InitRadioButton ( ParentForm, aOptions[i], 0, x, y , '' , 0 , width, invisible )

      ENDIF

      IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
      ELSE
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
      ENDIF

      IF valtype(tooltip) != "U"
         SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
      ENDIF

      aAdd ( aHandles , ControlHandle )

   NEXT i

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , aHandles )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "RADIOGROUP"
      :Name :=  ControlName
      :Handle :=  aHandles
      :ParentFormHandle :=   ParentForm
      :CTRL005 :=  aReadOnly
      :CTRL006 :=  ""
      :CTRL007 :=  {}
      :CTRL008 :=  horizontal // (Nil)
      :CTRL009 :=  transparent
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  change
      :IsDeleted :=  .F.
      :CTRL014 :=   backcolor
      :CTRL015 :=  fontcolor
      :CTRL016 :=  oHmgApp():ActiveTabButtons
      :CTRL017 :=  {}
      :CTRL018 :=  BackRow
      :CTRL019 :=  BackCol
      :CTRL020 :=  IF ( horizontal , Spacing * HMG_LEN (aOptions) , Width )
      :CTRL021 :=  IF ( horizontal , 28 , Spacing * HMG_LEN (aOptions) )
      :CTRL022 :=  Spacing
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  .NOT. NoTabStop
      :CTRL026 :=  0
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=   tooltip
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  cParentWindowName
      :CTRL033 :=   aOptions
      :CTRL034 :=   if(invisible,FALSE,TRUE)
      :CTRL035 :=   HelpId
      :CTRL036 :=   FontHandle
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   IF valtype (Value) <> 'U'
      SendMessage( aHandles [value] , BM_SETCHECK  , BST_CHECKED , 0 )
      IF notabstop .AND. IsTabStop(aHandles [value])
         SetTabStop(aHandles [value],.f.)
      ENDIF
   ENDIF

   IF VALTYPE ( aReadOnly ) = 'A'

      IF HMG_LEN ( aReadOnly ) == HMG_LEN ( aOptions )

         FOR Z := 1 TO HMG_LEN ( aReadOnly )

            IF VALTYPE ( aReadOnly [Z] ) == 'L'

               IF aReadOnly [Z] == .T.

                  DisableWindow ( aHandles [Z] )

               ELSE

                  EnableWindow ( aHandles [Z] )

               ENDIF

            ENDIF

         NEXT Z

      ENDIF

   ENDIF

   RETURN Nil

PROCEDURE _SetRadioGroupReadOnly ( ControlName , ParentForm , aReadOnly )

   LOCAL Z , I , aHandles , aOptions , lError

   lError := .F.

   I := GetControlIndex ( ControlName , ParentForm )

   aHandles := ControlByIndex( i ):Handle

   aOptions := ControlByIndex( I ):CTRL033

   IF VALTYPE ( aReadOnly ) = 'A'

      IF HMG_LEN ( aReadOnly ) == HMG_LEN ( aOptions )

         FOR Z := 1 TO HMG_LEN ( aReadOnly )

            IF VALTYPE ( aReadOnly [Z] ) == 'L'

               IF aReadOnly [Z] == .T.

                  DisableWindow ( aHandles [Z] )

               ELSE

                  EnableWindow ( aHandles [Z] )

               ENDIF

            ELSE

               lError := .T.
               EXIT

            ENDIF

         NEXT Z

      ELSE

         lError := .T.

      ENDIF

   ELSE

      lError := .T.

   ENDIF

   IF .NOT. lError

      ControlByIndex( I ):CTRL005 := aReadOnly

   ENDIF

   RETURN

FUNCTION _GetRadioGroupReadOnly ( ControlName , ParentForm )

   LOCAL RetVal , I

   I := GetControlIndex ( ControlName , ParentForm )

   RetVal := ControlByIndex( I ):CTRL005

   RETURN RetVal
