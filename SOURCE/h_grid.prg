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
MEMVAR _HMG_SYSDATA
//MEMVAR _HMG_GridInplaceEdit_StageEvent   // Pre, Into, Post


FUNCTION GridInplaceEdit_ControlHandle()

   LOCAL nHandle

   nHandle := oHmgApp():GridInplaceEdit_ControlHandle

   RETURN nHandle

FUNCTION GridInplaceEdit_ControlIndex()

   LOCAL nIndex, nHandle

   nHandle := oHmgApp():GridInplaceEdit_ControlHandle
   nIndex  := GetControlIndexByHandle( nHandle )

   RETURN nIndex

FUNCTION GridInplaceEdit_GridName()

   LOCAL nIndex, cName := ""

   nIndex := oHmgApp():GridInplaceEdit_GridIndex
   IF nIndex > 0
      cName := ControlByIndex( nIndex ):Name
   ENDIF

   RETURN cName

FUNCTION GridInplaceEdit_ParentName()

   LOCAL hWnd, cFormName := "", nIndex

   nIndex := oHmgApp():GridInplaceEdit_GridIndex
   IF nIndex > 0
      hWnd := GetControlParentHandleByIndex ( nIndex )
      GetFormNameByHandle ( hWnd, @cFormName )
   ENDIF

   RETURN cFormName


#define WM_COMMAND  273
#define WM_SETFOCUS 7


#include 'hmg.ch'
#include 'common.ch'

#define _SHOWDELETEREC_   .F.

*-----------------------------------------------------------------------------*
Function _DefineGrid (   ControlName   , ;
         ParentForm   , ;
         x      , ;
         y      , ;
         w      , ;
         h      , ;
         aHeaders, ;
         aWidths, ;
         aRows, ;
         value      , ;
         fontname   , ;
         fontsize   , ;
         tooltip      , ;
         change      , ;
         dblclick   , ;
         aHeadClick   , ;
         gotfocus   , ;
         lostfocus   , ;
         NoGridLines      , ;
         aImage, ;
         aJust, ;
         break      , ;
         HelpId      , ;
         bold      , ;
         italic      , ;
         underline   , ;
         strikeout   , ;
         ownerdata   , ;
         ondispinfo   , ;
         itemcount   , ;
         available0   , ;
         available1   , ;
         available2   , ;
         multiselect   , ;
         available3   , ;
         backcolor   , ;
         fontcolor   , ;
         alloweditInplace   , ;
         editcontrols   , ;
         dynamicbackcolor ,;
         dynamicforecolor ,;
         columnvalid ,      ;
         columnwhen ,      ;
         columnheaders ,   ;
         aHeaderImages ,   ;
         cellnavigation ,  ;
         cRecordSource   , ;
         aColumnFields   , ;
         allowappend      , ;
         buffered   , ;
         allowdelete     , ;
         dynamicdisplay, ;
         onsave      , ;
         lockcolumns,;
         OnClick, OnKey, InplaceEditOption,;
         Notrans, NotransHeader,;
         aDynamicFont, OnCheckBoxClicked, OnInplaceEditEvent )
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar, wBitmap , k := 0
Local ControlHandle, oControl
Local FontHandle
Local cParentTabName
Local nHeaderImageListHandle := Nil
Local ldfc := .F.   // ADD3
Local aColumnClassMap := {}
Local aFieldNames := {}
Local j
LOCAL lArrayRows := .T.   // ADD3

Available0 := Nil
Available1 := Nil
Available2 := Nil
Available3 := Nil


   DEFAULT alloweditInplace TO .F.
   DEFAULT columnheaders TO .T.

   DEFAULT multiselect TO .F.
   DEFAULT InplaceEditOption TO GRID_EDIT_DEFAULT

   if ValType ( lockcolumns ) == 'U'
      lockcolumns := 0
   endif

   if ValType ( cRecordSource ) == 'C'

      If Select( cRecordSource ) == 0
         MsgHMGError ("Grid: 'RecordSource' WorkArea must be open at control definition. Program Terminated")
      EndIf

      ownerdata      := .t.
      itemcount      :=  0  // ADD, May 2016  // GridRecCount( cRecordSource )
      cellnavigation := .t.
      buffered       := .t.
      lArrayRows     := .F.   // ADD3

      aSize ( aColumnClassMap , HMG_LEN ( aHeaders ) )

      aSize ( aFieldNames , &cRecordSource->( FCOUNT() ) )

      &cRecordSource->( AFIELDS( aFieldNames ) )

      aFill ( aColumnClassMap , 'E' )

      For i := 1 To HMG_LEN ( aColumnFields )
         For j := 1 To HMG_LEN ( aFieldNames )
            If ALLTRIM( HMG_UPPER( aColumnFields [i] ) ) == ALLTRIM( HMG_UPPER( aFieldNames [j] ) )
               aColumnClassMap [ i ] := 'F'
               Exit
            EndIf
         Next
      Next

      if alloweditInplace
         if ValType(editcontrols) <> 'A'
            MsgHMGError ("Grid: 'ColumnControls' must be specified when 'RecordSource' was set. Program Terminated")
         endif
      endif

   endif


   If ValType(aColumnFields) == 'A'
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'ColumnFields' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If allowappend == .T.
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'AllowAppend' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If allowdelete == .T.
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'AllowDelete' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If buffered == .T.
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'Buffered' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If ValType(dynamicdisplay) == 'A'
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'DynamicDisplay' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   if oHmgApp():APP264 = .T.
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
      cParentTabName := oHmgApp():APP225
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError(oHmgApp():APP136[1]+ ParentForm + oHmgApp():APP136[2])
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError (oHmgApp():APP136[4] + ControlName + oHmgApp():APP136[5] + ParentForm + oHmgApp():APP136[6])
   endif


   // ADD April 2016
#define DEFAULT_COLUMNHEADER  "Column "
#define DEFAULT_COLUMNWIDTH   150
   IF lArrayRows == .T.
      IF ValType( aRows ) == "A" .AND. HMG_LEN( aRows ) > 0
         IF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "U"
            aHeaders := ARRAY( HMG_LEN( aRows[ 1 ] ))
            aWidths  := ARRAY( HMG_LEN( aRows[ 1 ] ))
            AEVAL( aHeaders, { |xValue,nIndex| xValue:= NIL, aHeaders[ nIndex ] := DEFAULT_COLUMNHEADER + hb_NtoS( nIndex ) } )
            AFILL( aWidths,  DEFAULT_COLUMNWIDTH )
         ELSEIF ValType( aHeaders ) == "A" .AND. ValType ( aWidths ) == "U"
            aWidths  := ARRAY( HMG_LEN( aHeaders ))
            AFILL( aWidths,  DEFAULT_COLUMNWIDTH )
         ELSEIF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "A"
            aHeaders := ARRAY( HMG_LEN( aWidths ))
            AEVAL( aHeaders, { |xValue,nIndex| xValue:= NIL, aHeaders[ nIndex ] := DEFAULT_COLUMNHEADER + hb_NtoS( nIndex ) } )
         ENDIF
      ELSE
         IF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "U"
            aHeaders := {}
            aWidths  := {}
         ELSEIF ValType( aHeaders ) == "A" .AND. ValType ( aWidths ) == "U"
            aWidths  := ARRAY( HMG_LEN( aHeaders ))
            AFILL( aWidths,  DEFAULT_COLUMNWIDTH )
         ELSEIF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "A"
            aHeaders := ARRAY( HMG_LEN( aWidths ))
            AEVAL( aHeaders, { |xValue,nIndex| xValue:= NIL, aHeaders[ nIndex ] := DEFAULT_COLUMNHEADER + hb_NtoS( nIndex ) } )
         ENDIF
      ENDIF
   ENDIF

   if ValType ( aWidths ) == 'U'
      MsgHMGError ("Grid: WIDTHS not defined .Program Terminated")
   EndIf

   if columnheaders == .F.
      aHeaders := array ( HMG_LEN ( aWidths ) )
      afill ( aHeaders , '' )
   endif

   if ValType ( aHeaders ) == 'U'
      MsgHMGError ("Grid: HEADERS not defined .Program Terminated")
   EndIf

   if HMG_LEN ( aHeaders ) != HMG_LEN ( aWidths )
      MsgHMGError ("Browse/Grid: FIELDS/HEADERS/WIDTHS array size mismatch .Program Terminated")
   EndIf

   if ValType (aRows) != 'U' .AND. lArrayRows == .T.   // ADD3
      if HMG_LEN (aRows) > 0 .AND. ValType (aRows [1]) == 'A'   // ADD
         if HMG_LEN (aRows[1]) != HMG_LEN ( aHeaders )
            MsgHMGError ("Grid: ITEMS length mismatch. Program Terminated")
         EndIf
      EndIf
   EndIf

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm = ParentForm

   ParentForm = GetFormHandle (ParentForm)

   if ValType(w) == "U"
      w := 240
   endif
   if ValType(h) == "U"
      h := 120
   endif
   if ValType(value) == "U" .and. !MultiSelect
      value := 0
   endif
   if ValType(aRows) == "U"
      aRows := {}
   endif
   if ValType(aJust) == "U"      // Grid+
      aJust := Array( HMG_LEN( aHeaders ) )
      aFill( aJust, 0 )
   else
      aSize( aJust, HMG_LEN( aHeaders ) )
      aEval( aJust, { |x| x := iif( x == NIL, 0, x ) } )
   endif
   if ValType(aImage) == "U"        // Grid+
      aImage := {}
   endif

   if ValType(x) == "U" .or. ValType(y) == "U"

      If oHmgApp():APP216 == 'TOOLBAR'
         Break := .T.
      EndIf

      oHmgApp():APP216   := 'GRID'

      i := GetFormIndex ( cParentForm )

      if i > 0

         ControlHandle := InitListView ( FormByIndex( I ):FORM087 , 0, 0, 0, w, h ,'',0, NoGridLines, ownerdata , itemcount , multiselect , columnheaders )

         if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
            FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
         Else
            FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
         endif

         AddSplitBoxItem ( Controlhandle, FormByIndex( I ):FORM087 , w , break , , , , oHmgApp():APP258 )
      EndIf

   Else

      ControlHandle := InitListView ( ParentForm, 0, x, y, w, h ,'',0, NoGridLines, ownerdata  , itemcount  , multiselect , columnheaders )

      if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
      Else
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
      endif

   endif

   If ValType (backcolor) != 'U'
      ListView_SetBkColor ( ControlHandle , backcolor[1] , backcolor[2] , backcolor[3] )
      ListView_SetTextBkColor ( ControlHandle , backcolor[1] , backcolor[2] , backcolor[3]  )
   EndIf

   If ValType (fontcolor) != 'U'
      ListView_SetTextColor ( ControlHandle , fontcolor[1] , fontcolor[2] , fontcolor[3]  )
   EndIf

   wBitmap := iif( HMG_LEN( aImage ) > 0, AddListViewBitmap( ControlHandle, aImage, Notrans ), 0 )

   IF HMG_LEN( aWidths ) == 0
      aWidths := {0}   // ADD April 2016
   ENDIF

   aWidths[1] := max ( aWidths[1], wBitmap + 2 ) // Set Column 1 width to Bitmap width

   If oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , ControlHandle )
   EndIf

   if ValType(aHeadClick) == "U"
      aHeadClick := {}
   endif

   if ValType(change) == "U"
      change := ""
   endif

   if ValType(dblclick) == "U"
      dblclick := ""
   endif

   if ValType(tooltip) != "U"
           SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   IF ValType (aDynamicFont) == "A"
      if HMG_LEN ( aHeaders ) <> HMG_LEN ( aDynamicFont )
         MsgHMGError ("Grid: DYNAMIC FONT array size mismatch .Program Terminated")
      EndIf
   ENDIF

   k := _GetControlFree()

   Public &mVar. := k

   oControl := ControlByIndex( K )
   WITH OBJECT oControl
      :Type :=  if ( multiselect , "MULTIGRID" , "GRID" )
      :Name :=  ControlName
      :Handle :=  ControlHandle
      :ParentFormHandle :=  ParentForm
      :CTRL005 :=  ListView_GetHeader ( ControlHandle )
      :CTRL006 :=  ondispinfo
      :CTRL007 :=  aHeaders
      :CTRL008 :=  Value
      :CTRL009 :=  Nil
      :CTRL010 :=  lostfocus
      :CTRL011 :=  gotfocus
      :CTRL012 :=  change
      :IsDeleted :=  .F.
      :CTRL014 :=  aImage
      :CTRL015 :=  1       // nCol cellnavigation
      :CTRL016 :=  dblclick
      :CTRL017 :=  aHeadClick
      :CTRL018 :=  y
      :CTRL019 :=  x
      :CTRL020 :=  w
      :CTRL021 :=  h
      :CTRL022 :=  Nil
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  Nil
      :CTRL026 :=  0  // nHeaderImageListHandle
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  tooltip
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  cellnavigation
      :CTRL033 :=  aHeaders
      :CTRL034 :=  .t.
      :CTRL035 :=  HelpId
      :CTRL036 :=  FontHandle
      :CTRL037 :=  aJust
      :CTRL038 :=  .T.
      :CTRL039 :=  0       // nRow cellnavigation
      :CTRL040 := Array (47)

      :CTRL040 [  1 ] := alloweditInplace   // Allow ENTER
      :CTRL040 [  2 ] := editcontrols
      :CTRL040 [  3 ] := dynamicbackcolor
      :CTRL040 [  4 ] := dynamicforecolor
      :CTRL040 [  5 ] := columnvalid
      :CTRL040 [  6 ] := columnwhen
      :CTRL040 [  7 ] := NIL // old internal dynamicforecolor --> ARRAY (nRowCount , nColCount)
      :CTRL040 [  8 ] := NIL // old internal dynamicforecolor --> ARRAY (nRowCount , nColCount)
      :CTRL040 [  9 ] := OWNERDATA
      :CTRL040 [ 10 ] := cRecordSource
      :CTRL040 [ 11 ] := aColumnFields
      :CTRL040 [ 12 ] := allowappend   // Allow ALT+A
      :CTRL040 [ 13 ] := if ( ValType (aColumnFields) == 'A' , array ( HMG_LEN (aColumnFields) ) , Nil )
      :CTRL040 [ 14 ] := .F.   // old Grid
      :CTRL040 [ 15 ] := buffered
      :CTRL040 [ 16 ] := ldfc
      :CTRL040 [ 17 ] := allowdelete   // Allow ALT+D and ALT+R
      :CTRL040 [ 18 ] := dynamicdisplay
      :CTRL040 [ 19 ] := .F.
      :CTRL040 [ 20 ] := .F. // Pending Edit Updates Flag
      :CTRL040 [ 21 ] := {}  // Edit Updates Buffer
      :CTRL040 [ 22 ] := 0   // Appended Record Buffer Count ( Negative )
      :CTRL040 [ 23 ] := ItemCount // Buffered Session Initial ItemCount
      :CTRL040 [ 24 ] :=  0 // Deleted / Recalled record count
      :CTRL040 [ 25 ] := {} // Delete / Recall Buffer Array { nLogicalRow , nPhysicalRow , cStatus ( 'D' or 'R' ) }
      :CTRL040 [ 26 ] := OnSave
      :CTRL040 [ 27 ] := NIL // old internal Enable Virtual Database Grid Optimization
      :CTRL040 [ 28 ] := backcolor
      :CTRL040 [ 29 ] := fontcolor
      :CTRL040 [ 30 ] := aColumnClassMap
      :CTRL040 [ 31 ] := aWidths
      :CTRL040 [ 32 ] := lockcolumns
      :CTRL040 [ 33 ] := .T.  // ENABLEUPDATE = .T. | DISABLEUPDATE = .F.
      :CTRL040 [ 34 ] := .T.
      :CTRL040 [ 35 ] := OnClick   // ADD
      :CTRL040 [ 36 ] := OnKey     // ADD
      :CTRL040 [ 37 ] := {0,0}   // CellRowClicked and CellColClicked       // ADD
      :CTRL040 [ 38 ] := IF (ValType(InplaceEditOption) == "N", InplaceEditOption, 0)
      :CTRL040 [ 39 ] := NotransHeader
      :CTRL040 [ 40 ] := cParentForm    // ADD
      :CTRL040 [ 41 ] := aDynamicFont   // ADD
      :CTRL040 [ 42 ] := 0              // hFont_Dynamic
      :CTRL040 [ 43 ] := NIL            // aHeaderFont
      :CTRL040 [ 44 ] := NIL            // aHeaderBackColor
      :CTRL040 [ 45 ] := NIL            // aHeaderForeColor
      :CTRL040 [ 46 ] := OnCheckBoxClicked
      :CTRL040 [ 47 ] := OnInplaceEditEvent
   ENDWITH

   InitListViewColumns ( ControlHandle, aHeaders , aWidths, aJust )


IF ValType ( cRecordSource ) == 'C'   // ADD, May 2016
   ItemCount := GridRecCount( K )
   oControl:CTRL040 [ 23 ] := ItemCount
   ListView_SetItemCount ( ControlHandle , ItemCount )
ENDIF


IF lArrayRows == .T.   // ADD3
   for i := 1 to HMG_LEN (aRows)
      _AddGridRow ( ControlName, cParentForm, aRows [i] )
   next
ENDIF

   if multiselect == .T.

      if ValType ( value ) == 'A'
         ListViewSetMultiSel (ControlHandle,value)
      endif

   Else

      If CellNavigation == .T.
         _SetValue ( , , Value , k )
      Else

         if Value <> 0
            ListView_SetCursel (ControlHandle , Value )
         endif

      EndIf

   EndIf

   If ValType(aHeaderImages) <> "U"
      nHeaderImageListHandle := SetListViewHeaderImages ( ControlHandle , aHeaderImages , aJust, NotransHeader )
      ControlByIndex( K ):CTRL022 := aHeaderImages
      ControlByIndex( K ):CTRL026 := nHeaderImageListHandle
   EndIf


Return Nil




//*****************************************************
//* by Dr. Claudio Soto, April 2014
//*****************************************************


FUNCTION _HMG_GridOnClickAndOnKeyEvent
LOCAL ret := NIL, lInplacedEdit := .F.
LOCAL oControlI := ControlByHandle( EventHWND() )
LOCAL I := iif( oControlI == Nil, 0, oControlI:Index )

   IF i > 0 .AND. ( EventHWND() == oHmgApp():GridInplaceEdit_ControlHandle )
      i := oHmgApp():GridInplaceEdit_GridIndex
      lInplacedEdit := .T.
   ENDIF

   IF i > 0 .AND. ( ControlByIndex( i ):Type == "GRID" .OR. ControlByIndex( i ):Type == "MULTIGRID" )

      oHmgApp():GridEx_InplaceEdit_nMsg  := EventMSG()
      oHmgApp():GridEx_InplaceEditOption := ControlByIndex( I ):CTRL040 [38]

      IF EventMSG() == WM_SETFOCUS
         HMG_GetLastCharacterEx()
      ENDIF

      IF ( EventMSG() == WM_LBUTTONDOWN .OR. EventMSG() == WM_LBUTTONDBLCLK ) .AND. ValType( ControlByIndex( I ):CTRL040 [35] ) == "B"
         IF lInplacedEdit == .F.
            ControlByIndex( I ):CTRL040 [37] := _GetGridCellData (i)   // { CellRowClicked, CellColClicked }
         ENDIF
         ret := EVAL ( ControlByIndex( I ):CTRL040 [35] )   // OnClick Event
      ENDIF

      IF oHmgApp():EventIsKeyboardMessage == .T. .AND. ValType( ControlByIndex( I ):CTRL040 [36] ) == "B"
         ret := EVAL ( ControlByIndex( I ):CTRL040 [36] )   // OnKey Event
      ENDIF

      IF lInplacedEdit == .F.
         IF ValType(ret) <> "N" .AND. EventMSG() == WM_CHAR .AND. oHmgApp():GridEx_InplaceEditOption >= 1 .AND. oHmgApp():GridEx_InplaceEditOption <= 4
            ret := Events (0, WM_COMMAND, 1, 0)
         ENDIF
      ENDIF

   ENDIF

RETURN ret


FUNCTION _HMG_GridInplaceEditEvent
__THREAD STATIC Flag := .F.

   IF ValType ( oHmgApp():GridInplaceEdit_ControlHandle) == "N" .AND. oHmgApp():GridInplaceEdit_ControlHandle <> 0
      IF Flag == .F.
         Flag := .T.

         IF oHmgApp():GridEx_InplaceEdit_nMsg == WM_LBUTTONDBLCLK
            HMG_GetLastCharacterEx()
         ENDIF

         IF oHmgApp():GridEx_InplaceEditOption == 2
            _PushKey (VK_END)
         ELSEIF oHmgApp():GridEx_InplaceEditOption == 3
            SendMessage ( oHmgApp():GridInplaceEdit_ControlHandle, WM_KEYDOWN, VK_END, 0)
            SendMessage ( oHmgApp():GridInplaceEdit_ControlHandle, WM_KEYUP,   VK_END, 0)
            HMG_SendCharacterEx ( oHmgApp():GridInplaceEdit_ControlHandle, HMG_GetLastCharacterEx())
            _PushKey (VK_END)
         ELSEIF oHmgApp():GridEx_InplaceEditOption == 4
            IF oHmgApp():GridEx_InplaceEdit_nMsg == WM_LBUTTONDBLCLK
               _PushKey (VK_BACK)
            ELSE
               HMG_SendCharacter ( oHmgApp():GridInplaceEdit_ControlHandle, HMG_GetLastCharacterEx())
            ENDIF
         ENDIF
      ENDIF
   ELSE
      Flag := .F.
   ENDIF
RETURN NIL



// Enhanced by Dr. Claudio Soto (April 2013)
*-----------------------------------------------------------------------------*
Function _AddGridRow ( ControlName, ParentForm, aItem, nRowIndex )
*-----------------------------------------------------------------------------*
Local i, hWnd, k
LOCAL iImage := 0, aTemp

   i := GetControlIndex  ( ControlName, ParentForm )

   hWnd := GetControlHandle ( ControlName, ParentForm )

   IF ValType (nRowIndex) == "U"
      nRowIndex := ListView_GetItemCount (hWnd) + 1
   ELSEIF nRowIndex > (ListView_GetItemCount(hWnd) + 1)
      MsgHMGError ("Grid.AddItem (nRowIndex = " +ALLTRIM(STR(nRowIndex))+ "): Invalid nRowIndex. Program Terminated")
   ENDIF

   if HMG_LEN ( ControlByIndex( I ):CTRL007 ) != HMG_LEN ( aItem )
      MsgHMGError ("Grid.AddItem (nRowIndex = " +ALLTRIM(STR(nRowIndex))+ "): Item size mismatch. Program Terminated")
   EndIf

   IF ValType ( ControlByIndex( I ):CTRL040 [2] ) == 'A'   // editcontrols

      aTemp := ARRAY ( HMG_LEN(aItem) )
      AFILL ( aTemp , '' )
      if HMG_LEN( ControlByIndex( I ):CTRL014 ) > 0   // aImage
         iImage   := aItem[1]
         aItem[1] := NIL
         aTemp[1] := NIL
      endif
      AddListViewItems ( hWnd , aTemp , iImage , nRowIndex-1)
      _SetItem ( ControlName , ParentForm , nRowIndex , aItem )

   ELSE

      if HMG_LEN( ControlByIndex( I ):CTRL014 ) > 0   // aImage
         iImage   := aItem[1]
         aItem[1] := NIL
      endif

      aTemp := ACLONE( aItem )
      FOR k := 1 TO HMG_LEN( aTemp )   // by Dr. Claudio Soto, April 2016
         IF ValType( aTemp[ k ] ) <> "C" .AND. ValType( aTemp[ k ] ) <> "U"
            aTemp[ k ] := hb_ValToStr( aTemp[ k ] )
         ENDIF
      NEXT

      AddListViewItems ( hWnd , aTemp, iImage , nRowIndex-1)

   ENDIF
Return Nil



// by Dr. Claudio Soto (April 2013)
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Procedure _AddGridColumn ( cControlName , cParentForm , nColIndex , cCaption , nWidth , nJustify, aColumnControl)
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
LOCAL lRefresh
LOCAL k, nWidth_sum := 0

   If ValType ( nColIndex ) == 'U'
      nColIndex := _GridEx_ColumnCount (cControlName , cParentForm) + 1
   EndIf

   If ValType ( cCaption ) == 'U'
      cCaption := ''
   EndIf

   If ValType ( nWidth ) == 'U'
      nWidth := 120
   EndIf

   If ValType ( nJustify ) == 'U'
      nJustify := GRID_JTFY_LEFT
   EndIf

   If ValType ( aColumnControl ) == 'U'
      aColumnControl := {'TEXTBOX','CHARACTER'}
   EndIf

   _GridEx_AddColumnEx (cControlName, cParentForm, nColIndex)
   lRefresh := .F.
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_HEADER_,    nColIndex, cCaption,       lRefresh)
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_WIDTH_,     nColIndex, nWidth,         lRefresh)
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_JUSTIFY_,   nColIndex, nJustify,       lRefresh)
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_CONTROL_,   nColIndex, aColumnControl, lRefresh)

   LISTVIEW_ADDCOLUMN (GetControlHandle(cControlName,cParentForm), nColIndex , nWidth , cCaption , nJustify )   // Call C-Level Routine (source c_grid.c)

   IF SET_GRID_DELETEALLITEMS () == .T.
      RETURN   // for compatibility with old behavior of ADDCOLUMN and DELETECOLUMN
   ENDIF

   FOR k = 1 TO _GridEx_ColumnCount(cControlName,cParentForm)
       nWidth_sum := nWidth_sum + LISTVIEW_GETCOLUMNWIDTH (GetControlHandle (cControlName, cParentForm), k-1)
   NEXT
   IF nWidth_sum > GetProperty (cParentForm, cControlName, "Width")
      #define SB_HORZ   0
      #define SB_VERT   1
      #define SB_CTL    2
      #define SB_BOTH   3
      k := GetScrollRangeMax ( GetControlHandle(cControlName,cParentForm), SB_HORZ )
      SETSCROLLRANGE ( GetControlHandle(cControlName,cParentForm), SB_HORZ, 0, k + LISTVIEW_GETCOLUMNWIDTH (GetControlHandle (cControlName, cParentForm), nColIndex-1), .T. )
      SHOWSCROLLBAR (GetControlHandle(cControlName,cParentForm), SB_HORZ, .T.)
   ENDIF

   _GridEx_UpdateCellValue (cControlName, cParentForm, nColIndex)   // Force the rewrite the all items of the Column(nColumnIndex)

   REDRAWWINDOW (GetControlHandle (cControlName, cParentForm))
   UpdateWindow (GetControlHandle (cControlName, cParentForm))
Return


// by Dr. Claudio Soto (April 2013)
*-----------------------------------------------------------------------------------*
Procedure _DeleteGridColumn ( cControlName , cParentForm , nColIndex)
*-----------------------------------------------------------------------------------*
LOCAL nItemCount
   _GridEx_DeleteColumnEx (cControlName, cParentForm, nColIndex)
   ListView_DeleteColumn ( GetControlHandle(cControlName,cParentForm), nColIndex )   // Call C-Level Routine (source c_grid.c)

   IF SET_GRID_DELETEALLITEMS () == .T.
      RETURN   // for compatibility with old behavior of ADDCOLUMN and DELETECOLUMN
   ENDIF

   nItemCount := ListView_GetItemCount (GetControlHandle(cControlName,cParentForm))
   LISTVIEW_REDRAWITEMS (GetControlHandle(cControlName,cParentForm) , 0, nItemCount-1)
   REDRAWWINDOW (GetControlHandle (cControlName, cParentForm))
   UpdateWindow (GetControlHandle (cControlName, cParentForm))
Return



*-----------------------------------------------------------------------------*
FUNCTION _HMG_GRIDINPLACEEDIT(IDX)
*-----------------------------------------------------------------------------*
Local r , c , h , aTemp , ri , ci , DW := 0, DH := 0 , DR := 0 , DC := 0
LOCAL AEDITCONTROLS
LOCAL AEC := 'TEXTBOX'
LOCAL AITEMS := {}
LOCAL ARANGE := {}
LOCAL DTYPE := 'D'
LOCAL ALABELS := { '.T.' ,'.F.' }
LOCAL CTYPE := 'CHARACTER'
LOCAL CINPUTMASK := ''
LOCAL CFORMAT := ''
LOCAL XRES := {}
LOCAL CVA
LOCAL CWH
LOCAL WHEN
LOCAL GFN
LOCAL GFS
LOCAL V
Local nWx := 0
Local nHx := 0
LOCAL ARETURNVALUES
LOCAL Z
Local xValue := 0
Local cRecordSource
Local cTextFile
LOCAL nIndex := 0, cProc

oHmgApp():GridInplaceEdit_GridIndex := IDX  // ADD

/*
   AEDITCONTROLS := ControlByIndex( IDX ):CTRL040 [ 2 ]
   IF ValType (AEDITCONTROLS) == "A" .AND. HMG_LEN (AEDITCONTROLS) >= This.CellRowIndex
      IF ValType (AEDITCONTROLS [This.CellRowIndex]) == "A" .AND. HMG_LEN (AEDITCONTROLS [This.CellRowIndex]) >= 2
         IF ValType (AEDITCONTROLS [This.CellRowIndex] [1]) == "C" .AND. ValType (AEDITCONTROLS [This.CellRowIndex] [2]) == "B"
            IF HMG_UPPER (AEDITCONTROLS [This.CellRowIndex] [1]) == 'CUSTOM'
               EVAL (AEDITCONTROLS [This.CellRowIndex] [2])
               RETURN .T.
            ENDIF
         ENDIF
      ENDIF
   ENDIF
*/

   If oHmgApp():ThisEventType == 'GRID_WHEN'
      MsgHMGError("GRID: Editing within a grid 'when' event procedure is not allowed. Program terminated" )
   EndIf
   If oHmgApp():ThisEventType == 'GRID_VALID'
      MsgHMGError("GRID: Editing within a grid 'valid' event procedure is not allowed. Program terminated" )
   EndIf


   IF ControlByIndex( IDX ):CTRL032 == .F.

      If This.CellRowIndex != LISTVIEW_GETFIRSTITEM ( ControlByIndex( IDX ):Handle )
         Return .f.
      EndIf

   ELSE

      If This.CellRowIndex != ControlByIndex( IDX ):CTRL039
         Return .f.
      EndIf

   ENDIF

   ri := This.CellRowIndex
   ci := This.CellColIndex


   if ri == 0 .or. ci == 0
      return  .f.
   endif


   IF ValType ( ControlByIndex( IDX ):CTRL040 [ 10 ] ) == 'C'

      if IsDataGridDeleted ( idx , ri )
         return .f.
      endif

      cRecordSource   := ControlByIndex( IDX ):CTRL040 [ 10 ]

      if &cRecordSource->(RddName()) == 'PGRDD'
         MsgHMGError("GRID: Modify PostGre RDD tables is not allowed. Program terminated" )
      endif

      if &cRecordSource->(RddName()) == 'SQLMIX'
         MsgHMGError("GRID: Modify SQLMIX RDD tables is not allowed. Program terminated" )
      endif

   endif

   GFN := ControlByIndex( IDX ):CTRL027   // FontName
   GFS := ControlByIndex( IDX ):CTRL028   // FontSize


//Problem3031

   IF ControlByIndex( IDX ):CTRL040 [ 9 ] == .F.

      aTemp := this.item(ri)

      v := aTemp [ci]

   ELSE

      oHmgApp():APP201 := ri   // QueryRowIndex

      oHmgApp():APP202 := ci   // QueryColIndex

      oHmgApp():APP320 := .T.

      IF ValType ( ControlByIndex( IDX ):CTRL040 [ 10 ] ) == 'C'

         GetDataGridCellData ( idx , .t. )

      ELSE

         Eval( ControlByIndex( IDX ):CTRL006  )

      ENDIF


      oHmgApp():APP320 := .F.


      v := oHmgApp():APP230      // QueryData

   ENDIF

   CWH :=    ControlByIndex( IDX ):CTRL040 [6]   // ColumnWhen

//Problem3031

   IF ValType ( CWH ) = 'A'

      IF HMG_LEN ( CWH ) >= CI

         IF ValType ( CWH [CI] ) = 'B'

            oHmgApp():APP318 := V

            oHmgApp():ThisEventType := 'GRID_WHEN'

            WHEN := EVAL ( CWH [CI] )

            oHmgApp():ThisEventType := ''

            IF WHEN = .F.
               oHmgApp():APP256 := .F.
               RETURN .f.
            ENDIF

         ENDIF

      ENDIF

   ENDIF

   h := ControlByIndex( IDX ):Handle   // ControlHandle

//   This.CellRow    --> oHmgApp():ThisItemRow
//   This.CellCol    --> oHmgApp():ThisItemCol
//   This.CellWidth  --> oHmgApp():ThisItemCellWidth
//   This.CellHeight --> oHmgApp():ThisItemCellHeight

   r := This.CellRow + GetWindowRow ( h ) - this.row - 1

   if ControlByIndex( IDX ):CTRL023 <> -1
      r := r - ControlByIndex( IDX ):CTRL023
   endif

   c := This.CellCol + GetWindowCol ( h ) - this.col + 2

   if ControlByIndex( IDX ):CTRL024 <> -1
      c := c - ControlByIndex( IDX ):CTRL024
   endif


   AEDITCONTROLS := ControlByIndex( IDX ):LCTRL040 [ 2 ]

   CVA :=    ControlByIndex( IDX ):CTRL040 [ 5 ]

   XRES := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , CI )

   AEC      := XRES [1]
   CTYPE      := HMG_UPPER( XRES [2] )
   CINPUTMASK   := XRES [3]
   CFORMAT      := XRES [4]
   AITEMS      := XRES [5]
   ARANGE      := XRES [6]
   DTYPE      := XRES [7]
   ALABELS      := XRES [8]
   ARETURNVALUES   := XRES [9]

   IF AEC = 'COMBOBOX'
      DH := 1
   ELSEIF AEC = 'CHECKBOX'
      DR := 3
      DH := -7
   ELSEIF AEC = 'EDITBOX'
      oHmgApp():APP321 := .T.
   ENDIF

   oHmgApp():APP109 := GetActiveWindow()


   // Grid Valid Event Procedure Values

   oHmgApp():APP209 := idx

   *

   oHmgApp():APP245 := .F.

   IF AEC = 'EDITBOX'

      DEFINE WINDOW _HMG_GRID_InplaceEdit AT 0 , 0 ;
         WIDTH   350    ;
         HEIGHT   350 + IF ( IsAppThemed() , 3 , 0 ) ;
         TITLE ControlByIndex( IDX ):CTRL007 [ ci ] ;
         MODAL ;
         NOSIZE ;
         SHORTTITLEBAR

   else

      DEFINE WINDOW _HMG_GRID_InplaceEdit AT r + DR , c + DC ;
         WIDTH This.CellWidth +  DW ;
         HEIGHT This.CellHeight + 6 + DH ;
         TITLE '' ;
         MODAL NOSIZE NOCAPTION

   endif

   ON KEY ESCAPE ACTION ( oHmgApp():APP256 := .T., oHmgApp():APP340 := 1, THISWINDOW.RELEASE )   // ADD June 2016


oHmgApp():GridInplaceEdit_ControlHandle := 0   //ADD

   IF AEC = 'EDITBOX'

      ON KEY CONTROL+W ACTION IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                         ( oHmgApp():APP256 := .F. ,;
                           _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ),;  // ADD V parameter, by Pablo on February, 2015
                                   NIL )


      define button OK
         row   298
         col   278 - IF ( IsAppThemed() , 1 , 0 )
         width   28
         height   28
         action   IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                     ( oHmgApp():APP256 := .F. , _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ),;  // ADD V parameter, by Pablo on February, 2015
                       NIL )
         picture   'GRID_MSAV'
         tooltip oHmgApp():APP133 [ 12 ] + ' [Ctrl+W]'
      end button

      define button CANCEL
         row   298
         col   312 - IF ( IsAppThemed() , 1 , 0 )
         width   28
         height   28
         action   ( oHmgApp():APP256 := .T. , THISWINDOW.RELEASE )
         picture   'GRID_MCAN'
         tooltip oHmgApp():APP133 [ 13 ] + ' [Esc]'
      end button


   ELSE

      ON KEY RETURN ACTION IIF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                               ( oHmgApp():APP256 := .F. , _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ) ,;  // ADD V parameter, by Pablo on February, 2015
                                 NIL )

      ON KEY TAB    ACTION ( oHmgApp():APP285 := .T. , InsertReturn() )

   ENDIF


   ON KEY F2 ACTION IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                       ( oHmgApp():APP256 := .F. , _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ) ,;  // ADD V parameter, by Pablo on February, 2015
                         NIL )


   IF AEC == 'TEXTBOX' //*****************************************

      IF oHmgApp():APP321 == .F.

         DEFINE TEXTBOX T

      ELSE

         DEFINE EDITBOX T
               HSCROLLBAR      .F.
               VSCROLLBAR      .F.

      ENDIF

      FONTNAME   GFN
      FONTSIZE   GFS

      ROW   0
      COL   0
      WIDTH    This.CellWidth      + nWx
      HEIGHT   This.CellHeight + 6   + nHx

      IF CTYPE == 'NUMERIC'
         NUMERIC .T.
     ELSEIF CTYPE == 'PASSWORD'  // By Pablo on February, 2015
         PASSWORD .T.
      ELSEIF CTYPE == 'DATE'
         DATE .T.
      ENDIF

      VALUE   v

      IF ! EMPTY ( CINPUTMASK )
         INPUTMASK CINPUTMASK
      ENDIF

      IF ! EMPTY ( CFORMAT )
         FORMAT CFORMAT
      ENDIF

      IF oHmgApp():APP321 == .F.
         END TEXTBOX
      ELSE
         END EDITBOX
      ENDIF

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("t","_HMG_GRID_InplaceEdit")   //ADD

   ELSEIF AEC == 'EDITBOX' //**********************************************

     If ":" $ V .and. File(V)                        // By Pablo on February, 2015
          cTextFile:=hb_MemoRead(V)
      ElseIf "\" $ V .and. File(GetCurrentFolder()+V)
         cTextFile:=hb_MemoRead(GetCurrentFolder()+V)
     ElseIf HMG_LOWER(V)=="<memo>" .or. IsDataGridMemo ( Idx, ci )
        cTextFile:=GetDataGridCellData ( idx , .t. )
      Else
         cTextFile:=V
      Endif

      DEFINE EDITBOX T
         HSCROLLBAR .T.
         VSCROLLBAR .T.
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW        2
         COL        2
         WIDTH      340
         HEIGHT     292
         VALUE      cTextFile  // By Pablo on February, 2015
      END EDITBOX

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("t","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'DATEPICKER' //*******************************************

      DEFINE DATEPICKER D
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW      0
         COL      0
         WIDTH      This.CellWidth
         HEIGHT      This.CellHeight + 6
         VALUE      V
         SHOWNONE   .T.

         IF DTYPE = 'DROPDOWN'
            UPDOWN .F.
         ELSEIF DTYPE = 'UPDOWN'
            UPDOWN .T.
         ENDIF

      END DATEPICKER

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("D","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'TIMEPICKER' //*******************************************   ( Dr. Claudio Soto, April 2013 )

      DEFINE TIMEPICKER TPICK
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW        0
         COL        0
         WIDTH      This.CellWidth
         HEIGHT     This.CellHeight + 6
         VALUE      V
         SHOWNONE   .F.
         FORMAT     CFORMAT
      END TIMEPICKER

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("tpick","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'COMBOBOX' //********************************************

      DEFINE COMBOBOX C
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW   0
         COL   0
         WIDTH    This.CellWidth
         ITEMS   AITEMS

         IF HMG_LEN ( ARETURNVALUES ) == 0
            VALUE   v
         ELSE

            For z := 1 To HMG_LEN ( aReturnValues )

               if v = aReturnValues [z]

                  xValue := z
                  exit

               endif

            Next z

            if xValue == 0
               xValue := 1
            endif

            VALUE xValue

         ENDIF

         ONDROPDOWN   _hmg_grid_disablekeys()
         ONCLOSEUP   _hmg_grid_enablekeys( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues )

      END COMBOBOX

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("C","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'SPINNER' //*********************************************

      DEFINE SPINNER S
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW        0
         COL        0
         WIDTH      This.CellWidth
         HEIGHT     This.CellHeight + 6
         VALUE      V
         RANGEMIN   ARANGE [1]
         RANGEMAX   ARANGE [2]
         INCREMENT  ARANGE [3]  // By Pablo on February, 2015
      END SPINNER

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("S","_HMG_GRID_InplaceEdit")


   ELSEIF AEC == 'CHECKBOX' //********************************************

      DEFINE CHECKBOX C
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW      0
         COL      0
         WIDTH       This.CellWidth + DW
         HEIGHT      This.CellHeight + 6 + DH
         VALUE      V

         IF V == .T.
            CAPTION ALABELS [1]
         ELSEIF V == .F.
            CAPTION ALABELS [2]
         ENDIF

         BACKCOLOR WHITE
         ONCHANGE IF ( THIS.VALUE == .T. , THIS.CAPTION := ALABELS [1] , THIS.CAPTION := ALABELS [2] )
      END CHECKBOX

oHmgApp():GridInplaceEdit_ControlHandle := GetControlHandle ("C","_HMG_GRID_InplaceEdit")   //ADD


   ENDIF

   END WINDOW

   IF ValType( oHmgApp():GridInplaceEdit_ControlHandle ) == "A"
      oHmgApp():GridInplaceEdit_ControlHandle := oHmgApp():GridInplaceEdit_ControlHandle [1]
   ENDIF

   oHmgApp():GridInplaceEdit_StageEvent := 1   // PreEvent
   _HMG_OnInplaceEditEvent( IDX )

   oHmgApp():GridInplaceEdit_StageEvent := 2   // Into Event
   cProc := "_HMG_OnInplaceEditEvent( " + hb_NtoS( IDX ) + " ) "
   nIndex := EventCreate( cProc, NIL, NIL )   // by Dr. Claudio Soto, April 2016

   IF AEC = 'EDITBOX'

      SETFOCUS ( GetControlHandle( 't' , '_HMG_GRID_InplaceEdit' ) )

      CENTER WINDOW _HMG_GRID_InplaceEdit

   ENDIF

   ACTIVATE WINDOW _HMG_GRID_InplaceEdit

// MsgDebug ("InplaceEdit END")

 IF nIndex > 0   // by Dr. Claudio Soto, April 2016
   EventRemove ( nIndex )
 ENDIF

oHmgApp():GridInplaceEdit_StageEvent := 3   // PostEvent
 _HMG_OnInplaceEditEvent( IDX )

oHmgApp():GridInplaceEdit_StageEvent    := 0   //ADD
oHmgApp():GridInplaceEdit_ControlHandle := 0   //ADD
oHmgApp():GridInplaceEdit_GridIndex     := 0   //ADD

   oHmgApp():APP109 := 0

   SETFOCUS ( ControlByIndex( IDX ):Handle )

   oHmgApp():APP321 := .F.

RETURN .t.


FUNCTION _HMG_OnInplaceEditEvent( nIndex )
LOCAL Ret := NIL
   IF oHmgApp():GridInplaceEdit_ControlHandle <> 0 .AND. ValType( ControlByIndex( NINDEX ):CTRL040 [ 47 ] ) == "B"
      Ret := EVAL( ControlByIndex( NINDEX ):CTRL040 [ 47 ] )
   ENDIF
RETURN Ret


procedure _hmg_grid_disablekeys

   RELEASE KEY RETURN OF _HMG_GRID_InplaceEdit
   RELEASE KEY ESCAPE OF _HMG_GRID_InplaceEdit

return


procedure _hmg_grid_enablekeys( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues )

   ON KEY RETURN OF _HMG_GRID_InplaceEdit ACTION IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                                                    ( oHmgApp():APP256 := .F. , _HMG_GRIDINPLACEEDITOK ( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues ) ),;
                                                      NIL )

   ON KEY ESCAPE OF _HMG_GRID_InplaceEdit ACTION ( oHmgApp():APP256 := .T. , _HMG_GRID_InplaceEdit.RELEASE )

return


*-----------------------------------------------------------------------------*
FUNCTION _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , CI )
*-----------------------------------------------------------------------------*
LOCAL AEC := 'TEXTBOX'
LOCAL AITEMS := {}
LOCAL ARANGE := {}
LOCAL DTYPE := 'D'
LOCAL ALABELS := { '.T.' ,'.F.' }
LOCAL CTYPE := 'CHARACTER'
LOCAL CINPUTMASK := ''
LOCAL CFORMAT := ''
LOCAL ARET := {}
LOCAL DW , DH , DR , DC
LOCAL ARETURNVALUES := {}

   IF ValType ( AEDITCONTROLS ) = 'A'

      IF HMG_LEN ( AEDITCONTROLS ) >= ci

         IF ValType ( AEDITCONTROLS [CI] ) = 'A'

            IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 1

               AEC := AEDITCONTROLS [CI] [1]



               IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
                  .AND. ;
                  AEC == 'TEXTBOX'

                  IF ValType ( AEDITCONTROLS [CI] [2] ) = 'C'
                     CTYPE := HMG_UPPER( AEDITCONTROLS [CI] [2] )
                  ENDIF

                  IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 3
                     IF ValType ( AEDITCONTROLS [CI] [3] ) = 'C'
                        CINPUTMASK := AEDITCONTROLS [CI] [3]
                     ENDIF
                  ENDIF

                  IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 4
                     IF ValType ( AEDITCONTROLS [CI] [4] ) = 'C'
                        CFORMAT := AEDITCONTROLS [CI] [4]
                     ENDIF
                  ENDIF

               ENDIF

               IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
                  .AND. ;
                  AEC == 'COMBOBOX'

                  IF ValType ( AEDITCONTROLS [CI] [2] ) = 'A'
                     AITEMS := AEDITCONTROLS [CI] [2]
                  ENDIF

                  IF HMG_LEN ( AEDITCONTROLS [CI] ) == 3
                     IF ValType ( AEDITCONTROLS [CI] [3] ) = 'A'
                        ARETURNVALUES := AEDITCONTROLS [CI] [3]
                     ENDIF
                  ENDIF

               ENDIF

               IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 3 .AND. AEC == 'SPINNER'

                  IF ValType ( AEDITCONTROLS [CI] [2] ) = 'N' .AND. ValType ( AEDITCONTROLS [CI] [3] ) = 'N'
                     ARANGE := { AEDITCONTROLS [CI] [2] , AEDITCONTROLS [CI] [3] , 1 }
                  ENDIF
                  IF HMG_LEN (AEDITCONTROLS [CI]) == 4 .AND. ValType ( AEDITCONTROLS [CI] [4] ) = 'N'
                     ARANGE [3] := AEDITCONTROLS [CI] [4]
                  ENDIF

               ENDIF

               IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
                  .AND. ;
                  AEC == 'DATEPICKER'
                  IF    ValType ( AEDITCONTROLS [CI] [2] ) = 'C'
                     DTYPE := AEDITCONTROLS [CI] [2]
                  ENDIF
               ENDIF

               IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
                  .AND. ;
                  AEC == 'TIMEPICKER'
                  IF ValType ( AEDITCONTROLS [CI] [2] ) = 'C'
                     CFORMAT := AEDITCONTROLS [CI] [2]
                  ENDIF
               ENDIF


               IF HMG_LEN ( AEDITCONTROLS [CI] ) == 3   .AND.   AEC == 'CHECKBOX'
                  DW := -4
                  DH := -7
                  DR := 3
                  DC := 2
                  IF ValType ( AEDITCONTROLS [CI] [2] ) = 'C'   .AND.   ValType ( AEDITCONTROLS [CI] [3] ) = 'C'
                     ALABELS := { AEDITCONTROLS [CI] [2] , AEDITCONTROLS [CI] [3] }
                  ENDIF
               ENDIF

            ENDIF

         ENDIF

      ENDIF

   ENDIF

   ARET := { AEC , CTYPE , CINPUTMASK , CFORMAT , AITEMS , ARANGE , DTYPE , ALABELS , ARETURNVALUES }

RETURN ( ARET )

*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, cValCell ) // ADD cValCell parameter, by Pablo on February, 2015
*-----------------------------------------------------------------------------*
LOCAL VALID, aTemp
LOCAL Z
Local cTextFile:="" /* By Pablo on February, 2015 */

ALABELS    := NIL   // ADD
CTYPE      := NIL   // ADD
CINPUTMASK := NIL   // ADD
CFORMAT    := NIL   // ADD


   HMG_GetLastCharacterEx()   // Clean key char buffer

   IF ValType ( CVA ) = 'A'

      IF HMG_LEN ( CVA ) >= CI

         IF ValType ( CVA [CI] ) = 'B'

            IF   AEC == 'TEXTBOX' .or. AEC == 'EDITBOX'
               oHmgApp():APP318 := GetProperty ( "_HMG_GRID_InplaceEdit","t","value")
            ELSEIF   AEC == 'DATEPICKER'
               oHmgApp():APP318 := _HMG_GRID_InplaceEdit.d.value

            ELSEIF   AEC == 'TIMEPICKER'
               oHmgApp():APP318 := _HMG_GRID_InplaceEdit.tpick.value

            ELSEIF   AEC == 'COMBOBOX'

               IF HMG_LEN ( ARETURNVALUES ) == 0

                  oHmgApp():APP318 := _HMG_GRID_InplaceEdit.c.value

               ELSE

                  oHmgApp():APP318 := aReturnValues [_HMG_GRID_InplaceEdit.c.value ]

               ENDIF

            ELSEIF   AEC == 'SPINNER'
               oHmgApp():APP318 := _HMG_GRID_InplaceEdit.s.value
            ELSEIF   AEC == 'CHECKBOX'
               oHmgApp():APP318 := _HMG_GRID_InplaceEdit.c.value
            ENDIF

            oHmgApp():ThisEventType := 'GRID_VALID'

            _DoControlEventProcedure ( CVA [CI] , oHmgApp():APP209 )

            VALID := oHmgApp():APP293

            oHmgApp():ThisEventType := ''

            IF VALID = .F.

               MSGEXCLAMATION ( oHmgApp():APP136[11] )
               RETURN

            ENDIF

            redrawwindow( ControlByIndex( IDX ):Handle )

         ENDIF

      ENDIF

   ENDIF

   IF ControlByIndex( IDX ):CTRL040 [ 9 ] == .F.

      aTemp := _GetItem (  ,  , ri , idx )

   ELSE

      aTemp := array ( HMG_LEN( ControlByIndex( IDX ):CTRL007 ) )

      aTemp := aFill ( aTemp , '' )

      FOR Z := 1 TO HMG_LEN ( ControlByIndex( IDX ):CTRL007 )

         oHmgApp():APP201 := ri   // QueryRowIndex

         oHmgApp():APP202 := z   // QueryColIndex

         IF ValType ( ControlByIndex( IDX ):CTRL040 [ 10 ] ) == 'C'

            GetDataGridCellData ( idx , .t. )

         ELSE

            Eval( ControlByIndex( IDX ):CTRL006  )

         ENDIF

         aTemp [z] := oHmgApp():APP230   // QueryData

      NEXT Z

   ENDIF

   IF   AEC == 'TEXTBOX' .OR. AEC = 'EDITBOX'
      aTemp [ci] := GetProperty ( "_HMG_GRID_InplaceEdit","t","value")
   ELSEIF   AEC == 'DATEPICKER'
      aTemp [ci] := _HMG_GRID_InplaceEdit.d.value

   ELSEIF   AEC == 'TIMEPICKER'
      aTemp [ci] := _HMG_GRID_InplaceEdit.tpick.value

   ELSEIF   AEC == 'COMBOBOX'

      IF HMG_LEN ( ARETURNVALUES ) == 0

         aTemp [ci] := _HMG_GRID_InplaceEdit.c.value

      ELSE

         aTemp [ci] := aReturnValues [_HMG_GRID_InplaceEdit.c.value ]

      ENDIF

   ELSEIF   AEC == 'SPINNER'
      aTemp [ci] := _HMG_GRID_InplaceEdit.s.value
   ELSEIF   AEC == 'CHECKBOX'
      aTemp [ci] := _HMG_GRID_InplaceEdit.c.value
   ENDIF

   IF ControlByIndex( IDX ):CTRL040 [ 9 ] == .F.

      If AEC == 'EDITBOX'  // By Pablo on February, 2015
         If ":" $ cValCell .and. File(cValCell)
            cTextFile:=cValCell
         ElseIf "\" $ cValCell .and. File(GetCurrentFolder()+cValCell)
            cTextFile:=GetCurrentFolder()+cValCell
         ElseIf HMG_LOWER(cValCell)=="<memo>" .or. IsDataGridMemo ( Idx, ci )
            cTextFile:=GetDataGridCellData ( idx , .t. )
         Else
            cTextFile:=""
         Endif
      Endif
      If Empty(cTextFile)
         _SetItem ( , , ri , aTemp , idx )
      Else
          hb_MemoWrit(cTextFile,aTemp[ci])   // By Pablo on February, 2015
       Endif

   ENDIF

   IF ValType ( ControlByIndex( IDX ):CTRL040 [ 10 ] ) == 'C'

      oHmgApp():ThisItemColIndex := ci

      SaveDataGridField ( idx , aTemp [ci] )

   endif

   _HMG_GRID_InplaceEdit.RELEASE

RETURN



*-----------------------------------------------------------------------------*
Procedure _HMG_SetGridCellEditValue ( arg )
*-----------------------------------------------------------------------------*

   IF   ValType ( arg ) == 'C'

      If _IsControlDefined ( 't' , "_HMG_GRID_InplaceEdit")

         SetProperty ( "_HMG_GRID_InplaceEdit" , "t" , "value" , arg )

      EndIf

   ELSEIF   ValType ( arg ) == 'D'

      If _IsControlDefined ( 't' , "_HMG_GRID_InplaceEdit")

         SetProperty ( "_HMG_GRID_InplaceEdit" , "t" , "value" , arg )

      ElseIf _IsControlDefined ( 'd' , "_HMG_GRID_InplaceEdit")

         SetProperty ( "_HMG_GRID_InplaceEdit" , "d" , "value" , arg )

      EndIf

   ELSEIF   ValType ( arg ) == 'N'

      If _IsControlDefined ( 'c' , "_HMG_GRID_InplaceEdit")

         SetProperty ( "_HMG_GRID_InplaceEdit" , "c" , "value" , arg )

      ElseIf _IsControlDefined ( 's' , "_HMG_GRID_InplaceEdit")

         SetProperty ( "_HMG_GRID_InplaceEdit" , "s" , "value" , arg )

      ElseIf _IsControlDefined ( 't' , "_HMG_GRID_InplaceEdit")

         SetProperty ( "_HMG_GRID_InplaceEdit" , "t" , "value" , arg )

      EndIf

   ELSEIF   ValType ( arg ) == 'L'

      SetProperty ( "_HMG_GRID_InplaceEdit" , "c" , "value" , arg )

   ENDIF

return


FUNCTION GetControlSafeRow ( nIndex )

   RETURN hb_DefaultValue( ControlByIndex( nIndex ):CTRL018, 0 )   // for SplitBox

FUNCTION GetControlSafeCol ( nIndex )

   RETURN hb_DefaultValue( ControlByIndex( nIndex ):CTRL019, 0 )   // for SplitBox


*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRIDINPLACEKBDEDIT(i)
*-----------------------------------------------------------------------------*
LOCAL TmpRow, xTmp
LOCAL XS
LOCAL XD
LOCAL R
LOCAL IPE_MAXCOL


   IPE_MAXCOL := HMG_LEN ( ControlByIndex( I ):CTRL033 )

   Do While .T.

      TmpRow := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle )

      If TmpRow != oHmgApp():APP341

         oHmgApp():APP341 := TmpRow

         if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0
            oHmgApp():APP340 := 2
         Else
            oHmgApp():APP340 := 1
         EndIf

      EndIf

      oHmgApp():ThisItemRowIndex := oHmgApp():APP341
      oHmgApp():ThisItemColIndex := oHmgApp():APP340

      If oHmgApp():APP340 == 1
         r := LISTVIEW_GETITEMRECT ( ControlByIndex( i ):Handle  , oHmgApp():APP341 - 1 )
      Else
         r := LISTVIEW_GETSUBITEMRECT ( ControlByIndex( i ):Handle  , oHmgApp():APP341 - 1 , oHmgApp():APP340 - 1 )
      EndIf

      xs :=   ( ( GetControlSafeCol(i) + r [2] ) +( r[3] ))  -  ( GetControlSafeCol(i) + ControlByIndex( I ):CTRL020 )

      xd := 20

      If xs > -xd
         ListView_Scroll( ControlByIndex( i ):Handle ,   xs + xd , 0 )
      Else

        If r [2] < 0
           ListView_Scroll( ControlByIndex( i ):Handle , r[2]   , 0 )
        EndIf

      endIf

      If oHmgApp():APP340 == 1
         r := LISTVIEW_GETITEMRECT ( ControlByIndex( i ):Handle  , oHmgApp():APP341 - 1 )
      Else
         r := LISTVIEW_GETSUBITEMRECT ( ControlByIndex( i ):Handle  , oHmgApp():APP341 - 1 , oHmgApp():APP340 - 1 )
      EndIf

      oHmgApp():ThisItemRow := GetControlSafeRow(i) + r [1]
      oHmgApp():ThisItemCol := GetControlSafeCol(i) + r [2]
      oHmgApp():ThisItemCellWidth := r[3]
      oHmgApp():ThisItemCellHeight := r[4]

      *
      xTmp := ControlByIndex( I ):ParentFormHandle
      xTmp := FormByHandle( xTmp ):Index
      oHmgApp():ThisFormIndex := xTmp
      oHmgApp():ThisType := 'C'
      oHmgApp():ThisControlIndex := i
      oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name
      oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name
      *

      _HMG_GRIDINPLACEEDIT(I)

      oHmgApp():ThisControlIndex := 0
      oHmgApp():ThisType := ''

      oHmgApp():ThisItemRowIndex := 0
      oHmgApp():ThisItemColIndex := 0
      oHmgApp():ThisItemRow := 0
      oHmgApp():ThisItemCol := 0
      oHmgApp():ThisItemCellWidth := 0
      oHmgApp():ThisItemCellHeight := 0

      *
      oHmgApp():ThisFormIndex := 0
      oHmgApp():ThisEventType := ''
      oHmgApp():ThisFormName :=  ''
      oHmgApp():ThisControlName := ''
      *

      If oHmgApp():APP256 == .T.

         If oHmgApp():APP340 == IPE_MAXCOL

            if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0
               oHmgApp():APP340 := 2
            Else
               oHmgApp():APP340 := 1
            EndIf

            ListView_Scroll( ControlByIndex( i ):Handle ,   -10000  , 0 )
         EndIf

         Exit

      Else

         oHmgApp():APP340++

         If oHmgApp():APP340 > IPE_MAXCOL

            if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0
               oHmgApp():APP340 := 2
            Else
               oHmgApp():APP340 := 1
            EndIf

            ListView_Scroll( ControlByIndex( i ):Handle ,   -10000  , 0 )
            Exit
         EndIf

      EndIf

   EndDo

RETURN


*------------------------------------------------------------------------------*
Function GetNumFromCellText ( Text )
*------------------------------------------------------------------------------*
Local x , c , s

   s := ''

   For x := 1 To HMG_LEN ( Text )

      c := HB_USUBSTR(Text,x,1)

      If c='0' .or. c='1' .or. c='2' .or. c='3' .or. c='4' .or. c='5' .or. c='6' .or. c='7' .or. c='8' .or. c='9' .or. c='.' .or. c='-'
         s := s + c
      EndIf

   Next x

   If HB_ULEFT ( ALLTRIM(Text) , 1 ) == '(' .OR.  HB_URIGHT ( ALLTRIM(Text) , 2 ) == 'DB'
      s := '-' + s
   EndIf

Return Val(s)


*------------------------------------------------------------------------------*
Function GETNumFromCellTextSP(Text)
*------------------------------------------------------------------------------*
Local x , c , s

   s := ''

   For x := 1 To HMG_LEN ( Text )

      c := HB_USUBSTR(Text,x,1)

      If c='0' .or. c='1' .or. c='2' .or. c='3' .or. c='4' .or. c='5' .or. c='6' .or. c='7' .or. c='8' .or. c='9' .or. c=',' .or. c='-' .or. c = '.'

         if c == '.'
            c :=''
         endif

         IF C == ','
            C:= '.'
         ENDIF

         s := s + c

      EndIf

   Next x

   If HB_ULEFT ( ALLTRIM(Text) , 1 ) == '(' .OR.  HB_URIGHT ( ALLTRIM(Text) , 2 ) == 'DB'
      s := '-' + s
   EndIf

Return Val(s)

/*
*------------------------------------------------------------------------------*
FUNCTION _HMG_GETGRIDCELLVALUE ( CONTROLNAME , PARENTFORM , ROW , COL )
*------------------------------------------------------------------------------*
LOCAL A
LOCAL V

   A := _GetItem ( CONTROLNAME , PARENTFORM , ROW  )

   V := A [ COL ]

RETURN V

*------------------------------------------------------------------------------*
PROCEDURE _HMG_SETGRIDCELLVALUE ( CONTROLNAME , PARENTFORM , ROW , COL , CELLVALUE )
*------------------------------------------------------------------------------*
LOCAL A

   A := _GetItem ( CONTROLNAME , PARENTFORM , ROW  )

   A [ COL ] := CELLVALUE

   _SetItem ( CONTROLNAME , PARENTFORM , ROW , A )

RETURN
*/



*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRIDINPLACEKBDEDIT_2(i)
*-----------------------------------------------------------------------------*
LOCAL R
LOCAL S
Local aColumnWhen := ControlByIndex( I ):CTRL040 [  6 ]
Local j, xTmp
Local nWhenRow
Local xTmpCellValue
Local aTemp
Local nStart, nEnd, lResult

//Problem3031

   _HMG_GRID_KBDSCROLL(I)

   If ControlByIndex( I ):CTRL015 == 1   // nCol cellnavigation
                                                        // nRow cellnavigation
      r := LISTVIEW_GETITEMRECT ( ControlByIndex( i ):Handle  , ControlByIndex( I ):CTRL039 - 1 )
   Else
                                                        //   nRow cellnavigation          nCol cellnavigation
      r := LISTVIEW_GETSUBITEMRECT ( ControlByIndex( i ):Handle  , ControlByIndex( I ):CTRL039- 1 , ControlByIndex( I ):CTRL015 - 1 )
   EndIf


// MsgDebug( oHmgApp():APP195 , ControlByIndex( I ):CTRL039, oHmgApp():APP341 )

IF oHmgApp():ThisItemRowIndex == 0 .AND. ControlByIndex( I ):CTRL039 > 0   // ADD, march 2017
   oHmgApp():ThisItemRowIndex := ControlByIndex( I ):CTRL039
ENDIF


   nWhenRow := oHmgApp():ThisItemRowIndex   // This.CellRowIndex

   oHmgApp():ThisItemRow := GetControlSafeRow(i) + r [1]   // This.CellRow
   oHmgApp():ThisItemCol := GetControlSafeCol(i) + r [2]   // This.CellCol
   oHmgApp():ThisItemCellWidth := r [3]                   // This.CellWidth
   oHmgApp():ThisItemCellHeight := r [4]                   // This.CellHeight


   *
   xTmp := FormByHandle( ControlByIndex( I ):ParentFormHandle )
   oHmgApp():ThisFormIndex := iif( xTmp == Nil, 0, xTmp:Index )
   oHmgApp():ThisType := 'C'
   oHmgApp():ThisControlIndex := i
   oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name
   oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name
   *

   S := _HMG_GRIDINPLACEEDIT(I)

   IF ControlByIndex( I ):CTRL032 .AND. oHmgApp():APP245 == .F.

      IF   ControlByIndex( I ):CTRL015 < HMG_LEN(ControlByIndex( I ):CTRL007)

         IF ControlByIndex( I ):CTRL040 [ 32 ] == 0

            IF S

               IF .NOT. oHmgApp():APP285
*!!!!
                  IF oHmgApp():APP284
                     IF .NOT. oHmgApp():APP256
                        InsertDown()
                        InsertReturn()
                     ENDIF
                  ELSE
                     ControlByIndex( I ):CTRL015++
                  ENDIF

               ELSE

                  ControlByIndex( I ):CTRL015++
                  oHmgApp():APP285 := .F.
                  InsertReturn()

               ENDIF


               If ValType ( aColumnWhen ) == 'A'

                  nStart := ControlByIndex( I ):CTRL015

                  nEnd := HMG_LEN ( aColumnWhen )

                  For j := nStart To nEnd

                     If ValType ( aColumnWhen [j] ) == 'B'

*******************************************************************************************************************************
                        IF ControlByIndex( I ):CTRL040 [ 9 ] == .F.
                           aTemp := this.item( nWhenRow )
                           xTmpCellValue := aTemp [j]
                        ELSE
                           oHmgApp():APP201 := nWhenRow // QueryRowIndex
                           oHmgApp():APP202 := j   // QueryColIndex
                           oHmgApp():APP320 := .T.
                           IF ValType ( ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C'
                              GetDataGridCellData ( i , .t. )
                           ELSE
                              Eval( ControlByIndex( I ):CTRL006  )
                           ENDIF
                           oHmgApp():APP320 := .F.
                           xTmpCellValue := oHmgApp():APP230
                        ENDIF
********************************************************************************************************************************

                        oHmgApp():APP318 := xTmpCellValue

                        oHmgApp():ThisEventType := 'GRID_WHEN'

                        lResult := Eval ( aColumnWhen [j] )

                        oHmgApp():ThisEventType := ''

                        If lResult == .F.

                           ControlByIndex( I ):CTRL015++

                        Else

                           Exit

                        EndIf

                     EndIf

                  Next j

                  IF .NOT. oHmgApp():APP284

                     IF ControlByIndex( I ):CTRL015 > nEnd

                        ControlByIndex( I ):CTRL015 := nStart - 1

                     ENDIF

                  ENDIF

               EndIf

            ENDIF

         ENDIF

      ELSEIF ControlByIndex( I ):CTRL015 == HMG_LEN(ControlByIndex( I ):CTRL007)

         IF ControlByIndex( I ):CTRL040 [ 32 ] == 0

            IF S

               IF .NOT. oHmgApp():APP285

                  IF .NOT. oHmgApp():APP284
                     ControlByIndex( I ):CTRL015 := 1
                  ELSE
                     IF .NOT. oHmgApp():APP256
                        InsertDown()
                        InsertReturn()
                     ENDIF
                  ENDIF

               ELSE

                  ControlByIndex( I ):CTRL015 := 1
                  oHmgApp():APP285 := .F.

               ENDIF

            ENDIF

         ENDIF

      ENDIF

      LISTVIEW_REDRAWITEMS( ControlByIndex( I ):Handle , ControlByIndex( I ):CTRL039-1 , ControlByIndex( I ):CTRL039-1 )
      _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

   ENDIF

   oHmgApp():ThisControlIndex := 0
   oHmgApp():ThisType := ''

   oHmgApp():ThisItemRowIndex := 0
   oHmgApp():ThisItemColIndex := 0
   oHmgApp():ThisItemRow := 0
   oHmgApp():ThisItemCol := 0
   oHmgApp():ThisItemCellWidth := 0
   oHmgApp():ThisItemCellHeight := 0

   *
   oHmgApp():ThisFormIndex := 0
   oHmgApp():ThisEventType := ''
   oHmgApp():ThisFormName :=  ''
   oHmgApp():ThisControlName := ''
   *

RETURN

*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRID_KBDSCROLL(I)
*-----------------------------------------------------------------------------*
LOCAL R ,XS , XD

   oHmgApp():ThisItemRowIndex := ControlByIndex( I ):CTRL039
   oHmgApp():ThisItemColIndex := ControlByIndex( I ):CTRL015

   If ControlByIndex( I ):CTRL015 == 1
      r := LISTVIEW_GETITEMRECT ( ControlByIndex( i ):Handle  , ControlByIndex( I ):CTRL039 - 1 )
   Else
      r := LISTVIEW_GETSUBITEMRECT ( ControlByIndex( i ):Handle  , ControlByIndex( I ):CTRL039 - 1 , ControlByIndex( I ):CTRL015 - 1 )
   EndIf

   xs := ( ( GetControlSafeCol(i) + r [2] ) +( r[3] ))  -  ( GetControlSafeCol(i) + ControlByIndex( I ):CTRL020 )
   xd := 20

   If xs > -xd
      ListView_Scroll( ControlByIndex( i ):Handle, xs + xd, 0 )
   Else
      If r [2] < 0
         ListView_Scroll( ControlByIndex( i ):Handle, r[2], 0 )
      EndIf
   endIf

RETURN



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   VIRTUAL GRID DATABASE FUNCTIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define _IS_DBFILTER_ON_      ( ! Empty( &cRecordSource->( DBFILTER() ) ) )
#define _IS_SETDELETED_ON_    ( Set ( _SET_DELETED ) )
#define _IS_ORDFOR_ON_        ( ! Empty( &cRecordSource->( ORDFOR() ) ) )

#define _IS_ACTIVE_FILTER_    ( _IS_DBFILTER_ON_ .OR. _IS_SETDELETED_ON_ .OR. _IS_ORDFOR_ON_ )


**************************************************
Function GridRecCount( index )
**************************************************
Local nCount := 0
Local nOldRecno
Local cRecordSource := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   IF _IS_ACTIVE_FILTER_
      nOldRecno := &cRecordSource->( RECNO() )
      &cRecordSource->( DBGOTOP() )
      &cRecordSource->( DBEVAL( {|| nCount++ } ) )   // Dbeval  --> not ignore set delete, preceess only not deleleted records
      &cRecordSource->( DBGOTO( nOldRecno ) )
   ELSE
      nCount := &cRecordSource->( ORDKEYCOUNT() )    // OrdKeyCount --> ignore set delete, proceess deleted and non deleted records
   ENDIF
Return nCount


***********************************************
Function GetGridFieldName ( index , nField )
***********************************************
Local cRecordSource   := ControlByIndex( INDEX ):CTRL040 [ 10 ]
Local aColumnFields   := ControlByIndex( INDEX ):CTRL040 [ 11 ]
Local aColumnClassMap := ControlByIndex( INDEX ):CTRL040 [ 30 ]
Local cFieldName
   IF aColumnClassMap [ nField ] == 'F'
      cFieldName := cRecordSource + '->' + aColumnFields[ nField ]   //  Field in this Area
   ELSE
      cFieldName := aColumnFields[ nField ]   // Field in other Area
   ENDIF
Return cFieldName


*********************************************
Function IsDataGridMemo ( index , nField )
*********************************************
Local cFieldName := GetGridFieldName ( index , nField )
   IF TYPE ( cFieldName ) == 'M'
      Return .T.
   ENDIF
Return .F.


*************************************************
Function IsDataGridDeleted ( index , nRecno )
*************************************************
Local lRet := .F.
Local cRecordSource := ControlByIndex( INDEX ):CTRL040 [ 10 ]
Local nOldRecno := &cRecordSource->( RECNO() )
   &cRecordSource->( ORDKEYGOTO( nRecno ) )
   if &cRecordSource->( DELETED() )
      lRet := .T.
   endif
   &cRecordSource->( DBGOTO( nOldRecno ) )
Return lRet


************************************************
function SetDataGridRecNo ( index , nRecNo  )
************************************************
Local cRecordSource
Local aValue
Local nLogicalPos := 0
Local lOk := .f.
Local nBackRecNo
LOCAL nColumn := 0

   cRecordSource  := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   nBackRecNo     := &cRecordSource->( RECNO() )
   aValue         := _GetValue (  ,  ,  index )
   if ValType (aValue) == 'A'
      nColumn := aValue[2]
   endif

   if _IS_ACTIVE_FILTER_
      lOk := .f.
      nLogicalPos := 1
      &cRecordSource->( DBGOTOP() )

      Do While .Not. EOF()
         If &cRecordSource->( RECNO() ) == nRecNo
            lOk := .t.
//            nNewRecNo   := &cRecordSource->( RECNO() )   // ADD, march 2017
            Exit
         EndIf
         &cRecordSource->( DBSKIP() )
         nLogicalPos++
      EndDo
   else
      lOk := .t.
      &cRecordSource->( DBGOTO ( nRecNo ) )
      nLogicalPos := &cRecordSource->( ORDKEYNO () )
//      nNewRecNo   := &cRecordSource->( RECNO() )   // ADD, march 2017
   endif

   If lOk
//      &cRecordSource->( DBGOTO( nNewRecNo ) )   // ADD, march 2017
   else
      &cRecordSource->( DBGOTO( nBackRecNo ) )
   endif

   If lOk
      _SetValue (  ,  ,  if (ValType (aValue) == 'A', { nLogicalPos , nColumn } , nLogicalPos) , index )
   EndIf

return nil


*************************************
function GetDataGridRecno( index )
*************************************
Local cRecordSource := ''
Local nHandle
Local aColumnFields := {}
Local lRet := .T.
Local aValue
Local nValue
Local nRecNo
Local nBackRecNo

Local aTemp
Local nBuffLogicalRow
Local nBuffPhysicalRow
Local k

   nHandle        := ControlByIndex( INDEX ):Handle
   aColumnFields  := ControlByIndex( INDEX ):CTRL040 [ 11 ]
   cRecordSource  := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   nBackRecNo     := &cRecordSource->( RECNO() )
   aValue         := _GetValue (  ,  ,  index )
   nValue         := if ( ValType (aValue) == 'A', aValue[1], aValue )

   if _IS_ACTIVE_FILTER_
      &cRecordSource->( DBGOTOP() )
      &cRecordSource->( DBSKIP( nValue - 1 ) )
   else
      &cRecordSource->( ORDKEYGOTO ( nValue ) )
   endif

   If &cRecordSource->(EOF())
      nRecNo := 0
      // Try to get the buffer record number (if available)
      aTemp := ControlByIndex( INDEX ):CTRL040 [21]
      For k := 1 To HMG_LEN ( aTemp )
         // Get Buffer Data
         nBuffLogicalRow  := aTemp [ k ] [ 1 ]
         nBuffPhysicalRow := aTemp [ k ] [ 4 ]
         If nBuffLogicalRow == ControlByIndex( INDEX ):CTRL039
            nRecNo := nBuffPhysicalRow
            Exit
         EndIf
      Next
   Else
      nRecNo := &cRecordSource->( RECNO() )
   EndIf

   &cRecordSource->( DBGOTO( nBackRecNo ) )

return nRecNo


*************************************
Function DataGridDelete ( index )
*************************************
Local cOperation
Local nLogicalRow
Local nPhysicalRow
Local x

   // Set Operation Type
   cOperation := 'D'

   // Get Logical Row
   nLogicalRow := ControlByIndex( INDEX ):CTRL039

   // Get Physical Row
   nPhysicalRow := GetDataGridRecNo(index)

   // Process Double-Deleted/Recalled
   For x := 1 To ControlByIndex( INDEX ):CTRL040 [ 24 ]
      If ControlByIndex( INDEX ):CTRL040 [ 25 ] [ x ] [ 1 ] == nLogicalRow
         ControlByIndex( INDEX ):CTRL040 [ 25 ] [ x ] [ 3 ] := 'D'
         Return .T.
      EndIf
   Next

   // Not Double Deleted/Recalled *********************************************

   // Append Record To Deleted / Recalled Buffer
   aadd ( ControlByIndex( INDEX ):CTRL040 [ 25 ] , { nLogicalRow , nPhysicalRow , cOperation } )

   // Update Deleted / Recalled Buffer Count
   ControlByIndex( INDEX ):CTRL040 [ 24 ]++

   // Set Pending Updates Flag
   ControlByIndex( INDEX ):CTRL040 [ 20 ] := .T.

Return .T.


*************************************
Function DataGridRecall ( index )
*************************************
Local cOperation
Local nLogicalRow
Local nPhysicalRow
Local x

   // Set Operation Type
   cOperation := 'R'

   // Get Logical Row
   nLogicalRow := ControlByIndex( INDEX ):CTRL039

   // Get Physical Row
   nPhysicalRow := GetDataGridRecNo(index)

   // Process Double-Deleted/Recalled
   For x := 1 To ControlByIndex( INDEX ):CTRL040 [ 24 ]
      If ControlByIndex( INDEX ):CTRL040 [ 25 ] [ x ] [ 1 ] == nLogicalRow
         ControlByIndex( INDEX ):CTRL040 [ 25 ] [ x ] [ 3 ] := 'R'
         Return .T.
      EndIf
   Next


   // Not Double Deleted/Recalled *******************************************

   // Append Record To Deleted / Recalled Buffer
   aadd ( ControlByIndex( INDEX ):CTRL040 [ 25 ] , { nLogicalRow , nPhysicalRow , cOperation } )

   // Update Deleted / Recalled Buffer Count
   ControlByIndex( INDEX ):CTRL040 [ 24 ]++

   // Set Pending Updates Flag
   ControlByIndex( INDEX ):CTRL040 [ 20 ] := .T.

Return .T.


/*
****************************************
Function IsDataGridFiltered ( index )
****************************************
Local cRecordSource, lRet, nRecNo
   cRecordSource := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   if _IS_ACTIVE_FILTER_
      lRet := .t.
   else
      lRet := .f.
   endif
Return lRet
*/


***********************************************
Function SaveDataGridField ( index , Value )
***********************************************
Local nLogicalRow
Local nLogicalCol
Local lReEdit := .F.
Local aTemp := {}
Local nBufferRow
Local x, nRecNo

   // Get Logical Position
   nLogicalRow := ControlByIndex( INDEX ):CTRL039
   nLogicalCol := ControlByIndex( INDEX ):CTRL015

   // Get Selected Row Record Number
   nRecNo := GetDataGridRecNo(index)

   // New Buffered Record Without a True RecNo
   If nRecNo == 0
      nRecNo := ControlByIndex( INDEX ):CTRL040 [ 23 ] - nLogicalRow
   EndIf

   // Is re-edit of the same cell ?
   If ControlByIndex( INDEX ):CTRL040 [ 20 ] == .T.
      aTemp := ControlByIndex( INDEX ):CTRL040 [21]
      For x := 1 To HMG_LEN ( aTemp )
         If aTemp [ x ] [ 1 ] == nLogicalRow
            If aTemp [ x ] [ 2 ] == nLogicalCol
               lReEdit := .T.
               nBufferRow := x
               Exit
            EndIf
         EndIf
      Next
   EndIf

   // Add Data to Pending Updates Buffer
   If lReEdit
      ControlByIndex( INDEX ):CTRL040 [21] [ nBufferRow ] := { nLogicalRow , nLogicalCol , Value , nRecNo }
   Else
      aadd ( ControlByIndex( INDEX ):CTRL040 [21] , { nLogicalRow , nLogicalCol , Value , nRecNo } )
   EndIf

   // Set Pending Updates Flag
   ControlByIndex( INDEX ):CTRL040 [ 20 ] := .T.

Return .T.


***********************************
Function DataGridAppend( index )
***********************************
Local cRecordSource := ''
Local nItemCount
Local nHandle
Local aColumnFields := {}
Local lRet := .T.
Local j

   // Get Control Data
   nHandle        := ControlByIndex( INDEX ):Handle
   aColumnFields  := ControlByIndex( INDEX ):CTRL040 [ 11 ]
   cRecordSource  := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   nItemCount     := ListView_GetItemCount ( nHandle )

   // Append a Row To The Grid
   ListView_SetItemCount ( nHandle , 0 )
   ListView_SetItemCount ( nHandle , nItemCount + 1 )

   &cRecordSource->( DBGOTOP() )
   &cRecordSource->( DBGOBOTTOM() )

   nItemCount := ListView_GetItemCount ( nHandle )
   _SetValue ( , , { nItemCount , 1 } , index )

   // Update New Record Buffer Count (Negative)
   ControlByIndex( INDEX ):CTRL040 [ 22 ]--

   // Set Default Values For The New Record
   for j := 1 to HMG_LEN ( ControlByIndex( INDEX ):CTRL040 [ 13 ] )
      if type ( aColumnFields [j] ) == 'C'
         ControlByIndex( INDEX ):CTRL040 [ 13 ] [j] := ''
      elseif type ( aColumnFields [j] ) == 'N'
         ControlByIndex( INDEX ):CTRL040 [ 13 ] [j] := 0
      elseif   type ( aColumnFields [j] ) == 'D'
         ControlByIndex( INDEX ):CTRL040 [ 13 ] [j] := ctod('  /  /  ')
      elseif   type ( aColumnFields [j] ) == 'L'
         ControlByIndex( INDEX ):CTRL040 [ 13 ] [j] := .F.
      elseif   type ( aColumnFields [j] ) == 'M'
         ControlByIndex( INDEX ):CTRL040 [ 13 ] [j] := '<Memo>'
      endif
      aadd ( ControlByIndex( INDEX ):CTRL040 [21] , { nItemCount , j , ControlByIndex( INDEX ):CTRL040 [ 13 ] [j] , ControlByIndex( INDEX ):CTRL040 [ 22 ] } )
   next

   // Set Pending Updates Flag
   ControlByIndex( INDEX ):CTRL040 [ 20 ] := .T.

Return lRet


******************************
Function DataGridSave(index)
******************************
Local x
Local z
Local n
Local l
Local j
Local k
Local aTemp
Local g
Local h
Local aAppendBuffer
Local aEditBuffer
Local aMarkBuffer
Local nColumnCount
Local nAppendRecordCount
Local aRecord
Local aColumnClassMap
Local cRecordSource, aColumnFields, nHandle, nItemCount, nRecNo, nLogicalRow, nLogicalCol, xValue, nPhysicalRow, cCommand

   // If Not Buffered Data Then Return ************************************
   If ControlByIndex( INDEX ):CTRL040 [ 20 ] == .F.
      Return .F.
   EndIf

   // Get Control Data ****************************************************
   nHandle           := ControlByIndex( INDEX ):Handle
   cRecordSource     := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   aColumnFields     := ControlByIndex( INDEX ):CTRL040 [ 11 ]
   aColumnClassMap   := ControlByIndex( INDEX ):CTRL040 [ 30 ]
   nItemCount        := ListView_GetItemCount ( nHandle )

   // Backup Record Number ************************************************
   nRecNo := &cRecordSource->( RECNO() )

   // If OnSave Specified, Process It And Exit ****************************
   If ValType ( ControlByIndex( INDEX ):CTRL040 [ 26 ] ) == 'B'

      // Create User Buffer Arrays From Internal Ones ****************
      aAppendBuffer  := {}
      aEditBuffer    := {}
      aMarkBuffer    := ControlByIndex( INDEX ):CTRL040 [ 25 ]
      aTemp := ControlByIndex( INDEX ):CTRL040 [ 21 ] // Internal Buffer

      nColumnCount := HMG_LEN ( aColumnFields )
      nAppendRecordCount := ControlByIndex( INDEX ):CTRL040 [ 22 ]

      // Create User Append Buffer ***********************************
      for h := -1 To nAppendRecordCount Step -1
         aRecord := array ( nColumnCount )
         for g := 1 To HMG_LEN ( aTemp )
            if aTemp [ g ] [ 4 ] == h
               aRecord [ aTemp [ g ] [ 2 ] ] := aTemp [ g ] [ 3 ]
            endif
         next
         aadd ( aAppendBuffer , aRecord )
      next

      // Create User Edit Buffer *******************************************
      for g := 1 To HMG_LEN ( aTemp )
         h := aTemp [ g ] [ 4 ]
         if h > 0
            aadd ( aEditBuffer , aTemp [ g ] )
         endif
      next

      // Set This.*Buffer Properties
      oHmgApp():APP278 := aClone ( aEditBuffer )
      oHmgApp():APP279 := aClone ( aMarkBuffer )
      oHmgApp():APP280 := aClone ( aAppendBuffer )

      // Execute It!
      Eval ( ControlByIndex( INDEX ):CTRL040 [ 26 ] )

      // Cleanup ********************************************

      // Set Pending Updates Flag
      ControlByIndex( INDEX ):CTRL040 [ 20 ] := .F.

      // Clean Data Buffer
      ControlByIndex( INDEX ):CTRL040 [21] := {}

      // Update New Records Buffer Count
      ControlByIndex( INDEX ):CTRL040 [ 22 ] := 0

      // Reset Buffered Session Initial Item Count
      ControlByIndex( INDEX ):CTRL040 [ 23 ] := GridRecCount( index )

      // Reset Deleted / Recalled Buffer Count
      ControlByIndex( INDEX ):CTRL040 [ 24 ] :=  0

      // Reset Deleted / Recalled Buffer
      ControlByIndex( INDEX ):CTRL040 [ 25 ] := {}

      // Refresh
      DataGridRefresh(index)

      // The End
      Return .T.

   EndIf


///////////////////////////////////////////////////////////////////////
// RDD DEPENDANT CODE
///////////////////////////////////////////////////////////////////////

   if &cRecordSource->( RddName() ) == 'SQLMIX'
      MsgHMGError("GRID: Modify SQLMIX RDD tables are not allowed. Program terminated" )
   ElseIf   &cRecordSource->(RddName()) == 'PGRDD'
      MsgHMGError("GRID: Modify PostGre RDD tables are not allowed. Program terminated" )
   Else
      oHmgApp():APP347 := .F.   // Grid Automatic Update

      // Process Existing Records *************************************************
      aTemp := ControlByIndex( INDEX ):CTRL040 [ 21 ]
      For x := 1 To HMG_LEN ( aTemp )

         // Get Buffer Data
         nLogicalRow    := aTemp [ x ] [ 1 ]
         nLogicalCol    := aTemp [ x ] [ 2 ]
         xValue         := aTemp [ x ] [ 3 ]
         nPhysicalRow   := aTemp [ x ] [ 4 ]

         // Position in Physical Row ..............
         If nPhysicalRow > 0
            &cRecordSource->( DBGOTO( nPhysicalRow ) )

            // Attempt To Lock To Save ....................................
            If RLOCK() == .F.
               MsgExclamation(oHmgApp():APP136[9],oHmgApp():APP136[10])
               &cRecordSource->( DBGOTO( nRecNo ) )
               Return .f.
            endif

            // Save Data ..................................................
            if aColumnClassMap[ nLogicalCol ] == 'F'
               &cRecordSource->&( aColumnFields[ nLogicalCol ] ) := xValue
            Else
               &( aColumnFields[ nLogicalCol ] ) := xValue
            EndIf

            // Unlock .....................................................
            &cRecordSource->( DBRUNLOCK( &cRecordSource->( RECNO() ) ) )
         EndIf
      Next x

      // Process New Records ************************************************
      l := HMG_LEN(aTemp)
      For z := 1 To l
         If aTemp [ z ] [ 4 ] < 0
            // If the new record is marked as 'Deleted' do not append.
            If ! IsBufferedRecordMarkedForDeletion( index , aTemp [ z ] [ 4 ] )
               &cRecordSource->( DBAPPEND() )
               n := aTemp [ z ] [ 4 ]
               For j := 1 To l
                  If aTemp [j] [4] == n
                     // Attempt To Lock To Save .............
                     If RLOCK() == .F.
                        MsgExclamation(oHmgApp():APP136[9],oHmgApp():APP136[10])
                        &cRecordSource->( DBGOTO( nRecNo ) )
                        Return .f.
                     endif

                     // Save Data ...........................
                     if aColumnClassMap[ aTemp [j] [2] ] == 'F'
                        &cRecordSource->&( aColumnFields[ aTemp [j] [2] ] ) := aTemp [j] [3]
                     else
                        &( aColumnFields[ aTemp [j] [2] ] ) := aTemp [j] [3]   // Add, May 2016
                     EndIf

                     // Unlock ..............................
                     &cRecordSource->( DBRUNLOCK( &cRecordSource->( RECNO() ) ) )

                     // CleanUp .............................
                     aTemp [j] [1] := 0
                     aTemp [j] [2] := 0
                     aTemp [j] [3] := Nil
                     aTemp [j] [4] := 0
                  Endif
               Next j
            EndIf
         EndIf
      Next z

      // Precess Delete / ReCall Commands ****************************
      For k := 1 To ControlByIndex( INDEX ):CTRL040 [ 24 ]

         // Get Row And Command
         nPhysicalRow := ControlByIndex( INDEX ):CTRL040 [ 25 ] [ k ] [ 2 ]
         cCommand := ControlByIndex( INDEX ):CTRL040 [ 25 ] [ k ] [ 3 ]

         // Position On The Record To Process
         &cRecordSource->( DBGOTO( nPhysicalRow ) )

         // Lock Record
         If RLOCK() == .F.
            MsgExclamation(oHmgApp():APP136[9],oHmgApp():APP136[10])
            return .f.
         endif

         // Excute Command **************************************
         If cCommand == 'D'
            &cRecordSource->( DBDELETE() )
         ElseIf cCommand == 'R'
            &cRecordSource->( DBRECALL() )
         EndIf

         // Unlock **********************************************
         &cRecordSource->( DBRUNLOCK( &cRecordSource->( RECNO() ) ) )
      Next

      oHmgApp():APP347 := .T.   // Grid Automatic Update

   EndIf

///////////////////////////////////////////////////////////////////////
// END RDD DEPENDANT CODE
///////////////////////////////////////////////////////////////////////


   // Cleanup ********************************************

   // Restore Original Record Number **************************************
   &cRecordSource->( DBGOTO( nRecNo ) )

   // Set Pending Updates Flag ********************************************
   ControlByIndex( INDEX ):CTRL040 [ 20 ] := .F.

   // Clean Data Buffer ***************************************************
   ControlByIndex( INDEX ):CTRL040 [21] := {}

   // Update New Records Buffer Count *************************************
   ControlByIndex( INDEX ):CTRL040 [ 22 ] := 0

   // Reset Buffered Session Initial Item Count
   ControlByIndex( INDEX ):CTRL040 [ 23 ] := GridRecCount( index )

   // Reset Deleted / Recalled Buffer Count
   ControlByIndex( INDEX ):CTRL040 [ 24 ] :=  0

   // Reset Deleted / Recalled Buffer
   ControlByIndex( INDEX ):CTRL040 [ 25 ] := {}

   // Refresh
   DataGridRefresh(index)

Return .t.


********************************************************************
Function IsBufferedRecordMarkedForDeletion( index , nPhysicalRow )
********************************************************************
Local lRetVal := .F.
Local k, cCommand

   For k := 1 To ControlByIndex( INDEX ):CTRL040 [ 24 ]
      cCommand := ControlByIndex( INDEX ):CTRL040 [ 25 ] [ k ] [ 3 ]
      If cCommand == 'D'
         If nPhysicalRow == ControlByIndex( INDEX ):CTRL040 [ 25 ] [ k ] [ 2 ]
            lRetVal := .T.
            Exit
         EndIf
      EndIf
   Next

Return lRetVal


************************************************************
Function DataGridRefresh( index , lPreserveSelection )
*************************************************************
Local cRecordSource
Local nHandle
Local aValue

   DEFAULT lPreserveSelection TO .F.

   // Get Control Data ****************************************************
   nHandle       := ControlByIndex( INDEX ):Handle
   cRecordSource := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   IF ValType ( cRecordSource ) <> 'C'
      return .F.   // Not Grid with cRecordSource ( DataBase )
   ENDIF

   if lPreserveSelection
      aValue := _GetValue ( , , index )
   endif

   // Reset Cell Position Data ********************************************
   ControlByIndex( INDEX ):CTRL039 := 0
   ControlByIndex( INDEX ):CTRL015 := 0

   // Set New ItemCount ***************************************************
// ListView_SetItemCount ( nHandle , 0 )
   ListView_SetItemCount ( nHandle , GridRecCount( index ) )

   // ReSet Selected Row **************************************************
   if lPreserveSelection
      _SetValue (  ,  , aValue , index )
   Else
      _SetValue (  ,  , {1,1} , index )
   EndIf

//   RedrawWindow( nHandle )
Return .t.


***************************************
Function DataGridClearBuffer(index)
***************************************
Local cRecordSource, nHandle

   // Get Control Data ****************************************************
   nHandle        := ControlByIndex( INDEX ):Handle
   cRecordSource  := ControlByIndex( INDEX ):CTRL040 [ 10 ]

   // Set Pending Updates Flag ********************************************
   ControlByIndex( INDEX ):CTRL040 [ 20 ] := .F.

   // Clean Data Buffer ***************************************************
   ControlByIndex( INDEX ):CTRL040 [21] := {}

   // Update New Records Buffer Count *************************************
   ControlByIndex( INDEX ):CTRL040 [ 22 ] := 0

   // Reset Deleted / Recalled Buffer Count *******************************
   ControlByIndex( INDEX ):CTRL040 [ 24 ] :=  0

   // Reset Deleted / Recalled Buffer *************************************
   ControlByIndex( INDEX ):CTRL040 [ 25 ] := {}

   // Refresh *************************************************************
   DataGridRefresh(index)

Return .t.


*******************************************************
Procedure GetDataGridCellData ( index , lTrueData )
*******************************************************
__THREAD STATIC nLastLogicalRecord := 0
__THREAD STATIC nLastHandle := 0
__THREAD STATIC nLastPhysicalRecord := 0
Local x, aTemp
Local cRecordSource
Local aColumnFields
Local xBufferedCellValue
Local lBufferedCell := .F.
LOCAL nRecNo

   IF oHmgApp():APP347 == .F.   // Grid Automatic Update
      RETURN
   ENDIF

   IF ControlByIndex( INDEX ):CTRL040 [ 33 ] == .F.  // ENABLEUPDATE = .T. | DISABLEUPDATE = .F.
      RETURN
   ENDIF

   cRecordSource     := ControlByIndex( INDEX ):CTRL040 [ 10 ]
   aColumnFields     := ControlByIndex( INDEX ):CTRL040 [ 11 ]

   nRecNo := &cRecordSource->( RECNO() )   // ADD, march 2017

   // Update Physical Record position
   If nLasthandle <> ControlByIndex( Index ):Handle .OR. nLastLogicalRecord <> This.QueryRowIndex .OR. ListView_GetItemCount( ControlByIndex( Index ):Handle ) == 1
      nLasthandle := ControlByIndex( Index ):Handle
      nLastLogicalRecord := This.QueryRowIndex
      nLastPhysicalRecord := GridSetPhysicalRecord( index, This.QueryRowIndex )
   else
      &cRecordSource->( DBGOTO( nLastPhysicalRecord ) )   // ADD, march 2017
   endif

   // Determine If The Required Cell Is Buffered
   IF ControlByIndex( INDEX ):CTRL040 [ 20 ] == .T.  // Pending Edit Updates Flag
      aTemp := ControlByIndex( INDEX ):CTRL040 [ 21 ]   // { nLogicalRow , nLogicalCol , xValue , nRecNo }
      lBufferedCell := .F.
      FOR x := 1 TO HMG_LEN ( aTemp )
         IF  aTemp [ x ] [ 1 ] == This.QueryRowIndex .and. aTemp [ x ] [ 2 ] == This.QueryColIndex
            lBufferedCell := .T.
            xBufferedCellValue := aTemp [ x ] [ 3 ]
            Exit
         ENDIF
      NEXT
   ENDIF


   // This started like a nice and compact piece of code, but it is becoming terribly complicated now
   if IsDataGridMemo( index , This.QueryColIndex ) == .T.
      If lTrueData
         This.QueryData := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
      else
         This.QueryData := '<Memo>'
      EndIf
   else
      If lTrueData
         This.QueryData := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
      else
         If ValType ( ControlByIndex( INDEX ):CTRL040 [ 18 ] ) = 'A' // DynamicDisplay
            This.CellRowIndex := This.QueryRowIndex
            This.CellColIndex := This.QueryColIndex
            This.CellValueEx := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
            This.QueryData := EVAL ( ControlByIndex( INDEX ):CTRL040 [ 18 ] [ This.QueryColIndex ] )   // Eval DynamicDisplay CodeBlock
         Else
            This.QueryData := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
         EndIf
      Endif
   Endif

   &cRecordSource->( DBGOTO( nRecNo ) )   // ADD, march 2017

Return


************************************************************
Function GetFiledData ( index, nField )   // ADD May 2016
************************************************************
Local cRecordSource   := ControlByIndex( Index ):CTRL040 [ 10 ]
Local aColumnFields   := ControlByIndex( Index ):CTRL040 [ 11 ]
Local aColumnClassMap := ControlByIndex( Index ):CTRL040 [ 30 ]
Local xData
   IF aColumnClassMap [ nField ] == 'F'
   // xData := &cRecordSource->( FIELDGET( &cRecordSource->( FIELDPOS( aColumnFields[ nField ] ) ) ) )
      xData := &cRecordSource->&( aColumnFields[ nField ] )   //  Field in this Area
   ELSE
      xData := &( aColumnFields[ nField ] )   // Field in other Area
   ENDIF
Return xData


***********************************************************************************
Function GridSetPhysicalRecord( index, nLogicalRecno )   // ADD May 2016
***********************************************************************************
Local cRecordSource   := ControlByIndex( Index ):CTRL040 [ 10 ]
Local nPhysicalRecord := 0
Local nLogicalRecord  := 0
Local nOldWorkArea

   IF _IS_ACTIVE_FILTER_
/*
      &cRecordSource->( DBGOTOP() )
      WHILE .NOT. &cRecordSource->( EOF() )
         IF &cRecordSource->( DELETED() ) == .F.
            nLogicalRecord ++
            IF nLogicalRecord == nLogicalRecno
               nPhysicalRecord := &cRecordSource->( RECNO() )
               EXIT
            ENDIF
         ENDIF
         &cRecordSource->( DBSKIP() )
      ENDDO
*/
      nOldWorkArea := SELECT()
      SELECT( cRecordSource )
      DBGOTOP()
      // if Set Delete is On, dbeval() not process deleted records
      DBEVAL( {|| nLogicalRecord++, nPhysicalRecord := RECNO() }, NIL, {|| nLogicalRecord <> nLogicalRecno } )
      DBGOTO( nPhysicalRecord )
      SELECT( nOldWorkArea )
   ELSE
      nLogicalRecord := nLogicalRecno
      &cRecordSource->( ORDKEYGOTO( nLogicalRecord ) )
      nPhysicalRecord := &cRecordSource->( RECNO() )
   ENDIF
RETURN nPhysicalRecord



