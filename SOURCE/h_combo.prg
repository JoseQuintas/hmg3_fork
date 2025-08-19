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
#include "hmg.ch"
#include "common.ch"

*-----------------------------------------------------------------------------*
Function _DefineCombo ( ControlName, ;
         ParentForm, ;
         x, ;
         y, ;
         w, ;
         rows, ;
         value, ;
         fontname, ;
         fontsize, ;
         tooltip, ;
         changeprocedure, ;
         h, ;
         gotfocus, ;
         lostfocus, ;
         uEnter, ;
         HelpId, ;
         invisible, ;
         notabstop, ;
         sort , ;
         bold, ;
         italic, ;
         underline, ;
         strikeout , ;
         itemsource , ;
         valuesource , ;
         displayedit , ;
         ondisplaychangeprocedure , ;
         break , ;
         GripperText , aImage , DroppedWidth , dropdownprocedure , closeupprocedure, oncancel,  NoTransparent )
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar , ControlHandle , FontHandle , rcount := 0 , BackRec , cset := 0 , WorkArea , cField , ContainerHandle := 0 , k := 0
Local aRet := {}, oControl
Local ImageListHandle := Nil
Local aTemp
Local ImageSource
Local cImageWorkArea
Local cImageField

   DEFAULT w               TO 120
   DEFAULT h               TO 150
   DEFAULT changeprocedure TO ""
   DEFAULT gotfocus   TO ""
   DEFAULT lostfocus   TO ""
   DEFAULT rows      TO {}
   DEFAULT invisible   TO FALSE
   DEFAULT notabstop   TO FALSE
   DEFAULT sort      TO FALSE
   DEFAULT GripperText   TO ""
   DEFAULT DroppedWidth   TO w

   if oHmgApp():APP264 = TRUE
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

   if ValType ( ItemSource ) != 'U' .And. Sort == .T.
      MsgHMGError ("Sort and ItemSource clauses can't be used simultaneusly. Program Terminated" )
   EndIf

   if ValType ( ValueSource ) != 'U' .And. Sort == .T.
      MsgHMGError ("Sort and ValueSource clauses can't be used simultaneusly. Program Terminated" )
   EndIf

   If ValType ( ItemSource ) == 'A'

      aTemp := ItemSource

      If   HMG_LEN ( ItemSource ) == 1 .And. ValType ( aImage ) = 'U'

         ItemSource   := aTemp [1]

      ElseIf   HMG_LEN ( ItemSource ) == 2 .And. ValType ( aImage ) = 'A'

         ImageSource   := aTemp [1]
         ItemSource   := aTemp [2]

      ElseIf    HMG_LEN ( ItemSource ) > 2

         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + "Invalid ItemSource property value. Program Terminated" )

      ElseIf    HMG_LEN ( ItemSource ) == 0

         ItemSource := Nil

      EndIf

   EndIf

   if valtype ( itemsource ) != 'U'
      if  HB_UAT ( '>',ItemSource ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " (ItemSource): You must specify a fully qualified field name. Program Terminated" )
      Else
         WorkArea := HB_ULEFT ( ItemSource , HB_UAT ( '>', ItemSource ) - 2 )
         cField := HB_URIGHT ( ItemSource , HMG_LEN (ItemSource) - HB_UAT ( '>', ItemSource ) )
      EndIf
   EndIf

   if valtype ( imagesource ) != 'U'
      if  HB_UAT ( '>',ImageSource ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " (ItemSource): You must specify a fully qualified field name. Program Terminated" )
      Else
         cImageWorkArea := HB_ULEFT ( ImageSource , HB_UAT ( '>', ImageSource ) - 2 )
         cImageField := HB_URIGHT ( ImageSource , HMG_LEN (ImageSource) - HB_UAT ( '>', ImageSource ) )
      EndIf
   EndIf

   if valtype(value) == "U"
      value := 0
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   if valtype(x) == "U" .or. valtype(y) == "U"

      oHmgApp():APP216   := 'COMBOBOX'

      i := GetFormIndex ( cParentForm )

      If i > 0

         If ValType ( aImage ) == 'U'

            ControlHandle := InitComboBox ( FormByHandle( I ):FORM087, 0, x, y, w, '', 0 , h, invisible, notabstop, sort, displayedit , oHmgApp():IsXP , DroppedWidth )

         Else

            aRet      := InitImageCombo ( FormByIndex( I ):FORM087 , y , x , w , h , aImage , displayedit , .Not. invisible , .Not. notabstop , IF ( WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 ) > 5.1 , .T. , .F. ) , DroppedWidth, NoTransparent )
            ControlHandle   := aRet [1]
            ImageListHandle   := aRet [2]

         EndIf

         if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
            FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
         Else
            FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
         endif

         AddSplitBoxItem ( Controlhandle , FormByIndex( I ):FORM087 , w , break , GripperText , w , , oHmgApp():APP258 )

         Containerhandle := FormByIndex( I ):FORM087

      EndIf

   else

      If ValType ( aImage ) == 'U'

         ControlHandle := InitComboBox ( ParentForm, 0, x, y, w, '', 0 , h, invisible, notabstop, sort , displayedit , oHmgApp():IsXP , DroppedWidth )

      Else

         aRet      := InitImageCombo ( ParentForm , y , x , w , h , aImage , displayedit , .Not. invisible , .Not. notabstop , IF ( WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 ) > 5.1 , .T. , .F. ) , DroppedWidth,  NoTransparent )
         ControlHandle   := aRet [1]
         ImageListHandle   := aRet [2]

      EndIf

      if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
      Else
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
      endif

   endif

   If oHmgApp():BeginTabActive = TRUE
      aAdd ( oHmgApp():APP142 , Controlhandle )
   EndIf

   if valtype(uEnter) == "U"
      uEnter := ""
   endif

   if valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( K )

   WITH OBJECT oControl
      :Type := "COMBO"
      :Name := ControlName
      :Handle := ControlHandle
      :ParentFormHandle := ParentForm
      :CTRL005 := 0
      :CTRL006 := ondisplaychangeprocedure
      :CTRL007 := cField
      :CTRL008 := Value
      :CTRL009 := Nil
      :CTRL010 := lostfocus
      :CTRL011 := gotfocus
      :CTRL012 := changeprocedure
      :IsDeleted := FALSE
      :CTRL014 := cImageField
      :CTRL015 := ImageListHandle
      :CTRL016 := uEnter
      :CTRL017 := {}
      :CTRL018 := y
      :CTRL019 := x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := WorkArea
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := ""
      :CTRL026 := ContainerHandle
      :CTRL027 := fontname
      :CTRL028 := fontsize
      :CTRL029 := {bold,italic,underline,strikeout}
      :CTRL030 := tooltip
      :CTRL031 := 0
      :CTRL032 := OnCancel
      :CTRL033 := valuesource
      :CTRL034 := if(invisible,FALSE,TRUE)
      :CTRL035 := HelpId
      :CTRL036 := FontHandle
      :CTRL037 := closeupprocedure
      :CTRL038 := .T.
      :CTRL039 := dropdownprocedure
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

      If displayedit == .T.
         :CTRL031 := FindWindowEx( Controlhandle , 0, "Edit", Nil )
      EndIf
   ENDWITH

   If  ValType( WorkArea ) == "C"

      If Select ( WorkArea ) != 0

         BackRec := (WorkArea)->(RecNo())

         (WorkArea)->(DBGoTop())

         If ValType ( aImage ) = 'U'

            Do While ! (WorkArea)->(Eof())
               rcount++
                    if value == (WorkArea)->(RecNo())
                  cset := rcount
               EndIf
               ComboAddString (ControlHandle, (WorkArea)->&(cField) )
               (WorkArea)->(DBSkip())
            EndDo

         Else

            Do While ! (WorkArea)->(Eof())
               rcount++
                    if value == (WorkArea)->(RecNo())
                  cset := rcount
               EndIf
               ImageComboAddItem ( ControlHandle , (WorkArea)->&(cImageField) , (WorkArea)->&(cField) , -1 )
               (WorkArea)->(DBSkip())
            EndDo

         EndIf

         (WorkArea)->(DBGoTo(BackRec))

         ComboSetCurSel (ControlHandle,cset)

      EndIf

   Else

      If ValType ( aImage ) == 'U'

         for i = 1 to HMG_LEN (rows)
            ComboAddString (ControlHandle,rows[i] )
         next i

      Else

         for i = 1 to HMG_LEN (rows)
            ImageComboAddItem ( ControlHandle , rows[i][1] , rows[i][2] , -1 )
         next i

      EndIf


      if value <> 0
         ComboSetCurSel (ControlHandle,Value)
      endif

   EndIf

   if valtype ( ItemSource ) != 'U'

      if k > 0
         aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , k )
      Else
         aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , oHmgApp():ControlCount )
      EndIf
   EndIf

   If ValType ( aImage ) <> 'U'

      ControlByIndex( K ):CTRL032 := SendMessage( Controlhandle, 1030 , 0 , 0 )

   EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure _DataComboRefresh (i)
*-----------------------------------------------------------------------------*
Local BackRec , WorkArea , cField , cImageField , xCurrentValue , Tmp

   Tmp := ControlByIndex( I ):CTRL033
   ControlByIndex( I ):CTRL033 := Nil

   xCurrentValue := _GetValue ( , , i )

   ControlByIndex( I ):CTRL033 := Tmp

   cField := ControlByIndex( I ):CTRL007
   cImageField := ControlByIndex( I ):CTRL014

   WorkArea := ControlByIndex( I ):CTRL022

   BackRec := (WorkArea)->(RecNo())

   (WorkArea)->(DBGoTop())

   ComboboxReset ( ControlByIndex( i ):Handle )

   If ControlByIndex( I ):CTRL015 == Nil

      Do While ! (WorkArea)->(Eof())

         ComboAddString ( ControlByIndex( i ):Handle , (WorkArea)->&(cField) )

         (WorkArea)->(DBSkip())

      EndDo

   Else

      Do While ! (WorkArea)->(Eof())
         ComboAddString ( ControlByIndex( i ):Handle , (WorkArea)->&(cField) )
         ImageComboAddItem ( ControlByIndex( i ):Handle , (WorkArea)->&(cImageField) , (WorkArea)->&(cField) , -1 )
         (WorkArea)->(DBSkip())
      EndDo

   EndIf

   If xCurrentValue > 0 .And. xCurrentValue <= (WorkArea)->(LastRec())
      _SetValue ( , , xCurrentValue , i )
   EndIf

   (WorkArea)->(DBGoTo(BackRec))

Return

