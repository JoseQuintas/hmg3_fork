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
MEMVAR _HMG_SYSDATA
MEMVAR _HMG_SYSDATA_cButtonName
MEMVAR _HMG_SYSDATA_nControlHandle

#include "hmg.ch"
*------------------------------------------------------------------------------*

FUNCTION _DefineMainMenu ( Parent )

   *------------------------------------------------------------------------------*

   IF valtype(Parent) == 'U'
      PARENT := oHmgApp():ActiveFormName
   ENDIF

   IF IsMainMenuDefined (Parent) == .T.     // ADD
      MsgHMGError("Main Menu already defined in Window: "+ Parent + ". Program Terminated" )
   ENDIF

   oHmgApp():APP218 := 'MAIN'
   oHmgApp():APP172 := 0
   oHmgApp():APP173 := 0
   oHmgApp():APP174 := 0
   oHmgApp():xMainMenuParentName := ""

   oHmgApp():APP173 := GetFormHandle ( Parent )
   oHmgApp():xMainMenuParentName := Parent
   oHmgApp():APP172 := CreateMenu()

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _DefineMenuPopup ( Caption , Name )

   *------------------------------------------------------------------------------*
   LOCAL mVar , k := 0, oControl

   IF oHmgApp():APP218 == 'MAIN'

      oHmgApp():APP174++

      oHmgApp():APP335 [ oHmgApp():APP174 ] := CreatePopupMenu()

      oHmgApp():APP336 [ oHmgApp():APP174 ] := Caption

      IF oHmgApp():APP174 > 1
         AppendMenuPopup ( oHmgApp():APP335 [oHmgApp():APP174 - 1 ] , oHmgApp():APP335 [ oHmgApp():APP174 ] , oHmgApp():APP336 [ oHmgApp():APP174 ] )
      ENDIF

      IF valtype (name) != 'U'

         mVar := '_' + oHmgApp():xMainMenuParentName + '_' + Name

         k := _GetControlFree()

         PUBLIC &mVar. := k

         oControl := ControlByIndex( k )

         WITH OBJECT oControl
            :Type :=  "POPUP"
            :Name :=  Name
            :Handle :=  oHmgApp():APP172   // Main Menu Handle  // Dr. Claudio Soto (July 2013)  // 0
            :ParentFormHandle :=  oHmgApp():APP173   // Form Parent Handle
            :CTRL005 :=  0
            :CTRL006 :=   Nil
            :CTRL007 :=   oHmgApp():APP172   // Main Menu Handle
            :CTRL008 :=  Nil
            :CTRL009 := ""
            :CTRL010 :=  ""
            :CTRL011 :=  ""
            :CTRL012 :=  "MAIN_MENU_POPUP"   // ADD
            :IsDeleted :=  .F.
            :CTRL014 :=  Nil
            :CTRL015 :=  Nil
            :CTRL016 := ""
            :CTRL017 :=  {}
            :CTRL018 :=  0
            :CTRL019 :=  0
            :CTRL020 :=  0
            :CTRL021 :=  0
            :CTRL022 :=  oHmgApp():APP335 [ oHmgApp():APP174 ]   // Popup Menu Handle
            :CTRL023 :=  -1
            :CTRL024 :=  -1
            :CTRL025 :=  ""
            :CTRL026 :=  0
            :CTRL027 :=  ''
            :CTRL028 :=  0
            :CTRL029 :=  {.f.,.f.,.f.,.f.}
            :CTRL030 :=  ''
            :CTRL031 :=  0
            :CTRL032 :=   0
            :CTRL033 :=   Caption
            :CTRL034 :=   .t.
            :CTRL035 :=   0
            :CTRL036 :=  0
            :CTRL037 :=   0
            :CTRL038 :=   .T.
            :CTRL039 := 0
            :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
         ENDWITH

      ENDIF

   ELSE

      MsgHMGError("Context/DropDown/Notify Menus Does Not Support SubMenus. Program Terminated")

   ENDIF

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EndMenuPopup()

   *------------------------------------------------------------------------------*

   IF oHmgApp():APP218 == 'MAIN'

      oHmgApp():APP174--

      IF oHmgApp():APP174 == 0
         AppendMenuPopup ( oHmgApp():APP172 , oHmgApp():APP335 [ 1 ] , oHmgApp():APP336 [ 1 ] )
      ENDIF

   ELSE

      MsgHMGError("Context/DropDown/Notify Menus Does Not Support SubMenus. Program Terminated")

   ENDIF

   RETURN Nil
   *-----------------------------------------------------------------------------------------*

FUNCTION _DefineMenuItem ( caption , action , name , Image , checked , NoTrans, ToolTip )

   *-----------------------------------------------------------------------------------------*
   LOCAL Controlhandle , mVar := '' , k := 0, cTypeMenu :=""
   LOCAL id, oControl
   LOCAL cParentName := "", MenuItemID := 0

   IF oHmgApp():APP218 == 'MAIN'

      Id := _GetId()

      Controlhandle := AppendMenuString ( oHmgApp():APP335 [oHmgApp():APP174 ] , id ,  caption )   // This Not return a Handle, return lBoolean value

      IF Valtype ( image ) != 'U'
         MenuItem_SetBitMaps ( oHmgApp():APP335 [oHmgApp():APP174] , Id , image , "" , NoTrans )
      ENDIF

      k := _GetControlFree()

      IF valtype (name) != 'U'
         mVar := '_' + oHmgApp():xMainMenuParentName + '_' + Name
         PUBLIC &mVar. := k

      ELSE
         *mVar := '_MenuDummyVar'
         *Name := 'DummyMenuName'
         *Public &mVar. := 0
         Name := ''
      ENDIF

      oControl := ControlByIndex( k )

      WITH OBJECT oControl
         :Type := "MENU"
         :Name :=  Name
         :Handle :=  oHmgApp():APP172   // Main Menu Handle   // Dr. Claudio Soto (July 2013)  Controlhandle   // This Not a Handle, this is lBoolean value
         :ParentFormHandle :=  oHmgApp():APP173   // Form Parent Handle
         :CTRL005  :=  id
         :CTRL006  :=  action
         :CTRL007  :=  oHmgApp():APP335 [oHmgApp():APP174 ]   // Popup Menu Handle
         :CTRL008  :=  Nil                                            // oHmgApp():APP335 -> _HMG_xMenuPopuphandle
         :CTRL009  :=  ""                                             // oHmgApp():APP174 -> counter of Popup Menu Handle
         :CTRL010  :=  ""
         :CTRL011  :=  ""
         :CTRL012  :=  "MAIN_MENU_ITEM"   // ADD
         :IsDeleted  :=  .F.
         :CTRL014 :=  Nil
         :CTRL015 :=   Nil
         :CTRL016 := ""
         :CTRL017 :=  {}
         :CTRL018 :=  0
         :CTRL019 := 0
         :CTRL020 :=  0
         :CTRL021 :=  0
         :CTRL022 :=  0
         :CTRL023 :=  -1
         :CTRL024 :=  -1
         :CTRL025 :=  ""
         :CTRL026 :=  0
         :CTRL027 :=  ''
         :CTRL028 :=  0
         :CTRL029 :=  {.f.,.f.,.f.,.f.}
         :CTRL030 :=  ToolTip
         :CTRL031 :=   0
         :CTRL032 :=  0
         :CTRL033 :=   Caption
         :CTRL034 :=   .t.
         :CTRL035 :=   0
         :CTRL036 :=   0
         :CTRL037 :=  0
         :CTRL038 :=   .T.
         :CTRL039 := 0
         :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }   // ToolTip MenuItem Data
      ENDWITH

      IF checked == .t.
         xCheckMenuItem ( oHmgApp():APP335 [oHmgApp():APP174 ] , id )
      ENDIF

   ELSE

      id := _GetId()

      Controlhandle := AppendMenuString ( oHmgApp():APP175 , id ,  caption )   // This Not return a Handle, return lBoolean value

      IF Valtype ( image ) != 'U'
         MenuItem_SetBitMaps ( oHmgApp():APP175 , Id , image , "" , NoTrans )
      ENDIF

      k := _GetControlFree()

      IF valtype (name) != 'U'
         mVar := '_' + oHmgApp():APP221 + '_' + Name
         PUBLIC &mVar. := k

      ELSE
         *mVar := '_MenuDummyVar'
         *Name := 'DummyMenuName'
         *Public &mVar. := 0
         Name := ''
      ENDIF

      IF     oHmgApp():APP218 == "CONTEXT"       // ADD
         cTypeMenu := "CONTEXT_MENU_ITEM"        // ADD
      ELSEIF oHmgApp():APP218 == "NOTIFY"        // ADD
         cTypeMenu := "NOTIFY_MENU_ITEM"         // ADD
      ELSEIF oHmgApp():APP218 == "DROPDOWN"      // ADD
         cTypeMenu := "DROPDOWN_MENU_ITEM"       // ADD
      ELSEIF oHmgApp():APP218 == "CONTROL"       // ADD
         cTypeMenu := "CONTROL_MENU_ITEM"        // ADD
      ENDIF

      oControl := ControlByIndex( K )
      WITH OBJECT oControl
         :Type :=   "MENU"
         :Name :=   Name
         :Handle :=   oHmgApp():APP175   // Popup Menu Handle  // Dr. Claudio Soto (July 2013)   Controlhandle   // This Not a Handle, this is lBoolean value
         :ParentFormHandle :=   oHmgApp():APP176   // oHmgApp():APP176 := GetFormHandle ( Parent )   // Form Parent Handle
         :CTRL005 :=   id
         :CTRL006 :=   action
         :CTRL007 :=   oHmgApp():APP175   //oHmgApp():APP175 := CreatePopupMenu()   // Popup Menu Handle
         :CTRL008 :=   Nil
         :CTRL009 :=   ""
         :CTRL010 :=   ""
         :CTRL011 :=   _HMG_SYSDATA_cButtonName   // ADD
         :CTRL012 :=   cTypeMenu         // ADD
         :IsDeleted :=   .F.
         :CTRL014 :=   Nil
         :CTRL015 :=   Nil
         :CTRL016 :=   ""
         :CTRL017 :=   {}
         :CTRL018 :=   _HMG_SYSDATA_nControlHandle // ADD
         :CTRL019 :=   0
         :CTRL020 :=   0
         :CTRL021 :=   0
         :CTRL022 :=   0
         :CTRL023 :=   -1
         :CTRL024 :=   -1
         :CTRL025 :=   ""
         :CTRL026 :=   0
         :CTRL027 :=   ''
         :CTRL028 :=   0
         :CTRL029 :=   {.f.,.f.,.f.,.f.}
         :CTRL030 :=   ToolTip
         :CTRL031 :=   0
         :CTRL032 :=   0
         :CTRL033 :=   Caption
         :CTRL034 :=   .t.
         :CTRL035 :=   0
         :CTRL036 :=   0
         :CTRL037 :=   0
         :CTRL038 :=   .T.
         :CTRL039 :=   0
         :CTRL040 :=   { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
      ENDWITH

      IF checked == .t.
         xCheckMenuItem ( oHmgApp():APP175 , id )
      ENDIF

   ENDIF

   // by Dr. Claudio Soto, December 2014
   IF valtype(tooltip) != "U"
      GetFormNameByHandle ( ControlByIndex( K ):ParentFormHandle , @cParentName )
      MenuItemID  := ControlByIndex( K ):CTRL005
      SetToolTipMenuItem ( GetFormHandle (cParentName), ToolTip, MenuItemID, GetMenuToolTipHandle (cParentName) )
   ENDIF

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _DefineSeparator ()

   *------------------------------------------------------------------------------*

   IF oHmgApp():APP218 == 'MAIN'

      AppendMenuSeparator ( oHmgApp():APP335 [oHmgApp():APP174 ] )
   ELSE

      AppendMenuSeparator ( oHmgApp():APP175 )

   ENDIF

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EndMenu()

   *------------------------------------------------------------------------------*
   LOCAL i

   DO CASE
   CASE oHmgApp():APP218 == 'MAIN'

      SetMenu( oHmgApp():APP173 , oHmgApp():APP172 )

   CASE oHmgApp():APP218 == 'CONTEXT'

      i := GetFormIndex ( oHmgApp():APP221 )
      FormByIndex( i ):FormContextMenuHandle := oHmgApp():APP175

   CASE oHmgApp():APP218 == 'NOTIFY'

      i := GetFormIndex ( oHmgApp():APP221 )
      FormByIndex( I ):FORM088 := oHmgApp():APP175

   CASE oHmgApp():APP218 == 'DROPDOWN'

      ControlByIndex( oHmgApp():xContextMenuButtonIndex ):CTRL032 := oHmgApp():APP175

   ENDCASE

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _DisableMenuItem ( ItemName , FormName )

   *------------------------------------------------------------------------------*
   LOCAL i , h , x

   x := GetControlIndex ( ItemName , FormName )

   h := ControlByIndex( X ):CTRL007

   IF ControlByIndex( x ):Type == "MENU"
      i := ControlByIndex( X ):CTRL005
   ELSEIF ControlByIndex( X ):Type == "POPUP"
      i := ControlByIndex( X ):CTRL022
   ENDIF

   xDisableMenuItem ( h , i )

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EnableMenuItem ( ItemName , FormName )

   *------------------------------------------------------------------------------*
   LOCAL i , h , x

   x := GetControlIndex ( ItemName , FormName )

   h := ControlByIndex( X ):CTRL007

   IF ControlByIndex( x ):Type == "MENU"
      i := ControlByIndex( X ):CTRL005
   ELSEIF ControlByIndex( x ):Type == "POPUP"
      i := ControlByIndex( X ):CTRL022
   ENDIF

   xEnableMenuItem ( h , i )

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _CheckMenuItem ( ItemName , FormName )

   *------------------------------------------------------------------------------*
   LOCAL i , h , x

   x := GetControlIndex ( ItemName , FormName )

   h := ControlByIndex( X ):CTRL007

   IF ControlByIndex( x ):Type == "MENU"
      i := ControlByIndex( X ):CTRL005
   ELSEIF ControlByIndex( x ):Type == "POPUP"
      i := ControlByIndex( X ):CTRL022
   ENDIF

   xCheckMenuItem ( h , i )

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _UncheckMenuItem ( ItemName , FormName )

   *------------------------------------------------------------------------------*
   LOCAL i , h , x

   x := GetControlIndex ( ItemName , FormName )

   h := ControlByIndex( X ):CTRL007

   IF ControlByIndex( X ):Type == "MENU"
      i := ControlByIndex( X ):CTRL005
   ELSEIF ControlByIndex( X ):Type == "POPUP"
      i := ControlByIndex( X ):CTRL022
   ENDIF

   xUncheckMenuItem ( h , i )

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _IsMenuItemChecked ( ItemName , FormName )

   *------------------------------------------------------------------------------*
   LOCAL x,h,i,r,z

   x := GetControlIndex ( ItemName , FormName )

   h := ControlByIndex( X ):CTRL007

   IF ControlByIndex( X ):Type == "MENU"
      i := ControlByIndex( X ):CTRL005
   ELSEIF ControlByIndex( X ):Type == "POPUP"
      i := ControlByIndex( X ):CTRL022
   ENDIF

   r := xGetMenuCheckState ( h , i )

   IF r == 1
      z := .t.
   ELSE
      z := .f.
   ENDIF

   RETURN z
   *------------------------------------------------------------------------------*

FUNCTION _IsMenuItemEnabled ( ItemName , FormName )

   *------------------------------------------------------------------------------*
   LOCAL x,h,i,r,z

   x := GetControlIndex ( ItemName , FormName )

   h := ControlByIndex( X ):CTRL007

   IF ControlByIndex( X ):Type == "MENU"
      i := ControlByIndex( X ):CTRL005
   ELSEIF ControlByIndex( X ):Type == "POPUP"
      i := ControlByIndex( X ):CTRL022
   ENDIF

   r := xGetMenuEnabledState ( h , i )

   IF r == 1
      z := .t.
   ELSE
      z := .f.
   ENDIF

   RETURN z

   *------------------------------------------------------------------------------*

FUNCTION _DefineContextMenu ( Parent )

   *------------------------------------------------------------------------------*

   IF valtype(Parent) == 'U'
      PARENT := oHmgApp():ActiveFormName
   ENDIF

   PUBLIC _HMG_SYSDATA_cButtonName := ""   // ADD
   PUBLIC _HMG_SYSDATA_nControlHandle := 0 // ADD

   IF IsContextMenuDefined (Parent) == .T.     // ADD
      MsgHMGError("Context Menu already defined in Window: "+ Parent + ". Program Terminated" )
   ENDIF

   oHmgApp():APP175 := 0
   oHmgApp():APP176 := 0
   oHmgApp():APP177 := 0
   oHmgApp():APP221 := ""

   oHmgApp():APP218 := 'CONTEXT'

   oHmgApp():APP174 := 0

   oHmgApp():APP176 := GetFormHandle ( Parent )
   oHmgApp():APP221 := Parent
   oHmgApp():APP175 := CreatePopupMenu()

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _DefineNotifyMenu ( Parent )

   *------------------------------------------------------------------------------*

   IF valtype(Parent) == 'U'
      PARENT := oHmgApp():ActiveFormName
   ENDIF

   PUBLIC _HMG_SYSDATA_cButtonName := ""   // ADD
   PUBLIC _HMG_SYSDATA_nControlHandle := 0 // ADD

   IF IsNotifyMenuDefined (Parent) == .T.     // ADD
      MsgHMGError("Notify Menu already defined in Window: "+ Parent + ". Program Terminated" )
   ENDIF

   oHmgApp():APP175 := 0
   oHmgApp():APP176 := 0
   oHmgApp():APP177 := 0
   oHmgApp():APP221 := ""

   oHmgApp():APP218 := 'NOTIFY'

   oHmgApp():APP174 := 0

   oHmgApp():APP176 := GetFormHandle ( Parent )
   oHmgApp():APP221 := Parent
   oHmgApp():APP175 := CreatePopupMenu()

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION _DefineDropDownMenu ( cButton , Parent )

   *------------------------------------------------------------------------------*

   IF valtype(Parent) == 'U'
      PARENT := oHmgApp():ActiveFormName
   ENDIF

   PUBLIC _HMG_SYSDATA_cButtonName := cButton   // ADD
   PUBLIC _HMG_SYSDATA_nControlHandle := 0 // ADD

   IF IsDropDownMenuDefined ( cButton, Parent ) == .T.     // ADD
      MsgHMGError("DropDown Menu of Button: " + cButton + " already defined in Window: "+ Parent + ". Program Terminated" )
   ENDIF

   oHmgApp():APP175 := 0
   oHmgApp():APP176 := 0
   oHmgApp():APP177 := 0
   oHmgApp():APP221 := ""

   oHmgApp():APP218 := 'DROPDOWN'

   oHmgApp():APP174 := 0

   oHmgApp():xContextMenuButtonIndex  := GetControlIndex ( cButton , Parent )
   oHmgApp():APP176 := GetFormHandle ( Parent )
   oHmgApp():APP221 := Parent
   oHmgApp():APP175 := CreatePopupMenu()

   RETURN Nil

   // Dr. Claudio Soto (March 2013)

   *------------------------------------------------------------------------------*

PROCEDURE DeleteItem_HMG_SYSDATA (k)

   *------------------------------------------------------------------------------*

   LOCAL oControl

   oControl := ControlByIndex( K )
   WITH OBJECT oControl
      :IsDeleted := .T.
      :Type := ""
      :Name := ""
      :Handle := 0
      :ParentFormHandle := 0
      :CTRL005 := 0
      :CTRL006 := ""
      :CTRL007 := {}
      :CTRL008 := NIL
      :CTRL009 := ""
      :CTRL010 := ""
      :CTRL011 := ""
      :CTRL012 := ""
      :CTRL014 := NIL
      :CTRL015 := NIL
      :CTRL016 := ""
      :CTRL017 := {}
      :CTRL018 := 0
      :CTRL019 := 0
      :CTRL020 := 0
      :CTRL021 := 0
      :CTRL022 := 0
      :CTRL023 := 0
      :CTRL024 := 0
      :CTRL025 := ''
      :CTRL026 := 0
      :CTRL027 := ''
      :CTRL028 := 0
      :CTRL030 := ''
      :CTRL031 := 0
      :CTRL032 := 0
      :CTRL033 := ''
      :CTRL034 := .F.
      :CTRL035 := 0
      :CTRL036 := 0
      :CTRL029 := {}
      :CTRL037 := 0
      :CTRL038 := .F.
      :CTRL039 := 0
      :CTRL040 := NIL
   ENDWITH

   RETURN

   *------------------------------------------------------------------------------*

FUNCTION IsMainMenuDefined ( cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, Ret

   hWnd := GetFormHandle (cParentForm)
   Ret  := ExistMainMenu (hWnd)

   RETURN Ret

   *------------------------------------------------------------------------------*

FUNCTION IsContextMenuDefined ( cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, k

   hWnd := GetFormHandle ( cParentForm )
   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( K ):Type == "MENU") .OR. (ControlByIndex( K ):Type == "POPUP")
         IF ( ( ControlByIndex( K ):CTRL012 == "CONTEXT_MENU_ITEM") .AND. ( ControlByIndex( K ):ParentFormHandle == hWnd ) )
            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

   *------------------------------------------------------------------------------*

FUNCTION IsNotifyMenuDefined ( cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, k

   hWnd := GetFormHandle ( cParentForm )
   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF (( ControlByIndex( K ):CTRL012 == "NOTIFY_MENU_ITEM") .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

   *------------------------------------------------------------------------------*

FUNCTION IsDropDownMenuDefined ( cButton, cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, k

   hWnd := GetFormHandle ( cParentForm )
   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF (( ControlByIndex( K ):CTRL012 == "DROPDOWN_MENU_ITEM") .AND. ( ControlByIndex( K ):CTRL011 == cButton) .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

   *------------------------------------------------------------------------------*

FUNCTION ReleaseMainMenu ( cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, k, Ret := 0

   IF VALTYPE (cParentForm) == 'U'
      cParentForm := ThisWindow.Name
   ENDIF

   IF IsMainMenuDefined (cParentForm) == .F.
      MsgHMGError("Main Menu not defined in Window: "+ cParentForm + ". Program Terminated" )
   ENDIF

   hWnd := GetFormHandle ( cParentForm )
   DeleteMainMenu (hWnd)

   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF (( ControlByIndex( K ):CTRL012 == "MAIN_MENU_ITEM" .OR. ControlByIndex( K ):CTRL012 == "MAIN_MENU_POPUP") .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            DeleteItem_HMG_SYSDATA (k)
            Ret ++
         ENDIF
      ENDIF
   NEXT

   RETURN Ret

   *------------------------------------------------------------------------------*

FUNCTION ReleaseContextMenu ( cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, hMenu, k, Ret := 0

   IF VALTYPE (cParentForm) == 'U'
      cParentForm := ThisWindow.Name
   ENDIF

   IF IsContextMenuDefined (cParentForm) == .F.
      MsgHMGError("Context Menu not defined in Window: "+ cParentForm + ". Program Terminated" )
   ENDIF

   hWnd := GetFormHandle ( cParentForm )

   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF (( ControlByIndex( K ):CTRL012 == "CONTEXT_MENU_ITEM") .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            hMenu := ControlByIndex( K ):CTRL007
            DestroyMenu (hMenu)
            DeleteItem_HMG_SYSDATA (k)
            Ret ++
         ENDIF
      ENDIF
   NEXT

   RETURN Ret

   *------------------------------------------------------------------------------*

FUNCTION ReleaseNotifyMenu ( cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, hMenu, k, Ret := 0

   IF VALTYPE (cParentForm) == 'U'
      cParentForm := ThisWindow.Name
   ENDIF

   IF IsNotifyMenuDefined (cParentForm) == .F.
      MsgHMGError("Notify Menu not defined in Window: "+ cParentForm + ". Program Terminated" )
   ENDIF

   hWnd := GetFormHandle ( cParentForm )

   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF ((ControlByIndex( K ):CTRL012 == "NOTIFY_MENU_ITEM") .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            hMenu := ControlByIndex( K ):CTRL007
            DestroyMenu (hMenu)
            DeleteItem_HMG_SYSDATA (k)
            Ret ++
         ENDIF
      ENDIF
   NEXT

   RETURN Ret

   *------------------------------------------------------------------------------*

FUNCTION ReleaseDropDownMenu ( cButton, cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, hMenu, k, Ret := 0

   IF VALTYPE (cParentForm) == 'U'
      cParentForm := ThisWindow.Name
   ENDIF

   IF IsDropDownMenuDefined ( cButton, cParentForm) == .F.
      MsgHMGError("DropDown Menu of Button: " + cButton + " not defined in Window: "+ cParentForm + ". Program Terminated" )
   ENDIF

   hWnd := GetFormHandle ( cParentForm )

   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF (( ControlByIndex( K ):CTRL012 == "DROPDOWN_MENU_ITEM") .AND. (ControlByIndex( K ):CTRL011 == cButton) .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            hMenu := ControlByIndex( K ):CTRL007
            DestroyMenu (hMenu)
            DeleteItem_HMG_SYSDATA (k)
            Ret ++
         ENDIF
      ENDIF
   NEXT

   RETURN Ret

   //***************************************************************************************
   // Control Context Menu
   //***************************************************************************************

   // Dr. Claudio Soto (May 2013)

   *------------------------------------------------------------------------------*

FUNCTION _DefineControlContextMenu ( cControl, cParentForm )

   *------------------------------------------------------------------------------*

   IF valtype(cParentForm) == 'U'
      cParentForm := oHmgApp():ActiveFormName
   ENDIF

   PUBLIC _HMG_SYSDATA_cButtonName := ""   // ADD
   PUBLIC _HMG_SYSDATA_nControlHandle := 0 // ADD

   IF IsControlContextMenuDefined ( cControl, cParentForm ) == .T.
      MsgHMGError("Context Menu of Control: " + cControl + " already defined in Window: "+ cParentForm + ". Program Terminated" )
   ENDIF

   oHmgApp():APP175 := 0
   oHmgApp():APP176 := 0
   oHmgApp():APP177 := 0
   oHmgApp():APP221 := ""

   oHmgApp():APP218 := 'CONTROL'

   oHmgApp():APP174 := 0

   _HMG_SYSDATA_nControlHandle := GetControlHandle ( cControl, cParentForm  )
   oHmgApp():APP176 := GetFormHandle ( cParentForm  )
   oHmgApp():APP221 := cParentForm
   oHmgApp():APP175 := CreatePopupMenu()

   RETURN Nil

   *------------------------------------------------------------------------------*

FUNCTION IsControlContextMenuDefined ( cControl, cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, nControlHandle, k

   hWnd := GetFormHandle ( cParentForm )
   nControlHandle := GetControlHandle ( cControl, cParentForm )
   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF (( ControlByIndex( K ):CTRL012 == "CONTROL_MENU_ITEM") .AND. _TestControlHandle_ContextMenu (ControlByIndex( K ):CTRL018, nControlHandle) .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

   *------------------------------------------------------------------------------*

FUNCTION ReleaseControlContextMenu ( cControl, cParentForm )

   *------------------------------------------------------------------------------*
   LOCAL hWnd, hMenu, nControlHandle, k, Ret := 0

   IF VALTYPE (cParentForm) == 'U'
      cParentForm := ThisWindow.Name
   ENDIF

   IF IsControlContextMenuDefined ( cControl, cParentForm ) == .F.
      MsgHMGError("Context Menu of Control: " + cControl + " not defined in Window: "+ cParentForm + ". Program Terminated" )
   ENDIF

   hWnd := GetFormHandle ( cParentForm )
   nControlHandle := GetControlHandle ( cControl, cParentForm )

   FOR k = 1 TO oHmgApp():ControlCount
      IF (ControlByIndex( k ):Type == "MENU") .OR. (ControlByIndex( k ):Type == "POPUP")
         IF ((ControlByIndex( K ):CTRL012 == "CONTROL_MENU_ITEM") .AND. _TestControlHandle_ContextMenu (ControlByIndex( K ):CTRL018, nControlHandle) .AND. (ControlByIndex( K ):ParentFormHandle == hWnd))
            hMenu := ControlByIndex( K ):CTRL007
            DestroyMenu (hMenu)
            DeleteItem_HMG_SYSDATA (k)
            Ret ++
         ENDIF
      ENDIF
   NEXT

   RETURN Ret

   *------------------------------------------------------------------------------*

FUNCTION _TestControlHandle_ContextMenu  ( Handle , ControlHandle )

   *------------------------------------------------------------------------------*
   LOCAL i, k

   IF ValType (Handle) == "N" .AND. ValType (ControlHandle) == "N"
      RETURN (Handle == ControlHandle)
   ENDIF

   IF ValType (Handle) == "A" .AND. ValType (ControlHandle) == "N"
      FOR i = 1 TO HMG_LEN (Handle)
         IF Handle [i] == ControlHandle
            RETURN .T.
         ENDIF
      NEXT
      RETURN .F.
   ENDIF

   IF ValType (Handle) == "N" .AND. ValType (ControlHandle) == "A"
      FOR i = 1 TO HMG_LEN (ControlHandle)
         IF Handle == ControlHandle [i]
            RETURN .T.
         ENDIF
      NEXT
      RETURN .F.
   ENDIF

   IF ValType (Handle) == "A" .AND. ValType (ControlHandle) == "A"
      FOR i = 1 TO HMG_LEN (Handle)
         FOR k = 1 TO HMG_LEN (ControlHandle)
            IF Handle [i] == ControlHandle [k]
               RETURN .T.
            ENDIF
         NEXT
      NEXT
      RETURN .F.
   ENDIF

   RETURN .F.
