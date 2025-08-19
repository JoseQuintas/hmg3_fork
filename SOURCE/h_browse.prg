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
#define SB_CTL          2  // ok
#define CB_SHOWDROPDOWN 335  // ok
memvar aresult
*-----------------------------------------------------------------------------*

#include "SETCompileBrowse.ch"
#ifdef COMPILEBROWSE

Function _DefineBrowse ( ControlName, ;
         ParentForm, ;
         x, ;
         y, ;
         w, ;
         h, ;
         aHeaders, ;
         aWidths, ;
         aFields , ;
         value, ;
         fontname, ;
         fontsize , ;
         tooltip , ;
         change , ;
         dblclick , ;
         aHeadClick , ;
         gotfocus , ;
         lostfocus , ;
         WorkArea , ;
         Delete, ;
         nogrid, ;
         aImage, ;
         aJust , ;
         HelpId , ;
         bold , ;
         italic , ;
         underline , ;
         strikeout , ;
         break , ;
         backcolor , ;
         fontcolor , ;
         lock , ;
         inplace , ;
         novscroll , ;
         appendable , ;
         readonly , ;
         valid , ;
         validmessages , ;
         edit , ;
         dynamicbackcolor , ;
         aWhenFields , ;
         dynamicforecolor , ;
         inputmask , ;
         format , ;
         inputitems , displayitems , aHeaderImages, ;
         NoTrans, NoTransHeader)
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar , ix, wBitmap , z , ScrollBarHandle , DeltaWidth , k := 0
Local cParentTabName, oControl

Local ControlHandle
Local FontHandle
Local hsum := 0
Local ScrollBarButtonHandle
Local nHeaderImageListHandle

   InPlace := .T.

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
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   endif

   ix := GetFormIndex (ParentForm)

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm = ParentForm

   ParentForm = GetFormHandle (ParentForm)

   if valtype(w) == "U"
      w := 240
   endif
   if valtype(h) == "U"
      h := 120
   endif
   if valtype(value) == "U"
      value := 0
   endif
   if valtype(aFields) == "U"
      aFields := {}
   endif
   if valtype(aJust) == "U"      // Browse+
      aJust := Array( HMG_LEN( aFields ) )
      aFill( aJust, 0 )
   else
      aSize( aJust, HMG_LEN( aFields) )
      aEval( aJust, { |x| x := iif( x == NIL, 0, x ) } )
   endif
   if valtype(aImage) == "U"
      aImage := {}
   endif

   // If splitboxed force no vertical scrollbar

   if valtype(x) == "U" .or. valtype(y) == "U"
      novscroll := .T.
   endif

   if novscroll == .F.
      DeltaWidth := GETVSCROLLBARWIDTH()
   Else
      DeltaWidth := 0
   EndIf

   if valtype(x) == "U" .or. valtype(y) == "U"

      If oHmgApp():APP216 == 'TOOLBAR'
         Break := .T.
      EndIf

      oHmgApp():APP216   := 'GRID'

      i := GetFormIndex ( cParentForm )

      if i > 0

         ControlHandle := InitBrowse ( ParentForm, 0, x, y, w - DeltaWidth , h , '', 0, iif( nogrid, 0, 1 ) ) // Browse+

         x := GetWindowCol ( Controlhandle )
         y := GetWindowRow ( Controlhandle )

         if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
            FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
         Else
            FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
         endif

         AddSplitBoxItem ( Controlhandle, FormByIndex( I ):FORM087 , w , break , , , , oHmgApp():APP258 )
      EndIf

   Else

      ControlHandle := InitBrowse ( ParentForm, 0, x, y, w - DeltaWidth , h , '', 0, iif( nogrid, 0, 1 ) ) // Browse+

      if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
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

   wBitmap := iif( HMG_LEN( aImage ) > 0, AddListViewBitmap( ControlHandle, aImage, NoTrans ), 0 ) //Add Bitmap Column
   aWidths[1] := max ( aWidths[1], wBitmap + 2 ) // Set Column 1 witth to Bitmap width

   if valtype(aHeadClick) == "U"
      aHeadClick := {}
   endif

   if valtype(change) == "U"
      change := ""
   endif

   if valtype(dblclick) == "U"
      dblclick := ""
   endif

   if valtype(tooltip) != "U"
           SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   endif

   k := _GetControlFree()

   Public &mVar. := k
   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "BROWSE"
      :Name := ControlName
      :Handle := ControlHandle
      :ParentFormHandle := ParentForm
      :CTRL005 := 0
      :CTRL006 := aWidths
      :CTRL007 := aHeaders
      :CTRL008 := Value
      :CTRL009 := Lock
      :CTRL010 := lostfocus
      :CTRL011 := gotfocus
      :CTRL012 := change
      :IsDeleted := .F.
      :CTRL014 := aImage // Browse+
      :CTRL015 := inplace
      :CTRL016 := dblclick
      :CTRL017 := aHeadClick
      :CTRL018 := y
      :CTRL019 := x
      :CTRL020 := w
      :CTRL021 := h
      :CTRL022 := WorkArea
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := Delete
      :CTRL026 := 0
      :CTRL027 := fontname
      :CTRL028 := fontsize
      :CTRL029 := {bold,italic,underline,strikeout}
      :CTRL030 := tooltip
      :CTRL031 := aFields
      :CTRL032 := {}
      :CTRL033 := aHeaders
      :CTRL034 := .t.
      :CTRL035 := HelpId
      :CTRL036 := FontHandle
      :CTRL037 := cParentTabName
      :CTRL038 := .T.
      :CTRL039 := { 0 , appendable , readonly , valid , validmessages , edit , inputitems , displayitems , Nil , Nil , Nil }
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   InitListViewColumns ( ControlHandle , aHeaders , aWidths, aJust ) // Browse+

   // Add to browselist array to update on window activation

   i := k
   aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089, k )

   For z := 1 To HMG_LEN ( ControlByIndex( I ):CTRL006 )
      hsum := hsum + ListView_GetColumnWidth ( ControlByIndex( i ):Handle , z - 1 )
      ControlByIndex( I ):CTRL006 [z] := ListView_GetColumnWidth ( ControlByIndex( i ):Handle , z - 1 )
   Next z

   // Add Vertical scrollbar

   if novscroll == .F.

      if hsum > w - GETVSCROLLBARWIDTH() - 4
         ScrollBarHandle := InitVScrollBar (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y , GETVSCROLLBARWIDTH() , h - GETHSCROLLBARHEIGHT() )
         ScrollBarButtonHandle := InitVScrollBarButton (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y + h - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )
      Else
         ScrollBarHandle := InitVScrollBar (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y , GETVSCROLLBARWIDTH() , h )
         ScrollBarButtonHandle := InitVScrollBarButton (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y + h - GETHSCROLLBARHEIGHT() , 0 , 0 )
      EndIf

      If oHmgApp():BeginTabActive = .T.
         aAdd ( oHmgApp():APP142 , { ControlHandle , ScrollBarHandle , ScrollBarButtonHandle } )
      EndIf

   Else

      ScrollBarHandle := 0

      If oHmgApp():BeginTabActive = .T.
         aAdd ( oHmgApp():APP142 , ControlHandle )
      EndIf

   EndIf

   ControlByIndex( I ):CTRL005 := ScrollBarHandle
   ControlByIndex( I ):CTRL039 [1] := ScrollBarButtonHandle


   ControlByIndex( K ):CTRL040 [1] := dynamicbackcolor
   ControlByIndex( K ):CTRL040 [2] := dynamicforecolor
   ControlByIndex( K ):CTRL040 [3] := aWhenFields
   ControlByIndex( K ):CTRL040 [4] := inputmask
   ControlByIndex( K ):CTRL040 [5] := format

   If ValType(aHeaderImages) <> "U"
      nHeaderImageListHandle := SetListViewHeaderImages ( ControlHandle , aHeaderImages , aJust, NoTransHeader )
      ControlByIndex( K ):CTRL039 [9] := aHeaderImages
      ControlByIndex( K ):CTRL039 [10] := nHeaderImageListHandle
      ControlByIndex( K ):CTRL039 [11] := aJust
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
Procedure _BrowseUpdate( ControlName,ParentName , z )
*-----------------------------------------------------------------------------*
Local PageLength , aTemp := {} , cTemp , Fields , _BrowseRecMap := {} , i , x , j , First , Image , _Rec , ColorMap , ColorRow , processdbc , processdfc , k
Local dbc
Local dFc

local fcolormap
local fcolorrow

Local dim
Local processdim

Local dft
Local processdft

Local teval

Local aDisplayItems
Local aDisplayItemsLengths
Local aProcessDisplayItems
Local lFound
Local p
Local cTempType   // added by Marek Olszewski 2016.05.25


   If pcount() == 2
      i := GetControlIndex(ControlName,ParentName)
   Else
      i := z
   EndIf

   If Select() == 0
      Return
   EndIf

   *

   aDisplayItems := ControlByIndex( I ):CTRL039 [8]

   aProcessDisplayItems := array ( HMG_LEN (ControlByIndex( I ):CTRL031) )
   aDisplayItemsLengths := array ( HMG_LEN (ControlByIndex( I ):CTRL031) )

   if valtype (aDisplayItems) = 'A'

      For k := 1 To HMG_LEN ( aProcessDisplayItems )

         if valtype ( aDisplayItems [k] ) = 'A'
            aProcessDisplayItems [k] := .T.
            aDisplayItemsLengths [k] := HMG_LEN ( aDisplayItems [k] )
         else
            aProcessDisplayItems [k] := .F.
            aDisplayItemsLengths [k] := 0
         endif

      Next k

   else

      For k := 1 To HMG_LEN ( aProcessDisplayItems )
         aProcessDisplayItems [k] := .F.
         aDisplayItemsLengths [k] := 0
      Next k

   endif

   *

   dim :=    ControlByIndex( I ):CTRL040 [4]

   processdim := array ( HMG_LEN (ControlByIndex( I ):CTRL031) )

   if valtype (dim) = 'A'

      For k := 1 To HMG_LEN ( processdim )
         if valtype ( dim [k] ) = 'C'
            if .not. empty ( dim [k] )
               processdim [k] := .T.
            else
               processdim [k] := .F.
            endif
         else
            processdim [k] := .F.
         endif
      Next k

   else

      For k := 1 To HMG_LEN ( processdim )
         processdim [k] := .F.
      Next k

   endif

   dft :=    ControlByIndex( I ):CTRL040 [5]

   processdft := array ( HMG_LEN (ControlByIndex( I ):CTRL031) )

   if valtype (dft) = 'A'

      For k := 1 To HMG_LEN ( processdft )
         if valtype ( dft [k] ) = 'C'
            if .not. empty ( dft [k] )
               processdft [k] := .T.
            else
               processdft [k] := .F.
            endif
         else
            processdft [k] := .F.
         endif
      Next k

   else

      For k := 1 To HMG_LEN ( processdft )
         processdft [k] := .F.
      Next k

   endif

   dbc :=    ControlByIndex( I ):CTRL040 [1]

   processdbc := if ( valtype (dbc) = 'A' , .t. , .f. )

   dfc :=    ControlByIndex( I ):CTRL040 [2]

   processdFc := if ( valtype (dFc) = 'A' , .t. , .f. )

   ControlByIndex( I ):CTRL026 := 0

   First   := iif( HMG_LEN( ControlByIndex( I ):CTRL014 ) == 0, 1, 2 ) // Browse+ ( 2= bitmap definido, se cargan campos a partir de 2º )

   Fields := ControlByIndex( I ):CTRL031

   ListViewReset ( ControlByIndex( i ):Handle )
   PageLength := ListViewGetCountPerPage ( ControlByIndex( i ):Handle )


   if processdbc == .t.
      colormap := {}
      colorrow := {}
   endif

   if processdfc == .t.
      fcolormap := {}
      fcolorrow := {}
   endif

   for x := 1 to PageLength

      aTemp := {}

      If First == 2                  // Browse+
         cTemp := Fields [1]

         if Type (cTemp) == 'N'            // ..
            image := &cTemp

         elseif Type (cTemp) == 'L'         // ..
            image := iif( &cTemp, 1, 0 )

         else                  // ..
            image := 0

         endif                  // ..
         aadd ( aTemp , NIL )

         if processdbc == .t.
            if valtype ( dbc ) = 'A'
               if HMG_LEN ( dbc ) = HMG_LEN ( Fields )
                  aadd ( colorrow , -1 )
               endif
            endif
         endif
         if processdfc == .t.
            if valtype ( dfc ) = 'A'
               if HMG_LEN ( dfc ) = HMG_LEN ( Fields )
                  aadd ( fcolorrow , -1 )
               endif
            endif
         endif

      EndIf                     // Browse+

      For j := First To HMG_LEN (Fields)

         cTemp := Fields [j]
         cTempType := ValType(&cTemp)


         If aProcessDisplayItems [ j ] == .T.

            lFound := .F.

            For p := 1 To aDisplayItemsLengths [ j ]
               If aDisplayItems [ j ] [ p ] [ 2 ] = &cTemp
                  aadd ( aTemp , RTRIM ( aDisplayItems [ j ] [ p ] [ 1 ] ) )
                  lFound := .T.
                  Exit
               EndIf
            Next p

            If lFound == .F.
               aadd ( aTemp , '' )
            EndIf

         ElseIf cTempType == 'N'

            if   processdim [j] == .f. .and. processdft [j] == .f.

               aadd ( aTemp , LTRIM ( STR (&cTemp) ) )

            elseif   processdim [j] == .t. .and. processdft [j] == .f.

               aadd ( aTemp , TransForm ( &cTemp , dim [j] ) )

            elseif   processdim [j] == .f. .and. processdft [j] == .t.

               aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] ) )

            elseif   processdim [j] == .t. .and. processdft [j] == .t.

               aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] + ' ' + dim [j] ) )

            endif

         ElseIf cTempType == 'D'

            aadd ( aTemp , Dtoc(&cTemp) )

         ElseIf cTempType == 'L'

            aadd ( aTemp , IIF ( &cTemp == .T. , '.T.' , '.F.' ) )

         ElseIf cTempType == 'C'

            if processdim [j] == .t.
               aadd ( aTemp , RTRIM ( _BrowseCharMaskDisplay ( &cTemp , dim [j] ) ) )
            else
               aadd ( aTemp , RTRIM ( &cTemp ) )
            endif

         ElseIf cTempType == 'M'

            aadd ( aTemp , '<Memo>' )

         ElseIf cTempType == 'N'

            if   processdim [j] == .f. .and. processdft [j] == .f.

               aadd ( aTemp , LTRIM ( STR (&cTemp) ) )

            elseif   processdim [j] == .t. .and. processdft [j] == .f.

               aadd ( aTemp , TransForm ( &cTemp , dim [j] ) )

            elseif   processdim [j] == .f. .and. processdft [j] == .t.

               aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] ) )

            elseif   processdim [j] == .t. .and. processdft [j] == .t.

               aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] + ' ' + dim [j] ) )

            endif

         ElseIf cTempType == 'D'

            aadd ( aTemp , Dtoc(&cTemp) )

         ElseIf cTempType == 'L'

            aadd ( aTemp , IIF ( &cTemp == .T. , '.T.' , '.F.' ) )

         ElseIf cTempType == 'C'

            if processdim [j] == .t.
               aadd ( aTemp , RTRIM ( _BrowseCharMaskDisplay ( &cTemp , dim [j] ) ) )
            else
               aadd ( aTemp , RTRIM ( &cTemp ) )
            endif

         ElseIf cTempType == 'M'

            aadd ( aTemp , '<Memo>' )

         Else
            aadd ( aTemp , 'Nil' )

         EndIf

         if processdbc == .t.

            if valtype ( dbc ) = 'A'

               if HMG_LEN ( dbc ) = HMG_LEN ( Fields )

                  if valtype ( dbc [j] ) = 'B'

                     tEval := eval ( dbc [j] )

                     IF VALTYPE ( TEVAL ) == 'A'
                        IF HMG_LEN ( TEVAL ) == 3
                           TEVAL := RGB ( TEVAL [1] , TEVAL [2] , TEVAL [3] )
                        ENDIF
                     ENDIF

                     aadd ( colorrow , tEval )

                  else
                     aadd ( colorrow , -1 )
                  endif

               endif

            endif

         endif

         if processdfc == .t.

            if valtype ( dfc ) = 'A'

               if HMG_LEN ( dfc ) = HMG_LEN ( Fields )

                  if valtype ( dfc [j] ) = 'B'

                     tEval := eval ( dfc [j] )

                     IF VALTYPE ( TEVAL ) == 'A'
                        IF HMG_LEN ( TEVAL ) == 3
                           TEVAL := RGB ( TEVAL [1] , TEVAL [2] , TEVAL [3] )
                        ENDIF
                     ENDIF

                     aadd ( fcolorrow , tEval )

                  else
                     aadd ( fcolorrow , -1 )
                  endif

               endif

            endif

         endif

      Next j

      AddListViewItems ( ControlByIndex( i ):Handle , aTemp , Image )

      _Rec := RecNo()

      aadd ( _BrowseRecMap , _Rec )

      if processdbc == .t.
         aadd ( colormap , colorrow )
         colorrow := {}
      endif

      if processdfc == .t.
         aadd ( fcolormap , fcolorrow )
         fcolorrow := {}
      endif

      Skip

      If Eof()
         ControlByIndex( I ):CTRL026 := 1
         Go Bottom
         Exit
      EndIf

   Next x

   if processdbc == .t.

      ControlByIndex( I ):CTRL040 [ 6 ] := colormap

   else

      ControlByIndex( I ):CTRL040 [ 6 ] := Nil

   endif

   if processdfc == .t.

      ControlByIndex( I ):CTRL040 [ 7 ] := fcolormap

   else

      ControlByIndex( I ):CTRL040 [ 7 ] := Nil

   endif

   ControlByIndex( I ):CTRL032 := _BrowseRecMap

Return

*-----------------------------------------------------------------------------*
Procedure _BrowseNext ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , PageLength , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil } , s

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   PageLength := LISTVIEWGETCOUNTPERPAGE ( ControlByIndex( i ):Handle )

   s := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle )

   If  s == PageLength

      if ControlByIndex( I ):CTRL026 != 0
         Return
      EndIf

      _Alias := Alias()
      _BrowseArea := ControlByIndex( I ):CTRL022
      If Select (_BrowseArea) == 0
         Return
      EndIf
      Select &_BrowseArea
      _RecNo := RecNo()

      Go _BrowseRecMap [PageLength]
      _BrowseUpdate( ControlName , ParentForm , i )
      _BrowseVscrollUpdate( i )
      ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
      ListView_SetCursel ( ControlByIndex( i ):Handle , HMG_LEN(ControlByIndex( I ):CTRL032 ) )
      Go _RecNo
      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif

   Else

      ListView_SetCursel ( ControlByIndex( i ):Handle , HMG_LEN(_BrowseRecMap) )
      _BrowseVscrollFastUpdate ( i , PageLength - s )

   EndIf

   _BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowsePrior ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil }

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   If LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) == 1
      _Alias := Alias()
      _BrowseArea := ControlByIndex( I ):CTRL022
      If Select (_BrowseArea) == 0
         Return
      EndIf
      Select &_BrowseArea
      _RecNo := RecNo()
      Go _BrowseRecMap [1]
      Skip - LISTVIEWGETCOUNTPERPAGE ( ControlByIndex( i ):Handle ) + 1
      _BrowseVscrollUpdate( i )
      _BrowseUpdate(ControlName , ParentForm , i )
      ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
      Go _RecNo
      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif

   Else

      _BrowseVscrollFastUpdate ( i , 1 - LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) )

   EndIf

   ListView_SetCursel ( ControlByIndex( i ):Handle , 1 )

   _BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseHome ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil }

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022
   If Select (_BrowseArea) == 0
      Return
   EndIf
   Select &_BrowseArea
   _RecNo := RecNo()
   Go Top
   _BrowseVscrollUpdate( i )
   _BrowseUpdate( ControlName , ParentForm , i )
   ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
   Go _RecNo
   if Select( _Alias ) != 0
      Select &_Alias
   Else
      Select 0
   Endif

   ListView_SetCursel ( ControlByIndex( i ):Handle , 1 )

   _BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseEnd ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _BrowseRecMap   , _DeltaScroll := { Nil , Nil , Nil , Nil } , _BottomRec

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022
   If Select (_BrowseArea) == 0
      Return
   EndIf
   Select &_BrowseArea
   _RecNo := RecNo()
   Go Bottom
   _BottomRec := RecNo()

   _BrowseVscrollUpdate( i )
   Skip - LISTVIEWGETCOUNTPERPAGE ( ControlByIndex( i ):Handle ) + 1
   _BrowseUpdate(ControlName , ParentForm , i )
   ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
   Go _RecNo
   if Select( _Alias ) != 0
      Select &_Alias
   Else
      Select 0
   Endif

   ListView_SetCursel ( ControlByIndex( i ):Handle , ascan ( ControlByIndex( I ):CTRL032 , _BottomRec ) )

   _BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseUp ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , s  , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil }

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   s := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle )

   If s == 1
      _Alias := Alias()
      _BrowseArea := ControlByIndex( I ):CTRL022
      If Select (_BrowseArea) == 0
         Return
      EndIf
      Select &_BrowseArea
      _RecNo := RecNo()
      Go _BrowseRecMap [1]
      Skip - 1
      _BrowseVscrollUpdate( i )
      _BrowseUpdate(ControlName , ParentForm , i )
      ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
      Go _RecNo
      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif
      ListView_SetCursel ( ControlByIndex( i ):Handle , 1 )

   Else
      ListView_SetCursel ( ControlByIndex( i ):Handle , s - 1 )
      _BrowseVscrollFastUpdate ( i , -1 )
   EndIf

   _BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseDown ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , PageLength , s , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil }

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   s := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle )

   PageLength := LISTVIEWGETCOUNTPERPAGE ( ControlByIndex( i ):Handle )

   If s == PageLength

      if ControlByIndex( I ):CTRL026 != 0
         Return
      EndIf

      _Alias := Alias()
      _BrowseArea := ControlByIndex( I ):CTRL022
      If Select (_BrowseArea) == 0
         Return
      EndIf
      Select &_BrowseArea
      _RecNo := RecNo()

      Go _BrowseRecMap [1]
      Skip
      _BrowseUpdate( ControlName , ParentForm , i )
      _BrowseVscrollUpdate( i )
      ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
      Go _RecNo
      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif

      ListView_SetCursel ( ControlByIndex( i ):Handle , HMG_LEN(ControlByIndex( I ):CTRL032) )

   Else

      ListView_SetCursel ( ControlByIndex( i ):Handle , s+1 )
      _BrowseVscrollFastUpdate ( i , 1 )

   EndIf

   _BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseRefresh ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , s , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll := { Nil , Nil , Nil , Nil }
Local v
MEMVAR cMacroVar
Private cMacroVar


   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   v := _BrowseGetValue ( '','' , i )

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   s := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle )

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022


   If Select (_BrowseArea) == 0
      ListViewReset ( ControlByIndex( i ):Handle )
      Return
   EndIf

   Select &_BrowseArea
   _RecNo := RecNo()

   if v <= 0
      v := _RecNo
   EndIf

   Go v

   if s == 1 .or. s == 0
      cMacroVar := dbfilter()
      If HMG_LEN (cMacroVar) > 0
         If ! &cMacroVar
            Skip
         EndIf
      EndIf
   EndIf

   if s == 0 .or. s == 1
      if INDEXORD() != 0
         if ORDKEYVAL() == Nil
            Go Top
         endif
      EndIf
   endif

   if s == 0 .or. s == 1
      if Set ( _SET_DELETED ) == .T.
         if Deleted() == .T.
            Go Top
         endif
      EndIf
   endif


   If Eof()

      ListViewReset ( ControlByIndex( i ):Handle )

      Go _RecNo

      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif

      Return

   EndIf


   _BrowseVscrollUpdate( i )

   if s != 0
      Skip -s+1
   EndIf


   _BrowseUpdate( '' , '' , i )


   ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
   ListView_SetCursel ( ControlByIndex( i ):Handle , ascan ( ControlByIndex( I ):CTRL032 , v ) )


   Go _RecNo
   if Select( _Alias ) != 0
      Select &_Alias
   Else
      Select 0
   Endif

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseSetValue ( ControlName , ParentForm , Value , z , mp )
*-----------------------------------------------------------------------------*
Local i  , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , NewPos := 50  , _DeltaScroll := { Nil , Nil , Nil , Nil } , m
MEMVAR cMacroVar
Private cMacroVar

   If Value <= 0
      Return
   EndIf

   If valtype ( z ) == 'U'
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   If oHmgApp():ThisEventType == 'BROWSE_ONCHANGE'
      If i == oHmgApp():ThisControlIndex
         MsgHMGError ("BROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated" )
      EndIf
   EndIf

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022

   If Select (_BrowseArea) == 0
      Return
   EndIf

   If Value == (_BrowseArea)->(RecCount()) + 1
      ControlByIndex( I ):CTRL008 := Value
      ListViewReset ( ControlByIndex( i ):Handle )
      _BrowseOnChange (i)
      Return
   EndIf

   If Value > (_BrowseArea)->(RecCount()) + 1
      Return
   EndIf

   If Select (_BrowseArea) == 0
      Return
   EndIf

   If valtype ( mp ) == 'U'
      m := int ( ListViewGetCountPerPage ( ControlByIndex( i ):Handle ) / 2 )
   else
      m := mp
   endif

   _DeltaScroll := ListView_GetSubItemRect ( ControlByIndex( i ):Handle , 0 , 0 )
   _BrowseRecMap := ControlByIndex( I ):CTRL032

   Select &_BrowseArea

   _RecNo := RecNo()

   Go Value

   cMacroVar := dbfilter()

   If HMG_LEN (cMacroVar) > 0

      If ! &cMacroVar

         Go _RecNo
         if Select( _Alias ) != 0
            Select &_Alias
         Else
            Select 0
         Endif

         Return

      EndIf

   EndIf

   If Eof()
      Go _RecNo
      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif
      Return
   Else
      if pcount() < 5
         _BrowseVscrollUpdate( i )
      EndIf
      Skip -m + 1
   EndIf

   ControlByIndex( I ):CTRL008 := Value
   _BrowseUpdate( '' , '' , i )
   Go _RecNo
   if Select( _Alias ) != 0
      Select &_Alias
   Else
      Select 0
   Endif

   ListView_Scroll( ControlByIndex( i ):Handle , _DeltaScroll[2] * (-1) , 0 )
   ListView_SetCursel ( ControlByIndex( i ):Handle , ascan ( ControlByIndex( I ):CTRL032 , Value ) )

   oHmgApp():ThisEventType := 'BROWSE_ONCHANGE'
   _BrowseOnChange (i)
   oHmgApp():ThisEventTpe := ''

Return
*-----------------------------------------------------------------------------*
Function _BrowseGetValue ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , RetVal , _BrowseRecMap , _Alias , _BrowseArea

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022

   If Select (_BrowseArea) == 0
      Return 0
   EndIf

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   If LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) != 0
      RetVal := _BrowseRecMap [ LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) ]
   Else
      RetVal := 0
   EndIf

Return ( RetVal )

*-----------------------------------------------------------------------------*
Function  _BrowseDelete (  ControlName , ParentForm , z  )
*-----------------------------------------------------------------------------*
Local i , _BrowseRecMap , Value , _Alias , _RecNo , _BrowseArea

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   If LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) == 0
      Return Nil
   EndIf

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   Value := _BrowseRecMap [ LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) ]

   If Value == 0
      Return Nil
   EndIf

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022
   If Select (_BrowseArea) == 0
      Return Nil
   EndIf
   Select &_BrowseArea
   _RecNo := RecNo()

   Go Value

   If ControlByIndex( I ):CTRL009 == .t.
      If Rlock()
         Delete
         Skip
         if eof()
            Go Bottom
         EndIf

         If Set ( _SET_DELETED ) == .T.
            _BrowseSetValue( '' , '' , RecNo() , i , LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) )
         EndIf

      Else

         MsgStop('Record is being editied by another user. Retry later','Delete Record')

      EndIf

   Else

      Delete
      Skip
      if eof()
         Go Bottom
      EndIf
      If Set ( _SET_DELETED ) == .T.
         _BrowseSetValue( '' , '' , RecNo() , i  , LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) )
      EndIf

   EndIf

   Go _RecNo
   if Select( _Alias ) != 0
      Select &_Alias
   Else
      Select 0
   Endif

Return Nil
*------------------------------------------------------------------------------*
Function _BrowseEdit ( GridHandle , aValid , aValidMessages , aReadOnly , lock , append , inplace , INPUTITEMS )
*------------------------------------------------------------------------------*
Local actpos:={0,0,0,0}
Local aInitValues := {} , aFormats := {} , TmpNames := {} , NewRec := 0 , MixedFields := .f.
Private aWhen
Private aWhenVarNames

   InPlace := .T.

   If LISTVIEW_GETFIRSTITEM (GridHandle) == 0
      If Valtype (append) != 'U'
         If append == .f.
            Return Nil
         EndIf
      EndIf
   EndIf

   If InPlace
      _BrowseInPlaceEdit ( GridHandle , aValid , aValidMessages , aReadOnly , lock , append , INPUTITEMS )
      Return Nil
   EndIf

Return Nil

*------------------------------------------------------------------------------*
Function _BrowseInPlaceEdit ( GridHandle , aValid , aValidMessages , aReadOnly , lock , append , aInputItems )
*------------------------------------------------------------------------------*
Local GridCol , GridRow , i , nrec , _GridWorkArea , BackArea , BackRec , _GridFields , FieldName , CellData  := '' , CellColIndex , x
Local aFieldNames
Local aTypes
Local aWidths
Local aDecimals
Local Type
Local Width
Local Decimals
Local sFieldname
Local r
Local ControlType
Local Ldelta := 0
Local aTemp
Local E
LOCAL aInputMask
LOCAL aFormat
LOCAL BFN
LOCAL BFS
Local lInputItems := .F.
Local aItems := {}
Local p
Local aValues := {}
Local ii
Local ba
Local br
LOCAL oControlI

   If oHmgApp():ThisEventType == 'BROWSE_WHEN'
      MsgHMGError("BROWSE: Editing within a browse 'when' event procedure is not allowed. Program terminated" )
   EndIf
   If oHmgApp():ThisEventType == 'BROWSE_VALID'
      MsgHMGError("BROWSE: Editing within a browse 'valid' event procedure is not allowed. Program terminated" )
   EndIf


   If append

      oControlI := ControlByHandle( GridHandle )
      I := iif( oControlI == Nil, 0, oControlI:Handle )

      _BrowseInPlaceAppend ( '' , '' , i )

      Return Nil

   EndIf

   If This.CellRowIndex != LISTVIEW_GETFIRSTITEM ( GridHandle )
      Return Nil
   EndIf

   oControlI := ControlByHandle( GridHandle )
   I := iif( oControlI == Nil, 0, oControlI:Index )

   BFN := ControlByIndex( I ):CTRL027
   BFS := ControlByIndex( I ):CTRL028

   aInputMask := ControlByIndex( I ):CTRL040 [ 4 ]

   aFormat := ControlByIndex( I ):CTRL040 [5]

   _GridWorkArea := ControlByIndex( I ):CTRL022

   _GridFields := ControlByIndex( I ):CTRL031

   CellColIndex := This.CellColIndex

   If CellColIndex < 1 .or. CellColIndex > HMG_LEN (_GridFields)
      Return Nil
   EndIf

   if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0 .And. CellColIndex == 1
      PlayHand()
      Return Nil
   EndIf

   If valType ( aInputItems ) == 'A'
      If HMG_LEN ( aInputItems ) >= CellColIndex
         If ValType ( aInputItems [ CellColIndex ] ) == 'A'
            lInputItems := .T.
         EndIf
      EndIf
   EndIf

   If ValType ( aReadOnly ) == 'A'
      If HMG_LEN ( aReadOnly ) >= CellColIndex
         If aReadOnly [ CellColIndex ] != Nil
            If aReadOnly [ CellColIndex ] == .T.
               oHmgApp():APP256 := .F.
               Return Nil
            EndIf
         EndIf
      EndIf
   EndIf

   FieldName := _GridFields [  CellColIndex ]

   // If the specified area does not exists, set recorcount to 0 and
   // return

   If Select (_GridWorkArea) == 0
      Return Nil
   EndIf

   // Save Original WorkArea
   BackArea := Alias()

   // Save Original Record Pointer
   BackRec := RecNo()

   // Selects Grid's WorkArea

   Select &_GridWorkArea

   nRec := _GetValue ( '','',i )
   Go nRec

   // If LOCK clause is present, try to lock.

   If lock == .T.
      If Rlock() == .F.
         MsgExclamation(oHmgApp():APP136[9],oHmgApp():APP136[10])
         // Restore Original Record Pointer
         Go BackRec
         // Restore Original WorkArea
         If Select (BackArea) != 0
            Select &BackArea
         Else
            Select 0
         EndIf
         Return Nil
      EndIf
   EndIf

   aTemp := ControlByIndex( I ):CTRL040 [3]

   IF VALTYPE ( aTemp ) = 'A'
      IF HMG_LEN (aTemp) == HMG_LEN (_GridFields)
         IF VALTYPE ( aTemp [CellColIndex] ) = 'B'
            ba := Alias()
            br := recno()
            oHmgApp():ThisEventType := 'BROWSE_WHEN'
            E := EVAL ( aTemp [CellColIndex] )
            oHmgApp():ThisEventType := ''
            IF E == .F.
               PlayHand()
               // Restore Original Record Pointer
               Go BackRec
               // Restore Original WorkArea
               If Select (BackArea) != 0
                  Select &BackArea
               Else
                  Select 0
               EndIf
               oHmgApp():APP256 := .F.
               Return Nil
            ENDIF
            Select (ba)
            Go br
         ENDIF
      ENDIF
   ENDIF

   CellData := &FieldName

        aFieldNames   := ARRAY(FCOUNT())
        aTypes      := ARRAY(FCOUNT())
        aWidths      := ARRAY(FCOUNT())
        aDecimals   := ARRAY(FCOUNT())

        AFIELDS(aFieldNames, aTypes, aWidths, aDecimals)

   r := HB_UAT ('>',FieldName)

   if r != 0
      sFieldName := HB_URIGHT ( FieldName, HMG_LEN(Fieldname) - r )
   Else
      sFieldName := FieldName
   EndIf

   x := FieldPos ( sFieldName )

   If x > 0
           Type      := aTypes [x]
           Width      := aWidths [x]
           Decimals   := aDecimals [x]
   EndIf

   GridRow := GetWIndowRow (GridHandle)
   GridCol := GetWIndowCol (GridHandle)

   If lInputItems == .T.
      ControlType := 'X'
      Ldelta := 1
   ElseIf Type (FieldName) == 'C'
      ControlType := 'C'
   ElseIf Type (FieldName) == 'D'
      ControlType := 'D'
   ElseIf Type (FieldName) == 'L'
      ControlType := 'L'
      Ldelta := 1
   ElseIf Type (FieldName) == 'M'
      ControlType := 'M'
   ElseIf Type (FieldName) == 'N'
      If Decimals == 0
         ControlType := 'I'
      Else
         ControlType := 'F'
      EndIf
   EndIf

   If ControlType == 'M'

      r := InputBox ( '' , ControlByIndex( I ):CTRL033 [CellColIndex] , HB_UTF8STRTRAN(CellData,CHR(141),' ') , , , .T. )

      If oHmgApp():APP257 == .F.
         Replace &FieldName With r
         oHmgApp():APP256 := .F.
      Else
         oHmgApp():APP256 := .T.
      EndIf

   Else

      oHmgApp():APP109 := GetActiveWindow()

      DEFINE WINDOW _InPlaceEdit ;
         AT This.CellRow + GridRow - ControlByIndex( I ):CTRL018 - 1 , This.CellCol + GridCol - ControlByIndex( I ):CTRL019 + 2 ;
         WIDTH This.CellWidth ;
         HEIGHT This.CellHeight + 6 + Ldelta ;
         MODAL ;
         NOCAPTION ;
         NOSIZE


         ON KEY CONTROL+W ACTION if ( _IsWindowActive ( '_InPlaceEdit' ) , _InPlaceEditOk ( i , Fieldname , _InPlaceEdit.Control_1.Value , ControlType , aValid , CellColIndex , sFieldName , _GridWorkArea , aValidMessages , lock , aInputItems ) , Nil )
         ON KEY RETURN ACTION if ( _IsWindowActive ( '_InPlaceEdit' ) , _InPlaceEditOk ( i , Fieldname , _InPlaceEdit.Control_1.Value , ControlType , aValid , CellColIndex , sFieldName , _GridWorkArea , aValidMessages , lock , aInputItems ) , Nil )
         ON KEY ESCAPE ACTION ( oHmgApp():APP256 := .T. , dbrunlock() , _InPlaceEdit.Release , setfocus ( ControlByIndex( i ):Handle ) )

         If lInputItems == .T.

            * Fill Items Array

            For p := 1 To HMG_LEN ( aInputItems [ CellColIndex ] )
               aadd ( aItems , aInputItems [ CellColIndex ] [p] [1] )
            Next p

            * Fill Values Array

            For p := 1 To HMG_LEN ( aInputItems [ CellColIndex ] )
               aadd ( aValues , aInputItems [ CellColIndex ] [p] [2] )
            Next p

            ii := aScan ( aValues , CellData )

            if ii == 0
               ii := 1
            endif

            DEFINE COMBOBOX Control_1
               FONTNAME BFN
               FONTSIZE BFS
               ROW 0
               COL 0
               ITEMS aItems
               WIDTH This.CellWidth
               VALUE ii
            END COMBOBOX

         ElseIf ControlType == 'C'
            CellData := RTRIM ( CellData )

            DEFINE TEXTBOX Control_1
               FONTNAME BFN
               FONTSIZE BFS

               ROW 0
               COL 0
               WIDTH This.CellWidth
               HEIGHT This.CellHeight + 6
               VALUE CellData
               MAXLENGTH Width

               IF VALTYPE ( AINPUTMASK ) == 'A'
                  IF HMG_LEN ( AINPUTMASK ) >= CellColIndex
                     IF VALTYPE ( AINPUTMASK [CellColIndex] ) == 'C'
                        IF ! EMPTY ( AINPUTMASK [CellColIndex] )
                           INPUTMASK AINPUTMASK [CellColIndex]
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF

            END TEXTBOX

         ElseIf ControlType == 'D'

            DEFINE DATEPICKER Control_1
               FONTNAME BFN
               FONTSIZE BFS
               ROW 0
               COL 0
               HEIGHT This.CellHeight + 6
               WIDTH This.CellWidth
               VALUE CellData
               UPDOWN .T.
               SHOWNONE .T.
            END DATEPICKER

         ElseIf ControlType == 'L'

            DEFINE COMBOBOX Control_1
               FONTNAME BFN
               FONTSIZE BFS
               ROW 0
               COL 0
               ITEMS { '.T.','.F.' }
               WIDTH This.CellWidth
               VALUE If ( CellData , 1 , 2 )
            END COMBOBOX

         ElseIf ControlType == 'I'

            DEFINE TEXTBOX Control_1
               FONTNAME BFN
               FONTSIZE BFS
               ROW 0
               COL 0
               NUMERIC   .T.
               WIDTH This.CellWidth
               HEIGHT This.CellHeight + 6
               VALUE CellData

               IF VALTYPE ( AINPUTMASK ) == 'A'
                  IF HMG_LEN ( AINPUTMASK ) >= CellColIndex
                     IF VALTYPE ( AINPUTMASK [CellColIndex] ) == 'C'
                        IF ! EMPTY ( AINPUTMASK [CellColIndex] )
                           INPUTMASK AINPUTMASK [CellColIndex]
                        ELSE
                           MAXLENGTH Width
                        ENDIF
                     ELSE
                        MAXLENGTH Width
                     ENDIF
                  ELSE
                     MAXLENGTH Width
                  ENDIF
               ELSE
                  MAXLENGTH Width
               ENDIF

               IF VALTYPE ( AFORMAT ) == 'A'
                  IF HMG_LEN ( AFORMAT ) >= CellColIndex
                     IF VALTYPE ( AFORMAT [CellColIndex] ) == 'C'
                        IF ! EMPTY ( AFORMAT [CellColIndex] )
                           FORMAT AFORMAT [CellColIndex]
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF

            END TEXTBOX

         ElseIf ControlType == 'F'

            DEFINE TEXTBOX Control_1
               FONTNAME BFN
               FONTSIZE BFS
               ROW 0
               COL 0
               NUMERIC   .T.
               WIDTH This.CellWidth
               HEIGHT This.CellHeight + 6
               VALUE CellData

               IF VALTYPE ( AINPUTMASK ) == 'A'
                  IF HMG_LEN ( AINPUTMASK ) >= CellColIndex
                     IF VALTYPE ( AINPUTMASK [CellColIndex] ) == 'C'
                        IF ! EMPTY ( AINPUTMASK [CellColIndex] )
                           INPUTMASK AINPUTMASK [CellColIndex]
                        ELSE
                           INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
                        ENDIF
                     ELSE
                        INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
                     ENDIF
                  ELSE
                     INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
                  ENDIF
               ELSE
                  INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
               ENDIF

               IF VALTYPE ( AFORMAT ) == 'A'
                  IF HMG_LEN ( AFORMAT ) >= CellColIndex
                     IF VALTYPE ( AFORMAT [CellColIndex] ) == 'C'
                        IF ! EMPTY ( AFORMAT [CellColIndex] )
                           FORMAT AFORMAT [CellColIndex]
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF

            END TEXTBOX

         EndIf

      END WINDOW

      ACTIVATE WINDOW _InPlaceEdit

      oHmgApp():APP109 := 0

   EndIf

   // Restore Original Record Pointer
   Go BackRec

   // Restore Original WorkArea
   If Select (BackArea) != 0
      Select &BackArea
   Else
      Select 0
   EndIf

Return Nil
///////////////////////////////////////////////////////////////////////////////
Procedure _InPlaceEditOk ( i , Fieldname , r , ControlType , aValid , CellColIndex , sFieldName , AreaName , aValidMessages , lock , aInputItems )
///////////////////////////////////////////////////////////////////////////////
Local b , Result , mVar , TmpName

   If ControlType == 'X' .Or. ControlType == 'L'

      If GetDroppedState ( GetControlHandle ('Control_1' , '_InPlaceEdit' ) ) == 1
         SendMessage ( GetControlHandle ('Control_1' , '_InPlaceEdit' ) , CB_SHOWDROPDOWN , 0 , 0 )
         InsertReturn()
         Return
      EndIf

   EndIf

   If ValType ( aValid ) == 'A'
      If HMG_LEN ( aValid ) >= CellColIndex
         If aValid [ CellColIndex ] != Nil
            Result := _GetValue ( 'Control_1' , '_InPlaceEdit' )

            If ControlType == 'L'
               Result := if ( Result == 0 .or. Result == 2 , .F. , .T. )
            EndIf

            TmpName := 'MemVar' + AreaName + sFieldname
            mVar := TmpName
            &mVar := Result

            oHmgApp():ThisEventType := 'BROWSE_VALID'

            b := Eval ( aValid [ CellColIndex ] )

            oHmgApp():ThisEventType := ''

            If b == .f.

               If ValType ( aValidMessages ) == 'A'

                  If HMG_LEN ( aValidMessages ) >= CellColIndex

                     If aValidMessages [CellColIndex] != Nil

                        MsgExclamation ( aValidMessages [CellColIndex] )

                     Else

                        MsgExclamation (oHmgApp():APP136[11])

                     EndIf

                  Else

                     MsgExclamation (oHmgApp():APP136[11])

                  EndIf

               Else

                  MsgExclamation (oHmgApp():APP136[11])

               EndIf

            Else

               If ControlType == 'L'
                  r := if ( r == 0 .or. r == 2 , .F. , .T. )

               ElseIf ControlType == 'X'

                  r := aInputItems [ CellColIndex ] [ r ] [ 2 ]

               EndIf

               If lock == .t.
                  Replace &FieldName With r
                  Unlock

                  _BrowseRefresh ( '' , '' , i )

                  _InPlaceEdit.Release
               Else
                  Replace &FieldName With r

                  _BrowseRefresh ( '' , '' , i )

                  _InPlaceEdit.Release
               EndIf

            EndIf

         Else

            If ControlType == 'L'

               r := if ( r == 0 .or. r == 2 , .F. , .T. )

            ElseIf ControlType == 'X'

               r := aInputItems [ CellColIndex ] [ r ] [ 2 ]

            EndIf

            If lock == .t.

               Replace &FieldName With r
               Unlock

               _BrowseRefresh ( '' , '' , i )

               _InPlaceEdit.Release

            Else

               Replace &FieldName With r

               _BrowseRefresh ( '' , '' , i )

               _InPlaceEdit.Release

            EndIf

         EndIf

      EndIf

   Else

      If ControlType == 'L'

         r := if ( r == 0 .or. r == 2 , .F. , .T. )

      ElseIf ControlType == 'X'

         r := aInputItems [ CellColIndex ] [ r ] [ 2 ]

      EndIf

      If lock == .t.

         Replace &FieldName With r
         Unlock

         _BrowseRefresh ( '' , '' , i )

         _InPlaceEdit.Release

      Else

         Replace &FieldName With r

         _BrowseRefresh ( '' , '' , i )

         _InPlaceEdit.Release

      EndIf

   EndIf


   oHmgApp():APP256 := .F.

   setfocus ( ControlByIndex( i ):Handle )

Return
*------------------------------------------------------------------------------*
Procedure ProcessInPlaceKbdEdit(i)
*------------------------------------------------------------------------------*
Local r
Local IPE_MAXCOL
Local TmpRow
Local xs,xd

   If ControlByIndex( I ):CTRL015 == .F.
      Return
   EndIf

   if LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) == 0
      Return
   EndIf

   IPE_MAXCOL := HMG_LEN ( ControlByIndex( I ):CTRL031 )

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

      xs :=   ( ( ControlByIndex( I ):CTRL019 + r [2] ) +( r[3] ))  -  ( ControlByIndex( I ):CTRL019 + ControlByIndex( I ):CTRL020 )

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

      oHmgApp():ThisItemRow := ControlByIndex( I ):CTRL018 + r [1]
      oHmgApp():ThisItemCol := ControlByIndex( I ):CTRL019 + r [2]
      oHmgApp():ThisItemCellWidth := r[3]
      oHmgApp():ThisItemCellHeight := r[4]
      _BrowseEdit ( ControlByIndex( i ):Handle , ControlByIndex( I ):CTRL039 [4] , ControlByIndex( I ):CTRL039 [5] , ControlByIndex( I ):CTRL039 [3] , ControlByIndex( I ):CTRL009 , .f. , ControlByIndex( I ):CTRL015 , ControlByIndex( I ):CTRL039 [7] )
      oHmgApp():ThisControlIndex := 0
      oHmgApp():ThisType := ''

      oHmgApp():ThisItemRowIndex := 0
      oHmgApp():ThisItemColIndex := 0
      oHmgApp():ThisItemRow := 0
      oHmgApp():ThisItemCol := 0
      oHmgApp():ThisItemCellWidth := 0
      oHmgApp():ThisItemCellHeight := 0

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

Return
*------------------------------------------------------------------------------*
Procedure _BrowseSync (i)
*------------------------------------------------------------------------------*
Local _Alias
Local _BrowseArea
Local _RecNo
Local _CurrentValue

   If oHmgApp():APP254 == .T.

      _Alias := Alias()
      _BrowseArea := ControlByIndex( I ):CTRL022
      If Select (_BrowseArea) == 0
         Return
      EndIf
      Select &_BrowseArea
      _RecNo := RecNo()

                _CurrentValue := _BrowseGetValue ( '' , '' , i )

      If _RecNo != _CurrentValue
         Go _CurrentValue
      EndIf

      if Select( _Alias ) != 0
         Select &_Alias
      Else
         Select 0
      Endif

   EndIf

Return
*------------------------------------------------------------------------------*
Procedure _BrowseOnChange (i)
*------------------------------------------------------------------------------*

   _BrowseSync (i)

   _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

Return

*-----------------------------------------------------------------------------*
Procedure _BrowseInPlaceAppend ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _BrowseRecMap   , _DeltaScroll := { Nil , Nil , Nil , Nil } , _NewRec , aTemp

   If pcount() == 2
      i := GetControlIndex ( ControlName , ParentForm )
   Else
      i := z
   EndIf

   _BrowseRecMap := ControlByIndex( I ):CTRL032

   _Alias := Alias()
   _BrowseArea := ControlByIndex( I ):CTRL022
   If Select (_BrowseArea) == 0
      Return
   EndIf
   Select &_BrowseArea
   _RecNo := RecNo()
   Go Bottom

   _NewRec := RecCount() + 1

   if ListView_GetItemCount( ControlByIndex( i ):Handle ) != 0
      _BrowseVscrollUpdate( i )
      Skip - LISTVIEWGETCOUNTPERPAGE ( ControlByIndex( i ):Handle ) + 2
      _BrowseUpdate(ControlName , ParentForm , i )
   endif

   append blank

   Go _RecNo
   if Select( _Alias ) != 0
      Select &_Alias
   Else
      Select 0
   Endif

   aTemp := array ( HMG_LEN (ControlByIndex( I ):CTRL031) )
   afill ( aTemp , '' )
   aadd ( ControlByIndex( I ):CTRL032 , _NewRec )

   AddListViewItems ( ControlByIndex( i ):Handle , aTemp , 0 )

   ListView_SetCursel ( ControlByIndex( i ):Handle , HMG_LEN ( ControlByIndex( I ):CTRL032 ) )

   _BrowseOnChange (i)

   oHmgApp():APP341 := 1
   oHmgApp():APP340 := 1

Return

*------------------------------------------------------------------------------*
Procedure _BrowseVscrollUpdate (i)
*------------------------------------------------------------------------------*
Local ActualRecord , RecordCount , KeyCount

   // If vertical scrollbar is used it must be updated
   If ControlByIndex( I ):CTRL005 != 0

      KeyCount := OrdKeyCount()
      If KeyCount > 0
         ActualRecord := OrdKeyNo()
         RecordCount := KeyCount
      Else
         ActualRecord := RecNo()
         RecordCount := RecCount()
      EndIf

      ControlByIndex( I ):CTRL037 := RecordCount

      If RecordCount < 100
         SetScrollRange (ControlByIndex( I ):CTRL005 , 2 , 1 , RecordCount , .t. )
         SetScrollPos ( ControlByIndex( I ):CTRL005 , 2 , ActualRecord , .T. )
      Else
         SetScrollRange (ControlByIndex( I ):CTRL005 , 2 , 1 , 100 , .t. )
         SetScrollPos ( ControlByIndex( I ):CTRL005 , 2 , Int ( ActualRecord * 100 / RecordCount ) , .T. )
      EndIf

   EndIf

Return

*------------------------------------------------------------------------------*
Procedure _BrowseVscrollFastUpdate ( i , d )
*------------------------------------------------------------------------------*
Local ActualRecord , RecordCount

   // If vertical scrollbar is used it must be updated
   If ControlByIndex( I ):CTRL005 != 0

      RecordCount := ControlByIndex( I ):CTRL037

                If ValType(RecordCount) <> 'N'
         Return
      EndIf

      If RecordCount == 0
         Return
      EndIf

      If RecordCount < 100
                   ActualRecord := GetScrollPos(ControlByIndex( I ):CTRL005,2)
                   ActualRecord := ActualRecord + d
         SetScrollRange (ControlByIndex( I ):CTRL005 , 2 , 1 , RecordCount , .t. )
         SetScrollPos ( ControlByIndex( I ):CTRL005 , 2 , ActualRecord , .T. )
      EndIf

   EndIf

Return

*------------------------------------------------------------------------------*
Function _SetBrowseAllowEdit ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

   If ValType ( lValue ) <> 'L'
      MsgHMGError("Wrong Parameter Type (Logical Required). Program terminated" )
   Endif

   i := GetControlIndex ( cControlName , cWindowName )

   ControlByIndex( I ):CTRL039 [6] := lValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseAllowAppend ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

   If ValType ( lValue ) <> 'L'
      MsgHMGError("Wrong Parameter Type (Logical Required). Program terminated" )
   Endif

   i := GetControlIndex ( cControlName , cWindowName )

   ControlByIndex( I ):CTRL039 [2] := lValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseAllowDelete ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

   If ValType ( lValue ) <> 'L'
      MsgHMGError("Wrong Parameter Type (Logical Required). Program terminated" )
   Endif

   i := GetControlIndex ( cControlName , cWindowName )

   ControlByIndex( I ):CTRL025 := lValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseInputItems ( cControlName , cWindowName , aValue )
*------------------------------------------------------------------------------*
Local i
   If ValType ( aValue ) <> 'A'
      MsgHMGError("Wrong Parameter Type (Array Required). Program terminated" )
   Endif

   i := GetControlIndex ( cControlName , cWindowName )

   ControlByIndex( I ):CTRL039 [ 7 ] := aValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseDisplayItems ( cControlName , cWindowName , aValue )
*------------------------------------------------------------------------------*
Local i
   If ValType ( aValue ) <> 'A'
      MsgHMGError("Wrong Parameter Type (Array Required). Program terminated" )
   Endif

   i := GetControlIndex ( cControlName , cWindowName )

   ControlByIndex( I ):CTRL039 [ 8 ] := aValue

Return Nil

*------------------------------------------------------------------------------*
Function _GetBrowseInputItems ( cControlName , cWindowName )
*------------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( cControlName , cWindowName )

Return ControlByIndex( I ):CTRL039 [7]

*------------------------------------------------------------------------------*
Function _GetBrowseDisplayItems ( cControlName , cWindowName )
*------------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( cControlName , cWindowName )

Return ControlByIndex( I ):CTRL039 [8]

*------------------------------------------------------------------------------*
Function _GetBrowseAllowEdit ( cControlName , cWindowName )
*------------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( cControlName , cWindowName )

Return ControlByIndex( I ):CTRL039 [6]

*------------------------------------------------------------------------------*
Function _GetBrowseAllowAppend ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

lValue := NIL   // ADD

   i := GetControlIndex ( cControlName , cWindowName )

Return ControlByIndex( I ):CTRL039 [2]

*------------------------------------------------------------------------------*
Function _GetBrowseAllowDelete ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

lValue := NIL   // ADD

   i := GetControlIndex ( cControlName , cWindowName )

Return ControlByIndex( I ):CTRL025

*------------------------------------------------------------------------------*
Function _BrowseCharMaskDisplay ( cText , cMask )
*------------------------------------------------------------------------------*
Local i
Local Out
Local m
Local t

   Out := ''

   For i := 1 To HMG_LEN ( cMask )

      t := HB_USUBSTR ( cText , i , 1 )
      m := HB_USUBSTR ( cMask , i , 1 )

      if   m = '!'

         Out := Out + HMG_UPPER (t)

      elseif   m = 'A' .or. m = '9'

         Out := Out + t

      else

         Out := Out + m

      endif

   Next i

Return Out


#endif


