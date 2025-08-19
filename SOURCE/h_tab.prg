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

MEMVAR _HMG_TAB_IMAGE_NOTRANSPARET

#include "hmg.ch"

*-----------------------------------------------------------------------------*

FUNCTION _DefineTab ( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, value, fontname, fontsize , tooltip , change , Buttons , Flat , HotTrack , Vertical , notabstop , aMnemonic , bold, italic, underline, strikeout , Images , multiline, NoTrans)

   *-----------------------------------------------------------------------------*
   LOCAL r,c,z,i , cParentForm , mVar , Caption , imageFlag := .F. , k := 0
   LOCAL ControlHandle
   LOCAL FontHandle, oControl

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
   ENDIF

   FOR z := 1 To HMG_LEN (Images)
      IF ValType (Images[z]) == "C"
         ImageFlag := .T.
         EXIT
      ENDIF
   NEXT z

   IF ImageFlag == .T. .AND. IsAppThemed() == .T.

      FOR z := 1 To HMG_LEN (aCaptions)

         IF HB_UAT ( '&' , aCaptions[z] ) != 0
            aCaptions[z] := Space(3) + aCaptions[z]
         ENDIF

      NEXT z

   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   IF IsAppThemed() .AND. buttons == .f.
      vertical := .f.
   ENDIF

   ControlHandle = InitTabControl    ( ParentForm, 0, x, y, w, h , aCaptions, value, '', 0 , Buttons , Flat , HotTrack , Vertical , notabstop , multiline )

   IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   ELSE
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   IF valtype(change) == "U"
      change := ""
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "TAB"
      :Name :=   ControlName
      :ParentFormHandle :=   ParentForm
      :Handle :=   Controlhandle
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  aPageMap
      :CTRL008 :=  Nil
      :CTRL009 :=  0   // hImageList
      :CTRL010 :=  ""
      :CTRL011 :=  ""
      :CTRL012 :=  change
      :IsDeleted :=  .F.
      :CTRL014 :=  Nil
      :CTRL015 :=  Nil
      :CTRL016 :=  ""
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 :=  x
      :CTRL020 :=  w
      :CTRL021 := h
      :CTRL022 :=  0
      :CTRL023 :=  -1
      :CTRL024 :=  -1
      :CTRL025 :=  Images
      :CTRL026 :=  NoTrans
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  tooltip
      :CTRL031 :=  Buttons
      :CTRL032 :=  0
      :CTRL033 :=  aCaptions
      :CTRL034 :=   .t.
      :CTRL035 :=   0
      :CTRL036 :=  FontHandle
      :CTRL037 := 0
      :CTRL038 :=  .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   IF ImageFlag == .T.
      ControlByIndex( K ):CTRL009 := AddtabBitMap ( ControlHandle , Images , NoTrans )
   ENDIF
   FOR z := 1 To HMG_LEN ( aCaptions )

      CAPTION := HMG_UPPER ( aCaptions [z] )

      i := HB_UAT ( '&' , Caption )

      IF i > 0

         IF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'A'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_A , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'B'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_B , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'C'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_C , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'D'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_D , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'E'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_E , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'F'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_F , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'G'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_G , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'H'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_H , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'I'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_I , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'J'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_J , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'K'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_K , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'L'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_L , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'M'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_M , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'N'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_N , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'O'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_O , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'P'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_P , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'Q'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_Q , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'R'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_R , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'S'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_S , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'T'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_T , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'U'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_U , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'V'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_V , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'W'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_W , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'X'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_X , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'Y'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_Y , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == 'Z'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_Z , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '0'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_0 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '1'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_1 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '2'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_2 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '3'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_3 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '4'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_4 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '5'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_5 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '6'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_6 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '7'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_7 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '8'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_8 , aMnemonic [z] )
         ELSEIF   HB_USUBSTR ( Caption , i+1 , 1 ) == '9'
            _DefineHotKey ( cParentForm , MOD_ALT , VK_9 , aMnemonic [z] )
         ENDIF

      ENDIF

   NEXT z

   * Hide all except page to show

   FOR r = 1 to HMG_LEN ( aPageMap )
      IF r <> value

         FOR c = 1 to HMG_LEN ( aPageMap [r])
            IF valtype ( aPageMap [r] [c] ) <> "A"
               HideWindow ( aPageMap [r] [c] )
            ELSE
               FOR z = 1 to HMG_LEN ( aPageMap [r] [c] )
                  HideWindow ( aPageMap [r] [c] [z] )
               NEXT z
            ENDIF
         NEXT c

      ENDIF
   NEXT r

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION UpdateTab (y) // Internal Function

   *------------------------------------------------------------------------------*
   LOCAL r,w,s,z

   * Hide All Pages
   FOR r = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 )
      FOR w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [r])
         IF valtype ( ControlByIndex( Y ):CTRL007 [r] [w] ) <> "A"
            HideWindow ( ControlByIndex( Y ):CTRL007 [r] [w] )
         ELSE
            FOR z = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 [r] [w] )
               HideWindow ( ControlByIndex( Y ):CTRL007 [r] [w] [z] )
            NEXT z
         ENDIF
      NEXT w
   NEXT r

   * Show New Active Page
   s = TabCtrl_GetCurSel (ControlByIndex( Y ):Handle )
   FOR w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [s])
      IF valtype (ControlByIndex( Y ):CTRL007 [s] [w]) <> "A"

         IF _IsControlVisibleFromHandle ( ControlByIndex( Y ):CTRL007 [s] [w] )

            CShowControl ( ControlByIndex( Y ):CTRL007 [s] [w] )

         ELSEIF _IsWindowVisibleFromHandle ( ControlByIndex( Y ):CTRL007 [s] [w] )

            CShowControl ( ControlByIndex( Y ):CTRL007 [s] [w] )

         ENDIF

      ELSE

         IF _IsControlVisibleFromHandle ( ControlByIndex( Y ):CTRL007 [s] [w] [1] )

            FOR z = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 [s] [w] )
               CShowControl ( ControlByIndex( Y ):CTRL007 [s] [w] [z] )
            NEXT z

         ENDIF

      ENDIF
   NEXT w

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _BeginTab( name , parent , row , col , w , h , value , f , s , tooltip , change , buttons , flat , hottrack , vertical , notabstop , bold, italic, underline, strikeout , multiline , NoTrans )

   *------------------------------------------------------------------------------*
   LOCAL aMnemonic := {}

   IF oHmgApp():BeginTabActive = .T.
      MsgHMGError("DEFINE TAB Structures can't be nested. Program terminated")
   ENDIF

   IF oHmgApp():APP264 = .T.
      IF .NOT. Empty (oHmgApp():APP224) .AND. ValType(F) == "U"
         F := oHmgApp():APP224
      ENDIF
      IF .NOT. Empty ( oHmgApp():ActiveFontSize ) .AND. ValType(S) == "U"
         S := oHmgApp():ActiveFontSize
      ENDIF
   ENDIF

   IF oHmgApp():FrameLevel > 0
      COL    := col + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
      ROW    := row + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
      PARENT   := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
   ENDIF

   IF valtype (parent) == 'U'
      PARENT := oHmgApp():ActiveFormName
   ENDIF
   IF valtype (value) == 'U'
      VALUE := 1
   ENDIF

   oHmgApp():FrameLevel++

   oHmgApp():APP332   [ oHmgApp():FrameLevel ] := parent
   oHmgApp():APP333   [ oHmgApp():FrameLevel ] := row
   oHmgApp():APP334   [ oHmgApp():FrameLevel ] := col

   oHmgApp():BeginTabActive    := .T.
   oHmgApp():ActiveTabPage := 0
   oHmgApp():APP140    := {}
   oHmgApp():APP141    := {}
   oHmgApp():APP305    := {}
   oHmgApp():APP142   := {}
   oHmgApp():APP225    := name
   oHmgApp():APP226   := parent
   oHmgApp():ActiveTabRow   := row
   oHmgApp():ActiveTabCol   := col
   oHmgApp():ActiveTabWidth   := w
   oHmgApp():ActiveTabHeight   := h
   oHmgApp():ActiveTabValue   := value
   oHmgApp():APP227   := f
   oHmgApp():ActiveTabFontSize   := s
   oHmgApp():APP228   := tooltip
   oHmgApp():APP308   := change

   oHmgApp():ActiveTabButtons   := Buttons
   oHmgApp():ActiveTabFlat    := Flat
   oHmgApp():APP268   := HotTrack
   oHmgApp():APP269   := Vertical
   oHmgApp():APP270   := NotabStop

   oHmgApp():APP301   := Bold
   oHmgApp():APP302   := Italic
   oHmgApp():APP303   := Underline
   oHmgApp():APP304   := Strikeout
   oHmgApp():APP204   := Multiline
   // oHmgApp():APP463 := NoTrans

   PUBLIC _HMG_TAB_IMAGE_NOTRANSPARET := NoTrans

   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 1 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 2 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 3 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 4 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 5 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 6 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 7 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 8 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 9 )  ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 10 ) ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 11 ) ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 12 ) ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 13 ) ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 14 ) ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 15 ) ) } )
   aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 16 ) ) } )

   oHmgApp():APP229 := aMnemonic

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _BeginTabPage ( caption , image )

   *------------------------------------------------------------------------------*

   oHmgApp():ActiveTabPage++
   aAdd ( oHmgApp():APP141 , caption )
   aAdd ( oHmgApp():APP305 , image )

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EndTabPage()

   *------------------------------------------------------------------------------*

   aAdd ( oHmgApp():APP140 , oHmgApp():APP142 )
   oHmgApp():APP142 := {}

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EndTab()

   *------------------------------------------------------------------------------*

   _DefineTab ( oHmgApp():APP225 , ;
      oHmgApp():APP226 , ;
      oHmgApp():ActiveTabCol , ;
      oHmgApp():ActiveTabRow , ;
      oHmgApp():ActiveTabWidth , ;
      oHmgApp():ActiveTabHeight , ;
      oHmgApp():APP141 , ;
      oHmgApp():APP140 , ;
      oHmgApp():ActiveTabValue , ;
      oHmgApp():APP227 , ;
      oHmgApp():ActiveTabFontSize , ;
      oHmgApp():APP228 , ;
      oHmgApp():APP308 , ;
      oHmgApp():ActiveTabButtons , ;
      oHmgApp():ActiveTabFlat , ;
      oHmgApp():APP268 , ;
      oHmgApp():APP269 , ;
      oHmgApp():APP270 , ;
      oHmgApp():APP229 , ;
      oHmgApp():APP301 , ;
      oHmgApp():APP302 , ;
      oHmgApp():APP303 , ;
      oHmgApp():APP304 , ;
      oHmgApp():APP305 , ;
      oHmgApp():APP204 , ;
      /* oHmgApp():APP463 */ _HMG_TAB_IMAGE_NOTRANSPARET )

   oHmgApp():BeginTabActive := .F.
   oHmgApp():FrameLevel--

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _AddTabPage ( ControlName , ParentForm , Position , Caption , cImage )

   *------------------------------------------------------------------------------*
   LOCAL i

   IF ValType (Caption) == 'U'
      CAPTION := ''
   ENDIF

   IF ValType (cImage) == 'U'
      cImage := ''
   ENDIF

   i := GetControlIndex ( Controlname , ParentForm )

   TABCTRL_INSERTITEM ( ControlByIndex( i ):Handle , Position - 1 , Caption )

   aAdd ( ControlByIndex( I ):CTRL007 , Nil )
   aIns ( ControlByIndex( I ):CTRL007 , Position )
   ControlByIndex( I ):CTRL007 [Position] := {}   // aPageMap

   aAdd ( ControlByIndex( I ):CTRL033 , Nil )
   aIns ( ControlByIndex( I ):CTRL033 , Position )
   ControlByIndex( I ):CTRL033 [Position] := Caption

   aAdd ( ControlByIndex( I ):CTRL025 , Nil )
   aIns ( ControlByIndex( I ):CTRL025 , Position )
   ControlByIndex( I ):CTRL025 [Position] := cImage

   // ADD
   IF ControlByIndex( I ):CTRL009 <> 0
      IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL009 )
   ENDIF
   ControlByIndex( I ):CTRL009 := AddtabBitMap ( ControlByIndex( i ):Handle , ControlByIndex( I ):CTRL025 , ControlByIndex( I ):CTRL026 )
   //

   UpdateTab (i)

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _AddTabControl ( TabName , ControlName , ParentForm , PageNumber , Row , Col )

   *------------------------------------------------------------------------------*
   LOCAL i , h , x

   i := GetControlIndex ( TabName , ParentForm )

   x := GetControlIndex ( ControlName , ParentForm )

   h := ControlByIndex( x ):Handle

   IF   ControlByIndex( x ):Type == "CHECKBOX"   ;
         .OR.               ;
         ControlByIndex( x ):Type == "FRAME"

      ControlByIndex( X ):CTRL031 := TabName
      ControlByIndex( X ):CTRL032 := ParentForm

   ENDIF

   aadd ( ControlByIndex( I ):CTRL007 [PageNumber] , h )

   ControlByIndex( X ):CTRL023 := ControlByIndex( I ):CTRL018
   ControlByIndex( X ):CTRL024 := ControlByIndex( I ):CTRL019

   _SetControlRow ( ControlName , ParentForm , Row )
   _SetControlCol ( ControlName , ParentForm , Col )

   UpdateTab (i)

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _DeleteTabPage ( ControlName , ParentForm , Position )

   *------------------------------------------------------------------------------*
   LOCAL i , NewValue , j , NewMap := {}

   i := GetControlIndex ( Controlname , ParentForm )

   IF i > 0

      // Control Map

      FOR j := 1 To HMG_LEN ( ControlByIndex( I ):CTRL007 )

         IF j <> position
            aAdd ( NewMap , ControlByIndex( I ):CTRL007 [j] )
         ENDIF

      NEXT j

      ControlByIndex( I ):CTRL007 := NewMap

      // Images

      NewMap := {}

      FOR j := 1 To HMG_LEN ( ControlByIndex( I ):CTRL025 )

         IF j <> position
            aAdd ( NewMap , ControlByIndex( I ):CTRL025 [j] )
         ENDIF

      NEXT j

      ControlByIndex( I ):CTRL025 := NewMap

      // Captions

      NewMap := {}

      FOR j := 1 To HMG_LEN ( ControlByIndex( I ):CTRL033 )

         IF j <> position
            aAdd ( NewMap , ControlByIndex( I ):CTRL033 [j] )
         ENDIF

      NEXT j

      ControlByIndex( I ):CTRL033 := NewMap

      TabCtrl_DeleteItem(ControlByIndex( i ):Handle , Position - 1 )

      NewValue := Position - 1

      IF NewValue == 0
         NewValue := 1
      ENDIF

      AddTabBitMap ( ControlByIndex( i ):Handle , ControlByIndex( I ):CTRL025 , ControlByIndex( I ):CTRL026 )

      TABCTRL_SETCURSEL ( ControlByIndex( i ):Handle , NewValue )

      IF HMG_LEN ( ControlByIndex( I ):CTRL007 ) > 0
         UpdateTab (i)
      ENDIF

   ENDIF

   RETURN Nil
