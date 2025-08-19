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

#define TVE_COLLAPSE   1      // ok
#define TVE_EXPAND     2      // ok

*------------------------------------------------------------------------------*

FUNCTION _DefineTree ( ControlName , ParentForm , row , col , width , height , change , tooltip , ;
      FONTNAME , fontsize , gotfocus , lostfocus , dblclick , break , value  , HelpId , ;
      aImgNode, aImgItem, noBot , bold, italic, underline, strikeout , itemids , rootbutton , ;
      NoTrans , ON_EXPAND, ON_COLLAPSE, aBackColor, aFontColor, DynamicBackColor , DynamicForeColor , DynamicFont )
   *------------------------------------------------------------------------------*
   LOCAL i , cParentForm , Controlhandle , mVar, ImgDefNode, ImgDefItem, aBitmaps := array(4)
   LOCAL FontHandle , k, oControl

   oHmgApp():APP180 := 0
   oHmgApp():APP307 := 1
   oHmgApp():APP337 [1] := 0
   oHmgApp():APP138 := {}
   oHmgApp():APP139 := {}
   oHmgApp():APP259 := itemids

   IF valtype (rootbutton) == 'L'
      noBot := .NOT. RootButton
   ENDIF

   IF oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
      IF .NOT. Empty (oHmgApp():APP224) .AND. ValType(FontName) == "U"
         FONTNAME := oHmgApp():APP224
      ENDIF
      IF .NOT. Empty ( oHmgApp():ActiveFontSize ) .AND. ValType( FontSize ) == "U"
         FONTSIZE := oHmgApp():ActiveFontSize
      ENDIF
   ENDIF
   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         COL    := col + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         ROW    := row + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   IF valtype(Value) == "U"
      oHmgApp():APP178 := 0
   ELSE
      oHmgApp():APP178 := Value
   ENDIF
   IF valtype(Width) == "U"
      WIDTH := 120
   ENDIF
   IF valtype(Height) == "U"
      HEIGHT := 120
   ENDIF

   IF valtype(Row) == "U" .OR. valtype(Col) == "U"

      IF oHmgApp():APP216 == 'TOOLBAR'
         Break := .T.
      ENDIF

      i := GetFormIndex ( cParentForm )

      IF i > 0

         ControlHandle := InitTree ( FormByIndex( I ):FORM087 , col , row , width , height , 0 , '' , 0, iif(noBot,.T.,.F.) )
         IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
            FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
         ELSE
            FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
         ENDIF

         AddSplitBoxItem ( Controlhandle , FormByIndex( I ):FORM087 , Width , break , , , , oHmgApp():APP258 )

         oHmgApp():APP216 := 'TREE'

      ENDIF

   ELSE

      ControlHandle := InitTree ( ParentForm , col , row , width , height , 0 , '' , 0, iif(noBot,.T.,.F.) )
      IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize)
      ELSE
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343)
      ENDIF

   ENDIF

   ImgDefNode := iif( valtype( aImgNode ) == "A" , HMG_LEN( aImgNode ), 0 )  //Tree+
   ImgDefItem := iif( valtype( aImgItem ) == "A" , HMG_LEN( aImgItem ), 0 )  //Tree+

   ImgDefNode := IF (ImgDefNode > 2, 2, ImgDefNode)   // ADD  GET only first two NODE bitmaps
   ImgDefItem := IF (ImgDefItem > 2, 2, ImgDefItem)   // ADD  GET only first two ITEM bitmaps

   IF ImgDefNode > 0

      aBitmaps[1] := aImgNode[1]           // Node default
      aBitmaps[2] := aImgNode[ImgDefNode]

      IF ImgDefItem > 0

         aBitmaps[3] := aImgItem[1]        // Item default
         aBitmaps[4] := aImgItem[ImgDefItem]

      ELSE

         aBitmaps[3] := aImgNode[1]         // Copy Node def IF no Item def
         aBitmaps[4] := aImgNode[ImgDefNode]

      ENDIF

      InitTreeViewBitmap( ControlHandle, aBitmaps, NoTrans ) //Init Bitmap List
   ENDIF

   oHmgApp():APP180 := ControlHandle

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , ControlHandle )
   ENDIF

   IF valtype(change) == "U"
      change := ""
   ENDIF

   IF valtype(gotfocus) == "U"
      gotfocus := ""
   ENDIF

   IF valtype(lostfocus) == "U"
      lostfocus := ""
   ENDIF

   IF valtype(dblclick) == "U"
      dblclick := ""
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( K )

   oHmgApp():APP179 := k

   oControl:Type := "TREE"
   oControl:Name :=   ControlName
   oControl:Handle :=   ControlHandle
   oControl:ParentFormHandle :=   ParentForm
   oControl:CTRL005 :=   0
   oControl:CTRL006 :=   ""
   oControl:CTRL007 :=  {}      // nTreeItemHandle
   oControl:CTRL008 :=  Nil
   oControl:CTRL009 :=  itemids
   oControl:CTRL010 :=  lostfocus
   oControl:CTRL011 :=  gotfocus
   oControl:CTRL012 :=  change
   oControl:IsDeleted :=  .F.
   oControl:CTRL014 :=  Nil
   oControl:CTRL015 :=  Nil
   oControl:CTRL016 := dblclick
   oControl:CTRL017 := {ON_EXPAND, ON_COLLAPSE}
   oControl:CTRL018 := Row
   oControl:CTRL019 := Col
   oControl:CTRL020 := Width
   oControl:CTRL021 := Height
   oControl:CTRL022 := 0
   oControl:CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
   oControl:CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
   oControl:CTRL025 :=  {}     // nTreeItemID
   oControl:CTRL026 :=  { ImgDefNode, ImgDefItem }  // Numbers of bitmaps defined in NODEIMAGES and in ITEMIMAGES
   oControl:CTRL027 :=  fontname
   oControl:CTRL028 :=  fontsize
   oControl:CTRL029 := {bold,italic,underline,strikeout}
   oControl:CTRL030 :=  tooltip
   oControl:CTRL031 :=  0
   oControl:CTRL032 :=  {} // cargo
   oControl:CTRL033 :=  ''
   oControl:CTRL034 :=   .t.
   oControl:CTRL035 :=   HelpId
   oControl:CTRL036 :=  FontHandle
   oControl:CTRL037 :=   0
   oControl:CTRL038 :=   .T.
   oControl:CTRL039 := NoTrans
   oControl:CTRL040 := { DynamicBackColor , DynamicForeColor , DynamicFont , aBackColor, aFontColor, 0 /*hFontDynamic*/ , NIL , NIL }

   IF ValType (aFontColor) == "A"
      TreeView_SetTextColor (ControlHandle, aFontColor)
   ENDIF

   IF ValType (aBackColor) == "A"
      TreeView_SetBkColor (ControlHandle, aBackColor )
   ENDIF

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _DefineTreeNode ( text, aImage , nID )

   *------------------------------------------------------------------------------*
   LOCAL    ImgDef, iUnSel, iSel
   LOCAL k := GetControlIndexByHandle ( oHmgApp():APP180 )

   IF ValType ( nID ) == 'U'
      nID := 0
   ENDIF

   ImgDef := iif( valtype( aImage ) == "A" , HMG_LEN( aImage ), 0 )  //Tree+

   IF ImgDef == 0

      iUnsel := 0   // INDEX to defalut Node Bitmaps, no Bitmap loaded
      iSel   := 1

   ELSE
      iUnSel := AddTreeViewBitmap( oHmgApp():APP180, aImage[1], ControlByIndex( K ):CTRL039 ) -1
      iSel   := iif( ImgDef == 1, iUnSel, AddTreeViewBitmap( oHmgApp():APP180, aImage[2], ControlByIndex( K ):CTRL039 ) -1 )
      // IF only one bitmap in array iSel = iUnsel, only one Bitmap loaded
   ENDIF

   oHmgApp():APP307++
   oHmgApp():APP337 [oHmgApp():APP307]:= AddTreeItem ( oHmgApp():APP180 , oHmgApp():APP337 [oHmgApp():APP307-1] , text, iUnsel, iSel , nID , _IS_TREE_NODE_ )
   aAdd ( oHmgApp():APP138 , oHmgApp():APP337 [oHmgApp():APP307] )
   aAdd ( oHmgApp():APP139 , nID )
   AADD ( ControlByIndex( oHmgApp():APP179 ):CTRL032, NIL)   // cargo

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EndTreeNode()

   *------------------------------------------------------------------------------*

   oHmgApp():APP307--

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _DefineTreeItem ( text, aImage , nID )

   *------------------------------------------------------------------------------*
   LOCAL ItemHandle, ImgDef, iUnSel, iSel
   LOCAL k := GetControlIndexByHandle ( oHmgApp():APP180 )

   IF ValType ( nID ) == 'U'
      nID := 0
   ENDIF

   ImgDef := iif( valtype( aImage ) == "A" , HMG_LEN( aImage ), 0 )  //Tree+

   IF ImgDef == 0

      iUnsel := 2   // INDEX to defalut Item Bitmaps, no Bitmap loaded
      iSel   := 3

   ELSE
      iUnSel := AddTreeViewBitmap( oHmgApp():APP180, aImage[1], ControlByIndex( K ):CTRL039 ) -1
      iSel   := iif( ImgDef == 1, iUnSel, AddTreeViewBitmap( oHmgApp():APP180, aImage[2], ControlByIndex( K ):CTRL039 ) -1 )
      // IF only one bitmap in array iSel = iUnsel, only one Bitmap loaded
   ENDIF

   ItemHandle := AddTreeItem ( oHmgApp():APP180 , oHmgApp():APP337 [oHmgApp():APP307] , text, iUnSel, iSel , nID, _IS_TREE_ITEM_ )
   aAdd ( oHmgApp():APP138 , ItemHandle )
   aAdd ( oHmgApp():APP139 , nID )
   AADD ( ControlByIndex( oHmgApp():APP179 ):CTRL032, NIL)   // cargo

   RETURN Nil
   *------------------------------------------------------------------------------*

FUNCTION _EndTree()

   *------------------------------------------------------------------------------*

   ControlByIndex( oHmgApp():APP179 ):CTRL007 := oHmgApp():APP138
   ControlByIndex( oHmgApp():APP179 ):CTRL025 := oHmgApp():APP139

   IF oHmgApp():APP178 > 0

      IF oHmgApp():APP259 == .F.
         TreeView_SelectItem ( oHmgApp():APP180 , oHmgApp():APP138 [ oHmgApp():APP178 ] )
      ELSE
         TreeView_SelectItem ( oHmgApp():APP180 , oHmgApp():APP138 [ ascan ( oHmgApp():APP139 , oHmgApp():APP178 ) ] )
      ENDIF

   ENDIF

   RETURN Nil

   *------------------------------------------------------------------------------*

PROCEDURE _Collapse ( ControlName , ParentForm , nItem , lRecurse)

   *------------------------------------------------------------------------------*
   LOCAL i , ItemHandle

   i := GetControlIndex( ControlName , ParentForm )
   IF i > 0
      ItemHandle := TreeItemGetHandle ( ControlName , ParentForm , nItem )   // Dr. Claudio Soto (November 2013)
      IF ItemHandle <> 0
         DEFAULT lRecurse TO .F.
         TreeView_ExpandChildrenRecursive ( ControlByIndex( i ):Handle, ItemHandle, TVE_COLLAPSE, lRecurse )   // Dr. Claudio Soto (November 2013)
      ENDIF
   ENDIF

   RETURN

   *------------------------------------------------------------------------------*

PROCEDURE _Expand ( ControlName , ParentForm , nItem , lRecurse)

   *------------------------------------------------------------------------------*
   LOCAL i , ItemHandle

   i := GetControlIndex( ControlName , ParentForm )
   IF i > 0
      ItemHandle := TreeItemGetHandle ( ControlName , ParentForm , nItem )   // Dr. Claudio Soto (November 2013)
      IF ItemHandle <> 0
         DEFAULT lRecurse TO .F.
         TreeView_ExpandChildrenRecursive ( ControlByIndex( i ):Handle, ItemHandle, TVE_EXPAND, lRecurse )   // Dr. Claudio Soto (November 2013)
      ENDIF
   ENDIF

   RETURN

   //**********************************************
   // by Dr. Claudio Soto (November 2013)
   //**********************************************

PROCEDURE TreeItemCollapse2 ( i , nItem , lRecurse)

   LOCAL ItemHandle

   IF i > 0
      ItemHandle := TreeItemGetHandle2 ( i , nItem )
      IF ItemHandle <> 0
         DEFAULT lRecurse TO .F.
         TreeView_ExpandChildrenRecursive ( ControlByIndex( i ):Handle, ItemHandle, TVE_COLLAPSE, lRecurse )
      ENDIF
   ENDIF

   RETURN

PROCEDURE TreeItemExpand2 ( i , nItem , lRecurse)

   LOCAL ItemHandle

   IF i > 0
      ItemHandle := TreeItemGetHandle2 ( i , nItem )
      IF ItemHandle <> 0
         DEFAULT lRecurse TO .F.
         TreeView_ExpandChildrenRecursive ( ControlByIndex( i ):Handle, ItemHandle, TVE_EXPAND, lRecurse )
      ENDIF
   ENDIF

   RETURN

FUNCTION TreeItemGetHandle2 ( i , nItem )

   LOCAL nPos, nID, ItemHandle := 0

   IF i > 0
      IF ControlByIndex( I ):CTRL009 == .F.
         nPos := nItem
         ItemHandle := ControlByIndex( I ):CTRL007 [ nPos ]   // nPos
      ELSE
         nID := nItem
         nPos := ASCAN ( ControlByIndex( I ):CTRL025 , nID ) // nID
         ItemHandle := ControlByIndex( I ):CTRL007 [ nPos ]
      ENDIF
   ENDIF

   RETURN ItemHandle

FUNCTION TreeItemGetHandle ( ControlName , ParentForm , nItem )

   LOCAL nPos, nID, ItemHandle := 0
   LOCAL i := GetControlIndex( ControlName , ParentForm )

   IF i > 0
      IF ControlByIndex( I ):CTRL009 == .F.
         nPos := nItem
         ItemHandle := ControlByIndex( I ):CTRL007 [ nPos ]   // nPos
      ELSE
         nID := nItem
         nPos := ASCAN ( ControlByIndex( I ):CTRL025 , nID ) // nID
         ItemHandle := ControlByIndex( I ):CTRL007 [ nPos ]
      ENDIF
   ENDIF

   RETURN ItemHandle

FUNCTION TreeItemGetParentHandle ( ControlName , ParentForm , nItem )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   RETURN TREEVIEW_GETPARENT ( nControlHandle, ItemHandle )

FUNCTION TreeItemGetRootHandle ( ControlName , ParentForm)

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )

   RETURN TREEVIEW_GETROOT ( nControlHandle )

FUNCTION TreeItemGetValueByItemHandle ( ControlName , ParentForm , ItemHandle )

   LOCAL nPos, nID
   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL i := GetControlIndex  ( ControlName , ParentForm )

   IF i > 0 .AND. ItemHandle <> 0
      IF ControlByIndex( I ):CTRL009 == .F.
         nPos := ASCAN ( ControlByIndex( I ):CTRL007, ItemHandle )
         RETURN nPos
      ELSE
         nID := TREEITEM_GETID ( nControlHandle, ItemHandle )
         RETURN nID
      ENDIF
   ENDIF

   RETURN Nil

FUNCTION TreeItemGetValueByItemHandle2 ( i , ItemHandle )

   LOCAL nPos, nID
   LOCAL nControlHandle := GetControlHandleByIndex ( i )

   IF i > 0 .AND. ItemHandle <> 0
      IF ControlByIndex( I ):CTRL009 == .F.
         nPos := ASCAN ( ControlByIndex( I ):CTRL007, ItemHandle )
         RETURN nPos
      ELSE
         nID := TREEITEM_GETID ( nControlHandle, ItemHandle )
         RETURN nID
      ENDIF
   ENDIF

   RETURN Nil

   //----------------------------------------------------------------------------

FUNCTION TreeGetImageCount ( ControlName , ParentForm )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )

   RETURN TREEVIEW_GETIMAGECOUNT ( nControlHandle )

FUNCTION TreeAddImage ( ControlName , ParentForm ,  cImageName )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL k := GetControlIndex ( ControlName , ParentForm )

   RETURN ADDTREEVIEWBITMAP ( nControlHandle , cImageName, ControlByIndex( K ):CTRL039 )

   //----------------------------------------------------------------------------

FUNCTION TreeItemGetAllValue ( ControlName , ParentForm )

   LOCAL k, aAllValues := {}
   LOCAL i := GetControlIndex  ( ControlName , ParentForm )

   IF i > 0 .AND. GetProperty ( ParentForm, ControlName, "ItemCount" ) > 0
      IF ControlByIndex( I ):CTRL009 == .F.
         FOR k = 1 TO GetProperty ( ParentForm, ControlName, "ItemCount" )
            AADD (aAllValues, k)
         NEXT
      ELSE
         aAllValues := ControlByIndex( I ):CTRL025   // nTreeItemID
      ENDIF
   ENDIF

   RETURN IF (Empty(aAllValues), NIL, aAllValues)

FUNCTION TreeItemGetRootValue ( ControlName , ParentForm )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetRootHandle ( ControlName , ParentForm )

   RETURN TreeItemGetValueByItemHandle ( ControlName , ParentForm , ItemHandle )

FUNCTION TreeItemGetFirstItemValue ( ControlName , ParentForm )

   LOCAL nIndex     := GetControlIndex ( ControlName , ParentForm )
   LOCAL nID , nPos := 1

   IF GetProperty ( ParentForm, ControlName, "ItemCount" ) > 0
      IF ControlByIndex( nIndex ):CTRL009 == .F.
         RETURN nPos
      ELSE
         nID := ControlByIndex( nIndex ):CTRL025 [nPos]
         RETURN nID
      ENDIF
   ENDIF

   RETURN Nil

FUNCTION TreeItemGetParentValue ( ControlName , ParentForm , nItem )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetParentHandle ( ControlName , ParentForm , nItem )

   RETURN TreeItemGetValueByItemHandle ( ControlName , ParentForm , ItemHandle )

FUNCTION TreeItemGetChildValue ( ControlName , ParentForm , nItem )

   LOCAL ChildItem, NextItem, aChildValues := {}
   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   ChildItem := TreeView_GetChild ( nControlHandle , ItemHandle )
   WHILE (ChildItem <> 0)
      AADD (aChildValues, TreeItemGetValueByItemHandle(ControlName, ParentForm, ChildItem) )
      NextItem = TreeView_GetNextSibling ( nControlHandle , ChildItem )
      ChildItem = NextItem
   ENDDO

   RETURN IF (Empty(aChildValues), NIL, aChildValues)

FUNCTION TreeItemGetSiblingValue ( ControlName , ParentForm , nItem )

   LOCAL SiblingItem, FirstItem, NextItem, aSiblingValues := {}
   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   IF ItemHandle <> TreeItemGetRootHandle ( ControlName , ParentForm)
      FirstItem := SiblingItem := ItemHandle
      WHILE (SiblingItem <> 0)
         SiblingItem := TreeView_GetPrevSibling ( nControlHandle , FirstItem )
         IF SiblingItem <> 0
            FirstItem := SiblingItem
         ENDIF
      ENDDO
      SiblingItem := FirstItem
      WHILE (SiblingItem <> 0)
         AADD (aSiblingValues, TreeItemGetValueByItemHandle(ControlName, ParentForm, SiblingItem) )
         NextItem = TreeView_GetNextSibling ( nControlHandle , SiblingItem )
         SiblingItem = NextItem
      ENDDO
   ENDIF

   RETURN IF (Empty(aSiblingValues), NIL, aSiblingValues)

   //---------------------------------------------------------------------------------------

FUNCTION TreeItemGetDisplayLevel ( ControlName , ParentForm , nItem )

   LOCAL nDisplayColumn := NIL
   LOCAL aPathValues    := TreeItemGetPathValue ( ControlName , ParentForm , nItem )

   IF ValType (aPathValues) == "A"
      nDisplayColumn := HMG_LEN (aPathValues)
   ENDIF

   RETURN nDisplayColumn

FUNCTION TreeItemGetPathValue ( ControlName , ParentForm , nItem )

   LOCAL ParentItem, aPathValues := NIL
   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   IF ItemHandle <> 0
      aPathValues := { nItem }
      ParentItem := TreeView_GetParent ( nControlHandle , ItemHandle )
      WHILE (ParentItem <> 0)
         AADD (aPathValues, NIL)
         AINS (aPathValues,  1 )
         aPathValues [1] := TreeItemGetValueByItemHandle ( ControlName, ParentForm, ParentItem )
         ParentItem := TreeView_GetParent ( nControlHandle , ParentItem )
      ENDDO
   ENDIF

   RETURN aPathValues

FUNCTION TreeItemGetPathName ( ControlName , ParentForm , nItem )

   LOCAL aPathName   := NIL
   LOCAL aPathValues := TreeItemGetPathValue ( ControlName , ParentForm , nItem )

   IF ValType (aPathValues) == "A"
      aPathName := TreeItemGetItemText ( ControlName , ParentForm , aPathValues )
   ENDIF

   RETURN aPathName

FUNCTION TreeItemGetItemText ( ControlName , ParentForm , aItem )

   LOCAL k, cText, aItemsText := NIL

   IF ValType (aItem) == "A"
      aItemsText := {}
      FOR k = 1 TO HMG_LEN (aItem)
         cText := GetProperty ( ParentForm, ControlName, "Item", aItem [k] )
         AADD (aItemsText, cText)
      NEXT
   ENDIF

   RETURN aItemsText

   //---------------------------------------------------------------------------------------

FUNCTION TreeItemIsTrueNode ( ControlName , ParentForm , nItem )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   RETURN TREEITEM_ISTRUENODE ( nControlHandle, ItemHandle )

FUNCTION TreeItemSetNodeFlag ( ControlName , ParentForm , nItem , lNodeFlag)

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   RETURN TREEITEM_SETNODEFLAG ( nControlHandle, ItemHandle, lNodeFlag )

FUNCTION TreeItemGetNodeFlag ( ControlName , ParentForm , nItem )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   RETURN TREEITEM_GETNODEFLAG ( nControlHandle, ItemHandle )

FUNCTION TreeItemSetImageIndex ( ControlName , ParentForm , nItem , aSel)

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   RETURN TREEITEM_SETIMAGEINDEX ( nControlHandle , ItemHandle , aSel[1] , aSel[2] )   // { iUnSel , iSel }

FUNCTION TreeItemGetImageIndex ( ControlName , ParentForm , nItem )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )

   RETURN TREEITEM_GETIMAGEINDEX ( nControlHandle , ItemHandle )   // { iUnSel , iSel }

   //--------------------------------------------------------------------------------

PROCEDURE TreeItemSetDefaultNodeFlag ( ControlName , ParentForm , nItem )

   IF TreeItemIsTrueNode ( ControlName , ParentForm , nItem ) == .T. .AND. TreeItemGetNodeFlag ( ControlName , ParentForm , nItem ) == .F.
      TreeItemSetNodeFlag   ( ControlName , ParentForm , nItem , _IS_TREE_NODE_ )
      TreeItemSetImageIndex ( ControlName , ParentForm , nItem , TREEIMAGEINDEX_NODE )   // { iUnSel = 0 , iSel = 1 }

   ELSEIF TreeItemIsTrueNode ( ControlName , ParentForm , nItem ) == .F. .AND. TreeItemGetNodeFlag ( ControlName , ParentForm , nItem ) == .T.
      TreeItemSetNodeFlag   ( ControlName , ParentForm , nItem , _IS_TREE_ITEM_ )
      TreeItemSetImageIndex ( ControlName , ParentForm , nItem , TREEIMAGEINDEX_ITEM )   // { iUnSel = 2 , iSel = 3 }
   ENDIF

   RETURN

PROCEDURE TreeItemSetDefaultAllNodeFlag ( ControlName , ParentForm )

   LOCAL k, ItemHandle, aSel
   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL nIndex := GetControlIndex ( ControlName , ParentForm )

   FOR k = 1 TO GetProperty ( ParentForm, ControlName, "ItemCount" )
      ItemHandle := ControlByIndex( nIndex ):CTRL007 [k]
      IF TREEITEM_ISTRUENODE ( nControlHandle, ItemHandle ) == .T. .AND. TREEITEM_GETNODEFLAG ( nControlHandle, ItemHandle ) == .F.
         aSel := TREEIMAGEINDEX_NODE
         TREEITEM_SETNODEFLAG   ( nControlHandle, ItemHandle, _IS_TREE_NODE_ )
         TREEITEM_SETIMAGEINDEX ( nControlHandle, ItemHandle,  aSel[1] , aSel[2] )   // { iUnSel = 0 , iSel = 1 }

      ELSEIF TREEITEM_ISTRUENODE ( nControlHandle, ItemHandle ) == .F. .AND. TREEITEM_GETNODEFLAG ( nControlHandle, ItemHandle ) == .T.
         aSel := TREEIMAGEINDEX_ITEM
         TREEITEM_SETNODEFLAG   ( nControlHandle, ItemHandle, _IS_TREE_ITEM_ )
         TREEITEM_SETIMAGEINDEX ( nControlHandle, ItemHandle,  aSel[1] , aSel[2] )   // { iUnSel = 2 , iSel = 3 }
      ENDIF
   NEXT

   RETURN

   //------------------------------------------------------------------------

PROCEDURE TreeItemSort (cTreeName, cFormName, nItem, lRecurse, lCaseSensitive, lAscendingOrder, nNodePosition)

   LOCAL nIndex, nControlHandle, nItemHandle

   nIndex          := GetControlIndex   ( cTreeName, cFormName )
   nControlHandle  := GetControlHandle  ( cTreeName, cFormName )

   IF ValType (nItem) == "U"
      nItemHandle := TreeView_GetRoot ( nControlHandle )
   ELSE
      nItemHandle := TreeItemGetHandle ( cTreeName, cFormName , nItem )
   ENDIF

   DEFAULT lRecurse        TO .T.
   DEFAULT lCaseSensitive  TO .F.
   DEFAULT lAscendingOrder TO .T.
   DEFAULT nNodePosition   TO TREESORTNODE_MIX

   TreeView_SortChildrenRecursiveCB (nControlHandle, nItemHandle, lRecurse, lCaseSensitive, lAscendingOrder, nNodePosition)

   RETURN

   //------------------------------------------------------------------------

FUNCTION TreeSetTextColor ( ControlName , ParentForm , aColor )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )

   RETURN TreeView_SetTextColor ( nControlHandle , aColor )

FUNCTION TreeSetBackColor ( ControlName , ParentForm , aColor )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )

   RETURN TreeView_SetBkColor ( nControlHandle , aColor )

FUNCTION TreeSetLineColor ( ControlName , ParentForm , aColor )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )

   RETURN TreeView_SetLineColor ( nControlHandle , aColor )

   //------------------------------------------------------------------------

#define TVIS_EXPANDED   32

FUNCTION TreeItemIsExpand ( ControlName , ParentForm , nItem )

   LOCAL nControlHandle := GetControlHandle  ( ControlName , ParentForm )
   LOCAL ItemHandle     := TreeItemGetHandle ( ControlName , ParentForm , nItem )
   LOCAL State          := TreeView_GetItemState (nControlHandle, ItemHandle, TVIS_EXPANDED)

   RETURN ( hb_bitAND (State, TVIS_EXPANDED) == TVIS_EXPANDED )

FUNCTION TreeItemIsExpand2 ( i , nItem )

   LOCAL nControlHandle := GetControlHandleByIndex ( i )
   LOCAL ItemHandle     := TreeItemGetHandle2 ( i , nItem )
   LOCAL State          := TreeView_GetItemState (nControlHandle, ItemHandle, TVIS_EXPANDED)

   RETURN ( hb_bitAND (State, TVIS_EXPANDED) == TVIS_EXPANDED )

   //-----------------------------------------------------------------------------

   *-----------------------------------------------------------------------------*

FUNCTION _DoTreeCustomDraw ( i , lParam )

   *-----------------------------------------------------------------------------*
   LOCAL DefaultBackColor := RGB (255, 255, 255)   // WHITE
   LOCAL DefaultForeColor := RGB (  0,   0,   0)   // BLACK
   LOCAL BackColor  :=  ControlByIndex( I ):CTRL040 [4]
   LOCAL FontColor  :=  ControlByIndex( I ):CTRL040 [5]
   LOCAL DynamicBackColor := ControlByIndex( I ):CTRL040 [1]
   LOCAL DynamicForeColor := ControlByIndex( I ):CTRL040 [2]
   LOCAL nRGB_BackColor, nRGB_ForeColor, aRGB
   LOCAL hFont

   IF ValType (BackColor) == "A"
      DefaultBackColor := RGB (BackColor[1], BackColor[2], BackColor[3])
   ENDIF

   IF ValType (FontColor) == "A"
      DefaultForeColor := RGB (FontColor[1], FontColor[2], FontColor[3])
   ENDIF

   nRGB_BackColor := DefaultBackColor
   nRGB_ForeColor := DefaultForeColor

   IF ValType (DynamicBackColor) == "B"
      aRGB := EVAL (DynamicBackColor)
      IF ValType (aRGB) == "A"
         nRGB_BackColor := RGB (aRGB[1], aRGB[2], aRGB[3])
      ENDIF
   ENDIF

   IF ValType (DynamicForeColor) == "B"
      aRGB := EVAL (DynamicForeColor)
      IF ValType (aRGB) == "A"
         nRGB_ForeColor := RGB (aRGB[1], aRGB[2], aRGB[3])
      ENDIF
   ENDIF

   hFont := _TreeCustomDrawFont ( i, lParam )

   RETURN TREE_SETBCFC (lParam , nRGB_BackColor, nRGB_ForeColor, hFont)

   *-----------------------------------------------------------------------------*

FUNCTION _TreeCustomDrawFont ( i, lParam )

   *-----------------------------------------------------------------------------*
   LOCAL cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut
   LOCAL hFontDynamic
   LOCAL DefaultFontHandle := ControlByIndex( I ):CTRL036
   LOCAL DynamicFont       := ControlByIndex( I ):CTRL040 [3]
   LOCAL DynamicData

   IF ValType (DynamicFont) == "B"
      DynamicData := EVAL (DynamicFont)
      IF ValType (DynamicData) == "A"
         IF HMG_LEN (DynamicData) < 6
            ASIZE (DynamicData, 6 )   // { cFontName, nFontSize, [ lBold, lItalic, lUnderline, lStrikeOut ] }
         ENDIF

         IF ValType (DynamicData [1]) == "C" .AND. .NOT. Empty(DynamicData [1]) .AND. ValType (DynamicData [2]) == "N" .AND. DynamicData [2] > 0
            cFontName  := DynamicData [1]
            nFontSize  := DynamicData [2]
            lBold      := DynamicData [3]
            lItalic    := DynamicData [4]
            lUnderline := DynamicData [5]
            lStrikeOut := DynamicData [6]

            hFontDynamic := ControlByIndex( I ):CTRL040 [6]
            IF hFontDynamic <> 0
               DeleteObject (hFontDynamic)
            ENDIF

            hFontDynamic := HMG_CreateFont (TreeView_CustomDraw_GetHDC (lParam), cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut )
            ControlByIndex( I ):CTRL040 [6] := hFontDynamic
            RETURN hFontDynamic   // <=== return new handle
         ENDIF

      ENDIF
   ENDIF

   RETURN DefaultFontHandle   // <=== return default handle
