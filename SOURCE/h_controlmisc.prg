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

//MEMVAR _HMG_StopControlEventProcedure
MEMVAR _HMG_SYSDATA
MEMVAR _HMG_CharRange_Min , _HMG_CharRange_Max
MEMVAR aResult
MEMVAR _Y1,_X1,_Y2,_X2

#include "SET_COMPILE_HMG_UNICODE.ch"   // UNICODE

#include "SETCompileBrowse.ch"

#include "common.ch"
#include "hbdyn.ch"
#include "hmg.ch"


#define _NEW_MethodToolButtonChecked_

// #define SC_CLOSE   0xF060   // ok
#define MF_GRAYED       1   // ok

#define BS_PUSHBUTTON      0    // ok
#define BS_DEFPUSHBUTTON   1    // ok
#define BM_SETSTYLE        244  // ok

#define BM_SETIMAGE        247   // ok
#define IMAGE_BITMAP       0     // ok

#define WM_NEXTDLGCTL      40    // ok

#define COLOR_BTNFACE      15    // ok

#define PBM_GETPOS         1032  // ok
#define BM_GETCHECK        240   // ok
#define BST_UNCHECKED      0     // ok
#define BST_CHECKED        1     // ok
#define BM_SETCHECK        241   // ok
#define EM_GETSEL          176   // ok
#define EM_SETSEL          177   // ok
#define EM_SCROLLCARET     0x00B7   //ok

// #define WM_USER           1024          // ok (MinGW)
// #define TBM_SETPOS       (WM_USER+5)    // ok (MinGW)
// #define TBM_GETPOS       (WM_USER)      // ok (MinGW)
// #define PBM_SETPOS       (WM_USER+2)    // ok (MinGW)
// #define EM_SETBKGNDCOLOR (WM_USER+67)   // ok (MinGW)
#define TBM_SETPOS         1029  // ok
#define TBM_GETPOS         1024  // ok
#define PBM_SETPOS         1026  // ok
#define EM_SETBKGNDCOLOR   1091  // ok


//#define NM_FIRST         0      // ok
//#define NM_CUSTOMDRAW (NM_FIRST-12)  // ok
//#define WM_NOTIFY      78   //  ok

#define _SET_BITMAP_GRAY .T.


Function _Getvalue ( ControlName, ParentForm , Index )

   Local retval , h , t , x , c , d , bd , ix , auxval , WorkArea , BackRec , rcount , Tmp , Ts , BF
   Local TimeValue24h, cTimeFormat

   retval := 0

   If Pcount() == 2

      If HMG_UPPER (ALLTRIM (ControlName)) == 'VSCROLLBAR'

         Return GetScrollPos ( GetFormHandle ( ParentForm )  , 1 )

      EndIf

      If HMG_UPPER (ALLTRIM (ControlName)) == 'HSCROLLBAR'

         Return GetScrollPos ( GetFormHandle ( ParentForm )  , 0 )

      EndIf

      T = GetControlType (ControlName,ParentForm)
      h = GetControlParentHandle (ControlName,ParentForm)
      c = GetControlHandle (ControlName,ParentForm)
      ix := GetControlIndex ( ControlName, ParentForm )

   Else

      T =    ControlByIndex( Index ):Type
      h = ControlByIndex( INDEX ):ParentFormHandle
      c = ControlByIndex( Index ):Handle
      ix := Index

   EndIf

   do case

   #ifdef COMPILEBROWSE

   case T == "BROWSE"

      retval := _BrowseGetValue ( '' , '' , ix )

   #endif

   case T == "PROGRESSBAR"

      retval := SendMessage( c, PBM_GETPOS, 0, 0)

   case T == "IPADDRESS"

      retval := GetIPAddress ( c )

   case T == "MONTHCAL"

      // bd = Set (_SET_DATEFORMAT )
      bd := HBtoWinDateFormat()

      SET DATE TO ANSI
      d = ALLTRIM( STR ( GetMOnthCalYear ( c ) ) ) + "." + ALLTRIM ( STR (GetMonthCalMonth ( c ) ) ) + "." + ALLTRIM (STR ( GetMonthCalDay( c ) ) )
      retval := ctod (d)
      Set (_SET_DATEFORMAT ,bd)

   case T == "TREE"

      if ControlByIndex( IX ):CTRL009 == .F.
         retval :=  aScan ( ControlByIndex( IX ):CTRL007 , TreeView_GetSelection ( c ) )
      Else
         retval :=  TreeView_GetSelectionId ( c )
      EndIf


   case T == "MASKEDTEXT"

      IF "E" $ ControlByIndex( IX ):CTRL007

         Ts := GetWindowText ( c )

         If "." $ ControlByIndex( IX ):CTRL007
            Do Case
            Case HB_UAT ( '.' , Ts ) >  HB_UAT ( ',' , Ts )
               retval :=  GetNumFromText ( GetWindowText ( c )  , ix )
            Case HB_UAT ( ',' , Ts ) > HB_UAT ( '.' , Ts )
               retval :=  GetNumFromTextSp ( GetWindowText ( c )  , ix )
            EndCase
         Else
            Do Case
            Case HB_UAT ( '.' , Ts ) !=  0
               retval :=  GetNumFromTextSp ( GetWindowText ( c )  , ix )
            Case HB_UAT ( ',' , Ts )  != 0
               retval :=  GetNumFromText ( GetWindowText ( c )  , ix )
            OtherWise
               retval :=  GetNumFromText ( GetWindowText ( c )  , ix )
            EndCase
         EndIf
      ELSE
         retval :=  GetNumFromText ( GetWindowText ( c )  , ix )
      ENDIF

   case T == "TEXT" .or. T == "EDIT" .or. T == "LABEL"  .or. T == "CHARMASKTEXT" .or. T == "RICHEDIT"

      if t == "CHARMASKTEXT"
         if valtype ( ControlByIndex( IX ):CTRL017 ) == 'L'
            if ControlByIndex( IX ):CTRL017 == .T.
               retval := CTOD ( ALLTRIM ( GetWindowText ( c ) ) )
            Else
               retval := GetWindowText ( c )
            endif
         Else
            retval := GetWindowText ( c )
         endif
      Else
         retval := GetWindowText ( c )
      endif

   case T == "NUMTEXT"

//        retval := Int ( Val( GetWindowText(  c ) ) )
      retval := Val( GetWindowText( c ) )

   case T == "SPINNER"

      retval := GetSpinnerValue ( c [2] )

   case T == "CHECKBOX"

      auxval := SendMessage( c , BM_GETCHECK , 0 , 0 )

      if auxval == BST_CHECKED
         retval  := .t.
      ElseIf auxval == BST_UNCHECKED
         retval := .f.
      EndIf

   case T == "RADIOGROUP"

      for x = 1 to HMG_LEN (c)

         auxval := SendMessage( c[x] , BM_GETCHECK , 0 , 0 )

         if auxval == BST_CHECKED
            retval  := x
            exit
         EndIf

      next x

   case T == "COMBO"

      If ValType ( ControlByIndex( IX ):CTRL022 ) == 'C'

         auxval := ComboGetCursel ( c )
         rcount := 0

         WorkArea := ControlByIndex( IX ):CTRL022

         BackRec := (WorkArea)->(RecNo())
         (WorkArea)->(DBGoTop())

         Do While ! (WorkArea)->(Eof())
            rcount++
            if rcount == auxval

               If Empty ( ControlByIndex( IX ):CTRL033 )
                  RetVal := (WorkArea)->(RecNo())
               Else
                  Tmp := ControlByIndex( IX ):CTRL033
                  RetVal := &Tmp
               EndIf

            EndIf
            (WorkArea)->(DBSkip())
         EndDo

         (WorkArea)->(DBGoTo(BackRec))

      Else
         retval := ComboGetCursel ( c )
      EndIf

   case T == "LIST"
      retval := ListBoxGetCursel ( c )
   case T == "GRID"

      IF ControlByIndex( IX ):CTRL032 == .T.

         retval := { ControlByIndex( IX ):CTRL039 , ControlByIndex( IX ):CTRL015 }

      ELSE

         retval := LISTVIEW_GETFIRSTITEM ( c )

      ENDIF

   case T == "TAB"
      retval := TABCTRL_GETCURSEL ( c )

   case T == "DATEPICK"
      bf := set(2)
      set(2,.f.)
      //bd = Set (_SET_DATEFORMAT )
      bd := HBtoWinDateFormat()

      SET DATE TO ANSI
      d = ALLTRIM( STR ( GetDatePickYear ( c ) ) ) + "." + ALLTRIM ( STR ( GetDatePickMonth ( c ) ) ) + "." + ALLTRIM (STR ( GetDatePickDay ( c ) ) )
      retval := ctod (d)
      Set (_SET_DATEFORMAT ,bd)
      set(2, bf )

   case T == "TIMEPICK"   // ( Dr. Claudio Soto, April 2013 )
      TimeValue24h := GETTIMEPICK (c)
      IF TimeValue24h [1] == -1   // Not Valid Time or Disable checkbox (SHOWNONE)
         retval := ""
      ELSE
         // retval := STRZERO (TimeValue24h [1], 2) +":"+ STRZERO (TimeValue24h [2], 2) +":"+ STRZERO (TimeValue24h [3], 2)
         cTimeFormat := ControlByIndex( IX ):CTRL009
         retval := HMG_ValueToTime (TimeValue24h, cTimeFormat)
      ENDIF

   case T == "SLIDER"

      retval := SendMessage( c, TBM_GETPOS, 0, 0)

   case T == "MULTILIST"

      retval := ListBoxGetMultiSel (c)

   case T == "MULTIGRID"

      retval := ListViewGetMultiSel (c)

   case T == "TOOLBUTTON"
      #ifdef _NEW_MethodToolButtonChecked_
         retval := IsToolButtonChecked( ControlByIndex( IX ):CTRL026 ,  NIL , ControlByIndex( IX ):CTRL005 ) // ADD
      #else
         retval := IsToolButtonChecked( ControlByIndex( IX ):CTRL026  , ControlByIndex( IX ):CTRL008 - 1)
      #endif

   endcase

   Return (retval)

Function _SetValue ( ControlName, ParentForm, Value , index )

   Local retval , h , t , x , c, y, r ,controlcount , backrec , workarea , rcount , aPos
   Local TreeItemHandle := 0 , ix
   Local z
   Local aTemp
   Local lEqual
   Local xPreviousValue
   Local TimeValue24h
   LOCAL i, cText

   controlcount := oHmgApp():ControlCount
   retval := 0
   r = 0

   if pcount() == 3

      ix = GetControlIndex (ControlName,ParentForm)

      t = ControlByIndex( ix ):Type
      h = ControlByIndex( IX ):ParentFormHandle
      c = ControlByIndex( ix ):Handle

   Else

      t = ControlByIndex( Index ):Type
      h = ControlByIndex( INDEX ):ParentFormHandle
      c = ControlByIndex( Index ):Handle
      ix = index

   EndIf

   If ValType( Value ) == 'A'

      aTemp := _GetValue ( , , ix )

      If ValType ( aTemp ) == 'A'

         If HMG_LEN( aTemp ) == HMG_LEN( Value )

            lEqual  := .T.

            For z := 1 To HMG_LEN ( Value )
               If ValType(aTemp [z]) == ValType(Value [z])
                  If aTemp [z] <> Value [z]
                     lEqual := .F.
                     Exit
                  EndIf
               Else
                  lEqual := .F.
                  Exit
               EndIf
            Next z

            If lEqual == .T.
               Return Nil
            EndIf

         EndIf

      EndIf

   Else
      IF T <> "TREE"  // ADD

         xPreviousValue := _GetValue ( , , ix )
         If ValType ( xPreviousValue ) == ValType ( Value )
            If xPreviousValue == value
               Return Nil
            EndIf
         EndIf

      ENDIF
   EndIf

   do case

#ifdef COMPILEBROWSE

   case T == "BROWSE"

      _BrowseSetValue ( '' , '' , value , ix )

#endif

   case T == "IPADDRESS"

      If HMG_LEN( Value ) == 0
         ClearIpAddress( c )
      Else
         SetIPAddress( c , Value[1],Value[2],Value[3],Value[4] )
      EndIf

   case T == "MONTHCAL"

      SetMonthCal( c ,year(value), month(value), day(value) )

      _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

   case T == "TREE"

      if ControlByIndex( IX ):CTRL009 == .F.
         If Value > TreeView_GetCount ( c ) .OR. Value <  1
            MsgHMGError ("Value Property: Invalid TreeItem Reference (nPos). Program Terminated")
         Endif

         TreeItemHandle :=  ControlByIndex( IX ):CTRL007 [ Value ]
      Else
         aPos := ASCAN ( ControlByIndex( IX ):CTRL025 , Value )
         If aPos == 0
            MsgHMGError ("Value Property: Invalid TreeItem Reference (nID). Program Terminated")
         EndIf

         TreeItemHandle :=  ControlByIndex( IX ):CTRL007 [ aPos ]
      EndIf

      TreeView_SelectItem ( c , TreeItemHandle )


   case T == "MASKEDTEXT"

      If GetFocus() == c
         SetWindowText ( ControlByIndex( ix ):Handle , Transform ( Value , ControlByIndex( IX ):CTRL009 ) )
      Else
         SetWindowText ( ControlByIndex( ix ):Handle , Transform ( value , ControlByIndex( IX ):CTRL007) )
      EndIf

   case T == "TIMER"

        KillTimer ( ControlByIndex( IX ):ParentFormHandle , ControlByIndex( IX ):CTRL005 )
        ControlByIndex( IX ):CTRL008 := Value

        for x := 1 to ControlCount
           if ControlByIndex( X ):CTRL005 == ControlByIndex( IX ):CTRL005
                InitTimer ( GetFormHandle(ParentForm) , ControlByIndex( IX ):CTRL005 , ControlByIndex( IX ):CTRL008 )
                exit
            endif
        next x


    case T == "LABEL"

        IF ValType( value ) <> "C"   // ADD October 2015
           IF ValType( value ) == "A"
               cText := ""
               FOR i = 1 TO HMG_LEN( value )
                  cText := cText + hb_ValToStr( value [i] )
               NEXT
            ELSE
               cText := hb_ValToStr( value )
            ENDIF
            value := cText
        ENDIF

        if ControlByIndex( IX ):CTRL022 == 1
            _SetControlWidth ( ControlName , ParentForm , GetTextWidth( NIL, Value , ControlByIndex( IX ):CTRL036 ) )
            _SetControlHeight ( ControlName , ParentForm , ControlByIndex( IX ):CTRL028 + 16 )
        EndIf

        SetWindowText ( c , value )

        if ValType ( ControlByIndex( IX ):CTRL009 ) == 'L'
            If ControlByIndex( IX ):CTRL009 == .T.
                RedrawWindowControlRect( h , ControlByIndex( IX ):CTRL018 , ControlByIndex( IX ):CTRL019 , ControlByIndex( IX ):CTRL018 + ControlByIndex( IX ):CTRL021 , ControlByIndex( IX ):CTRL019 + ControlByIndex( IX ):CTRL020 )
            EndIf
        else
           RedrawWindow (c)   // ADD  May 2015
        EndIf


    case T == "TEXT" .or. T == "EDIT" .or. T == "CHARMASKTEXT"  .or. T == "RICHEDIT"

        if t == "CHARMASKTEXT"
            if valtype ( ControlByIndex( IX ):CTRL017 ) == 'L'
                if ControlByIndex( IX ):CTRL017 == .T.
                    SetWindowText ( c , RTRIM(dtoc(value)) )
                Else
                    SetWindowText ( c , RTRIM(value) )
                endif
            Else
                SetWindowText ( c , RTRIM(value) )
            endif
        Else
            SetWindowText ( c , RTRIM(value) )
        endif

        if T == "EDIT"

            _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

        endif

    case T == "NUMTEXT"

        SetWindowText ( c , ALLTRIM(STR(value)) )

    case T == "SPINNER"
        SetSpinnerValue ( c [2] , Value )

    case T == "CHECKBOX"
        if value = .t.
                    SendMessage( c , BM_SETCHECK  , BST_CHECKED , 0 )
        else
                    SendMessage( c , BM_SETCHECK  , BST_UNCHECKED , 0 )
        endif

        _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

    case T == "RADIOGROUP"

        for x = 1 to HMG_LEN (c)
                    SendMessage( c[x] , BM_SETCHECK  , BST_UNCHECKED , 0 )
        next x

                SendMessage( c[value] , BM_SETCHECK  , BST_CHECKED , 0 )

        if ControlByIndex( IX ):CTRL025 == .F. .and. IsTabStop( c[value] )
            SetTabStop( c[value] , .f. )
        endif

        _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

    case T == "COMBO"

        If ValType ( Value ) != 'N'
            MsgHMGError('COMBOBOX: Value property wrong type (only numeric allowed). Program terminated')
        EndIf

        If ValType ( ControlByIndex( IX ):CTRL022 ) == 'C'
            ControlByIndex( IX ):CTRL008 := value
            WorkArea := ControlByIndex( IX ):CTRL022
                rcount := 0
            BackRec := (WorkArea)->(RecNo())
            (WorkArea)->(DBGoTop())
            Do While ! (WorkArea)->(Eof())
                rcount++
                    if value == (WorkArea)->(RecNo())
                    Exit
                EndIf
                (WorkArea)->(DBSkip())
            EndDo
            (WorkArea)->(DBGoTo(BackRec))
            ComboSetCurSel ( c ,rcount)
        Else
            ComboSetCursel ( c , value )
        EndIf

        _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

    case T == "LIST"
        ListBoxSetCursel ( c , value )
        _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )
    case T == "GRID"

        IF ControlByIndex( IX ):CTRL032 == .F.

            ListView_SetCursel ( c, value )
            ListView_EnsureVisible( C , VALUE )

        ELSE

            IF VALTYPE ( VALUE ) == 'A'
/*
                IF VALUE [1] == 0 .OR. VALUE [2] == 0   // Remove, April 2016

                    ControlByIndex( IX ):CTRL039 := 0
                    ControlByIndex( IX ):CTRL015 := 0

                    RedrawWindow( c )

                    _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

                ELSE
*/
//                    IF  ControlByIndex( IX ):CTRL039 <> value [1]   .OR.   ControlByIndex( IX ):CTRL015 <> value [2]   // Remove, April 2016

                        ControlByIndex( IX ):CTRL039 := value [1]
                        ControlByIndex( IX ):CTRL015 := value [2]

                        GRID_CheckRowCol( ix )   // ADD, April 2016

                        ListView_SetCursel ( c, ControlByIndex( IX ):CTRL039 )
                        ListView_EnsureVisible( c , ControlByIndex( IX ):CTRL039 )

                        IF ControlByIndex( IX ):CTRL039 <> value [1]   .OR.   ControlByIndex( IX ):CTRL015 <> value [2]   // ADD, April 2016
                           _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )
                        ENDIF

                        RedrawWindow ( ControlByIndex( IX ):Handle )

//                    ENDIF

//                ENDIF

            ENDIF

        ENDIF

    case T == "TAB"
        TABCTRL_SETCURSEL ( c , value )

        y := GetControlIndex (ControlName , ParentForm )

        UpdateTab (y)

        _DoControlEventProcedure ( ControlByIndex( Y ):CTRL012 , y )

    case T == "DATEPICK"
        If Empty (Value)
            SetDatePickNull(c)
        Else
            SetDatePick( c ,year(value), month(value), day(value) )
        EndIf
        _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )

    case T == "TIMEPICK"   //   ( Dr. Claudio Soto, April 2013 )
         If Empty (Value)
            SetTimePick (c, -1, -1, -1)   // Set Current Time
         Else
            TimeValue24h := HMG_TimeToValue (Value)
            SetTimePick (c, TimeValue24h [1], TimeValue24h [2], TimeValue24h [3])
         EndIf
         _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )   // On Change

    case T == "PROGRESSBAR"
        SendMessage(c, PBM_SETPOS,value,0)
    case T == "SLIDER"
        SendMessage( c , TBM_SETPOS ,1,  value )
        _DoControlEventProcedure ( ControlByIndex( IX ):CTRL012 , ix )
    case T == "STATUS"
            SetStatus( C , value )
    case T == "MULTILIST"
        LISTBOXSETMULTISEL ( c , value )
    case T == "MULTIGRID"
        LISTVIEWSETMULTISEL ( c , value )

        If HMG_LEN (value) > 0
            ListView_EnsureVisible( C , VALUE [1] )
        EndIf

    case T == "TOOLBUTTON"
         #ifdef _NEW_MethodToolButtonChecked_
            CheckToolButton( ControlByIndex( IX ):CTRL026  , NIL , value , ControlByIndex( IX ):CTRL005 ) // ADD
         #else
            CheckToolButton( ControlByIndex( IX ):CTRL026  , ControlByIndex( IX ):CTRL008 - 1 , value )
         #endif

endcase
Return (retval)


PROCEDURE GRID_CheckRowCol( ix )   // ADD, April 2016
LOCAL hWnd := ControlByIndex( IX ):Handle

   // nRow cellnavigation
   IF ListView_GetItemCount( hWnd ) == 0
      ControlByIndex( IX ):CTRL039 := 0
   ELSEIF ControlByIndex( IX ):CTRL039 <= 0
      ControlByIndex( IX ):CTRL039 := 1
   ELSEIF ControlByIndex( IX ):CTRL039 > ListView_GetItemCount( hWnd )
      ControlByIndex( IX ):CTRL039 := ListView_GetItemCount( hWnd )
   ENDIF

   // nCol cellnavigation
   IF ListView_GetColumnCount( hWnd ) == 0
      ControlByIndex( IX ):CTRL015 := 0
   ELSEIF ControlByIndex( IX ):CTRL015 <= 0
      ControlByIndex( IX ):CTRL015 := 1
   ELSEIF ControlByIndex( IX ):CTRL015 > ListView_GetColumnCount( hWnd )
      ControlByIndex( IX ):CTRL015 := ListView_GetColumnCount( hWnd )
   ENDIF

RETURN





Function _AddItem ( ControlName, ParentForm, Value , Parent, aImage , Id )
Local t , c , NewHandle , TempHandle , i , ix , aPos , ChildHandle , BackHandle , ParentHandle
Local TreeItemHandle // Tree+
Local ImgDef, iUnSel, iSel

ix := GetControlIndex (ControlName , ParentForm )

T = ControlByIndex( ix ):Type

c = ControlByIndex( ix ):Handle

If ValType ( Id ) == 'U'
    Id := 0
EndIf

If ValType ( aImage ) == 'N'
    Id := aImage
EndIf

do case
    case T == "TREE"

        if ControlByIndex( IX ):CTRL009 == .F.

            If Parent > TreeView_GetCount ( c ) .or. Parent < 0
                MsgHMGError ("Additem Method:  Invalid Parent Value. Program Terminated" )
            EndIf

        EndIf

        ImgDef := iif( valtype( aImage ) == "A" , HMG_LEN( aImage ), 0 )  //Tree+

        if Parent != 0

            if ControlByIndex( IX ):CTRL009 == .F.
                TreeItemHandle := ControlByIndex( IX ):CTRL007 [ Parent ]
            Else
                aPos := ascan ( ControlByIndex( IX ):CTRL025 , Parent )

                If aPos == 0
                    MsgHMGError ("Additem Method: Invalid Parent Value. Program Terminated" )
                EndIf

                TreeItemHandle := ControlByIndex( IX ):CTRL007 [ aPos ]

            EndIf

            if ImgDef == 0

                iUnsel := 2 // Pointer to defalut Node Bitmaps, no Bitmap loaded
                iSel   := 3
            else
                iUnSel := AddTreeViewBitmap( c, aImage[1], ControlByIndex( IX ):CTRL039 ) -1
                iSel   := iif( ImgDef == 1, iUnSel, AddTreeViewBitmap( c, aImage[2], ControlByIndex( IX ):CTRL039 ) -1 )
                // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
            endif

            NewHandle := AddTreeItem ( c , TreeItemHandle , Value, iUnsel, iSel , Id , _IS_TREE_ITEM_ )

                        * Determine Position of New Item

            TempHandle := TreeView_GetChild ( c , TreeItemHandle )

            i := 0

            Do While .t.

                i++

                If TempHandle == NewHandle
                    Exit
                EndIf

                ChildHandle := TreeView_GetChild ( c , TempHandle )

                If ChildHandle == 0
                    BackHandle := TempHandle
                    TempHandle := TreeView_GetNextSibling ( c , TempHandle )
                Else
                    i++
                    BackHandle := Childhandle
                    TempHandle := TreeView_GetNextSibling ( c , ChildHandle )
                EndIf

                Do While TempHandle == 0

                    ParentHandle := TreeView_GetParent ( c , BackHandle )

                    TempHandle := TreeView_GetNextSibling ( c , ParentHandle )

                    If TempHandle == 0
                        BackHandle := ParentHandle
                    EndIf

                EndDo

            EndDo

            * Resize Array

            aSize ( ControlByIndex( IX ):CTRL007 , TreeView_GetCount ( c ) )   // nTreeItemHandle
            aSize ( ControlByIndex( IX ):CTRL025 , TreeView_GetCount ( c ) )   // nID
            aSize ( ControlByIndex( IX ):CTRL032 , TreeView_GetCount ( c ) )   // cargo

            * Insert New Element

            if ControlByIndex( IX ):CTRL009 == .F.
                aIns ( ControlByIndex( IX ):CTRL007 , Parent + i  )   // nTreeItemHandle
                aIns ( ControlByIndex( IX ):CTRL025 , Parent + i  )   // nID
                aIns ( ControlByIndex( IX ):CTRL032 , Parent + i  )   // cargo
            Else
                aIns ( ControlByIndex( IX ):CTRL007 , aPos + i )   // nTreeItemHandle
                aIns ( ControlByIndex( IX ):CTRL025 , aPos + i )   // nID
                aIns ( ControlByIndex( IX ):CTRL032 , aPos + i )   // cargo
            EndIf

            * Assign Handle

            if ControlByIndex( IX ):CTRL009 == .F.
                ControlByIndex( IX ):CTRL007 [ Parent + i ] := NewHandle
                ControlByIndex( IX ):CTRL025 [ Parent + i ] := Id
                ControlByIndex( IX ):CTRL032 [ Parent + i ] := NIL   // cargo
            Else

                If ascan ( ControlByIndex( IX ):CTRL025 , Id ) != 0
                    MsgHMGError ("Additem Method:  Item Id "+ALLTRIM(STR(Id))+" Already In Use. Program Terminated" )
                EndIf

                ControlByIndex( IX ):CTRL007 [ aPos + i ] := NewHandle
                ControlByIndex( IX ):CTRL025 [ aPos + i ] := Id
                ControlByIndex( IX ):CTRL032 [ aPos + i ] := NIL   // cargo

            EndIf

        Else
            TreeItemHandle := 0

            if ImgDef == 0

                iUnsel := 0 // Pointer to defalut Node Bitmaps, no Bitmap loaded
                iSel   := 1
            else
                iUnSel := AddTreeViewBitmap( c, aImage[1], ControlByIndex( IX ):CTRL039 ) -1
                iSel   := iif( ImgDef == 1, iUnSel, AddTreeViewBitmap( c, aImage[2], ControlByIndex( IX ):CTRL039 ) -1 )
                // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
            endif

            NewHandle := AddTreeItem ( c , 0 , Value, iUnsel, iSel , Id, _IS_TREE_ITEM_ )

            if ControlByIndex( IX ):CTRL009 == .T.
                If ascan ( ControlByIndex( IX ):CTRL025 , Id ) != 0
                    MsgHMGError ("Additem Method:  Item Id Already In Use. Program Terminated" )
                EndIf
            EndIf

            aadd ( ControlByIndex( IX ):CTRL007 , NewHandle )   // nTreeItemHandle
            aadd ( ControlByIndex( IX ):CTRL025 , Id        )   // nID
            aadd ( ControlByIndex( IX ):CTRL032 , NIL       )   // cargo

        EndIf

    case T == "COMBO"

        If ValType ( Value ) == 'A'
            ImageComboAddItem ( c , value[1] , value[2] , -1 )
        Else
            ComboAddString ( c , value )
        EndIf

    case T == "LIST" .or. T == "MULTILIST"
        ListBoxAddstring ( c , value )

    case T == "GRID" .or. T == "MULTIGRID"

        IF ControlByIndex( IX ):CTRL040 [ 9 ] == .F.   // OWNERDATA
                _AddGridRow ( ControlName, ParentForm, value )
        ENDIF

endcase
Return Nil

Function _DeleteItem ( ControlName, ParentForm, Value )
Local t , c , BeforeCount , AfterCount , DeletedCount , i , ix , aPos
Local TreeItemHandle

ix := GetControlIndex (ControlName,ParentForm)

T = ControlByIndex( ix ):Type
c = ControlByIndex( ix ):Handle

do case
    case T == "TREE"

        BeforeCount := TreeView_GetCount ( c )

        if ControlByIndex( IX ):CTRL009 == .F.   // ITEMIDS == .F.

            If Value > BeforeCount .or. Value < 1
                MsgHMGError ("DeleteItem Method: Invalid Item Specified. Program Terminated" )
            EndIf

            TreeItemHandle := ControlByIndex( IX ):CTRL007 [ Value ]   // nTreeItemHandle
            DELETETREEITEM ( c , TreeItemHandle )

        Else

            aPos := ascan ( ControlByIndex( IX ):CTRL025 , Value )   // nID

            If aPos == 0
                MsgHMGError ("DeleteItem Method: Invalid Item Id. Program Terminated" )
            EndIf

            TreeItemHandle := ControlByIndex( IX ):CTRL007 [ aPos ]   // nTreeItemHandle
            DELETETREEITEM ( c , TreeItemHandle )

        EndIf

        AfterCount := TreeView_GetCount ( c )

        DeletedCount := BeforeCount - AfterCount

        if ControlByIndex( IX ):CTRL009 == .F.   // ITEMIDS == .F.

               For i := 1 To DeletedCount
                    Adel ( ControlByIndex( IX ):CTRL007 , Value )   // nTreeItemHandle
                    Adel ( ControlByIndex( IX ):CTRL032 , Value )   // cargo
                Next i

        Else
                For i := 1 To DeletedCount
                    Adel ( ControlByIndex( IX ):CTRL007 , aPos )   // nTreeItemHandle
                    Adel ( ControlByIndex( IX ):CTRL025 , aPos )   // nID
                    Adel ( ControlByIndex( IX ):CTRL032 , aPos )   // cargo
                Next i

        EndIf

        aSize ( ControlByIndex( IX ):CTRL007 , AfterCount )   // nTreeItemHandle
        aSize ( ControlByIndex( IX ):CTRL025 , AfterCount )   // nID
        aSize ( ControlByIndex( IX ):CTRL032 , AfterCount )   // cargo

    case T == "LIST" .OR. T == "MULTILIST"
        ListBoxDeleteString ( c , value )
    case T == "COMBO"
        ComboBoxDeleteString ( c , value )
        RedrawWindow( c )
    case T == "GRID" .OR. T == "MULTIGRID"

        IF ControlByIndex( IX ):CTRL040 [ 9 ] == .F.   // OWNERDATA

            IF ControlByIndex( IX ):CTRL032 == .T. .AND. T == "GRID"   // cellnavigation
/*
               IF ControlByIndex( IX ):CTRL039 < value

                    ListViewDeleteString ( c , value )

               ELSEIF ControlByIndex( IX ):CTRL039 == value   // nRow cellnavigation

                    ListViewDeleteString ( c , value )


                   _SetValue( NIL, NIL, { value, ControlByIndex( IX ):CTRL015 } , ix )   // ADD, April 2016

                   // ControlByIndex( IX ):CTRL039 := 0   // nRow cellnavigation    Remove, April 2016
                   // ControlByIndex( IX ):CTRL015 := 0   // nCol cellnavigation    Remove, April 2016

                ELSEIF  ControlByIndex( IX ):CTRL039 > value

                    ListViewDeleteString ( c , value )

                    ControlByIndex( IX ):CTRL039 --   // nRow cellnavigation

                ENDIF
*/

ListViewDeleteString ( c , value )
ControlByIndex( IX ):CTRL039 := LISTVIEW_GETFOCUSEDITEM ( c )   // ADD, April 2016

            ELSE

                    ListViewDeleteString ( c , value )

            ENDIF

        ENDIF

endcase
Return Nil

Function _DeleteAllItems ( ControlName, ParentForm )
Local t , c , i

i = GetControlIndex (ControlName,ParentForm)

T = ControlByIndex( i ):Type
c = ControlByIndex( i ):Handle

do case

    case T == "TREE"
        DELETEALLTREEITEMS ( c , ControlByIndex( I ):CTRL007)
        aSize ( ControlByIndex( I ):CTRL007, 0 )   // nTreeItemHandle
        aSize ( ControlByIndex( I ):CTRL025, 0 )   // nID
        ASIZE ( ControlByIndex( I ):CTRL032, 0 )   // cargo

    case T == "LIST" .OR. T == "MULTILIST"
        ListBoxReset ( c )
    case T == "COMBO"
        ComboBoxReset ( c )
    case T == "GRID" .OR. T == "MULTIGRID"

        IF ControlByIndex( I ):CTRL040 [ 9 ] == .F.

            ListViewReset ( c )

            IF ControlByIndex( I ):CTRL032 == .T. .AND. T == "GRID"
                ControlByIndex( I ):CTRL015 := 0
                ControlByIndex( I ):CTRL039 := 0
            ENDIF


        ENDIF

endcase
Return Nil

Function GetControlIndex (ControlName,ParentForm)
Local mVar
mVar := '_' + ParentForm + '_' + ControlName
Return ( &mVar )

Function GetControlName (ControlName,ParentForm)

   Local mVar , i

   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   if i == 0
       Return ''
   EndIf

   Return ControlByIndex( &mVar ):Name

Function GetControlHandle (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
If i == 0
  Return 0
EndIf
Return ControlByIndex( &mVar ):Handle

Function GetControlContainerHandle (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return 0
EndIf
Return (ControlByIndex( &MVAR ):CTRL026 )

Function GetControlParentHandle (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return 0
EndIf
Return ControlByIndex( &MVAR ):ParentFormHandle

Function GetControlId (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return 0
EndIf
Return (ControlByIndex( &MVAR ):CTRL005 )

Function GetControlType (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return ''
EndIf
Return ControlByIndex( &mVar ):Type

Function GetControlValue (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return Nil
EndIf
Return (ControlByIndex( &MVAR ):CTRL008 )

Function GetControlPageMap (ControlName,ParentForm)
Local mVar , i
mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return {}
EndIf
Return (ControlByIndex( &MVAR ):CTRL007 )


Function _IsControlDefined ( ControlName , FormName )
Local mVar , i , r

   ControlName := CharRem ( CHR(34)+CHR(39), ControlName )
   FormName    := CharRem ( CHR(34)+CHR(39), FormName )

   mVar := '_' + FormName + '_' + ControlName

   if type ( mVar ) = 'U'
      Return (.F.)
   EndIf
   if type ( mVar ) = 'N'
      i := &mVar
      if i == 0
         Return .f.
      EndIf
      r :=  ControlByIndex( I ):IsDeleted
      r := .Not. r
      Return (r)
   EndIf
Return .F.


Function _SetFocus ( ControlName , ParentForm , ix )
Local H , T , MaskStart , X , i , j , L , F

if pcount() == 2
    i := GetControlIndex ( ControlName,ParentForm )
    H = GetControlHandle( ControlName , ParentForm )
    T = GetControlType (ControlName,ParentForm)
else
    i := ix
    H := ControlByIndex( IX ):Handle
    T := ControlByIndex( IX ):Type
endif


DO CASE

    CASE T == 'TEXT' .Or. T == 'NUMTEXT' .Or. T == 'MASKEDTEXT'
        setfocus( H )
        SendMessage ( H , 177 , 0 , -1 ) // EM_SETSEL

    CASE T == "CHARMASKTEXT"

        setfocus( H )

        For x := 1 To HMG_LEN (ControlByIndex( I ):CTRL009)
            If HMG_ISDIGIT(HB_USUBSTR ( ControlByIndex( I ):CTRL009 , x , 1 )) .Or. HMG_ISALPHA(HB_USUBSTR ( ControlByIndex( I ):CTRL009 , x , 1 )) .Or. HB_USUBSTR ( ControlByIndex( I ):CTRL009 , x , 1 ) == '!'
                MaskStart := x
                Exit
            EndIf
        Next x

        If MaskStart == 1
                SendMessage( H , EM_SETSEL , 0 , -1 )
        Else
                SendMessage( H , EM_SETSEL , MaskStart - 1 , -1 )
        EndIf

    CASE T == 'BUTTON'

        IF ControlByIndex( I ):CTRL038 == .T.

            L := oHmgApp():ControlCount

            *F := GetFormHandle( ParentForm )

            F := ControlByIndex( I ):ParentFormHandle

            FOR J := 1 TO L

                If ControlByIndex( J ):Type == 'BUTTON'

                    IF ControlByIndex( J ):ParentFormHandle == F

                        SendMessage  ( ControlByIndex( J ):Handle , BM_SETSTYLE , LOWORD ( BS_PUSHBUTTON ) , 1 )
                        RedrawWindow ( ControlByIndex( J ):Handle )

                    ENDIF

                ENDIF

            NEXT

            setfocus( H )
            SendMessage ( H , BM_SETSTYLE , LOWORD ( BS_DEFPUSHBUTTON ) , 1 )

        ENDIF

    CASE T == 'SPINNER'
        setfocus( H [1] )
    CASE T == 'RADIO'
        setfocus( H [1] )
    OTHERWISE
        setfocus( H )
ENDCASE
oHmgApp():APP251 := .T.
Return Nil

Function _DisableControl ( ControlName , ParentForm )
Local H, T, i, c, y, s, z, w

T := GetControlType (ControlName,ParentForm)
i := GetControlId (ControlName,ParentForm)
h := GetControlParentHandle (ControlName,ParentForm)
c := GetControlHandle (ControlName,ParentForm)
y := GetControlIndex (ControlName,ParentForm)

DO CASE

    #ifdef COMPILEBROWSE

    CASE T == "BROWSE"
        DisableWindow ( c )
        If ControlByIndex( Y ):CTRL005 != 0
            DisableWindow ( ControlByIndex( Y ):CTRL005 )
        EndIf

    #endif

    CASE T == "TOOLBUTTON"
        _DisableToolBarButton ( ControlName , ParentForm )

    CASE T == "MENU" .OR. T == "POPUP"
        _DisableMenuItem ( ControlName , ParentForm )

    CASE T == "TIMER"
        KillTimer ( h , i )

    CASE T == "SPINNER"
        DisableWindow ( c [1] )
        DisableWindow ( c [2] )

    CASE T == "RADIOGROUP"
        For i := 1 To HMG_LEN (c)
            DisableWindow ( c [i] )
        Next i

    CASE T == "TAB"

        DisableWindow ( c )

        s = TabCtrl_GetCurSel ( ControlByIndex( Y ):Handle )
        for w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [s])
            if valtype (ControlByIndex( Y ):CTRL007 [s] [w]) <> "A"
                DisableWindow ( ControlByIndex( Y ):CTRL007 [s] [w] )
            else
                for z = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 [s] [w] )
                    DisableWindow ( ControlByIndex( Y ):CTRL007 [s] [w] [z] )
                next z
            endif
        Next w

    CASE T == "BUTTON"

        if ControlByIndex( Y ):CTRL038 == .T.

            SendMessage  ( c , BM_SETSTYLE , LOWORD ( BS_PUSHBUTTON ) , 1 )
            RedrawWindow ( c )

            IF ControlByIndex( Y ):CTRL022 == 'T'

                DisableWindow ( c )

            ELSE

                if  (ControlByIndex( Y ):CTRL022 == 'M')  .OR. (ControlByIndex( Y ):CTRL022 == 'I' .AND.  IsAppThemed())

                     IMAGELIST_DESTROY ( ControlByIndex( Y ):CTRL037 )
                     ControlByIndex( Y ):CTRL037 := _SetMixedBtnPicture ( ControlByIndex( Y ):Handle, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL026, ControlByIndex( Y ):CTRL032, _SET_BITMAP_GRAY )

                     // _SetMixedBtnPictureDisabled ()

                    RedrawWindow (c)
                    DisableWindow ( c )

                else

                    // NewHandle := GetDisabledBitmap( ControlByIndex( Y ):CTRL037, ControlByIndex( Y ):CTRL039 )

                    DeleteObject (ControlByIndex( Y ):CTRL037)
                    ControlByIndex( Y ):CTRL037 := _SETBTNPICTURE ( ControlByIndex( Y ):Handle, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL032, _SET_BITMAP_GRAY )

                    RedrawWindow (c)
                    DisableWindow ( c )

                endif

            ENDIF

        EndIf

    CASE T == "CHECKBOX"   // CHECKBUTTON ???

        if ControlByIndex( Y ):CTRL038 == .T.

            if  ControlByIndex( Y ):CTRL039 == 1

                if IsAppThemed()

                   IMAGELIST_DESTROY ( ControlByIndex( Y ):CTRL037 )
                   ControlByIndex( Y ):CTRL037 := _SetMixedBtnPicture ( ControlByIndex( Y ):Handle, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL026, ControlByIndex( Y ):CTRL032, _SET_BITMAP_GRAY )

                  //  _SetMixedBtnPictureDisabled ()

                    RedrawWindow (c)
                    DisableWindow ( c )

                else

                    //  NewHandle := GetDisabledBitmap ( ControlByIndex( Y ):CTRL037 , .F. )

                    DeleteObject (ControlByIndex( Y ):CTRL037)
                    ControlByIndex( Y ):CTRL037 := _SETBTNPICTURE ( ControlByIndex( Y ):Handle, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL032, _SET_BITMAP_GRAY )

                    RedrawWindow (c)
                    DisableWindow ( c )

                endif

            else

                DisableWindow ( c )

            endif

        EndIf

OTHERWISE
    DisableWindow ( c )
ENDCASE
ControlByIndex( Y ):CTRL038 := .F.
Return Nil

Function _EnableControl ( ControlName,ParentForm )
Local H,t,i,c,x,controlcount , y , s , z , w

controlcount := oHmgApp():ControlCount()

T = GetControlType (ControlName,ParentForm)
i = GetControlId (ControlName,ParentForm)
h = GetControlParentHandle (ControlName,ParentForm)
c = GetControlHandle (ControlName,ParentForm)
y := GetControlIndex (ControlName,ParentForm)


DO CASE

    #ifdef COMPILEBROWSE

    CASE T == "BROWSE"
        EnableWindow ( c )
        If ControlByIndex( Y ):CTRL005 != 0
            EnableWindow ( ControlByIndex( Y ):CTRL005 )
        EndIf

    #endif

    CASE T == "TOOLBUTTON"
        _EnableToolBarButton ( ControlName , ParentForm )
    CASE T == "MENU" .OR. T == "POPUP"
        _EnableMenuItem ( ControlName , ParentForm )

    CASE T == "TIMER"
        for x :=1 to controlcount
                if ControlByIndex( X ):CTRL005 == i
                InitTimer ( GetFormHandle(ParentForm) , ControlByIndex( X ):CTRL005 , ControlByIndex( X ):CTRL008 )
                exit
            endif
        next x
    CASE T == "SPINNER"
        EnableWindow ( c [1] )
        EnableWindow ( c [2] )
    CASE T == "RADIOGROUP"
        For i := 1 To HMG_LEN (c)
            EnableWindow ( c [i] )
        Next i

    CASE T == "TAB"

        EnableWindow ( c )

        s = TabCtrl_GetCurSel ( ControlByIndex( Y ):Handle )
        for w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [s])
            if valtype (ControlByIndex( Y ):CTRL007 [s] [w]) <> "A"
                EnableWindow ( ControlByIndex( Y ):CTRL007 [s] [w] )
            else
                for z = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 [s] [w] )
                                EnableWindow ( ControlByIndex( Y ):CTRL007 [s] [w] [z] )
                next z
            endif
        Next w

    CASE T == "BUTTON"

        If ControlByIndex( Y ):CTRL038 == .F.

            IF  ControlByIndex( Y ):CTRL022 == 'T'

                EnableWindow( c )

            ELSE

                if  (ControlByIndex( Y ):CTRL022 == 'M') .OR. (ControlByIndex( Y ):CTRL022 == 'I' .AND. IsAppThemed())

                    IMAGELIST_DESTROY ( ControlByIndex( Y ):CTRL037 )
                    ControlByIndex( Y ):CTRL037 := _SetMixedBtnPicture ( ControlByIndex( Y ):Handle, ControlByIndex( Y ):CTRL025 , ControlByIndex( Y ):CTRL026, ControlByIndex( Y ):CTRL032, Nil )

                    ReDrawWindow ( ControlByIndex( Y ):Handle )
                    EnableWindow( c )

                else

                    EnableWindow( c )
                    DeleteObject ( ControlByIndex( Y ):CTRL037 )
                    ControlByIndex( Y ):CTRL037 := _SETBTNPICTURE ( c, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL032, Nil )

                endif

            ENDIF

        EndIf

    CASE T == "CHECKBOX"

        If ControlByIndex( Y ):CTRL038 == .F.

            if  ControlByIndex( Y ):CTRL039 == 1

                if IsAppThemed()

                    IMAGELIST_DESTROY ( ControlByIndex( Y ):CTRL037 )
                    ControlByIndex( Y ):CTRL037 := _SetMixedBtnPicture ( ControlByIndex( Y ):Handle, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL026, ControlByIndex( Y ):CTRL032, Nil )

                    RedrawWindow ( ControlByIndex( y ):Handle )
                    EnableWindow ( c )

                else

                    EnableWindow ( c )
                    DeleteObject ( ControlByIndex( Y ):CTRL037 )
                    ControlByIndex( Y ):CTRL037 := _SETBTNPICTURE ( c, ControlByIndex( Y ):CTRL025, ControlByIndex( Y ):CTRL032, Nil )

                endif

            else

                EnableWindow ( c )

            endif

        EndIf

OTHERWISE
    EnableWindow ( c )
ENDCASE
ControlByIndex( Y ):CTRL038 := .T.
Return Nil

Function _ShowControl ( ControlName,ParentForm )
Local t,i,c,w,s,y,z,r
Local TabHide := .f.

T = GetControlType (ControlName,ParentForm)

c = GetControlHandle (ControlName,ParentForm)

y := GetControlIndex (ControlName,ParentForm)

if ControlByIndex( Y ):CTRL034 == .t.
    Return Nil
EndIf

******************************************************************************
    // If the control is inside a TAB and the page is not visible,
    // the control must not be showed
******************************************************************************

For i := 1 To oHmgApp():ControlCount

    if ControlByIndex( i ):Type == "TAB"

        s = TabCtrl_GetCurSel (ControlByIndex( i ):Handle )

        for r = 1 to HMG_LEN ( ControlByIndex( I ):CTRL007 )

            for w = 1 to HMG_LEN (ControlByIndex( I ):CTRL007 [r])

                if t == 'RADIOGROUP'

                        if ValType (ControlByIndex( I ):CTRL007 [r] [w]) == 'A'

                        if ControlByIndex( I ):CTRL007 [r] [w] [1] == ControlByIndex( Y ):Handle[1]

                                if r != s
                                TabHide := .T.
                            EndIf

                            Exit

                        EndIf

                    EndIf

                Elseif t == 'SPINNER'

                        if ValType (ControlByIndex( I ):CTRL007 [r] [w]) == 'A'

                        if ControlByIndex( I ):CTRL007 [r] [w] [1] == ControlByIndex( Y ):Handle[1]

                                if r != s
                                TabHide := .T.
                            EndIf

                            Exit

                        EndIf

                    EndIf

                #ifdef COMPILEBROWSE

                Elseif t == 'BROWSE'

                        if ValType (ControlByIndex( I ):CTRL007 [r] [w]) == 'A'

                        if ControlByIndex( I ):CTRL007 [r] [w] [1] == ControlByIndex( Y ):Handle

                                if r != s
                                TabHide := .T.
                            EndIf

                            Exit

                        EndIf

                        Elseif ValType (ControlByIndex( I ):CTRL007 [r] [w]) == 'N'

                        if ControlByIndex( I ):CTRL007 [r] [w] == ControlByIndex( Y ):Handle

                                if r != s
                                TabHide := .T.
                            EndIf

                            Exit

                        EndIf

                    EndIf

                #endif

                Else

                        if ValType (ControlByIndex( I ):CTRL007 [r] [w]) == 'N'

                        if ControlByIndex( I ):CTRL007 [r] [w] == ControlByIndex( Y ):Handle

                                if r != s
                                TabHide := .T.
                            EndIf

                            Exit

                        EndIf

                    EndIf

                EndIf

            Next w

        next r

    EndIf

Next i

if TabHide == .T.
    ControlByIndex( Y ):CTRL034 := .t.
    Return Nil
EndIf

******************************************************************************

if T == "SPINNER"
    CShowControl ( c [1] )
    CShowControl ( c [2] )
    ControlByIndex( Y ):CTRL034 := .t.

#ifdef COMPILEBROWSE

ElseIf T == "BROWSE"
    CShowControl ( c )
    If ControlByIndex( Y ):CTRL005 != 0
        CShowControl ( ControlByIndex( Y ):CTRL005 )
    EndIf
    If ControlByIndex( Y ):CTRL039 [1] != 0
        CShowControl ( ControlByIndex( Y ):CTRL039 [1])
    EndIf
    ControlByIndex( Y ):CTRL034 := .t.

#endif

Elseif T == "TAB"

    CShowControl ( c )

    s = TabCtrl_GetCurSel ( ControlByIndex( Y ):Handle )
    for w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [s])
        if valtype (ControlByIndex( Y ):CTRL007 [s] [w]) <> "A"
            CShowControl ( ControlByIndex( Y ):CTRL007 [s] [w] )
        else
            for z = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 [s] [w] )
                            CShowControl ( ControlByIndex( Y ):CTRL007 [s] [w] [z] )
            next z
        endif
    Next w
    ControlByIndex( Y ):CTRL034 := .t.

Elseif T == "RADIOGROUP"

    For i:= 1 To HMG_LEN(c)

        CShowControl ( c [i] )

    Next i
    ControlByIndex( Y ):CTRL034 := .t.
Else
    CShowControl ( c )
    ControlByIndex( Y ):CTRL034 := .t.
EndIf
redrawwindow(c)
Return Nil

Function _HideControl ( ControlName,ParentForm )
Local t,c,i,y,r,w,z

T = GetControlType (ControlName,ParentForm)

c = GetControlHandle (ControlName,ParentForm)

y := GetControlIndex (ControlName,ParentForm)

if T == "SPINNER"
    HideWindow ( c [1] )
    HideWindow ( c [2] )
    ControlByIndex( Y ):CTRL034 := .f.

#ifdef COMPILEBROWSE

ElseIf T == "BROWSE"
    HideWindow ( c )
    If ControlByIndex( Y ):CTRL005 != 0
        HideWindow ( ControlByIndex( Y ):CTRL005 )
    EndIf
    If ControlByIndex( Y ):CTRL039 [1] != 0
        HideWindow ( ControlByIndex( Y ):CTRL039 [1])
    EndIf
    ControlByIndex( Y ):CTRL034 := .f.

#endif

Elseif T == "TAB"

    HideWindow ( c )

    for r = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 )
        for w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [r])
            if valtype ( ControlByIndex( Y ):CTRL007 [r] [w] ) <> "A"
                HideWindow ( ControlByIndex( Y ):CTRL007 [r] [w] )
                        else
                for z = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 [r] [w] )
                                        HideWindow ( ControlByIndex( Y ):CTRL007 [r] [w] [z] )
                Next z
            endif
        Next w
    Next r

    ControlByIndex( Y ):CTRL034 := .f.

Elseif T == "RADIOGROUP"

    For i:= 1 To HMG_LEN(c)

        HideWindow ( c [i] )

    Next i

    ControlByIndex( Y ):CTRL034 := .f.

Elseif T == "COMBO"

    SendMessage ( c , 335 , 0 , 0 )
    HideWindow ( c )
    ControlByIndex( Y ):CTRL034 := .f.

Else
    HideWindow ( c )
    ControlByIndex( Y ):CTRL034 := .f.
EndIf
Return Nil

Function _SetItem ( ControlName, ParentForm, Item , Value , index )
Local t , c , i , aPos, k
Local TreeHandle, ItemHandle
Local AEDITCONTROLS
Local CI
Local XRES
Local aTemp
Local AEC
Local CTYPE
Local CINPUTMASK
Local CFORMAT
Local AITEMS
Local ARANGE
Local DTYPE
Local ALABELS
Local bd
Local nCurrentValue

if pcount() == 5
    i = index
else
    i = GetControlIndex (ControlName,ParentForm)
endif

T = ControlByIndex( i ):Type
c = ControlByIndex( i ):Handle

do case
    case t == 'TREE'

        if ControlByIndex( I ):CTRL009 == .F.
            If Item > TreeView_GetCount ( c ) .or. Item < 1
                MsgHMGError ("Item Property: Invalid Item Reference. Program Terminated" )
            EndIf
        EndIf

        TreeHandle := c

        if ControlByIndex( I ):CTRL009 == .F.
            ItemHandle := ControlByIndex( I ):CTRL007 [ Item ]
        Else

            aPos := ascan ( ControlByIndex( I ):CTRL025 , Item )

            If aPos == 0
                MsgHMGError ("Item Property: Invalid Item Id. Program Terminated" )
            EndIf

            ItemHandle := ControlByIndex( I ):CTRL007 [ aPos ]

        EndIf

        TreeView_SetItem ( TreeHandle , ItemHandle , Value )

    case T == "LIST" .Or. T == "MULTILIST"
        nCurrentValue := ListBoxGetCursel ( c )
        ListBoxDeleteString ( c , Item )
        ListBoxInsertString ( c , value , Item )
        ListBoxSetCursel ( c , nCurrentValue )
    case T == "COMBO"
        If ValType ( Value ) == 'C'
            ComboBoxDeleteString ( c , Item )
            ComboInsertString ( c , value , Item )
        Else
            ComboBoxDeleteString ( c , Item )
            ImageComboAddItem ( c , Value[1] , Value[2] , Item - 1 )
        EndIf
    case T == "GRID" .OR. T == "MULTIGRID"

        IF ControlByIndex( I ):CTRL040 [ 9 ] == .F.

            AEDITCONTROLS := ControlByIndex( I ):CTRL040 [2]

            IF VALTYPE ( AEDITCONTROLS ) <> "A"

                aTemp := ACLONE( Value )
                FOR k := 1 TO HMG_LEN( aTemp )   // by Dr. Claudio Soto, April 2016
                   IF ValType( aTemp[ k ] ) <> "C"
                      aTemp[ k ] := hb_ValToStr( aTemp[ k ] )
                   ENDIF
                NEXT

                ListViewSetItem ( c , aTemp , Item )

            ELSE

                aTemp := ARRAY ( HMG_LEN ( VALUE ) )

                FOR CI := 1 TO HMG_LEN ( VALUE )

                    XRES := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , CI )

                    AEC     := XRES [1]
                    CTYPE       := HMG_UPPER( XRES [2] )
                    CINPUTMASK  := XRES [3]
                    CFORMAT     := XRES [4]
                    AITEMS      := XRES [5]
                    ARANGE      := XRES [6]
                    DTYPE       := XRES [7]
                    ALABELS     := XRES [8]

                    IF  AEC == 'TEXTBOX'
                        IF CTYPE == 'CHARACTER'
                            IF EMPTY ( CINPUTMASK )
                                aTemp [ci] := VALUE [CI]
                            ELSE
                                aTemp [ci] := TRANSFORM ( VALUE [CI] , CINPUTMASK )
                            ENDIF
                        ELSEIF CTYPE == 'NUMERIC'
                            IF EMPTY ( CINPUTMASK )
                                aTemp [ci] := STR ( VALUE [CI] )
                            ELSE
                                IF EMPTY ( CFORMAT )
                                    aTemp [ci] := TRANSFORM ( VALUE [CI] , CINPUTMASK )
                                ELSE
                                    aTemp [ci] := TRANSFORM ( VALUE [CI], '@' + CFORMAT + ' ' + CINPUTMASK )
                                ENDIF
                            ENDIF
                        ELSEIF CTYPE == 'DATE'
                            aTemp [ci] := DTOC ( VALUE [CI] )
                        ENDIF
                    ELSEIF  AEC == 'DATEPICKER'
                        bd = Set (_SET_DATEFORMAT )
                        SET CENTURY ON
                        aTemp [ci] := dtoc ( VALUE [CI] )
                        Set (_SET_DATEFORMAT ,bd)

               ELSEIF   AEC == 'TIMEPICKER'
                 // aTemp [ci] := VALUE [CI]
                    aTemp [ci] := HMG_TimeToTime (VALUE [CI], CFORMAT)

               ELSEIF   AEC == 'EDITBOX'        // Pablo, February 2015
                    aTemp [ci] := VALUE [CI]


                    ELSEIF  AEC == 'COMBOBOX'
                        IF VALUE [CI] == 0
                            aTemp [ci] := ''
                        ELSE
                            aTemp [ci] := AITEMS [ VALUE [CI] ]
                         ENDIF
                    ELSEIF  AEC == 'SPINNER'
                        aTemp [ci] := STR ( VALUE [CI] )
                    ELSEIF  AEC == 'CHECKBOX'
                        IF VALUE [CI] == .T.
                            aTemp [ci] := ALABELS [1]
                        ELSE
                            aTemp [ci] := ALABELS [2]
                        ENDIF
                    ENDIF

                    NEXT CI

                FOR k := 1 TO HMG_LEN( aTemp )   // by Dr. Claudio Soto, April 2016
                   IF ValType( aTemp[ k ] ) <> "C"
                      aTemp[ k ] := hb_ValToStr( aTemp[ k ] )
                   ENDIF
                NEXT

                ListViewSetItem ( c , aTemp , Item )

            ENDIF

            if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0
                    SetImageListViewItems( c, item , value [1] )
            EndIf


        ENDIF

    case T == "STATUSBAR"

        SetStatusItemText ( c , value , Item-1 )

endcase
Return Nil

Function _GetItem ( ControlName , ParentForm , Item , idx )
Local t , c , RetVal , TreeHandle , ItemHandle , i , aPos
Local AEDITCONTROLS
Local CI
Local XRES
Local aTemp
Local AEC
Local CTYPE
Local CINPUTMASK
Local CFORMAT
Local AITEMS
Local ARANGE
Local DTYPE
Local ALABELS
Local V
Local Z
Local X

if pcount() == 3

    i := GetControlIndex ( ControlName , ParentForm )

elseif pcount() == 4

    i := idx

endif

T = ControlByIndex( i ):Type

c = ControlByIndex( i ):Handle

do case

    case T == "STATUSBAR"

        RetVal := GETSTATUSITEMTEXT ( c , Item-1 )   // by Dr. Claudio Soto (July 2014)

    case t == 'TREE'

        if ControlByIndex( I ):CTRL009 == .F.
            If Item > TreeView_GetCount ( c ) .or. Item < 1
                MsgHMGError ("Item Property: Invalid Item Reference. Program Terminated" )
            EndIf
        EndIf

        TreeHandle := c

        if ControlByIndex( I ):CTRL009 == .F.
            ItemHandle := ControlByIndex( I ):CTRL007 [ Item ]
        Else

            aPos := ascan ( ControlByIndex( I ):CTRL025 , Item )

            If aPos == 0
                MsgHMGError ("Item Property: Invalid Item Id. Program Terminated" )
            EndIf

            ItemHandle := ControlByIndex( I ):CTRL007 [ aPos ]

        EndIf

        RetVal  := TreeView_GetItem ( TreeHandle , ItemHandle )

    case T == "LIST" .Or. T == "MULTILIST"
        RetVal := ListBoxGetString ( c , Item )
    case T == "COMBO"

        If ValType ( ControlByIndex( I ):CTRL015 ) == 'U'
            RetVal := ComboGetString ( c , Item )
        Else
            RetVal := IMAGECOMBOGETITEM ( c , Item )
        EndIf

    case T == "GRID" .OR. T == "MULTIGRID"

        IF ControlByIndex( I ):CTRL040 [ 9 ] == .F.

            AEDITCONTROLS := ControlByIndex( I ):CTRL040 [2]

            IF VALTYPE ( AEDITCONTROLS ) != 'A'

               RetVal := ListViewGetItem_NEW ( c , Item , HMG_LEN( ControlByIndex( I ):CTRL007 ) )

            ELSE

                V := ListViewGetItem_NEW ( c , Item , HMG_LEN( ControlByIndex( I ):CTRL007 ) )

                aTemp := ARRAY ( HMG_LEN( ControlByIndex( I ):CTRL007 ) )

                FOR CI := 1 TO HMG_LEN( ControlByIndex( I ):CTRL007 )

                    XRES := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , CI )

                    AEC     := XRES [1]
                    CTYPE       := HMG_UPPER( XRES [2] )
                    CINPUTMASK  := XRES [3]
                    CFORMAT     := XRES [4]
                    AITEMS      := XRES [5]
                    ARANGE      := XRES [6]
                    DTYPE       := XRES [7]
                    ALABELS     := XRES [8]

                    IF AEC == 'TEXTBOX'
                        IF CTYPE == 'NUMERIC'
                            IF CFORMAT = 'E'
                                aTemp [CI] := GetNumFromCellTextSp ( v [CI] )
                            ELSE
                                aTemp [CI] := GetNumFromCellText ( v [CI] )
                            ENDIF
                        ELSEIF CTYPE == 'DATE'
                            aTemp [CI] := CTOD ( v [CI] )
                        ELSEIF CTYPE == 'CHARACTER'
                            aTemp [CI] := v [CI]
                        ENDIF

                    ELSEIF AEC == 'DATEPICKER'
                        aTemp [CI] := CTOD (V [CI] )


               ELSEIF AEC == 'TIMEPICKER'
                  aTemp [CI] := V [CI]

               ELSEIF   AEC == 'EDITBOX'        // Pablo, February 2015
                    aTemp [ci] := V [CI]

                    ELSEIF AEC == 'COMBOBOX'
                        Z := 0
                        FOR X := 1 TO HMG_LEN ( AITEMS )
                            IF HMG_UPPER ( ALLTRIM( V [CI] ) ) == HMG_UPPER ( ALLTRIM ( AITEMS [X] ) )
                                Z := X
                                EXIT
                            ENDIF
                        NEXT X
                        aTemp [CI] :=   Z

                    ELSEIF AEC == 'SPINNER'
                            aTemp [CI] := VAL (V [CI] )
                    ELSEIF AEC == 'CHECKBOX'
                        IF ALLTRIM(HMG_UPPER(V[CI])) == ALLTRIM(HMG_UPPER(ALABELS [1]))
                            aTemp [CI] :=  .T.
                        ELSEIF ALLTRIM(HMG_UPPER(V[CI])) == ALLTRIM(HMG_UPPER(ALABELS [2]))
                            aTemp [CI] := .F.
                        ENDIF
                    ENDIF

                    NEXT CI

                RetVal := aTemp

            ENDIF

            if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0
                if HMG_LEN (RetVal) >= 1
                    RetVal [1] := GetImageListViewItems( c , Item )
                EndIf
            EndIf

        ENDIF
endcase
Return (RetVal)

Function ListViewGetItem_NEW ( nControlHandle , nRow , nColumnCount )
Local nCol, V := ARRAY (nColumnCount)
   FOR nCol = 1 TO nColumnCount
       V [nCol] := LISTVIEW_GETITEMTEXT (nControlHandle , nRow-1, nCol-1)
   NEXT
Return V

Function _SetControlSizePos ( ControlName, ParentForm, row, col, width, height )
Local t,i,c,x , NewRow , r , w , z , p , xx , b , hws, oControlP
Local DelTaRow, DelTaCol
Local tCol, tRow, tWidth, tHeight , NewCol , Spacing

T := GetControlType (ControlName,ParentForm)

c := GetControlHandle (ControlName,ParentForm)

x := GetControlIndex (ControlName,ParentForm)

do case

    Case T == "TAB"



        DelTaRow := Row - ControlByIndex( X ):CTRL018
        DelTaCol := Col - ControlByIndex( X ):CTRL019

        ControlByIndex( X ):CTRL018 := Row
        ControlByIndex( X ):CTRL019 := Col
        ControlByIndex( X ):CTRL020 := Width
        ControlByIndex( X ):CTRL021 := Height

        MoveWindow ( c , col , Row , Width , Height , .t. )

        for r = 1 to HMG_LEN ( ControlByIndex( X ):CTRL007 )
            for w = 1 to HMG_LEN (ControlByIndex( X ):CTRL007 [r])
                if valtype ( ControlByIndex( X ):CTRL007 [r] [w] ) <> "A"

                    oControlP := ControlByHandle( ControlByIndex( X ):CTRL007 [r] [w] )
                    P := iif( oControlP == Nil, 0, oControlP:Index )


                    if p > 0
                    tCol    := ControlByIndex( P ):CTRL019
                    tRow    := ControlByIndex( P ):CTRL018
                    tWidth  := ControlByIndex( P ):CTRL020
                    tHeight := ControlByIndex( P ):CTRL021

                    MoveWindow ( ControlByIndex( X ):CTRL007 [r] [w] ,  tCol + DeltaCol , tRow + DeltaRow , tWidth , tHeight , .t. )

                    ControlByIndex( P ):CTRL018 :=  tRow + DeltaRow
                    ControlByIndex( P ):CTRL019 :=  tCol + DeltaCol

                    ControlByIndex( P ):CTRL023 :=  Row
                    ControlByIndex( P ):CTRL024 :=  Col
                    endif

                            else

                    oControlP := ControlByHandle( ControlByIndex( X ):CTRL007 [r] [w] [1] )
                    P := iif( oControlP == Nil, 0, oControlP:Index )

                    if p > 0 .and. oControlP:Type == 'BROWSE'

                    #ifdef COMPILEBROWSE

                        tCol    := ControlByIndex( P ):CTRL019
                        tRow    := ControlByIndex( P ):CTRL018
                        tWidth  := ControlByIndex( P ):CTRL020
                        tHeight := ControlByIndex( P ):CTRL021

                        If ControlByIndex( P ):CTRL005 != 0

                            MoveWindow ( ControlByIndex( X ):CTRL007 [r] [w] [1] , tCol + DeltaCol , tRow + DeltaRow , tWidth - GETVSCROLLBARWIDTH() , tHeight , .t. )

                            hws := 0
                            For b := 1 To HMG_LEN ( ControlByIndex( P ):CTRL006 )
                                hws := hws + ListView_GetColumnWidth ( ControlByIndex( P ):Handle , b - 1 )
                            Next b

                            if hws > ControlByIndex( P ):CTRL020 - GETVSCROLLBARWIDTH() - 4

                                MoveWindow ( ControlByIndex( P ):CTRL005 , tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH() , tRow + DeltaRow , GETVSCROLLBARWIDTH()   , tHeight - GetHScrollBarHeight() , .t. )
                                MoveWindow ( ControlByIndex( P ):CTRL039 [1], tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH() , tRow + DeltaRow + tHeight - GetHScrollBarHeight() , GetWindowWidth(ControlByIndex( P ):CTRL039 [1])   , GetWindowHeight(ControlByIndex( P ):CTRL039[1]) , .t. )

                            Else

                                MoveWindow ( ControlByIndex( P ):CTRL005 , tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH() , tRow + DeltaRow , GETVSCROLLBARWIDTH()   , tHeight , .t. )
                                MoveWindow ( ControlByIndex( P ):CTRL039 [1], tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH() , tRow + DeltaRow + tHeight - GetHScrollBarHeight() , 0  , 0 , .t. )

                            EndIf


                            _BrowseRefresh ( '' , '' , p )

                            ReDrawWindow ( ControlByIndex( P ):CTRL005 )

                            ReDrawWindow ( ControlByIndex( P ):CTRL039 [1])

                        Else

                            MoveWindow ( ControlByIndex( X ):CTRL007 [r] [w] [1] ,  tCol + DeltaCol , tRow + DeltaRow , tWidth , tHeight , .t. )

                        endif

                        ControlByIndex( P ):CTRL018 :=  tRow + DeltaRow
                        ControlByIndex( P ):CTRL019 :=  tCol + DeltaCol

                        ControlByIndex( P ):CTRL023 :=  Row
                        ControlByIndex( P ):CTRL024 :=  Col

                    #endif

                    else

                    for z = 1 to HMG_LEN ( ControlByIndex( X ):CTRL007 [r] [w] )

                        for xx = 1 to oHmgApp():ControlCount
                            if valtype ( ControlByIndex( XX ):Handle ) == 'A'
                                 if ControlByIndex( X ):CTRL007 [r] [w] == ControlByIndex( XX ):Handle
                                        if ControlByIndex( xx ):Type == 'RADIOGROUP'
                                          If ControlByIndex( XX ):CTRL008 == .T.
                                          MoveWindow ( ControlByIndex( XX ):Handle[ z ] ,  ControlByIndex( XX ):CTRL019 + DeltaCol + ( ControlByIndex( XX ):CTRL022 * (z-1) ) , ControlByIndex( XX ):CTRL018 + DeltaRow , ControlByIndex( XX ):CTRL022 , 28 , .t.  )
                                        Else
                                          MoveWindow ( ControlByIndex( XX ):Handle[ z ] ,  ControlByIndex( XX ):CTRL019 + DeltaCol , ControlByIndex( XX ):CTRL018 + DeltaRow + (ControlByIndex( XX ):CTRL022 * (z-1)), ControlByIndex( XX ):CTRL020 , 28 , .t.  )
                                        EndIf
                                 endif
                                 if ControlByIndex( xx ):Type == 'RADIOGROUP' .and. z == HMG_LEN ( ControlByIndex( X ):CTRL007 [r] [w] )
                                        If ControlByIndex( XX ):CTRL008 == .T.

                                        ControlByIndex( XX ):CTRL018  := ControlByIndex( XX ):CTRL018 + DeltaRow
                                        ControlByIndex( XX ):CTRL019  := ControlByIndex( XX ):CTRL019 + DeltaCol
                                        ControlByIndex( XX ):CTRL023  :=  Row
                                        ControlByIndex( XX ):CTRL024  :=  Col

                                        Else
                                        ControlByIndex( XX ):CTRL018  := ControlByIndex( XX ):CTRL018 + DeltaRow
                                        ControlByIndex( XX ):CTRL019  := ControlByIndex( XX ):CTRL019 + DeltaCol
                                        ControlByIndex( XX ):CTRL023  :=  Row
                                        ControlByIndex( XX ):CTRL024  :=  Col
                                        EndIf
                                    EndIf
                                        if ControlByIndex( xx ):Type == 'SPINNER' .and. z == 1

                                            MoveWIndow ( ControlByIndex( XX ):Handle[ 1 ] ,  ControlByIndex( XX ):CTRL019 + DeltaCol             , ControlByIndex( XX ):CTRL018 + DeltaRow , ControlByIndex( XX ):CTRL020    , ControlByIndex( XX ):CTRL021 , .t.  )
                                                        endif
                                        if ControlByIndex( xx ):Type == 'SPINNER' .and. z == 2

                                        MoveWIndow ( ControlByIndex( XX ):Handle[ 2 ] ,  ControlByIndex( XX ):CTRL019 + DeltaCol + ControlByIndex( XX ):CTRL020 - 15 , ControlByIndex( XX ):CTRL018 + DeltaRow , 15          , ControlByIndex( XX ):CTRL021 , .t.  )
                                        ControlByIndex( XX ):CTRL018 := ControlByIndex( XX ):CTRL018 + DeltaRow
                                        ControlByIndex( XX ):CTRL019 := ControlByIndex( XX ):CTRL019 + DeltaCol
                                        ControlByIndex( XX ):CTRL023  :=  Row
                                        ControlByIndex( XX ):CTRL024  :=  Col

                                                        endif

                                EndIf
                            EnDif
                        next xx

                    Next z
                    endif
                endif
            Next w
        Next r

    Case T == "SPINNER"

        if ControlByIndex( X ):CTRL023 == -1

            ControlByIndex( X ):CTRL018 := Row
            ControlByIndex( X ):CTRL019 := Col
            ControlByIndex( X ):CTRL020 := Width
            ControlByIndex( X ):CTRL021 := Height

            MoveWindow ( c [1] , Col , Row  , Width - 15 , Height , .t. )
            MoveWindow ( c [2] , Col + Width - 15 , Row , 15  , Height , .t. )

        Else

            ControlByIndex( X ):CTRL018 := Row + ControlByIndex( X ):CTRL023
            ControlByIndex( X ):CTRL019 := Col + ControlByIndex( X ):CTRL024
            ControlByIndex( X ):CTRL020 := Width
            ControlByIndex( X ):CTRL021 := Height

            MoveWindow ( c [1] , Col + ControlByIndex( X ):CTRL024 , Row + ControlByIndex( X ):CTRL023 , Width - 15 , Height , .t. )
            MoveWindow ( c [2] , Col + ControlByIndex( X ):CTRL024 + Width - 15 , Row + ControlByIndex( X ):CTRL023 , 15  , Height , .t. )


        EndIf

    #ifdef COMPILEBROWSE

    Case T == "BROWSE"

        if ControlByIndex( X ):CTRL023 == -1

            ControlByIndex( X ):CTRL018 := Row
            ControlByIndex( X ):CTRL019 := Col
            ControlByIndex( X ):CTRL020 := Width
            ControlByIndex( X ):CTRL021 := Height

            If ControlByIndex( X ):CTRL005 != 0
                MoveWindow ( c , col , Row , Width - GETVSCROLLBARWIDTH() , Height , .t. )

                hws := 0
                For b := 1 To HMG_LEN ( ControlByIndex( X ):CTRL006 )
                    hws := hws + ListView_GetColumnWidth ( ControlByIndex( X ):Handle , b - 1 )
                Next b

                if hws > ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH() - 4

                    MoveWindow ( ControlByIndex( X ):CTRL005 , col + Width - GETVSCROLLBARWIDTH() , Row , GETVSCROLLBARWIDTH()   , Height - GetHScrollBarHeight() , .t. )
                    MoveWindow ( ControlByIndex( X ):CTRL039 [1], col + Width - GETVSCROLLBARWIDTH() , Row + Height - GetHScrollBarHeight() , GetWindowWidth(ControlByIndex( X ):CTRL039 [1])   , GetWindowHeight(ControlByIndex( X ):CTRL039[1]) , .t. )

                else

                    MoveWindow ( ControlByIndex( X ):CTRL005 , col + Width - GETVSCROLLBARWIDTH() , Row , GETVSCROLLBARWIDTH()   , Height , .t. )
                    MoveWindow ( ControlByIndex( X ):CTRL039 [1], col + Width - GETVSCROLLBARWIDTH() , Row + Height - GetHScrollBarHeight() , 0  , 0 , .t. )

                endif

                _BrowseRefresh ( '' , '' , x )
                ReDrawWindow ( ControlByIndex( X ):CTRL005 )
                ReDrawWindow ( ControlByIndex( X ):CTRL039 [1])
            Else
                MoveWindow ( c , col , Row , Width , Height , .t. )
            EndIf

        Else

            ControlByIndex( X ):CTRL018 := Row + ControlByIndex( X ):CTRL023
            ControlByIndex( X ):CTRL019 := Col + ControlByIndex( X ):CTRL024
            ControlByIndex( X ):CTRL020 := Width
            ControlByIndex( X ):CTRL021 := Height

            If ControlByIndex( X ):CTRL005 != 0

                MoveWindow ( c , col + ControlByIndex( X ):CTRL024, Row + ControlByIndex( X ):CTRL023 , Width - GETVSCROLLBARWIDTH() , Height , .t. )

                hws := 0
                For b := 1 To HMG_LEN ( ControlByIndex( X ):CTRL006 )
                    hws := hws + ListView_GetColumnWidth ( ControlByIndex( X ):Handle , b - 1 )
                Next b

                if hws > ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH() - 4

                    MoveWindow ( ControlByIndex( X ):CTRL005 , col + ControlByIndex( X ):CTRL024+ Width - GETVSCROLLBARWIDTH() , Row + ControlByIndex( X ):CTRL023, GETVSCROLLBARWIDTH()   , Height - GetHScrollBarHeight() , .t. )
                    MoveWindow ( ControlByIndex( X ):CTRL039 [1], col + ControlByIndex( X ):CTRL024+ Width - GETVSCROLLBARWIDTH() , Row + ControlByIndex( X ):CTRL023+ Height - GetHScrollBarHeight() , GetWindowWidth(ControlByIndex( X ):CTRL039 [1])   , GetWindowHeight(ControlByIndex( X ):CTRL039[1]) , .t. )

                else

                    MoveWindow ( ControlByIndex( X ):CTRL005 , col + ControlByIndex( X ):CTRL024+ Width - GETVSCROLLBARWIDTH() , Row + ControlByIndex( X ):CTRL023, GETVSCROLLBARWIDTH()   , Height , .t. )
                    MoveWindow ( ControlByIndex( X ):CTRL039 [1], col + ControlByIndex( X ):CTRL024+ Width - GETVSCROLLBARWIDTH() , Row + ControlByIndex( X ):CTRL023+ Height - GetHScrollBarHeight() , 0  , 0 , .t. )

                endif

                _BrowseRefresh ( '' , '' , x )

                ReDrawWindow ( ControlByIndex( X ):CTRL005 )

                ReDrawWindow ( ControlByIndex( X ):CTRL039 [1])

            Else
                MoveWindow ( c , col + ControlByIndex( X ):CTRL024, Row + ControlByIndex( X ):CTRL023 , Width , Height , .t. )
            EndIf

        EndIf

        ReDrawWindow ( c )

    #endif

    Case T == "RADIOGROUP"

        if ControlByIndex( X ):CTRL023 == -1

            ControlByIndex( X ):CTRL018   := Row
            ControlByIndex( X ):CTRL019   := Col
            ControlByIndex( X ):CTRL020   := Width
            Spacing             := ControlByIndex( X ):CTRL022

            if ControlByIndex( X ):CTRL008

                For i := 1 To HMG_LEN ( c )
                    NewCol := Col + ( ( i - 1 ) * ControlByIndex( X ):CTRL022 )
                    MoveWindow ( c [i] , Newcol , Row , spacing , 28 , .t. )
                Next i

            else



                For i := 1 To HMG_LEN ( c )
                    NewRow := Row + ( ( i - 1 ) * ControlByIndex( X ):CTRL022 )
                    MoveWindow ( c [i] , col , NewRow , Width , 28 , .t. )
                Next i

            endif

        Else

            ControlByIndex( X ):CTRL018 := Row + ControlByIndex( X ):CTRL023
            ControlByIndex( X ):CTRL019 := Col + ControlByIndex( X ):CTRL024
            ControlByIndex( X ):CTRL020 := Width

            Spacing             := ControlByIndex( X ):CTRL022

            if ControlByIndex( X ):CTRL008



                For i := 1 To HMG_LEN ( c )
                    *NewCol := Col + ControlByIndex( X ):CTRL024 + ( ( i - 1 ) * ControlByIndex( X ):CTRL022 )
                    *MoveWindow ( c [i] , NewCol , Row , Spacing , 28 , .t. )
                Next i

            else



                For i := 1 To HMG_LEN ( c )
                    NewRow := Row + ControlByIndex( X ):CTRL023 + ( ( i - 1 ) * ControlByIndex( X ):CTRL022 )
                    MoveWindow ( c [i] , col + ControlByIndex( X ):CTRL024 , NewRow , Width , 28 , .t. )
                Next i

            endif

        EndIf

    OtherWise

        if ControlByIndex( X ):CTRL023 == -1

            ControlByIndex( X ):CTRL018 := Row
            ControlByIndex( X ):CTRL019 := Col
            ControlByIndex( X ):CTRL020 := Width
            ControlByIndex( X ):CTRL021 := Height
            MoveWindow ( c , col , row , width , height , .t. )

        Else

            ControlByIndex( X ):CTRL018 := Row + ControlByIndex( X ):CTRL023
            ControlByIndex( X ):CTRL019 := Col + ControlByIndex( X ):CTRL024
            ControlByIndex( X ):CTRL020 := Width
            ControlByIndex( X ):CTRL021 := Height
            MoveWindow ( c , col + ControlByIndex( X ):CTRL024 , row + ControlByIndex( X ):CTRL023 , width , height , .t. )

        EndIf
EndCase
Return Nil

Function _GetItemCount ( ControlName, ParentForm )
Local t , c , RetVal

T = GetControlType (ControlName,ParentForm)

c = GetControlHandle (ControlName,ParentForm)

do case
    case T == "TREE"
        RetVal := TreeView_GetCount  ( c )
    case T == "LIST" .Or. T == "MULTILIST"
        RetVal := ListBoxGetItemCount ( c )
    case T == "COMBO"
        RetVal := ComboBoxGetItemCount ( c )
    case T == "GRID" .OR. T == "MULTIGRID"
        RetVal := ListView_GetItemCount ( c )
endcase
Return (RetVal)

Function _GetControlRow (ControlName,ParentForm)
Local mVar , i

mVar := '_' + ParentForm + '_' + ControlName

i := &mVar
if i == 0
    Return 0
EndIf

If ControlByIndex( &MVAR ):CTRL023 == - 1
    Return (ControlByIndex( &MVAR ):CTRL018 )
Else
    Return ( ControlByIndex( &MVAR ):CTRL018 - ControlByIndex( &MVAR ):CTRL023 )
EndIf
Return Nil

Function _GetControlCol (ControlName,ParentForm)
Local mVar , i

mVar := '_' + ParentForm + '_' + ControlName

i := &mVar
if i == 0
    Return 0
EndIf

If ControlByIndex( &MVAR ):CTRL024 == - 1
    Return (ControlByIndex( &MVAR ):CTRL019 )
Else
    Return ( ControlByIndex( &MVAR ):CTRL019 - ControlByIndex( &MVAR ):CTRL024 )
EndIf
Return Nil

Function _GetControlWidth (ControlName,ParentForm)
Local mVar , i

mVar := '_' + ParentForm + '_' + ControlName

i := &mVar
if i == 0
   Return 0
EndIf
Return (ControlByIndex( &MVAR ):CTRL020 )

Function _GetControlHeight (ControlName,ParentForm)
Local mVar , i

mVar := '_' + ParentForm + '_' + ControlName

i := &mVar
if i == 0
   Return 0
EndIf
Return (ControlByIndex( &MVAR ):CTRL021 )

Function _SetControlCol ( ControlName, ParentForm, Value )
_SetControlSizePos ( ControlName, ParentForm , _GetControlRow ( ControlName,ParentForm) , Value , _GetControlWidth ( ControlName,ParentForm) , _GetControlHeight ( ControlName,ParentForm) )
Return Nil

Function _SetControlRow ( ControlName, ParentForm, Value )
_SetControlSizePos ( ControlName, ParentForm , Value , _GetControlCol ( ControlName,ParentForm) , _GetControlWidth ( ControlName,ParentForm) , _GetControlHeight ( ControlName,ParentForm) )
Return Nil

Function _SetControlWidth ( ControlName, ParentForm, Value )
_SetControlSizePos ( ControlName, ParentForm , _GetControlRow ( ControlName,ParentForm) , _GetControlCol ( ControlName,ParentForm) , Value , _GetControlHeight ( ControlName,ParentForm) )
Return Nil

Function _SetControlHeight ( ControlName, ParentForm, Value )
_SetControlSizePos ( ControlName, ParentForm , _GetControlRow ( ControlName,ParentForm) , _GetControlCol ( ControlName,ParentForm) , _GetControlWidth ( ControlName,ParentForm) , Value )
Return Nil

Function _SetPicture ( ControlName, ParentForm, FileName )
Local w,h,t,i,c, OldBitmap

i := GetControlIndex ( ControlName, ParentForm )
t := GetControlType ( ControlName, ParentForm )
c := GetControlHandle (ControlName,ParentForm)

If t == 'IMAGE'    // Dr. Claudio Soto (May 2013)

  // w := _GetControlWidth  ( ControlName, ParentForm )
  // h := _GetControlHeight ( ControlName, ParentForm )

  w := ControlByIndex( I ):CTRL031   // original Width
  h := ControlByIndex( I ):CTRL032   // original Height

  DeleteObject ( ControlByIndex( I ):CTRL037 )
                                                                                                          //  stretch                  transparent              nBackgroundColor        adjustimage              TransparentColor
  ControlByIndex( I ):CTRL037 := C_SetPicture ( GetControlHandle (ControlName, ParentForm) , FileName , w , h , ControlByIndex( I ):CTRL008 , ControlByIndex( I ):CTRL039 , ControlByIndex( I ):CTRL026, ControlByIndex( I ):CTRL036, ControlByIndex( I ):CTRL028)

  ControlByIndex( I ):CTRL025 := FileName

  ControlByIndex( I ):CTRL020 := GetWindowWidth  ( GetControlHandle (ControlName, ParentForm) )
  ControlByIndex( I ):CTRL021 := GetWindowHeight ( GetControlHandle (ControlName, ParentForm) )


elseif T == 'BUTTON'

   if ControlByIndex( I ):CTRL038 == .T. .AND. Empty( FileName )   // ADD, march 2017
      DeleteObject ( ControlByIndex( I ):CTRL037 )
      ControlByIndex( I ):CTRL037 := _SetBtnPicture ( ControlByIndex( i ):Handle, FileName, Nil, Nil )
      ControlByIndex( I ):CTRL025 := FileName
      Return Nil
   endif

    if  .Not. Empty (ControlByIndex( I ):CTRL025 ) ;
        .And. ;
        .Not. Empty (ControlByIndex( I ):CTRL033 ) ;
        .Or.;
        (ControlByIndex( I ):CTRL022 == 'I' .And. IsAppThemed());

        if ControlByIndex( I ):CTRL038 == .T.

            IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL037 )
            ControlByIndex( I ):CTRL037 := _SetMixedBtnPicture ( ControlByIndex( i ):Handle, FileName, ControlByIndex( I ):CTRL026, ControlByIndex( I ):CTRL032, Nil )

            RedrawWindow (ControlByIndex( i ):Handle)
            ControlByIndex( I ):CTRL025 := FileName

        endif

    else

        if ControlByIndex( I ):CTRL038 == .T.
            DeleteObject ( ControlByIndex( I ):CTRL037 )
            ControlByIndex( I ):CTRL037 := _SetBtnPicture ( ControlByIndex( i ):Handle, FileName, ControlByIndex( I ):CTRL032, Nil )
            ControlByIndex( I ):CTRL025 := FileName
        endif

    endif

elseif T == "TOOLBUTTON"    // Dr. Claudio Soto (March 2016)

   OldBitmap := ControlByIndex( i ):Handle
   ControlByIndex( i ):Handle := TB_REPLACEBITMAP ( ControlByIndex( I ):CTRL026, c, FileName, ControlByIndex( I ):CTRL032, ControlByIndex( I ):CTRL005 )
   ControlByIndex( I ):CTRL025 := FileName
   IF ControlByIndex( i ):Handle <> 0
      DeleteObject( OldBitmap )
   ENDIF

elseif T == "CHECKBOX"

    If ControlByIndex( I ):CTRL038 == .T.

        if  ControlByIndex( I ):CTRL016 == 'I'

            if IsAppThemed()

                IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL037 )
                ControlByIndex( I ):CTRL037 := _SetMixedBtnPicture ( ControlByIndex( i ):Handle, FileName, ControlByIndex( I ):CTRL026, ControlByIndex( I ):CTRL032, Nil )

                RedrawWindow (ControlByIndex( i ):Handle)
                ControlByIndex( I ):CTRL025 := FileName

            else

                DeleteObject( ControlByIndex( I ):CTRL037 )
                ControlByIndex( I ):CTRL037 := _SetBtnPicture ( c, FileName, ControlByIndex( I ):CTRL032, Nil )
                ControlByIndex( I ):CTRL025 := FileName

            endif

        else

            DeleteObject ( ControlByIndex( I ):CTRL037 )
            ControlByIndex( I ):CTRL037 := _SetBtnPicture ( ControlByIndex( i ):Handle, FileName, ControlByIndex( I ):CTRL032, Nil )
            ControlByIndex( I ):CTRL025 := FileName

        endif

    EndIf

else

    DeleteObject ( ControlByIndex( I ):CTRL037 )
    ControlByIndex( I ):CTRL037 := _SetBtnPicture ( ControlByIndex( i ):Handle, FileName, ControlByIndex( I ):CTRL032, Nil )
    ControlByIndex( I ):CTRL025 := FileName

Endif
Return Nil

Function _GetPicture ( ControlName, ParentForm )
Local i

i := GetControlIndex ( ControlName, ParentForm )

if i == 0
    Return ''
EndIf
Return  ( ControlByIndex( I ):CTRL025 )

Function GetData()
Local PacketNames [ aDir ( oHmgApp():APP291 + oHmgApp():APP292 + '.*'  ) ] , i , Rows , Cols , RetVal := Nil , bd , aItem , aTemp := {} , r , c
Local DataValue, DataType, DataLength, Packet

bd = Set (_SET_DATEFORMAT )

SET DATE TO ANSI

aDir ( oHmgApp():APP291 + oHmgApp():APP292 + '.*' , PacketNames )

If HMG_LEN ( PacketNames ) > 0

    Packet := HB_MemoRead ( oHmgApp():APP291 + PacketNames [1] )   // ADD

    Rows := Val ( HB_USUBSTR ( Memoline ( Packet , , 1 ) , 11 , 99 ) )
    Cols := Val ( HB_USUBSTR ( Memoline ( Packet , , 2 ) , 11 , 99 )    )

    Do Case

        // Single Data

        Case Rows == 0 .And. Cols == 0

            DataType := HB_USUBSTR ( Memoline ( Packet ,  , 3 ) , 12 , 1 )
            DataLength := Val ( HB_USUBSTR ( Memoline ( Packet , , 3 ) , 14 , 99 ) )

            DataValue := Memoline ( Packet , 254 , 4 )

            Do Case
                Case DataType == 'C'
                    RetVal := HB_ULEFT ( DataValue , DataLength )
                Case DataType == 'N'
                    RetVal := Val ( DataValue )
                Case DataType == 'D'
                    RetVal := CTOD ( DataValue )
                Case DataType == 'L'
                    RetVal := iif ( ALLTRIM(DataValue) == 'T' , .t. , .f. )
                End Case

        // One Dimension Array Data

        Case Rows != 0 .And. Cols == 0

            i := 3

            Do While i < MlCount ( Packet )

                DataType   := HB_USUBSTR ( Memoline ( Packet , , i ) , 12 , 1 )
                DataLength := Val ( HB_USUBSTR ( Memoline ( Packet , , i ) , 14 , 99 ) )

                i++

                DataValue  := Memoline ( Packet , 254 , i )

                Do Case
                    Case DataType == 'C'
                        aItem := HB_ULEFT ( DataValue , DataLength )
                    Case DataType == 'N'
                        aItem := Val ( DataValue )
                    Case DataType == 'D'
                        aItem := CTOD ( DataValue )
                    Case DataType == 'L'
                        aItem := iif ( ALLTRIM(DataValue) == 'T' , .t. , .f. )
                    End Case

                aAdd ( aTemp , aItem )

                i++

            EndDo

            RetVal := aTemp

        // Two Dimension Array Data

        Case Rows != 0 .And. Cols != 0

            i := 3

            aTemp := Array ( Rows , Cols )

            r := 1
                        c := 1

            Do While i < MlCount ( Packet )

                DataType   := HB_USUBSTR ( Memoline ( Packet , , i ) , 12 , 1 )
                DataLength := Val ( HB_USUBSTR ( Memoline ( Packet , , i ) , 14 , 99 ) )

                i++

                DataValue  := Memoline ( Packet , 254 , i )

                Do Case
                    Case DataType == 'C'
                        aItem := HB_ULEFT ( DataValue , DataLength )
                    Case DataType == 'N'
                        aItem := Val ( DataValue )
                    Case DataType == 'D'
                        aItem := CTOD ( DataValue )
                    Case DataType == 'L'
                        aItem := iif ( ALLTRIM(DataValue) == 'T' , .t. , .f. )
                    End Case

                aTemp [r] [c] := aItem

                c++
                if c > Cols
                    r++
                    c := 1
                EndIf

                i++

            EndDo

            RetVal := aTemp

    End Case
Else
    Set (_SET_DATEFORMAT ,bd)
    Return Nil
EndIf
Delete File ( oHmgApp():APP291 + PacketNames [1] )
Set (_SET_DATEFORMAT ,bd)
Return ( RetVal )

Function SendData ( cDest , Data )
Local cData := '' , i , j
Local pData, cLen, cType, FileName, Rows, Cols

oHmgApp():APP290++

FileName := oHmgApp():APP291 + cDest + '.' + oHmgApp():APP292 + '.' + ALLTRIM ( STR ( oHmgApp():APP290 ) )

If ValType ( Data ) == 'A'

    If ValType ( Data [1] ) != 'A'

        cData := '#DataRows=' + ALLTRIM(STR(HMG_LEN(Data))) + CHR(13) + CHR(10)
        cData := cData + '#DataCols=0'  + CHR(13) + CHR(10)

        For i := 1 To HMG_LEN ( Data )

            cType := ValType ( Data [i] )

            If cType == 'D'
                pData := ALLTRIM(STR(year(data[i]))) + '.' + ALLTRIM(STR(month(data[i]))) + '.' + ALLTRIM(STR(day(data[i])))
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            ElseIf cType == 'L'
                If Data [i] == .t.
                    pData := 'T'
                Else
                    pData := 'F'
                EndIf
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            ElseIf cType == 'N'
                pData := STR ( Data [i] )
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            ElseIf cType == 'C'
                pData := Data [i]
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            Else
                MsgHMGError('SendData: Type Not Suported. Program terminated')
            EndIf

            cData := cData + '#DataBlock='  + cType + ',' + cLen + CHR(13) + CHR(10)
            cData := cData + pData      + CHR(13) + CHR(10)

        Next i

        HB_MemoWrit ( FileName , cData )   // ADD

    Else

        Rows := HMG_LEN ( Data )
        Cols := HMG_LEN ( Data [1] )

        cData := '#DataRows=' + ALLTRIM(STR(Rows))  + CHR(13) + CHR(10)
        cData := cData + '#DataCols=' + ALLTRIM(STR(Cols)) + CHR(13) + CHR(10)

        For i := 1 To Rows

            For j := 1 To Cols

            cType := ValType ( Data [i] [j] )

            If cType == 'D'
                pData := ALLTRIM(STR(year(data[i][j]))) + '.' + ALLTRIM(STR(month(data[i][j]))) + '.' + ALLTRIM(STR(day(data[i][j])))
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            ElseIf cType == 'L'
                If Data [i] [j] == .t.
                    pData := 'T'
                Else
                    pData := 'F'
                EndIf
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            ElseIf cType == 'N'
                pData := STR ( Data [i] [j] )
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            ElseIf cType == 'C'
                pData := Data [i] [j]
                cLen := ALLTRIM(STR(HMG_LEN(pData)))
            Else
                MsgHMGError('SendData: Type Not Suported. Program terminated')
            EndIf

            cData := cData + '#DataBlock='  + cType + ',' + cLen+ CHR(13) + CHR(10)
            cData := cData + pData      + CHR(13) + CHR(10)

            Next j
        Next i

        HB_MemoWrit ( FileName , cData )   // ADD

    EndIf

Else

    cType := ValType ( Data )

    If cType == 'D'
        pData := ALLTRIM(STR(year(data))) + '.' + ALLTRIM(STR(month(data))) + '.' + ALLTRIM(STR(day(data)))
        cLen := ALLTRIM(STR(HMG_LEN(pData)))
    ElseIf cType == 'L'
        If Data == .t.
            pData := 'T'
        Else
            pData := 'F'
        EndIf
        cLen := ALLTRIM(STR(HMG_LEN(pData)))
    ElseIf cType == 'N'
        pData := STR ( Data )
        cLen := ALLTRIM(STR(HMG_LEN(pData)))
    ElseIf cType == 'C'
        pData := Data
        cLen := ALLTRIM(STR(HMG_LEN(pData)))
    Else
            MsgHMGError('SendData: Type Not Suported. Program terminated')
    EndIf

    cData := '#DataRows=0'      + CHR(13) + CHR(10)
    cData := cData + '#DataCols=0'  + CHR(13) + CHR(10)

    cData := cData + '#DataBlock='  + cType + ',' + cLen+ CHR(13) + CHR(10)
    cData := cData + pData      + CHR(13) + CHR(10)

    HB_MemoWrit ( FileName , cData )   // ADD

EndIf
Return Nil

Function _EnableToolbarButton ( ButtonName , FormName )
Local i
Local cCaption
Local x
Local c
Local bAction

i := GetControlIndex ( ButtonName, FormName )

if i > 0

    EnableToolButton( ControlByIndex( I ):CTRL026  , GetControlId(ButtonName,FormName) )

    bAction := ControlByIndex( I ):CTRL006

    cCaption := ControlByIndex( I ):CTRL033

    If ValType ( cCaption ) != 'U'

        cCaption := HMG_UPPER ( cCaption )

        x := HB_UAT ( '&' , cCaption )

        If x > 0
            c := ASC ( HB_USUBSTR ( cCaption , x+1 , 1 ) )

            If c >= 48 .And. c <= 90
                _DefineHotKey ( FormName , MOD_ALT , c , bAction )
            EndIf
        EndIf
    EndIf
EndIf
Return Nil

Function _DisableToolbarButton ( ButtonName, FormName )
Local i
Local cCaption
Local x
Local c

i := GetControlIndex ( ButtonName, FormName )

if i > 0

    DisableToolButton( ControlByIndex( I ):CTRL026  , GetControlId(ButtonName,FormName) )

    cCaption := ControlByIndex( I ):CTRL033

    If ValType ( cCaption ) != 'U'

        cCaption := HMG_UPPER ( cCaption )

        x := HB_UAT ( '&' , cCaption )

        If x > 0

            c := ASC ( HB_USUBSTR ( cCaption , x+1 , 1 ) )

            If c >= 48 .And. c <= 90
                _ReleaseHotKey ( FormName , MOD_ALT , c )
            EndIf

        EndIf

    EndIf

EndIf
Return NIL

Function _GetControlAction( ControlName, ParentForm )
Local i := GetControlIndex ( ControlName, ParentForm )

if i == 0
    Return ''
EndIf
Return  ( ControlByIndex( I ):CTRL006 )

Function _GetToolTip ( ControlName, ParentForm )
Local i := GetControlIndex ( ControlName, ParentForm )

if i == 0
    Return ''
EndIf
Return  ( ControlByIndex( I ):CTRL030 )


Function _SetToolTip ( ControlName, ParentForm , Value  )
Local i , h
LOCAL MenuItemID

   i := GetControlIndex ( ControlName, ParentForm )
   if i == 0
      Return Nil
   EndIf

   IF ControlByIndex( I ):Type == "MENU"   // by Dr. Claudio Soto, December 2014
      MenuItemID := ControlByIndex( I ):CTRL005
      ControlByIndex( I ):CTRL030 := Value
      SetToolTipMenuItem ( GetFormHandle (ParentForm), Value, MenuItemID, GetMenuToolTipHandle(ParentForm) )
   ELSE
      h := ControlByIndex( i ):Handle
      ControlByIndex( I ):CTRL030 := Value
      SetToolTip ( h , Value , GetFormToolTipHandle (ParentForm) )
   ENDIF
Return Nil


Function _SetRangeMin ( ControlName, ParentForm , Value  )
Local i , h , t , m

i := GetControlIndex ( ControlName, ParentForm )
h := ControlByIndex( i ):Handle
t := GetControlType ( ControlName, ParentForm )
m := ControlByIndex( I ):CTRL032

DO CASE

    CASE T == 'SLIDER'

        SetSliderRange ( h , Value , m )

    CASE T == 'SPINNER'

        SetSpinnerRange ( h [2] , Value , m )

    CASE T == 'PROGRESSBAR'

        SetProgressBarRange ( h , Value , m )

END CASE
ControlByIndex( I ):CTRL031 := Value
Return Nil

Function _SetRangeMax ( ControlName, ParentForm , Value  )
Local i , h , t , m

i := GetControlIndex ( ControlName, ParentForm )
h := ControlByIndex( i ):Handle
t := GetControlType ( ControlName, ParentForm )
m := ControlByIndex( I ):CTRL031

DO CASE
    CASE T == 'SLIDER'
        SetSliderRange ( h , m, Value  )

    CASE T == 'SPINNER'
        SetSpinnerRange ( h [2] , m , Value )

    CASE T == 'PROGRESSBAR'
        SetProgressBarRange ( h , m , Value )

END CASE
ControlByIndex( I ):CTRL032 := Value
Return Nil

Function _GetRangeMin ( ControlName, ParentForm )
Local i

i := GetControlIndex ( ControlName, ParentForm )

if i == 0
    Return 0
EndIf
Return  ( ControlByIndex( I ):CTRL031 )

Function _GetRangeMax ( ControlName, ParentForm )
Local i

i := GetControlIndex ( ControlName, ParentForm )

if i == 0
    Return 0
EndIf
Return  ( ControlByIndex( I ):CTRL032 )

Function _SetMultiCaption ( ControlName, ParentForm , Column , Value  )
Local i , h , t

i := GetControlIndex ( ControlName, ParentForm )

h := ControlByIndex( i ):Handle

t := GetControlType ( ControlName, ParentForm )

ControlByIndex( I ):CTRL033 [Column] := Value

Do Case
    Case t == 'GRID' .Or. t == 'MULTIGRID' .Or. t == 'BROWSE'
        SETGRIDCOLOMNHEADER ( h , Column , Value )
    Case t == 'RADIOGROUP'
        SetWindowText ( h [Column] , Value )
    Case t == 'TAB'
        ControlByIndex( I ):CTRL033 [Column] := Value
        SETTABCAPTION ( h , Column , Value )
EndCase
Return Nil

Function _GetMultiCaption ( ControlName, ParentForm , Item )
Local i := GetControlIndex ( ControlName, ParentForm )
if i == 0
    Return ''
EndIf
Return  ( ControlByIndex( I ):CTRL033 [item] )


/*****************************************************************************************************************/


//  By Pablo César on June 26th, 2015

Function InputWindow ( cTitle, aLabels, aValues, aFormats, nRow, nCol, aBackColor, aToolTips, aHotKeys, aStyles, bCode )
Local i, nLen, nControlRow:=10, nControlCol, LN, CN, nR, nC, nW, nH:=0, nDiff, cType1, cType2, nCWidth:=140, nLWidth:=90
Local cForm, cGrid, aCtrlsWidths, aCtrlsWhen, nIdx, cValue, cTimeFormat, aEditControls, XRES, aFields, cControlType:=""
Local cDbf, nPos, lWidthCDefined, nGridRow, nGridCol, xValue, aGridValue, cTxt, lWhen, lHidden, lCheckBoxEnabled:=.F.
Local aJust, lRightAlign, lHotKeysDefined, nEditOption:=0, lAtFirstImages, oError, OldScrollStep


DEFAULT nRow := 0
DEFAULT nCol := 0

If !ValType(aBackColor)="A"
   aBackColor  := NIL
Endif
If !ValType(aHotKeys)="A"
   aHotKeys    := {}
Endif
If ValType(aStyles)="A" .and. HMG_Len(aStyles)=2
   If !( HMG_Len(aStyles[1])=4 .and. HMG_Len(aStyles[2])=2 )
      ASize( aStyles[1], 4 )
      ASize( aStyles[2], 2 )
   Endif
Else
   aStyles:={{nLWidth,.F.,Nil,0},{nCWidth,.F.}}
Endif

If ValType(cTitle)="U"
   cTitle:=(ThisWindow.Name)
Endif
If ValType(aLabels)="U"
   aLabels:=(ThisWindow.FocusedControl)
Endif

If !ValType(aLabels)="A"
   If ValType(cTitle)="C" .and. ValType(aLabels)="C"
      cControlType:=HMG_Upper(GetControlType(aLabels,cTitle))
      If "GRID" $ cControlType
         cForm:=cTitle
         cGrid:=aLabels
         //DoMethod(cForm,cGrid,"DisableUpdate")
         nIdx:=GetControlIndex(cGrid,cForm)
         aGridValue:=GetProperty(cForm,cGrid,"Value")
         If cControlType="MULTIGRID"
            If Len(aGridValue)=1
               nGridRow:=aGridValue[1]
               cTitle:="Record #"+AllTrim(Str(nGridRow))+" edition"
            Else
               nGridRow:=1
               cTxt:=""
               AEval( aGridValue, { | Arr,n | cTxt += AllTrim(Str(Arr))+If(n=Len(aGridValue),"",",") } )
               cTitle:="Records #"+cTxt+" edition"
            Endif
            nGridCol:=1
         Else
            If ValType(aGridValue)="A"
               nGridRow:=aGridValue[1]
               nGridCol:=aGridValue[2]
            Else
               nGridRow:=aGridValue
               nGridCol:=1
            Endif
            cTitle:="Record #"+AllTrim(Str(nGridRow))+" edition"
         Endif
         If !GetProperty(cForm,cGrid,"CELLNAVIGATION")
            If GetProperty(cForm,cGrid,"CELLCOLCLICKED") > 0
               nGridCol:=GetProperty(cForm,cGrid,"CELLCOLCLICKED")
               ControlByIndex( NIDX ):CTRL040 [37] [2]:=0                // Need to reset the last clicked
            Endif
         Endif
         If nGridCol=0 // In case click out of active columns
            Return Nil
         Endif
         lAtFirstImages := (Len(ControlByIndex( NIDX ):CTRL014) > 0)
         If nGridCol=1 .and. lAtFirstImages
            nGridCol++
         Endif
         aLabels:={}
         If ValType(aValues)="A"
            aStyles[2,1]:=aValues
            lWidthCDefined:=.T.
         Else
            lWidthCDefined:=.F.
         Endif
         aValues:={}
         If ValType(aFormats)="A"
            aHotKeys:=aFormats
            lHotKeysDefined:=.T.
         Else
            lHotKeysDefined:=.F.
         Endif
         aJust:={}
         aFormats:={}
         aCtrlsWidths:={}



         aEditControls := ControlByIndex( NIDX ):CTRL040 [ 2 ]
         aCtrlsWhen := ControlByIndex( NIDX ):CTRL040 [ 6 ]


         nEditOption := GetProperty(cForm,cGrid,"EDITOPTION")


         cDbf := ( ControlByIndex( NIDX ):CTRL040 [ 10 ])

         lCheckBoxEnabled:=GetProperty(cForm,cGrid,"CHECKBOXENABLED")
         If lCheckBoxEnabled
            xValue:=GetProperty(cForm,cGrid,"CHECKBOXITEM",nGridRow)
            Aadd(aLabels,"") // "Selected item"
            Aadd(aValues,xValue)
            Aadd(aFormats,Nil)
            Aadd(aJust,0)
         Endif

         nLen:=GetProperty(cForm,cGrid,"COLUMNCOUNT")


         nCWidth := 0
         For i=1 To nLen
             nPos:=_GridEx_GetColumnDisplayPosition(cGrid, cForm, i)

             If cControlType="MULTIGRID"
                If Len(aGridValue)=1

                   xValue:=GetProperty(cForm,cGrid,"CELL",nGridRow,nPos)
                Else
                   xValue:=""
                Endif
             Else
                xValue:=GetProperty(cForm,cGrid,"CELL",nGridRow,nPos)
             Endif


             Aadd(aLabels,GetProperty(cForm,cGrid,"ColumnHEADER",nPos))




             If ValType(aEditControls)="A" .and. ValType(aEditControls[nPos])="A"
                XRES := _HMG_PARSEGRIDCONTROLS ( aEditControls, nPos )
                Do Case
                   Case XRES[1] == 'CHECKBOX'
                        Aadd(aValues,xValue)
                        Aadd(aFormats,Nil)

                   Case XRES[1] == 'TEXTBOX' .and. XRES[2] == 'DATE'
                        Aadd(aValues,xValue)
                        Aadd(aFormats,Nil)

                   Case XRES[1] == 'TEXTBOX' .and. XRES[2] == 'NUMERIC'
                        Aadd(aValues,xValue)
                        If !Empty( XRES[3] )         // INPUTMASK
                           Aadd(aFormats,XRES[3])
                        Else
                           Aadd(aFormats,xValue)
                        Endif

                   Case XRES[1] == 'TEXTBOX' .and. XRES[2] == 'CHARACTER'
                        Aadd(aValues,xValue)
                        Aadd(aFormats,32)

                   Case XRES[1] == 'TEXTBOX' .and. XRES[2] == 'PASSWORD' // Required Grid implementation in HMG
                        If ValType(xValue)="U"
                           xValue:=""
                        Endif
                        Aadd(aValues,xValue)
                        Aadd(aFormats,"PASSWORD")

                   Case XRES[1] == 'COMBOBOX' .and. Len(XRES[5]) > 0
                        Aadd(aValues,xValue)
                        Aadd(aFormats,XRES[5])

                   Case XRES[1] == 'DATEPICKER'
                        Aadd(aValues,xValue)
                        If XRES[7] = 'DROPDOWN'
                           Aadd(aFormats,.F.)
                        ElseIf XRES[7] = 'UPDOWN'
                           Aadd(aFormats,.T.)
                        Endif

                   Case XRES[1] == 'TIMEPICKER'
                        Aadd(aValues,xValue)
                        Aadd(aFormats,{HMG_TimeToTime(xValue, XRES[4])})

                   Case XRES[1] == 'SPINNER'
                        If !(Len(XRES[6]) == (Len(aEditControls[nPos])-1))
                           XRES[6]:={aEditControls[nPos,2],aEditControls[nPos,3]}
                           If Len(aEditControls[nPos])=4
                              Aadd(XRES[6],aEditControls[nPos,4])
                           Endif
                        Endif
                        If Len(XRES[6])<3
                           Aadd(aValues,{XRES[6,1],XRES[6,2],1})
                        Else
                           Aadd(aValues,{XRES[6,1],XRES[6,2],XRES[6,3]})
                        Endif
                        Aadd(aFormats,xValue)

                   Case XRES[1] == 'EDITBOX'
                        If ":" $ xValue .and. File(xValue)
                           cValue:=hb_MemoRead(xValue)
                        ElseIf "\" $ xValue .and. File(GetCurrentFolder()+xValue)
                           cValue:=hb_MemoRead(GetCurrentFolder()+xValue)
                        ElseIf (!Empty(cDbf) .and. IsDataGridMemo( nIdx, nPos )) .or. HMG_LOWER(xValue)=="<memo>"
                           aFields:=( ControlByIndex( NIDX ):CTRL040 [ 11 ])
                           cValue:=(&cDbf->&(aFields[nPos]))
                        Else
                           cValue:=xValue
                        Endif
                        Aadd(aValues,cValue)
                        Aadd(aFormats,64)
                EndCase
             Else
                If (!Empty(cDbf) .and. IsDataGridMemo( nIdx, nPos )) .or. HMG_LOWER(xValue)=="<memo>"
                   aFields := ( ControlByIndex( NIDX ):CTRL040 [ 11 ])
                   cValue:=(&cDbf->&(aFields[nPos]))
                   xValue:=cValue
                   Aadd(aFormats,64)
                Else
                   Aadd(aFormats,32)
                Endif
                Aadd(aValues,xValue)
             Endif

             Aadd(aCtrlsWidths,GetProperty(cForm,cGrid,"COLUMNWIDTH",nPos))
             Aadd(aJust,GetProperty(cForm,cGrid,"COLUMNJUSTIFY",nPos))

             If GetColumnHeaderSize(cForm,cGrid,"COLUMNHEADERWIDTH",aLabels[i]) > nLWidth
                nLWidth:=GetColumnHeaderSize(cForm,cGrid,"COLUMNHEADERWIDTH",aLabels[i])
             Endif
         Next
         aStyles[1,1]:=nLWidth
         aStyles[1,2]:=.T.
         aStyles[1,4]:=1
         If !lWidthCDefined
            aStyles[2,1]:=aCtrlsWidths
         Endif
         // DoMethod(cForm,cGrid,"UnableUpdate")
      Endif
   Endif
Endif

DEFAULT cTitle       := ""
DEFAULT aStyles[1,1] := 90
DEFAULT aStyles[1,2] := .F.
DEFAULT aStyles[1,4] := 0

OldScrollStep := oHmgApp():APP345

If ValType(aStyles[2,1])="A"
   If !(HMG_Len(aStyles[2,1])=HMG_Len(aLabels))
      ASize( aStyles[2,1], HMG_Len(aLabels) )
   Endif
   nCWidth := 0
   For i=1 To HMG_Len(aStyles[2,1])
       If ValType(aStyles[2,1,i]) = "U" // .or. aStyles[2,1,i] = 140
          If nCWidth > 140
             aStyles[2,1,i]:=nCWidth
          Else
             aStyles[2,1,i]:=140
          Endif
       Endif
       If aStyles[2,1,i] > nCWidth
          nCWidth := aStyles[2,1,i]
       Endif
   Next
ElseIf ValType(aStyles[2,1])="N"
   nCWidth:=aStyles[2,1]
Else
   nCWidth := 140
Endif

DEFAULT aStyles[2,2] := .F.

If ValType(aToolTips) == "U"
   aToolTips := Array( HMG_Len( aValues ) )
   aFill( aToolTips, "?" )
Else
   ASize( aToolTips, HMG_Len( aValues ) )
   AEval( aToolTips, { |x| x := iif( x == Nil, "", x ) } )
Endif

nLen := HMG_Len ( aLabels )
Private aResult[nLen]

If !(HMG_Len ( aValues ) == nLen .and. HMG_Len ( aFormats ) == nLen)
   MsgStop("Number of elements of arrays, doesn't match !"+CRLF+"It must be same size in:"+CRLF+CRLF+"aLabels["+AllTrim(Str(HMG_Len(aLabels)))+"], aValues["+AllTrim(Str(HMG_Len(aValues)))+"], aFormats["+AllTrim(Str(HMG_Len(aFormats)))+"]","Please correct your source code")
   Return aResult
Endif

For i := 1 to nLen    // Calculate Height Window according controls height
    lHidden:=.F.
    If ValType(aStyles[2,1])="A"
       nDiff:=aStyles[2,1,i]
    Else
       nDiff:=aStyles[2,1]
    Endif
    If "GRID" $ cControlType .and. i=1
       If lAtFirstImages
          lHidden:=.T.
       Endif
    Endif
    If nDiff == 0
       lHidden:=.T.
    Endif
    If lHidden
       Loop
    Endif

    Do Case
       Case ValType( aValues[i] ) == 'C' .and. ValType( aFormats[i] ) == 'N'
            If aFormats[i] > 32
               nH := nH + 94
            Else
               nH := nH + 30
            Endif
       Case ValType( aValues[i] ) == 'M'
            nH := nH + 94
       Case ValType( aValues[i] ) == 'A' .and. ValType( aFormats[i] ) == 'A' // Grids
            nH := nH + 94
       OtherWise
            nH := nH + 30
    EndCase
Next i

nR := nRow
nC := nCol
nH := nH + 90




nW := aStyles[1,1] + nCWidth + 50
nControlCol := aStyles[1,1] + 30

If nR + nH > GetDeskTopRealHeight()
   nDiff :=  nR + nH - GetDeskTopRealHeight()
   // nR := nR - nDiff
   DEFINE WINDOW _InputWindow AT nR, nC WIDTH nW HEIGHT (nH - nDiff);
       VIRTUAL HEIGHT nH VIRTUAL WIDTH nW+20 ;
       TITLE cTitle MODAL NOSIZE BackColor aBackColor ON RELEASE _InputWindowOnRelease(OldScrollStep,aHotKeys)

   SET SCROLLSTEP TO 20
Else
   DEFINE WINDOW _InputWindow AT nR, nC WIDTH nW HEIGHT nH ;
       TITLE cTitle MODAL NOSIZE BackColor aBackColor ON RELEASE _InputWindowOnRelease(OldScrollStep,aHotKeys)
EndIf

    For i := 1 To nLen

        LN := 'Label_' + AllTrim(Str(i,2,0))
        CN := 'Control_' + AllTrim(Str(i,2,0))
        lHidden:=.F.

        If ValType(aStyles[2,1])="A"
           nCWidth:=aStyles[2,1,i]
        Else
           nCWidth:=aStyles[2,1]
        Endif

        If ValType ( aCtrlsWhen ) = 'A'
           If HMG_Len ( aCtrlsWhen ) >= i
              If ValType ( aCtrlsWhen [i] ) = 'B'
                 oHmgApp():APP202 := i // This.QueryColIndex
                 oHmgApp():ThisItemColIndex := i // This.CellColIndex
                 oHmgApp():APP318 := GetProperty(cForm,cGrid,"CellEx",nGridRow,i) // This.CellValue

                 BEGIN SEQUENCE WITH {|oError| BREAK( oError ) }
                     lWhen := EVAL ( aCtrlsWhen [i] )
                 RECOVER USING oError
                     MsgStop("Error: "+(oError:Description)+CRLF+CRLF+"Please check COLUMNWHEN at column #"+AllTrim(Str(i))+CRLF+CRLF+'Tips: Do not use any "This.xxx" like This.CellValue, etc.'+CRLF+"         Use just .T. or .F.","Exemption edit aborted")
                 END SEQUENCE
              ElseIf ValType ( aCtrlsWhen [i] ) = 'L'
                 lWhen:=aCtrlsWhen [i]
              Else
                 lWhen:=.T.
              Endif
              If !ValType(lWhen)="L"
                 lWhen:=.T.
              Endif
           Endif
        Else
           lWhen:=.T.
        Endif

        If "GRID" $ cControlType .and. i=1
           If lCheckBoxEnabled
              lHidden:=.F.
           Else
              If lAtFirstImages
                 lHidden:=.T.
              Endif
           Endif
        Endif
        If nCWidth == 0
           lHidden:=.T.
        Endif

        If ValType(aJust)="A"
           lRightAlign:=If(aJust[i]=1,.T.,.F.)
        Else
           lRightAlign:=.F.
        Endif






        DEFINE LABEL    &(LN)
            PARENT      "_InputWindow"
            ROW         nControlRow
            COL         10
            VALUE       aLabels[i]
            WIDTH       aStyles[1,1]
            FONTBOLD    aStyles[1,2]
            BACKCOLOR   aBackColor
            FONTCOLOR   aStyles[1,3]
            RIGHTALIGN  If(aStyles[1,4]=1,.T.,.F.)
            CENTERALIGN If(aStyles[1,4]=2,.T.,.F.)
        END LABEL

        nDiff := 30
        cType1 := ValType ( aValues[i] )
        cType2 := ValType ( aFormats[i] )

        Do Case
           Case cType1 == 'L'





                DEFINE CHECKBOX &(CN)
                    PARENT      "_InputWindow"
                    ROW         nControlRow
                    COL         nControlCol
                    CAPTION     ""
                    VALUE       aValues[i]
                    WIDTH       nCWidth
                    FONTBOLD    aStyles[2,2]
                    TOOLTIP     aToolTips[i]
                    BACKCOLOR   aBackColor
                END CHECKBOX
           Case cType1 == 'D'
                /* Probably need to be reforced as logical when is not a grid
                If cType2 == "U"
                   aFormats[i]:=.T.




                Endif  */

                DEFINE DATEPICKER &(CN)
                    PARENT        "_InputWindow"
                    ROW           nControlRow
                    COL           nControlCol
                    WIDTH         nCWidth
                    FONTBOLD      aStyles[2,2]
                    TOOLTIP       aToolTips[i]
                    VALUE         aValues[i]
                    UPDOWN        aFormats[i]
                    RIGHTALIGN    lRightAlign
                    FORMAT        aFormats[i]
               If aFormats[i]=="  "
                   // ONCHANGE _InputWindowSetDtFormat("_InputWindow", CN)
                   ONCHANGE SetProperty ( ThisWindow.Name, This.Name, "FORMAT", HBtoWinDateFormat() )
                Endif
                END DATEPICKER

           Case cType1 == 'N'
                If cType2 == 'A'





                    DEFINE COMBOBOX &(CN)
                        PARENT      "_InputWindow"
                        ROW         nControlRow
                        COL         nControlCol
                        WIDTH       nCWidth
                        FONTBOLD    aStyles[2,2]
                        TOOLTIP     aToolTips[i]
                        ITEMS       aFormats[i]
                        VALUE       aValues[i]
                    END COMBOBOX
                ElseIf cType2 == 'C'
                   If hb_UAT ( '.' , aFormats[i] ) > 0





                        DEFINE TEXTBOX &(CN)
                            PARENT     "_InputWindow"
                            ROW        nControlRow
                            COL        nControlCol
                            VALUE      aValues[i]
                            WIDTH      nCWidth
                            INPUTMASK  CharOnly("0123456789.",aFormats[i])
                            FONTBOLD   aStyles[2,2]
                            TOOLTIP    aToolTips[i]
                            DATATYPE   NUMERIC
                            RIGHTALIGN lRightAlign
                        END TEXTBOX
                   Else






                        DEFINE TEXTBOX &(CN)
                            PARENT     "_InputWindow"
                            ROW        nControlRow
                            COL        nControlCol
                            VALUE      aValues[i]
                            WIDTH      nCWidth
                            INPUTMASK  aFormats[i]
                            FONTBOLD   aStyles[2,2]
                            TOOLTIP    aToolTips[i]
                            DATATYPE   NUMERIC
                            RIGHTALIGN lRightAlign
                        END TEXTBOX
                        // MAXLENGTH  HMG_Len(aFormats[i])
                   EndIf
                ElseIf cType2 == 'N'






                    DEFINE TEXTBOX &(CN)
                        PARENT     "_InputWindow"
                        ROW        nControlRow
                        COL        nControlCol
                        VALUE      aValues[i]
                        WIDTH      nCWidth
                        FONTBOLD   aStyles[2,2]
                        TOOLTIP    aToolTips[i]
                        MAXLENGTH  aFormats[i]
                        DATATYPE   NUMERIC
                        RIGHTALIGN lRightAlign
                    END TEXTBOX
                Endif
           Case cType1 == 'C'
                If cType2 == 'N'
                   If aFormats[i] <= 32






                        DEFINE TEXTBOX &(CN)
                            PARENT     "_InputWindow"
                            ROW        nControlRow
                            COL        nControlCol
                            VALUE      aValues[i]
                            WIDTH      nCWidth
                            FONTBOLD   aStyles[2,2]
                            TOOLTIP    aToolTips[i]
                            MAXLENGTH  aFormats[i]
                            DATATYPE   CHARACTER
                            RIGHTALIGN lRightAlign
                        END TEXTBOX
                   Else





                        DEFINE EDITBOX &(CN)
                            PARENT     "_InputWindow"
                            ROW        nControlRow
                            COL        nControlCol
                            VALUE      aValues[i]
                            WIDTH      nCWidth
                            HEIGHT     90
                            FONTBOLD   aStyles[2,2]
                            TOOLTIP    aToolTips[i]

                        END EDITBOX
                        // MAXLENGTH  aFormats[i]
                      nDiff := 94
                   EndIf
                ElseIf cType2 == 'A'
                       cTimeFormat:=CharRem("{}",hb_ValToExp(aFormats[i]))
                       cTimeFormat:=CharRem(Chr(34)+Chr(39),cTimeFormat)
                       cValue:=hb_ValToExp(aValues[i])
                       cValue:=CharRem(Chr(34)+Chr(39),cValue)







                        DEFINE TIMEPICKER &(CN)
                            PARENT        "_InputWindow"
                            ROW           nControlRow
                            COL           nControlCol
                            VALUE         aValues[i]
                            WIDTH         nCWidth
                            FONTBOLD      aStyles[2,2]
                            TOOLTIP       aToolTips[i]
                            FORMAT        cTimeFormat
                        END TIMEPICKER
                ElseIf cType2 == 'C'
                   If HMG_Upper(aFormats[i]) == 'PASSWORD'






                        DEFINE TEXTBOX  &(CN)
                            PARENT      "_InputWindow"
                            ROW         nControlRow
                            COL         nControlCol
                            VALUE       aValues[i]
                            WIDTH       nCWidth
                            FONTBOLD    aStyles[2,2]
                            TOOLTIP     aToolTips[i]
                            PASSWORD    .T.
                            FONTBOLD    aStyles[2,2]
                            TOOLTIP     aToolTips[i]
                            DATATYPE    CHARACTER
                            RIGHTALIGN  lRightAlign
                        END TEXTBOX
                    Else





                        DEFINE TEXTBOX &(CN)
                            PARENT     "_InputWindow"
                            ROW        nControlRow
                            COL        nControlCol
                            VALUE      aValues[i]
                            WIDTH      nCWidth
                            INPUTMASK  aFormats[i]
                            FONTBOLD   aStyles[2,2]
                            TOOLTIP    aToolTips[i]
                            DATATYPE   CHARACTER
                            RIGHTALIGN lRightAlign
                        END TEXTBOX
                    Endif
                Else






                    DEFINE LABEL    &(CN)
                        PARENT      "_InputWindow"
                        ROW         nControlRow
                        COL         nControlCol-20
                        VALUE       aLabels[i]
                        WIDTH       nCWidth+20
                        FONTBOLD    aStyles[1,2]
                        TOOLTIP     aToolTips[i]
                        BACKCOLOR   aBackColor
                        FONTCOLOR   aStyles[1,3]
                    END LABEL

                    nDiff := 20
                EndIf
           Case cType1 == 'M'





                DEFINE EDITBOX &(CN)
                    PARENT     "_InputWindow"
                    ROW        nControlRow
                    COL        nControlCol
                    FIELD      aValues[i]
                    WIDTH      nCWidth
                    HEIGHT     90
                    FONTBOLD   aStyles[2,2]
                    TOOLTIP    aToolTips[i]

                END EDITBOX
                // MAXLENGTH  aFormats[i]

                nDiff := 94
           Case cType1 == 'A'
                If cType2 == 'N'
                   /* aValues[i,3] (Incremental, new)
                      Used aValues in place of aFormats, due only available option in InputWindow to differentiate to others */







                    DEFINE SPINNER &(CN)
                        PARENT     "_InputWindow"
                        ROW        nControlRow
                        COL        nControlCol
                        RANGEMAX   aValues[i,1]
                        RANGEMIN   aValues[i,2]
                        VALUE      aFormats[i]
                        WIDTH      nCWidth
                        FONTBOLD   aStyles[2,2]
                        TOOLTIP    aToolTips[i]
                        INCREMENT  aValues[i,3]
                    END SPINNER
                Else






                    DEFINE GRID        &(CN)
                        PARENT         "_InputWindow"
                        ROW            nControlRow
                        COL            nControlCol
                        WIDTH          nCWidth
                        HEIGHT         90
                        FONTBOLD       aStyles[2,2]
                        TOOLTIP        aToolTips[i]
                        ITEMS          aValues[i]
                        HEADERS        aFormats[i,1]
                        WIDTHS         aFormats[i,2]
                        ALLOWEDIT      .T.
                        MULTISELECT    .F.
                        CELLNAVIGATION .T.
                    END GRID
                    nDiff := 94
                Endif
        EndCase
        If !lWhen
           SetProperty("_InputWindow",CN,"Enabled",lWhen)
        Endif
        If lHidden
           DoMethod("_InputWindow",LN,"Hide")
           DoMethod("_InputWindow",CN,"Hide")
        Else
           nControlRow += nDiff
        Endif
    Next i
    If "GRID" $ cControlType
       CN := 'Control_' + AllTrim(Str(_GridEx_GetColumnDisplayPosition(cGrid, cForm, nGridCol)+If(lCheckBoxEnabled,1,0),2,0))
       DoMethod("_InputWindow",CN,"SetFocus")
       If nEditOption > 0 .and. "TEXT" $ HMG_Upper(GetControlType(CN,"_InputWindow"))
          _InplaceEditOpt("_InputWindow", CN, nEditOption)
       Endif
    Endif
    @ nControlRow + 10, nW / 2 - 110 BUTTON BUTTON_1   ;
        OF _InputWindow                                ;
        CAPTION oHmgApp():APP128 [8]               ;
        ACTION _InputWindowOk()

    @ nControlRow + 10, nW / 2 BUTTON BUTTON_2         ;
        OF _InputWindow                                ;
        CAPTION oHmgApp():APP128 [7]               ;
        ACTION _InputWindowCancel()

    nLen := HMG_Len ( aHotKeys )
    For i := 1 To nLen
        _DefineHotKey ( "_InputWindow", aHotKeys[i,1], aHotKeys[i,2], aHotKeys[i,3] )
    Next

    If ValType(_GetHotKey( "_InputWindow", 0, VK_ESCAPE ))="U"
       _DefineHotKey ( "_InputWindow",  0, VK_ESCAPE, {|| ThisWindow.Release() } )
    Endif

    If ValType(bCode)='B'
       Eval(bCode)
    Endif

END WINDOW
If nRow = 0 .or. nCol = 0
   CENTER WINDOW _InputWindow
EndIf
If nRow > 0
   _InputWindow.Row := nR
Endif
If nCol > 0
   _InputWindow.Col := nC
Endif
ACTIVATE WINDOW _InputWindow
Return aResult


Procedure _InputWindowSetDtFormat(cForm, cControl, cDtFormat)   // By Pablo César on June 26th, 2015
   hb_default( @cDtFormat, HBtoWinDateFormat() )
   SetProperty ( cForm, cControl, "FORMAT", cDtFormat )
Return


FUNCTION HBtoWinDateFormat()   // By Pablo César on June 26th, 2015
Local cDateFormat := HMG_LOWER( SET( _SET_DATEFORMAT ) )
RETURN CharRepl ("m", @cDateFormat, "M")   // this transform is need for internal structure of date format of MonthCal/DatePick controls


Function _InputWindowOnRelease(OldScrollStep,aHotKeys)  // By Pablo on June 26th, 2015
Local i, nLen := HMG_Len ( aHotKeys )

SET SCROLLSTEP TO OldScrollStep

For i := 1 To nLen
    _ReleaseHotKey ( "_InputWindow", aHotKeys[i,1], aHotKeys[i,2] )
Next

If ValType(_GetHotKey( "_InputWindow", 0, VK_ESCAPE ))="U"
   _ReleaseHotKey ( "_InputWindow", 0, VK_ESCAPE )
Endif
Return Nil


Function GetColumnHeaderSize(Arg1, Arg2, Arg3, Arg4)  // By Pablo César on June 26th, 2015 (function renamed, was My_GeProperty)
Local nRet:=0, hGrid, hHeader, hFont

hGrid := GetControlHandle(Arg2, Arg1)
hHeader := ListView_GetHeader ( hGrid )
hFont := SendMessage (hHeader, WM_GETFONT, 0, 0)
Do Case
   Case HMG_Upper(Arg3) == "COLUMNHEADERWIDTH"
        nRet := GetTextWidth(NIL, Arg4, hFont)
   Case HMG_Upper(Arg3) == "COLUMNHEADERHEIGHT"
        nRet := GetTextHeight(NIL, Arg4, hFont)
EndCase
Return nRet


Function SetMethodCode( cForm, cControl, cMethod, bCode )  // By Pablo César on June 26th, 2015 (not renamed because is known by Minigui users)
Local nIndex:=GetControlIndex( cControl, cForm )
Local cControlType:=GetControlTypeByIndex (nIndex)

Do Case
   Case nIndex=0
   Case cControlType = "COMBO"
        Do Case
           Case cMethod='DISPLAYCHANGE'
                ControlByIndex( NINDEX ):CTRL006 :=  bCode
           Case cMethod='LISTDISPLAY'
                // _HMG_aControlInputMask [nIndex] := bCode
           Case cMethod='LOSTFOCUS'
                ControlByIndex( NINDEX ):CTRL010 :=  bCode
           Case cMethod='GOTFOCUS'
                ControlByIndex( NINDEX ):CTRL011 :=  bCode
           Case cMethod='CHANGE'
                ControlByIndex( NINDEX ):CTRL012 :=  bCode
           Case cMethod='ENTER'
                ControlByIndex( NINDEX ):CTRL016 :=  bCode
           Case cMethod='LISTCLOSE'
                // _HMG_aControlPicture[nIndex] :=  bCode
        EndCase
   Case cControlType = "TEXT" .or. cControlType = "NUMTEXT" .or. cControlType = "MASKEDTEXT"
        Do Case
           Case cMethod='LOSTFOCUS'
                ControlByIndex( NINDEX ):CTRL010 :=  bCode
                SetProperty(cForm, cControl, cMethod, bCode)
           Case cMethod='GOTFOCUS'
                ControlByIndex( NINDEX ):CTRL011 :=  bCode
           Case cMethod='CHANGE'
                ControlByIndex( NINDEX ):CTRL012 :=  bCode
           Case cMethod='ENTER'
                ControlByIndex( NINDEX ):CTRL016 :=  bCode
        Endcase
   Case cControlType = "EDIT"
        Do Case
           Case cMethod='LOSTFOCUS'
                ControlByIndex( NINDEX ):CTRL010 :=  bCode
           Case cMethod='GOTFOCUS'
                ControlByIndex( NINDEX ):CTRL011 :=  bCode
           Case cMethod='CHANGE'
                ControlByIndex( NINDEX ):CTRL012 :=  bCode
        EndCase
   Case cControlType = "DATEPICK"
        Do Case
           Case cMethod='LOSTFOCUS'
                ControlByIndex( NINDEX ):CTRL010 :=  bCode
           Case cMethod='GOTFOCUS'
                ControlByIndex( NINDEX ):CTRL011 :=  bCode
           Case cMethod='CHANGE'
                ControlByIndex( NINDEX ):CTRL012 :=  bCode
           Case cMethod='ENTER'
                ControlByIndex( NINDEX ):CTRL006 :=  bCode
        EndCase
   Case cControlType = "CHECKBOX"
        Do Case
           Case cMethod='LOSTFOCUS'
                ControlByIndex( NINDEX ):CTRL010 :=  bCode
           Case cMethod='GOTFOCUS'
                ControlByIndex( NINDEX ):CTRL011 :=  bCode
           Case cMethod='CHANGE'
                ControlByIndex( NINDEX ):CTRL012 :=  bCode
           Case cMethod='ENTER'
                ControlByIndex( NINDEX ):CTRL006 := bCode
        EndCase
   Case cControlType = "GRID"
        Do Case
           Case cMethod='LOSTFOCUS'
                ControlByIndex( NINDEX ):CTRL010 :=  bCode
           Case cMethod='GOTFOCUS'
                ControlByIndex( NINDEX ):CTRL011 :=  bCode
           Case cMethod='CHANGE'
                ControlByIndex( NINDEX ):CTRL012 :=  bCode
           Case cMethod='ENTER'
                ControlByIndex( NINDEX ):CTRL016 := .T.
        EndCase
EndCase
DO Events
Return Nil


Function _InplaceEditOpt(Arg1, Arg2, nInplaceEditOption)
Local nCtrlHnd:=GetControlHandle(Arg2, Arg1)

If nInplaceEditOption == 2
   _PushKey (VK_END)
ElseIf nInplaceEditOption == 3
   SendMessage (nCtrlHnd, WM_KEYDOWN, VK_END, 0)
   SendMessage (nCtrlHnd, WM_KEYUP,   VK_END, 0)
   HMG_SendCharacterEx (nCtrlHnd, HMG_GetLastCharacterEx())
   _PushKey (VK_END)
ElseIf nInplaceEditOption == 4
   //_PushKey (VK_BACK)
   HMG_SendCharacter (nCtrlHnd, HMG_GetLastCharacterEx())
Endif
Return Nil


Function _InputWindowOk()
Local i, r, c, nRowCount, nColCount, cControlName, l, aTemp, aTupla

l := HMG_Len (aResult)
For i := 1 to l
    cControlName := 'Control_' + AllTrim(Str(i,2,0))
    If GetControlType (cControlName,'_InputWindow')="GRID"
       aTemp:={}
       nRowCount:=GetProperty("_InputWindow",cControlName,"ItemCount")
       nColCount:=_GridEx_ColumnCount ( cControlName,'_InputWindow' )
       For r=1 To nRowCount
           aTupla:={}
           For c=1 To nColCount
               Aadd(aTupla,_GridEx_GetCellValue (cControlName, '_InputWindow', r, c))
           Next
           Aadd(aTemp,aTupla)
       Next
       aResult [i] := aTemp
    Else
       aResult [i] := _GetValue ( cControlName, '_InputWindow' )
    Endif
Next i
RELEASE WINDOW _InputWindow
Return Nil


Function _InputWindowCancel()
AEval( aResult, {|x, i| HB_SYMBOL_UNUSED( x ), aResult [i] := Nil } )
RELEASE WINDOW _InputWindow
Return Nil

/*****************************************************************************************************************/


Function _ReleaseControl ( ControlName, ParentForm )
Local i , t , r , w , z , x , y , k, oControlX

i := GetControlIndex ( ControlName, ParentForm )
t := GetControlType ( ControlName, ParentForm )
k := GetFormIndex (ParentForm)

Do Case
    Case t == "GRID"

        ReleaseControl ( ControlByIndex( i ):Handle )

    Case t == "ANIMATEBOX"
        _DestroyAnimateBox ( ControlName , ParentForm )

    Case t == "PLAYER"
        _DestroyPlayer ( ControlName , ParentForm )

    Case t == "SPINNER"
        ReleaseControl ( ControlByIndex( i ):Handle [1] )
        ReleaseControl ( ControlByIndex( i ):Handle [2] )

    Case t == "STATUSBAR"
        if _IsControlDefined ( 'StatusTimer' , ParentForm )
            ReleaseControl ( ControlByIndex( GetControlIndex ( 'StatusTimer' , ParentForm) ):Handle )
            _EraseControl ( GetControlIndex ( 'StatusTimer' , ParentForm ) , k )
        endif

        if _IsControlDefined ( 'StatusKeyBrd' , ParentForm )
            ReleaseControl ( ControlByIndex( GetControlIndex ( 'StatusKeyBrd' , ParentForm ) ):Handle )
            _EraseControl ( GetControlIndex ( 'StatusKeyBrd' , ParentForm ) , k )
        endif

        ReleaseControl ( ControlByIndex( i ):Handle )

    #ifdef COMPILEBROWSE

    Case t == "BROWSE"

        ReleaseControl ( ControlByIndex( i ):Handle )

        if ControlByIndex( I ):CTRL005 != 0

            ReleaseControl ( ControlByIndex( I ):CTRL005 )
            ReleaseControl ( ControlByIndex( I ):CTRL039 [1])

        endif

    #endif

    Case t == "RADIOGROUP"

        For x:= 1 To HMG_LEN( ControlByIndex( i ):Handle )
             ReleaseControl ( ControlByIndex( i ):Handle [x] )
        Next x

    Case t == "TAB"

        for r = 1 to HMG_LEN ( ControlByIndex( I ):CTRL007 )
            for w = 1 to HMG_LEN (ControlByIndex( I ):CTRL007 [r])
                if valtype ( ControlByIndex( I ):CTRL007 [r] [w] ) <> "A"
                    ReleaseControl ( ControlByIndex( I ):CTRL007 [r] [w] )
                    oControlX := ControlByHandle( ControlByIndex( I ):CTRL007 [r] [w] )
                    x := iif( oControlX == Nil, 0, oControlX:Handle )
                    if x > 0
                        _EraseControl(x,k)
                    EndIf
                            else
                    for z = 1 to HMG_LEN ( ControlByIndex( I ):CTRL007 [r] [w] )
                                            ReleaseControl ( ControlByIndex( I ):CTRL007 [r] [w] [z] )
                        Next z

                    For x := 1 To oHmgApp():ControlCount
                        If ValType( ControlByIndex( x ):Handle ) == 'A'
                            If ControlByIndex( x ):Handle [1] == ControlByIndex( I ):CTRL007 [r] [w] [1]
                                _EraseControl(x,k)
                                Exit
                            EndIf
                        EndIf
                    Next x

                endif
            Next w
        Next r

        ReleaseControl ( ControlByIndex( i ):Handle )

OtherWise
    ReleaseControl ( ControlByIndex( i ):Handle )
EndCase

// If the control is inside a TAB, PageMap must be updated

For y := 1 To oHmgApp():COntrolCount

    if ControlByIndex( y ):Type == "TAB"

        for r = 1 to HMG_LEN ( ControlByIndex( Y ):CTRL007 )

            for w = 1 to HMG_LEN (ControlByIndex( Y ):CTRL007 [r])

                if t == 'RADIOGROUP'

                        if ValType (ControlByIndex( Y ):CTRL007 [r] [w]) == 'A'

                        if ControlByIndex( Y ):CTRL007 [r] [w] [1] == ControlByIndex( i ):Handle [1]

                            adel ( ControlByIndex( Y ):CTRL007 [r] , w )
                            asize ( ControlByIndex( Y ):CTRL007 [r] , HMG_LEN(ControlByIndex( Y ):CTRL007 [r])-1 )
                            Exit

                        EndIf

                    EndIf

                Elseif t == 'SPINNER'

                        if ValType (ControlByIndex( Y ):CTRL007 [r] [w]) == 'A'

                        if ControlByIndex( Y ):CTRL007 [r] [w] [1] == ControlByIndex( i ):Handle [1]

                            adel ( ControlByIndex( Y ):CTRL007 [r] , w )
                            asize ( ControlByIndex( Y ):CTRL007 [r] , HMG_LEN(ControlByIndex( Y ):CTRL007 [r])-1 )
                            Exit

                        EndIf

                    EndIf

                #ifdef COMPILEBROWSE

                Elseif t == 'BROWSE'

                        if ValType (ControlByIndex( Y ):CTRL007 [r] [w]) == 'A'

                        if ControlByIndex( Y ):CTRL007 [r] [w] [1] == ControlByIndex( i ):Handle

                            adel ( ControlByIndex( Y ):CTRL007 [r] , w )
                            asize ( ControlByIndex( Y ):CTRL007 [r] , HMG_LEN(ControlByIndex( Y ):CTRL007 [r])-1 )
                            Exit

                        EndIf

                        Elseif ValType (ControlByIndex( Y ):CTRL007 [r] [w]) == 'N'

                        if ControlByIndex( Y ):CTRL007 [r] [w] == ControlByIndex( i ):Handle

                            adel ( ControlByIndex( Y ):CTRL007 [r] , w )
                            asize ( ControlByIndex( Y ):CTRL007 [r] , HMG_LEN(ControlByIndex( Y ):CTRL007 [r])-1 )
                            Exit

                        EndIf


                    EndIf

                #endif

                Else

                        if ValType (ControlByIndex( Y ):CTRL007 [r] [w]) == 'N'

                        if ControlByIndex( Y ):CTRL007 [r] [w] == ControlByIndex( i ):Handle

                            adel ( ControlByIndex( Y ):CTRL007 [r] , w )
                            asize ( ControlByIndex( Y ):CTRL007 [r] , HMG_LEN(ControlByIndex( Y ):CTRL007 [r])-1 )
                            Exit

                        EndIf

                    EndIf

                EndIf

            Next w

        next r

    EndIf

Next y
_EraseControl(i,k)
Return Nil

Function _EraseControl (i, nParentIndex)
Local mVar, oControlI

// i = nControlIndex
// nParentIndex (nFormIndex)

DeleteObject ( ControlByIndex( I ):CTRL036 )
DeleteObject ( ControlByIndex( I ):CTRL037 )

if IsAppThemed() .and. ( ControlByIndex( i ):Type == 'BUTTON' .Or. ControlByIndex( i ):Type == 'CHECKBOX' )
    IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL037 )
EndIf

if ControlByIndex( i ):Type == 'GRID' .Or. ControlByIndex( i ):Type == 'MULTIGRID'
    if ValType ( ControlByIndex( I ):CTRL026 ) == 'N'
        IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL026 )
    EndIf
    IF ControlByIndex( I ):CTRL040 [42] <> 0   // hFont_Dynamic
       DeleteObject ( ControlByIndex( I ):CTRL040 [42] )
    ENDIF
EndIf

#ifdef COMPILEBROWSE
      if ControlByIndex( i ):Type == 'BROWSE'
         if ValType ( ControlByIndex( I ):CTRL039 [10] ) == 'N'
            IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL039 [10] )
         EndIf
      EndIf
#endif

if ControlByIndex( i ):Type == 'COMBO'
    if ValType ( ControlByIndex( I ):CTRL015 ) == 'N'
        IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL015 )
    EndIf
EndIf

if ControlByIndex( i ):Type == 'ACTIVEX'
    DestroyWindow ( ControlByIndex( i ):Type )
    FreeLibrary ( ControlByIndex( I ):CTRL035 )
EndIf

if ControlByIndex( i ):Type == 'HOTKEY'
    ReleaseHotKey ( ControlByIndex( I ):ParentFormHandle , ControlByIndex( I ):CTRL005 )
EndIf

if ControlByIndex( i ):Type == 'TAB'
    If ControlByIndex( I ):CTRL009 != 0
        IMAGELIST_DESTROY ( ControlByIndex( I ):CTRL009 )
    EndIf
EndIf

mVar := '_' + FormByIndex( nParentIndex ):Name + '_' + ControlByIndex( i ):Name
if type ( mVar ) != 'U'
    __MVPUT ( mVar , 0 )
EndIf

oControlI := ControlByIndex( I )
WITH OBJECT oControlI
ControlByIndex( I ):IsDeleted := .T.
   :Type := ""
   :Name := ""
   :Handle := 0
   :ParentFormHandle := 0
   :CTRL005 := 0
   :CTRL006 := ""
   :CTRL007 := {}
   :CTRL008 := Nil
   :CTRL009 := ""
   :CTRL010 := ""
   :CTRL011 := ""
   :CTRL012 := ""
   :CTRL014 := Nil
   :CTRL015 := Nil
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
   :CTRL034 := .f.
   :CTRL035 := 0
   :CTRL036 := 0
   :CTRL029 := {}
   :CTRL037 := 0
   :CTRL038 := .F.
   :CTRL039 := 0
   :CTRL040 := NIL
ENDWITH

oControlI:StopEventProcedure := .F.
Return Nil

Function _IsControlVisibleFromHandle (Handle)
Local x
Local lVisible := .f.

For x := 1 To oHmgApp():ControlCount

    If ValType ( ControlByIndex( x ):Handle ) == 'N'

        If ControlByIndex( x ):Handle == Handle
            lVisible := ControlByIndex( X ):CTRL034
            Exit
        EndIf

    ElseIf ValType ( ControlByIndex( x ):Handle ) == 'A'

        If ControlByIndex( x ):Handle [1] == Handle
            lVisible := ControlByIndex( X ):CTRL034
            Exit
        EndIf

    EndIf

Next x
Return lVisible

Function _IsControlVisible ( ControlName , FormName)
Local lVisible, ix

lVisible := .f.

ix := GetControlIndex ( ControlName, FormName )

if ix > 0
   lVisible := ControlByIndex( IX ):CTRL034
endif
Return lVisible


Function _SetCaretPos ( ControlName , FormName , Pos )
Local i
   i := GetControlIndex ( ControlName, FormName )
   if i == 0 .OR. ValType( Pos ) <> "N"
      Return Nil
   EndIf
   IF Pos == -1
      Pos := GetProperty ( FormName, ControlName, "GetTextLength" )   // ADD August 2015
   ENDIF
   SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , Pos , Pos )
   SendMessage( ControlByIndex( i ):Handle , EM_SCROLLCARET , 0 , 0 )   // ADD August 2015
Return Nil


Function _GetCaretPos ( ControlName , FormName )
Local i, nStart, nEnd
i := GetControlIndex ( ControlName, FormName )
If i == 0
   Return 0
EndIf
// Dr. Claudio Soto (July 2013)
HMG_SendMessage ( ControlByIndex( i ):Handle, EM_GETSEL, @nStart, @nEnd )   // This functions supports huge text
Return nEnd

Function _GetId()

   Local RetVal , i, xTmp

   do while .t.

       RetVal := random (65000)

       xTmp := ControlByBlock( { | e | ValType( e:CTRL005 ) == "N" .AND. e:CTRL005 == retval } )
       i := iif( xTmp == Nil, 0, xTmp:Index )

       if i == 0 .and. retval != 0
           exit
       EndIf

   EndDo

   Return RetVal

FUNCTION Random( nLimit )
__THREAD STATIC snRandom := Nil
Local nDecimals, cLimit

DEFAULT snRandom TO Seconds() / Exp(1)
DEFAULT nLimit   TO 65535

snRandom  := Log( snRandom + Sqrt(2) ) * Exp(3)
snRandom  := Val( STR(snRandom - Int(snRandom), 17, 15 ) )
cLimit    := Transform( nLimit, "@N" )

nDecimals := HB_UAT(".", cLimit)

if nDecimals > 0
   nDecimals := HMG_LEN(cLimit)-nDecimals
endif
Return Round( nLimit * snRandom, nDecimals )

Function _dummy()
return nil


********************************************************************************

// by Pablo César (April 2014)


Function cFileDrive( cFileMask )
Local cDrive
// hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL,   NIL,    NIL,   @cDrive )
Return cDrive


Function cFilePath( cFileMask )
Local cDir
// hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, @cDir, NIL,    NIL,   NIL     )
Return HB_ULEFT ( cDir, HMG_LEN( cDir ) - 1 )


Function cFileNoExt( cFileMask )
Local cName
// hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL,   @cName, NIL,   NIL     )
Return cName


Function cFileNoPath( cFileMask )
Local cName, cExt
// hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL,   @cName, @cExt, NIL )
Return ( cName + cExt )


Function cFileExt ( cFileMask )
Local cExt
// hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL,   NIL,    @cExt, NIL )
Return ( cExt )


/*
Function cFileNoPath( cPathMask )
Local n := HB_UTF8RAT( "\", cPathMask )

Return If( n > 0 .and. n < HMG_LEN( cPathMask ), ;
        HB_URIGHT( cPathMask, HMG_LEN( cPathMask ) - n ), ;
        If( ( n := HB_UAT( ":", cPathMask ) ) > 0, ;
        HB_URIGHT( cPathMask, HMG_LEN( cPathMask ) - n ), cPathMask ) )

Function cFileNoExt( cPathMask )
Local cName := ALLTRIM( cFileNoPath( cPathMask ) )
Local n     := HB_UAT( ".", cName )

Return ALLTRIM( If( n > 0, HB_ULEFT( cName, n - 1 ), cName ) )
*/

********************************************************************************

Function _Refresh(i)
Local ControlHandle, k
If ControlByIndex( i ):Type == 'COMBO'
    _DataComboRefresh (i)

ElseIf ControlByIndex( i ):Type == 'TEXT' .Or. ControlByIndex( i ):Type == 'NUMTEXT'  .Or. ControlByIndex( i ):Type == "CHARMASKTEXT"  .Or. ControlByIndex( i ):Type == "MASKEDTEXT"
    _DataTextBoxRefresh (i)

ElseIf ControlByIndex( i ):Type == 'DATEPICK'
    _DataDatePickerRefresh (i)

ElseIf ControlByIndex( i ):Type == 'TIMEPICK'   // ( Dr. Claudio Soto, April 2013 )
   _DataTimePickerRefresh (i)

ELseIf ControlByIndex( i ):Type == 'EDIT'
    _DataEditBoxRefresh (i)

ELseIf ControlByIndex( i ):Type == 'CHECKBOX'
    _DataCheckBoxRefresh (i)

#ifdef COMPILEBROWSE

ELseIf ControlByIndex( i ):Type == 'BROWSE'
    _BrowseRefresh ('','',i)

#endif

ELseIf ControlByIndex( i ):Type == 'GRID'

    IF VALTYPE ( ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C'   // Grid with cRecordSource ( DataBase )
        DataGridRefresh( i, .T. )   // ADD .T. parameter (May 2016)
    ENDIF

ELseIf ControlByIndex( i ):Type == 'MULTIGRID'
    // _HMG_DOGRIDREFRESH(I)

EndIf

// ( Dr. Claudio Soto, May 2013 )
ControlHandle := ControlByIndex( i ):Handle
IF ValType (ControlHandle) == "A"
   FOR k = 1 TO HMG_LEN (ControlHandle)
       RedrawWindow ( ControlHandle [k])
   NEXT
ELSE
  RedrawWindow ( ControlHandle )
ENDIF
Return Nil


Function _RedrawControl (ControlName,ParentForm)   // ( Dr. Claudio Soto, July 2014 )
Local ControlHandle, k, i
   i := GetControlIndex (ControlName,ParentForm)
   ControlHandle := ControlByIndex( i ):Handle
   IF ValType (ControlHandle) == "A"
      FOR k = 1 TO HMG_LEN (ControlHandle)
         RedrawWindow ( ControlHandle [k])
      NEXT
   ELSE
      RedrawWindow ( ControlHandle )
   ENDIF
Return Nil


Function _SaveData (ControlName,ParentForm)
Local I

i := GetControlIndex ( ControlName , ParentForm )
If ControlByIndex( i ):Type == 'TEXT' .Or. ControlByIndex( i ):Type == 'NUMTEXT'  .Or. ControlByIndex( i ):Type == "CHARMASKTEXT"  .Or. ControlByIndex( i ):Type == "MASKEDTEXT"
    _DataTextBoxSave ( ControlName , ParentForm )
ELseIf ControlByIndex( i ):Type == 'DATEPICK'
    _DataDatePickerSave ( ControlName , ParentForm )
ELseIf ControlByIndex( i ):Type == 'TIMEPICK'   // ( Dr. Claudio Soto, April 2013 )
   _DataTimePickerSave ( ControlName , ParentForm )
ELseIf ControlByIndex( i ):Type == 'EDIT'
    _DataEditBoxSave ( ControlName , ParentForm )
ELseIf ControlByIndex( i ):Type == 'CHECKBOX'
    _DataCheckBoxSave ( ControlName , ParentForm )
ELseIf ControlByIndex( i ):Type == 'GRID'
    DataGridSave ( i )
EndIf
Return Nil

Function _GetFocusedControl ( cFormName )
Local nFormHandle , i , nFocusedControlHandle , nControlCount , cRetVal , x

nFormHandle     := GetFormHandle ( cFormName )
nFocusedControlHandle   := GetFocus()
nControlCount       := oHmgApp():ControlCount

If nFocusedControlHandle != 0

    For i := 1 To nControlCount

        If ControlByIndex( I ):ParentFormHandle ==  nFormHandle
            If ValType ( ControlByIndex( i ):Handle ) == 'N'
                If ControlByIndex( i ):Handle == nFocusedControlHandle .OR. (ControlByIndex( i ):Type == "COMBO" .AND. ControlByIndex( I ):CTRL031 == nFocusedControlHandle)   // ADD
                    cRetVal := ControlByIndex( i ):Name
                EndIf
            ElseIf ValType ( ControlByIndex( i ):Handle ) == 'A'
                For x := 1 To HMG_LEN ( ControlByIndex( i ):Handle )
                    If ControlByIndex( i ):Handle [x] == nFocusedControlHandle
                        cRetVal := ControlByIndex( i ):Name
                        Exit
                    EndIf
                Next x
            EndIf
        EndIf

        If ! Empty ( cRetVal )
            Exit
        EndIf

    Next i

Else

    cRetVal := ''

EndIf
Return cRetVal

Function _SetFontColor ( ControlName, ParentForm , Value  )
Local i

if value[1] == Nil .or. value[2] == Nil .or. value[3] == Nil
    Return Nil
EndIf

i := GetControlIndex ( ControlName, ParentForm )

If  ControlByIndex( i ):Type == 'GRID' .or. ControlByIndex( i ):Type == 'MULTIGRID'  .or. ControlByIndex( i ):Type == 'BROWSE'
    ListView_SetTextColor ( ControlByIndex( i ):Handle, value[1] , value[2] , value[3] )
    RedrawWindow ( ControlByIndex( i ):Handle )

ElseIf ControlByIndex( i ):Type == 'PROGRESSBAR'
    ControlByIndex( I ):CTRL015 := Value
    SetProgressBarBarColor(ControlByIndex( i ):Handle,value[1],value[2],value[3])

Else
    ControlByIndex( I ):CTRL015 := Value
    RedrawWindow ( ControlByIndex( i ):Handle )
EndIf
Return Nil

Function _SetBackColor ( ControlName, ParentForm , Value  )
Local i , f
Local ControlHandle , k

if value[1] == Nil .or. value[2] == Nil .or. value[3] == Nil
    Return Nil
EndIf

i := GetControlIndex ( ControlName, ParentForm )

If ControlByIndex( i ):Type == 'SLIDER'

    ControlByIndex( I ):CTRL014 := Value
    RedrawWindow ( ControlByIndex( i ):Handle )
    f := GetFocus()
    setfocus(ControlByIndex( i ):Handle)
    setfocus(f)

ElseIf  ControlByIndex( i ):Type == 'GRID' .or. ControlByIndex( i ):Type == 'MULTIGRID' .or. ControlByIndex( i ):Type == 'BROWSE'

    ListView_SetBkColor ( ControlByIndex( i ):Handle, value[1] , value[2] , value[3] )
    ListView_SetTextBkColor ( ControlByIndex( i ):Handle, value[1] , value[2] , value[3] )
    RedrawWindow ( ControlByIndex( i ):Handle )

ElseIf  ControlByIndex( i ):Type == 'RICHEDIT'

    SendMessage ( ControlByIndex( i ):Handle , EM_SETBKGNDCOLOR  , 0 , RGB ( value[1] , value[2] , value[3] ) )

    RedrawWindow ( ControlByIndex( i ):Handle )

ElseIf ControlByIndex( i ):Type == 'PROGRESSBAR'
    ControlByIndex( I ):CTRL014 := Value
    SetProgressBarBkColor(ControlByIndex( i ):Handle,value[1],value[2],value[3])

Else

    ControlByIndex( I ):CTRL014 := Value
    ControlHandle := ControlByIndex( i ):Handle
    IF ValType (ControlHandle) == "A"
       FOR k = 1 TO HMG_LEN (ControlHandle)
           RedrawWindow ( ControlHandle [k])
       NEXT
    ELSE
       RedrawWindow ( ControlHandle )
    ENDIF

EndIf
Return Nil

Function _GetFontColor ( ControlName, ParentForm )
Local i , RetVal := { Nil , Nil , Nil } , Tmp

i := GetControlIndex ( ControlName, ParentForm )

If  ControlByIndex( i ):Type == 'GRID' .or. ControlByIndex( i ):Type == 'MULTIGRID'  .or. ControlByIndex( i ):Type == 'BROWSE'
    Tmp := ListView_GetTextColor ( ControlByIndex( i ):Handle )
    RetVal [1] := GetRed (Tmp)
    RetVal [2] := GetGreen (Tmp)
    RetVal [3] := GetBlue (Tmp)
Else
    RetVal := ControlByIndex( I ):CTRL015
EndIf
Return RetVal

Function _GetBackColor ( ControlName, ParentForm )
Local i , RetVal := { Nil , Nil , Nil } , Tmp

i := GetControlIndex ( ControlName, ParentForm )

If  ControlByIndex( i ):Type == 'GRID' .or. ControlByIndex( i ):Type == 'MULTIGRID'  .or. ControlByIndex( i ):Type == 'BROWSE'
    Tmp := ListView_GetBkColor ( ControlByIndex( i ):Handle )
    RetVal [1] := GetRed (Tmp)
    RetVal [2] := GetGreen (Tmp)
    RetVal [3] := GetBlue (Tmp)
Else
    RetVal := ControlByIndex( I ):CTRL014
EndIf
Return RetVal

Function _IsControlEnabled ( ControlName, ParentForm )
Local i , t , RetVal

i := GetControlIndex ( ControlName, ParentForm )
t := GetControlType  ( ControlName, ParentForm )

if t == 'MENU'
    RetVal := _IsMenuItemEnabled ( ControlName, ParentForm )
Else
    RetVal := ControlByIndex( I ):CTRL038
EndIf
Return RetVal

Function _SetStatusIcon( ControlName , ParentForm , nItem , cIcon, hIcon )
Local i := GetControlIndex ( ControlName , ParentForm )
SetStatusItemIcon( ControlByIndex( i ):Handle , nItem - 1 , cIcon , hIcon )
Return Nil

Function _GetCaption( ControlName , ParentForm )
Local i
Local cRetVal := ''

i := GetControlIndex ( ControlName , ParentForm )

If ControlByIndex( i ):Type == 'TOOLBUTTON'
    cRetVal := ControlByIndex( I ):CTRL033
Else
    cRetVal := GetWindowText ( ControlByIndex( i ):Handle )
EndIf
Return cRetVal

FUNCTION _GetControlFree()

   LOCAL k, oControl

   oControl := ControlByBlock( { | e | e:IsDeleted } )
   k := iif( oControl == Nil, 0, oControl:Index )

   if k == 0
      k := oHmgApp():ControlCount + 1
      oControl := oHmgApp():AddControl()
      IF k != oControl:Index
         MsgBox( "h_ControlMisc.prg, _GetControlFree(), line 4777 wrong index" )
      ENDIF

   EndIf

   RETURN k

Function httpconnect( Connection , Server , Port )
Connection := NIL   // ADD
Server     := NIL   // ADD
Port       := NIL   // ADD
Return Nil

Function _SetAddress ( ControlName , ParentForm , url )
Local i

i := GetControlIndex ( ControlName , ParentForm )

if i > 0

    if HB_UAT("@",url)>0

        ControlByIndex( I ):CTRL006 := {||ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler mailto:"+url, ,1)}
        ControlByIndex( I ):CTRL008 := url

    elseif HB_UAT("http",url)>0

        ControlByIndex( I ):CTRL006 := {||ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + url, ,1)}
        ControlByIndex( I ):CTRL008 := url

    else

        MsgHMGError ("Control: " + ControlName + " must have valid email or url defined. Program Terminated")

    EndIf

EndIf
Return Nil

Function _GetAddress ( ControlName , ParentForm )
Local i , RetVal := ''

i := GetControlIndex ( ControlName , ParentForm )

if i > 0

    RetVal := ControlByIndex( I ):CTRL008

EndIf
Return RetVal

/*
Function GetStartUpFolder()
Local StartUpFolder := GetProgramFileName()
Return HB_ULEFT ( StartUpFolder , HB_UTF8RAT ( '\' , StartUpFolder ) - 1 )
*/

Function GetStartUpFolder() // by Pablo Cesar, march 2017 ( remove last unnecessary backslash )
Return cFilePath( hb_ProgName() )


///////////////////////////////////////////////////////////////////////////////
// HARBOUR LEVEL PRINT ROUTINES
///////////////////////////////////////////////////////////////////////////////

#define SB_HORZ     0        // ok
#define SB_VERT     1        // ok
#define WM_VSCROLL  0x0115    // ok
// #define WM_CLOSE     16   // ok (MinGW)
// #define WM_VSCROLL   277  // ok (MinGW)

#if 1

Function _HMG_PRINTER_SHOWPREVIEW()
__THREAD STATIC nIndexEvent  := 0   // ADD, April 2014
Local ModalHandle := 0
Local Tmp
Local tWidth, oForm
Local tHeight
Local tFactor
Local tvHeight
Local icb := 0
Local ppnavtitle
Local cLang       := HB_USubStr( HMG_UPPER( Set ( _SET_LANGUAGE ) ), 1 , 2 )

PUBLIC _Y1:=0,_X1:=0,_Y2:=0,_X2:=0 // ADD April 2014

If !( cLang == "EN" )
   _HMG_PRINTER_InitUserMessages (cLang)
Endif

oHmgApp():APP360 := GetTempFolder() +   oHmgApp():APP379 + "_hmg_print_preview_"
oHmgApp():APP361 := 1
oHmgApp():APP362 := NIL
oHmgApp():APP363 := 0
oHmgApp():APP364 := 0
oHmgApp():APP365 := 0
oHmgApp():APP366 := 10
oHmgApp():APP367 := 0
oHmgApp():APP368 := .T.
oHmgApp():APP369 := NIL
oHmgApp():APP370 := 0

if oHmgApp():IsModalActive

    ModalHandle := oHmgApp():ActiveModalHandle

    oHmgApp():IsModalActive := .F.
    oHmgApp():ActiveModalHandle := 0

    DisableWindow ( ModalHandle )

Else

    ModalHandle := 0

EndIf

if oHmgApp():APP372 == 0
    Return Nil
EndIf

if _IsWindowDefined ( "_HMG_PRINTER_SHOWPREVIEW" )
    Return Nil
endif

icb := oHmgApp():APP339

SET INTERACTIVECLOSE ON

oHmgApp():APP362 := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) * 0.63

IF _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372 ) > 370
    oHmgApp():APP359 := - 250
ELSE
    oHmgApp():APP359 := 0
ENDIF

DEFINE WINDOW _HMG_PRINTER_WAIT AT 0,0 width 310 height 85 title '' child noshow nocaption
    DEFINE LABEL label_1
        ROW 30
        COL 5
        WIDTH 300
        HEIGHT 30
        VALUE oHmgApp():APP371 [29]
        CENTERALIGN .T.
    END LABEL
END WINDOW
CENTER WINDOW _HMG_PRINTER_WAIT

ppnavtitle := oHmgApp():APP371 [01] + ' [' + ALLTRIM(STR(oHmgApp():APP361)) + '/'+ALLTRIM(STR(oHmgApp():APP380)) + ']'

DEFINE WINDOW _HMG_PRINTER_SHOWPREVIEW ;
    AT 0,0 ;
    WIDTH  GetDesktopWidth() - 103 - IF ( ISVISTA() .And. IsAppThemed() , 25 , 0);
    HEIGHT GetDesktopHeight() - 066  - IF ( ISVISTA() .And. IsAppThemed() , 25 , 0);
    CHILD NOSIZE NOMINIMIZE NOMAXIMIZE NOSYSMENU ;
    TITLE ppnavtitle ;
    BACKCOLOR GRAY ;
    ON INIT _HMG_PRINTER_PREVIEWRefresh()

    _HMG_PRINTER_SET_K_EVENTS("_HMG_PRINTER_SHOWPREVIEW")

    DEFINE SPLITBOX   // by Pablo César, April 2014
        DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 40,32 IMAGESIZE 24,24 FLAT CAPTION oHmgApp():APP371 [02]
            BUTTON b2          PICTURE "HP_BACK"      TOOLTIP oHmgApp():APP371 [04]                ACTION ( oHmgApp():APP361-- , _HMG_PRINTER_PREVIEWRefresh() )
            BUTTON b3          PICTURE "HP_NEXT"      TOOLTIP oHmgApp():APP371 [05]                ACTION ( oHmgApp():APP361++ , _HMG_PRINTER_PREVIEWRefresh() ) SEPARATOR
            BUTTON b1          PICTURE "HP_TOP"       TOOLTIP oHmgApp():APP371 [03]                ACTION ( oHmgApp():APP361:=1 , _HMG_PRINTER_PREVIEWRefresh() )
            BUTTON b4          PICTURE "HP_END"       TOOLTIP oHmgApp():APP371 [06]                ACTION ( oHmgApp():APP361:= oHmgApp():APP380, _HMG_PRINTER_PREVIEWRefresh() ) SEPARATOR
            BUTTON bGoToPage   PICTURE "HP_GOPAGE"    TOOLTIP oHmgApp():APP371 [07] + ' [Ctrl+G]'  ACTION (( EnableWindow(GetformHandle("_HMG_PRINTER_SHOWPREVIEW")), EnableWindow(GetformHandle("SPLITCHILD_1")), EnableWindow(GetformHandle("_HMG_PRINTER_SHOWTHUMBNAILS")), HideWindow(GetFormHandle("_HMG_PRINTER_GO_TO_PAGE")), DoMethod("SPLITCHILD_1","SetFocus") ),_HMG_PRINTER_GO_TO_PAGE()) SEPARATOR
            BUTTON thumbswitch PICTURE "HP_THUMBNAIL" TOOLTIP oHmgApp():APP371 [28] + ' [Ctrl+T]'  ACTION (_HMG_PRINTER_ProcessTHUMBNAILS(),_HMG_PRINTER_PREVIEWRefresh()) CHECK SEPARATOR
            BUTTON b5          PICTURE "HP_ZOOM"      TOOLTIP oHmgApp():APP371 [08] + ' [*]'       ACTION (_HMG_PRINTER_Zoom()) CHECK SEPARATOR
            BUTTON b12         PICTURE "HP_PRINT"     TOOLTIP oHmgApp():APP371 [09] + ' [Ctrl+P]'  ACTION _HMG_PRINTER_PrintPages()
            BUTTON b7          PICTURE "HP_SAVE"      TOOLTIP oHmgApp():APP371 [27] + ' [Ctrl+S]'  ACTION (_HMG_PRINTER_SavePages(),_HMG_PRINTER_PREVIEWRefresh()) SEPARATOR
            BUTTON b6          PICTURE "HP_CLOSE"     TOOLTIP oHmgApp():APP371 [26] + ' [Ctrl+C]'  ACTION _HMG_PRINTER_PreviewClose()
        END TOOLBAR

        IF oHmgApp():APP505 == .T.  // PrintPreview NoSavaButton --> .T. or .F.
           _HMG_PRINTER_SHOWPREVIEW.ToolBar_1.b7.Enabled := .F.
        ENDIF

        DEFINE WINDOW SPLITCHILD_1 ;
            WIDTH  GetDesktopWidth() - 103 - IF ( ISVISTA() .And. IsAppThemed() , 25 , 0)   ;
            HEIGHT GetDesktopHeight() - 140  - IF ( ISVISTA() .And. IsAppThemed() , 25 , 0) ;
            VIRTUAL WIDTH  ( GetDesktopWidth() - 103 )  * 2 ;
            VIRTUAL HEIGHT ( GetDesktopHeight() - 140 ) * 2 ;
            SPLITCHILD NOCAPTION ;  // CURSOR          "HP_GLASS" ;
            ON SCROLLUP     _HMG_PRINTER_ScrollUp() ;
            ON SCROLLDOWN   _HMG_PRINTER_ScrollDown() ;
            ON SCROLLLEFT   _HMG_PRINTER_ScrollLeft() ;
            ON SCROLLRIGHT  _HMG_PRINTER_ScrollRight() ;
            ON HSCROLLBOX   _HMG_PRINTER_hScrollBoxProcess() ;
            ON VSCROLLBOX   _HMG_PRINTER_vScrollBoxProcess();
            ON PAINT _HMG_PRINTER_PREVIEW_OnPaint()

            _HMG_PRINTER_SET_K_EVENTS("SPLITCHILD_1")
        END WINDOW

        CREATE EVENT PROCNAME _HMG_PRINTER_SpltChldMouseClick() STOREINDEX nIndexEvent

    END SPLITBOX
END WINDOW


DEFINE WINDOW _HMG_PRINTER_PRINTPAGES                ;
    AT 0,0 WIDTH 420 HEIGHT 168 + GetTitleHeight()   ;
    TITLE oHmgApp():APP371 [9] CHILD NOSHOW      ;
    NOSIZE NOSYSMENU

    ON KEY ESCAPE ACTION ( EnableWindow(GetformHandle("_HMG_PRINTER_SHOWPREVIEW")), EnableWindow(GetformHandle("SPLITCHILD_1")), EnableWindow(GetformHandle("_HMG_PRINTER_SHOWTHUMBNAILS")), HideWindow(GetFormHandle("_HMG_PRINTER_PRINTPAGES")), DoMethod("SPLITCHILD_1","SetFocus") )
    ON KEY RETURN  ACTION _HMG_PRINTER_PrintPagesDo()

    Define Frame Frame_1
        Row 5
        Col 10
        Width 275
        Height 147
        FontName 'Arial'
        FontSize 9
        Caption oHmgApp():APP371 [15]
    End Frame

    Define RadioGroup Radio_1
        Row 25
        Col 20
        FontName 'Arial'
        FontSize 9
        Value 1
        Options { oHmgApp():APP371 [16] , oHmgApp():APP371 [17] }
        OnChange if ( This.value == 1 , ( _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F.  , _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .F. ) , ( _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .T.  , _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Spinner_1.SetFocus ) )
    End RadioGroup

    Define Label Label_1
        Row 84
        Col 55
        Width 50
        Height 25
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP371 [18] + ':'
    End Label

    Define Spinner Spinner_1
        Row 81
        Col 110
        Width 50
        FontName 'Arial'
        FontSize 9
        Value 1
        RangeMin 1
        RangeMax oHmgApp():APP380
    End Spinner

    Define Label Label_2
        Row 84
        Col 165
        Width 35
        Height 25
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP371 [19] + ':'
    End Label

    Define Spinner Spinner_2
        Row 81
        Col 205
        Width 50
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP380
        RangeMin 1
        RangeMax oHmgApp():APP380
    End Spinner

    Define Label Label_4
        Row 115
        Col 55
        Width 50
        Height 25
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP371 [09] + ':'
    End Label

    Define ComboBox Combo_1
        Row 113
        Col 110
        Width 145
        FontName 'Arial'
        FontSize 9
        Value 1
        Items {oHmgApp():APP371 [21] , oHmgApp():APP371 [22] , oHmgApp():APP371 [23] }
    End ComboBox

    Define Button Ok
        Row 10
        Col 300
        Width 105
        Height 25
        FontName 'Arial'
        FontSize 9
        Caption oHmgApp():APP371 [11]
        Action _HMG_PRINTER_PrintPagesDo()
    End Button

    Define Button Cancel
        Row 40
        Col 300
        Width 105
        Height 25
        FontName 'Arial'
        FontSize 9
        Caption oHmgApp():APP371 [12]
        Action ( EnableWindow(GetformHandle("_HMG_PRINTER_SHOWPREVIEW")), EnableWindow(GetformHandle("SPLITCHILD_1")), EnableWindow(GetformHandle("_HMG_PRINTER_SHOWTHUMBNAILS")), HideWindow(GetFormHandle("_HMG_PRINTER_PRINTPAGES")), DoMethod("SPLITCHILD_1","SetFocus") )
    End Button

    Define Label Label_3
        Row 103
        Col 300
        Width 45
        Height 25
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP371 [20] + ':'
    End Label

    Define Spinner Spinner_3
        Row 100
        Col 355
        Width 50
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP376
        RangeMin 1
        RangeMax 999
        OnChange ( if ( IsControlDefined (CheckBox_1,_HMG_PRINTER_PRINTPAGES) , If ( This.Value > 1 , SetProperty( '_HMG_PRINTER_PRINTPAGES' , 'CheckBox_1','Enabled',.T.) , SetProperty( '_HMG_PRINTER_PRINTPAGES','CheckBox_1','Enabled', .F. ) ) , Nil ) )
    End Spinner

    Define CheckBox CheckBox_1
        Row 132
        Col 300
        Width 110
        FontName 'Arial'
        FontSize 9
        Value if ( oHmgApp():APP377 == 1 , .T. , .F. )
        Caption oHmgApp():APP371 [14]
    End CheckBox

END WINDOW
CENTER WINDOW _HMG_PRINTER_PRINTPAGES

DEFINE WINDOW _HMG_PRINTER_GO_TO_PAGE   ;
    AT 0,0                              ;
    WIDTH 195                           ;
    HEIGHT 90 + GetTitleHeight()        ;
    TITLE oHmgApp():APP371 [07]     ;
    CHILD NOSHOW NOSIZE NOSYSMENU

    ON KEY ESCAPE ACTION ( EnableWindow(GetformHandle("_HMG_PRINTER_SHOWPREVIEW")), EnableWindow(GetformHandle("SPLITCHILD_1")), EnableWindow(GetformHandle("_HMG_PRINTER_SHOWTHUMBNAILS")), HideWindow(GetFormHandle("_HMG_PRINTER_GO_TO_PAGE")), DoMethod("SPLITCHILD_1","SetFocus") )

    ON KEY RETURN  ACTION ( oHmgApp():APP361 := _HMG_PRINTER_GO_TO_PAGE.Spinner_1.Value ,;
                            EnableWindow(GetformHandle("_HMG_PRINTER_SHOWPREVIEW")),;
                            EnableWindow(GetformHandle("SPLITCHILD_1")),;
                            EnableWindow(GetformHandle("_HMG_PRINTER_SHOWTHUMBNAILS")),;
                            HideWindow(GetFormHandle("_HMG_PRINTER_GO_TO_PAGE")),;
                            _HMG_PRINTER_PREVIEWRefresh(),;   // ADD April 2014
                            DoMethod("SPLITCHILD_1","SetFocus") )

    Define Label Label_1
        Row 13
        Col 10
        Width 94
        Height 25
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP371 [10] + ':'
    End Label

    Define Spinner Spinner_1
        Row 10
        Col 105
        Width 75
        FontName 'Arial'
        FontSize 9
        Value oHmgApp():APP361
        RangeMin 1
        RangeMax oHmgApp():APP380
    End Spinner

    Define Button Ok
        Row 48
        Col 10
        Width 80
        Height 25
        FontName 'Arial'
        FontSize 9
        Caption oHmgApp():APP371 [11]
        Action ( oHmgApp():APP361 := _HMG_PRINTER_GO_TO_PAGE.Spinner_1.Value ,;
                 HideWindow( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) ),;
                 EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) ),;
                 EnableWindow ( GetformHandle ( "SPLITCHILD_1" ) ),;
                 EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ),;
                 _HMG_PRINTER_PREVIEWRefresh(),;   // ADD April 2014
                 DoMethod("_HMG_PRINTER_SHOWPREVIEW","SetFocus") )
    End Button

    Define Button Cancel
        Row 48
        Col 100
        Width 80
        Height 25
        FontName 'Arial'
        FontSize 9
        Caption oHmgApp():APP371 [12]
        Action ( EnableWindow(GetformHandle("_HMG_PRINTER_SHOWPREVIEW")), EnableWindow(GetformHandle("SPLITCHILD_1")), EnableWindow(GetformHandle("_HMG_PRINTER_SHOWTHUMBNAILS")), HideWindow(GetFormHandle("_HMG_PRINTER_GO_TO_PAGE")), DoMethod("SPLITCHILD_1","SetFocus") )
    End Button
END WINDOW
CENTER WINDOW _HMG_PRINTER_GO_TO_PAGE

if _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) > _HMG_PRINTER_GETPAGEWIDTH(oHmgApp():APP372)
    tFactor := 0.44
else
    tFactor := 0.26
endif

tWidth  :=_HMG_PRINTER_GETPAGEWIDTH(oHmgApp():APP372) * tFactor
tHeight :=_HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) * tFactor

tHeight := Int (tHeight)

tvHeight := ( oHmgApp():APP380 * (tHeight + 10) ) + GetHScrollbarHeight() + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 7

if tvHeight <= GetDesktopHeight() - 066
    oHmgApp():APP369 := .f.
    tvHeight := GetDesktopHeight() - 065
else
    oHmgApp():APP369 := .t.
EndIf

DEFINE WINDOW _HMG_PRINTER_SHOWTHUMBNAILS ;
    AT 0,5 ;
    WIDTH 130 ;
    HEIGHT GetDesktopHeight() - 066 - IF ( ISVISTA() .And. IsAppThemed() , 25 , 0) ;
    VIRTUAL WIDTH 131 ;
    VIRTUAL HEIGHT tvHeight ;
    TITLE oHmgApp():APP371 [28] ;
    CHILD ;
    NOSIZE ;
    NOMINIMIZE ;
    NOMAXIMIZE ;
    NOSYSMENU ;
    NOSHOW ;
    BACKCOLOR GRAY

    _HMG_PRINTER_SET_K_EVENTS("_HMG_PRINTER_SHOWTHUMBNAILS")

END WINDOW

if oHmgApp():APP369 == .f.
    _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWTHUMBNAILS'))
endif

SetScrollRange ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 0 , 100 , .T. )
SetScrollRange ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 0 , 100 , .T. )

SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 50 , .T. )
SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 50 , .T. )

_HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('SPLITCHILD_1'))
_HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR (GetFormHandle('_HMG_PRINTER_SHOWTHUMBNAILS'))

CENTER WINDOW _HMG_PRINTER_SHOWPREVIEW

Tmp := _HMG_PRINTER_SHOWPREVIEW.ROW
_HMG_PRINTER_SHOWTHUMBNAILS.ROW := Tmp

ACTIVATE WINDOW _HMG_PRINTER_PRINTPAGES , _HMG_PRINTER_GO_TO_PAGE , _HMG_PRINTER_SHOWTHUMBNAILS , _HMG_PRINTER_SHOWPREVIEW , _HMG_PRINTER_WAIT

IF nIndexEvent > 0
   EventRemove (nIndexEvent)   // ADD, April 2014
ENDIF


oHmgApp():APP374 := oHmgApp():APP372

If ModalHandle != 0

   FOR EACH oForm IN oHmgApp():AllForms()
      IF ! oForm:IsDeleted .AND. oForm:Type != "X" .AND. oForm:Handle != ModalHandle
         DisableWindow( oForm:Handle )
      ENDIF
   NEXT

   EnableWindow ( ModalHandle )

   // by Dr. Claudio Soto (April 2014)
   FOR EACH oForm IN oHmgApp():AllForms
      IF ! oForm:IsDeleted .AND. oForm:Type == 'P' .AND. oForm:Handle == ModalHandle   // Panel window into Modal window
            EnableWindow ( oForm:Handle )   // Enable Panel window
      ENDIF
   NEXT

   SetFocus ( ModalHandle )

    oHmgApp():IsModalActive := .T.
    oHmgApp():ActiveModalHandle := ModalHandle
Endif

oHmgApp():APP339 := icb

Return Nil


FUNCTION _HMG_PRINTER_SpltChldMouseCursor()   // by Dr. Claudio Soto, April 2014
__THREAD STATIC Flag := .F.
LOCAL hWnd, x, y, IsPoint

   hWnd := GetformHandle ("SPLITCHILD_1")
// GetCursorPos (@x, @y)
// ScreenToClient (hWnd, @x, @y)
   HMG_GetCursorPos (hWnd, @y, @x)

// IsPoint := ( x >= _X1 .AND. y >= _Y1 .AND. x <= _X2 .AND. y <= _Y2 )
   IsPoint := PtInRect (x, y, _X1, _Y1, _X2, _Y2)

   IF IsPoint == .T. .AND. Flag == .F.
      Flag := .T.
      SetWindowCursor (hWnd, "HP_GLASS")
   ELSEIF IsPoint == .F. .AND. Flag == .T.
      Flag := .F.
      SetWindowCursor (hWnd, IDC_ARROW)
   ENDIF

RETURN Flag


FUNCTION _HMG_PRINTER_SpltChldMouseClick()   // by Pablo César and Dr. Claudio Soto, April 2014
LOCAL Flag := _HMG_PRINTER_SpltChldMouseCursor()

   #define WM_SETCURSOR 32
   IF EventMSG() == WM_SETCURSOR
      IF EventWPARAM() == GetControlHandle ("TOOLBAR_1","_HMG_PRINTER_SHOWPREVIEW")
         DoMethod("_HMG_PRINTER_SHOWPREVIEW","SetFocus")   // SetFocus for display ToolTip of the ToolBar define into SPLITBOX
      ENDIF
   ENDIF

   IF EventMSG() == WM_LBUTTONDOWN .AND. Flag == .T. .AND. oHmgApp():EventIsHMGWindowsMessage == .T.
      IF EventHWND() == GetformHandle ("SPLITCHILD_1")   // Click in show page to print
         _HMG_PRINTER_SHOWPREVIEW.b5.Value := .NOT. ( _HMG_PRINTER_SHOWPREVIEW.b5.Value )
         _HMG_PRINTER_MouseZoom()
      ENDIF
   ENDIF

RETURN NIL


Function _HMG_PRINTER_SET_K_EVENTS (parent)
_DefineHotKey ( parent, 0  , VK_HOME       , {||( oHmgApp():APP361:=1 , _HMG_PRINTER_PREVIEWRefresh() )} )
_DefineHotKey ( parent, 0  , VK_PRIOR      , {||( oHmgApp():APP361-- , _HMG_PRINTER_PREVIEWRefresh() )} )
_DefineHotKey ( parent, 0  , VK_NEXT       , {||( oHmgApp():APP361++ , _HMG_PRINTER_PREVIEWRefresh() )} )
_DefineHotKey ( parent, 0  , VK_END        , {||( oHmgApp():APP361:= oHmgApp():APP380, _HMG_PRINTER_PREVIEWRefresh() )} )
_DefineHotKey ( parent, MOD_CONTROL , VK_P , {||_HMG_PRINTER_PrintPages()} )
_DefineHotKey ( parent, MOD_CONTROL , VK_G , {||_HMG_PRINTER_GO_TO_PAGE()} )
_DefineHotKey ( parent, 0 , VK_ESCAPE      , {||_HMG_PRINTER_PreviewClose()} )
_DefineHotKey ( parent, 0 , VK_MULTIPLY    , {|| ( _HMG_PRINTER_SHOWPREVIEW.b5.Value := .NOT. ( _HMG_PRINTER_SHOWPREVIEW.b5.Value ), _HMG_PRINTER_MouseZoom(.T.) )} )
_DefineHotKey ( parent, MOD_CONTROL , VK_C , {||_HMG_PRINTER_PreviewClose()} )
_DefineHotKey ( parent, MOD_ALT , VK_F4    , {||_HMG_PRINTER_PreviewClose()} )

IF oHmgApp():APP505 <> .T.  // PrintPreview NoSavaButton --> .T. or .F.
   _DefineHotKey ( parent, MOD_CONTROL , VK_S , {||( _hmg_printer_savepages(), _HMG_PRINTER_PREVIEWRefresh() )} )
ENDIF

_DefineHotKey ( parent, MOD_CONTROL , VK_T , {||_hmg_printer_ThumbnailToggle()} )
Return Nil


Function CreateThumbNails()
Local tFactor
Local tWidth
Local tHeight
Local ttHandle
Local i
Local cMacroTemp
Local cAction
LOCAL cFileName, hBitmap

If _IsControlDefined ( 'Image1' , '_HMG_PRINTER_SHOWTHUMBNAILS' )
    Return Nil
EndIf

ShowWindow ( GetFormHandle ( "_HMG_PRINTER_WAIT" ) )

if _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) > _HMG_PRINTER_GETPAGEWIDTH(oHmgApp():APP372)
    tFactor := 0.44
else
    tFactor := 0.26
endif

tWidth  :=_HMG_PRINTER_GETPAGEWIDTH(oHmgApp():APP372) * tFactor
tHeight :=_HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) * tFactor

tHeight := Int (tHeight)

ttHandle := GetFormToolTipHandle ('_HMG_PRINTER_SHOWTHUMBNAILS')

For i := 1 To oHmgApp():APP380

    cMacroTemp := 'Image' + ALLTRIM(STR(i))

    cAction := "( oHmgApp():APP361:="+ ALLTRIM(STR(i)) +", oHmgApp():APP368 := .F. , _HMG_PRINTER_PREVIEWRefresh() , oHmgApp():APP368 := .T. )"

    cFileName := oHmgApp():APP360 + StrZero(i,4) + ".EMF"

    _DefineImage( cMacroTemp,;
                  '_HMG_PRINTER_SHOWTHUMBNAILS',;
                  10,;
                  ( i * (tHeight + 10) ) - tHeight,;
                  "" /*cFileName*/,;
                  tWidth,;
                  tHeight,;
                  { || &cAction },;
                  Nil,;
                  .F.,;
                  .F.,;
                  .T. )

//  by Dr. Claudio Soto, April 2014
    hBitmap := BT_BitmapLoadEMF ( cFileName, WHITE, tWidth, tHeight )
    BT_HMGSetImage ('_HMG_PRINTER_SHOWTHUMBNAILS', cMacroTemp, hBitmap)


    SetToolTip ( GetControlHandle ( cMacroTemp ,'_HMG_PRINTER_SHOWTHUMBNAILS'), oHmgApp():APP371 [01] + ' ' + ALLTRIM(STR(i)) + ' [Click]' , ttHandle )

Next i
HideWindow ( GetFormHandle ( "_HMG_PRINTER_WAIT" ) )
Return Nil

Function _hmg_printer_ThumbnailToggle()
if _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value == .t.

   _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value := .f.

Else

   _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value := .t.

EndIf
_HMG_PRINTER_ProcessTHUMBNAILS()
Return .F.

Function _HMG_PRINTER_ProcessTHUMBNAILS()
If _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value == .T.

   CreateThumbNails()

   oHmgApp():APP367 := 90

   oHmgApp():APP362 := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) * 0.58

   SetProperty("_HMG_PRINTER_SHOWPREVIEW","Width", GetDesktopWidth() - 148 - IF ( ISVISTA() .And. IsAppThemed() , 30 , 0 ) )
   SetProperty("_HMG_PRINTER_SHOWPREVIEW","Col", 138 + IF ( ISVISTA() .And. IsAppThemed() , 20 , 0 ) )
   ShowWindow ( GetFormHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

else

   oHmgApp():APP367 := 0

   oHmgApp():APP362 := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) * 0.63

   SetProperty("_HMG_PRINTER_SHOWPREVIEW","Width", GetDesktopWidth() - 103 )
   SetProperty("_HMG_PRINTER_SHOWPREVIEW","Col", 51 )
   HideWindow ( GetFormHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
   DoMethod("_HMG_PRINTER_SHOWPREVIEW","SetFocus")

EndIf
Return Nil



Function _HMG_PRINTER_SavePages ( lSaveAs )
Local i, nFiles, cFileEMF, cTempFolder, cPrintFileName, aFiles := {}

LOCAL g := {".PDF", ".BMP",".JPG",".GIF",".TIF",".PNG",".EMF"}
LOCAL nTypePicture := { Nil , BT_FILEFORMAT_BMP, BT_FILEFORMAT_JPG, BT_FILEFORMAT_GIF, BT_FILEFORMAT_TIF, BT_FILEFORMAT_PNG, Nil }
LOCAL acFilter := { {"PDF", "*.pdf"}, {"BMP", "*.bmp"}, {"JPG", "*.jpg"}, {"GIF", "*.gif"}, {"TIF", "*.tif"}, {"PNG", "*.png"}, {"EMF", "*.emf"} }
LOCAL cFullName:="", cPath:="", cName:="", cExt:="", cExtFile := ""
LOCAL cFileName := "HMG_PrintFile"
LOCAL cFolder

Local hBitmap, nType
Local flag_PDF := .F.
local nWidth, nHeight, nDPI

   IF ValType ( oHmgApp():APP506 ) == "C"
      hb_FNameSplit( oHmgApp():APP506, @cFolder, @cFileName, @cExt, NIL )   // Dialog cFileName
   ENDIF

   // by Dr. Claudio Soto, September 2014

   IF ValType (lSaveAs) == "L" .AND. lSaveAs == .T.
      IF ValType ( oHmgApp():APP507 ) == "C"
         cFullName := oHmgApp():APP507   // SaveAs: cFileName + cExt
      ELSE
         MsgStop ("SaveAs: Invalid File Name", "ERROR")
         RETURN NIL
      ENDIF
   ELSE
      cExt := HMG_UPPER (AllTrim (cExt))
      i := ASCAN (g, cExt)
      cFullName := PutFile ( acFilter, NIL, cFolder, .F., cFileName, @cExtFile, i )
   ENDIF

   HB_FNameSplit (cFullName, @cPath, @cName, @cExt, NIL)

   IF EMPTY (cName)
      Return Nil
   ENDIF

   cExt := HMG_UPPER (AllTrim (cExt))

   i := ASCAN (g, cExt)
   If i == 0
      MsgStop ("Invalid File Extension: "+cExt, "ERROR")
      Return Nil
   endif

   nType := nTypePicture [ i ]

   IF HMG_UPPER (cExt) == ".PDF"
      flag_PDF := .T.
   ENDIF


cTempFolder := GetTempFolder ()

nFiles := ADIR ( cTempFolder + oHmgApp():APP379 + "_hmg_print_preview_*.Emf")

ASIZE ( aFiles , nFiles )

ADIR ( cTempFolder + oHmgApp():APP379  + "_hmg_print_preview_*.Emf" , aFiles )


For i := 1 To nFiles
    cFileEMF := cTempFolder + aFiles [i]
    cPrintFileName := cPath + cName + "_" + StrZero ( i , 4 )

    IF HMG_UPPER (cExt) == ".EMF"
       COPY FILE (cFileEMF) TO (cPrintFileName + cExt)
    ELSE


      // by Dr. Claudio Soto, April 2014
       hBitmap = BT_BitmapLoadEMF ( cFileEMF, WHITE )

       IF hBitmap <> 0 .AND. flag_PDF == .F.
          BT_BitmapSaveFile (hBitmap, cPrintFileName + cExt, nType)
          BT_BitmapRelease (hBitmap)
       ENDIF

       IF hBitmap <> 0 .AND. flag_PDF == .T.   // by Rathinagiri (May 2014)
         if i == 1
            nDPI    := 300
            nWidth  := ( BT_BitmapWidth ( hBitmap ) / nDPI * 25.4 )
            nHeight := ( BT_BitmapHeight( hBitmap ) / nDPI * 25.4 )
            _HMG_HPDF_INIT ( cPath + cName + ".PDF", 1, 256, nHeight, nWidth, .f. )
            _hmg_hpdf_startdoc()
            _HMG_HPDF_SetCompression( 'ALL' )
         endif

         _hmg_hpdf_startpage()
         BT_BitmapSaveFile (hBitmap, cPrintFileName + ".JPG", BT_FILEFORMAT_JPG)
         BT_BitmapRelease (hBitmap)
         _HMG_HPDF_IMAGE ( cPrintFileName + ".JPG", 0, 0, nHeight, nWidth, .t. , "JPG" )
         _hmg_hpdf_endpage()
         FERASE ( cPrintFileName + ".JPG" )

         if i == nFiles
            _hmg_hpdf_enddoc()
         endif

       ENDIF

    ENDIF
Next i
Return Nil



Function HMG_IsValidFileName ( cFileName )   // cFileName --> ONLY FILE NAME without Path
LOCAL cName, ch, i
   cName := AllTrim (cFileName)
   IF EMPTY (cName)
      Return .F.
   ENDIF
   FOR i := 1 TO HMG_LEN (cName)
      ch := HB_USUBSTR (cName, i, 1)
   // Not valid characters --> ASCII 0 to 31 and < > : " / \ |
      IF (HB_UCODE (ch) >= 0 .AND. HB_UCODE (ch) <= 31) .OR. ch $ '<>:"/\|'
         Return .F.
      ENDIF
   NEXT
Return .T.


Function _HMG_PRINTER_GO_TO_PAGE()
DisableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
DisableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )
DisableWindow ( GetformHandle ( "SPLITCHILD_1" ) )
ShowWindow ( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) )
Return Nil


Function _HMG_PRINTER_hScrollBoxProcess()
Local Sp
Sp := GetScrollPos (  GetFormHandle('SPLITCHILD_1') , SB_HORZ )
oHmgApp():APP363    := - ( Sp - 50 ) * 10
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


Function _HMG_PRINTER_vScrollBoxProcess()
Local Sp
Sp := GetScrollPos (  GetFormHandle('SPLITCHILD_1') , SB_VERT )
oHmgApp():APP364    := - ( Sp - 50 ) * 10
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


Function _HMG_PRINTER_PreviewClose()
_HMG_PRINTER_CleanPreview()
_HMG_PRINTER_WAIT.Release
_HMG_PRINTER_SHOWTHUMBNAILS.Release
_HMG_PRINTER_SHOWPREVIEW.Release
_HMG_PRINTER_GO_TO_PAGE.Release
_HMG_PRINTER_PRINTPAGES.Release
Return Nil


Function _HMG_PRINTER_CleanPreview()
Local c , i , f , t
Local a := {}

t := gettempfolder()
c := adir ( t + oHmgApp():APP379  + "_hmg_print_preview_*.Emf")
asize ( a , c )
adir ( t + oHmgApp():APP379  + "_hmg_print_preview_*.Emf" , a )
For i := 1 To c
    f := t + a [i]
    DELETE FILE (f)
Next i
Return Nil


PROCEDURE _HMG_PRINTER_PREVIEWRefresh()   // July 2015
   BT_ClientAreaInvalidateAll ("SPLITCHILD_1")
RETURN


Function _HMG_PRINTER_PREVIEW_OnPaint()   // July 2015
Local hwnd
Local nRow
Local nScrollMax
LOCAL aCoord:= {0,0,0,0}
LOCAL hDC, BTstruct   // July 2015

If _IsControlDefined ( 'Image' + ALLTRIM(STR(oHmgApp():APP361)) , '_HMG_PRINTER_SHOWTHUMBNAILS' ) .and. oHmgApp():APP368 == .T. .and. oHmgApp():APP369 == .T.

    if oHmgApp():APP370 != oHmgApp():APP361

        oHmgApp():APP370 := oHmgApp():APP361
        hwnd := GetFormHandle('_HMG_PRINTER_SHOWTHUMBNAILS')
        nRow := GetProperty ( '_HMG_PRINTER_SHOWTHUMBNAILS' , 'Image' + ALLTRIM(STR(oHmgApp():APP361)) , 'Row' )
        nScrollMax := GetScrollRangeMax ( hwnd , SB_VERT )

        if oHmgApp():APP380 == oHmgApp():APP361

            if GetScrollPos(hwnd,SB_VERT) != nScrollMax
                _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , nScrollMax )
            EndIf

        ElseIf oHmgApp():APP361 == 1

            if GetScrollPos(hwnd,SB_VERT) != 0
                _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , 0 )
            EndIf

        Else

            if ( nRow - 9 ) < nScrollMax
                _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , nRow - 9 )
            Else
                if GetScrollPos(hwnd,SB_VERT) != nScrollMax
                    _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , nScrollMax )
                EndIf
            EndIf

        EndIf

    EndIf

EndIf

if oHmgApp():APP361 < 1
    oHmgApp():APP361 := 1
    PlayBeep()
    Return Nil
EndIf

if oHmgApp():APP361 > oHmgApp():APP380
    oHmgApp():APP361 := oHmgApp():APP380
    PlayBeep()
    Return Nil
EndIf


hDC := BT_CreateDC ("SPLITCHILD_1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)   // July 2015

      aCoord := _HMG_PRINTER_SHOWPAGE ( oHmgApp():APP360 + StrZero(oHmgApp():APP361,4) + ".emf",;
                                  GetFormhandle ('SPLITCHILD_1') ,;
                                  oHmgApp():APP372 ,;
                                  oHmgApp():APP362 * 10000 ,;
                                  oHmgApp():APP365 ,;
                                  oHmgApp():APP363 ,;
                                  oHmgApp():APP364 ,;
                                  hDC )   // July 2015
BT_DeleteDC (BTstruct)   // July 2015


// ADD April 2014
_Y1 := aCoord [1]
_X1 := aCoord [2]
_Y2 := aCoord [3]
_X2 := aCoord [4]

_HMG_PRINTER_SHOWPREVIEW.TITLE := oHmgApp():APP371 [01] + ' [' + ALLTRIM(STR(oHmgApp():APP361)) + '/'+ALLTRIM(STR(oHmgApp():APP380)) + ']'

Return Nil


Function _HMG_PRINTER_PrintPages()
Local aProp := {}

DisableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )
DisableWindow ( GetformHandle ( "SPLITCHILD_1" ) )
DisableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

_HMG_PRINTER_PRINTPAGES.Radio_1.Value := 1

_HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .F.
_HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .F.
_HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .F.
_HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F.
_HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F.
_HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F.
_HMG_PRINTER_PRINTPAGES.CheckBox_1.Enabled := .F.

if  oHmgApp():APP286 ;
    .or. ;
    oHmgApp():APP287

    _HMG_PRINTER_PRINTPAGES.Spinner_3.Enabled := .F.

endif
ShowWindow ( GetFormHandle ( "_HMG_PRINTER_PRINTPAGES" ) )
Return Nil


Function _HMG_PRINTER_PrintPagesDo()
Local PageFrom
Local PageTo
Local p, i
Local OddOnly := .F.
Local EvenOnly := .F.

If _HMG_PRINTER_PrintPages.Radio_1.Value == 1

    PageFrom := 1
    PageTo   := oHmgApp():APP380

ElseIf _HMG_PRINTER_PrintPages.Radio_1.Value == 2

    PageFrom := _HMG_PRINTER_PrintPages.Spinner_1.Value
    PageTo   := _HMG_PRINTER_PrintPages.Spinner_2.Value

    If _HMG_PRINTER_PrintPages.Combo_1.Value == 2
        OddOnly := .T.
    ElseIf _HMG_PRINTER_PrintPages.Combo_1.Value == 3
        EvenOnly := .T.
    EndIf

EndIf


// by Dr. Claudio Soto, August 2015

// oHmgApp():APP516 -->  cVarName_aJobData of START PRINTDOC STOREJOBDATA
OpenPrinterGetJobID() := _HMG_PRINTER_StartDoc ( oHmgApp():APP372 , oHmgApp():APP358 )
IF .NOT. Empty ( oHmgApp():APP516 )
   IF __mvExist(oHmgApp():APP516)
   __mvPut( oHmgApp():APP516 , OpenPrinterGetJobData() )
   ELSE
      MsgHMGError ("START PRINTDOC STOREJOBDATA: " + oHmgApp():APP516 + " VarMem must be declared Public or Private. Program Terminated")
   ENDIF
ENDIF


If _HMG_PRINTER_PrintPages.Spinner_3.Value == 1 // Copies

    For i := PageFrom To PageTo

        If OddOnly == .T.
            If i / 2 != int (i / 2)
                _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
            EndIf
        ElseIf EvenOnly == .T.
            If i / 2 == int (i / 2)
                _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
            EndIf
        Else
            _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
        EndIf

    Next i

Else

    If _HMG_PRINTER_PrintPages.CheckBox_1.Value == .F.

        For p := 1 To _HMG_PRINTER_PrintPages.Spinner_3.Value

            For i := PageFrom To PageTo

                If OddOnly == .T.
                    If i / 2 != int (i / 2)
                        _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
                    EndIf
                ElseIf EvenOnly == .T.
                    If i / 2 == int (i / 2)
                        _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
                    EndIf
                Else
                    _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
                EndIf

            Next i

        Next p

    Else

        For i := PageFrom To PageTo

            For p := 1 To _HMG_PRINTER_PrintPages.Spinner_3.Value

                If OddOnly == .T.
                    If i / 2 != int (i / 2)
                        _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
                    EndIf
                ElseIf EvenOnly == .T.
                    If i / 2 == int (i / 2)
                        _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
                    EndIf
                Else
                    _HMG_PRINTER_PRINTPAGE ( oHmgApp():APP372 , oHmgApp():APP360 + strzero(i,4) + ".emf" )
                EndIf

            Next p

        Next i

    EndIf

EndIf

_HMG_PRINTER_ENDDOC ( oHmgApp():APP372 )

EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )
EnableWindow ( GetformHandle ( "SPLITCHILD_1" ) )
EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
HideWindow ( GetFormHandle ( "_HMG_PRINTER_PRINTPAGES" ) )
DoMethod("SPLITCHILD_1","SetFocus")
Return Nil


Function _HMG_PRINTER_ScrollLeft()
oHmgApp():APP363 := oHmgApp():APP363 + oHmgApp():APP366
if oHmgApp():APP363 >= 500
    oHmgApp():APP363 := 500
    PlayBeep()
EndIf
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


Function _HMG_PRINTER_ScrollRight()
oHmgApp():APP363 := oHmgApp():APP363 - oHmgApp():APP366
if oHmgApp():APP363 <= -500
    oHmgApp():APP363 := -500
    PlayBeep()
EndIf
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


Function _HMG_PRINTER_ScrollUp()
oHmgApp():APP364 := oHmgApp():APP364 + oHmgApp():APP366
if oHmgApp():APP364 >= 500
    oHmgApp():APP364 := 500
    PlayBeep()
EndIf
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


Function _HMG_PRINTER_ScrollDown()
oHmgApp():APP364 := oHmgApp():APP364 - oHmgApp():APP366
if oHmgApp():APP364 <= -500
    oHmgApp():APP364 := -500
    PlayBeep()
EndIf
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


#endif

Function GetPrinter()
Local RetVal          := ''
Local Printers        := ASort (aPrinters())
Local cDefaultPrinter := GetDefaultPrinter()
Local nInitPosition   := 0
Local i

For i := 1 to HMG_LEN ( Printers )

    If Printers [i] == cDefaultPrinter
        nInitPosition := i
        Exit
    Endif

Next i

DEFINE WINDOW _HMG_PRINTER_GETPRINTER   ;
    AT 0,0          ;
    WIDTH 345       ;
    HEIGHT GetTitleHeight() + 100 ;
    TITLE oHmgApp():APP371 [13] ;
    MODAL           ;
    NOSIZE

    @ 15,10 COMBOBOX Combo_1 ITEMS Printers VALUE nInitPosition WIDTH 320

    @ 53 , 65  BUTTON Ok CAPTION oHmgApp():APP371 [11] ACTION ( RetVal := Printers [ GetProperty ( '_HMG_PRINTER_GETPRINTER','Combo_1','Value') ] , DoMethod('_HMG_PRINTER_GETPRINTER','Release' ) )

    @ 53 , 175 BUTTON Cancel CAPTION oHmgApp():APP371 [12] ACTION ( RetVal := '' ,DoMethod('_HMG_PRINTER_GETPRINTER','Release' ) )

END WINDOW
CENTER WINDOW _HMG_PRINTER_GETPRINTER
ACTIVATE WINDOW _HMG_PRINTER_GETPRINTER
Return RetVal


#define TA_CENTER   6   // ok
#define TA_LEFT     0   // ok
#define TA_RIGHT    2   // ok

Function _HMG_PRINTER_H_PRINT ( nHdc , nRow , nCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize , cAlign, nAngle )
Local lAlignChanged := .F.

if ValType (cText) == "N"
   cText := ALLTRIM(STR(cText))
Elseif ValType (cText) == "D"
   cText := dtoc (cText)
Elseif ValType (cText) == "L"
   cText := if ( cText == .T. , oHmgApp():APP371 [24] , oHmgApp():APP371 [25] )
Elseif ValType (cText) == "A"
   Return Nil
Elseif ValType (cText) == "B"
   Return Nil
Elseif ValType (cText) == "O"
   Return Nil
Elseif ValType (cText) == "U"
   Return Nil
EndIf

nRow := Int ( nRow * 10000 / 254 )
nCol := Int ( nCol * 10000 / 254 )

if valtype ( cAlign ) = 'C'
    if HMG_UPPER (ALLTRIM ( cAlign )) == 'CENTER'
        SetTextAlign ( nHdc , TA_CENTER )
        lAlignChanged := .T.
    elseif HMG_UPPER (ALLTRIM ( cAlign )) == 'RIGHT'
        SetTextAlign ( nHdc , TA_RIGHT )
        lAlignChanged := .T.
    endif
endif

_HMG_PRINTER_C_PRINT ( nHdc , nRow , nCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize , nAngle )

if lAlignChanged
    SetTextAlign ( nHdc , TA_LEFT )
endif
Return nil


Function _HMG_PRINTER_H_MULTILINE_PRINT ( nHdc , nRow , nCol , nToRow , nToCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize , cAlign )
Local nAlign := TA_LEFT

//  cText := hb_oemtoansi(cText)
if ValType (cText) == "N"
    cText := ALLTRIM(STR(cText))
Elseif ValType (cText) == "D"
    cText := dtoc (cText)
Elseif ValType (cText) == "L"
    cText := if ( cText == .T. , oHmgApp():APP371 [24] , oHmgApp():APP371 [25] )
Elseif ValType (cText) == "A"
    Return Nil
Elseif ValType (cText) == "B"
    Return Nil
Elseif ValType (cText) == "O"
    Return Nil
Elseif ValType (cText) == "U"
    Return Nil
EndIf

nRow := Int ( nRow * 10000 / 254 )
nCol := Int ( nCol * 10000 / 254 )
nToRow := Int ( nToRow * 10000 / 254 )
nToCol := Int ( nToCol * 10000 / 254 )

if valtype ( cAlign ) = 'C'
    if HMG_UPPER (ALLTRIM ( cAlign )) == 'CENTER'
        nAlign := TA_CENTER
    elseif HMG_UPPER (ALLTRIM ( cAlign )) == 'RIGHT'
        nAlign := TA_RIGHT
    endif
endif
_HMG_PRINTER_C_MULTILINE_PRINT ( nHdc , nRow , nCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize , nToRow , nToCol , nAlign )
Return Nil


Function _HMG_PRINTER_H_IMAGE ( nHdc , cImage , nRow , nCol , nHeight , nWidth , lStretch , lTransparent , aTransparentColor )

nRow    := Int ( nRow * 10000 / 254 )
nCol    := Int ( nCol * 10000 / 254 )
nWidth  := Int ( nWidth * 10000 / 254 )
nHeight := Int ( nHeight * 10000 / 254 )

_HMG_PRINTER_C_IMAGE ( nHdc , cImage , nRow , nCol , nHeight , nWidth , lStretch , lTransparent , aTransparentColor )
Return Nil


Function _HMG_PRINTER_H_LINE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )
nRow    := Int ( nRow * 10000 / 254 )
nCol    := Int ( nCol * 10000 / 254 )
nToRow  := Int ( nToRow * 10000 / 254 )
nToCol  := Int ( nToCol * 10000 / 254 )

If ValType ( nWidth ) != 'U'
    nWidth  := Int ( nWidth * 10000 / 254 )
EndIf

_HMG_PRINTER_C_LINE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )
Return Nil


Function _HMG_PRINTER_H_RECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol ,nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor, lfilled )
nRow    := Int ( nRow * 10000 / 254 )
nCol    := Int ( nCol * 10000 / 254 )
nToRow  := Int ( nToRow * 10000 / 254 )
nToCol  := Int ( nToCol * 10000 / 254 )

If ValType ( nWidth ) != 'U'
    nWidth  := Int ( nWidth * 10000 / 254 )
EndIf
_HMG_PRINTER_C_RECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor, lfilled )
Return Nil


Function _HMG_PRINTER_H_ROUNDRECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol ,nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor, lfilled )
nRow    := Int ( nRow * 10000 / 254 )
nCol    := Int ( nCol * 10000 / 254 )
nToRow  := Int ( nToRow * 10000 / 254 )
nToCol  := Int ( nToCol * 10000 / 254 )

If ValType ( nWidth ) != 'U'
    nWidth  := Int ( nWidth * 10000 / 254 )
EndIf
_HMG_PRINTER_C_ROUNDRECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor, lfilled )
Return Nil



Function _HMG_PRINTER_InitUserMessages (cLang)
// LANGUAGES NOT SUPPORTED BY hb_langSelect() FUNCTION.
/*
IF oHmgApp():APP211 == 'FI'     // FINNISH
    cLang := 'FI'
ELSEIF oHmgApp():APP211 == 'NL' // DUTCH
    cLang := 'NL'
ENDIF
*/

********************************************************************************************************************************************************
IF HMG_IsCurrentCodePageUnicode()
********************************************************************************************************************************************************
    do case
       /////////////////////////////////////////////////////////////
       // TURKISH
       ////////////////////////////////////////////////////////////
       // case cLang == "TRWIN" .OR. cLang == "TR"
       case cLang == "TR"
            oHmgApp():APP371 [01] := 'Sayfa'
            oHmgApp():APP371 [02] := 'Print Ã–n-izleme'
            oHmgApp():APP371 [03] := 'Ãlk Sayfa [HOME]'
            oHmgApp():APP371 [04] := 'Ã–nceki Sayfa [PGUP]'
            oHmgApp():APP371 [05] := 'Sonraki Sayfa [PGDN]'
            oHmgApp():APP371 [06] := 'Son sayfa [END]'
            oHmgApp():APP371 [07] := 'Sayfa no'
            oHmgApp():APP371 [08] := 'BÃ¼yÃ¼t/KÃ¼Ã§Ã¼lt'
            oHmgApp():APP371 [09] := 'YazdÃ½r'
            oHmgApp():APP371 [10] := 'Sayfa No'
            oHmgApp():APP371 [11] := 'Tamam'
            oHmgApp():APP371 [12] := 'Ãptal'
            oHmgApp():APP371 [13] := 'Printer SeÃ§'
            oHmgApp():APP371 [14] := 'KopyalarÃ½ birleÃ¾tir'
            oHmgApp():APP371 [15] := 'SÃ½nÃ½rlÃ½ Print'
            oHmgApp():APP371 [16] := 'Hepsi'
            oHmgApp():APP371 [17] := 'Sayfalar'
            oHmgApp():APP371 [18] := 'Ãlk'
            oHmgApp():APP371 [19] := 'Son'
            oHmgApp():APP371 [20] := 'Kopya sayÃ½sÃ½'
            oHmgApp():APP371 [21] := 'BÃ¼tÃ¼n sÃ½nÃ½rlar'
            oHmgApp():APP371 [22] := 'YalnÃ½z tek sayfalar'
            oHmgApp():APP371 [23] := 'YalnÃ½z Ã§ift sayfalar'
            oHmgApp():APP371 [24] := 'Evet'
            oHmgApp():APP371 [25] := 'HayÃ½r'
            oHmgApp():APP371 [26] := 'Kapat'
            oHmgApp():APP371 [27] := 'Kaydet'
            oHmgApp():APP371 [28] := 'Sayfa ikonlarÃ½'
            oHmgApp():APP371 [29] := 'Sayfa ikonlarÃ½ oluÃ¾turuluyor... LÃ¼tfen bekleyin...'

        /////////////////////////////////////////////////////////////
        // CZECH
        ////////////////////////////////////////////////////////////
        // case cLang ==  "CS" .OR. cLang == "CSWIN"
        case cLang ==  "CS"
             oHmgApp():APP371 [01] := 'Strana'
             oHmgApp():APP371 [02] := 'NÃ¡hled'
             oHmgApp():APP371 [03] := 'PrvnÃ­ strana [HOME]'
             oHmgApp():APP371 [04] := 'PÃ¸edchozÃ­ strana [PGUP]'
             oHmgApp():APP371 [05] := 'DalÅ¡Ã­ strana [PGDN]'
             oHmgApp():APP371 [06] := 'PoslednÃ­ strana [END]'
             oHmgApp():APP371 [07] := 'Jdi na stranu'
             oHmgApp():APP371 [08] := 'Lupa'
             oHmgApp():APP371 [09] := 'Tisk'
             oHmgApp():APP371 [10] := 'ÃˆÃ­slo strany'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Storno'
             oHmgApp():APP371 [13] := 'Vyber tiskÃ¡rnu'
             oHmgApp():APP371 [14] := 'TÃ¸Ã­dÃ¬nÃ­'
             oHmgApp():APP371 [15] := 'Rozsah tisku'
             oHmgApp():APP371 [16] := 'vÅ¡e'
             oHmgApp():APP371 [17] := 'strany'
             oHmgApp():APP371 [18] := 'od'
             oHmgApp():APP371 [19] := 'do'
             oHmgApp():APP371 [20] := 'kopiÃ­'
             oHmgApp():APP371 [21] := 'vÅ¡echny strany'
             oHmgApp():APP371 [22] := 'lichÃ© strany'
             oHmgApp():APP371 [23] := 'sudÃ© strany'
             oHmgApp():APP371 [24] := 'Ano'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'ZavÃ¸i'
             oHmgApp():APP371 [27] := 'UloÅ¾'
             oHmgApp():APP371 [28] := 'Miniatury'
             oHmgApp():APP371 [29] := 'Generuji miniatury... Ãˆekejte, prosÃ­m...'

        /////////////////////////////////////////////////////////////
        // CROATIAN
        ////////////////////////////////////////////////////////////
        // case cLang == "HR852" // Croatian
        case cLang == "HR"
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // BASQUE
        ////////////////////////////////////////////////////////////
        case cLang == "EU"        // Basque.
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // ENGLISH
        ////////////////////////////////////////////////////////////
        case cLang == "EN"        // English
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // FRENCH
        ////////////////////////////////////////////////////////////
        case cLang == "FR"        // French
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := "AperÃ§u avant impression"
             oHmgApp():APP371 [03] := 'PremiÃ¨re page [HOME]'
             oHmgApp():APP371 [04] := 'Page prÃ©cÃ©dente [PGUP]'
             oHmgApp():APP371 [05] := 'Page suivante [PGDN]'
             oHmgApp():APP371 [06] := 'DerniÃ¨re page [END]'
             oHmgApp():APP371 [07] := 'Allez page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Imprimer'
             oHmgApp():APP371 [10] := 'Page'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Annulation'
             oHmgApp():APP371 [13] := "SÃ©lection de l'imprimante"
             oHmgApp():APP371 [14] := "Assemblez"
             oHmgApp():APP371 [15] := "ParamÃ¨tres d'impression"
             oHmgApp():APP371 [16] := 'Tous'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'De'
             oHmgApp():APP371 [19] := 'Ã€'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'Toutes les pages'
             oHmgApp():APP371 [22] := 'Pages Impaires'
             oHmgApp():APP371 [23] := 'Pages Paires'
             oHmgApp():APP371 [24] := 'Oui'
             oHmgApp():APP371 [25] := 'Non'
             oHmgApp():APP371 [26] := 'Fermer'
             oHmgApp():APP371 [27] := 'Sauver'
             oHmgApp():APP371 [28] := 'Affichettes'
             oHmgApp():APP371 [29] := "CrÃ©ation des affichettes... Merci d'attendre..."

        /////////////////////////////////////////////////////////////
        // GERMAN
        ////////////////////////////////////////////////////////////
        // case cLang == "DEWIN" .OR. cLang == "DE"       // German
        case cLang == "DE"
             oHmgApp():APP371 [01] := 'Seite'
             oHmgApp():APP371 [02] := 'DruckcVorbetrachtung'
             oHmgApp():APP371 [03] := 'Erste Seite [HOME]'
             oHmgApp():APP371 [04] := 'Vorige Seite [PGUP]'
             oHmgApp():APP371 [05] := 'Folgende Seite [PGDN]'
             oHmgApp():APP371 [06] := 'Letzte Seite [END]'
             oHmgApp():APP371 [07] := 'Gehen Sie Zu paginieren'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Druck'
             oHmgApp():APP371 [10] := 'Seitenzahl'
             oHmgApp():APP371 [11] := 'O.K.'
             oHmgApp():APP371 [12] := 'LÃ¶schen'
             oHmgApp():APP371 [13] := 'WÃ¤hlen Sie Drucker Vor'
             oHmgApp():APP371 [14] := 'Sortieren'
             oHmgApp():APP371 [15] := 'DruckcStrecke'
             oHmgApp():APP371 [16] := 'Alle'
             oHmgApp():APP371 [17] := 'Seiten'
             oHmgApp():APP371 [18] := 'Von'
             oHmgApp():APP371 [19] := 'Zu'
             oHmgApp():APP371 [20] := 'Kopien'
             oHmgApp():APP371 [21] := 'Alle Strecke'
             oHmgApp():APP371 [22] := 'Nur Ungerade Seiten'
             oHmgApp():APP371 [23] := 'Nur GleichmÃ¤ÃŸige Seiten'
             oHmgApp():APP371 [24] := 'Ja'
             oHmgApp():APP371 [25] := 'Nein'
             oHmgApp():APP371 [26] := 'Fenster'
             oHmgApp():APP371 [27] := 'Speichern'
             oHmgApp():APP371 [28] := 'Ãœberblick'
             oHmgApp():APP371 [29] := 'Ãœberblick Erzeugen...  Bitte Wartezeit...'

        /////////////////////////////////////////////////////////////
        // ITALIAN
        ////////////////////////////////////////////////////////////
        case cLang == "IT"        // Italian
             oHmgApp():APP371 [01] := 'Pagina'
             oHmgApp():APP371 [02] := 'Anteprima di stampa'
             oHmgApp():APP371 [03] := 'Prima Pagina [HOME]'
             oHmgApp():APP371 [04] := 'Pagina Precedente [PGUP]'
             oHmgApp():APP371 [05] := 'Pagina Seguente [PGDN]'
             oHmgApp():APP371 [06] := 'Ultima Pagina [END]'
             oHmgApp():APP371 [07] := 'Vai Alla Pagina'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Stampa'
             oHmgApp():APP371 [10] := 'Pagina'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Annulla'
             oHmgApp():APP371 [13] := 'Selezioni Lo Stampatore'
             oHmgApp():APP371 [14] := 'Fascicoli'
             oHmgApp():APP371 [15] := 'Intervallo di stampa'
             oHmgApp():APP371 [16] := 'Tutti'
             oHmgApp():APP371 [17] := 'Pagine'
             oHmgApp():APP371 [18] := 'Da'
             oHmgApp():APP371 [19] := 'A'
             oHmgApp():APP371 [20] := 'Copie'
             oHmgApp():APP371 [21] := 'Tutte le pagine'
             oHmgApp():APP371 [22] := 'Le Pagine Pari'
             oHmgApp():APP371 [23] := 'Le Pagine Dispari'
             oHmgApp():APP371 [24] := 'Si'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Chiudi'
             oHmgApp():APP371 [27] := 'Salva'
             oHmgApp():APP371 [28] := 'Miniatura'
             oHmgApp():APP371 [29] := 'Generando Miniatura...  Prego Attesa...'

        /////////////////////////////////////////////////////////////
        // POLISH
        ////////////////////////////////////////////////////////////
        // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish
        case cLang == "PL"

             oHmgApp():APP371 [01] := 'Strona'
             oHmgApp():APP371 [02] := 'PodglÂ¹d wydruku'
             oHmgApp():APP371 [03] := 'Pierwsza strona [HOME]'
             oHmgApp():APP371 [04] := 'Poprzednia strona [PGUP]'
             oHmgApp():APP371 [05] := 'NastÃªpna strona [PGDN]'
             oHmgApp():APP371 [06] := 'Ostatnia strona [END]'
             oHmgApp():APP371 [07] := 'Skocz do strony'
             oHmgApp():APP371 [08] := 'PowiÃªksz'
             oHmgApp():APP371 [09] := 'Drukuj'
             oHmgApp():APP371 [10] := 'Numer strony'
             oHmgApp():APP371 [11] := 'Tak'
             oHmgApp():APP371 [12] := 'Przerwij'
             oHmgApp():APP371 [13] := 'Wybierz drukarkÃª'
             oHmgApp():APP371 [14] := 'Sortuj kopie'
             oHmgApp():APP371 [15] := 'Zakres wydruku'
             oHmgApp():APP371 [16] := 'Wszystkie'
             oHmgApp():APP371 [17] := 'Strony'
             oHmgApp():APP371 [18] := 'Od'
             oHmgApp():APP371 [19] := 'Do'
             oHmgApp():APP371 [20] := 'Kopie'
             oHmgApp():APP371 [21] := 'Wszystkie'
             oHmgApp():APP371 [22] := 'Nieparzyste'
             oHmgApp():APP371 [23] := 'Parzyste'
             oHmgApp():APP371 [24] := 'Tak'
             oHmgApp():APP371 [25] := 'Nie'
             oHmgApp():APP371 [26] := 'Zamknij'
             oHmgApp():APP371 [27] := 'Zapisz'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'GenerujÃª Thumbnails... ProszÃª czekaÃ¦...'

        /////////////////////////////////////////////////////////////
        // PORTUGUESE
        ////////////////////////////////////////////////////////////
        // case cLang == "pt.PT850"        // Portuguese
        case cLang == "PT"
             oHmgApp():APP371 [01] := 'PÃ¡gina'
             oHmgApp():APP371 [02] := 'VisualizaÃ§Ã£o prÃ©via da ImpressÃ£o'
             oHmgApp():APP371 [03] := 'Primeira PÃ¡gina [HOME]'
             oHmgApp():APP371 [04] := 'PÃ¡gina Anterior [PGUP]'
             oHmgApp():APP371 [05] := 'PrÃ³xima PÃ¡gina [PGDN]'
             oHmgApp():APP371 [06] := 'Ãšltima PÃ¡gina [END]'
             oHmgApp():APP371 [07] := 'Ir para PÃ¡gina NÂº...'
             oHmgApp():APP371 [08] := 'Ampliar'
             oHmgApp():APP371 [09] := 'Imprimir'
             oHmgApp():APP371 [10] := 'PÃ¡gina'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancelar'
             oHmgApp():APP371 [13] := 'Selecionar Impressora'
             oHmgApp():APP371 [14] := 'Ordenar CÃ³pias'
             oHmgApp():APP371 [15] := 'Faixa De ImpressÃ£o'
             oHmgApp():APP371 [16] := 'Tudo'
             oHmgApp():APP371 [17] := 'PÃ¡ginas'
             oHmgApp():APP371 [18] := 'De'
             oHmgApp():APP371 [19] := 'AtÃ©'
             oHmgApp():APP371 [20] := 'CÃ³pias'
             oHmgApp():APP371 [21] := 'Todas as PÃ¡ginas'
             oHmgApp():APP371 [22] := 'SÃ³ PÃ¡ginas Ãmpares'
             oHmgApp():APP371 [23] := 'SÃ³ PÃ¡ginas Pares'
             oHmgApp():APP371 [24] := 'Sim'
             oHmgApp():APP371 [25] := 'NÃ£o'
             oHmgApp():APP371 [26] := 'Fechar e Sair'
             oHmgApp():APP371 [27] := 'Salvar em Arquivo'
             oHmgApp():APP371 [28] := 'Gerar Miniaturas'
             oHmgApp():APP371 [29] := 'Aguarde por favor, gerando Miniaturas...'

        /////////////////////////////////////////////////////////////
        // RUSSIAN
        ////////////////////////////////////////////////////////////
        // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
        case cLang == "RU"
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // SPANISH
        ////////////////////////////////////////////////////////////
        // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
        case cLang == "ES"
             oHmgApp():APP371 [01] := 'PÃ¡gina'
             oHmgApp():APP371 [02] := 'Vista Previa'
             oHmgApp():APP371 [03] := 'Inicio [INICIO]'
             oHmgApp():APP371 [04] := 'Anterior [REPAG]'
             oHmgApp():APP371 [05] := 'Siguiente [AVPAG]'
             oHmgApp():APP371 [06] := 'Fin [FIN]'
             oHmgApp():APP371 [07] := 'Ir a'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Imprimir'
             oHmgApp():APP371 [10] := 'PÃ¡gina Nro.'
             oHmgApp():APP371 [11] := 'Aceptar'
             oHmgApp():APP371 [12] := 'Cancelar'
             oHmgApp():APP371 [13] := 'Seleccionar Impresora'
             oHmgApp():APP371 [14] := 'Ordenar Copias'
             oHmgApp():APP371 [15] := 'Rango de ImpresiÃ³n'
             oHmgApp():APP371 [16] := 'Todo'
             oHmgApp():APP371 [17] := 'PÃ¡ginas'
             oHmgApp():APP371 [18] := 'Desde'
             oHmgApp():APP371 [19] := 'Hasta'
             oHmgApp():APP371 [20] := 'Copias'
             oHmgApp():APP371 [21] := 'Todo El Rango'
             oHmgApp():APP371 [22] := 'Solo PÃ¡ginas Impares'
             oHmgApp():APP371 [23] := 'Solo PÃ¡ginas Pares'
             oHmgApp():APP371 [24] := 'Si'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Cerrar'
             oHmgApp():APP371 [27] := 'Guardar'
             oHmgApp():APP371 [28] := 'Miniaturas'
             oHmgApp():APP371 [29] := 'Generando Miniaturas... Espere Por Favor...'

        ///////////////////////////////////////////////////////////////////////
        // FINNISH
        ///////////////////////////////////////////////////////////////////////
        case cLang == "FI"        // Finnish
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // DUTCH
        ////////////////////////////////////////////////////////////
        case cLang == "NL"        // Dutch
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // SLOVENIAN
        ////////////////////////////////////////////////////////////
        // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
        case cLang == "SL"
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        OtherWise
        /////////////////////////////////////////////////////////////
        // DEFAULT ENGLISH
        ////////////////////////////////////////////////////////////

             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

    endcase

********************************************************************************************************************************************************
ELSE    // ANSI
********************************************************************************************************************************************************

    do case
        /////////////////////////////////////////////////////////////
        // TÜRKÇE
        ////////////////////////////////////////////////////////////
        // case cLang == "TRWIN" .OR. cLang == "TR"
        case cLang == "TR"
             oHmgApp():APP371 [01] := 'Sayfa'
             oHmgApp():APP371 [02] := 'Print Ön-izleme'
             oHmgApp():APP371 [03] := 'Ýlk Sayfa [HOME]'
             oHmgApp():APP371 [04] := 'Önceki Sayfa [PGUP]'
             oHmgApp():APP371 [05] := 'Sonraki Sayfa [PGDN]'
             oHmgApp():APP371 [06] := 'Son sayfa [END]'
             oHmgApp():APP371 [07] := 'Sayfa no'
             oHmgApp():APP371 [08] := 'Büyüt/Küçült'
             oHmgApp():APP371 [09] := 'Yazdýr'
             oHmgApp():APP371 [10] := 'Sayfa No'
             oHmgApp():APP371 [11] := 'Tamam'
             oHmgApp():APP371 [12] := 'Ýptal'
             oHmgApp():APP371 [13] := 'Printer Seç'
             oHmgApp():APP371 [14] := 'Kopyalarý birleþtir'
             oHmgApp():APP371 [15] := 'Sýnýrlý Print'
             oHmgApp():APP371 [16] := 'Hepsi'
             oHmgApp():APP371 [17] := 'Sayfalar'
             oHmgApp():APP371 [18] := 'Ýlk'
             oHmgApp():APP371 [19] := 'Son'
             oHmgApp():APP371 [20] := 'Kopya sayýsý'
             oHmgApp():APP371 [21] := 'Bütün sýnýrlar'
             oHmgApp():APP371 [22] := 'Yalnýz tek sayfalar'
             oHmgApp():APP371 [23] := 'Yalnýz çift sayfalar'
             oHmgApp():APP371 [24] := 'Evet'
             oHmgApp():APP371 [25] := 'Hayýr'
             oHmgApp():APP371 [26] := 'Kapat'
             oHmgApp():APP371 [27] := 'Kaydet'
             oHmgApp():APP371 [28] := 'Sayfa ikonlarý'
             oHmgApp():APP371 [29] := 'Sayfa ikonlarý oluþturuluyor... Lütfen bekleyin...'

        /////////////////////////////////////////////////////////////
        // CZECH
        ////////////////////////////////////////////////////////////
        // case cLang ==  "CS" .OR. cLang == "CSWIN"
        case cLang ==  "CS"
             oHmgApp():APP371 [01] := 'Strana'
             oHmgApp():APP371 [02] := 'Náhled'
             oHmgApp():APP371 [03] := 'První strana [HOME]'
             oHmgApp():APP371 [04] := 'Pøedchozí strana [PGUP]'
             oHmgApp():APP371 [05] := 'Další strana [PGDN]'
             oHmgApp():APP371 [06] := 'Poslední strana [END]'
             oHmgApp():APP371 [07] := 'Jdi na stranu'
             oHmgApp():APP371 [08] := 'Lupa'
             oHmgApp():APP371 [09] := 'Tisk'
             oHmgApp():APP371 [10] := 'Èíslo strany'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Storno'
             oHmgApp():APP371 [13] := 'Vyber tiskárnu'
             oHmgApp():APP371 [14] := 'Tøídìní'
             oHmgApp():APP371 [15] := 'Rozsah tisku'
             oHmgApp():APP371 [16] := 'vše'
             oHmgApp():APP371 [17] := 'strany'
             oHmgApp():APP371 [18] := 'od'
             oHmgApp():APP371 [19] := 'do'
             oHmgApp():APP371 [20] := 'kopií'
             oHmgApp():APP371 [21] := 'všechny strany'
             oHmgApp():APP371 [22] := 'liché strany'
             oHmgApp():APP371 [23] := 'sudé strany'
             oHmgApp():APP371 [24] := 'Ano'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Zavøi'
             oHmgApp():APP371 [27] := 'Ulož'
             oHmgApp():APP371 [28] := 'Miniatury'
             oHmgApp():APP371 [29] := 'Generuji miniatury... Èekejte, prosím...'

        /////////////////////////////////////////////////////////////
        // CROATIAN
        ////////////////////////////////////////////////////////////
        // case cLang == "HR852" // Croatian
        case cLang == "HR"
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // BASQUE
        ////////////////////////////////////////////////////////////
        case cLang == "EU"        // Basque.
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // ENGLISH
        ////////////////////////////////////////////////////////////
        case cLang == "EN"        // English
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // FRENCH
        ////////////////////////////////////////////////////////////
        case cLang == "FR"        // French
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := "Aperçu avant impression"
             oHmgApp():APP371 [03] := 'Première page [HOME]'
             oHmgApp():APP371 [04] := 'Page précédente [PGUP]'
             oHmgApp():APP371 [05] := 'Page suivante [PGDN]'
             oHmgApp():APP371 [06] := 'Dernière page [END]'
             oHmgApp():APP371 [07] := 'Allez page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Imprimer'
             oHmgApp():APP371 [10] := 'Page'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Annulation'
             oHmgApp():APP371 [13] := "Sélection de l'imprimante"
             oHmgApp():APP371 [14] := "Assemblez"
             oHmgApp():APP371 [15] := "Paramètres d'impression"
             oHmgApp():APP371 [16] := 'Tous'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'De'
             oHmgApp():APP371 [19] := 'À'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'Toutes les pages'
             oHmgApp():APP371 [22] := 'Pages Impaires'
             oHmgApp():APP371 [23] := 'Pages Paires'
             oHmgApp():APP371 [24] := 'Oui'
             oHmgApp():APP371 [25] := 'Non'
             oHmgApp():APP371 [26] := 'Fermer'
             oHmgApp():APP371 [27] := 'Sauver'
             oHmgApp():APP371 [28] := 'Affichettes'
             oHmgApp():APP371 [29] := "Création des affichettes... Merci d'attendre..."

        /////////////////////////////////////////////////////////////
        // GERMAN
        ////////////////////////////////////////////////////////////
        // case cLang == "DEWIN" .OR. cLang == "DE"       // German
        case cLang == "DE"
             oHmgApp():APP371 [01] := 'Seite'
             oHmgApp():APP371 [02] := 'DruckcVorbetrachtung'
             oHmgApp():APP371 [03] := 'Erste Seite [HOME]'
             oHmgApp():APP371 [04] := 'Vorige Seite [PGUP]'
             oHmgApp():APP371 [05] := 'Folgende Seite [PGDN]'
             oHmgApp():APP371 [06] := 'Letzte Seite [END]'
             oHmgApp():APP371 [07] := 'Gehen Sie Zu paginieren'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Druck'
             oHmgApp():APP371 [10] := 'Seitenzahl'
             oHmgApp():APP371 [11] := 'O.K.'
             oHmgApp():APP371 [12] := 'Löschen'
             oHmgApp():APP371 [13] := 'Wählen Sie Drucker Vor'
             oHmgApp():APP371 [14] := 'Sortieren'
             oHmgApp():APP371 [15] := 'DruckcStrecke'
             oHmgApp():APP371 [16] := 'Alle'
             oHmgApp():APP371 [17] := 'Seiten'
             oHmgApp():APP371 [18] := 'Von'
             oHmgApp():APP371 [19] := 'Zu'
             oHmgApp():APP371 [20] := 'Kopien'
             oHmgApp():APP371 [21] := 'Alle Strecke'
             oHmgApp():APP371 [22] := 'Nur Ungerade Seiten'
             oHmgApp():APP371 [23] := 'Nur Gleichmäßige Seiten'
             oHmgApp():APP371 [24] := 'Ja'
             oHmgApp():APP371 [25] := 'Nein'
             oHmgApp():APP371 [26] := 'Fenster'
             oHmgApp():APP371 [27] := 'Speichern'
             oHmgApp():APP371 [28] := 'Überblick'
             oHmgApp():APP371 [29] := 'Überblick Erzeugen...  Bitte Wartezeit...'

        /////////////////////////////////////////////////////////////
        // ITALIAN
        ////////////////////////////////////////////////////////////
        case cLang == "IT"        // Italian
             oHmgApp():APP371 [01] := 'Pagina'
             oHmgApp():APP371 [02] := 'Anteprima di stampa'
             oHmgApp():APP371 [03] := 'Prima Pagina [HOME]'
             oHmgApp():APP371 [04] := 'Pagina Precedente [PGUP]'
             oHmgApp():APP371 [05] := 'Pagina Seguente [PGDN]'
             oHmgApp():APP371 [06] := 'Ultima Pagina [END]'
             oHmgApp():APP371 [07] := 'Vai Alla Pagina'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Stampa'
             oHmgApp():APP371 [10] := 'Pagina'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Annulla'
             oHmgApp():APP371 [13] := 'Selezioni Lo Stampatore'
             oHmgApp():APP371 [14] := 'Fascicoli'
             oHmgApp():APP371 [15] := 'Intervallo di stampa'
             oHmgApp():APP371 [16] := 'Tutti'
             oHmgApp():APP371 [17] := 'Pagine'
             oHmgApp():APP371 [18] := 'Da'
             oHmgApp():APP371 [19] := 'A'
             oHmgApp():APP371 [20] := 'Copie'
             oHmgApp():APP371 [21] := 'Tutte le pagine'
             oHmgApp():APP371 [22] := 'Le Pagine Pari'
             oHmgApp():APP371 [23] := 'Le Pagine Dispari'
             oHmgApp():APP371 [24] := 'Si'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Chiudi'
             oHmgApp():APP371 [27] := 'Salva'
             oHmgApp():APP371 [28] := 'Miniatura'
             oHmgApp():APP371 [29] := 'Generando Miniatura...  Prego Attesa...'

        /////////////////////////////////////////////////////////////
        // POLISH
        ////////////////////////////////////////////////////////////
        // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish
        case cLang == "PL"
             oHmgApp():APP371 [01] := 'Strona'
             oHmgApp():APP371 [02] := 'Podgl¹d wydruku'
             oHmgApp():APP371 [03] := 'Pierwsza strona [HOME]'
             oHmgApp():APP371 [04] := 'Poprzednia strona [PGUP]'
             oHmgApp():APP371 [05] := 'Nastêpna strona [PGDN]'
             oHmgApp():APP371 [06] := 'Ostatnia strona [END]'
             oHmgApp():APP371 [07] := 'Skocz do strony'
             oHmgApp():APP371 [08] := 'Powiêksz'
             oHmgApp():APP371 [09] := 'Drukuj'
             oHmgApp():APP371 [10] := 'Numer strony'
             oHmgApp():APP371 [11] := 'Tak'
             oHmgApp():APP371 [12] := 'Przerwij'
             oHmgApp():APP371 [13] := 'Wybierz drukarkê'
             oHmgApp():APP371 [14] := 'Sortuj kopie'
             oHmgApp():APP371 [15] := 'Zakres wydruku'
             oHmgApp():APP371 [16] := 'Wszystkie'
             oHmgApp():APP371 [17] := 'Strony'
             oHmgApp():APP371 [18] := 'Od'
             oHmgApp():APP371 [19] := 'Do'
             oHmgApp():APP371 [20] := 'Kopie'
             oHmgApp():APP371 [21] := 'Wszystkie'
             oHmgApp():APP371 [22] := 'Nieparzyste'
             oHmgApp():APP371 [23] := 'Parzyste'
             oHmgApp():APP371 [24] := 'Tak'
             oHmgApp():APP371 [25] := 'Nie'
             oHmgApp():APP371 [26] := 'Zamknij'
             oHmgApp():APP371 [27] := 'Zapisz'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generujê Thumbnails... Proszê czekaæ...'

        /////////////////////////////////////////////////////////////
        // PORTUGUESE
        ////////////////////////////////////////////////////////////
        // case cLang == "pt.PT850"        // Portuguese
        case cLang == "PT"
             oHmgApp():APP371 [01] := 'Página'
             oHmgApp():APP371 [02] := 'Visualização prévia da Impressão'
             oHmgApp():APP371 [03] := 'Primeira Página [HOME]'
             oHmgApp():APP371 [04] := 'Página Anterior [PGUP]'
             oHmgApp():APP371 [05] := 'Próxima Página [PGDN]'
             oHmgApp():APP371 [06] := 'Última Página [END]'
             oHmgApp():APP371 [07] := 'Ir para Página Nº...'
             oHmgApp():APP371 [08] := 'Ampliar'
             oHmgApp():APP371 [09] := 'Imprimir'
             oHmgApp():APP371 [10] := 'Página'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancelar'
             oHmgApp():APP371 [13] := 'Selecionar Impressora'
             oHmgApp():APP371 [14] := 'Ordenar Cópias'
             oHmgApp():APP371 [15] := 'Faixa De Impressão'
             oHmgApp():APP371 [16] := 'Tudo'
             oHmgApp():APP371 [17] := 'Páginas'
             oHmgApp():APP371 [18] := 'De'
             oHmgApp():APP371 [19] := 'Até'
             oHmgApp():APP371 [20] := 'Cópias'
             oHmgApp():APP371 [21] := 'Todas as Páginas'
             oHmgApp():APP371 [22] := 'Só Páginas Ímpares'
             oHmgApp():APP371 [23] := 'Só Páginas Pares'
             oHmgApp():APP371 [24] := 'Sim'
             oHmgApp():APP371 [25] := 'Não'
             oHmgApp():APP371 [26] := 'Fechar e Sair'
             oHmgApp():APP371 [27] := 'Salvar em Arquivo'
             oHmgApp():APP371 [28] := 'Gerar Miniaturas'
             oHmgApp():APP371 [29] := 'Aguarde por favor, gerando Miniaturas...'

        /////////////////////////////////////////////////////////////
        // RUSSIAN
        ////////////////////////////////////////////////////////////
        // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
        case cLang == "RU"
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // SPANISH
        ////////////////////////////////////////////////////////////
        // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
        case cLang == "ES"
             oHmgApp():APP371 [01] := 'Página'
             oHmgApp():APP371 [02] := 'Vista Previa'
             oHmgApp():APP371 [03] := 'Inicio [INICIO]'
             oHmgApp():APP371 [04] := 'Anterior [REPAG]'
             oHmgApp():APP371 [05] := 'Siguiente [AVPAG]'
             oHmgApp():APP371 [06] := 'Fin [FIN]'
             oHmgApp():APP371 [07] := 'Ir a'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Imprimir'
             oHmgApp():APP371 [10] := 'Página Nro.'
             oHmgApp():APP371 [11] := 'Aceptar'
             oHmgApp():APP371 [12] := 'Cancelar'
             oHmgApp():APP371 [13] := 'Seleccionar Impresora'
             oHmgApp():APP371 [14] := 'Ordenar Copias'
             oHmgApp():APP371 [15] := 'Rango de Impresión'
             oHmgApp():APP371 [16] := 'Todo'
             oHmgApp():APP371 [17] := 'Páginas'
             oHmgApp():APP371 [18] := 'Desde'
             oHmgApp():APP371 [19] := 'Hasta'
             oHmgApp():APP371 [20] := 'Copias'
             oHmgApp():APP371 [21] := 'Todo El Rango'
             oHmgApp():APP371 [22] := 'Solo Páginas Impares'
             oHmgApp():APP371 [23] := 'Solo Páginas Pares'
             oHmgApp():APP371 [24] := 'Si'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Cerrar'
             oHmgApp():APP371 [27] := 'Guardar'
             oHmgApp():APP371 [28] := 'Miniaturas'
             oHmgApp():APP371 [29] := 'Generando Miniaturas... Espere Por Favor...'

        ///////////////////////////////////////////////////////////////////////
        // FINNISH
        ///////////////////////////////////////////////////////////////////////
        case cLang == "FI"        // Finnish
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // DUTCH
        ////////////////////////////////////////////////////////////
        case cLang == "NL"        // Dutch
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        /////////////////////////////////////////////////////////////
        // SLOVENIAN
        ////////////////////////////////////////////////////////////
        // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
        case cLang == "SL"
             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

        OtherWise
        /////////////////////////////////////////////////////////////
        // DEFAULT ENGLISH
        ////////////////////////////////////////////////////////////

             oHmgApp():APP371 [01] := 'Page'
             oHmgApp():APP371 [02] := 'Print Preview'
             oHmgApp():APP371 [03] := 'First Page [HOME]'
             oHmgApp():APP371 [04] := 'Previous Page [PGUP]'
             oHmgApp():APP371 [05] := 'Next Page [PGDN]'
             oHmgApp():APP371 [06] := 'Last Page [END]'
             oHmgApp():APP371 [07] := 'Go To Page'
             oHmgApp():APP371 [08] := 'Zoom'
             oHmgApp():APP371 [09] := 'Print'
             oHmgApp():APP371 [10] := 'Page Number'
             oHmgApp():APP371 [11] := 'Ok'
             oHmgApp():APP371 [12] := 'Cancel'
             oHmgApp():APP371 [13] := 'Select Printer'
             oHmgApp():APP371 [14] := 'Collate Copies'
             oHmgApp():APP371 [15] := 'Print Range'
             oHmgApp():APP371 [16] := 'All'
             oHmgApp():APP371 [17] := 'Pages'
             oHmgApp():APP371 [18] := 'From'
             oHmgApp():APP371 [19] := 'To'
             oHmgApp():APP371 [20] := 'Copies'
             oHmgApp():APP371 [21] := 'All Range'
             oHmgApp():APP371 [22] := 'Odd Pages Only'
             oHmgApp():APP371 [23] := 'Even Pages Only'
             oHmgApp():APP371 [24] := 'Yes'
             oHmgApp():APP371 [25] := 'No'
             oHmgApp():APP371 [26] := 'Close'
             oHmgApp():APP371 [27] := 'Save'
             oHmgApp():APP371 [28] := 'Thumbnails'
             oHmgApp():APP371 [29] := 'Generating Thumbnails... Please Wait...'

    endcase

ENDIF   // HMG_IsCurrentCodePageUnicode()
Return Nil


Function GETPRINTABLEAREAWIDTH()
Return _HMG_PRINTER_GETPRINTERWIDTH ( oHmgApp():APP374 )


Function GETPRINTABLEAREAHEIGHT()
Return _HMG_PRINTER_GETPRINTERHEIGHT ( oHmgApp():APP374 )


Function GETPRINTABLEAREAHORIZONTALOFFSET()
IF ! __MVEXIST ( 'oHmgApp():APP374' )
    Return 0
ENDIF
Return ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX ( oHmgApp():APP374 ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX ( oHmgApp():APP374 ) * 25.4 )


Function GETPRINTABLEAREAVERTICALOFFSET()
IF ! __MVEXIST ( 'oHmgApp():APP374' )
    Return 0
ENDIF
Return ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY ( oHmgApp():APP374 ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY ( oHmgApp():APP374 ) * 25.4 )


Function _HMG_PRINTER_MouseZoom (Flag)
Local Width  := GetDesktopWidth()
Local Height := GetDesktopHeight()
Local Q := 0
Local DeltaHeight := 35 + GetTitleHeight() + GetBorderHeight() + 10

IF ValType(Flag) <> "L"
   IF _HMG_PRINTER_SpltChldMouseCursor() == .F.   // ADD April 2014
      RETURN NIL
   ENDIF
ENDIF

If oHmgApp():APP365 == 1000 + oHmgApp():APP359

    oHmgApp():APP365 := 0
    oHmgApp():APP363 := 0
    oHmgApp():APP364 := 0

    SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 50 , .T. )
    SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 50 , .T. )

    _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('SPLITCHILD_1'))

Else

    * Calculate Quadrant

    if  oHmgApp():MouseCol <= ( Width / 2 ) - oHmgApp():APP367 .And. ;
        oHmgApp():MouseRow <= ( Height / 2 )  - DeltaHeight

        Q := 1

    Elseif  oHmgApp():MouseCol > ( Width / 2 ) - oHmgApp():APP367 .And. ;
            oHmgApp():MouseRow <= ( Height / 2 )  - DeltaHeight

        Q := 2

    Elseif  oHmgApp():MouseCol <= ( Width / 2 ) - oHmgApp():APP367 .And. ;
            oHmgApp():MouseRow > ( Height / 2 ) - DeltaHeight

        Q := 3

    Elseif  oHmgApp():MouseCol > ( Width / 2 ) - oHmgApp():APP367 .And. ;
            oHmgApp():MouseRow > ( Height / 2 ) - DeltaHeight

        Q := 4

    EndIf

    if  _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) > ;
        _HMG_PRINTER_GETPAGEWIDTH(oHmgApp():APP372)

        * Portrait

        If Q == 1
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := 100
            oHmgApp():APP364 := 400
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 10 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 40 , .T. )
        ElseIf Q == 2
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := -100
            oHmgApp():APP364 := 400
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 10 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 60 , .T. )
        ElseIf Q == 3
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := 100
            oHmgApp():APP364 := -400
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 90 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 40 , .T. )
        ElseIf Q == 4
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := -100
            oHmgApp():APP364 := -400
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 90 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 60 , .T. )
        EndIf

    Else

        * Landscape

        If Q == 1
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := 500
            oHmgApp():APP364 := 300
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 20 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 1 , .T. )
        ElseIf Q == 2
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := -500
            oHmgApp():APP364 := 300
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 20 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 99 , .T. )
        ElseIf Q == 3
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := 500
            oHmgApp():APP364 := -300
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 80 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 1 , .T. )
        ElseIf Q == 4
            oHmgApp():APP365 := 1000 + oHmgApp():APP359
            oHmgApp():APP363 := -500
            oHmgApp():APP364 := -300
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 80 , .T. )
            SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 99 , .T. )
        EndIf

    EndIf

    _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS (GetFormHandle('SPLITCHILD_1'))
    DoMethod("SPLITCHILD_1","SetFocus")
EndIf
_HMG_PRINTER_PREVIEWRefresh()
Return Nil


Function _HMG_PRINTER_Zoom()
If oHmgApp():APP365 == 1000 + oHmgApp():APP359

    oHmgApp():APP365 := 0
    oHmgApp():APP363 := 0
    oHmgApp():APP364 := 0

    SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 50 , .T. )
    SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 50 , .T. )

    _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('SPLITCHILD_1'))
    _HMG_PRINTER_PREVIEWRefresh()
   DoMethod("_HMG_PRINTER_SHOWPREVIEW","SetFocus")
Else

    if  _HMG_PRINTER_GETPAGEHEIGHT(oHmgApp():APP372) > ;
        _HMG_PRINTER_GETPAGEWIDTH(oHmgApp():APP372)

        oHmgApp():APP365 := 1000 + oHmgApp():APP359
        oHmgApp():APP363 := 100
        oHmgApp():APP364 := 400
        SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 10 , .T. )
        SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 40 , .T. )

    Else

        oHmgApp():APP365 := 1000 + oHmgApp():APP359
        oHmgApp():APP363 := 500
        oHmgApp():APP364 := 300
        SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_VERT , 20 , .T. )
        SetScrollPos ( GetFormHandle('SPLITCHILD_1') , SB_HORZ , 1 , .T. )

    EndIf
    _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS (GetFormHandle('SPLITCHILD_1'))
   _HMG_PRINTER_PREVIEWRefresh()
   DoMethod("SPLITCHILD_1","SetFocus")
EndIf
Return Nil


Function _HMG_PRINTER_SETJOBNAME( cName )
if valtype ( cName ) = 'U'
    oHmgApp():APP358 := 'HMG Print System'
else
    oHmgApp():APP358 := cName
endif
Return Nil



FUNCTION HMG_PrintGetJobInfo ( aJobData )   // by Dr. Claudio Soto, August 2015
LOCAL cPrinterName, nJobID
   IF ValType ( aJobData ) == "U"
      aJobData := OpenPrinterGetJobData()
   ENDIF
   nJobID       := aJobData [1]
   cPrinterName := aJobData [2]
RETURN _HMG_PrintGetJobInfo( cPrinterName, nJobID ) // --> { nJobID, cPrinterName, cMachineName, cUserName, cDocument, cDataType, cStatus, nStatus
                                                    //       nPriorityLevel, nPositionPrintQueue, nTotalPages, nPagesPrinted, cLocalDate, cLocalTime }


FUNCTION HMG_PrinterGetStatus ( cPrinterName )
   IF ValType ( cPrinterName ) == "U"
      cPrinterName := OpenPrinterGetName()
   ENDIF
RETURN _HMG_PrinterGetStatus( cPrinterName ) // --> nStatus


*******************************************************************************************************************


*------------------------------------------------------------------------------*
* Based on HBMZIP Harbour contribution library samples.
*------------------------------------------------------------------------------*
Function COMPRESSFILES ( cFileName , aDir , bBlock , lOvr )
Local hZip , i , cPassword

if valtype (lOvr) == 'L'
    if lOvr == .t.
        if file (cFileName)
            delete file (cFileName)
        endif
    endif
endif

hZip := HB_ZIPOPEN( cFileName )
IF ! EMPTY( hZip )
    FOR i := 1 To HMG_LEN (aDir)
        if valtype (bBlock) == 'B'
            Eval ( bBlock , aDir [i] , i )
        endif
        HB_ZipStoreFile( hZip, aDir [ i ], aDir [ i ] , cPassword )
    NEXT
ENDIF
HB_ZIPCLOSE( hZip )
Return Nil

*------------------------------------------------------------------------------*
* Based on HBMZIP Harbour contribution library samples.
*------------------------------------------------------------------------------*
Function UNCOMPRESSFILES ( cFileName , bBlock )
Local i := 0 , hUnzip , nErr, cFile, dDate, cTime, nSize, nCompSize

hUnzip := HB_UNZIPOPEN( cFileName )

nErr := HB_UNZIPFILEFIRST( hUnzip )

DO WHILE nErr == 0

    HB_UnzipFileInfo( hUnzip, @cFile, @dDate, @cTime,,,, @nSize, @nCompSize )

    i++
    if valtype (bBlock) = 'B'
        Eval ( bBlock , cFile , i )
    endif

    HB_UnzipExtractCurrentFile( hUnzip, NIL, NIL )

    nErr := HB_UNZIPFILENEXT( hUnzip )

ENDDO
HB_UNZIPCLOSE( hUnzip )
Return Nil

Function _GetControlObject (ControlName,ParentForm)
Local mVar , i

mVar := '_' + ParentForm + '_' + ControlName
i := &mVar
if i == 0
    Return ''
EndIf
Return (ControlByIndex( &MVAR ):CTRL039 )



******************************************************************************************


Function _DefineActivex ( cControlName, cParentForm, nRow, nCol , nWidth , nHeight , cProgId )
Local mVar , nControlHandle , k := 0 , nParentFormHandle , oOle
Local nAtlDllHandle , cParentTabName, nInterfacePointer, oControl

* If defined inside DEFINE WINDOW structure, determine cParentForm

if oHmgApp():APP264 = .T.
    cParentForm := oHmgApp():ActiveFormName
endif

* If defined inside a Tab structure, adjust position and determine
* cParentForm

if oHmgApp():FrameLevel > 0
    nCol        := nCol + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
    nRow        := nRow + oHmgApp():APP333 [ oHmgApp():FrameLevel]
    cParentForm     := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
    cParentTabName  := oHmgApp():APP225
EndIf

* Check for errors

* Check Parent Window

If .Not. _IsWindowDefined (cParentForm)
    MsgHMGError("Window: "+ cParentForm + " is not defined. Program terminated" )
Endif

* Check Control

If _IsControlDefined (cControlName,cParentForm)
    MsgHMGError ("Control: " + cControlName + " Of " + cParentForm + " Already defined. Program Terminated" )
Endif

* Check cProgId

If valType (cProgId) <> 'C'
    MsgHMGError ("Control: " + cControlName + " Of " + cParentForm + " PROGID Property Invalid Type. Program Terminated" )
EndIf

If Empty (cProgId)
    MsgHMGError ("Control: " + cControlName + " Of " + cParentForm + " PROGID Can't be empty. Program Terminated" )
EndIf

* Define public variable associated with control

mVar := '_' + cParentForm + '_' + cControlName

nParentFormHandle := GetFormHandle (cParentForm)

* Init Activex

aResult := InitActivex( nParentFormHandle , cProgId , nCol , nRow , nWidth , nHeight )

nControlHandle      := aResult [1]
nInterfacePointer   := aResult [2]
nAtlDllHandle       := aResult [3]

If oHmgApp():BeginTabActive = .T.
    aAdd ( oHmgApp():APP142 , nControlhandle )
EndIf

* Create OLE control

oOle := ToleAuto():New( nInterfacePointer )

k := _GetControlFree()

Public &mVar. := k
oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "ACTIVEX"
      :Name := cControlName
      :Handle := nControlHandle
      :ParentFormHandle := nParentFormHandle
      :CTRL005 := 0
      :CTRL006 := ""
      :CTRL007 := {}
      :CTRL008 := Nil
      :CTRL009 := ""
      :CTRL010 := Nil
      :CTRL011 := Nil
      :CTRL012 := ""
      :IsDeleted := .F.
      :CTRL014 := Nil
      :CTRL015 := Nil
      :CTRL016 := ""
      :CTRL017 := {}
      :CTRL018 := nRow
      :CTRL019 := nCol
      :CTRL020 := nWidth
      :CTRL021 := nHeight
      :CTRL022 := 'T'
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := ""
      :CTRL026 := 0
      :CTRL027 := ""
      :CTRL028 := 0
      :CTRL029 := {.f.,.f.,.f.,.f.}
      :CTRL030 := ""
      :CTRL031 := ""
      :CTRL032 := 0
      :CTRL033 := ""
      :CTRL034 := .t.
      :CTRL035 := nAtlDllHandle
      :CTRL036 := 0
      :CTRL037 := 0
      :CTRL038 := .T.
      :CTRL039 := oOle
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH
   Return oOle


Function _HMG_SetHeaderImages ( cControlName, cParentForm , nColumn , cImage  )
Local i , nControlHandle , nHeaderImageListHandle , aHeaderImages
Local cControlType
Local aHeadersJustify
LOCAL NoTransHeader

* Get Control Type

cControlType := GetControlType (cControlName,cParentForm)

* Get Control Index

i := GetControlIndex ( cControlName, cParentForm )

* Get Control handle

nControlHandle := ControlByIndex( i ):Handle


* Process According Control Type

If cControlType == 'GRID' .Or. cControlType == 'MULTIGRID'

    * Get Header Justify Array

    aHeadersJustify := ControlByIndex( I ):CTRL037

        * Get Header Images Array *

    aHeaderImages := ControlByIndex( I ):CTRL022

    * Get Header ImageList Handle *

    nHeaderImageListHandle := ControlByIndex( I ):CTRL026

    NoTransHeader := ControlByIndex( I ):CTRL040 [ 39 ]

    * Destroy Current ImageList *

    IMAGELIST_DESTROY ( nHeaderImageListHandle )

    * Updete aHeaderImages Specified Column With The New Image *

    aHeaderImages [ nColumn ] := cImage

    ControlByIndex( I ):CTRL022 := aHeaderImages

    * Set New Image *

    nHeaderImageListHandle := SetListViewHeaderImages ( nControlHandle , aHeaderImages , aHeadersJustify , NoTransHeader)

    * Update ImageList Handle in Control Data Array *

    ControlByIndex( I ):CTRL026 := nHeaderImageListHandle

#ifdef COMPILEBROWSE

ElseIf cControlType == 'BROWSE'

    * Get Header Justify Array

    aHeadersJustify := ControlByIndex( I ):CTRL039 [11]

        * Get Header Images Array *

    aHeaderImages := ControlByIndex( I ):CTRL039 [9]

    * Get Header ImageList Handle *

    nHeaderImageListHandle := ControlByIndex( I ):CTRL039 [10]

    * Destroy Current ImageList *

    IMAGELIST_DESTROY ( nHeaderImageListHandle )

    * Updete aHeaderImages Specified Column With The New Image *

    aHeaderImages [ nColumn ] := cImage

    ControlByIndex( I ):CTRL039 [9] := aHeaderImages

    * Set New Image *

    // NoTransHeader := .F.

    nHeaderImageListHandle := SetListViewHeaderImages ( nControlHandle , aHeaderImages , aHeadersJustify ,  .F. /* NoTransHeader */ )  // Browse

    * Update ImageList Handle in Control Data Array *

    ControlByIndex( I ):CTRL039 [10] := nHeaderImageListHandle

#endif

EndIf
Return Nil

Function _HMG_GetHeaderImages ( cControlName, cParentForm , nColumn )
Local i , aHeaderImages
Local cControlType
Local cRetVal

* Get Control Type *

cControlType := GetControlType (cControlName,cParentForm)

* Get Control Index *

i := GetControlIndex ( cControlName, cParentForm )


* Process According Control Type

If cControlType == 'GRID' .Or. cControlType == 'MULTIGRID'

        * Get Header Images Array *

    aHeaderImages := ControlByIndex( I ):CTRL022

    cRetVal := aHeaderImages [ nColumn ]

#ifdef COMPILEBROWSE

ElseIf cControlType == 'BROWSE'

        * Get Header Images Array *

    aHeaderImages := ControlByIndex( I ):CTRL039 [9]

    cRetVal := aHeaderImages [ nColumn ]

#endif

EndIf
Return cRetVal

Function SetProperty ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local i, hWnd
Local cMacro
Local k

IF _GridEx_SetProperty      ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 ) == .T.
   RETURN NIL
ENDIF

IF _Tree_SetProperty        ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 ) == .T.
   RETURN NIL
ENDIF

IF _RichEditBox_SetProperty ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 ) == .T.
   RETURN NIL
ENDIF

if Pcount() == 3 // Window

    Arg2 := HMG_UPPER (ALLTRIM (Arg2))

    For i := 1 To HMG_LEN ( oHmgApp():APP061 )
        If Arg2 == oHmgApp():APP061 [i] [1]
            cMacro := oHmgApp():APP061 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If .Not. _IsWindowDefined ( Arg1 )
        MsgHMGError("Window: "+ Arg1 + " is not defined. Program terminated" )
    Endif

  hWnd := GetFormHandle( Arg1 )

    if     Arg2 == 'TITLE'
        SetWindowText ( GetFormHandle( Arg1 ) , Arg3 )

    ElseIf Arg2 == 'HEIGHT'
        _SetWindowSizePos ( Arg1 , , , , Arg3 )

    ElseIf Arg2 == 'WIDTH'
        _SetWindowSizePos ( Arg1 , , , Arg3 , )

    ElseIf Arg2 == 'COL'
        _SetWindowSizePos ( Arg1 , , Arg3 , , )

    ElseIf Arg2 == 'ROW'
        _SetWindowSizePos ( Arg1 , Arg3 , , , )

    ElseIf Arg2 == 'NOTIFYICON'
        _SetNotifyIconName ( Arg1 , Arg3 )

    ElseIf Arg2 == 'NOTIFYTOOLTIP'
        _SetNotifyIconTooltip ( Arg1 , Arg3 )

    ElseIf Arg2 == 'CURSOR'
        SetWindowCursor ( GetFormHandle( Arg1 ) , Arg3 )

  ELSEIF Arg2 == HMG_UPPER ("NoClose")
      IF Arg3 == .T.
         xDisableMenuItem ( GetSystemMenu (hWnd), SC_CLOSE )
      ELSE
         xEnableMenuItem  ( GetSystemMenu (hWnd), SC_CLOSE )
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("NoCaption")
      IF Arg3 == .T.
         HMG_ChangeWindowStyle ( hWnd, NIL, WS_CAPTION, .F. )   // remove style
      ELSE
         HMG_ChangeWindowStyle ( hWnd, WS_CAPTION, NIL, .F. )   // add style
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("NoMaximize")
      IF HMG_IsWindowStyle ( hWnd, WS_EX_CONTEXTHELP, .T. ) == .F.
        IF Arg3 == .T.
           HMG_ChangeWindowStyle ( hWnd, NIL, WS_MAXIMIZEBOX, .F. )   // remove style
        ELSE
           HMG_ChangeWindowStyle ( hWnd, WS_MAXIMIZEBOX, NIL, .F. )   // add style
        ENDIF
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("NoMinimize")
      IF HMG_IsWindowStyle ( hWnd, WS_EX_CONTEXTHELP, .T. ) == .F.
        IF Arg3 == .T.
           HMG_ChangeWindowStyle ( hWnd, NIL, WS_MINIMIZEBOX, .F. )   // remove style
        ELSE
           HMG_ChangeWindowStyle ( hWnd, WS_MINIMIZEBOX, NIL, .F. )   // add style
        ENDIF
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("NoSize")
      IF Arg3 == .T.
         HMG_ChangeWindowStyle ( hWnd, NIL, WS_SIZEBOX, .F. )   // remove style
      ELSE
         HMG_ChangeWindowStyle ( hWnd, WS_SIZEBOX, NIL, .F. )   // add style
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("NoSysMenu")
      IF Arg3 == .T.
         HMG_ChangeWindowStyle ( hWnd, NIL, WS_SYSMENU, .F. )   // remove style
      ELSE
         HMG_ChangeWindowStyle ( hWnd, WS_SYSMENU, NIL, .F. )   // add style
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("HScroll")
      IF Arg3 == .T.
         HMG_ChangeWindowStyle ( hWnd, WS_HSCROLL, NIL, .F. )   // add style
      ELSE
         HMG_ChangeWindowStyle ( hWnd, NIL, WS_HSCROLL, .F. )   // remove style
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("VScroll")
      IF Arg3 == .T.
         HMG_ChangeWindowStyle ( hWnd, WS_VSCROLL, NIL, .F. )   // add style
      ELSE
         HMG_ChangeWindowStyle ( hWnd, NIL, WS_VSCROLL, .F. )   // remove style
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("Enabled")
      IF Arg3 == .T.
         EnableWindow ( hWnd )
      ELSE
         DisableWindow ( hWnd )
      ENDIF

  ELSEIF Arg2 == HMG_UPPER ("AlphaBlendTransparent")
      SetLayeredWindowAttributes (hWnd, 0, Arg3, LWA_ALPHA)   // nAlphaBlend = 0 to 255 (completely transparent = 0, opaque = 255)

  ELSEIF Arg2 == HMG_UPPER ("BackColorTransparent")
      SetLayeredWindowAttributes ( hWnd, RGB (Arg3[1],Arg3[2],Arg3[3]), 0, LWA_COLORKEY)

  EndIf

ElseIf Pcount() == 4 // CONTROL

    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP061 )
        If Arg3 == oHmgApp():APP061 [i] [1]
            cMacro := oHmgApp():APP061 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 , Arg4 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf
        Endif
    Next i

    If .Not. _IsControlDefined ( Arg2 , Arg1  )
        MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
    endif

    If     Arg3 == 'VALUE'

        _SetValue ( Arg2 , Arg1 , Arg4 )

  Elseif Arg3 == 'CHANGEFONTSIZE'    // ADD

     ChangeControlFontSize ( Arg2 , Arg1 , Arg4 )

  Elseif Arg3 == 'FORMAT'    // cTimeFormat (TimePicker)

      IF HMG_IsUTF8 (Arg4)
         Arg4 := HMG_UNICODE_TO_ANSI (Arg4)
      ENDIF

      IF DateTime_SetFormat ( GetControlHandle(Arg2, Arg1), Arg4 ) == .F.
         IF GetControlType (Arg2, Arg1) == "DATEPICK"
            MsgHMGError ( "DatePicker Control: " + Arg2 + " Of " + Arg1 + ": Invalid Date Format" )
         ELSE
            MsgHMGError ( "TimePicker Control: " + Arg2 + " Of " + Arg1 + ": Invalid Time Format" )
         ENDIF
      ENDIF
      i := GetControlIndex ( Arg2 , Arg1 )
      ControlByIndex( I ):CTRL009 := Arg4


    ElseIf Arg3 == 'ALLOWEDIT'

    #ifdef COMPILEBROWSE

        _SetBrowseAllowEdit ( Arg2 , Arg1 , Arg4 )

    #endif

    ElseIf Arg3 == 'RECNO'

        SetDataGridRecNo ( GetControlIndex ( Arg2 , Arg1 ) , Arg4 )

    ElseIf Arg3 == 'ALLOWAPPEND'

        #ifdef COMPILEBROWSE

        _SetBrowseAllowAppend ( Arg2 , Arg1 , Arg4 )

        #endif

    ElseIf Arg3 == 'ALLOWDELETE'

        #ifdef COMPILEBROWSE

        _SetBrowseAllowDelete ( Arg2 , Arg1 , Arg4 )

        #endif

    ElseIf Arg3 == 'PICTURE'

        _SetPicture ( Arg2 , Arg1 , Arg4 )

   ElseIf Arg3 == "HBITMAP"

        BT_HMGSetImage ( Arg1 , Arg2 , Arg4, .T. )   // Assign hBitmap to the IMAGE control

    ElseIf Arg3 == 'TOOLTIP'

        _SetTooltip ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTNAME'

        _SetFontName ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTSIZE'

        _SetFontSize ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTBOLD'

        _SetFontBold ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTITALIC'

        _SetFontItalic ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTUNDERLINE'

        _SetFontUnderline ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTSTRIKEOUT'

        _SetFontStrikeout ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'CAPTION'

        IF GetControlType ( Arg2 , Arg1 ) == 'TOOLBUTTON'

            k := GetControlIndex ( Arg2 , Arg1 )

            SetToolButtonCaption ( ControlByIndex( K ):CTRL026 , ControlByIndex( K ):CTRL005 , Arg4 )

            ControlByIndex( K ):CTRL033 := Arg4

        Else

            SetWindowText ( GetControlHandle( Arg2 , Arg1 ) , Arg4 )

        EndIf

    ElseIf Arg3 == 'DISPLAYVALUE'

        SetWindowText ( GetControlHandle( Arg2 , Arg1 ) , Arg4 )

    ElseIf Arg3 == 'ROW'

        _SetControlRow ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'COL'

        _SetControlCol ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'WIDTH'

        _SetControlWidth ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'HEIGHT'

        _SetControlHeight ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'VISIBLE'

        iif ( Arg4 == .t. , _ShowControl ( Arg2 , Arg1 ) , _HideControl ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'ENABLED'

        iif ( Arg4 == .t. , _EnableControl ( Arg2 , Arg1 ) , _DisableControl ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'CHECKED'

        iif ( Arg4 == .t. , _CheckMenuItem ( Arg2 , Arg1 ) , _UnCheckMenuItem ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'RANGEMIN'

        _SetRangeMin ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'RANGEMAX'

        _SetRangeMax ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'REPEAT'

        If Arg4 == .t.
            _SetPlayerRepeatOn ( Arg2 , Arg1 )
        Else
            _SetPlayerRepeatOff ( Arg2 , Arg1 )
        EndIf

    ElseIf Arg3 == 'SPEED'

        _SetPlayerSpeed ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'VOLUME'

        _SetPlayerVolume ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'ZOOM'

        _SetPlayerZoom ( Arg2 , Arg1 , Arg4 )

   ElseIf Arg3 == 'SEEK'   // ADD

        _SetPlayerSeek ( Arg2 , Arg1 , Arg4 )   // ADD

    ElseIf Arg3 == 'POSITION'

        If Arg4 == 0
            _SetPlayerPositionHome ( Arg2 , Arg1 )
        ElseIf Arg4 == 1
            _SetPlayerPositionEnd ( Arg2 , Arg1 )
        EndIf

    ElseIf Arg3 == 'CARETPOS'

        _SetCaretPos ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'BACKCOLOR'

        _SetBackColor ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FONTCOLOR'

        _SetFontColor ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'FORECOLOR'

        _SetFontColor ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'ADDRESS'

        _SetAddress ( Arg2 , Arg1 , Arg4 )

    #ifdef COMPILEBROWSE

    ElseIf Arg3 == 'INPUTITEMS'

        _SetBrowseInputItems ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'DISPLAYITEMS'

        _SetBrowseDisplayItems ( Arg2 , Arg1 , Arg4 )

    #endif

    ElseIf Arg3 == 'READONLY'

        IF GetControlType ( Arg2 , Arg1 ) == 'RADIOGROUP'

            _SetRadioGroupReadOnly ( Arg2 , Arg1 , Arg4 )

        Else

            SetTextEditReadOnly ( GetControlHandle( Arg2 , Arg1 ) , Arg4 )

        EndIf

    ElseIf Arg3 == 'ITEMCOUNT'

        ListView_SetItemCount ( GetControlHandle ( Arg2 , Arg1 ) , Arg4 )

    EndIf

ElseIf Pcount() == 5    // CONTROL WITH ARGUMENT, TOOLBAR BUTTON OR
            // SPLITBOX CHILD CONTROL WITHOUT ARGUMENT

    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP061 )
        If Arg3 == oHmgApp():APP061 [i] [1]
            cMacro := oHmgApp():APP061 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If     HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            SetProperty ( Arg1 , Arg3 , Arg4 , Arg5 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If     Arg3 == 'CAPTION'

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

        _SetMultiCaption ( Arg2 , Arg1 , Arg4 , Arg5 )


    ElseIf Arg3 == 'HEADER'

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

        _SetMultiCaption ( Arg2 , Arg1 , Arg4 , Arg5 )


    ElseIf Arg3 == 'HEADERIMAGES'

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

        _HMG_SetHeaderImages ( Arg2 , Arg1 , Arg4 , Arg5  )


    ElseIf Arg3 == 'ITEM'

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

        _SetItem ( Arg2 , Arg1 , Arg4 , Arg5 )

   ElseIf Arg3 == 'ICONHANDLE'

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

        _SetStatusIcon ( Arg2 , Arg1 , Arg4 , NIL, Arg5 )

    ElseIf Arg3 == 'ICON'

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

        _SetStatusIcon ( Arg2 , Arg1 , Arg4 , Arg5 )

    Else
        // If Property Not Matched Look For ToolBar Button

        If GetControlType ( Arg2 , Arg1 ) == 'TOOLBAR'

            If GetControlHandle ( Arg2 , Arg1 ) != GetControlContainerHandle ( Arg3 , Arg1 )
                MsgHMGError('Control Does Not Belong To Container')
            EndIf

            SetProperty ( Arg1 , Arg3 , Arg4 , Arg5 )
        EndIf

    EndIf

ElseIf Pcount() == 6    // TAB CHILD CONTROL,
            // SPLITBOX CHILD WITH 1 ARGUMENT
            // OR SPLITCHILD TOOLBAR BUTTON

    If     HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            SetProperty ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 )
            Return Nil
        Else
            If _IsControlDefined ( Arg4 , Arg1 )

                If _IsControlSplitBoxed ( Arg4 , Arg1 )

                    SetProperty ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 )
                    Return Nil

                Else
                    MsgHMGError('Control Does Not Belong To Container')
                EndIf
            Else
                MsgHMGError('Control Does Not Belong To Container')
            EndIf

        EndIf

    EndIf

    If ValType (Arg3) = 'C'

        Arg3 := HMG_UPPER (ALLTRIM (Arg3))

        If     Arg3 == 'CELL'

            If .Not. _IsControlDefined ( Arg2 , Arg1  )
                MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            endif

            // _HMG_SETGRIDCELLVALUE ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 )

            i := GetControlIndex ( Arg2 , Arg1 )
            if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0 .AND. Arg5 == 1  // Image Array
               SetProperty ( Arg1 , Arg2 , "ImageIndex" , Arg4 , Arg5 , Arg6 )   // ADD October 2015
               Return Nil
            EndIf

            _GridEx_SetCellValue ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 )      // ADD February 2015
            Return Nil

        EndIf

    EndIf

    If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
        MsgHMGError('Control Does Not Belong To Container')
    EndIf

    SetProperty ( Arg1 , Arg4 , Arg5 , Arg6 )

ElseIf Pcount() == 7    // TAB CHILD CONTROL WITH 1 ARGUMENT OR
            // SPLITBOX WITH 2 ARGUMENTS

    If     HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            SetProperty ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
        MsgHMGError('Control Does Not Belong To Container')
    EndIf

    SetProperty ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

ElseIf Pcount() == 8 // TAB CHILD CONTROL WITH 2 ARGUMENTS

    If     HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            SetProperty ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
        MsgHMGError('Control Does Not Belong To Container')
    EndIf

    SetProperty ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )

EndIf
Return Nil

Function GetProperty ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local xData, RetVal
Local i, hWnd
Local cMacro
Local tRetVal

IF _GridEx_GetProperty     ( @xData, Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 ) == .T.
   RETURN xData
ENDIF

IF _Tree_GetProperty       ( @xData, Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 ) == .T.
   RETURN xData
ENDIF

IF _RichEditBox_GetProperty ( @xData, Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 ) == .T.
   RETURN xData
ENDIF


if Pcount() == 2 // WINDOW

    If .Not. _IsWindowDefined ( Arg1 )
        MsgHMGError("Window: "+ Arg1 + " is not defined. Program terminated" )
    Endif

    Arg2 := HMG_UPPER (ALLTRIM (Arg2))

    For i := 1 To HMG_LEN ( oHmgApp():APP061 )   // Custom Properties Procedures Array
        If Arg2 == oHmgApp():APP061 [i] [1]
            cMacro := oHmgApp():APP061 [i] [3]
            tRetVal := &cMacro ( Arg1 , Arg2 )

            If oHmgApp():APP063 == .T.   // User Component Process Flag
                Return tRetVal
            EndIf

        Endif
    Next i

  hWnd := GetFormHandle ( Arg1 )

  IF Arg2 == 'HANDLE'
     RetVal := GetFormHandle ( Arg1 )

  ELSEIF Arg2 == 'INDEX'
         RetVal := GetFormIndex ( Arg1 )

  ELSEIF Arg2 == HMG_UPPER ("IsMinimized")
         RetVal := IsMinimized ( hWnd )

  ELSEIF Arg2 == HMG_UPPER ("IsMaximized")
         RetVal := IsMaximized ( hWnd )

  ELSEIF Arg2 == HMG_UPPER ("ClientAreaWidth")
         RetVal := GetClientAreaWidth ( hWnd )

  ELSEIF Arg2 == HMG_UPPER ("ClientAreaHeight")
         RetVal := GetClientAreaHeight ( hWnd )

  ELSEIF Arg2 == HMG_UPPER ("NoClose")
         RetVal := IF ( HB_bitAND ( GetMenuState(GetSystemMenu (hWnd), SC_CLOSE), MF_GRAYED ) == MF_GRAYED, .T., .F. )

  ELSEIF Arg2 == HMG_UPPER ("NoCaption")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_CAPTION, .F. )

  ELSEIF Arg2 == HMG_UPPER ("NoMaximize")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_MAXIMIZEBOX, .F. )

  ELSEIF Arg2 == HMG_UPPER ("NoMinimize")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_MINIMIZEBOX, .F. )

  ELSEIF Arg2 == HMG_UPPER ("NoSize")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_SIZEBOX, .F. )

  ELSEIF Arg2 == HMG_UPPER ("NoSysMenu")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_SYSMENU, .F. )

  ELSEIF Arg2 == HMG_UPPER ("HScroll")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_HSCROLL, .F. )

  ELSEIF Arg2 == HMG_UPPER ("VScroll")
         RetVal := HMG_IsWindowStyle ( hWnd, WS_VSCROLL, .F. )

  ELSEIF Arg2 == HMG_UPPER ("Enabled")
         RetVal := IsWindowEnabled ( hWnd )


  ElseIf Arg2 == 'TITLE'

        RetVal := GetWindowText ( GetFormHandle( Arg1 ) )

    ELseIf Arg2 == 'FOCUSEDCONTROL'

        RetVal := _GetFocusedControl ( Arg1 )

    ELseIf Arg2 == 'NAME'

        RetVal := GetFormName ( Arg1 )

    ELseIf Arg2 == 'HEIGHT'

        // RetVal := GetWindowHeight ( GetFormHandle ( Arg1 ) )
        RetVal := _GetWindowSizePos ( GetFormHandle ( Arg1 ) ) [4]

    ElseIf Arg2 == 'WIDTH'

        // RetVal := GetWindowWidth ( GetFormHandle ( Arg1 ) )
        RetVal := _GetWindowSizePos ( GetFormHandle ( Arg1 ) ) [3]

    ElseIf Arg2 == 'COL'

        // RetVal := GetWindowCol ( GetFormHandle ( Arg1 ) )
        RetVal := _GetWindowSizePos ( GetFormHandle ( Arg1 ) ) [2]

    ElseIf Arg2 == 'ROW'

        // RetVal := GetWindowRow ( GetFormHandle ( Arg1 ) )
        RetVal := _GetWindowSizePos ( GetFormHandle ( Arg1 ) ) [1]

    ElseIf Arg2 == 'NOTIFYICON'

        RetVal := _GetNotifyIconName ( Arg1 )

    ElseIf Arg2 == 'NOTIFYTOOLTIP'

        RetVal := _GetNotifyIconTooltip ( Arg1 )

    EndIf

ElseIf Pcount() == 3 // CONTROL

    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP061 )   // Custom Properties Procedures Array
        If Arg3 == oHmgApp():APP061 [i] [1]
            cMacro := oHmgApp():APP061 [i] [3]
            tRetVal := &cMacro ( Arg1 , Arg2 , Arg3 )

            If oHmgApp():APP063 == .T.   // User Component Process Flag
                Return tRetVal
            EndIf

        Endif

    Next i

    If ( HMG_UPPER (ALLTRIM (Arg2)) == 'VSCROLLBAR' .Or. HMG_UPPER (ALLTRIM (Arg2)) == 'HSCROLLBAR' )

        If .Not. _IsWindowDefined ( Arg1 )
            MsgHMGError("Window: "+ Arg1 + " is not defined. Program terminated" )
        Endif

    Else

        If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
        endif

    EndIf

  IF  Arg3 == 'HANDLE'

     RetVal := GetControlHandle ( Arg2 , Arg1 )

  ElseIf Arg3 == 'INDEX'

     RetVal :=  GetControlIndex ( Arg2 , Arg1 )

  ElseIf Arg3 == 'TYPE'

     RetVal :=  GetControlType ( Arg2 , Arg1 )

  ElseIf Arg3 == HMG_UPPER("GetTextLength")

   RetVal :=  HMG_LEN ( GetWindowText( GetControlHandle( Arg2 , Arg1 ) ) )

  ElseIf Arg3 == 'VALUE'

        RetVal := _GetValue ( Arg2 , Arg1 )

  Elseif Arg3 == 'FORMAT'

     i := GetControlIndex ( Arg2 , Arg1 )
     RetVal := ControlByIndex( I ):CTRL009   // cTimeFormat (TimePicker)

    ElseIf Arg3 == 'RECNO'

        RetVal := GetDataGridRecno ( GetControlIndex ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'NAME'

        RetVal := GetControlName ( Arg2 , Arg1 )

    ElseIf Arg3 == 'ALLOWEDIT'

        #ifdef COMPILEBROWSE

        RetVal := _GetBrowseAllowEdit ( Arg2 , Arg1 )

        #endif

    ElseIf Arg3 == 'INPUTITEMS'

        #ifdef COMPILEBROWSE

        RetVal := _GetBrowseInputItems ( Arg2 , Arg1 )

        #endif

    ElseIf Arg3 == 'DISPLAYITEMS'

        #ifdef COMPILEBROWSE

        RetVal := _GetBrowseDisplayItems ( Arg2 , Arg1 )

        #endif

    ElseIf Arg3 == 'ALLOWAPPEND'

        #ifdef COMPILEBROWSE

        RetVal := _GetBrowseAllowAppend ( Arg2 , Arg1 )

        #endif

    ElseIf Arg3 == 'ALLOWDELETE'

        #ifdef COMPILEBROWSE

        RetVal := _GetBrowseAllowDelete ( Arg2 , Arg1 )

        #endif

    ElseIf Arg3 == 'PICTURE'

        RetVal := _GetPicture ( Arg2 , Arg1 )

   ElseIf Arg3 == "HBITMAP"

        RetVal := BT_HMGGetImage ( Arg1, Arg2 )   // Gets the value of hBitmap from the IMAGE control

    ElseIf Arg3 == 'TOOLTIP'

        RetVal := _GetTooltip ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTNAME'

        RetVal := _GetFontName ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTSIZE'

        RetVal := _GetFontSize ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTBOLD'

        RetVal := _GetFontBold ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTITALIC'

        RetVal := _GetFontItalic ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTUNDERLINE'

        RetVal := _GetFontUnderline ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTSTRIKEOUT'

        RetVal := _GetFontStrikeout ( Arg2 , Arg1 )

    ElseIf Arg3 == 'CAPTION'

        RetVal := _GetCaption ( Arg2 , Arg1 )

    ElseIf Arg3 == 'DISPLAYVALUE'

        RetVal := GetWindowText ( GetControlHandle ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'ROW'

        RetVal := _GetControlRow ( Arg2 , Arg1 )

    ElseIf Arg3 == 'COL'

        RetVal := _GetControlCol ( Arg2 , Arg1 )

    ElseIf Arg3 == 'WIDTH'

        RetVal := _GetControlWidth ( Arg2 , Arg1 )

    ElseIf Arg3 == 'HEIGHT'

        RetVal := _GetControlHeight ( Arg2 , Arg1 )

    ElseIf Arg3 == 'VISIBLE'

        RetVal := _IsControlVisible ( Arg2 , Arg1 )

    ElseIf Arg3 == 'ENABLED'

        RetVal := _IsControlEnabled ( Arg2 , Arg1 )

    ElseIf Arg3 == 'CHECKED'

        RetVal := _IsMenuItemChecked ( Arg2 , Arg1 )

    ElseIf Arg3 == 'ITEMCOUNT'

        RetVal := _GetItemCount ( Arg2 , Arg1 )

    ElseIf Arg3 == 'RANGEMIN'

        RetVal := _GetRangeMin ( Arg2 , Arg1 )

    ElseIf Arg3 == 'RANGEMAX'

        RetVal := _GetRangeMax ( Arg2 , Arg1 )

    ElseIf Arg3 == 'LENGTH'

        RetVal := _GetPlayerLength ( Arg2 , Arg1 )

    ElseIf Arg3 == 'POSITION'

        RetVal := _GetPlayerPosition ( Arg2 , Arg1 )

   ElseIf Arg3 == 'VOLUME'        // ADD
         RetVal := _GetPlayerVolume ( Arg2 , Arg1 )   // ADD

   ElseIf Arg3 == 'CARETPOS'

        RetVal := _GetCaretPos ( Arg2 , Arg1 )

    ElseIf Arg3 == 'BACKCOLOR'

        RetVal := _GetBackColor ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FONTCOLOR'

        RetVal := _GetFontColor ( Arg2 , Arg1 )

    ElseIf Arg3 == 'FORECOLOR'

        RetVal := _GetFontColor ( Arg2 , Arg1 )

    ElseIf Arg3 == 'ADDRESS'

        RetVal := _GetAddress ( Arg2 , Arg1 )

    ElseIf Arg3 == 'OBJECT'

        RetVal := _GetControlObject ( Arg2 , Arg1 )

    ElseIf Arg3 == 'READONLY'

        IF GetControlType ( Arg2 , Arg1 ) == 'RADIOGROUP'

            RetVal := _GetRadioGroupReadOnly ( Arg2 , Arg1 )

        Else

            #define ES_READONLY 0x0800
            RetVal := HMG_IsWindowStyle ( GetControlHandle( Arg2 , Arg1 ), ES_READONLY, .F. )   // ADD July 2016

        EndIf

    EndIf

ElseIf Pcount() == 4    // CONTROL WITH ARGUMENT, TOOLBAR BUTTON
            // OR SPLITBOX CHILD WITHOUT ARGUMENT

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            RetVal := GetProperty ( Arg1 , Arg3 , Arg4 )
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    Else

        Arg3 := HMG_UPPER (ALLTRIM (Arg3))

        If     Arg3 == 'ITEM'

            If .Not. _IsControlDefined ( Arg2 , Arg1  )
                MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            endif

            RetVal := _GetItem (  Arg2 , Arg1 , Arg4 )

        ElseIf Arg3 == 'CAPTION'

            If .Not. _IsControlDefined ( Arg2 , Arg1  )
                MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            endif

            RetVal := _GetMultiCaption ( Arg2 , Arg1 , Arg4 )

        ElseIf Arg3 == 'HEADER'

            If .Not. _IsControlDefined ( Arg2 , Arg1  )
                MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            endif

            RetVal := _GetMultiCaption ( Arg2 , Arg1 , Arg4 )

        ElseIf Arg3 == 'HEADERIMAGES'

            If .Not. _IsControlDefined ( Arg2 , Arg1  )
                MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            endif

            RetVal := _HMG_GetHeaderImages ( Arg2 , Arg1 , Arg4 )

        Else

            // If Property Not Matched Look For Contained Control
            // With No Arguments (ToolBar Button)

            If  GetControlType ( Arg2 , Arg1 ) == 'TOOLBAR'

                If GetControlHandle ( Arg2 , Arg1 ) != GetControlContainerHandle ( Arg3 , Arg1 )
                    MsgHMGError('Control Does Not Belong To Container')
                EndIf

                RetVal := GetProperty ( Arg1 , Arg3 , Arg4 )

            EndIf

        EndIf

    EndIf

ElseIf Pcount() == 5    // TAB CHILD CONTROL (WITHOUT ARGUMENT)
            // OR SPLITBOX CHILD WITH ARGUMENT

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            RetVal := GetProperty ( Arg1 , Arg3 , Arg4 , Arg5 )
        Else
            If _IsControlDefined ( Arg4 , Arg1 )

                If _IsControlSplitBoxed ( Arg4 , Arg1 )

                    RetVal := GetProperty ( Arg1 , Arg3 , Arg4 , Arg5 )

                Else

                    MsgHMGError('Control Does Not Belong To Container')

                EndIf

            Else

                MsgHMGError('Control Does Not Belong To Container')

            EndIf

        EndIf

    Else

        If ValType ( Arg3 ) = 'C'

            Arg3 := HMG_UPPER (ALLTRIM (Arg3))

            If Arg3 == 'CELL'

                // Return ( _HMG_GETGRIDCELLVALUE ( Arg2 , Arg1 , Arg4 , Arg5 ) )

               i := GetControlIndex ( Arg2 , Arg1 )
               if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0 .AND. Arg5 == 1  // Image Array
                  Return GetProperty ( Arg1 , Arg2 , "ImageIndex" , Arg4 , Arg5 )   // ADD October 2015
               EndIf

                Return _GridEx_GetCellValue ( Arg2 , Arg1 , Arg4 , Arg5 )           // ADD February 2015
            Endif

        EndIf

        If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

        RetVal := GetProperty ( Arg1 , Arg4 , Arg5 )

    EndIf

ElseIf Pcount() == 6    // TAB CHILD CONTROL (WITH 1 ARGUMENT
            // OR SPLITBOX CHILD WITH 2 ARGUMENT

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            RetVal := GetProperty ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 )
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    Else

        If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

        RetVal := GetProperty ( Arg1 , Arg4 , Arg5 , Arg6 )

    EndIf

ElseIf Pcount() == 7    // TAB CHILD CONTROL (WITH 2 ARGUMENT
            // OR SPLITBOX CHILD WITH 3 ARGUMENT

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            RetVal := GetProperty ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    Else

        If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

        RetVal := GetProperty ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

    EndIf

EndIf
Return RetVal

Function GetControlTabPage ( cControlName , cTabName , cParentWindowName )
Local r , c , j , a
Local aPageMap
Local niTab
Local niControl
Local xControlHandle
Local nRetVal := 0


niTab       := GetControlIndex ( cTabName , cParentWindowName )
niControl   := GetControlIndex ( cControlName , cParentWindowName )

xControlHandle  := ControlByIndex( NICONTROL ):Handle
aPageMap    := ControlByIndex( NITAB ):CTRL007

For r = 1 to HMG_LEN ( aPageMap )

    For c = 1 To HMG_LEN ( aPageMap [r])

        If  ValType ( aPageMap [r] [c] ) == 'N' ;
            .And. ;
            ValType (xControlHandle) == 'N'

            If aPageMap [r] [c] == xControlHandle

                nRetVal := r
                Exit

            EndIf

                ElseIf  ValType ( aPageMap [r] [c] ) == "A" ;
            .And. ;
            ValType ( xControlHandle ) == "A"

            For j := 1 To HMG_LEN ( xControlHandle )

                a := aScan ( aPageMap [r] [c] , xControlHandle [j] )

                If a <> 0
                    nRetVal := r
                    Exit
                EndIf

            Next j

            If nRetVal <> 0
                Exit
            EndIf

                ElseIf  ValType ( aPageMap [r] [c] ) == "A" ;
            .And. ;
            ValType ( xControlHandle ) == "N"

            a := aScan ( aPageMap [r] [c] , xControlHandle )

            If a <> 0
                nRetVal := r
                Exit
            EndIf

                EndIf

    Next c

    If nRetVal <> 0
        Exit
    EndIf

Next r
Return nRetVal

Function DoMethod ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )
Local i, hWnd
Local cMacro, cControlType

IF _GridEx_DoMethod      ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 ) == .T.
   Return Nil
ENDIF

IF _Tree_DoMethod        ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 ) == .T.
   Return Nil
ENDIF

IF _RichEditBox_DoMethod ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 ) == .T.
   Return Nil
ENDIF

if Pcount() == 2 // Window

    Arg2 := HMG_UPPER (ALLTRIM (Arg2))

    For i := 1 To HMG_LEN ( oHmgApp():APP062 )

        If Arg2 == oHmgApp():APP062 [i] [1]

            cMacro := oHmgApp():APP062 [i] [2]

            &cMacro ( Arg1 , Arg2 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If ValType ( Arg1 ) == 'C'
        If .Not. _IsWindowDefined ( Arg1 )
            MsgHMGError("Window: "+ Arg1 + " is not defined. Program terminated" )
        Endif
    EndIf

    if Arg2 == 'ACTIVATE'

        if ValType ( Arg1 ) == 'A'
            _ActivateWindow ( Arg1 )
        Else
            _ActivateWindow ( { Arg1 } )
        EndIf

    ELseIf Arg2 == 'CENTER'

        _CenterWindow ( Arg1 )

   ElseIf Arg2 == 'REDRAW'

      RedrawWindow ( GetFormHandle( Arg1 ) )

   ELseIf Arg2 == HMG_UPPER ('CenterDesktop')

        _CenterWindow ( Arg1 , 1 )

    ElseIf Arg2 == 'RELEASE'

        _ReleaseWindow ( Arg1 )

    ElseIf Arg2 == 'MAXIMIZE'

        _MaximizeWindow ( Arg1 )

    ElseIf Arg2 == 'MINIMIZE'

        _MinimizeWindow ( Arg1 )

    ElseIf Arg2 == 'RESTORE'

        _RestoreWindow ( Arg1 )

    ElseIf Arg2 == 'SHOW'

        _ShowWindow ( Arg1 )

    ElseIf Arg2 == 'HIDE'

        _HideWindow ( Arg1 )

    ElseIf Arg2 == 'SETFOCUS'

        i := GetFormIndex ( Arg1 )

        if i >= 1  .and. i <= oHmgApp():FormCount

            If FormByIndex( i ):IsActive // _HMG_aFormActive
                setfocus ( FormByIndex( i ):Handle )
            EndIf

        EndIf

    ElseIf Arg2 == 'PRINT'

        PrintWindow ( Arg1 )

    ElseIf Arg2 == 'CAPTURE'

        SaveWindow ( Arg1 )

    EndIf

ElseIf Pcount() == 3 // CONTROL

   IF ValType (Arg2) == "C" .AND. HMG_UPPER (Arg2) == HMG_UPPER ('CenterIn')
        _CenterWindow ( Arg1 , Arg3 )   //  ---> window center
       RETURN NIL
   ENDIF

    Arg3 := HMG_UPPER  (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP062 )

        If Arg3 == oHmgApp():APP062 [i] [1]

            cMacro := oHmgApp():APP062 [i] [2]

            &cMacro ( Arg1 , Arg2 , Arg3 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If .Not. _IsControlDefined ( Arg2 , Arg1  )
        MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
    endif

    If     Arg3 == 'REFRESH'

        _Refresh ( GetControlIndex ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'REDRAW'

       _RedrawControl ( Arg2 , Arg1 )

    ElseIf Arg3 == 'SAVE'

        _SaveData (Arg2 , Arg1)

    ElseIf Arg3 == 'CLEARBUFFER'

        DataGridClearBuffer ( GetControlIndex (Arg2 , Arg1) )

    ElseIf Arg3 == 'DISABLEUPDATE'

     cControlType := ControlByIndex( GetControlIndex (Arg2 , Arg1) ):Type

     IF cControlType $ "COMBO,BROWSE,TREE,GRID"
        hWnd := GetControlHandle(Arg2 , Arg1)
        EnableWindowRedraw ( hWnd , .F. )
     ENDIF

     IF cControlType == "GRID"
        ControlByIndex( GetControlIndex (Arg2 , Arg1) ):CTRL040 [ 33 ] := .F.
     ENDIF

    ElseIf Arg3 == 'ENABLEUPDATE'
     cControlType := ControlByIndex( GetControlIndex (Arg2 , Arg1) ):Type

     IF cControlType $ "COMBO,BROWSE,TREE,GRID"
        hWnd := GetControlHandle(Arg2 , Arg1)
        EnableWindowRedraw ( hWnd , .T. )
        RedrawWindow ( hWnd )
     ENDIF

     IF cControlType == "GRID"
        ControlByIndex( GetControlIndex (Arg2 , Arg1) ):CTRL040 [ 33 ] := .T.
     ENDIF

    ElseIf Arg3 == 'APPEND'

        DataGridAppend( GetControlIndex (Arg2 , Arg1) )

    ElseIf Arg3 == 'DELETE'

        DataGridDelete( GetControlIndex (Arg2 , Arg1) )

    ElseIf Arg3 == 'RECALL'

        DataGridRecall( GetControlIndex (Arg2 , Arg1) )

    ElseIf Arg3 == 'SETFOCUS'

        _SetFocus ( Arg2 , Arg1 )

    ElseIf Arg3 == 'ACTION'

        Eval ( _GetControlAction ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'ONCLICK'

        Eval ( _GetControlAction ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'DELETEALLITEMS'

        _DeleteAllItems ( Arg2 , Arg1 )

    ElseIf Arg3 == 'RELEASE'

        _ReleaseControl ( Arg2 , Arg1 )

    ElseIf Arg3 == 'SHOW'

        _ShowControl ( Arg2 , Arg1 )

    ElseIf Arg3 == 'HIDE'

        _HideControl ( Arg2 , Arg1 )

    ElseIf Arg3 == 'PLAY'

        iif ( GetControlType ( Arg2 , Arg1 ) == "ANIMATEBOX" ,  _PlayAnimateBox ( Arg2 , Arg1 )  , _PlayPlayer ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'STOP'

        iif ( GetControlType ( Arg2 , Arg1 ) == "ANIMATEBOX" ,  _StopAnimateBox ( Arg2 , Arg1 )  , _StopPlayer ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'CLOSE'

        iif ( GetControlType ( Arg2 , Arg1 ) == "ANIMATEBOX" ,  _CloseAnimateBox ( Arg2 , Arg1 )  , _ClosePlayer ( Arg2 , Arg1 ) )

    ElseIf Arg3 == 'PLAYREVERSE'

        _PlayPlayerReverse ( Arg2 , Arg1 )

    ElseIf Arg3 == 'PAUSE'

        _PausePlayer ( Arg2 , Arg1 )

    ElseIf Arg3 == 'EJECT'

        _EjectPlayer ( Arg2 , Arg1 )

    ElseIf Arg3 == 'OPENDIALOG'

        _OpenPlayerDialog ( Arg2 , Arg1 )

    ElseIf Arg3 == 'RESUME'

        _ResumePlayer ( Arg2 , Arg1 )

    EndIf

ElseIf Pcount() == 4    // CONTROL WITH 1 ARGUMENT
            // OR SPLITBOX CHILD WITHOUT ARGUMENT


    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP062 )

        If Arg3 == oHmgApp():APP062 [i] [1]

            cMacro := oHmgApp():APP062 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 , Arg4 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'
        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            DoMethod( Arg1 , Arg3 , Arg4 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf
    EndIf

    If .Not. _IsControlDefined ( Arg2 , Arg1  )
        MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
    endif

    If     Arg3 == 'DELETEITEM'

        _DeleteItem ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'DELETEPAGE'

        _DeleteTabPage ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'REFRESH'

        DataGridRefresh ( GetControlIndex ( Arg2 , Arg1 ) , Arg4 )

    ElseIf Arg3 == 'OPEN'

        iif ( GetControlType ( Arg2 , Arg1 ) == "ANIMATEBOX" ,  _OpenAnimateBox ( Arg2 , Arg1 , Arg4 )  , _OpenPlayer ( Arg2 , Arg1 , Arg4 ) )

    ElseIf Arg3 == 'SEEK'

        _SeekAnimateBox ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'ADDITEM'

        _AddItem ( Arg2 , Arg1 , Arg4 )

    ElseIf Arg3 == 'EXPAND'

        _Expand ( Arg2 , Arg1 , Arg4 , NIL)   // Tree

    ElseIf Arg3 == 'COLLAPSE'

        _Collapse ( Arg2 , Arg1 , Arg4 , NIL) // Tree

    ElseIf Arg3 == 'DELETECOLUMN'

        _DeleteGridColumn ( Arg2 , Arg1 , Arg4 )

    EndIf

ElseIf Pcount() == 5 .And. ValType (Arg3) == 'C'

     // CONTROL WITH 2 ARGUMENTS
    //  OR SPLITBOX CHILD WITH 1 ARGUMENT

    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP062 )

        If Arg3 == oHmgApp():APP062 [i] [1]

            cMacro := oHmgApp():APP062 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'
        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            DoMethod( Arg1 , Arg3 , Arg4 , Arg5 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf
    EndIf

    If .Not. _IsControlDefined ( Arg2 , Arg1  )
        MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
    endif

    If     Arg3 == 'ADDITEM'

        _AddItem ( Arg2 , Arg1 , Arg4 , Arg5 )

    ElseIf Arg3 == 'ADDPAGE'

        _AddTabPage ( Arg2 , Arg1 , Arg4 , Arg5 )

    ElseIf Arg3 == 'EXPAND'

        _Expand ( Arg2 , Arg1 , Arg4 , Arg5 )   // Tree

    ElseIf Arg3 == 'COLLAPSE'

        _Collapse ( Arg2 , Arg1 , Arg4 , Arg5 ) // Tree

    EndIf

ElseIf Pcount()=5  .And. ValType (Arg3)=='N'

    // TAB CHILD WITHOUT ARGUMENTS

    If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
        MsgHMGError('Control Does Not Belong To Container')
    EndIf

    DoMethod ( Arg1 , Arg4 , Arg5 )

ElseIf Pcount() == 6 .And. ValType (Arg3) == 'C'

    // CONTROL WITH 3 ARGUMENTS
    // OR SPLITBOX CHILD WITH 2 ARGUMENTS

    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP062 )

        If Arg3 == oHmgApp():APP062 [i] [1]

            cMacro := oHmgApp():APP062 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            DoMethod( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If .Not. _IsControlDefined ( Arg2 , Arg1  )
        MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
    endif

    If     Arg3 == 'ADDITEM'

        _AddItem ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 )

    ElseIf Arg3 == 'ADDPAGE'

        _AddTabPage ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 )

    EndIf

ElseIf Pcount() == 6 .And. ValType (Arg3) == 'N'
    // TAB CHILD WITH 1 ARGUMENT

    If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
        MsgHMGError('Control Does Not Belong To Container')
    EndIf

    DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 )

ElseIf Pcount() == 7 .And. HMG_UPPER (ALLTRIM (Arg2)) == 'CAPTURE'

    SaveWindow ( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )

ElseIf Pcount() == 7 .And. ValType (Arg3) == 'C'

    // CONTROL WITH 4 ARGUMENTS
    // OR SPLITBOX CHILD WITH 3 ARGUMENTS

    Arg3 := HMG_UPPER (ALLTRIM (Arg3))

    For i := 1 To HMG_LEN ( oHmgApp():APP062 )

        If Arg3 == oHmgApp():APP062 [i] [1]

            cMacro := oHmgApp():APP062 [i] [2]
            &cMacro ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )

            If oHmgApp():APP063 == .T.
                Return NIL
            EndIf

        Endif

    Next i

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            DoMethod( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If .Not. _IsControlDefined ( Arg2 , Arg1  )
        MsgHMGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
    endif

    If     Arg3 == 'ADDCONTROL'

        _AddTabControl ( Arg2 , Arg4 , Arg1 , Arg5 , Arg6 , Arg7 )

    ElseIf     Arg3 == 'ADDCOLUMN'

        _AddGridColumn ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

    ElseIf     Arg3 == 'ADDITEM'

        _AddItem ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

    EndIf

ElseIf Pcount() == 7 .And. ValType (Arg3) == 'N'

    // TAB CHILD WITH 2 ARGUMENTS

    If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
        MsgHMGError('Control Does Not Belong To Container')
    EndIf

    DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

ElseIf Pcount() == 8

    // TAB CHILD WITH 3 ARGUMENTS
    // OR SPLITBOX CHILD WITH 4 ARGUMENTS

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            DoMethod( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If ValType (Arg3) == 'N'

        If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

        DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )

    EndIf

ElseIf Pcount() == 9
    // TAB CHILD WITH 4 ARGUMENTS
    // OR SPLITBOX CHILD WITH 5 ARGUMENTS

    If HMG_UPPER (ALLTRIM (Arg2)) == 'SPLITBOX'

        If _IsControlSplitBoxed ( Arg3 , Arg1 )
            DoMethod( Arg1 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )
            Return Nil
        Else
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

    EndIf

    If ValType (Arg3) == 'N'

        If GetControlTabPage ( Arg4 , Arg2 , Arg1 ) <> Arg3
            MsgHMGError('Control Does Not Belong To Container')
        EndIf

        DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )

    EndIf

EndIf
Return Nil

Function _IsControlSplitBoxed ( cControlName , cWindowName )
Local lSplitBoxed := .F.
Local i

i := GetControlIndex ( cControlName, cWindowName )

If i > 0

    If  ValType ( ControlByIndex( I ):CTRL018 ) == 'U' ;
        .And. ;
        ValType ( ControlByIndex( I ):CTRL019 ) == 'U' ;

        lSplitBoxed := .T.

    EndIf

EndIf
Return lSplitBoxed

FUNCTION _IsWindowVisibleFromHandle (Handle)

   Local x
   Local lVisible := .f.

   For x := 1 To oHmgApp():FormCount

      If FormByIndex( X ):Handle == Handle
         lVisible := .Not. FormByIndex( X ):NoShow
         Exit
      EndIf
   Next x

   RETURN lVisible

Function GetFocusedControlType()
Local nHandle
Local cType
Local i

cType := ''

nHandle := GetFocus()

For i := 1 To oHmgApp():ControlCount

    If ValType ( ControlByIndex( i ):Handle ) == 'N'

        If ControlByIndex( i ):Handle == nHandle

            cType := ControlByIndex( i ):Type

        EndIf

    EndIf

Next i
Return cType


//*********************************************
// by Dr. Claudio Soto (April 2013)
//*********************************************

Function _GridEx_GetProperty (xData, Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local i, RetVal := .F.
Local cHeader, nAlignHeader, cFooter, nAlingFooter, nState

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. ((GetControlType(Arg2 , Arg1) <> "GRID") .AND. (GetControlType(Arg2 , Arg1) <> "MULTIGRID"))
   RETURN .F.
ENDIF

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg6 )
HB_SYMBOL_UNUSED ( Arg7 )
HB_SYMBOL_UNUSED ( Arg8 )

i := GetControlIndex ( Arg2 , Arg1 )

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == 'COLUMNCOUNT'
        xData  := _GridEx_ColumnCount ( Arg2 , Arg1 )
        RetVal := .T.

   CASE Arg3 == 'COLUMNHEADER'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADER_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNWIDTH'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_WIDTH_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNJUSTIFY'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_JUSTIFY_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNCONTROL'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_CONTROL_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDYNAMICBACKCOLOR'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_DYNAMICBACKCOLOR_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDYNAMICFORECOLOR'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_DYNAMICFORECOLOR_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDYNAMICFONT'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_DYNAMICFONT_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'HEADERDYNAMICFONT'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADERFONT_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'HEADERDYNAMICBACKCOLOR'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADERBACKCOLOR_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'HEADERDYNAMICFORECOLOR'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADERFORECOLOR_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNVALID'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_VALID_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNWHEN'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_WHEN_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNONHEADCLICK'
        xData  := _GridEx_GetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_ONHEADCLICK_ , Arg4)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDISPLAYPOSITION'
        xData  := _GridEx_GetColumnDisplayPosition ( Arg2 , Arg1 , Arg4)
        RetVal := .T.

   CASE Arg3 == 'CELLEX'
        xData  := _GridEx_GetCellValue ( Arg2 , Arg1 , Arg4 , Arg5 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CellRowFocused')
        IF ControlByIndex( I ):CTRL032 == .T.   // CellNavigation == .T.
           xData := ControlByIndex( I ):CTRL039   // nRow of the selected cell
        ELSE
           xData := LISTVIEW_GETFOCUSEDITEM ( ControlByIndex( I ):Handle )
        ENDIF
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CellColFocused')
        IF ControlByIndex( I ):CTRL032 == .T.   // CellNavigation == .T.
           xData := ControlByIndex( I ):CTRL015   // nCol of the selected cell
        ELSE
           xData := 0
        ENDIF
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CellNavigation')
        xData := ControlByIndex( I ):CTRL032   // CellNavigation == .T. or .F.
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CellRowClicked')
        xData := ControlByIndex( I ):CTRL040 [37] [1]
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CellColClicked')
        xData := ControlByIndex( I ):CTRL040 [37] [2]
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('EditOption')
        xData := ControlByIndex( I ):CTRL040 [38]
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('ImageList')
       xData := ListView_GetImageList ( GetControlHandle(Arg2,Arg1) , LVSIL_SMALL )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('ImageIndex')
       xData := ListView_GetItemImageIndex ( GetControlHandle(Arg2,Arg1), (Arg4 - 1), (Arg5 - 1) )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('HeaderImageIndex')
       xData := ListView_GetHeaderImageIndex ( GetControlHandle(Arg2,Arg1), (Arg4 - 1) )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('PaintDoubleBuffer')
       xData := ListView_GetExtendedStyle ( GetControlHandle(Arg2,Arg1), LVS_EX_DOUBLEBUFFER )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CheckBoxEnabled')
       xData := ListView_GetExtendedStyle ( GetControlHandle(Arg2,Arg1), LVS_EX_CHECKBOXES )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CheckBoxItem')
       xData := ListView_GetCheckState ( GetControlHandle(Arg2,Arg1), (Arg4 - 1) )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupEnabled')
       xData := ListView_IsGroupViewEnabled ( GetControlHandle(Arg2,Arg1) )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupInfo')
       cHeader := nAlignHeader := cFooter := nAlingFooter := nState := NIL
       ListView_GroupGetInfo ( GetControlHandle(Arg2,Arg1), Arg4, @cHeader, @nAlignHeader, @cFooter, @nAlingFooter, @nState )
       xData := { cHeader, nAlignHeader, cFooter, nAlingFooter, nState }
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupItemID')
       xData := ListView_GroupItemGetID ( GetControlHandle(Arg2,Arg1), (Arg4 - 1) )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupExist')
       xData := ListView_HasGroup ( GetControlHandle(Arg2,Arg1), Arg4 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupGetAllItemIndex')
       xData := _GridEx_GroupGetAllItemIndex ( Arg2 , Arg1 , Arg4 )
       RetVal := .T.

ENDCASE
Return RetVal

Function _GridEx_SetProperty ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local i, hImageList, RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. ((GetControlType(Arg2 , Arg1) <> "GRID") .AND. (GetControlType(Arg2 , Arg1) <> "MULTIGRID"))
   RETURN .F.
ENDIF

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg8 )

i := GetControlIndex ( Arg2 , Arg1 )

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == 'COLUMNHEADER'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADER_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNWIDTH'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_WIDTH_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNJUSTIFY'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_JUSTIFY_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNCONTROL'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_CONTROL_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDYNAMICBACKCOLOR'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_DYNAMICBACKCOLOR_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDYNAMICFORECOLOR'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_DYNAMICFORECOLOR_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDYNAMICFONT'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_DYNAMICFONT_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'HEADERDYNAMICFONT'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADERFONT_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'HEADERDYNAMICBACKCOLOR'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADERBACKCOLOR_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'HEADERDYNAMICFORECOLOR'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_HEADERFORECOLOR_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNVALID'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_VALID_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNWHEN'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_WHEN_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNONHEADCLICK'
        _GridEx_SetColumnControl ( Arg2 , Arg1 , _GRID_COLUMN_ONHEADCLICK_ , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'COLUMNDISPLAYPOSITION'
        _GridEx_SetColumnDisplayPosition ( Arg2 , Arg1 , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'CELLEX'
        _GridEx_SetCellValue ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 )
        RetVal := .T.

   CASE Arg3 == 'BACKGROUNDIMAGE'
        _GridEx_SetBkImage ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6, Arg7 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CellNavigation')
       IF ValType (Arg4) == "L"
          ControlByIndex( I ):CTRL032 := Arg4   // CellNavigation == .T. or .F.
          ControlByIndex( I ):CTRL039 := LISTVIEW_GETFOCUSEDITEM ( GetControlHandle(Arg2,Arg1) )   // nRow of the selected cell
          RedrawWindow ( GetControlHandle(Arg2,Arg1) )
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('EditOption')
       IF ValType (Arg4) == "N"
          ControlByIndex( I ):CTRL040 [38] := Arg4
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('ImageList')
       ListView_SetImageList ( GetControlHandle(Arg2,Arg1) , Arg4 , LVSIL_SMALL )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('ImageIndex')
       ListView_SetItemImageIndex ( GetControlHandle(Arg2,Arg1), (Arg4 - 1), (Arg5 - 1), Arg6 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('HeaderImageIndex')
       ListView_SetHeaderImageIndex ( GetControlHandle(Arg2,Arg1), (Arg4 - 1), Arg5 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('Image')
       hImageList := ListView_GetImageList ( GetControlHandle(Arg2,Arg1), LVSIL_SMALL )
       IF hImageList <> 0
          ImageList_Destroy (hImageList)
       ENDIF
       IF ValType (Arg4) <> "L"
          Arg4 := .T.
       ENDIF
                                                   //   aImage   NoTransparent
       ADDLISTVIEWBITMAP ( GetControlHandle(Arg2,Arg1),   Arg5,     .NOT. Arg4 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('PaintDoubleBuffer')
       IF Arg4 == .T.
          ListView_ChangeExtendedStyle ( GetControlHandle(Arg2,Arg1), LVS_EX_DOUBLEBUFFER, NIL )
       ELSE
          ListView_ChangeExtendedStyle ( GetControlHandle(Arg2,Arg1), NIL, LVS_EX_DOUBLEBUFFER )
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CheckBoxEnabled')
       IF Arg4 == .T.
          ListView_ChangeExtendedStyle ( GetControlHandle(Arg2,Arg1), LVS_EX_CHECKBOXES, NIL )   // Add
       ELSE
          ListView_ChangeExtendedStyle ( GetControlHandle(Arg2,Arg1), NIL, LVS_EX_CHECKBOXES )   // Remove
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CheckBoxItem')
       ListView_SetCheckState ( GetControlHandle(Arg2,Arg1), (Arg4 - 1), Arg5 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CheckBoxAllItems')
       _GridEx_CheckBoxAllItems ( Arg2, Arg1, Arg4 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupEnabled')
       IF HMG_IsRunAppInWin32() == .F.    // GridGroup only work on Windows 64-bits
          ListView_EnableGroupView ( GetControlHandle(Arg2,Arg1), Arg4 )
       ELSE
          // MsgHMGError ("Grid Group is not available when application is running on Windows versions of 32-bits. Program terminated")
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupInfo')
       ASIZE ( Arg5, 5)
       ListView_GroupSetInfo ( GetControlHandle(Arg2,Arg1), Arg4, Arg5[1], Arg5[2], Arg5[3], Arg5[4], Arg5[5] )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupItemID')
       ListView_GroupItemSetID ( GetControlHandle(Arg2,Arg1), (Arg4 - 1), Arg5 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupCheckBoxAllItems')
       _GridEx_GroupCheckBoxAllItems ( Arg2, Arg1, Arg4, Arg5 )
       RetVal := .T.

ENDCASE
Return RetVal

Function _GridEx_DoMethod ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )
Local RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. ((GetControlType(Arg2 , Arg1) <> "GRID") .AND. (GetControlType(Arg2 , Arg1) <> "MULTIGRID"))
   RETURN .F.
ENDIF

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg9 )

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == 'ADDCOLUMNEX'
        _AddGridColumn ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
        RetVal := .T.

   CASE Arg3 == 'ADDITEMEX'
        IF ControlByIndex( GetControlIndex (Arg2 , Arg1) ):CTRL040 [ 9 ] == .F.
           _AddGridRow ( Arg2 , Arg1,  Arg4 , Arg5 )
        ENDIF
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupDeleteAll')
        ListView_GroupDeleteAll ( GetControlHandle (Arg2 , Arg1) )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupDelete')
       ListView_GroupDelete ( GetControlHandle(Arg2,Arg1), Arg4 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupAdd')
       ListView_GroupAdd ( GetControlHandle(Arg2,Arg1), Arg4, Arg5 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupExpand')
       ListView_GroupSetInfo ( GetControlHandle(Arg2,Arg1), Arg4, NIL, NIL, NIL, NIL, GRID_GROUP_NORMAL )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupCollapsed')
       ListView_GroupSetInfo ( GetControlHandle(Arg2,Arg1), Arg4, NIL, NIL, NIL, NIL, GRID_GROUP_COLLAPSED )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GroupDeleteAllItems')
        _GridEx_GroupDeleteAllItems ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

ENDCASE
Return RetVal

//*********************************************
// by Dr. Claudio Soto (November 2013)
//*********************************************

Function _Tree_GetProperty (xData, Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local i, nPos, RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. (GetControlType(Arg2 , Arg1) <> "TREE")
   RETURN .F.
ENDIF

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg5 )
HB_SYMBOL_UNUSED ( Arg6 )
HB_SYMBOL_UNUSED ( Arg7 )
HB_SYMBOL_UNUSED ( Arg8 )


Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE

   CASE Arg3 == 'ALLVALUE'
        xData  := TreeItemGetAllValue ( Arg2 , Arg1 )
        RetVal := .T.

   CASE Arg3 == 'ROOTVALUE'
        xData  := TreeItemGetRootValue ( Arg2 , Arg1 )
        RetVal := .T.

   CASE Arg3 == 'FIRSTITEMVALUE'
        xData  := TreeItemGetFirstItemValue ( Arg2 , Arg1 )
        RetVal := .T.

   CASE Arg3 == 'PARENTVALUE'
        xData  := TreeItemGetParentValue ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'CHILDVALUE'
        xData  := TreeItemGetChildValue ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'SIBLINGVALUE'
        xData  := TreeItemGetSiblingValue ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'ITEMTEXT'
        xData  := TreeItemGetItemText ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'ISTRUENODE'
        xData  := TreeItemIsTrueNode ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'NODEFLAG'
        xData  := TreeItemGetNodeFlag ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'IMAGEINDEX'
        xData  := TreeItemGetImageIndex ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'IMAGECOUNT'
        xData  := TreeGetImageCount  ( Arg2 , Arg1 )
        RetVal := .T.

   CASE Arg3 == 'ISEXPAND'
        xData  := TreeItemIsExpand  ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('ImageList')
        xData := TreeView_GetImageList ( GetControlHandle(Arg2,Arg1) , TVSIL_NORMAL )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('HasLines')
        xData := HMG_IsWindowStyle (GetControlHandle(Arg2,Arg1), TVS_HASLINES, .F.)
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('FullRowSelect')
        xData := HMG_IsWindowStyle (GetControlHandle(Arg2,Arg1), TVS_FULLROWSELECT, .F.)
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('HasButton')
       xData := TreeView_GetHasButton (GetControlHandle(Arg2,Arg1), TreeItemGetHandle (Arg2, Arg1, Arg4))
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('Cargo')
       xData := _GetCargo ( Arg2, Arg1, Arg4, NIL )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('CargoScan')
       i := GetControlIndex ( Arg2, Arg1 )
       nPos := ASCAN ( ControlByIndex( I ):CTRL032 , Arg4 )
       xData := IF ( nPos > 0, nPos, NIL)
       IF nPos <> NIL .AND. ControlByIndex( I ):CTRL009 == .T.
         xData := ControlByIndex( I ):CTRL025 [nPos]
       EndIf
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GetPathValue')
       xData := TreeItemGetPathValue ( Arg2, Arg1, Arg4 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GetPathName')
       xData := TreeItemGetPathName ( Arg2, Arg1, Arg4 )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('GetDisplayLevel')
       xData := TreeItemGetDisplayLevel ( Arg2, Arg1, Arg4 )
       RetVal := .T.

ENDCASE
Return RetVal

Function _Tree_SetProperty ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. (GetControlType(Arg2 , Arg1) <> "TREE")
   RETURN .F.
ENDIF

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg6 )
HB_SYMBOL_UNUSED ( Arg7 )
HB_SYMBOL_UNUSED ( Arg8 )

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == 'NODEFLAG'
        TreeItemSetNodeFlag ( Arg2 , Arg1 , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'IMAGEINDEX'
        TreeItemSetImageIndex ( Arg2 , Arg1 , Arg4 , Arg5)
        RetVal := .T.

   CASE Arg3 == 'ADDIMAGE'
        TreeAddImage ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'TEXTCOLOR'
        TreeSetTextColor ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'BACKCOLOR'
        TreeSetBackColor ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'LINECOLOR'
        TreeSetLineColor ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ('ImageList')
       TreeView_SetImageList ( GetControlHandle(Arg2,Arg1) , Arg4 , TVSIL_NORMAL )
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('HasLines')
       IF Arg4 == .T.
         HMG_ChangeWindowStyle (GetControlHandle(Arg2,Arg1), TVS_HASLINES, NIL, .F.)
       ELSE
         HMG_ChangeWindowStyle (GetControlHandle(Arg2,Arg1), NIL, TVS_HASLINES, .F.)
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('FullRowSelect')
       IF Arg4 == .T.
         HMG_ChangeWindowStyle (GetControlHandle(Arg2,Arg1), TVS_FULLROWSELECT, NIL, .F.)
       ELSE
         HMG_ChangeWindowStyle (GetControlHandle(Arg2,Arg1), NIL, TVS_FULLROWSELECT, .F.)
       ENDIF
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('HasButton')
       TreeView_SetHasButton (GetControlHandle(Arg2,Arg1), TreeItemGetHandle (Arg2, Arg1, Arg4), Arg5)
       RetVal := .T.

   CASE Arg3 == HMG_UPPER ('Cargo')
      _SetCargo ( Arg2, Arg1, Arg4, NIL, Arg5 )
      RetVal := .T.

   CASE Arg3 == HMG_UPPER ('DynamicBackColor')
      ControlByIndex( GetControlIndex(Arg2, Arg1) ):CTRL040 [1] := Arg4
      RetVal := .T.

   CASE Arg3 == HMG_UPPER ('DynamicForeColor')
      ControlByIndex( GetControlIndex(Arg2, Arg1) ):CTRL040 [2] := Arg4
      RetVal := .T.

   CASE Arg3 == HMG_UPPER ('DynamicFont')
      ControlByIndex( GetControlIndex(Arg2, Arg1) ):CTRL040 [3] := Arg4
      RetVal := .T.

ENDCASE
Return RetVal

Function _Tree_DoMethod ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )
Local RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. (GetControlType(Arg2 , Arg1) <> "TREE")
   RETURN .F.
ENDIF

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg9 )

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == 'SETDEFAULTNODEFLAG'
        TreeItemSetDefaultNodeFlag ( Arg2 , Arg1 , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'SETDEFAULTALLNODEFLAG'
        TreeItemSetDefaultAllNodeFlag ( Arg2 , Arg1 )
        RetVal := .T.

   CASE Arg3 == 'SORT'
        TreeItemSort ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
        RetVal := .T.

ENDCASE
Return RetVal

//*********************************************
// by Dr. Claudio Soto (January 2014)
//*********************************************

Function _RichEditBox_GetProperty ( xData, Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7, Arg8 )
Local hWndControl, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, aTextColor, aBackColor, nScript, lLink
Local nAlignment, nNumbering, nNumberingStyle, nNumberingStart, ndOffset, ndLineSpacing, ndStartIndent
Local nNumerator, nDenominator
Local RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. (GetControlType(Arg2 , Arg1) <> "RICHEDIT")
   RETURN .F.
ENDIF

cFontName := nFontSize := lBold := lItalic := lUnderline := lStrikeout := aTextColor := aBackColor := nScript := lLink := NIL
nAlignment := nNumbering := nNumberingStyle := nNumberingStart := ndOffset := ndLineSpacing := ndStartIndent := NIL


hWndControl := GetControlHandle (Arg2 , Arg1)
RichEditBox_GetFont       ( hWndControl, @cFontName, @nFontSize, @lBold, @lItalic, @lUnderline, @lStrikeout, @aTextColor, @aBackColor, @nScript, @lLink )
RichEditBox_GetParaFormat ( hWndControl, @nAlignment, @nNumbering, @nNumberingStyle, @nNumberingStart, @ndOffset, @ndLineSpacing, @ndStartIndent )

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == 'FONTNAME'
        xData  := cFontName
        RetVal := .T.

   CASE Arg3 == 'FONTSIZE'
        xData  := nFontSize
        RetVal := .T.

   CASE Arg3 == 'FONTBOLD'
        xData  := lBold
        RetVal := .T.

   CASE Arg3 == 'FONTITALIC'
        xData  := lItalic
        RetVal := .T.

   CASE Arg3 == 'FONTUNDERLINE'
        xData  := lUnderline
        RetVal := .T.

   CASE Arg3 == 'FONTSTRIKEOUT'
        xData  := lStrikeout
        RetVal := .T.

   CASE Arg3 == 'FONTCOLOR'
        xData  := aTextColor
        RetVal := .T.

   CASE Arg3 == 'FONTBACKCOLOR'
        xData  := aBackColor
        RetVal := .T.

   CASE Arg3 == 'FONTSCRIPT'
        xData  := nScript
        RetVal := .T.

   CASE Arg3 == 'RTFTEXTMODE'
        xData  := RichEditBox_IsRTFTextMode ( hWndControl )
        RetVal := .T.

   CASE Arg3 == 'AUTOURLDETECT'
        xData  := RichEditBox_GetAutoURLDetect ( hWndControl )
        RetVal := .T.

   CASE Arg3 == 'ZOOM'
        RichEditBox_GetZoom ( hWndControl, @nNumerator, @nDenominator )
        xData  := (nNumerator / nDenominator) * 100
        RetVal := .T.

   CASE Arg3 == 'SELECTRANGE'
        xData  := RichEditBox_GetSelRange ( hWndControl )
        RetVal := .T.

   CASE Arg3 == 'CARETPOS'
        xData  := RichEditBox_GetCaretPos ( hWndControl )
        RetVal := .T.

   CASE Arg3 == 'VALUE'
        xData  := RichEditBox_GetText ( hWndControl , .F. )
        RetVal := .T.

   CASE Arg3 == 'GETSELECTTEXT'
        xData  := RichEditBox_GetText ( hWndControl , .T. )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("GetTextRange")
        xData  := RichEditBox_GetTextRange ( hWndControl , Arg4 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("GetTextLength")
        xData  := RichEditBox_GetTextLength ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("GetPosChar")
        xData  := RichEditBox_PosFromChar ( hWndControl , Arg4 )   // return { nRowScreen, nColScreen } or { -1, -1 } if character is not displayed
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaAlignment")
        xData  := nAlignment
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaNumbering")
        xData  := nNumbering
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaNumberingStyle")
        xData  := nNumberingStyle
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaNumberingStart")
        xData  := nNumberingStart
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaOffset")
        xData  := ndOffset   // in millimeters
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaLineSpacing")
        xData  := ndLineSpacing
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaIndent")
        xData  := ndStartIndent   // in millimeters
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("CanPaste")
        xData  := RichEditBox_CanPaste ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("CanUnDo")
        xData  := RichEditBox_CanUnDo ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("CanReDo")
        xData  := RichEditBox_CanReDo ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("FindText")
        xData  := RichEditBox_FindText       ( hWndControl, Arg4 , Arg5 , Arg6 , Arg7 , Arg8)
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ReplaceText")
        xData  := RichEditBox_ReplaceText    ( hWndControl, Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ReplaceAllText")
        xData  := RichEditBox_ReplaceAllText ( hWndControl, Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("Link")
        xData  := lLink
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("GetClickLinkRange")
        xData  := { _HMG_CharRange_Min , _HMG_CharRange_Max }   // This Value is valid only into ON LINK procedure
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("GetClickLinkText")
        xData  := RichEditBox_GetTextRange ( hWndControl , { _HMG_CharRange_Min , _HMG_CharRange_Max } )   // This Value is valid only into ON LINK procedure
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ViewRect")
        xData  := RichEditBox_GetRect ( hWndControl )
        RetVal := .T.

ENDCASE
Return RetVal

Function _RichEditBox_SetProperty (Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )
Local hWndControl, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, aTextColor, aBackColor, nScript, lLink
Local nAlignment, nNumbering, nNumberingStyle, nNumberingStart, ndOffset, ndLineSpacing, ndStartIndent
Local nNumerator, nDenominator
Local RetVal := .F.

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. (GetControlType(Arg2 , Arg1) <> "RICHEDIT")
   RETURN .F.
ENDIF

cFontName := nFontSize := lBold := lItalic := lUnderline := lStrikeout := aTextColor := aBackColor := nScript := lLink := NIL
nAlignment := nNumbering := nNumberingStyle := nNumberingStart := ndOffset := ndLineSpacing := ndStartIndent := NIL

// Parameters NOT used
HB_SYMBOL_UNUSED ( Arg6 )
HB_SYMBOL_UNUSED ( Arg7 )
HB_SYMBOL_UNUSED ( Arg8 )

hWndControl := GetControlHandle (Arg2 , Arg1)

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE

   CASE Arg3 == 'FONTNAME'
        cFontName := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTSIZE'
        nFontSize := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTBOLD'
        lBold := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTITALIC'
        lItalic := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTUNDERLINE'
        lUnderline := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTSTRIKEOUT'
        lStrikeout := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTCOLOR'
        aTextColor := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTBACKCOLOR'
        aBackColor := Arg4
        RetVal := .T.

   CASE Arg3 == 'FONTSCRIPT'
        nScript   := Arg4
        RetVal := .T.

   CASE Arg3 == 'RTFTEXTMODE'
        RichEditBox_SetRTFTextMode ( hWndControl , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'AUTOURLDETECT'
        RichEditBox_SetAutoURLDetect ( hWndControl , Arg4 )
        RetVal := .T.

   CASE Arg3 == 'BACKGROUNDCOLOR'
        RichEditBox_SetBkgndColor ( hWndControl, Arg4 )
        RetVal := .T.

   CASE Arg3 == 'ZOOM'
        nNumerator   := Arg4   // in percentage
        nDenominator := 100
        RichEditBox_SetZoom ( hWndControl, nNumerator, nDenominator)
        RetVal := .T.

   CASE Arg3 == 'SELECTRANGE'
        RichEditBox_SetSelRange ( hWndControl, Arg4 )
        RetVal := .T.

   CASE Arg3 == 'CARETPOS'
        RichEditBox_SetCaretPos ( hWndControl, Arg4 )
        RetVal := .T.

   CASE Arg3 == 'VALUE'
        RichEditBox_SetText ( hWndControl, .F., Arg4 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("AddText")
        Arg4 := IF ( ValType (Arg4) <> "N", -1, Arg4 )
        RichEditBox_SetCaretPos ( hWndControl,  Arg4 )
        RichEditBox_SetText ( hWndControl, .T., Arg5 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("AddTextAndSelect")
        Arg4 := IF ( ValType (Arg4) <> "N", -1, Arg4 )
        RichEditBox_AddTextAndSelect ( hWndControl , Arg4, Arg5 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaAlignment")
        nAlignment := Arg4
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaNumbering")
        nNumbering := Arg4
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaNumberingStyle")
        nNumberingStyle := Arg4
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaNumberingStart")
        nNumberingStart := Arg4
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaOffset")
        ndOffset :=  Arg4   // in millimeters
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaLineSpacing")
        ndLineSpacing := Arg4
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ParaIndent")
        ndStartIndent := Arg4   // in millimeters
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("Link")
        lLink := Arg4
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ViewRect")
        RichEditBox_SetRect ( hWndControl, Arg4 )
        RetVal := .T.

ENDCASE

RichEditBox_SetFont       ( hWndControl, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, aTextColor, aBackColor, nScript, lLink )
RichEditBox_SetParaFormat ( hWndControl, nAlignment, nNumbering, nNumberingStyle, nNumberingStart, ndOffset, ndLineSpacing, ndStartIndent )
Return RetVal

Function _RichEditBox_DoMethod ( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )
Local RetVal := .F.
Local hWndControl

IF (Valtype(Arg1) <> "C") .OR. (Valtype(Arg2) <> "C") .OR. (Valtype (Arg3) <> "C") .OR. (_IsControlDefined(Arg2 , Arg1) == .F.) .OR. (GetControlType(Arg2 , Arg1) <> "RICHEDIT")
   RETURN .F.
ENDIF


hWndControl := GetControlHandle (Arg2 , Arg1)

Arg3 := HMG_UPPER (ALLTRIM (Arg3))

DO CASE
   CASE Arg3 == HMG_UPPER ("SelectAll")
        RichEditBox_SelectAll ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("UnSelectAll")
        RichEditBox_UnSelectAll ( hWndControl )
        RetVal := .T.


   CASE Arg3 == HMG_UPPER ("RTFLoadFile") .OR. Arg3 == HMG_UPPER ("LoadFile")
        RichEditBox_LoadFile ( hWndControl, Arg4, Arg5, Arg6 )   // by default load in SF_RTF format
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("RTFSaveFile") .OR. Arg3 == HMG_UPPER ("SaveFile")
        RichEditBox_SaveFile ( hWndControl, Arg4, Arg5, Arg6 )   // by default save in SF_RTF format
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("SelPasteSpecial")
        RichEditBox_PasteSpecial ( hWndControl, Arg4 )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("SelCopy")
        RichEditBox_SelCopy ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("SelPaste")
        RichEditBox_SelPaste ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("SelCut")
        RichEditBox_SelCut ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("SelClear")
        RichEditBox_SelClear ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("Undo")
        RichEditBox_ChangeUndo ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("Redo")
        RichEditBox_ChangeRedo ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("ClearUndoBuffer")
        RichEditBox_ClearUndoBuffer ( hWndControl )
        RetVal := .T.

   CASE Arg3 == HMG_UPPER ("RTFPrint")
        RichEditBox_RTFPrint ( hWndControl, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )
        RetVal := .T.

ENDCASE
Return RetVal


//*********************************************
// by Dr. Claudio Soto (January 2014)
//*********************************************

Function GetFontList ( hDC, cFontFamilyName, nCharSet , nPitch , nFontType, lSortCaseSensitive, aFontName)   // return array { { cFontName, nCharSet, nPitchAndFamily, nFontType } , ... }
Local SortCodeBlock

IF ValType (lSortCaseSensitive) <> "L"
   lSortCaseSensitive := .F.
ENDIF

IF lSortCaseSensitive == .T.
   SortCodeBlock := { |x, y| x[1] < y[1] }
ELSE
   SortCodeBlock := { |x, y| HMG_UPPER (ALLTRIM ( x[1] )) < HMG_UPPER (ALLTRIM ( y[1] )) }
ENDIF
Return EnumFonts ( hDC, cFontFamilyName, nCharSet , nPitch , nFontType, SortCodeBlock, @aFontName )


//*********************************************
// by Dr. Claudio Soto (July 2014)
//*********************************************

Function _SetCargo ( ControlName , ParentForm , Item , idx, xData )
LOCAL i := 0, RetVal := NIL
LOCAL T , c, aPos

   if ValType (idx) <> "N"
      i := GetControlIndex ( ControlName , ParentForm )
   else
      i := idx
   endif

   T = ControlByIndex( i ):Type
   c = ControlByIndex( i ):Handle

   DO CASE
      CASE t == 'TREE'
         if ControlByIndex( I ):CTRL009 == .F.
            If Item > TreeView_GetCount ( c ) .or. Item < 1
                MsgHMGError ("Item Property: Invalid Item Reference. Program Terminated" )
            EndIf
            ControlByIndex( I ):CTRL032 [ Item ] := xData   // cargo
         Else
            aPos := ascan ( ControlByIndex( I ):CTRL025 , Item )
            If aPos == 0
                MsgHMGError ("Item Property: Invalid Item Id. Program Terminated" )
            EndIf
            ControlByIndex( I ):CTRL032 [ aPos ] := xData   // cargo
         EndIf
   ENDCASE
Return NIL


Function _GetCargo ( ControlName , ParentForm , Item , idx )
LOCAL i := 0, xData := NIL
LOCAL T , c, aPos

   if ValType (idx) <> "N"
      i := GetControlIndex ( ControlName , ParentForm )
   else
      i := idx
   endif

   T = ControlByIndex( i ):Type
   c = ControlByIndex( i ):Handle

   DO CASE
      CASE t == 'TREE'
         If ControlByIndex( I ):CTRL009 == .F.
            If Item > TreeView_GetCount ( c ) .or. Item < 1
                MsgHMGError ("Item Property: Invalid Item Reference. Program Terminated" )
            EndIf
            xData := ControlByIndex( I ):CTRL032 [ Item ]   // cargo
         Else
            aPos := ascan ( ControlByIndex( I ):CTRL025 , Item )
            If aPos == 0
                MsgHMGError ("Item Property: Invalid Item Id. Program Terminated" )
            EndIf
            xData := ControlByIndex( I ):CTRL032 [ aPos ]   // cargo
         EndIf
   ENDCASE
Return xData



//*********************************************
// by Dr. Claudio Soto (December 2014)
//*********************************************

FUNCTION HMG_CreateFontFromArrayFont ( aFont )
LOCAL cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut
LOCAL hFont := 0

   IF ValType ( aFont ) == "A"
      IF HMG_LEN (aFont) < 6
         ASIZE (aFont, 6 )   // { cFontName, nFontSize, [ lBold, lItalic, lUnderline, lStrikeOut ] }
      ENDIF

      IF ValType (aFont [1]) == "C" .AND. .NOT. EMPTY(aFont [1]) .AND. ValType (aFont [2]) == "N" .AND. aFont [2] > 0
         cFontName  := aFont [1]
         nFontSize  := aFont [2]
         lBold      := aFont [3]
         lItalic    := aFont [4]
         lUnderline := aFont [5]
         lStrikeOut := aFont [6]

         hFont := HMG_CreateFont (NIL, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut )
      ENDIF
   ENDIF

RETURN hFont


PROCEDURE SetToolTipCustomDraw ( lOn )
LOCAL k, hWndToolTip
   IF HB_ISLOGICAL ( lOn )
      oHmgApp():APP509 := lOn
      IF lOn == .F.
         FOR k := 1 TO oHmgApp():FormCount
            IF ! FormByIndex( k ):IsDeleted
               hWndToolTip := FormByIndex( k ):FORM073
               IF FormByIndex( k ):FORM512[ 7 ] == .T.
                  HMG_ChangeWindowStyle ( hWndToolTip, TTS_BALLOON, NIL, .F. )
               ELSE
                  HMG_ChangeWindowStyle ( hWndToolTip, NIL, TTS_BALLOON, .F. )
               ENDIF
               SendMessage ( hWndToolTip, WM_SETFONT, 0, MAKELPARAM (1, 0))   // Set Default Font System
               ToolTip_SetTitle ( hwndToolTip, "", "" )
            ENDIF
         NEXT
      ENDIF
   ENDIF
RETURN


PROCEDURE SetToolTipCustomDrawForm (cFormName, aBackColor, aForeColor, aFont, lBalloon, cTitle, xIconName )
LOCAL k := GetFormIndex ( cFormName )
LOCAL hFont, DefaultBalloon

   IF HB_ISNIL (aBackColor) .AND. ;
      HB_ISNIL (aForeColor) .AND. ;
      HB_ISNIL (aFont)      .AND. ;
      HB_ISNIL (lBalloon)   .AND. ;
      HB_ISNIL (cTitle)     .AND. ;
      HB_ISNIL (xIconName)

      DefaultBalloon := FormByIndex( k ):FORM512[ 7 ]
      FormByIndex( k ):FORM512 := { -1, -1, 0, DefaultBalloon, "", "", DefaultBalloon }   // Set Default Data
   ENDIF

   IF ValType ( aBackColor ) == "A"
      FormByIndex( k ):FORM512[ 1 ] := RGB ( aBackColor[1], aBackColor[2], aBackColor[3] )
   ENDIF

   IF ValType ( aForeColor ) == "A"
      FormByIndex( k ):FORM512[ 2 ] := RGB ( aForeColor[1], aForeColor[2], aForeColor[3] )
   ENDIF

   IF ValType ( aFont ) == "A"
      hFont := FormByIndex( k ):FORM512[ 3 ]
      IF hFont <> 0
         DeleteObject ( hFont )
      ENDIF

      hFont := HMG_CreateFontFromArrayFont ( aFont )
      FormByIndex( k ):FORM512[ 3 ] := hFont
   ENDIF

   IF ValType ( lBalloon ) == "L"
      FormByIndex( k ):FORM512[ 4 ] := lBalloon
   ENDIF

   IF ValType ( cTitle ) == "C"
      FormByIndex( k ):FORM512[ 5 ] := cTitle
   ENDIF

   IF ValType ( xIconName ) == "C" .OR. ValType ( xIconName ) == "N"
      FormByIndex( k ):FORM512[ 6 ] := xIconName
   ENDIF

RETURN


PROCEDURE SetToolTipCustomDrawControl (cControlName, cFormName, aBackColor, aForeColor, aFont, lBalloon, cTitle, xIconName )
LOCAL hFont, DefaultBalloon
LOCAL i := GetControlIndex (cControlName, cFormName)
LOCAL k := GetFormIndex (cFormName)

   IF ValType ( ControlByIndex( I ):CTRL041 [ 3 ] ) != "A" .OR. ;
              ( HB_ISNIL (aBackColor) .AND. ;
                HB_ISNIL (aForeColor) .AND. ;
                HB_ISNIL (aFont)      .AND. ;
                HB_ISNIL (lBalloon)   .AND. ;
                HB_ISNIL (cTitle)     .AND. ;
                HB_ISNIL (xIconName) )
      DefaultBalloon := FormByIndex( k ):FORM512[ 7 ]
      ControlByIndex( I ):CTRL041 [ 3 ] := { -1, -1, 0, DefaultBalloon, "", "" }   // Set Default Data
   ENDIF

   IF ValType ( aBackColor ) == "A"
      ControlByIndex( I ):CTRL041 [ 3 ] [ 1 ] := RGB ( aBackColor[1], aBackColor[2], aBackColor[3] )
   ENDIF

   IF ValType ( aForeColor ) == "A"
      ControlByIndex( I ):CTRL041 [ 3 ] [ 2 ] := RGB ( aForeColor[1], aForeColor[2], aForeColor[3] )
   ENDIF

   IF ValType ( aFont ) == "A"
      hFont := ControlByIndex( I ):CTRL041 [ 3 ] [ 3 ]
      IF hFont <> 0
         DeleteObject ( hFont )
      ENDIF

      hFont := HMG_CreateFontFromArrayFont ( aFont )
      ControlByIndex( I ):CTRL041 [ 3 ] [ 3 ] := hFont
   ENDIF

   IF ValType ( lBalloon ) == "L"
      ControlByIndex( I ):CTRL041 [ 3 ] [ 4 ] := lBalloon
   ENDIF

   IF ValType ( cTitle ) == "C"
      ControlByIndex( I ):CTRL041 [ 3 ] [ 5 ] := cTitle
   ENDIF

   IF ValType ( xIconName ) == "C" .OR. ValType ( xIconName ) == "N"
      ControlByIndex( I ):CTRL041 [ 3 ] [ 6 ] := xIconName
   ENDIF

RETURN


#define TTN_FIRST (0 - 520)
#define TTN_SHOW (TTN_FIRST - 1)
#define DEFAULT_GUI_FONT 17

FUNCTION ToolTipCustomDrawEvent ( lParam )
LOCAL i, k, j, hFont, xTmp
LOCAL IsToolTipMenu := .F. //, hWnd := 0
LOCAL xRet := NIL

   If GetNotifyCode ( lParam ) ==  NM_CUSTOMDRAW .OR. GetNotifyCode ( lParam ) ==  TTN_SHOW
      IF oHmgApp():APP509 == .T. // ToolTip CustomDraw
         xTmp := FormByBlock( { | e | e:FORM073 == GetHwndFrom (lParam) } )
         K := iif( xTmp == Nil, 0, xTmp:Index )   // ToolTipHandle
         xTmp := ControlByHandle( GetIdFrom( lParam ) )
         i := iif( xTmp == Nil, 0, xTmp:Index )  // ToolTipID == ControlHandle

         if k > 0 .AND. i == 0
            FOR j := 1 To oHmgApp():ControlCount
               IF ValType ( ControlByIndex( J ):Handle ) == 'A' .AND. ControlByIndex( J ):Type == 'SPINNER' .AND. ControlByIndex( J ):Handle [ 1 ] == GetIdFrom (lParam)   // ToolTipID == ControlHandle
                  i := j
                  EXIT
               ENDIF
            NEXT
         endif

         if k == 0 .AND. i == 0
            xTmp := FormByBlock( { | e | e:TooltipMenuHandle == GetHWndFrom( lParam ) } ) // ToolTipHandleMenu
            k := iif( xTmp == Nil, 0, xTmp:Index )
            xTmp := ControlByHandle( { | e | e:CTRL005 == GetIdFrom( lParam ) } )
            i := iif( xTmp == Nil, 0, xTmp:Index )   // ToolTipID == MenuItemID
            IsToolTipMenu := .T.
         endif

         if k > 0 .AND. i > 0
/*
            if IsToolTipMenu == .T.
               hWnd := ControlByIndex( I ):ParentFormHandle
            endif
*/
            if ValType ( ControlByIndex( I ):CTRL041 [ 3 ] ) == "A"
IF GetNotifyCode ( lParam ) ==  NM_CUSTOMDRAW
               ToolTip_SetTitle ( GetHwndFrom (lParam), ControlByIndex( I ):CTRL041 [ 3 ] [ 5 ] , ControlByIndex( I ):CTRL041 [ 3 ] [ 6 ] )

               if ControlByIndex( I ):CTRL041 [ 3 ] [ 4 ] == .T.
                  HMG_ChangeWindowStyle ( GetHwndFrom (lParam), TTS_BALLOON, NIL, .F., .F. )
               else
                  HMG_ChangeWindowStyle ( GetHwndFrom (lParam), NIL, TTS_BALLOON, .F., .F. )
               endif

               xRet := TOOLTIP_CUSTOMDRAW ( lParam,;
                                           ControlByIndex( I ):CTRL041 [ 3 ] [ 1 ],;
                                           ControlByIndex( I ):CTRL041 [ 3 ] [ 2 ],;
                                           /*ControlByIndex( I ):CTRL041 [ 3 ] [ 3 ],;
                                           IsToolTipMenu,;
                                           hWnd */ )

ELSEIF GetNotifyCode ( lParam ) ==  TTN_SHOW  .AND.  .NOT.( IsToolTipMenu )
   hFont := ControlByIndex( I ):CTRL041 [ i ] [ 3 ] [ 3 ]
   IF hFont == 0
      hFont := GetStockObject( DEFAULT_GUI_FONT )
   ENDIF
   SetWindowFont (GetHwndFrom (lParam), hFont, .T. )
   //xRet := 1
ENDIF
            else

IF GetNotifyCode ( lParam ) ==  NM_CUSTOMDRAW
               ToolTip_SetTitle ( GetHwndFrom (lParam), FormByIndex( k ):FORM512[ 5 ], FormByIndex( k ):FORM512[ 6 ] )

               if FormByIndex( k ):FORM512[ 4 ] == .T.
                  HMG_ChangeWindowStyle ( GetHwndFrom (lParam), TTS_BALLOON, NIL, .F., .F. )
               else
                  HMG_ChangeWindowStyle ( GetHwndFrom (lParam), NIL, TTS_BALLOON, .F., .F. )
               endif

               xRet := TOOLTIP_CUSTOMDRAW ( lParam,;
                                           FormByIndex( k ):FORM512[ 1 ],;
                                           FormByIndex( k ):FORM512[ 2 ],;
                                           /*FormByIndex( k ):FORM512[ 3 ],;
                                           IsToolTipMenu,;
                                           hWnd */ )

ELSEIF GetNotifyCode ( lParam ) ==  TTN_SHOW  .AND.  .NOT.( IsToolTipMenu )
   hFont := FormByIndex( k ):FORM512[ 3 ]
   IF hFont == 0
      hFont := GetStockObject( DEFAULT_GUI_FONT )
   ENDIF
   SetWindowFont (GetHwndFrom (lParam), hFont, .T. )
   //xRet := 1
ENDIF
            endif
         EndIf
      ENDIF
   EndIf

RETURN xRet


FUNCTION ToolTipMenuDisplayEvent ( wParam, lParam )
__THREAD STATIC hWndToolTip_Old := 0, hWnd_Old := 0, nMenuItemID_Old := 0
LOCAL hWndToolTip := 0
LOCAL Menu_ID     := LOWORD ( wParam )
LOCAL Menu_Flag   := HIWORD ( wParam )
LOCAL hMenu       := lParam
LOCAL hWnd        := 0, xTmp
LOCAL hFont       := 0
LOCAL i, k

   IF oHmgApp():APP510 == .T.

      FOR i := 1 TO oHmgApp():ControlCount
         IF ControlByIndex( i ):Type == "MENU" .AND. ControlByIndex( I ):CTRL005 == Menu_ID
            hWnd := ControlByIndex( I ):ParentFormHandle
            hWndToolTip := FormByHandle( hWnd ):TooltipMenuHandle
            EXIT
         ENDIF
      NEXT

      ToolTip_ShowMenu ( hWndToolTip_Old, hWnd_Old, nMenuItemID_Old, .F. )   // Hide Previous ToolTip Menu

      hWndToolTip_Old := hWndToolTip
      hWnd_Old        := hWnd
      nMenuItemID_Old := nMenuItemID_Old

      xTmp := FormByBlock( { | e | e:TooltipMenuHandle = hWndTooltip } ) // ToolTipHandleMenu
      k := iif( xTmp == Nil, 0, xTmp:Index )
      xTmp := ControlByBlock( { | e | e:CTRL005 == Menu_ID } )
      i := iif( xTmp == Nil, 0, xTmp:Index )   // ToolTipID == MenuItemID
      IF i > 0 .AND. ValType ( ControlByIndex( I ):CTRL041 [ 3 ] ) == "A"
         hFont := ControlByIndex( I ):CTRL041 [ 3 ] [ 3 ]
      ELSEIF k > 0
         hFont := FormByIndex( k ):FORM512[ 3 ]
      ENDIF
      IF hFont == 0
         hFont := GetStockObject( DEFAULT_GUI_FONT )
      ENDIF

      ToolTip_MenuDisplay ( hWndToolTip, hWnd, hMenu, Menu_ID, Menu_Flag, hFont )

   ENDIF

RETURN NIL


PROCEDURE SetToolTipMenu ( lOn )
LOCAL k, hWndToolTip
   IF HB_ISLOGICAL ( lOn )
      oHmgApp():APP510 := lOn
      IF lOn == .F.
         FOR k := 1 TO oHmgApp():FormCount
            IF ! FormByIndex( k ):IsDeleted
               hWndToolTip := FormByIndex( k ):TooltipMenuHandle
               IF FormByIndex( k ):FORM512[ 7 ] == .T.
                  HMG_ChangeWindowStyle ( hWndToolTip, TTS_BALLOON, NIL, .F. )
               ELSE
                  HMG_ChangeWindowStyle ( hWndToolTip, NIL, TTS_BALLOON, .F. )
               ENDIF
               SendMessage ( hWndToolTip, WM_SETFONT, 0, MAKELPARAM (1, 0))   // Set Default Font System
            ENDIF
         NEXT
      ENDIF
   ENDIF
RETURN



//*********************************************
// by Dr. Claudio Soto (May 2015)
//*********************************************

//-----------------------------------------------------------------------------------------------
//   HMG_CallDLL ( cLibName , [ nRetType ] , cFuncName , Arg1 , ... , ArgN ) ---> xRetValue
//-----------------------------------------------------------------------------------------------

FUNCTION HMG_CallDLL ( cLibName, nRetType, cFuncName, ... )
STATIC s_hDLL   := { => }
STATIC s_mutex  := hb_mutexCreate()
LOCAL nCallConv := HB_DYN_CALLCONV_STDCALL
LOCAL nEncoding := IIF ( HMG_IsCurrentCodePageUnicode(), HB_DYN_ENC_UTF16, HB_DYN_ENC_ASCII )
LOCAL pLibrary

   IF HB_ISSTRING( cFuncName ) .AND. HB_ISSTRING( cLibName )
      hb_mutexLock( s_mutex )

      IF !( cLibName $ s_hDLL )
         s_hDLL[ cLibName ] := hb_libLoad( cLibName )
      ENDIF

      pLibrary := s_hDLL[ cLibName ]

      hb_mutexUnlock( s_mutex )

      IF .NOT. HB_ISNUMERIC( nRetType )
         nRetType := HB_DYN_CTYPE_DEFAULT
      ENDIF

      cFuncName := ALLTRIM (cFuncName)

      DO CASE
         CASE HMG_IsCurrentCodePageUnicode() == .T. .AND. HMG_IsFuncDLL( pLibrary, cFuncName + "W" )
            cFuncName := cFuncName + "W"
         CASE HMG_IsCurrentCodePageUnicode() == .F. .AND. HMG_IsFuncDLL( pLibrary, cFuncName + "A" )
            cFuncName := cFuncName + "A"
      ENDCASE

      RETURN hb_DynCall ( { cFuncName, pLibrary, hb_bitOR (nCallConv, nRetType, nEncoding) }, ... )
   ENDIF

RETURN NIL


/*
   HB_DYNCALL ({<cFunction>, <cLibrary> | <pLibrary> [, <nFuncFlags> [, <nArgFlags1>, ..., <nArgFlagsn>]]}, ...) -> <xResult>

      nFuncFlags ---> hb_bitOr (HB_DYN_CTYPE_ *, HB_DYN_ENC_ *, HB_DYN_CALLCONV_ *)
      nArgFlags  ---> hb_bitOr (HB_DYN_CTYPE_ *, HB_DYN_ENC_ *)
      pLibrary : = hb_libLoad (cLibrary)
*/


#pragma BEGINDUMP
#include "SET_COMPILE_HMG_UNICODE.ch"
#include "HMG_UNICODE.h"
#include <windows.h>
#include "hbapi.h"


//        HMG_IsFuncDLL ( pLibDLL | cLibName, cFuncName ) ---> Boolean
HB_FUNC ( HMG_ISFUNCDLL )
{
   HMODULE hModule = NULL;
   BOOL bRelease;

   if ( HB_ISCHAR (1) )
   {  hModule = LoadLibrary ((TCHAR *) HMG_parc (1));
      bRelease = TRUE;
   }
   else
   {  hModule = hb_libHandle (hb_param (1, HB_IT_ANY));
      bRelease = FALSE;
   }

   CHAR * cFuncName = (CHAR *) hb_parc (2);

   hb_retl (GetProcAddress (hModule, cFuncName) ? TRUE : FALSE);

   if (bRelease && hModule)
      FreeLibrary (hModule);
}

#pragma ENDDUMP



FUNCTION HMG_GetHBSymbols()   // return array -->   { { cSymName1, cSymType1 } , { cSymName2, cSymType2 }, ... }
LOCAL i, cSymName, aSym := {}
/*
__DYNSCOUNT()    // How much symbols do we have:    dsCount = __dynsCount()
__DYNSGETNAME()  // Get name of symbol:             cSymbol = __dynsGetName( dsIndex )
__DYNSGETINDEX() // Get index number of symbol:     dsIndex = __dynsGetIndex( cSymbol )
__DYNSISFUN()    // returns .T. if a symbol has a function/procedure pointer given its symbol index or name:   __DynsIsFun( cSymbol | dsIndex )
HB_ISFUNCTION()  // returns .T. if a symbol has a function/procedure pointer:                                  hb_IsFunction( cSymbol )
*/

   FOR i := __DYNSCOUNT() TO 1 STEP -1
      cSymName := __DYNSGETNAME( i )
      AAdd( aSym, { cSymName, IIF( __DYNSISFUN( cSymName ), "FUNC/PROC","" ) } )
   NEXT

RETURN aSym
