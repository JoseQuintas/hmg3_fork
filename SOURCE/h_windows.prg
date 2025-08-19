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


// #define ALLOW_ONLY_ONE_MESSAGE_LOOP


/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "SET_COMPILE_HMG_UNICODE.ch"

#include "SETCompileBrowse.ch"

#include "hmg.ch"
#include "common.ch"
#include "error.ch"

MEMVAR _HMG_SYSDATA
//MEMVAR _HMG_StopControlEventProcedure
MEMVAR _HMG_AvoidReentryEventProcedure
MEMVAR _HMG_SetControlContextMenu
MEMVAR _HMG_MsgIDFindDlg
MEMVAR _HMG_FindReplaceOnAction

MEMVAR _HMG_CharRange_Min
MEMVAR _HMG_CharRange_Max

//#define WM_GETFONT 49   // ok

//#define WM_MENUCOMMAND    0x0126   // ok
//#define WM_MENUSELECT     287     // ok
//#define WM_MENURBUTTONUP  290     // ok
//#define WM_MENUGETOBJECT  0x0124   // ok

#define WM_NCCALCSIZE      131    // ok
#define EM_SETREADONLY     207    // ok
#define COLOR_MENU      4      // ok
#define WM_NCACTIVATE      134    // ok
//#define GWL_EXSTYLE       (-20)   // ok
#define CBN_CLOSEUP       8      // ok
#define CBN_DROPDOWN      7      // ok
#define WM_MOVE          3      // ok
#define WM_MOVING        534    // ok

//#define NM_FIRST         0      // ok
#define CDRF_DODEFAULT    0x00    // ok
#define CDDS_ITEMPOSTPAINT 65538  // ok
#define DL_BEGINDRAG        1157   // ok
#define DL_CANCELDRAG    1160    // ok
#define DL_DRAGGING      1158    // ok
#define DL_DROPPED       1159    // ok
#define DL_CURSORSET     0       // ok
#define DL_STOPCURSOR    1       // ok
#define DL_COPYCURSOR    2       // ok
#define DL_MOVECURSOR    3       // ok

#define DTM_FIRST      0x1000          //  ok
#define DTM_GETMONTHCAL (DTM_FIRST+8)     // ok
// #define DTM_GETMONTHCAL   0x1008  // ok  (MinGW)

// #define TTN_NEEDTEXT   (-520)  // only ANSI
#define TTN_FIRST          (-520)
#define TTN_GETDISPINFOA    (TTN_FIRST - 0)
#define TTN_GETDISPINFOW    (TTN_FIRST - 10)
#define TTN_NEEDTEXTA       TTN_GETDISPINFOA
#define TTN_NEEDTEXTW       TTN_GETDISPINFOW
#ifdef COMPILE_HMG_UNICODE
   #define TTN_NEEDTEXT TTN_NEEDTEXTW   // UNICODE ok
#else
   #define TTN_NEEDTEXT TTN_NEEDTEXTA   // ANSI ok
#endif

#define HOLLOW_BRUSH   5           // ok
#define DC_BRUSH      18          // ok
//#define NM_CUSTOMDRAW (NM_FIRST-12)  // ok

#define LVN_FIRST      (-100)        // ok
// #define LVN_BEGINDRAG   (LVN_FIRST-9)   // ok  (MinGW)
#define LVN_BEGINDRAG   (-109)    // ok

// #define WS_EX_TRANSPARENT   32    // ok
// #define WS_VISIBLE   0x10000000   // ok
// #define WS_GROUP     0x20000      // ok
// #define WS_CHILD   0x40000000     // ok

#define BS_AUTORADIOBUTTON   9    // ok
#define BS_NOTIFY   0x4000       // ok
//#define GWL_STYLE   (-16)       // ok
#define CBN_EDITCHANGE   5       // ok
#define SIZE_MAXHIDE   4         // ok
#define SIZE_MAXIMIZED   2        // ok
#define SIZEFULLSCREEN   2        // ok
#define SIZE_MAXSHOW     3       // ok
#define SIZE_MINIMIZED    1      // ok
#define SIZEICONIC       1      // ok
#define SIZE_RESTORED    0       // ok
#define SIZENORMAL      0       // ok
#define TBN_FIRST     (-700)    // ok
#define TBN_DROPDOWN    (TBN_FIRST-10)   // ok
#define WM_CTLCOLORLISTBOX  308     // ok
#define WM_CTLCOLORBTN   309       // ok
#define COLOR_WINDOW   5        // ok
#define COLOR_3DFACE   15       // ok
#define COLOR_BTNFACE  15       // ok
#define OPAQUE   2               // ok
#define DKGRAY_BRUSH   3          // ok

#define LVN_GETDISPINFOA   (LVN_FIRST-50)
#define LVN_GETDISPINFOW   (LVN_FIRST-77)
#ifdef COMPILE_HMG_UNICODE
   #define LVN_GETDISPINFO   LVN_GETDISPINFOW    // Unicode  ok
#else
   #define LVN_GETDISPINFO   LVN_GETDISPINFOA    // ANSI ok
#endif

#define LVN_BEGINSCROLL   (LVN_FIRST-80)
#define LVN_ENDSCROLL     (LVN_FIRST-81)

// #define WM_HOTKEY    786       // ok
#define WM_CTLCOLOREDIT   307   // ok
// #define WM_MOUSEWHEEL   522     // ok
// #define WM_MOUSEHOVER   0x2a1    // ok
#define EN_MSGFILTER    1792    // ok
#define DLGC_WANTCHARS   128    // ok
#define DLGC_WANTMESSAGE  4     // ok
#ifndef MCN_FIRST
   #define MCN_FIRST           -750  // ok
#endif
#define MCN_LAST            -759  // ok
#ifndef MCN_SELCHANGE
   #define MCN_SELCHANGE       (MCN_FIRST + 1) // ok
#endif
#ifndef MCN_SELECT
   #define MCN_SELECT          (MCN_FIRST + 4) // ok
#endif
// #define MCN_SELCHANGE  (-749)  // ok (MinGW)
// #define MCN_SELECT     (-746)  // ok (MinGW)

#define WM_HELP            83   // ok
#define STN_CLICKED         0    // ok
#define STN_DBLCLK          1    // ok
#define STN_ENABLE          2    // ok
#define STN_DISABLE         3    // ok

#define SB_HORZ            0    // ok
#define NM_CLICK           (-2)   // ok
// #define NM_CLICK      (NM_FIRST-2)   // ok (MinGW)
#define BS_DEFPUSHBUTTON     1    // ok
#define BM_SETSTYLE         244   // ok
#define SB_CTL             2     // ok
#define SB_VERT            1     // ok
#define SB_LINEUP           0    // ok
#define SB_LINEDOWN         1    // ok
#define SB_LINELEFT         0    // ok
#define SB_LINERIGHT        1    // ok
#define SB_PAGEUP          2    // ok
#define SB_PAGEDOWN         3   // ok
#define SB_PAGELEFT         2   // ok
#define SB_PAGERIGHT        3   // ok
#define SB_THUMBPOSITION     4   // ok
#define SB_THUMBTRACK       5   // ok
#define SB_ENDSCROLL        8   // ok
#define SB_LEFT            6   // ok
#define SB_RIGHT           7   // ok
#define SB_BOTTOM          7   // ok
#define SB_TOP            6   // ok

#define WM_VSCROLL             0x0115  // ok
// #define WM_VSCROLL    277   // ok (MinGW)

// TreeView Notify
#define TVN_FIRST             (-400)
#define TVN_SELCHANGEDA       (TVN_FIRST-2)
#define TVN_SELCHANGEDW       (TVN_FIRST-51)
#define TVN_ITEMEXPANDINGA    (TVN_FIRST-5)
#define TVN_ITEMEXPANDINGW    (TVN_FIRST-54)
#define TVN_ITEMEXPANDEDA     (TVN_FIRST-6)
#define TVN_ITEMEXPANDEDW     (TVN_FIRST-55)
#define TVN_GETDISPINFOA      (TVN_FIRST-3)
#define TVN_GETDISPINFOW      (TVN_FIRST-52)

#ifdef COMPILE_HMG_UNICODE
      #define TVN_SELCHANGED        TVN_SELCHANGEDW        // Unicode ok
      #define TVN_ITEMEXPANDING     TVN_ITEMEXPANDINGW
      #define TVN_ITEMEXPANDED      TVN_ITEMEXPANDEDW
      #define TVN_GETDISPINFO       TVN_GETDISPINFOW
#else
      #define TVN_SELCHANGED        TVN_SELCHANGEDA        // ANSI ok
      #define TVN_ITEMEXPANDING     TVN_ITEMEXPANDINGA
      #define TVN_ITEMEXPANDED      TVN_ITEMEXPANDEDA
      #define TVN_GETDISPINFO       TVN_GETDISPINFOA
#endif

#define TVE_COLLAPSE   1
#define TVE_EXPAND     2

//New define for TaskBar
#define WM_USER         0x0400    // ok
// #define WM_USER         1024  // ok (MinGW)

#define WM_TASKBAR      WM_USER+1043   // User define Message
#define ID_TASKBAR      0            // User define Message

// #define WM_NCMOUSEMOVE    160    // ok
// #define WM_MOUSEMOVE      512    // 0x0200      // ok
// #define WM_LBUTTONDOWN    513    // 0x0201      // ok
// #define WM_LBUTTONUP      514    // 0x0202      // ok
// #define WM_LBUTTONDBLCLK  515    // 0x203      // ok
// #define WM_RBUTTONDOWN    516    // 0x0204      // ok
// #define WM_RBUTTONUP      517    // 0x0205      // ok

#define WM_INITDIALOG     272   // ok
#define WM_ACTIVATEAPP    28    // ok
// #define TB_AUTOSIZE      (WM_USER+33)   // ok (MinGW)
#define TB_AUTOSIZE      1057   // ok
#define WM_EXITSIZEMOVE   562    // ok
#define WM_ENTERSIZEMOVE  561    // ok
#define WM_NEXTDLGCTL    40      // ok
#define WM_GETDLGCODE    135     // ok
#define TRANSPARENT   1       // ok
#define GRAY_BRUSH      2       // ok
#define NULL_BRUSH      5       // ok
#define WM_CTLCOLORSTATIC   312  // ok
#define WM_CTLCOLORDLG     310   // ok
#define BN_CLICKED        0     // ok
#define WM_VKEYTOITEM     46    // ok
#define LBN_KILLFOCUS     5     // ok
#define LBN_SETFOCUS      4     // ok
#define CBN_KILLFOCUS     4     // ok
#define CBN_SETFOCUS      3     // ok
#define BN_KILLFOCUS      7     // ok
#define BN_SETFOCUS       6     // ok

// #define NM_SETFOCUS  (NM_FIRST-7)   // ok (MinGW)
// #define NM_KILLFOCUS (NM_FIRST-8)   // ok (MinGW)
#define NM_SETFOCUS     (-7)   // ok
#define NM_KILLFOCUS       (-8)   // ok

// #define LVN_KEYDOWN       (LVN_FIRST-55)   // ok  (MinGW)
// #define LVN_COLUMNCLICK   (LVN_FIRST-8)    // ok  (MinGW)
#define LVN_KEYDOWN     (-155)  // ok
#define LVN_COLUMNCLICK  (-108)  // ok

// #define NM_DBLCLK (NM_FIRST-3)   // ok  (MinGW)
#define NM_DBLCLK       (-3)    // ok

#define LBN_DBLCLK       2     // ok

 #define TCN_FIRST   (-550)
// #define TCN_SELCHANGE    (TCN_FIRST-1)   // ok (MinGW)
// #define TCN_SELCHANGING  (TCN_FIRST-2)   // ok (MinGW)
#define TCN_SELCHANGE    (-551)  // ok
#define TCN_SELCHANGING  (-552)  // ok

#define DTN_FIRST       (-760)  // ok
#define DTN_DATETIMECHANGE (DTN_FIRST+1)  // ok
#define DTN_CLOSEUP    (DTN_FIRST+7)
// #define DTN_DATETIMECHANGE (-759)   //  ok (MinGW)
// #define DTN_CLOSEUP        (-753)   //  ok (MinGW)

#define TB_ENDTRACK      8    //  ok
#define WM_HSCROLL       276  //  ok
#define CBN_SELCHANGE    1     //  ok

// #define LVN_ITEMCHANGED   (LVN_FIRST-1)   // ok (MinGW)
#define LVN_ITEMCHANGED  (-101)  //  ok

#define LBN_SELCHANGE    1     // ok
//#define WM_PAINT        15    // ok
//#define WM_ERASEBKGND    20    // ok
//#define WM_DRAWITEM      43    // ok
#define WM_SHOWWINDOW    24    // ok
#define EN_SETFOCUS     256    // ok
#define EN_KILLFOCUS    512    // ok
#define WM_SETFOCUS     7     //  ok
#define WM_KILLFOCUS    8     //  ok
#define WM_UNDO        772   //  ok
#define EM_SETMODIFY    185   //  ok
#define WM_PASTE       770   //  ok
#define EM_GETLINE     196    //  ok
#define EM_SETSEL      177    //  ok
#define WM_CLEAR       771   //  ok
#define EM_GETSEL      176   //  ok
#define EM_UNDO       199    //  ok
#define EN_CHANGE      768   //  ok
#define EN_UPDATE      1024  //  ok
#define WM_ACTIVATE    6     //   ok
#define WM_SIZING     532    //  ok
// #define MK_LBUTTON    1     // ok (i_keybd.ch)
#define WM_CONTEXTMENU 123   // ok
#define WM_TIMER      275   // ok
#define WM_SIZE       5     // ok

// #define TBM_SETPOS   (WM_USER+5)   //  ok  (MinGW)
// #define TBM_GETPOS   (WM_USER)     //  ok  (MinGW)
// #define PBM_SETPOS   (WM_USER+2)   //  ok  (MinGW)
#define TBM_SETPOS    1029  // ok
#define TBM_GETPOS    1024  // ok
#define PBM_SETPOS    1026  // ok

//#define WM_SYSCOMMAND  274     //  ok

// #define SC_CLOSE 0xF060    // ok  (MinGW)
//#define SC_CLOSE      61536     // ok

#define WM_CLOSE      16    //  ok  (MinGW)
// #define WM_COMMAND    273   //  ok  (MinGW)
// #define WM_DESTROY    2     //  ok  (MinGW)

// #define WM_CLOSE        0x0010    //  ok
#define WM_COMMAND      0x0111    //  ok
#define WM_DESTROY      0x0002    //  ok

//#define WM_NOTIFY      78   //  ok
#define WM_CREATE      1    //  ok
#define WM_QUIT        18   //  ok

#define TTM_SETTIPBKCOLOR    (WM_USER + 19)   // ok
#define TTM_SETTIPTEXTCOLOR  (WM_USER + 20)   // ok

#define LVM_FIRST           0x1000         // ok
#define LVM_GETTOPINDEX      (LVM_FIRST+39)   // ok
#define LVM_GETCOUNTPERPAGE   (LVM_FIRST+40)   // ok
#define NM_RCLICK           (NM_FIRST-5)     // ok

#define EN_SELCHANGE   1794   // ok
#define EN_LINK        1803   // ok
#define EN_VSCROLL     1538   // ok

#define CBN_SELENDCANCEL 10   // ok

//#include "hmg.ch"
//#include "common.ch"
//#include "error.ch"

MEMVAR mVar

FUNCTION Events ( hWnd, nMsg, wParam, lParam )

   LOCAL i,j,z,x,lvc, aPos , maskstart , xs , xd , ts , nr, xTmp
   LOCAL k
   LOCAL ControlCount , RecordCount , SkipCount , BackRec , BackArea , BrowseArea , NextControlHandle , NewPos , NewHPos , NewVPos , _ThisQueryTemp , r
   LOCAL hwm := .F.
   LOCAL hws
   LOCAL mVar
   LOCAL DeltaSelect
   LOCAL TmpStr
   LOCAL Tmp
   LOCAL xRetVal
   LOCAL aCellData
   LOCAL aTemp
   LOCAL a
   LOCAL MaxBrowseRows
   LOCAL MaxBrowseCols
   LOCAL aTemp2
   LOCAL aSize
   // LOCAL MaxGridRows
   // LOCAL MaxGridCols
   LOCAL cProc
   LOCAL dlnc
   LOCAL _GridInitValue
   // LOCAL _GridInitValue2
   LOCAL cTemp
   LOCAL xTemp
   LOCAL oForm

   LOCAL nDestinationColumn
   LOCAL nFrozenColumnCount
   LOCAL anOriginalColumnWidths
   // LOCAL anCurrentColumnWidths

   // ADD
   LOCAL _HMG_ControlHandle, _HMG_MouseRow, _HMG_MouseCol, _HMG_ControlContextMenu
   LOCAL aux_hWnd, nIndex, _HMG_ret
   LOCAL hFont := 0, oControlI
   LOCAL oFormI, oFormX, oFormZ

/*
   // Dr. Claudio Soto (June 2013)

   SetNewBehaviorWndProc (.T.)
   r := EventProcess (hWnd, nMsg, wParam, lParam, .F., .F., .T., (WH_MIN -1), -1)

   IF ValType (r) == "N"
      Return r
   ENDIF
   SetNewBehaviorWndProc (.F.)
   // ret <> Num   --> execution continues normally in the function EVENTS(), not returns to CALLBACK WndProc()
   // ret == -1    --> returns to CALLBACK WndProc() and executes DefWindowProc(Default Window Procedure)
   // ret <> -1    --> returns to CALLBACK WndProc() and NOT executes DefWindowProc(), the application is responsible for fully process the event

*/

   SetNewBehaviorWndProc (.F.)   // ADD2, December 2014

   FOR i := 1 To HMG_LEN ( oHmgApp():APP060 )
      cProc := oHmgApp():APP060 [ i ]  // Custom Event Procedures Array
      r := &cProc ( hWnd , nMsg , wParam , lParam )
      IF ValType ( r ) == 'N'
         RETURN r
      ENDIF
   NEXT
   // ret <> Num   --> execution continues normally in the function EVENTS(), not returns to CALLBACK WndProc()
   // ret == 0     --> returns to CALLBACK WndProc() and executes DefWindowProc(Default Window Procedure)
   // ret <> 0     --> returns to CALLBACK WndProc() and NOT executes DefWindowProc(), the application is responsible for fully process the event

   DO CASE

        **********************************************************************************************************
   CASE nMsg == _HMG_MsgIDFindDlg   // FindReplace Dialog Notification   ( by Dr. Claudio Soto, January 2014 )
        **********************************************************************************************************
         oHmgApp():APP503 := FindReplaceDlgGetOptions (lParam)

         EVAL ( _HMG_FindReplaceOnAction )

         IF oHmgApp():APP503 [ 1 ] == 0   // User CANCEL or CLOSE Dialog
            FindReplaceDlgRelease ( .T. )      // Destroy Dialog Window and Set NULL Dialog Handle
         ENDIF

         AFILL ( oHmgApp():APP503, NIL )

        ***********************************************************************
   CASE nMsg == oHmgApp():APP054 //Drag ListBox Notification
        ***********************************************************************

      dlnc := GET_DRAG_LIST_NOTIFICATION_CODE(lParam)

      IF dlnc == DL_BEGINDRAG

         * Original Item
         oHmgApp():APP053 := GET_DRAG_LIST_DRAGITEM(lParam)
         RETURN 1

      ELSEIF dlnc == DL_DRAGGING

         * Current Item
         oHmgApp():APP052 := GET_DRAG_LIST_DRAGITEM(lParam)


         IF oHmgApp():APP052 > oHmgApp():APP053

            DRAG_LIST_DRAWINSERT(hWnd,lParam,oHmgApp():APP052 + 1 )

         ELSE

            DRAG_LIST_DRAWINSERT(hWnd,lParam,oHmgApp():APP052 )

         ENDIF

         IF oHmgApp():APP052 <> -1

            IF oHmgApp():APP052 > oHmgApp():APP053
               DRAG_LIST_SETCURSOR_DOWN()
            ELSE
               DRAG_LIST_SETCURSOR_UP()
            ENDIF

            RETURN 0

         ENDIF

         RETURN DL_STOPCURSOR

      ELSEIF dlnc == DL_CANCELDRAG
         oHmgApp():APP053 := -1

      ELSEIF dlnc == DL_DROPPED

         oHmgApp():APP052 := GET_DRAG_LIST_DRAGITEM(lParam)

         IF oHmgApp():APP052 <> -1

            DRAG_LIST_MOVE_ITEMS(lParam,oHmgApp():APP053,oHmgApp():APP052)

         ENDIF

         DRAG_LIST_DRAWINSERT(hWnd,lParam, -1 )

         oHmgApp():APP053 := -1

      ENDIF

        ***********************************************************************
   CASE nMsg == WM_CTLCOLORSTATIC
        ***********************************************************************

      oControlI := ControlByHandle( lParam )
      I := iif( oControlI == Nil, 0, oControlI:Index )

      IF i > 0

         IF ControlByIndex( i ):Type ==  'EDIT' .OR. ControlByIndex( i ):Type == 'TEXT' .OR. ControlByIndex( i ):Type ==  'NUMTEXT' .OR. ControlByIndex( i ):Type ==  'MASKEDTEXT' .OR. ControlByIndex( i ):Type ==  'CHARMASKTEXT'


            IF ControlByIndex( I ):CTRL040 [ 10 ] != Nil
               SetTextColor( wParam,ControlByIndex( I ):CTRL040 [ 10 ] [1], ControlByIndex( I ):CTRL040 [ 10 ] [2] , ControlByIndex( I ):CTRL040 [ 10 ] [3] )
            ENDIF

            IF ControlByIndex( I ):CTRL040 [ 9 ] != Nil
               SetBkColor( wParam,ControlByIndex( I ):CTRL040 [ 9 ] [1] ,ControlByIndex( I ):CTRL040 [ 9 ] [2] ,ControlByIndex( I ):CTRL040 [ 9 ] [3] )
               DeleteObject ( ControlByIndex( I ):CTRL037 )
               ControlByIndex( I ):CTRL037 := CreateSolidBrush( ControlByIndex( I ):CTRL040 [ 9 ] [1] ,ControlByIndex( I ):CTRL040 [ 9 ] [2] ,ControlByIndex( I ):CTRL040 [ 9 ] [3] )
               return ( ControlByIndex( I ):CTRL037 )
            ELSE

               DeleteObject ( ControlByIndex( I ):CTRL037 )
               ControlByIndex( I ):CTRL037 := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_MENU ) ) , GetGreen ( GetSysColor ( COLOR_MENU ) ) , GetBlue ( GetSysColor ( COLOR_MENU ) ) )
               SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_MENU ) ) , GetGreen ( GetSysColor ( COLOR_MENU) ) , GetBlue ( GetSysColor ( COLOR_MENU ) ) )
               return ( ControlByIndex( I ):CTRL037 )

            ENDIF

         ENDIF

         IF ControlByIndex( i ):Type ==  "LABEL"  .Or. ControlByIndex( i ):Type == "CHECKBOX" .Or. ControlByIndex( i ):Type == "FRAME" .Or. ControlByIndex( i ):Type == "SLIDER"

           IF ( IsAppThemed() ) .AND. ControlByIndex( i ):Type == "SLIDER" .and. ControlByIndex( I ):CTRL023 <> -1 .and. ControlByIndex( I ):CTRL024 <> -1 .AND. ControlByIndex( I ):CTRL014 == Nil
               IF ControlByIndex( I ):CTRL016 == .F.
                  DeleteObject ( ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL036,ControlByIndex( I ):CTRL037) ):CTRL039 )
                  ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL036,ControlByIndex( I ):CTRL037) ):CTRL039 := _GetTabBrush( GetControlHandle(ControlByIndex( I ):CTRL036,ControlByIndex( I ):CTRL037) )
                  Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (ControlByIndex( I ):CTRL036,ControlByIndex( I ):CTRL037) , ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL036,ControlByIndex( I ):CTRL037) ):CTRL039 )
               ENDIF
            ENDIF

           IF ( IsAppThemed() ) .AND. ControlByIndex( i ):Type == "FRAME" .and. ControlByIndex( I ):CTRL023 <> -1 .and. ControlByIndex( I ):CTRL024 <> -1  .AND. ControlByIndex( I ):CTRL014 == Nil
               IF ControlByIndex( I ):CTRL016 == .F.
                  DeleteObject ( ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) ):CTRL039 )
                  ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) ):CTRL039 := _GetTabBrush( GetControlHandle(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) )
                  Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) , ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) ):CTRL039 )
               ENDIF
            ENDIF

            IF ( IsAppThemed() ) .and. ControlByIndex( i ):Type == "CHECKBOX" .and. ControlByIndex( I ):CTRL023 <> -1 .and. ControlByIndex( I ):CTRL024 <> -1  .AND. ControlByIndex( I ):CTRL014 == Nil
               IF ControlByIndex( I ):CTRL016 == .F.
                  DeleteObject ( ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) ):CTRL039 )
                  ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) ):CTRL039 := _GetTabBrush( GetControlHandle(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) )
                  Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) , ControlByIndex( GetControlIndex(ControlByIndex( I ):CTRL031,ControlByIndex( I ):CTRL032) ):CTRL039 )
               ENDIF
            ENDIF

            If ControlByIndex( I ):CTRL015 != Nil
               SetTextColor( wParam,ControlByIndex( I ):CTRL015 [1], ControlByIndex( I ):CTRL015 [2] , ControlByIndex( I ):CTRL015 [3] )
            EndIf

            If ValType ( ControlByIndex( I ):CTRL009 ) == 'L'
               If ControlByIndex( I ):CTRL009 == .T.
                  SetBkMode( wParam , TRANSPARENT )
                  Return ( GetStockObject (NULL_BRUSH) )
               EndIf
            EndIf

            If ControlByIndex( I ):CTRL014 != Nil

               SetBkColor( wParam,ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
               DeleteObject ( ControlByIndex( I ):CTRL037 )
               ControlByIndex( I ):CTRL037 := CreateSolidBrush( ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
               return ( ControlByIndex( I ):CTRL037 )

            Else

               DeleteObject ( ControlByIndex( I ):CTRL037 )
               ControlByIndex( I ):CTRL037 := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
               SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
               return ( ControlByIndex( I ):CTRL037 )

            EndIf

         EndIf

      Else

         For i := 1 To oHmgApp():ControlCount

            If ValType ( ControlByIndex( i ):Handle ) == 'A'

               If ControlByIndex( i ):Type == 'RADIOGROUP'

                  For x := 1 To HMG_LEN ( ControlByIndex( i ):Handle )

                          If ControlByIndex( i ):Handle [x] == lParam

                        If ControlByIndex( I ):CTRL015 != Nil
                           SetTextColor( wParam,ControlByIndex( I ):CTRL015 [1], ControlByIndex( I ):CTRL015 [2] , ControlByIndex( I ):CTRL015 [3] )
                        EndIf

                     // if ( IsAppThemed() ) .and. ControlByIndex( I ):CTRL023 <> -1 .and. ControlByIndex( I ):CTRL024 <> -1   // Bug: set background color in RADIOGROUP when defined in the TAB control
                        if ( IsAppThemed() ) .and. ControlByIndex( I ):CTRL023 <> -1 .and. ControlByIndex( I ):CTRL024 <> -1  .AND. ControlByIndex( I ):CTRL014 == Nil
                           if ControlByIndex( I ):CTRL016 == .F.
                              DeleteObject ( ControlByIndex( GetControlIndex( ControlByIndex( I ):CTRL031, ControlByIndex( I ):CTRL032 ) ):CTRL039 )
                              ControlByIndex( GetControlIndex( ControlByIndex( I ):CTRL031, ControlByIndex( I ):CTRL032 ) ):CTRL039 := _GetTabBrush( GetControlHandle( ControlByIndex( I ):CTRL031, ControlByIndex( I ):CTRL032) )
                              Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle ( ControlByIndex( I ):CTRL031, ControlByIndex( I ):CTRL032 ) , ControlByIndex( GetControlIndex( ControlByIndex( I ):CTRL031, ControlByIndex( i ):CTRL032 ) ):CTRL039 )
                           endif
                        endif

                        If ValType ( ControlByIndex( I ):CTRL009 ) == 'L'
                           If ControlByIndex( I ):CTRL009 == .T.
                              SetBkMode( wParam , TRANSPARENT )
                              Return(GetStockObject( NULL_BRUSH ) )
                           EndIf
                        EndIf

                        If ControlByIndex( I ):CTRL014 != Nil
                           SetBkColor( wParam,ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
                           if x == 1
                              DeleteObject ( ControlByIndex( I ):CTRL037 )
                              ControlByIndex( I ):CTRL037 := CreateSolidBrush( ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
                           EndIf
                           return ( ControlByIndex( I ):CTRL037 )
                        Else
                           if x == 1
                              DeleteObject ( ControlByIndex( I ):CTRL037 )
                              ControlByIndex( I ):CTRL037 := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
                           EndIf
                           SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
                           return ( ControlByIndex( I ):CTRL037 )
                        EndIf

                     EndIf

                  Next x

               EndIf

            EndIf

         Next i

      EndIf

        ***********************************************************************
   case nMsg == WM_CTLCOLOREDIT .Or. nMsg == WM_CTLCOLORLISTBOX
        ***********************************************************************

      oControlI := ControlByHandle( lParam )
      I := iif( oControlI == Nil, 0, oControlI:Index )

      if i > 0

         If ControlByIndex( i ):Type ==  "NUMTEXT" .or. ControlByIndex( i ):Type == "TEXT" .or. ControlByIndex( i ):Type == "MASKEDTEXT" .or. ControlByIndex( i ):Type == "CHARMASKTEXT"  .or. ControlByIndex( i ):Type == "EDIT" .or. ControlByIndex( i ):Type == "LIST"  .or. ControlByIndex( i ):Type == "MULTILIST"

            If ControlByIndex( I ):CTRL015 != Nil
               SetTextColor( wParam,ControlByIndex( I ):CTRL015 [1], ControlByIndex( I ):CTRL015 [2] , ControlByIndex( I ):CTRL015 [3] )
            EndIf

            If ControlByIndex( I ):CTRL014 != Nil
               SetBkColor( wParam,ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
               DeleteObject ( ControlByIndex( I ):CTRL037 )
               ControlByIndex( I ):CTRL037 := CreateSolidBrush( ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
               return ( ControlByIndex( I ):CTRL037 )
            Else

               DeleteObject ( ControlByIndex( I ):CTRL037 )
               ControlByIndex( I ):CTRL037 := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
               SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
               return ( ControlByIndex( I ):CTRL037 )

            EndIf

         EndIf

      Else

         For i := 1 To oHmgApp():ControlCount

            If ValType ( ControlByIndex( i ):Handle ) == 'A'

               If ControlByIndex( i ):Type == 'SPINNER'

                       If ControlByIndex( i ):Handle [1] == lParam

                     If ControlByIndex( I ):CTRL015 != Nil
                        SetTextColor( wParam,ControlByIndex( I ):CTRL015 [1], ControlByIndex( I ):CTRL015 [2] , ControlByIndex( I ):CTRL015 [3] )
                     EndIf

                     If ControlByIndex( I ):CTRL014 != Nil
                        SetBkColor( wParam,ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
                        DeleteObject ( ControlByIndex( I ):CTRL037 )
                        ControlByIndex( I ):CTRL037 := CreateSolidBrush( ControlByIndex( I ):CTRL014 [1] ,ControlByIndex( I ):CTRL014 [2] ,ControlByIndex( I ):CTRL014 [3] )
                        return ( ControlByIndex( I ):CTRL037 )
                     Else
                                                             DeleteObject ( ControlByIndex( I ):CTRL037 )
                        ControlByIndex( I ):CTRL037 := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
                        SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
                        return ( ControlByIndex( I ):CTRL037 )
                                                          EndIf

                  EndIf

               EndIf

            EndIf

         Next i

      EndIf

        ***********************************************************************
   case nMsg == WM_HOTKEY
        ***********************************************************************

      * Process HotKeys

      xTmp := ControlByBlock( { | e | E:CTRL005 == wParam } )
      i := iif( xTmp ==Nil, 0, xTmp:Index )

      If i > 0

         If ControlByIndex( i ):Type = "HOTKEY" .And. ControlByIndex( I ):ParentFormHandle == GetActiveWindow()

            if hiword(lParam) == 27 .and. loword(lParam) == 0

               _HMG_CLOSEMENU( ControlByIndex( I ):ParentFormHandle )

               DO EVENTS

            endif

            If _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )

               Return 0

            EndIf

         EndIf

      EndIf

        ***********************************************************************
   case nMsg == WM_MOUSEWHEEL
        ***********************************************************************

      hwnd := 0

      oFormI := FormByHandle( GetFocus() )

      IF oFormI != Nil

         If oFormI:VirtualHeight > 0
            hwnd := oFormI:Handle
         EndIf

      Else

         oControlI := ControlByHandle( GetFocus() )
         I := iif( oControlI == Nil, 0, oControlI:Index )

         If i > 0

            oFormX := FormByHandle( ControlByIndex( i ):ParentFormHandle )

            if oFormX != Nil
               If oFormX:VirtualHeight > 0
                  hwnd := oFormX:Handle
                  i := oFormX:Index
               EndIf
            EndIf
         Else
            ControlCount := oHmgApp():ControlCount
            For i := 1 To ControlCount
               if ControlByIndex( i ):Type == 'RADIOGROUP'
                  x := ascan ( ControlByIndex( i ):Handle , GetFocus() )
                  If x > 0
                     oFormZ := FormByHandle( ControlByIndex( i ):ParentFormHandle )
                     if oFormZ != Nil
                        If oFormZ:VirtualHeight > 0
                           hwnd := oFormZ:Handle
                           i := oFormZ:Index // ***not used***
                           Exit
                        EndIf
                     EndIf
                  EndIf
               Endif
            Next i
         EndIf

      EndIf

      If hwnd != 0

         If HIWORD(wParam) == 120
            if GetScrollPos(hwnd,SB_VERT) < 25
               SendMessage ( hwnd , WM_VSCROLL , SB_TOP , 0 )
            Else
               SendMessage ( hwnd , WM_VSCROLL , SB_PAGEUP , 0 )
            endif
         Else
            if GetScrollPos(hwnd,SB_VERT) >= GetScrollRangeMax ( hwnd , SB_VERT ) - 10
               SendMessage ( hwnd , WM_VSCROLL , SB_BOTTOM , 0 )
            else
               SendMessage ( hwnd , WM_VSCROLL , SB_PAGEDOWN , 0 )
            endif
         EndIf

      EndIf

        ***********************************************************************
   case nMsg == WM_ACTIVATE
        ***********************************************************************

      if LoWord(wparam) == 0
         oFormI := FormByHandle( hWnd )
         I := iif( oFormI == Nil , 0, oFormI:Index )
         if i > 0

            ControlCount := oHmgApp():ControlCount()

            For x := 1 To ControlCount
               if ControlByIndex( x ):Type == 'HOTKEY'
                  ReleaseHotKey ( ControlByIndex( X ):ParentFormHandle , ControlByIndex( X ):CTRL005 )
               EndIf
            Next x

                 oFormI:FORM101 := GetFocus()

            _DoWindowEventProcedure ( FormByIndex( I ):FORM086 , i , 'WINDOW_LOSTFOCUS' )

         Endif

      Else

         oFormI := FormByHandle( hWnd )
         IF oFormI != Nil
            UpdateWIndow ( hWnd )
         ENDIF

      EndIf

        ***********************************************************************
   case nMsg == WM_SETFOCUS
        ***********************************************************************

      oFormI := FormByHandle( hWnd )
      I := iif( oFormI == Nil, 0, oFormI:Index )

      if i > 0

         If oFormI:IsActive == .T. .and. oFormI:Type != 'X'
            oHmgApp():ActiveWindowHandle := hWnd
         EndIf

         ControlCount := oHmgApp():ControlCount

         For x := 1 To ControlCount
            if ControlByIndex( x ):Type == 'HOTKEY'
               ReleaseHotKey ( ControlByIndex( X ):ParentFormHandle , ControlByIndex( X ):CTRL005 )
            EndIf
         Next x

         For x := 1 To ControlCount
            if ControlByIndex( x ):Type == 'HOTKEY'
               If ControlByIndex( X ):ParentFormHandle == hWnd
                  InitHotKey ( hWnd , ControlByIndex( X ):CTRL007 , ControlByIndex( X ):CTRL008 , ControlByIndex( X ):CTRL005 )
               EndIf
            EndIf
         Next x

         _DoWindowEventProcedure ( FormByIndex( I ):FORM085 , i , 'WINDOW_GOTFOCUS' )

         if ( oFormI:FORM101 != 0 , setfocus ( oFormI:FORM101 ) , Nil )

      Endif

        ***********************************************************************
   case nMsg == WM_HELP
        ***********************************************************************
/*
      oControlI := ControlByHandle( GetHelpData ( lParam ) )
      I := iif( oControlI == Nil, 0, oControlI:Index )

      if i > 0
         WinHelp ( hwnd , oHmgApp():APP217 , 1  , 2 , ControlByIndex( I ):CTRL035 )
      EndIf
*/

      oControlI := ControlByHandle( lParam )
      I := iif( oControlI == Nil, 0, oControlI:Index )

      if i > 0

      cTemp := oHmgApp():APP217
      xTemp := ControlByIndex( I ):CTRL035
      if HB_URIGHT ( ALLTRIM(HMG_UPPER(cTemp)) , 4 ) == '.CHM'
        _Execute( hwnd , "open" , "hh.exe" , cTemp + if( ValType( xTemp ) == 'C', '::/' + xTemp, '' ) , , SW_SHOW )   // ADD, Kevin march 2017
      else
        WinHelp ( hwnd , cTemp , 1  , 2 , xTemp )
      Endif

      EndIf

        ***********************************************************************
   case nMsg == WM_VSCROLL
        ***********************************************************************

      oFormI := FormByHandle( hWnd )
      I := iif( oFormI == Nil, 0, oFormI:Index )

      if i > 0

         * Vertical ScrollBar Processing

         if oFormI:VirtualHeight > 0 .And. lParam == 0

            If FormByIndex( I ):FORM087 > 0
               MsgHMGError("SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
            EndIf

            If LoWord(wParam) == SB_LINEDOWN

                    NewPos := GetScrollPos(hwnd,SB_VERT) + oHmgApp():APP345
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            ElseIf LoWord(wParam) == SB_LINEUP

                    NewPos := GetScrollPos(hwnd,SB_VERT) - oHmgApp():APP345
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            ElseIf LoWord(wParam) == SB_TOP

                    NewPos := 0
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            ElseIf LoWord(wParam) == SB_BOTTOM

                    NewPos := GetScrollRangeMax(hwnd,SB_VERT)
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            ElseIf LoWord(wParam) == SB_PAGEUP

                    NewPos := GetScrollPos(hwnd,SB_VERT) - oHmgApp():APP501
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            ElseIf LoWord(wParam) == SB_PAGEDOWN

                    NewPos := GetScrollPos(hwnd,SB_VERT) + oHmgApp():APP501
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            ElseIf LoWord(wParam) == SB_THUMBPOSITION

               NewPos := HIWORD(wParam)
               SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

            EndIf

            If FormByIndex( I ):VirtualWidth > 0
                    NewHPos := GetScrollPos ( hwnd , SB_HORZ )
            Else
                    NewHPos := 0
            EndIf

* Panel Window Repositioning ( by Dr. Claudio Soto, April 2014 )

If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINEDOWN .Or. LoWord(wParam) == SB_LINEUP .or. LoWord(wParam) == SB_PAGEUP .or. LoWord(wParam) == SB_PAGEDOWN  .or. LoWord(wParam) == SB_BOTTOM  .or. LoWord(wParam) == SB_TOP
   FOR EACH oFormX IN oHmgApp():AllForms()
      x := oFormX:Index
      IF ! oFormX:IsDeleted
         IF oFormX:Type == 'P' .AND. oFormX:ParentHandle == hWnd
            MoveWindow ( oFormX:Handle , oFormX:FORM504[1] - NewHPos , oFormX:FORM504[2] - NewPos , oFormX:FORM504[3], oFormX:FORM504[4], .T. )
            // RedrawWindow ( hWnd )
         ENDIF
      ENDIF
   NEXT
EndIf

            * Control Repositioning

            If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINEDOWN .Or. LoWord(wParam) == SB_LINEUP .or. LoWord(wParam) == SB_PAGEUP .or. LoWord(wParam) == SB_PAGEDOWN  .or. LoWord(wParam) == SB_BOTTOM  .or. LoWord(wParam) == SB_TOP

               For x := 1 To oHmgApp():ControlCount

                  If ControlByIndex( X ):ParentFormHandle == hwnd

                     If ControlByIndex( x ):Type == 'SPINNER'

                        MoveWindow ( ControlByIndex( x ):Handle [1]   , ControlByIndex( X ):CTRL019 - NewHPos            , ControlByIndex( X ):CTRL018 - NewPos , ControlByIndex( X ):CTRL020 - GetWindowWidth(ControlByIndex( x ):Handle [2] )+1   , ControlByIndex( X ):CTRL021 , .t. )
                        MoveWindow ( ControlByIndex( x ):Handle [2]   , ControlByIndex( X ):CTRL019 + ControlByIndex( X ):CTRL020 - GetWindowWidth(ControlByIndex( x ):Handle [2] ) - NewHPos , ControlByIndex( X ):CTRL018 - NewPos , GetWindowWidth(ControlByIndex( x ):Handle [2] )         , ControlByIndex( X ):CTRL021 , .t. )

                     #ifdef COMPILEBROWSE

                     ElseIf ControlByIndex( x ):Type == 'BROWSE'

                        MoveWindow ( ControlByIndex( x ):Handle    , ControlByIndex( X ):CTRL019 - NewHPos         , ControlByIndex( X ):CTRL018 - NewPos , ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH() , ControlByIndex( X ):CTRL021 , .t. )
                        MoveWindow ( ControlByIndex( X ):CTRL005    , ControlByIndex( X ):CTRL019 + ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH()  - NewHPos   , ControlByIndex( X ):CTRL018 - NewPos , GETVSCROLLBARWIDTH()          , GetWIndowHeight(ControlByIndex( X ):CTRL005) , .t. )
                        MoveWindow ( ControlByIndex( X ):CTRL039 [1]   , ControlByIndex( X ):CTRL019 + ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH()  - NewHPos   , ControlByIndex( X ):CTRL018 +ControlByIndex( X ):CTRL021 - GetHScrollBarHeight () - NewPos ,GetWindowWidth(ControlByIndex( X ):CTRL039[1])   , GetWindowHeight(ControlByIndex( X ):CTRL039[1])  , .t. )
                        ReDrawWindow ( ControlByIndex( x ):Handle )

                     #endif

                     ElseIf ControlByIndex( x ):Type == 'RADIOGROUP'


                        If ControlByIndex( X ):CTRL008 == .F.

                           For z := 1 To HMG_LEN (ControlByIndex( x ):Handle)
                              MoveWindow ( ControlByIndex( x ):Handle [z]   , ControlByIndex( X ):CTRL019 - NewHPos , ControlByIndex( X ):CTRL018 - NewPos + ( (z-1) * ControlByIndex( X ):CTRL022 ), ControlByIndex( X ):CTRL020    , ControlByIndex( X ):CTRL021 / HMG_LEN (ControlByIndex( x ):Handle) , .t. )
                           Next z

                        Else

                           For z := 1 To HMG_LEN (ControlByIndex( x ):Handle)
                              MoveWindow ( ControlByIndex( x ):Handle [z] , ControlByIndex( X ):CTRL019 - NewHPos + (z-1) * ControlByIndex( X ):CTRL022 , ControlByIndex( X ):CTRL018 - NewPos , ControlByIndex( X ):CTRL020 / HMG_LEN (ControlByIndex( x ):Handle)  , ControlByIndex( X ):CTRL021 , .t. )
                           Next z

                        EndIf

                     ElseIf ControlByIndex( x ):Type == 'TOOLBAR'

                        MsgHMGError("ToolBar's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )

                     ElseIf ControlByIndex( x ):Type == 'STATUSBAR'   // Dr. Claudio Soto (November 2013)
                        // No change

                     Else

                        MoveWindow ( ControlByIndex( x ):Handle , ControlByIndex( X ):CTRL019 - NewHPos , ControlByIndex( X ):CTRL018 - NewPos , ControlByIndex( X ):CTRL020    , ControlByIndex( X ):CTRL021 , .t. )

                     EndIf

                  EndIf
               Next x

               ReDrawWindow ( hwnd )

            EndIf

         EndIf

         If LoWord(wParam) == SB_LINEDOWN
            _DoWindowEventProcedure ( FormByIndex( I ):FORM095 , i , '' )
         ElseIf LoWord(wParam) == SB_LINEUP
            _DoWindowEventProcedure ( FormByIndex( I ):FORM094 , i , '' )
         ElseIf LoWord(wParam) == SB_THUMBPOSITION ;
            .or. ;
            LoWord(wParam) == SB_PAGEUP ;
            .or. ;
            LoWord(wParam) == SB_PAGEDOWN ;
            .or. ;
            LoWord(wParam) == SB_TOP ;
            .or. ;
            LoWord(wParam) == SB_BOTTOM

            _DoWindowEventProcedure ( ControlByIndex( I ):FORM099 , i , '' )

         EndIf

      EndIf

      xTmp := ControlByBlock( { | e | E:CTRL005 == wParam } )
      i := iif( xTmp ==Nil, 0, xTmp:Index )

      if i > 0

         #ifdef COMPILEBROWSE

         if ControlByIndex( i ):Type == 'BROWSE'

            If LoWord(wParam) == SB_LINEDOWN

               setfocus( ControlByIndex( i ):Handle )
               InsertDown()

            EndIf

            If LoWord(wParam) == SB_LINEUP

               setfocus( ControlByIndex( i ):Handle )
               InsertUp()

            EndIf

            If LoWord(wParam) == SB_PAGEUP
               setfocus( ControlByIndex( i ):Handle )
               InsertPrior()
            EndIf

            If LoWord(wParam) == SB_PAGEDOWN
               setfocus( ControlByIndex( i ):Handle )
               InsertNext()
            EndIf

            If LoWord(wParam) == SB_THUMBPOSITION

               BackArea := Alias()
               BrowseArea := ControlByIndex( I ):CTRL022

               If Select (BrowseArea) != 0

                  Select &BrowseArea
                  BackRec := RecNo()

                  If OrdKeyCount() > 0
                     RecordCount := OrdKeyCount()
                  Else
                     RecordCount := RecCount()
                  EndIf

                  SkipCount := Int ( HIWORD(wParam) * RecordCount / GetScrollRangeMax ( ControlByIndex( I ):CTRL005 , 2 ) )

                  If SkipCount > ( RecordCount / 2 )
                               Go Bottom
                          Skip - ( RecordCount - SkipCount )
                  Else
                     Go Top
                          Skip SkipCount
                  EndIf

                  If Eof()
                     Skip -1
                  EndIf

                  nr := RecNo()

                  SetScrollPos ( ControlByIndex( I ):CTRL005 , 2 , HIWORD(wParam) , .t. )

                  Go BackRec

                  If Select (BackArea) != 0
                     Select &BackArea
                  Else
                     Select 0
                  EndIf

                  _BrowseSetValue ( '' , '' , nr , i )

               EndIf

            EndIf

         EndIf

         #endif

      EndIf

      oControlI := ControlByHandle( lParam )
      i := iif( oControlI == Nil, 0, oControlI:Index )
      if ( i > 0 )
         If LoWord (wParam) == TB_ENDTRACK
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
         EndIf
      EndIf

        ***********************************************************************
   case nMsg == WM_TASKBAR
        ***********************************************************************

      If wParam == ID_TASKBAR .and. lParam # WM_MOUSEMOVE
         aPos := GETCURSORPOS()

         do case

            case lParam == WM_LBUTTONDOWN

               oFormI := FormByHandle( hWnd )
               IF oFormI != Nil
                  _DoWindowEventProcedure ( oFormI:FORM084 , oFormI:Index , "TASKBAR" )   //  ADD, November 2016
               Endif

            case lParam == WM_RBUTTONDOWN

               if oHmgApp():APP338 == .t.

                  oFormI := FormByHandle( hWnd )
                  IF oFormI != Nil
                     if oFormI:FORM088 != 0
                        TrackPopupMenu ( oFormI:FORM088  , aPos[2] , aPos[1] , hWnd )
                     Endif
                  Endif

               EndIf

         endcase
      EndIf

        ***********************************************************************
   case nMsg == WM_NEXTDLGCTL
        ***********************************************************************
#if 0

      If Wparam == 0
         NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .F. )
      else
         NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .T. )
      endif

#else   // by Dr. Claudio Soto, march 2017

   IF LOWORD( lParam ) <> 0   // if LOWORD( lParam ) == .T.

      NextControlHandle = wParam   // wParam identifies the handle of the control that receives the focus

   ELSE                       // if LOWORD( lParam ) == .F.

      If wParam == 0
         NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .F. )   // next control with the WS_TABSTOP style receives the focus
      else
         NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .T. )   // previous control with the WS_TABSTOP style receives the focus
      endif

   ENDIF

#endif

      setfocus( NextControlHandle )

      oControlI := ControlByHandle( NextControlHandle )
      i := iif( oControlI == Nil, 0, oControlI:Index )

      if i > 0
         If ControlByIndex( i ):Type == 'BUTTON'
            SendMessage ( NextControlHandle , BM_SETSTYLE , LOWORD ( BS_DEFPUSHBUTTON ) , 1 )
         ElseIf ControlByIndex( i ):Type == 'EDIT' .OR. ControlByIndex( i ):Type == 'TEXT'
                  SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , 0 , -1 )
         endif
      EndIf

      Return 0

        ***********************************************************************
   case nMsg == WM_HSCROLL
        ***********************************************************************

      oFormI := FormByHandle( hWnd )
      i := iif( oFormI == Nil, 0, oFormI:Index )

      if i > 0

         * Horizontal ScrollBar Processing

         if FormByIndex( I ):VirtualWidth > 0 .And. lParam == 0

            If oFormI:FORM087 > 0
               MsgHMGError("SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
            EndIf

            If LoWord(wParam) == SB_LINERIGHT

                    NewHPos := GetScrollPos(hwnd,SB_HORZ) + oHmgApp():APP345
               SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

            ElseIf LoWord(wParam) == SB_LINELEFT

                    NewHPos := GetScrollPos(hwnd,SB_HORZ) - oHmgApp():APP345
               SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

            ElseIf LoWord(wParam) == SB_PAGELEFT

                    NewHPos := GetScrollPos(hwnd,SB_HORZ) - oHmgApp():APP501
               SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

            ElseIf LoWord(wParam) == SB_PAGERIGHT

                    NewHPos := GetScrollPos(hwnd,SB_HORZ) + oHmgApp():APP501
               SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

            ElseIf LoWord(wParam) == SB_THUMBPOSITION

               NewHPos := HIWORD(wParam)
               SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

            EndIf

            If FormByIndex( i ):VirtualHeight > 0
                    NewVPos := GetScrollPos ( hwnd , SB_VERT )
            Else
                    NewVPos := 0
            EndIf

* Panel Window Repositioning ( by Dr. Claudio Soto, April 2014 )

If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINELEFT .Or. LoWord(wParam) == SB_LINERIGHT .OR. LoWord(wParam) == SB_PAGELEFT   .OR. LoWord(wParam) == SB_PAGERIGHT
   FOR x := 1 To oHmgApp():FormCount
      oForm := FormByIndex( x )
      IF ! oForm:IsDeleted
         IF oForm:Type == 'P' .AND. oForm:Handle == hWnd
            MoveWindow ( oForm:Handle, oForm:FORM504[1] - NewHPos , oForm:FORM504[2] - NewVPos , oForm:FORM504[3], oForm:FORM504[4], .T. )
            // RedrawWindow ( hWnd )
         ENDIF
      ENDIF
   NEXT
EndIf

            * Control Repositioning

            If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINELEFT .Or. LoWord(wParam) == SB_LINERIGHT .OR. LoWord(wParam) == SB_PAGELEFT   .OR. LoWord(wParam) == SB_PAGERIGHT

               For x := 1 To oHmgApp():ControlCount

                  If ControlByIndex( X ):ParentFormHandle == hwnd

                     If ControlByIndex( x ):Type == 'SPINNER'

                        MoveWindow ( ControlByIndex( x ):Handle [1]   , ControlByIndex( X ):CTRL019 - NewHPos            , ControlByIndex( X ):CTRL018 - NewVPos , ControlByIndex( X ):CTRL020 - GetWindowWidth(ControlByIndex( x ):Handle [2] )+1   , ControlByIndex( X ):CTRL021 , .t. )
                        MoveWindow ( ControlByIndex( x ):Handle [2]   , ControlByIndex( X ):CTRL019 + ControlByIndex( X ):CTRL020 - GetWindowWidth(ControlByIndex( x ):Handle [2] ) - NewHPos   , ControlByIndex( X ):CTRL018 - NewVPos , GetWindowWidth(ControlByIndex( x ):Handle [2] ) , ControlByIndex( X ):CTRL021 , .t. )

                     #ifdef COMPILEBROWSE

                     ElseIf ControlByIndex( x ):Type == 'BROWSE'

                        MoveWindow ( ControlByIndex( x ):Handle    , ControlByIndex( X ):CTRL019 - NewHPos            , ControlByIndex( X ):CTRL018 - NewVPos , ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH()   , ControlByIndex( X ):CTRL021 , .t. )
                        MoveWindow ( ControlByIndex( X ):CTRL005    , ControlByIndex( X ):CTRL019 + ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH() - NewHPos   , ControlByIndex( X ):CTRL018 - NewVPos , GetWindowWidth(ControlByIndex( X ):CTRL005)         , GetWindowHeight(ControlByIndex( X ):CTRL005) , .t. )
                        MoveWindow ( ControlByIndex( X ):CTRL039 [1]   , ControlByIndex( X ):CTRL019 + ControlByIndex( X ):CTRL020 - GETVSCROLLBARWIDTH() - NewHPos   , ControlByIndex( X ):CTRL018 +ControlByIndex( X ):CTRL021 - GethScrollBarHeight() - NewVPos , GetWindowWidth(ControlByIndex( X ):CTRL039 [1])         , GetWindowHeight (ControlByIndex( X ):CTRL039[1]) , .t. )
                        ReDrawWindow ( ControlByIndex( x ):Handle )

                     #endif

                     ElseIf ControlByIndex( x ):Type == 'RADIOGROUP'

                        If ControlByIndex( X ):CTRL008 == .F.

                           For z := 1 To HMG_LEN (ControlByIndex( x ):Handle)
                              MoveWindow ( ControlByIndex( x ):Handle [z]   , ControlByIndex( X ):CTRL019 - NewHPos , ControlByIndex( X ):CTRL018 - NewVPos + ( (z-1) * ControlByIndex( X ):CTRL022 ), ControlByIndex( X ):CTRL020    , ControlByIndex( X ):CTRL021 / HMG_LEN (ControlByIndex( x ):Handle) , .t. )
                           Next z

                        Else

                           For z := 1 To HMG_LEN (ControlByIndex( x ):Handle)
                              MoveWindow ( ControlByIndex( x ):Handle [z] , ControlByIndex( X ):CTRL019 - NewHPos + (z-1) * ControlByIndex( X ):CTRL022 , ControlByIndex( X ):CTRL018 - NewVPos , ControlByIndex( X ):CTRL020 / HMG_LEN (ControlByIndex( x ):Handle), ControlByIndex( X ):CTRL021 , .t. )
                           Next z

                        EndIf

                     ElseIf ControlByIndex( x ):Type == 'TOOLBAR'

                        MsgHMGError("ToolBar's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )


                     ElseIf ControlByIndex( x ):Type == 'STATUSBAR'   // Dr. Claudio Soto (November 2013)
                           // No change

                     Else

                        MoveWindow ( ControlByIndex( x ):Handle , ControlByIndex( X ):CTRL019 - NewHPos , ControlByIndex( X ):CTRL018 - NewVPos , ControlByIndex( X ):CTRL020 , ControlByIndex( X ):CTRL021 , .t. )

                     EndIf

                  EndIf
               Next x

               RedrawWindow ( hwnd )

            EndIf

         EndIf

         If LoWord(wParam) == SB_LINERIGHT

            _DoWindowEventProcedure ( FormByIndex( I ):FORM097 , i , '' )

         ElseIf LoWord(wParam) == SB_LINELEFT

            _DoWindowEventProcedure ( FormByIndex( I ):FORM096 , i , '' )

         ElseIf   LoWord(wParam) == SB_THUMBPOSITION ;
            .or. ;
            LoWord(wParam) == SB_PAGELEFT ;
            .or. ;
            LoWord(wParam) == SB_PAGERIGHT

            _DoWindowEventProcedure ( FormByIndex( I ):FORM098 , i , '' )

         EndIf

      EndIf

      oControlI := ControlByHandle( lParam )
      i := iif( oControlI == Nil, 0, oControlI:Index )
      if ( i > 0 )
         If LoWord (wParam) == TB_ENDTRACK
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
         EndIf
      EndIf

        ***********************************************************************
   case nMsg == WM_PAINT
        ***********************************************************************

        oFormI := FormByHandle( hWnd )
         IF oFormI != Nil
            _DoWindowEventProcedure ( oFormI:FORM080 , oFormI:Index , '' ) // _HMG_aFormPaintProcedure
            For x := 1 To HMG_LEN ( oFormI:GraphTasks )
               Eval ( oFormI:GraphTasks [x] )                    // _HMG_aFormGraphTasks
            Next x
         Endif

         FOR EACH oFormZ IN oHmgApp():AllForms()
            // _HMG_aFormDeleted_   _HMG_aFormType ---> X = SplitChildWindow
            If ! oFormZ:IsDeleted .AND. oFormZ:Type == 'X'
               _DoWindowEventProcedure ( oFormZ:FORM080 , oFormZ:Index , '' ) // _HMG_aFormPaintProcedure
               IF ValType ( oFormZ:GraphTasks ) == 'A'
                  For x := 1 To HMG_LEN ( oFormZ:GraphTasks )
                     Eval ( oFormZ:GraphTasks [x] )  // _HMG_aFormGraphTasks
                  Next x
               ENDIF
            EndIf
         Next z
         IF oFormI != Nil
            RepositionToolBar( oFormI:Index )
         ENDIF

         Return 0 //call DefWindowProc( hWnd, nMsg, wParam, lParam )


         ***********************************************************************
   case nMsg == WM_LBUTTONDOWN
        ***********************************************************************

      oHmgApp():MouseRow := HIWORD(lParam)
      oHmgApp():MouseCol := LOWORD(lParam)
      oHmgApp():MouseState := 1

      oFormI := FormByHandle( hWnd )

      IF oFormI != Nil

         IF oFormI:VirtualHeight > 0
            oHmgApp():MouseRow := oHmgApp():MouseRow + GetScrollPos(hwnd,SB_VERT)
         ENDIF

         IF oFormI:VirtualWidth > 0
            oHmgApp():MouseCol := oHmgApp():MouseCol + GetScrollPos(hwnd,SB_HORZ)
         ENDIF

         _DoWindowEventProcedure ( oFormI:FORM077 , oFormI:Index , '' )

      Endif

        ***********************************************************************
   case nMsg == WM_LBUTTONUP
        ***********************************************************************

      oHmgApp():MouseState := 0

        ***********************************************************************
   case nMsg == WM_NCMOUSEMOVE
        ***********************************************************************
      // Dr. Claudio Soto (June 2013)
      oFormI := FormByHandle( hWnd )
      IF oFormI != Nil
          oHmgApp():LastFormIndexWithCursor := oFormI:Index
      ENDIF

        ***********************************************************************
   case nMsg == WM_MOUSEMOVE
        ***********************************************************************

      oHmgApp():MouseRow := HIWORD(lParam)
      oHmgApp():MouseCol := LOWORD(lParam)

      oFormI := FormByHandle( hWnd )
      IF oFormI != Nil

         oHmgApp():LastFormIndexWithCursor := oFormI:Index

         IF oFormI:VirtualHeight > 0
            oHmgApp():MouseRow := oHmgApp():MouseRow + GetScrollPos(hwnd,SB_VERT)
         endif

         IF oFormI:VirtualWidth > 0
            oHmgApp():MouseCol := oHmgApp():MouseCol + GetScrollPos(hwnd,SB_HORZ)
         endif

         if wParam == MK_LBUTTON
            _DoWindowEventProcedure ( oFormI:FORM075 , oFormI:Index , "MOUSEMOVE" )
         Else
            _DoWindowEventProcedure ( oFormI:FORM078 , oFormI:Index , "MOUSEMOVE" )
         Endif

      endif

        ***********************************************************************
   case nMsg == WM_CONTEXTMENU
        ***********************************************************************

// Dr. Claudio Soto (May 2013)

   _HMG_ControlHandle := wParam
   _HMG_MouseRow  := HIWORD(lParam)
   _HMG_MouseCol  := LOWORD(lParam)
   _HMG_ControlContextMenu := 0
   i := 0

   IF _HMG_SetControlContextMenu == .T.
        FOR k = 1 TO oHmgApp():ControlCount
            IF (ControlByIndex( K ):Type == "MENU") .AND. (ControlByIndex( K ):CTRL012 == "CONTROL_MENU_ITEM") .AND. _TestControlHandle_ContextMenu (ControlByIndex( K ):CTRL018, _HMG_ControlHandle)
              _HMG_ControlContextMenu := ControlByIndex( K ):CTRL007
              i := k
              EXIT
            ENDIF
        NEXT

        IF i > 0
            SetFocus (_HMG_ControlHandle)
            TrackPopupMenu ( _HMG_ControlContextMenu , _HMG_MouseCol , _HMG_MouseRow , hWnd )
        ENDIF
   ENDIF

      if oHmgApp():APP338 == .t.

         oHmgApp():MouseRow := HIWORD(lParam)
         oHmgApp():MouseCol := LOWORD(lParam)

         setfocus(wParam)

         oFormI := FormByHandle( hWnd )
         IF oFormI != Nil
            if oFormI:FormContextMenuHandle != 0
               if oFormI:VirtualHeight > 0
                  oHmgApp():MouseRow := oHmgApp():MouseRow + GetScrollPos(hwnd,SB_VERT)
               endif
               if oFormI:VirtualWidth > 0
                  oHmgApp():MouseCol := oHmgApp():MouseCol + GetScrollPos(hwnd,SB_HORZ)
               endif
               TrackPopupMenu ( oFormI:FormContextMenuHandle  , LOWORD(lparam) , HIWORD(lparam) , hWnd )
            Endif
         EndIf

      EndIf


        ***********************************************************************
   case nMsg == WM_TIMER
        ***********************************************************************

      xTmp := ControlByBlock( { | e | E:CTRL005 == wParam } )
      i := iif( xTmp ==Nil, 0, xTmp:Index )

      if i > 0
         _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
      EndIf

        ***********************************************************************
   case nMsg == WM_SIZE
        ***********************************************************************

#if 0

// REMOVE3
/*
      xTmp := FormByHandle( hWnd )
      i := iif( xTmp == Nil, 0, xTmp:Index )

      if i > 0

         If oHmgApp():APP263 == .T.   // _HMG_MainActive

            If wParam == SIZE_MAXIMIZED

               _DoWindowEventProcedure ( FormByIndex( i ):FORM103 , i , '' )

            ElseIf wParam == SIZE_MINIMIZED

               _DoWindowEventProcedure ( FormByIndex( i ):FORM104 , i , '' )

            Else

               _DoWindowEventProcedure ( FormByIndex( I ):FORM076 , i , '' )

            EndIf

         EndIf

         If FormByIndex( I ):FORM087 > 0
            SizeRebar ( FormByIndex( I ):FORM087 )
            RedrawWindow  ( FormByIndex( I ):FORM087 )
         EndIf

      EndIf

      ControlCount := oHmgApp():ControlCount

      For i = 1 to ControlCount
         if ControlByIndex( i ):ParentFormHandle == hWnd   // ParentHandle
            if ControlByIndex( i ):Type == "STATUSBAR"
               MoveWindow( ControlByIndex( i ):Handle , 0 , 0 , 0 , 0 , .T. )
               SetStatusBarSize ( hWnd , ControlByIndex( i ):Handle , ControlByIndex( I ):CTRL020 )
               EXIT
            endif
        EndIf
      Next

      For i = 1 to ControlCount
         if ControlByIndex( i ):ParentFormHandle == hWnd   // ParentHandle
            if ControlByIndex( i ):Type == "TOOLBAR"
               SendMessage( ControlByIndex( i ):Handle , TB_AUTOSIZE , 0 , 0 )
            EndIf
         EndIf
      Next
*/
#else

      ControlCount := oHmgApp():ControlCount()

      For i = 1 to oHmgApp():ControlCount()
         oControlI := ControlByIndex( I )
         If oControlI:ParentFormHandle == hWnd   // ParentHandle

            If oControlI:Type == "TOOLBAR"
               SendMessage( oControlI:Handle , TB_AUTOSIZE , 0 , 0 )

            ElseIf oControlI:Type == "STATUSBAR"
               MoveWindow( oControlI:Handle , 0 , 0 , 0 , 0 , .T. )
               SetStatusBarSize ( hWnd , oControlI:Handle , ControlByIndex( I ):CTRL020 )
            EndIf

         EndIf
      Next

      oFormI := FormByHandle( hWnd )

      if oFormI != Nil

         If oFormI:FORM087 > 0
            SizeRebar ( oFormI:FORM087 )   // resize SplitBox
            RedrawWindow  ( oFormI:FORM087 )
         EndIf

         If oHmgApp():APP263 == .T.  .OR. ;   // _HMG_MainActive
            oFormI:IsActive == .T.      // _HMG_aFormActive

            If wParam == SIZE_MAXIMIZED
               _DoWindowEventProcedure ( oFormI:FORM103 , oFormI:Index , '' )   // On Maximize

            ElseIf wParam == SIZE_MINIMIZED
               _DoWindowEventProcedure ( oFormI:FORM104 , oFormI:Index , '' )   // On Minimize

            Else
               _DoWindowEventProcedure ( oFormI:FORM076 , oFormI:Index , '' )   // On Size

            EndIf

         EndIf

      EndIf

#endif

        ***********************************************************************
   case nMsg == WM_COMMAND
        ***********************************************************************

      ControlCount := oHmgApp():ControlCount

      *...............................................
      * Search Control From Received Id LoWord(wParam)
      *...............................................

      xTmp := ControlByBlock( { | e | e:CTRL005 = LoWord(wParam)  } )
      i := iif( xTmp == Nil, 0, xTmp:Index )

      If i > 0

         * Process Menus .......................................

         IF HiWord(wParam) == 0 .And. ControlByIndex( i ):Type = "MENU"
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            Return 0
         EndIf

         * Process ToolBar Buttons ............................

         If ControlByIndex( i ):Type = "TOOLBUTTON"
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            Return 0
         EndIf

      EndIf

      *..............................................
      * Search Control From Received Handle (lparam)
      *..............................................

      oControlI := ControlByHandle( lParam )
      i := iif( oControlI == Nil, 0, oControlI:Index )

      * If Handle Not Found, Look For Spinner

      if i == 0
         For x := 1 To ControlCount
                 If ValType (  ControlByIndex( X ):Handle ) == 'A'
               If ControlByIndex( X ):Handle [1] == lParam .and. ControlByIndex( x ):Type == 'SPINNER'
                  i := x
                  Exit
               EndIf
            EndIf
         Next x
      EndIf

      *................................
      * Process Command (Handle based)
      *................................

      if ( i > 0 )

         * Button Click ........................................

         If HIWORD(wParam) == BN_CLICKED .And. ControlByIndex( i ):Type = "BUTTON"

            SetFocus(ControlByIndex( i ):Handle)
            SendMessage ( ControlByIndex( i ):Handle , 244 , LOWORD ( 1 ) , 1 )

            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )

            Return 0
         EndIf

         * CheckBox Click ......................................

         If HIWORD(wParam) == BN_CLICKED .And. ControlByIndex( i ):Type = "CHECKBOX"
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
            Return 0
         EndIf

         * Label / HyperLink / Image Click .....................

         if HiWord ( wParam ) == STN_CLICKED .And. ( ControlByIndex( i ):Type = "LABEL"  .Or. ControlByIndex( i ):Type = "IMAGE" )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            Return 0
         endif

         * Process Richedit Area Change ........................ ( Dr. Claudio Soto, January 2014 )

         IF HiWord ( wParam ) == EN_VSCROLL .AND. ( ControlByIndex( i ):Type == "RICHEDIT" )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL032 , i )
            Return 0
         ENDIF


         * TextBox Change ......................................

         if HiWord ( wParam ) == EN_CHANGE

            If oHmgApp():APP253 == .T.
               oHmgApp():APP253 := .F.
            Else

               if HMG_LEN (ControlByIndex( I ):CTRL009 ) > 0

                  If ControlByIndex( i ):Type == 'MASKEDTEXT'


                     If ControlByIndex( I ):CTRL022 == .T.
                        ProcessCharmask ( i , .t. )
                     EndIf

                     _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                  ElseIf ControlByIndex( i ):Type == 'CHARMASKTEXT'

                     ProcessCharMask (i)

                     _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                  EndIf

               else

                  If ControlByIndex( i ):Type == 'NUMTEXT'
                     ProcessNumText ( i )
                  EndIf

                  _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

               endif

            EndIf

            Return 0

         EndIf

         * TextBox LostFocus ...................................

         If  HiWord(wParam) == EN_KILLFOCUS

            oHmgApp():APP243 := .T.

            If ControlByIndex( i ):Type == 'MASKEDTEXT'

               ControlByIndex( I ):CTRL022 := .F.

               IF "E" $ ControlByIndex( I ):CTRL007

                  Ts := GetWindowText ( ControlByIndex( i ):Handle )

                  If "." $ ControlByIndex( I ):CTRL007
                     Do Case
                        Case HB_UAT ( '.' , Ts ) >  HB_UAT ( ',' , Ts )
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle )  , i )  , ControlByIndex( I ):CTRL007 ) )
                        Case HB_UAT ( ',' , Ts ) > HB_UAT ( '.' , Ts )
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromTextSp ( GetWindowText ( ControlByIndex( i ):Handle )  , i )  , ControlByIndex( I ):CTRL007 ) )
                     EndCase
                  Else
                     Do Case
                        Case HB_UAT ( '.' , Ts ) !=  0
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromTextSp ( GetWindowText ( ControlByIndex( i ):Handle )  , i )  , ControlByIndex( I ):CTRL007 ) )
                        Case HB_UAT ( ',' , Ts )  != 0
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle )  , i )  , ControlByIndex( I ):CTRL007 ) )
                        OtherWise
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle )  , i )  , ControlByIndex( I ):CTRL007 ) )
                     EndCase
                  EndIf
               ELSE
                  SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , ControlByIndex( I ):CTRL007 ) )
               ENDIF

            Endif

            If ControlByIndex( i ):Type == 'CHARMASKTEXT'
               if valtype ( ControlByIndex( I ):CTRL017 ) == 'L'
                  if ControlByIndex( I ):CTRL017 == .T.
                     oHmgApp():APP253 := .T.
                     SetWindowText ( ControlByIndex( i ):Handle , dtoc ( ctod ( GetWindowText ( ControlByIndex( i ):Handle ) ) ) )
                  EndIf
               EndIf
            EndIf

            If oHmgApp():InteractiveCloseStarted != .T.
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL010, i )
             EndIf

            oHmgApp():APP243 := .F.

            Return 0

         EndIf

         * TextBox GotFocus ....................................

         If  HIWORD(wParam) == EN_SETFOCUS

            oHmgApp():APP242 := .T.

            VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )

            If ControlByIndex( i ):Type == 'MASKEDTEXT'


               IF "E" $ ControlByIndex( I ):CTRL007

                  Ts := GetWindowText ( ControlByIndex( i ):Handle )

                  If "." $ ControlByIndex( I ):CTRL007
                     Do Case
                        Case HB_UAT ( '.' , Ts ) >  HB_UAT ( ',' , Ts )
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , ControlByIndex( I ):CTRL009 ) )
                        Case HB_UAT ( ',' , Ts ) > HB_UAT ( '.' , Ts )
                           TmpStr := Transform ( GetNumFromTextSP ( GetWindowText ( ControlByIndex( i ):Handle ) , i )  , ControlByIndex( I ):CTRL009 )
                           If Val ( TmpStr ) == 0
                              TmpStr := HB_UTF8STRTRAN ( TmpStr , '0.' , ' .' )
                           EndIf
                           SetWindowText ( ControlByIndex( i ):Handle , TmpStr )
                     EndCase
                  Else
                     Do Case
                        Case HB_UAT ( '.' , Ts ) !=  0
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromTextSP ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , ControlByIndex( I ):CTRL009 ) )
                        Case HB_UAT ( ',' , Ts )  != 0
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , ControlByIndex( I ):CTRL009 ) )
                        OtherWise
                           SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , ControlByIndex( I ):CTRL009 ) )
                     EndCase
                  EndIf
               ELSE
                  TmpStr := Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , ControlByIndex( I ):CTRL009 )

                  If Val ( TmpStr ) == 0
                     TmpStr := HB_UTF8STRTRAN ( TmpStr , '0.' , ' .' )
                  EndIf

                  SetWindowText ( ControlByIndex( i ):Handle , TmpStr )
               ENDIF

                     SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , 0 , -1 )

               ControlByIndex( I ):CTRL022 := .T.

            EndIf

            If ControlByIndex( i ):Type == 'CHARMASKTEXT'

               For x := 1 To HMG_LEN (ControlByIndex( I ):CTRL009)
                                                If HMG_ISDIGIT(HB_USUBSTR ( ControlByIndex( I ):CTRL009 , x , 1 )) .Or. HMG_ISALPHA(HB_USUBSTR ( ControlByIndex( I ):CTRL009 , x , 1 )) .Or. HB_USUBSTR ( ControlByIndex( I ):CTRL009 , x , 1 ) == '!'
                     MaskStart := x
                     Exit
                  EndIf
               Next x

               If MaskStart == 1
                        SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , 0 , -1 )
               Else
                        SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , MaskStart - 1 , -1 )
               EndIf

            EndIf

            _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )

            oHmgApp():APP242 := .F.

            Return 0

         EndIf

         * ListBox OnChange ....................................

         If  HIWORD(wParam) == LBN_SELCHANGE .And. (ControlByIndex( i ):Type == 'LIST' .Or. ControlByIndex( i ):Type == 'MULTILIST' )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
            Return 0
         EndIf

         * ListBox Double Click ................................

         If  HIWORD(wParam) == LBN_DBLCLK
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            Return 0
         EndIf

         * ComboBox Change .....................................

         If HiWord (wParam) == CBN_SELCHANGE .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
            Return 0
         endif

         * ComboBox OnCancel .....................................

         If HiWord (wParam) == CBN_SELENDCANCEL .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL032 , i )
            Return 0
         endif

         * ComboBox OnDropDown .....................................

         If HiWord (wParam) == CBN_DROPDOWN .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL039 , i )
            Return 0
         endif

         * ComboBox OnCloseUp .....................................

         If HiWord (wParam) == CBN_CLOSEUP .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL037 , i )
            Return 0
         endif

         * ComboBox LostFocus ..................................

         If HiWord (wParam) == CBN_KILLFOCUS .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
            Return 0
         EndIf

         * ComboBox GotFocus ...................................

         If HiWord (wParam) == CBN_SETFOCUS  .And. ControlByIndex( i ):Type == 'COMBO'
            VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
            Return 0
         EndIf

         * Process Combo Display Area Change ...................

         IF HiWord (wParam) == CBN_EDITCHANGE .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            RETURN 0
         ENDIF

         * Button LostFocus ....................................

         If HIWORD(wParam) == BN_KILLFOCUS .And. ControlByIndex( i ):Type <> 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
            Return 0
         EndIf

         * Button GotFocus .....................................

         If HIWORD(wParam) == BN_SETFOCUS
            VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
            Return 0
         EndIf

         * ListBox LostFocus ...................................

         If HIWORD(wParam) == LBN_KILLFOCUS .And. ( ControlByIndex( i ):Type = "LIST" .or. ControlByIndex( i ):Type = "MULTILIST")
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
            Return 0
         EndIf

         * ListBox GotFocus ....................................

         If HIWORD(wParam) == LBN_SETFOCUS .And. ( ControlByIndex( i ):Type = "LIST" .or. ControlByIndex( i ):Type = "MULTILIST")
            VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
            Return 0
         EndIf

         * Process Combo Display Area Change ...................

         If HIWORD(wParam) == CBN_EDITCHANGE .And. ControlByIndex( i ):Type == 'COMBO'
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            Return 0
         EndIf

      Else

         * Process RadioGrop ...................................

         If HIWORD(wParam) == BN_CLICKED
            For i := 1 to ControlCount
               if ValType (ControlByIndex( i ):Handle ) == "A" .And.ControlByIndex( i ):ParentFormHandle == hWnd
                  For x := 1 To HMG_LEN ( ControlByIndex( i ):Handle )
                     If ControlByIndex( i ):Handle [x] == lParam
                        _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
                        If ControlByIndex( I ):CTRL025 == .F. // No TabStop
                           if IsTabStop(ControlByIndex( i ):Handle [x])
                              SetTabStop(ControlByIndex( i ):Handle [x],.f.)
                           endif
                        EndIf
                        Return 0
                     EndIf
                  Next x
               Endif
            Next i

         ElseIf HIWORD(wParam) == BN_SETFOCUS

            For i := 1 to ControlCount
               if ValType (ControlByIndex( i ):Handle ) == "A" .And.ControlByIndex( i ):ParentFormHandle == hWnd
                  For x := 1 To HMG_LEN ( ControlByIndex( i ):Handle )
                     If ControlByIndex( i ):Handle [x] == lParam
                        VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle [x] , ControlByIndex( i ):ParentFormHandle )
                        If ControlByIndex( I ):CTRL025 == .F. // No TabStop
                           if IsTabStop(ControlByIndex( i ):Handle [x])
                              SetTabStop(ControlByIndex( i ):Handle [x],.f.)
                           endif
                        EndIf
                        Return 0
                     EndIf
                  Next x
               Endif
            Next i

         EndIf

      EndIf

      *...................
      * Process Enter Key
      *...................

      oControlI := ControlByHandle( GetFocus() )
      i := iif( oControlI == Nil, 0, oControlI:Index )

      if  i > 0

         * CheckBox Enter ( Pablo Cesar, December 2014 ) .......................................

         if ControlByIndex( i ):Type = "CHECKBOX" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
             _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
          If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
                _SetNextFocus()
             EndIf
             Return 0
         EndIf

         * DatePicker Enter ......................................

         if ControlByIndex( i ):Type = "DATEPICK" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
               _SetNextFocus()
            EndIf
            Return 0
         EndIf

         * TimePicker Enter ( Dr. Claudio Soto, April 2013 ) ......................................

         if ControlByIndex( i ):Type = "TIMEPICK" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
            If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
               _SetNextFocus()
            EndIf
            Return 0
         EndIf

         * Browse Enter ..........................................

         #ifdef COMPILEBROWSE

         if ControlByIndex( i ):Type = "BROWSE" .and. lparam == 0 .and. wparam == 1

            if ControlByIndex( I ):CTRL039 [6] == .T.
               ProcessInPlaceKbdEdit(i)
            Else
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            Endif

            Return 0

         EndIf

         #endif

         * Grid Enter ..........................................

         if ( ControlByIndex( i ):Type = "GRID" .or. ControlByIndex( i ):Type = "MULTIGRID") .and. lparam == 0 .and. wparam == 1
            IF ControlByIndex( I ):CTRL040  [ 1 ] == .T.

               IF ControlByIndex( I ):CTRL032 == .T.   // cellnavigation

                  _HMG_GRIDINPLACEKBDEDIT_2(I)

               ELSE

                  _HMG_GRIDINPLACEKBDEDIT(I)

               ENDIF

            Else
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            EndIf
            Return 0
         EndIf

         * ComboBox Enter ......................................

         if ControlByIndex( i ):Type = "COMBO" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
               _SetNextFocus()
            EndIf
            Return 0
         EndIf

         * ListBox Enter .......................................

         if ( ControlByIndex( i ):Type = "LIST" .or. ControlByIndex( i ):Type = "MULTILIST") .And. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            Return 0
         EndIf

         * TextBox Enter .......................................

         if ( ControlByIndex( i ):Type == "TEXT" .Or. ControlByIndex( i ):Type == "MASKEDTEXT" .Or. ControlByIndex( i ):Type == "CHARMASKTEXT" .Or. ControlByIndex( i ):Type == "NUMTEXT" ) .And. HiWord(wParam) == 0  .And. LoWord(wParam) == 1
            oHmgApp():APP251 := .F.
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            If oHmgApp():APP251 == .F.
               If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
                  _SetNextFocus()
               EndIf
            Else
               oHmgApp():APP251 := .F.
            EndIf
            Return 0
         EndIf

         * Tree Enter ..........................................

         if ControlByIndex( i ):Type == "TREE" .And. HiWord(wParam) == 0  .And. LoWord(wParam) == 1
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
            Return 0
         EndIf

      Else

         * ComboBox (DisplayEdit) ..............................

         For i := 1 To ControlCount

                          if ControlByIndex( i ):Type = "COMBO" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
               if ControlByIndex( I ):CTRL031 == GetFocus()
                  _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
                  If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
                     _SetNextFocus()
                  EndIf
                  Exit
               EndIf
            EndIf
         Next i

         * ComboBox (Image) ..............................

         xTmp := ControlByBlock( { | e | ValType( e:CTRL032 ) == "N" .AND. e:CTRL032 == GetFocus() } )
         i := iif( xTmp == Nil, 0, xTmp:Index )

         If  i > 0
            If ControlByIndex( i ):Type = "COMBO" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
               If oHmgApp():IsExtendedNavigation == .T.   // If Set ExtendedNavigation
                  _SetNextFocus()
               EndIf
            EndIf
         EndIf

         Return 0

      EndIf

        ***********************************************************************
   case nMsg == WM_MENUSELECT
        ***********************************************************************

        ToolTipMenuDisplayEvent (wParam, lParam)   // ToolTip Menu Custom Draw, by Dr. Claudio Soto (December 2014)
        Return 0

        ***********************************************************************
   case nMsg == WM_NOTIFY
        ***********************************************************************

      * Process ToolTip Custom Draw, by Dr. Claudio Soto (December 2014)

      xRetVal := ToolTipCustomDrawEvent (lParam)
      IF ValType (xRetVal) == "N"
         SetNewBehaviorWndProc (.T.)
         Return xRetVal
      ENDIF


      * Process ToolBar ToolTip .....................................

      If GetNotifyCode ( lParam ) == TTN_NEEDTEXT
         xTmp := COntrolByBlock( { | e | e:CTRL005 == GetToolButtonId(lParam)  } )
         i := iif( xTmp == Nil, 0, xTmp:Index )
         if i > 0
            if ValType ( ControlByIndex( I ):CTRL030 ) == 'C'
               ShowToolButtonTip ( lParam , ControlByIndex( I ):CTRL030 )
            endif
         endif
      EndIf

      ********************************************************************
      * GRID HEAD Custom Draw   // by Dr. Claudio Soto, September 2014
      ********************************************************************

      IF GetNotifyCode (lParam) == NM_CUSTOMDRAW
         xTmp := ControlByBlock( { | e | ValType( e:CTRL005 ) == "N" .AND. e:CTRL005 = GetHwndFrom (lParam) } )
         i := iif( xTmp == Nil, 0, xTmp:Index )
         if i > 0
            if (ControlByIndex( i ):Type == "GRID" .OR. ControlByIndex( i ):Type == "MULTIGRID")
               SetNewBehaviorWndProc (.T.)   // ADD2, December 2014
               r := HEADER_CUSTOMDRAW_GetAction ( lParam )
               if r <> -1
                  Return r   // return CDRF_NOTIFYITEMDRAW or CDRF_DODEFAULT
               endif
               Return _GridEx_DoHeaderCustomDraw ( i , lParam , Header_CustomDraw_GetItem (lParam) + 1 )   // return CDRF_NEWFONT
            endif
         endif
      ENDIF

      oControlI := ControlByHandle( GetHwndFrom (lParam) )
      i := iif( oControlI == Nil .OR. oControlI:Index == 0, 0, oControlI:Index )

      if i > 0

         * Process StatusBar Single Click ...................

         IF oControlI:Type = "STATUSBAR"
            * StatusBar Single Click
            IF GetNotifyCode ( lParam ) == NM_CLICK
               x := GetStatusBarItemPos( lParam) + 1
               IF x > 0
                  IF valtype ( oControlI:CTRL006 ) = 'A' ;
                     .AND. HMG_LEN ( oControlI:CTRL006 ) >= x ;
                     .AND. valtype ( oControlI:CTRL006 [x] ) = 'B' ;
                     .AND. _DoControlEventProcedure ( oControlI:CTRL006 [x] , i  )
                     RETURN 0
                  ENDIF
               ENDIF
            ENDIF
         ENDIF

         * Process Browse .....................................

         #ifdef COMPILEBROWSE

         if (ControlByIndex( i ):Type = "BROWSE")

            If   GetNotifyCode ( lParam ) == NM_RCLICK

               If LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) > 0
                  DeltaSelect := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) - ascan ( ControlByIndex( I ):CTRL032 , ControlByIndex( I ):CTRL008 )
                  ControlByIndex( I ):CTRL008 :=  ControlByIndex( I ):CTRL032 [ LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) ]
                  _BrowseVscrollFastUpdate ( i , DeltaSelect )
                  _BrowseOnChange (i)
               EndIf

               Return 0

            EndIf

             * Browse Refresh On Column Size ..............

            If   GetNotifyCode ( lParam ) == -12

               hws := 0
               hwm := .F.
               For x := 1 To HMG_LEN ( ControlByIndex( I ):CTRL006 )
                  hws := hws + ListView_GetColumnWidth ( ControlByIndex( i ):Handle , x - 1 )
                  If ControlByIndex( I ):CTRL006 [x] != ListView_GetColumnWidth ( ControlByIndex( i ):Handle , x - 1 )
                     hwm := .T.
                     ControlByIndex( I ):CTRL006 [x] := ListView_GetColumnWidth ( ControlByIndex( i ):Handle , x - 1 )
                     _BrowseRefresh('','',i)
                  EndIf
               Next x

               * Browse ReDraw Vertical ScrollBar If Needed ...

               If ControlByIndex( I ):CTRL005 != 0 .and. hwm == .T.
                  if hws > ControlByIndex( I ):CTRL020 - GETVSCROLLBARWIDTH() - 4
                     MoveWindow ( ControlByIndex( I ):CTRL005 , ControlByIndex( I ):CTRL019+ControlByIndex( I ):CTRL020 - GETVSCROLLBARWIDTH() , ControlByIndex( I ):CTRL018 , GETVSCROLLBARWIDTH() , ControlByIndex( I ):CTRL021 - GETHSCROLLBARHEIGHT() , .t. )
                     MoveWindow ( ControlByIndex( I ):CTRL039 [1], ControlByIndex( I ):CTRL019+ControlByIndex( I ):CTRL020 - GETVSCROLLBARWIDTH() , ControlByIndex( I ):CTRL018 + ControlByIndex( I ):CTRL021 - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() , .t. )
                  Else
                     MoveWindow ( ControlByIndex( I ):CTRL005 , ControlByIndex( I ):CTRL019+ControlByIndex( I ):CTRL020 - GETVSCROLLBARWIDTH() , ControlByIndex( I ):CTRL018 , GETVSCROLLBARWIDTH() , ControlByIndex( I ):CTRL021 , .t. )
                     MoveWindow ( ControlByIndex( I ):CTRL039 [1], ControlByIndex( I ):CTRL019+ControlByIndex( I ):CTRL020 - GETVSCROLLBARWIDTH() , ControlByIndex( I ):CTRL018 + ControlByIndex( I ):CTRL021 - GETHSCROLLBARHEIGHT() , 0 , 0 , .t. )
                  EndIf
               EndIf

            EndIf

            If GetNotifyCode ( lParam ) = NM_CUSTOMDRAW

               // r := GetDs ( lParam )
               r := LISTVIEW_CUSTOMDRAW_GetAction ( lParam )
               if r <> -1
                  Return r
               else
                  a := LISTVIEW_CUSTOMDRAW_GetRowCol (lParam)

                  MaxBrowseRows := HMG_LEN ( ControlByIndex( I ):CTRL032 )
                  MaxBrowseCols := HMG_LEN ( ControlByIndex( I ):CTRL031 )

                  if a[1] >= 1 .and. a[1] <= MaxBrowseRows .and. a[2] >= 1 .and. a[2] <= MaxBrowseCols
                     aTemp := ControlByIndex( I ):CTRL040 [6]
                     aTemp2 := ControlByIndex( I ):CTRL040 [7]

                     if valtype ( aTemp ) = 'A' .and. valtype ( aTemp2 ) <> 'A'
                        if HMG_LEN ( aTemp ) >= a[1]
                           if aTemp [a[1]] [a[2]] <> -1
                              Return SetBCFC ( lParam , aTemp [a[1]] [a[2]] , RGB(0,0,0) )
                           else
                              Return SetBCFC_Default(LpARAM)
                           endif
                        else
                           Return SetBCFC_Default(LpARAM)
                        endif
                     elseif valtype ( aTemp ) <> 'A' .and. valtype ( aTemp2 ) = 'A'
                        if HMG_LEN ( aTemp2 ) >= a[1]
                           if aTemp2 [a[1]] [a[2]] <> -1
                              Return SetBCFC ( lParam , RGB(255,255,255) , aTemp2 [a[1]] [a[2]] )
                           else
                              Return SetBCFC_Default(LpARAM)
                           endif
                        else
                           Return SetBCFC_Default(LpARAM)
                        endif
                     elseif valtype ( aTemp ) = 'A' .and. valtype ( aTemp2 ) = 'A'
                        if HMG_LEN ( aTemp ) >= a[1] .and. HMG_LEN ( aTemp2 ) >= a[1]
                           if aTemp [a[1]] [a[2]] <> -1
                              Return SetBCFC ( lParam , aTemp [a[1]] [a[2]] , aTemp2 [a[1]] [a[2]] )
                           else
                              Return SetBCFC_Default(LpARAM)
                           endif
                        else
                           Return SetBCFC_Default(LpARAM)
                        endif
                     endif

                  else
                     Return SetBCFC_Default(LpARAM)
                  endif

               endif

            EndIf

            * Browse Click ................................

            If   GetNotifyCode ( lParam ) == NM_CLICK  .or. ;
               GetNotifyCode ( lParam ) == LVN_BEGINDRAG

               If LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) > 0
                  DeltaSelect := LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) - ascan ( ControlByIndex( I ):CTRL032 , ControlByIndex( I ):CTRL008 )
                  ControlByIndex( I ):CTRL008 :=  ControlByIndex( I ):CTRL032 [ LISTVIEW_GETFIRSTITEM ( ControlByIndex( i ):Handle ) ]
                  _BrowseVscrollFastUpdate ( i , DeltaSelect )
                  _BrowseOnChange (i)
               EndIf

               Return 0

            EndIf

            * Browse Key Handling .........................

            If GetNotifyCode ( lParam ) = LVN_KEYDOWN

               Do Case

               Case GetGridvKey(lParam) == 65 // A

                  if   GetAltState() == -127 ;
                     .or.;
                     GetAltState() == -128   // ALT

                     if ControlByIndex( I ):CTRL039 [2] == .T.
                               _BrowseEdit ( ControlByIndex( i ):Handle , ControlByIndex( I ):CTRL039 [4] , ControlByIndex( I ):CTRL039 [5] , ControlByIndex( I ):CTRL039 [3] , ControlByIndex( I ):CTRL009 , .t. , ControlByIndex( I ):CTRL015 , ControlByIndex( I ):CTRL039 [7] )
                     EndIf

                  EndIf

               Case GetGridvKey(lParam) == 46 // DEL

                  If ControlByIndex( I ):CTRL025 == .t.
                          If MsgYesNo (oHmgApp():APP137 [1] , oHmgApp():APP137 [2] ) == .t.
                        _BrowseDelete('','',i)
                     EndIf
                  EndIf

               Case GetGridvKey(lParam) == 36 // HOME

                  _BrowseHome('','',i)
                  Return 1

               Case GetGridvKey(lParam) == 35 // END

                  _BrowseEnd('','',i)
                  Return 1

               Case GetGridvKey(lParam) == 33 // PGUP

                  _BrowsePrior('','',i)
                  Return 1

               Case GetGridvKey(lParam) == 34 // PGDN

                  _BrowseNext('','',i)
                  Return 1

               Case GetGridvKey(lParam) == 38 // UP

                  _BrowseUp('','',i)
                  Return 1

               Case GetGridvKey(lParam) == 40 // DOWN

                  _BrowseDown('','',i)
                  Return 1

               EndCase

               Return 0

            EndIf

            * Browse Double Click .........................

            If GetNotifyCode ( lParam ) == NM_DBLCLK

               _PushEventInfo()
               oHmgApp():ThisFormIndex := FormByHandle( ControlByIndex( I ):ParentFormHandle ):Index
               oHmgApp():ThisType := 'C'
               oHmgApp():ThisControlIndex := i
               oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name
               oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name

               r := ListView_HitTest ( ControlByIndex( i ):Handle , GetCursorRow() - GetWindowRow ( ControlByIndex( i ):Handle )  , GetCursorCol() - GetWindowCol ( ControlByIndex( i ):Handle ) )
               If r [2] == 1
                  ListView_Scroll( ControlByIndex( i ):Handle ,   -10000  , 0 )
                  r := ListView_HitTest ( ControlByIndex( i ):Handle , GetCursorRow() - GetWindowRow ( ControlByIndex( i ):Handle )  , GetCursorCol() - GetWindowCol ( ControlByIndex( i ):Handle ) )
               Else
                  r := LISTVIEW_GETSUBITEMRECT ( ControlByIndex( i ):Handle  , r[1] - 1 , r[2] - 1 )

                                                      *   CellCol            CellWidth
                  xs :=   ( ( ControlByIndex( I ):CTRL019 + r [2] ) +( r[3] ))  -  ( ControlByIndex( I ):CTRL019 + ControlByIndex( I ):CTRL020 )
                  xd := 20
                  If xs > -xd
                     ListView_Scroll( ControlByIndex( i ):Handle ,   xs + xd , 0 )
                  Else
                     If r [2] < 0
                        ListView_Scroll( ControlByIndex( i ):Handle , r[2]   , 0 )
                     EndIf
               EndIf
                     r := ListView_HitTest ( ControlByIndex( i ):Handle , GetCursorRow() - GetWindowRow ( ControlByIndex( i ):Handle )  , GetCursorCol() - GetWindowCol ( ControlByIndex( i ):Handle ) )
            EndIf

                  oHmgApp():ThisItemRowIndex := r[1]
                  oHmgApp():ThisItemColIndex := r[2]
                  If r [2] == 1
                     r := LISTVIEW_GETITEMRECT ( ControlByIndex( i ):Handle  , r[1] - 1 )
                  Else
                     r := LISTVIEW_GETSUBITEMRECT ( ControlByIndex( i ):Handle  , r[1] - 1 , r[2] - 1 )
                  EndIf
                  oHmgApp():ThisItemRow := ControlByIndex( I ):CTRL018 + r [1]
                  oHmgApp():ThisItemCol := ControlByIndex( I ):CTRL019 + r [2]
                  oHmgApp():ThisItemCellWidth := r[3]
                  oHmgApp():ThisItemCellHeight := r[4]

                  if ControlByIndex( I ):CTRL039 [6] == .T.
                     _BrowseEdit ( ControlByIndex( i ):Handle , ControlByIndex( I ):CTRL039 [4] , ControlByIndex( I ):CTRL039 [5] , ControlByIndex( I ):CTRL039 [3] , ControlByIndex( I ):CTRL009 , .f. , ControlByIndex( I ):CTRL015 , ControlByIndex( I ):CTRL039 [7] )
                  Else
                     if valtype(ControlByIndex( I ):CTRL016  )=='B'
                        Eval( ControlByIndex( I ):CTRL016  )
                     EndIf
                  Endif

                  _PopEventInfo()
                  oHmgApp():ThisItemRowIndex := 0
                  oHmgApp():ThisItemColIndex := 0
                  oHmgApp():ThisItemRow := 0
                  oHmgApp():ThisItemCol := 0
                  oHmgApp():ThisItemCellWidth := 0
                  oHmgApp():ThisItemCellHeight := 0

            EndIf

            * Browse LostFocus ............................

            If GetNotifyCode ( lParam ) = NM_KILLFOCUS

               // by Dr. Claudio Soto, December 2014
               IF IsGridCustomDrawNewBehavior() == .T.
                  SetEventProcessHMGWindowsMessage (.T.)
               ENDIF

               _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
               Return 0
            EndIf

            * Browse GotFocus ..............................

            If GetNotifyCode ( lParam ) = NM_SETFOCUS

               // by Dr. Claudio Soto, December 2014
               IF IsGridCustomDrawNewBehavior() == .T.
                  SetEventProcessHMGWindowsMessage (.F.)
               ENDIF

               VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
               Return 0
            EndIf

            * Browse Header Click .........................

            If GetNotifyCode ( lParam ) =  LVN_COLUMNCLICK
               if ValType ( ControlByIndex( I ):CTRL017 ) == 'A'
                  lvc := GetGridColumn(lParam) + 1
                  if HMG_LEN (ControlByIndex( I ):CTRL017) >= lvc
                     _DoControlEventProcedure ( ControlByIndex( I ):CTRL017 [lvc] , i )
                  EndIf
               EndIf
               Return 0
            EndIf

         EndIf

         #endif

         * ToolBar DropDown Button Click .......................

         If GetNotifyCode ( lParam ) == TBN_DROPDOWN

                xTmp := ControlByBlock( { | e | e:CTRL005 = GetToolButtonDDId( lParam) } )
                x := iif( xTmp == Nil, 0, xTmp:Index )

                if x > 0 .And. ControlByIndex( x ):Type = "TOOLBUTTON"
               aPos:= {0,0,0,0}
               GetWindowRect(ControlByIndex( i ):Handle,aPos)
               aSize := GetToolButtonSize ( ControlByIndex( i ):Handle , ControlByIndex( X ):CTRL008 - 1 )
               TrackPopupMenu ( ControlByIndex( X ):CTRL032 , aPos[1] + aSize [1] , aPos[2] + aSize [2] + ( aPos[4] - aPos[2] - aSize [2] ) / 2 , hWnd )
                EndIf

         EndIf

         * MonthCalendar Selection Change ......................

         if ControlByIndex( i ):Type = "MONTHCAL"
            If GetNotifyCode ( lParam ) = MCN_SELECT
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
               Return 0
            EndIf
         EndIf

         * Grid Processing .....................................

         if (ControlByIndex( i ):Type = "GRID") .Or. (ControlByIndex( i ):Type = "MULTIGRID")

            IF ControlByIndex( I ):CTRL032 == .T.

                 * Grid Key Handling .........................

               If GetNotifyCode ( lParam ) = LVN_KEYDOWN

                     Do Case

                     Case GetGridvKey (lParam) == 37 // LEFT

                        IF ControlByIndex( I ):CTRL015  > 1

                           ControlByIndex( I ):CTRL015  --

**************************************************************************************************************************************

                           nDestinationColumn   := ControlByIndex( I ):CTRL015
                           nFrozenColumnCount   := ControlByIndex( I ):CTRL040 [ 32 ]
                           anOriginalColumnWidths   := ControlByIndex( I ):CTRL040 [ 31 ]

                           If nFrozenColumnCount > 0

                              If nDestinationColumn >= nFrozenColumnCount + 1

                                 * Set Destination Column Width To Original

                                 LISTVIEW_SETCOLUMNWIDTH ( ControlByIndex( I ):Handle , nDestinationColumn - 1 , anOriginalColumnWidths [ nDestinationColumn ] )

                              EndIf

                           EndIf

**************************************************************************************************************************************

                           _HMG_GRID_KBDSCROLL(I)

                           LISTVIEW_REDRAWITEMS ( ControlByIndex( I ):Handle , ControlByIndex( I ):CTRL039 - 1 , ControlByIndex( I ):CTRL039 - 1 )

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF

                     Case GetGridvKey (lParam) == 39 // RIGHT

                        IF ControlByIndex( I ):CTRL015  < HMG_LEN ( ControlByIndex( I ):CTRL033 )

                           ControlByIndex( I ):CTRL015  ++

                           nDestinationColumn   := ControlByIndex( I ):CTRL015
                           nFrozenColumnCount   := ControlByIndex( I ):CTRL040 [ 32 ]

                           FOR J := nDestinationColumn TO HMG_LEN( ControlByIndex( I ):CTRL033 ) - 1

                                 IF LISTVIEW_GETCOLUMNWIDTH ( ControlByIndex( I ):Handle , J - 1 ) == 0
                                 ControlByIndex( I ):CTRL015 ++
                              ENDIF

                           NEXT J

                           If nFrozenColumnCount > 0

                              If nDestinationColumn > nFrozenColumnCount + 1

                                 * Set Current Column Width To 0

                                 LISTVIEW_SETCOLUMNWIDTH ( ControlByIndex( I ):Handle , nDestinationColumn - 2 , 0 )

                              EndIf

                           EndIf

**************************************************************************************************************************************
                           _HMG_GRID_KBDSCROLL(I)

                           LISTVIEW_REDRAWITEMS ( ControlByIndex( I ):Handle , ControlByIndex( I ):CTRL039 - 1 , ControlByIndex( I ):CTRL039 - 1 )

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF


                     Case GetGridvKey (lParam) == 38 // UP

                        IF ControlByIndex( I ):CTRL015  == 0
                           ControlByIndex( I ):CTRL015  := 1
                        ENDIF

                        IF ControlByIndex( I ):CTRL039 > 1

                           ControlByIndex( I ):CTRL039--

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF

                     Case GetGridvKey (lParam) == 40 // DOWN

                        IF ControlByIndex( I ):CTRL015  == 0
                           ControlByIndex( I ):CTRL015  := 1
                        ENDIF

                        IF ControlByIndex( I ):CTRL039 < ListView_GetItemCount( ControlByIndex( I ):Handle )

                           ControlByIndex( I ):CTRL039++

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF

                     Case GetGridvKey (lParam) == 33 // PGUP

                        _GridInitValue := ControlByIndex( I ):CTRL039

                        IF ControlByIndex( I ):CTRL039 == SendMessage ( ControlByIndex( I ):Handle , LVM_GETTOPINDEX , 0 , 0 ) + 1

                           ControlByIndex( I ):CTRL039 -= SendMessage ( ControlByIndex( I ):Handle , LVM_GETCOUNTPERPAGE , 0 , 0 ) - 1

                        ELSE

                           ControlByIndex( I ):CTRL039 := SendMessage ( ControlByIndex( I ):Handle , LVM_GETTOPINDEX , 0 , 0 ) + 1

                        ENDIF

                        IF ControlByIndex( I ):CTRL039 < 1

                           ControlByIndex( I ):CTRL039  := 1

                        ENDIF

                        IF _GridInitValue <> ControlByIndex( I ):CTRL039

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF

                     Case GetGridvKey (lParam) == 34 // PGDOWN

                        _GridInitValue := ControlByIndex( I ):CTRL039

                        IF ControlByIndex( I ):CTRL039 == SendMessage ( ControlByIndex( I ):Handle , LVM_GETTOPINDEX , 0 , 0 ) + SendMessage ( ControlByIndex( I ):Handle , LVM_GETCOUNTPERPAGE , 0 , 0 )

                           ControlByIndex( I ):CTRL039 += SendMessage ( ControlByIndex( I ):Handle , LVM_GETCOUNTPERPAGE , 0 , 0 ) - 1

                        ELSE

                           ControlByIndex( I ):CTRL039  := SendMessage ( ControlByIndex( I ):Handle , LVM_GETTOPINDEX , 0 , 0 ) + SendMessage ( ControlByIndex( I ):Handle , LVM_GETCOUNTPERPAGE , 0 , 0 )

                        ENDIF

                        IF ControlByIndex( I ):CTRL039 > ListView_GetItemCount( ControlByIndex( I ):Handle )

                           ControlByIndex( I ):CTRL039  := ListView_GetItemCount(  ControlByIndex( I ):Handle )

                        ENDIF

                        IF _GridInitValue <> ControlByIndex( I ):CTRL039
                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
                        ENDIF

//ListView_Scroll ( ControlByIndex( I ):Handle , 0, (ControlByIndex( I ):CTRL039 - _GridInitValue) * LISTVIEW_GETITEMRECT ( ControlByIndex( i ):Handle  , ControlByIndex( I ):CTRL039 ) [4])
//return 0

                     Case GetGridvKey (lParam) == 35 // END

                        _GridInitValue := ControlByIndex( I ):CTRL039

                        ControlByIndex( I ):CTRL039  := ListView_GetItemCount( ControlByIndex( I ):Handle )

                        IF _GridInitValue <> ControlByIndex( I ):CTRL039

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF

                     Case GetGridvKey (lParam) == 36 // HOME

                        _GridInitValue := ControlByIndex( I ):CTRL039

                        ControlByIndex( I ):CTRL039  := 1

                        IF _GridInitValue <> ControlByIndex( I ):CTRL039

                           _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

                        ENDIF

                     Case GetGridvKey (lParam) == 65  // A
                        if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                           IF ControlByIndex( I ):CTRL040 [ 12 ] == .T. .AND. VALTYPE( ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C'
                              DataGridAppend(i)
                           ENDIF
                        Else
                           // Return 1
                        EndIf

                     Case GetGridvKey (lParam) == 68 // D
                        if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                           IF ControlByIndex( I ):CTRL040 [ 17 ] == .T. .AND. VALTYPE(ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C'
                              DataGridDelete(i)
                           ENDIF
                        Else
                           // Return 1
                        EndIf

                     Case GetGridvKey (lParam) == 82 // R
                        if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                           IF ControlByIndex( I ):CTRL040 [ 17 ] == .T. .AND. VALTYPE(ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C'
                              DataGridReCall(i)
                           ENDIF
                        Else
                           // Return 1
                        EndIf

                     Case GetGridvKey (lParam) == 83 // S
                        if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                           IF ( ControlByIndex( I ):CTRL040 [ 12 ] == .T. .OR. ;      // allowAppend
                                ControlByIndex( I ):CTRL040 [ 17 ] == .T. .OR. ;      // allowDelete
                                ControlByIndex( I ):CTRL040 [ 1 ] == .T. ) .AND. ;    // allowEdit inplace
                                ( VALTYPE(ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C' )
                              DataGridSave(i)
                           ENDIF
                        Else
                           // Return 1
                        EndIf

                     Case GetGridvKey (lParam) == 85 // U
                        if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                           IF ( ControlByIndex( I ):CTRL040 [ 12 ] == .T. .OR. ;      // allowAppend
                                ControlByIndex( I ):CTRL040 [ 17 ] == .T. .OR. ;      // allowDelete
                                ControlByIndex( I ):CTRL040 [ 1 ] == .T. ) .AND. ;    // allowEdit inplace
                                ( VALTYPE(ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C' )
                              DataGridClearBuffer(i)
                           ENDIF
                        Else
                           // Return 1
                        EndIf

                     OtherWise

                        // Return 1   // Remove, december 2014

                     EndCase

                     Return 0   // ADD, december 2014

               EndIf

            EndIf
/*
            // by Dr. Claudio Soto, December 2014
            If GetNotifyCode (lParam) = LVN_BEGINSCROLL
               Return 0
            ENDIF

            If GetNotifyCode (lParam) = LVN_ENDSCROLL
               Return 0
            ENDIF
*/

            If GetNotifyCode (lParam) = NM_CUSTOMDRAW

               SetNewBehaviorWndProc (.T.)   // ADD2, December 2014

               IF ControlByIndex( I ):CTRL032 == .T.   // CellNavigation == .T.
                  // r := GetDsx ( lParam , ControlByIndex( I ):Handle , ControlByIndex( I ):CTRL039 )
                  r := LISTVIEW_CUSTOMDRAW_GetAction ( lParam, .T., ControlByIndex( I ):Handle , ControlByIndex( I ):CTRL039 )
               ELSE
                  // r := GetDs ( lParam )   // CellNavigation == .F.
                  r := LISTVIEW_CUSTOMDRAW_GetAction ( lParam )
               ENDIF

               if r <> -1
                  Return r   // return CDRF_NOTIFYITEMDRAW, CDRF_NOTIFYSUBITEMDRAW or CDRF_DODEFAULT
               else

                  a := LISTVIEW_CUSTOMDRAW_GetRowCol (lParam)   //  get nROW and nCOL of the cell draw

                  *  a [1] --> nRow draw
                  *  a [2] --> nCow draw
                  *  ControlByIndex( I ):CTRL039 --> nRow of the selected cell
                  *  ControlByIndex( I ):CTRL015 --> nCol of the selected cell

                  IF ControlByIndex( I ):CTRL032 == .T.  // CellNavigation == .T.

                     if a [1] == ControlByIndex( I ):CTRL039  .and. a [2] == ControlByIndex( I ):CTRL015 .AND. oHmgApp():GRID_SELECTEDCELL_DISPLAYCOLOR == .T.   // ADD
                        hFont := _GridEx_DoGridCustomDrawFont ( i, a, lParam, .F. )
                        r := GRID_SetBCFC ( lParam , RGB( oHmgApp():APP351[1] ,oHmgApp():APP351[2],oHmgApp():APP351[3] ) , RGB( oHmgApp():APP350[1] , oHmgApp():APP350[2] , oHmgApp():APP350[3] ) , hFont )

                     elseif a [1] == ControlByIndex( I ):CTRL039  .and. a [2] <> ControlByIndex( I ):CTRL015 .AND. oHmgApp():GRID_SELECTEDROW_DISPLAYCOLOR == .T.   // ADD
                        hFont := _GridEx_DoGridCustomDrawFont ( i, a, lParam, .F. )
                        r := GRID_SetBCFC ( lParam , RGB( oHmgApp():APP349[1] ,oHmgApp():APP349[2],oHmgApp():APP349[3] ) , RGB( oHmgApp():APP348[1] , oHmgApp():APP348[2] , oHmgApp():APP348[3] ) , hFont )

                     else
                        r := _GridEx_DoGridCustomDraw ( i , a , lParam )   // ADD2
                     endif

                  ELSE
                     r := _GridEx_DoGridCustomDraw ( i , a , lParam )   // ADD2
                  ENDIF

                  Return r   // return CDRF_NEWFONT

               endif

            EndIf

*******************************************************************************
            If GetNotifyCode ( lParam ) = -181
               redrawwindow (ControlByIndex( i ):Handle)
            endif
*******************************************************************************

            * Grid OnQueryData ............................

            If GetNotifyCode ( lParam ) = LVN_GETDISPINFO

               _PushEventInfo()
               oHmgApp():ThisFormIndex := FormByHandle( ControlByIndex( I ):ParentFormHandle ):Index
               oHmgApp():ThisType := 'C'
               oHmgApp():ThisControlIndex := i
               oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name
               oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name
               _ThisQueryTemp  := GETGRIDDISPINFOINDEX ( lParam )
               oHmgApp():APP201  := _ThisQueryTemp [1]   // This.QueryRowIndex
               oHmgApp():APP202  := _ThisQueryTemp [2]   // This.QueryColIndex

               IF valtype ( ControlByIndex( I ):CTRL040 [ 10 ] ) == 'C'
                  IF USED ()                                           // ADD
                     GetDataGridCellData ( i , .F. )
                  ENDIF
               ELSE
                  IF ValType (ControlByIndex( I ):CTRL006) == "B"          // ADD
                     Eval( ControlByIndex( I ):CTRL006  )   // OnQueryData Event
                  ENDIF
               ENDIF

               if HMG_LEN ( ControlByIndex( I ):CTRL014 ) > 0 .And. oHmgApp():APP202 == 1
                  SetGridQueryImage ( lParam , oHmgApp():APP230 )
               Else
                  xTemp := oHmgApp():APP230   // This.QueryData

                  if valtype ( xTemp ) == 'C'
                     cTemp := RTRIM(xTemp)
                  elseif valtype ( xTemp ) == 'N'
                     cTemp := STR(xTemp)
                  elseif valtype ( xTemp ) == 'D'
                     cTemp := dtoc(xTemp)
                  elseif valtype ( xTemp ) == 'L'
                     cTemp := if ( xTemp , '.T.' , '.F.' )
                  else
                     cTemp := ''
                  endif

                  SetGridQueryData ( lParam , cTemp )
               EndIf

               oHmgApp():APP201  := 0   // This.QueryRowIndex
               oHmgApp():APP202  := 0   // This.QueryColIndex
               oHmgApp():APP230 := ""   // This.QueryData
               _PopEventInfo()
               Return 0   // ADD
            EndIf

            * Grid LostFocus ..............................

            If GetNotifyCode ( lParam ) = NM_KILLFOCUS

               // by Dr. Claudio Soto, December 2014
               IF IsGridCustomDrawNewBehavior() == .T.
                  SetEventProcessHMGWindowsMessage (.T.)
               ENDIF

               _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
               Return 0

            EndIf

            * Grid GotFocus ...............................

            If GetNotifyCode ( lParam ) = NM_SETFOCUS

               // by Dr. Claudio Soto, December 2014
               IF IsGridCustomDrawNewBehavior() == .T.
                  SetEventProcessHMGWindowsMessage (.F.)
               ENDIF

               VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
               Return 0
            EndIf

            * Grid Change .................................

            If GetNotifyCode ( lParam ) = LVN_ITEMCHANGED

               //   OnCheckBoxClicked   (by Dr. Claudio Soto, December 2014)
               #define LVIS_UNCHECKED 0x1000
               #define LVIS_CHECKED   0x2000
               IF GetGridNewState(lParam) == LVIS_UNCHECKED .OR. GetGridNewState(lParam) == LVIS_CHECKED
                  xTemp := { NIL, NIL }
                  xTemp[1] := ControlByIndex( I ):CTRL040 [ 37 ] [ 1 ]   // This.CellRowClicked
                  IF ( xTemp[1] > 0 .AND. xTemp[1] <=  ListView_GetItemCount (ControlByIndex( I ):Handle) ) .OR. ;
                     ( HMG_GetLastVirtualKeyDown( @xTemp[2] ) == VK_SPACE .AND. xTemp[2] == ControlByIndex( I ):Handle ) .OR. ;
                     ( HMG_GetLastMouseMessage( @xTemp[2] ) == WM_LBUTTONDOWN .AND. xTemp[2] == ControlByIndex( I ):Handle )   // ADD, March 2016
                     IF HMG_GetLastVirtualKeyDown() == VK_SPACE .OR. HMG_GetLastMouseMessage() == WM_LBUTTONDOWN
                        ControlByIndex( I ):CTRL040 [ 37 ] [ 1 ] := GETGRIDROW ( lParam ) + 1  // CellRowClicked
                        ControlByIndex( I ):CTRL040 [ 37 ] [ 2 ] := 0                          // CellColClicked
                     ENDIF
                     _DoControlEventProcedure ( ControlByIndex( I ):CTRL040 [ 46 ] , i )   // OnCheckBoxClicked
                     Return 0
                  ENDIF
               ENDIF

               If GetGridOldState(lParam) == 0 .and. GetGridNewState(lParam) <> 0
                  IF ControlByIndex( I ):CTRL032 == .T.
                     ControlByIndex( I ):CTRL039 := LISTVIEW_GETFIRSTITEM ( ControlByIndex( I ):Handle )
                  ELSE
                     _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
                  ENDIF
                  Return 0
               EndIf

            EndIf

            * Grid Header Click ..........................

            If GetNotifyCode ( lParam ) =  LVN_COLUMNCLICK
               if ValType ( ControlByIndex( I ):CTRL017 ) == 'A'
                  lvc := GetGridColumn(lParam) + 1
                  if HMG_LEN (ControlByIndex( I ):CTRL017) >= lvc
                     _DoControlEventProcedure ( ControlByIndex( I ):CTRL017 [lvc] , i )
                     Return 0
                  EndIf
               EndIf
            EndIf

            * Grid Click ...........................

            If GetNotifyCode ( lParam ) == NM_CLICK
               IF ControlByIndex( I ):CTRL032 == .T.

                  aCellData := _GetGridCellData(i)

                  IF aCellData [2] > 0

                     ControlByIndex( I ):CTRL015  := aCellData [2]

                  ENDIF

                  LISTVIEW_REDRAWITEMS ( ControlByIndex( I ):Handle , ControlByIndex( I ):CTRL039 - 1 , ControlByIndex( I ):CTRL039 - 1 )

                  _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )

               ENDIF
               Return 0   // ADD2
            EndIf

            * Grid Double Click ...........................

            If GetNotifyCode ( lParam ) == NM_DBLCLK

               IF ControlByIndex( I ):CTRL040 [ 1 ]  == .T.

                     _PushEventInfo()
                     oHmgApp():ThisFormIndex := FormByHandle( ControlByIndex( I ):ParentFormHandle ):Index   // Parent Index
                     oHmgApp():ThisType := 'C'
                     oHmgApp():ThisControlIndex := i                                                      // Control Index
                     oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name  // Parent Name
                     oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name               // Control Name
                     aCellData := _GetGridCellData(i)
                     oHmgApp():ThisItemRowIndex := aCellData [1]
                     oHmgApp():ThisItemColIndex := aCellData [2]
                     oHmgApp():ThisItemRow := aCellData [3]
                     oHmgApp():ThisItemCol := aCellData [4]
                     oHmgApp():ThisItemCellWidth := aCellData [5]
                     oHmgApp():ThisItemCellHeight := aCellData [6]

                     _HMG_GRIDINPLACEEDIT(i)

                     _PopEventInfo()
                     oHmgApp():ThisItemRowIndex := 0
                     oHmgApp():ThisItemColIndex := 0
                     oHmgApp():ThisItemRow := 0
                     oHmgApp():ThisItemCol := 0
                     oHmgApp():ThisItemCellWidth := 0
                     oHmgApp():ThisItemCellHeight := 0

                     // Return 0

               Else

                  if valtype(ControlByIndex( I ):CTRL016  )=='B'

                        _PushEventInfo()
                        oHmgApp():ThisFormIndex := FormByHandle( ControlByIndex( I ):ParentFormHandle ):Index
                        oHmgApp():ThisType := 'C'
                        oHmgApp():ThisControlIndex := i
                        oHmgApp():ThisFormName := FormByIndex( oHmgApp():ThisFormIndex ):Name
                        oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name

                        aCellData := _GetGridCellData(i)

                        oHmgApp():ThisItemRowIndex := aCellData [1]
                        oHmgApp():ThisItemColIndex := aCellData [2]
                        oHmgApp():ThisItemRow := aCellData [3]
                        oHmgApp():ThisItemCol := aCellData [4]
                        oHmgApp():ThisItemCellWidth := aCellData [5]
                        oHmgApp():ThisItemCellHeight := aCellData [6]

                        Eval( ControlByIndex( I ):CTRL016  )
                        _PopEventInfo()

                        oHmgApp():ThisItemRowIndex := 0
                        oHmgApp():ThisItemColIndex := 0
                        oHmgApp():ThisItemRow := 0
                        oHmgApp():ThisItemCol := 0
                        oHmgApp():ThisItemCellWidth := 0
                        oHmgApp():ThisItemCellHeight := 0

                        // Return 0

                   EndIf

               EndIf

               Return 0

            EndIf

         EndIf

         * DatePicker Process ..................................

         if ControlByIndex( i ):Type = "DATEPICK"

            * DatePicker Change ............................

            If ( GetNotifyCode ( lParam ) == DTN_DATETIMECHANGE .and. SendMessage( ControlByIndex( I ):Handle ,DTM_GETMONTHCAL,0,0 ) == 0 ) .OR. ( GetNotifyCode ( lParam ) == DTN_CLOSEUP )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
               Return 0
            EndIf

            * DatePicker LostFocus ........................

            If GetNotifyCode ( lParam ) = NM_KILLFOCUS
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
               Return 0
            EndIf

            * DatePicker GotFocus .........................

            If GetNotifyCode ( lParam ) = NM_SETFOCUS
               VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
               Return 0
            EndIf

         EndIf

         * TimePicker Process ( Dr. Claudio Soto, April 2013 ) ..................................

         if ControlByIndex( i ):Type = "TIMEPICK"

            * TimePicker Change ............................

            If ( GetNotifyCode ( lParam ) == DTN_DATETIMECHANGE )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
               Return 0
            EndIf

            * TimePicker LostFocus ........................

            If GetNotifyCode ( lParam ) = NM_KILLFOCUS
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
               Return 0
            EndIf

            * TimePicker GotFocus .........................

            If GetNotifyCode ( lParam ) = NM_SETFOCUS
               VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
               Return 0
            EndIf

         EndIf

         // by Dr. Claudio Soto, January 2014
         * RichEditBox Processing ......................................

         if ControlByIndex( i ):Type = "RICHEDIT"

            * RichEditBox Selelection Change ..................................

            If GetNotifyCode ( lParam ) = EN_SELCHANGE
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL022 , i )
               Return 0
            EndIf

            If GetNotifyCode ( lParam ) = EN_LINK
               // GetNotifyLink ( lParam , @Link_wParam , @Link_lParam , @Link_cpMin         , @Link_cpMax         )   -> return Link_nMsg

               If GetNotifyLink ( lParam , NIL          , NIL          , @_HMG_CharRange_Min , @_HMG_CharRange_Max ) = WM_LBUTTONDOWN
                  _DoControlEventProcedure ( ControlByIndex( I ):CTRL031 , i )
                  _HMG_CharRange_Min := 0
                  _HMG_CharRange_Max := 0
                  Return 0
               EndIf

            EndIf

         EndIf

         * Tab Processing ......................................

         if ControlByIndex( i ):Type = "TAB"

            * Tab Change ..................................

            If GetNotifyCode ( lParam ) = TCN_SELCHANGE
               if HMG_LEN (ControlByIndex( I ):CTRL007) > 0
                       UpdateTab (i)
               EndIf
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
               Return 0
            EndIf

         EndIf

         * Tree Processing .....................................

         if ControlByIndex( i ):Type = "TREE"

            * Tree LostFocus .............................

            If GetNotifyCode ( lParam ) = NM_KILLFOCUS
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL010 , i )
               Return 0
            EndIf

            * Tree GotFocus ..............................

            If GetNotifyCode ( lParam ) = NM_SETFOCUS
               VirtualChildControlFocusProcess ( ControlByIndex( i ):Handle , ControlByIndex( i ):ParentFormHandle )
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL011 , i )
               Return 0
            EndIf

            * Tree Change ................................

            If GetNotifyCode ( lParam ) = TVN_SELCHANGED
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL012 , i )
               Return 0
            EndIf

            * Tree Double Click .........................

            If GetNotifyCode ( lParam ) == NM_DBLCLK
               _DoControlEventProcedure ( ControlByIndex( I ):CTRL016 , i )
               Return 0
            EndIf

            * Tree OnExpand and OnCollapse ......................... (Dr. Claudio Soto, July 2014)

            IF GetNotifyCode ( lParam ) == TVN_ITEMEXPANDING   /*TVN_ITEMEXPANDED*/

               _HMG_ret := NOTIFY_TREEVIEW_ITEMEXPAND ( lParam )
               oHmgApp():This_TreeItem_Value := NIL

               If ControlByIndex( I ):CTRL009 == .F.
                  oHmgApp():This_TreeItem_Value := ASCAN ( ControlByIndex( I ):CTRL007, _HMG_ret [2] )
               Else
                  oHmgApp():This_TreeItem_Value := TREEITEM_GETID ( ControlByIndex( i ):Handle, _HMG_ret [2] )
               EndIf

               IF _HMG_ret [1] == TVE_EXPAND
                  _DoControlEventProcedure ( ControlByIndex( I ):CTRL017 [1], i )
                  oHmgApp():This_TreeItem_Value := NIL
                  Return 0
               ENDIF

               IF _HMG_ret [1] == TVE_COLLAPSE
                  _DoControlEventProcedure ( ControlByIndex( I ):CTRL017 [2], i )
                  oHmgApp():This_TreeItem_Value := NIL
                  Return 0
               ENDIF

            ENDIF

            * Tree Dynamic ForeColor, BackColor and Font   ......................... (Dr. Claudio Soto, July 2014)

            IF GetNotifyCode (lParam) == NM_CUSTOMDRAW

               IF ValType ( ControlByIndex( I ):CTRL040 [1] ) == "B" .OR. ;   // DynamicBackColor
                  ValType ( ControlByIndex( I ):CTRL040 [2] ) == "B" .OR. ;   // DynamicForeColor
                  ValType ( ControlByIndex( I ):CTRL040 [3] ) == "B"          // DynamicFont

                  SetNewBehaviorWndProc (.T.)   // ADD2, December 2014

                  r := TREEVIEW_CUSTOMDRAW_GetAction ( lParam )

                  if r <> -1
                     Return R   // return CDRF_NOTIFYITEMDRAW or CDRF_DODEFAULT
                  endif

                  oHmgApp():This_TreeItem_Value := NIL

                  _HMG_ret := ASCAN ( ControlByIndex( I ):CTRL007, TREEVIEW_CUSTOMDRAW_GETITEMHANDLE (lParam) )

                  IF _HMG_ret > 0

                     If ControlByIndex( I ):CTRL009 == .F.
                        oHmgApp():This_TreeItem_Value := _HMG_ret
                     ELSE
                        oHmgApp():This_TreeItem_Value := ControlByIndex( I ):CTRL025 [ _HMG_ret ]
                     EndIf

                     Return _DoTreeCustomDraw ( i , lParam )   // return CDRF_NEWFONT

                  ENDIF

               ENDIF

            ENDIF

         EndIf

      EndIf

        ***********************************************************************
   case nMsg == WM_CLOSE
        ***********************************************************************

      If GetEscapeState() < 0   // GetKeyState( VK_ESCAPE )
         If GetFocusedControlType() == 'EDIT'
            Return (1)   // Not Closes Window
         EndIf
      EndIf

      oFormI := FormByHandle( hWnd )
      IF oFormI != Nil

         * Process Interactive Close Event / Setting

         If ValType ( oFormI:FORM106 ) == 'B'
            xRetVal := _DoWindowEventProcedure ( oFormI:FORM106 , oFormI:Index , 'WINDOW_ONINTERACTIVECLOSE' )
            If ValType (xRetVal) = 'L'
               If !xRetVal
                  Return (1)   // Not Closes Window
               EndIf
            EndIf
         EndIf

         Do Case
         Case oHmgApp():APP339 == 0   // _HMG_InteractiveClose
            MsgStop ( oHmgApp():APP331 [3] )
            Return (1)   // Not Closes Window
         Case oHmgApp():APP339 == 2
            If ! MsgYesNo ( oHmgApp():APP331 [1] , oHmgApp():APP331 [2] )
               Return (1)   // Not Closes Window
            EndIf
         Case oHmgApp():APP339 == 3
            if FormByIndex( i ):Type == 'A'
               If ! MsgYesNo ( oHmgApp():APP331 [1] , oHmgApp():APP331 [2] )
                  Return (1)   // Not Closes Window
               EndIf
            EndIf
         EndCase

         * Process AutoRelease Property

         if oFormI:AutoRelease := .F.
            _HideWindow ( oFormI:Name )
            Return (1)   // Not Closes Window
         EndIf

         * If Not AutoRelease Destroy Window

         if oFormI:Type == 'A'   // Main Window
            ReleaseAllWindows()   // call ExitProcess(0) and ends the application
         Else
            if valtype( oFormI:ReleaseProcedure ) == 'B'
               oHmgApp():InteractiveCloseStarted := .T.
               _DoWindowEventProcedure ( oFormI:ReleaseProcedure , oFormI:Index , 'WINDOW_RELEASE')
            EndIf
            _hmg_OnHideFocusManagement( oFormI:Index )

#ifdef ALLOW_ONLY_ONE_MESSAGE_LOOP
// DestroyWindow(hWnd): Destroys the specified window.
// The function sends WM_DESTROY and WM_NCDESTROY messages to the window to deactivate it and remove the keyboard focus from it.
// The function also destroys the window's MENU, flushes the thread MESSAGE QUEUE, destroys TIMERS, removes CLIPBOARD ownership,
// and breaks the clipboard viewer chain (if the window is at the top of the viewer chain).
// If the specified window is a parent or owner window, DestroyWindow automatically destroys the associated CHILD or OWNED windows
// when it destroys the parent or owner window. The function first destroys child or owned windows, and then it destroys the parent or owner window.
// DestroyWindow also destroys MODELESS DIALOG BOXES created by the CreateDialog function.

   DestroyWindow ( oFormI:Handle )
#endif
         EndIf

      EndIf

        ***********************************************************************
   case nMsg == WM_DESTROY
        ***********************************************************************

      ControlCount  := oHmgApp():ControlCount
      oFormI := FormByHandle( hWnd )

      if oFormI != Nil

      * Remove Child Controls
         For x:=1 To ControlCount
            if ControlByIndex( X ):ParentFormHandle == hWnd              // _HMG_aParentHandle
               if ControlByIndex( x ):Type == 'ACTIVEX'      // _HMG_aControlType
                  releasecontrol(ControlByIndex( x ):Handle)   // _HMG_aControlHandle
               ENDIF
               if ControlByIndex( x ):Type == 'BUTTON'
                  IMAGELIST_DESTROY ( ControlByIndex( X ):CTRL037 )   // avoid the increase of GDI handles when subwindow with buttons is released
               ENDIF
               _EraseControl( x, oFormI:Index )   // This function call: DeleteObject(), IMAGELIST_DESTROY(), ReleaseHotKey() and clean the content of _HMGSYSDATA of control
            EndIf
         Next x

         // Delete Brush
         DeleteObject ( oFormI:FORM100 )   // _HMG_aFormBrushHandle

         // Update Form Index Variable
         mVar := '_' + oFormI:Name
         if type ( mVar ) != 'U'
            __MVPUT ( mVar , 0 )
         EndIf

         Tmp := NIL   // avoid warning message: defined variable but not used (need only ALLOW_ONLY_ONE_MESSAGE_LOOP is defined)

#ifndef ALLOW_ONLY_ONE_MESSAGE_LOOP

         * If Window Was Multi-Activated, Determine If It Is The Last One.
         * If Yes, Post Quit Message To Finish The Message Loop
         * Quit Message, will be posted always for single activated windows.

         if oFormI:FORM107 > 0   // _HMG_aFormActivateId
            TmpStr := '_HMG_ACTIVATE_' + ALLTRIM( STR( oFormI:FORM107 ) )
            if __MVEXIST ( TmpStr )
               Tmp := __MVGET ( TmpStr )
               If ValType(Tmp) == 'N'
                  __MVPUT ( TmpStr , Tmp - 1 )
                  if Tmp - 1 == 0
                     PostQuitMessage(0)
                     __MVXRELEASE(TmpStr)
                  Endif
               Endif
            Endif
         else
            PostQuitMessage(0)
         Endif

#endif


#ifdef ALLOW_ONLY_ONE_MESSAGE_LOOP
   if oFormI:Type == "A"   // Main Window
     PostQuitMessage(0)
   endif
#endif

      i := oFormI:Index
      WITH OBJECT oFormI
         :IsDeleted         := .T.
         :Handle            := 0
         :Name              := ""
         :IsActive          := .f.
         :Type              := ""
         :ParentHandle := 0
         :InitProcedure     := ""
         :ReleaseProcedure  := ""
         :TooltipHandle     := 0
         :FormContextMenuHandle   := 0
         :FORM075   := ""
         :FORM076   := ""
         :FORM077   := ""
         :FORM078   := ""
         :FORM079   := Nil
         :FORM080   := ""
         :NoShow := .F.
         :NotifyIconName := ''
         :FORM083 := ''
         :FORM084 := ''
         :FORM087 := 0
         :FORM088 := 0
         :FORM089 := {}
         :FORM090 := {}
         :VirtualHeight     := 0
         :FORM085 := ""
         :FORM086 := ""
         :VirtualWidth      := 0
         :FORM093 := .f.
         :FORM094 := ""
         :FORM095 := ""
         :FORM096 := ""
         :FORM097 := ""
         :FORM098 := ""
         :FORM099 := ""
         :FORM100 := 0
         :FORM101 := 0
         :GraphTasks := {}
         :FORM103 := Nil
         :FORM104 := Nil
         :AutoRelease        := .F.
         :FORM106 := ""
         :FORM107 := 0
         :FORM108 := NIL
         :FORM504 := { NIL, NIL, NIL, NIL}
         :TooltipMenuHandle := 0
         :FORM512 := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }
      ENDWITH

         oHmgApp():InteractiveCloseStarted := .F.

      Endif

// Dr. Claudio Soto (July 2013)

   IF oHmgApp():LastActiveControlIndex > 0 .AND. ;
         ControlByIndex( oHmgApp():LastActiveControlIndex ):IsDeleted
      aux_hWnd := GetFocus ()
      IF aux_hWnd == 0
         aux_hWnd := GetActiveWindow ()
      ENDIF
      nIndex := 0
      IF aux_hWnd <> 0
         nIndex := GetControlIndexByHandle( aux_hWnd )
      ENDIF
      oHmgApp():LastActiveControlIndex := nIndex
   ENDIF


        ***********************************************************************
   case nMsg == WM_NCACTIVATE
        ***********************************************************************

      if wParam == 0
         if lParam == 0
            if _isWindowDefined('_HMG_GRID_InplaceEdit')
               oHmgApp():APP256 := .F.
               EXITGRIDCELL()
            endif
            if valtype ( oHmgApp():APP296 ) == 'B'
               Eval ( oHmgApp():APP296 )
            endif
         endif
      endif

   endcase

return (0)
*-----------------------------------------------------------------------------*
Function GetWindowType ( FormName )

   LOCAL mVar , i

   mVar := '_' + FormName

   i := &mVar
   IF i == 0
      RETURN ''
   ENDIF

   RETURN FormByIndex( &mVar ):Type
*-----------------------------------------------------------------------------*
Function _IsWindowActive ( FormName )
*-----------------------------------------------------------------------------*
Local mVar , i

FormName := CharRem ( CHR(34)+CHR(39), FormName )

mVar := '_' + FormName

if type ( mVar ) = 'U'
   Return (.F.)
Else
   i := &mVar
   If i == 0
      Return .f.
   EndIf
   Return FormByIndex( &mVar ):IsActive
EndIf

Return .F.

*-----------------------------------------------------------------------------*
Function _IsWindowDefined ( FormName )
*-----------------------------------------------------------------------------*
Local mVar , i

FormName := CharRem ( CHR(34)+CHR(39), FormName )

mVar := '_' + FormName

if type ( mVar ) = 'U'
   Return (.F.)
Else
   i := &mVar
   If i == 0
      Return .f.
   EndIf
   Return ! FormByIndex( I ):IsDeleted
EndIf

Return .F.


*-----------------------------------------------------------------------------*
Function GetFormName (FormName)
*-----------------------------------------------------------------------------*
Local mVar , nIndex

   mVar := '_' + FormName

   nIndex := &mVar
   if nIndex == 0
      Return ''
   endif

Return FormByIndex( nIndex ):Name
*-----------------------------------------------------------------------------*
Function GetFormToolTipHandle (FormName)

Local mVar , i

   mVar := '_' + FormName

   i:=&mVar
   if i == 0
      Return 0
   endif

   RETURN FormByIndex( &mVar ):TooltipHandle

*-----------------------------------------------------------------------------*
Function GetMenuToolTipHandle (FormName)
*-----------------------------------------------------------------------------*
Local mVar , i

   mVar := '_' + FormName

   i:=&mVar
   if i == 0
      Return 0
   endif

Return FormByIndex( &mVar ):TooltipMenuHandle

*-----------------------------------------------------------------------------*
Function GetFormHandle (FormName)
*-----------------------------------------------------------------------------*
Local mVar , i

   mVar := '_' + FormName

   i:=&mVar
   if i == 0
      Return 0
   endif

Return FormByIndex( &mVar ):Handle

*-----------------------------------------------------------------------------*
Function ReleaseAllWindows ()
*-----------------------------------------------------------------------------*
Local i, FormCount , x , ControlCount

   If oHmgApp():ThisEventType == 'WINDOW_RELEASE'
      MsgHMGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
   EndIf

   FormCount := oHmgApp():FormCount

   For i = 1 to FormCount
      if  FormByIndex( i ):IsActive == .t.   // _HMG_aFormActive

         _DoWindowEventProcedure ( FormByIndex( i ):ReleaseProcedure , i , 'WINDOW_RELEASE' )

         if .Not. Empty ( FormByIndex( I ):NotifyIconName )
            FormByIndex( I ):NotifyIconName := ''
            ShowNotifyIcon( FormByIndex( i ):Handle , .F., NIL, NIL )
         EndIf

      Endif

// if set mixedmode
//      FormByIndex( i ):IsDeleted := .T.
//      DestroyWindow ( FormByIndex( i ):Handle )

   Next i

   ControlCount := oHmgApp():ControlCount

   For x := 1 To ControlCount

      if ControlByIndex( x ):Type == 'HOTKEY'
         ReleaseHotKey ( ControlByIndex( X ):ParentFormHandle , ControlByIndex( X ):CTRL005 )   // This is not necessary here !!!
      EndIf

   Next x

   // Dr. Claudio Soto (July 2013)
   HMG_HOOK_UNINSTALL ()

   UnloadAllDll()

   dbcloseall()

   ExitProcess(0)

// if Set MixedMode --> call PostQuitMessage(0) and not ExitProcess(0), dbcloseall(), UnloadAllDll() ???

Return Nil

*-----------------------------------------------------------------------------*
Function _ReleaseWindow (FormName)
*-----------------------------------------------------------------------------*
Local FormCount , b , i , x


   b := oHmgApp():APP339
   oHmgApp():APP339 := 1

   FormCount := oHmgApp():FormCount

   If .Not. _IsWindowDefined (Formname)
      MsgHMGError("Window: "+ FormName + " is not defined. Program terminated" )
   Endif

   If .Not. _IsWindowActive (Formname)
      MsgHMGError("Window: "+ FormName + " is not active. Program terminated" )
   Endif

   If oHmgApp():ThisEventType == 'WINDOW_RELEASE'
      If GetFormIndex ( FormName ) == oHmgApp():ThisControlIndex
         MsgHMGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
      EndIf
   EndIf


   // If the window to release is the main application window, release all windows command will be executed
   If GetWindowType (FormName) == 'A'   // Release MainWindow

      If oHmgApp():ThisEventType == 'WINDOW_RELEASE'
         MsgHMGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
      Else
         ReleaseAllWindows()   // in ReleaseAllWindows() is called HMG_HOOK_UNINSTALL()
      EndIf

   EndIf


   If GetWindowType (FormName) == 'P'
      MsgHMGError("Release a 'Panel' window is not allowed (It is released via its parent). Program terminated" )
   EndIf


   i := GetFormIndex ( Formname )

   * Release Window

   if FormByIndex( i ):Type == 'M' .and. oHmgApp():ActiveModalHandle <> FormByIndex( i ):Handle

         If IsWindowVisible ( FormByIndex( i ):Handle )
            MsgHMGError("Non top modal windows can't be released. Program terminated" )
         Else
            EnableWindow ( FormByIndex( i ):Handle )
            SendMessage  ( FormByIndex( i ):Handle , WM_SYSCOMMAND, SC_CLOSE, 0 )
            // SendMessage( FormByIndex( i ):Handle, WM_CLOSE, 0, 0 )   // ADD October 2015, REMOVE January 2016
         EndIf

   Else

      For x := 1 To FormCount
         if FormByIndex( x ):ParentHandle == FormByIndex( i ):Handle   // if _HMG_aFormParentHandle == FormHandle to Release
            FormByIndex( x ):ParentHandle := oHmgApp():MainHandle      // _HMG_aFormParentHandle := _HMG_MainHandle  -->  WHY THIS ???
         EndIf
      Next x

      EnableWindow ( FormByIndex( i ):Handle )
      SendMessage( FormByIndex( i ):Handle , WM_SYSCOMMAND, SC_CLOSE, 0 )
      // SendMessage( FormByIndex( i ):Handle, WM_CLOSE, 0, 0 )   // ADD October 2015, REMOVE January 2016
   EndIf

   oHmgApp():APP339 := b

Return Nil

*-----------------------------------------------------------------------------*
Function _ShowWindow (FormName)

   LOCAL i , oFormI, oFormX, nIndex
   LOCAL  ActiveWindowHandle

   i := GetFormIndex ( FormName )
   oFormI := FormByIndex( i )

   IF oFormI:Type == "M"

      // Find Parent

      IF oHmgApp():IsModalActive
         oFormI:ParentHandle := oHmgApp():ActiveModalHandle
      ELSE
         ActiveWindowhandle := oHmgApp():ActiveWindowHandle
         oFormX := FormByHandle( ActiveWindowhandle )
         IF oFormX != Nil
            oFormI:ParentHandle := ActiveWindowhandle
         ELSE
            oFormI:ParentHandle := oHmgApp():MainHandle
         ENDIF

      ENDIF

      FOR EACH oFormX IN oHmgApp():AllForms()
         IF oFormX:Index <> oFormI:Index .AND. oFormX:Type != 'X' ;
                 .AND. oFormX:Type != 'P' .AND. oFormX:ParentHandle != oFormX:Handle
            DisableWindow( oFormX:Handle )
         ENDIF
      NEXT
      FOR EACH nIndex IN FormByIndex( I ):FORM090
         EnableWindow( FormByIndex( nIndex ):Handle )
      NEXT

      oHmgApp():IsModalActive := .T.
      oHmgApp():ActiveModalHandle := FormByIndex( i ):Handle
      EnableWindow ( FormByIndex( i ):Handle )

      IF _SetFocusedSplitChild( i ) == .f.
         _SetActivationFocus( i )
      ENDIF

   ENDIF

   ShowWindow( oFormI:Handle )

   DO EVENTS   // ProcessMessages()

   RETURN Nil

*-----------------------------------------------------------------------------*
Function _HideWindow (FormName)
*-----------------------------------------------------------------------------*
Local i

   i := GetFormIndex (FormName)

   if i > 0

      If IsWindowVisible ( FormByIndex( i ):Handle  )

         if FormByIndex( i ):Type == 'M'
            if   oHmgApp():ActiveModalHandle <> FormByIndex( i ):Handle
               MsgHMGError("Non top modal windows can't be hide. Program terminated" )
            EndIf
         EndIf

         HideWindow ( FormByIndex( i ):Handle )
         _hmg_OnHideFocusManagement(i)

      EndIf

   EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _CenterWindow ( FormName , Parent )
*-----------------------------------------------------------------------------*
   C_Center( GetFormHandle(FormName) , IIF (ValType(Parent)=="C", GetFormHandle(Parent), Parent) )
Return Nil
*-----------------------------------------------------------------------------*
Function _RestoreWindow ( FormName )
*-----------------------------------------------------------------------------*
local h
   _ShowWindow (FormName)
   H = GetFormHandle(FormName)
   Restore(H)
Return Nil
*-----------------------------------------------------------------------------*
Function _MaximizeWindow ( FormName )
*-----------------------------------------------------------------------------*
local h
   H = GetFormHandle(FormName)
   Maximize(H)
Return Nil
*-----------------------------------------------------------------------------*
Function _MinimizeWindow ( FormName )
*-----------------------------------------------------------------------------*
local h
   H = GetFormHandle(FormName)
   Minimize(H)
Return Nil


*-----------------------------------------------------------------------------*
Function HMG_MakeWindowsClassName ( cForm )
LOCAL ClassName := "_HMG_" + cForm  + "_" + hb_NtoS( GetCurrentThreadID() )
Return ClassName
*-----------------------------------------------------------------------------*


*-----------------------------------------------------------------------------*
Function _DefineWindow ( FormName, Caption, x, y, w, h ,nominimize ,nomaximize ,nosize ,nosysmenu, nocaption , StatusBar , StatusText ,initprocedure ,ReleaseProcedure , MouseDragProcedure ,SizeProcedure , ClickProcedure , MouseMoveProcedure, aRGB , PaintProcedure , noshow , topmost , main , icon , child , fontname , fontsize , NotifyIconName , NotifyIconTooltip , NotifyIconLeftClick , GotFocus , LostFocus , virtualheight , VirtualWidth , scrollleft , scrollright , scrollup , scrolldown , hscrollbox , vscrollbox , helpbutton , maximizeprocedure , minimizeprocedure , cursor , NoAutoRelease , InteractiveCloseProcedure , visible , autorelease , minbutton , maxbutton , sizable , sysmenu , titlebar , cPanelParent , panel )
*-----------------------------------------------------------------------------*
Local i , htooltip , mVar , vscroll , hscroll , BrushHandle , k := 0 , FormHandle, ParentHandle
Local cType, oForm, xTmp
LOCAL hWnd_ToolTip

* Unused Parameters

StatusBar := Nil
StatusText := Nil

DEFAULT x := GetDesktopRealLeft()
DEFAULT y := GetDesktopRealTop()
DEFAULT w := GetDeskTopRealWidth()
DEFAULT h := GetDeskTopRealHeight()

Parenthandle := 0

   If ValType( cPanelParent ) == 'C' .and. panel == .f.

      MsgHMGError("Parent can be specified only for Panel windows. Program Terminated" )

   endif

   If .not. empty( oHmgApp():ActiveFormName ) .and. panel == .f.
      MsgHMGError("Only Panel windows can be defined inside a DEFINE WINDOW...END WINDOW structure. Program Terminated" )
   EndIf

   if valtype(sizable) == "L"
      nosize   := .Not. sizable
   endif

   if valtype(sysmenu) == "L"
      nosysmenu   := .Not. sysmenu
   endif

   if valtype(titlebar) == "L"
      nocaption   := .Not. titlebar
   endif

   if valtype(minbutton) == "L"
      nominimize   := .Not. minbutton
   endif

   if valtype(maxbutton) == "L"
      nomaximize   := .Not. maxbutton
   endif

   if valtype(autorelease) == "L"
      NoAutoRelease   := .Not. AutoRelease
   endif

   if valtype(visible) == "L"
      NoShow   := .Not. Visible
   endif

   if valtype(FormName) == "U"
      FormName := oHmgApp():APP214

      if oHmgApp():APP235 <> -1

         y := oHmgApp():APP235
         x := oHmgApp():APP236
         w := oHmgApp():APP237
         h := oHmgApp():APP238

         oHmgApp():APP235 := -1
         oHmgApp():APP236 := -1
         oHmgApp():APP237 := -1
         oHmgApp():APP238 := -1

      endif

   endif


   if oHmgApp():FrameLevel > 0
      x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
      y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
   EndIf


   FormName := ALLTRIM( FormName )

   if Main

      xTmp := FormByBlock( { | e | e:Type == "A" } )
      i := iif( xTmp == Nil, 0, xTmp:Index )

      IF i != 0
         MsgHMGError("Main Window Already Defined. Program Terminated" )
      ENDIF

      if Child == .T.
         MsgHMGError("Child and Main Clauses Can't Be Used Simultaneously. Program Terminated" )
      Endif

      if NoAutoRelease == .T.
         MsgHMGError("NOAUTORELEASE and MAIN Clauses Can't Be Used Simultaneously. Program Terminated" )
      Endif

//      oHgmApp():APP054 := _GETDDLMESSAGE()

   Else

 IF oHmgApp():MainWindowFirst
      xTmp := FormByBlock( { | e | e:Type == "A" } )
      i := iif( xTmp == Nil, 0, xTmp:Index )
      IF i == Nil
         MsgHMGError("Main Window Not Defined. Program Terminated" )
      ENDIF
ENDIF

      If _IsWindowDefined( FormName )
         MsgHMGError("Window: "+ FormName + " already defined. Program Terminated" )
      endif

      If .Not. Empty ( NotifyIconName )
         MsgHMGError( "Notification Icon Allowed Only in Main Window. Program Terminated" )
      endif

   EndIf

   mVar := '_' + FormName

   if child == .T.
      ParentHandle := oHmgApp():MainHandle
   Else
      ParentHandle := 0
   endif


   if panel == .T.

      If ValType ( cPanelParent ) == 'C'

         if GetWindowType ( cPanelParent ) == 'X'
            MsgHMGError("Panel Windows Can't Have SplitChild Parents. Program Terminated" )
         endif

         ParentHandle := GetFormHandle(cPanelParent)
         oHmgApp():APP240 := .F.

      ElseIf   .Not. Empty( oHmgApp():ActiveFormName )

         if FormByIndex( oHmgApp():ActiveFormName ) == 'X'
            MsgHMGError("panel Windows Can't Have SplitChild Parents. Program Terminated" )
         endif

         ParentHandle := FormByName( oHmgApp():ActiveFormName ):Handle
         oHmgApp():APP240 := .t.
         oHmgApp():APP215 := oHmgApp():ActiveFormName

      Else

         MsgHMGError("Panel Windows Must Have a Parent. Program Terminated" )

      EndIf

   endif

   if valtype(FontName) == "U"
      oHmgApp():APP224 := ""
   Else
      oHmgApp():APP224 := FontName
   Endif

   if valtype(FontSize) == "U"
      oHmgApp():ActiveFontSize := 0
   Else
      oHmgApp():ActiveFontSize := FontSize
   Endif

   if valtype(Caption) == "U"
      Caption := ""
   endif

   if valtype(scrollup) == "U"
      scrollup := ""
   endif
   if valtype(scrolldown) == "U"
      scrolldown := ""
   endif
   if valtype(scrollleft) == "U"
      scrollleft := ""
   endif
   if valtype(scrollright) == "U"
      scrollright := ""
   endif

   if valtype(hscrollbox) == "U"
      hscrollbox := ""
   endif
   if valtype(vscrollbox) == "U"
      vscrollbox := ""
   endif

   if valtype(InitProcedure) == "U"
      InitProcedure := ""
   endif

   if valtype(ReleaseProcedure) == "U"
      ReleaseProcedure := ""
   endif

   if valtype(MouseDragProcedure) == "U"
      MouseDragProcedure := ""
   endif

   if valtype(SizeProcedure) == "U"
      SizeProcedure := ""
   endif

   if valtype(ClickProcedure) == "U"
      ClickProcedure := ""
   endif

   if valtype(MouseMoveProcedure) == "U"
      MouseMoveProcedure := ""
   endif

   if valtype(PaintProcedure) == "U"
      PaintProcedure := ""
   endif

   if valtype(GotFocus) == "U"
      GotFocus := ""
   endif

   if valtype(LostFocus) == "U"
      LostFocus := ""
   endif

   if valtype(VirtualHeight) == "U"
      VirtualHeight   := 0
      vscroll      := .f.
   Else
      If VirtualHeight <= h
         MsgHMGError("DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )
      EndIf

      vscroll      := .t.

   endif

   if valtype(VirtualWidth) == "U"
      VirtualWidth   := 0
      hscroll      := .f.
   Else
      If VirtualWidth <= w
         MsgHMGError("DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )
      EndIf

      hscroll      := .t.

   endif

   if Valtype ( aRGB ) == 'U'
      aRGB := { -1 , -1 , -1 }
   EndIf

   oHmgApp():ActiveFormName := FormName
   oHmgApp():APP264 := .T.

   UnRegisterWindow( HMG_MakeWindowsClassName ( FormName ) )

   IF ValType ( icon ) == 'U' .AND. ! Empty( oHmgApp():DefaultIconName )
      icon := oHmgApp():DefaultIconName
   ENDIF

   BrushHandle := RegisterWindow( icon, HMG_MakeWindowsClassName ( FormName ) , aRGB )

   Formhandle = InitWindow( Caption , x, y, w, h, nominimize, nomaximize, nosize, nosysmenu, nocaption , topmost , HMG_MakeWindowsClassName ( FormName ) , ParentHandle , vscroll , hscroll , helpbutton , panel  )

   If oHmgApp():BeginTabActive = TRUE  .and. Panel == .T.
      aAdd ( oHmgApp():APP142 , Formhandle )
   EndIf

   if Valtype ( cursor ) != "U"
      SetWindowCursor( Formhandle , cursor )
   EndIf

   if Main
      oHmgApp():MainHandle := Formhandle
   EndIf

   if valtype(NotifyIconName) == "U"
      NotifyIconName := ""
   Else
      ShowNotifyIcon( FormHandle , .T. , LoadTrayIcon(GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
   endif

   htooltip := InitToolTip ( FormHandle , oHmgApp():APP055 )

   hWnd_ToolTip := TOOLTIP_INITMENU ( FormHandle , oHmgApp():APP055 )

   If Main

      cType := 'A'

   Else

      If   Child == .T.

              cType := 'C'

      ElseIf   Panel == .T.

         cType := 'P'

      Else

              cType := 'S'

      EndIf

   EndIf

   xTmp := FormByBlock( { | e | e:IsDeleted } )
   k := iif( xTmp == Nil, 0, xTmp:Index )

   IF k < 1
      oForm := oHmgApp():AddForm()
      k := oHmgApp():FormCount()
   ELSE
      oForm := FormByIndex( k )
   ENDIF

      oHmgApp():MainIndex := k

      Public &mVar. := k

      IF Main
         oHmgApp():MainFormIndex := k
      ENDIF

   WITH OBJECT oForm
      :Name := FormName
      :Handle := FormHandle
      :IsActive := .f.
      :Type := cType
      :ParentHandle := If ( panel , Parenthandle , 0 )
      :ReleaseProcedure := ReleaseProcedure
      :InitProcedure := InitProcedure
      :TooltipHandle := htooltip
      :FormContextMenuHandle := 0
      :FORM075 := MouseDragProcedure
      :FORM076 := SizeProcedure
      :FORM077 := ClickProcedure
      :FORM078 := MouseMoveProcedure
      :IsDeleted := .F.
      :FORM079 := aRGB
      :FORM080 := PaintProcedure
      :NoShow := noshow
      :NotifyIconName := NotifyIconName
      :FORM083 := NotifyIconToolTip
      :FORM084 := NotifyIconLeftClick
      :FORM085 := GotFocus
      :FORM086 := LostFocus
      :FORM087 := 0
      :FORM088 := 0
      :FORM089 := {}
      :FORM090 := {}
      :VirtualHeight := VirtualHeight
      :VirtualWidth := VirtualWidth
      :FORM093 := .f.
      :FORM094 := ScrollUp
      :FORM095 := ScrollDown
      :FORM096 := ScrollLeft
      :FORM097 := ScrollRight
      :FORM098 := HScrollBox
      :FORM099 := VScrollBox
      :FORM100 := BrushHandle
      :FORM101 := 0
      :GraphTasks := {}
      :FORM103 := MaximizeProcedure
      :FORM104 := MinimizeProcedure
      :AutoRelease := .Not. NoAutoRelease
      :FORM106 := InteractiveCloseProcedure
      :FORM107 := 0
      :FORM108 := NIL
      :FORM504 := {x, y, w, h}
      :TooltipMenuHandle := hWnd_ToolTip
      :FORM512 := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }
      :StopEventProcedure := .F.
   ENDWITH

   InitDummy(FormHandle)

   If VirtualHeight > 0
      SetScrollRange ( Formhandle , SB_VERT , 0 , VirtualHeight - h , .T. )
   EndIf
   If VirtualWidth > 0
      SetScrollRange ( Formhandle , SB_HORZ , 0 , VirtualWidth - w , .T. )
   EndIf

   if valtype ( oHmgApp():APP056 ) = 'A'
      if HMG_LEN ( oHmgApp():APP056 ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( oHmgApp():APP056 [1] , oHmgApp():APP056 [2] , oHmgApp():APP056 [3] ), 0)
      endif
   endif

   if valtype ( oHmgApp():APP057 ) = 'A'
      if HMG_LEN ( oHmgApp():APP057 ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( oHmgApp():APP057 [1] , oHmgApp():APP057 [2] , oHmgApp():APP057 [3] ), 0)
      endif
   endif

   oForm := FormByIndex( GetFormIndex( FormName ) )
   oForm:FORM512[ 7 ] := oHmgApp():APP055
   SetToolTipCustomDrawForm ( FormName )

Return (FormHandle)
*-----------------------------------------------------------------------------*
Function _DefineModalWindow ( FormName, Caption, x, y, w, h, Parent ,nosize ,nosysmenu, nocaption , StatusBar , StatusText ,InitProcedure, ReleaseProcedure , MouseDragProcedure , SizeProcedure , ClickProcedure , MouseMoveProcedure, aRGB , PaintProcedure , icon , FontName , FontSize , GotFocus , LostFocus , virtualheight , VirtualWidth , scrollleft , scrollright , scrollup , scrolldown  , hscrollbox , vscrollbox , helpbutton , cursor , noshow  , NoAutoRelease  , InteractiveCloseProcedure , visible , autorelease , sizable , sysmenu , titlebar , lLittleTitle )
*-----------------------------------------------------------------------------*
Local i , htooltip , mVar , vscroll , hscroll , BrushHandle , k := 0
Local FormHandle, oForm, xTmp
LOCAL hWnd_ToolTip

* Unused Parameters

StatusBar := Nil
StatusText := Nil


DEFAULT x := GetDesktopRealLeft()
DEFAULT y := GetDesktopRealTop()
DEFAULT w := GetDeskTopRealWidth()
DEFAULT h := GetDeskTopRealHeight()



   if valtype(titlebar) == "L"
      NoCaption := .Not. TitleBar
   endif

   if valtype(sysmenu) == "L"
      NoSysMenu := .Not. sysmenu
   endif



   if valtype(sizable) == "L"
      NoSize := .Not. Sizable
   endif


   if valtype(visible) == "L"
      NoShow := .Not. Visible
   endif


   if valtype(autorelease) == "L"
      NoAutoRelease := .Not. autorelease
   endif


   if valtype(FormName) == "U"
      FormName := oHmgApp():APP214
   endif

IF oHmgApp():MainWindowFirst
   xTmp := FormByBlock( { | e | e:Type == "A" } )
   i := iif( xTmp == Nil, 0, xTmp:Index )
   IF i == Nil
      MsgHMGError("Main Window Not Defined. Program Terminated" )
   ENDIF
ENDIF

   If _IsWindowDefined (FormName)
      MsgHMGError("Window: "+ FormName + " already defined. Program Terminated" )
   endif

   mVar := '_' + FormName

   if valtype(FontName) == "U"
      oHmgApp():APP224 := ""
   Else
      oHmgApp():APP224 := FontName
   Endif

   if valtype(FontSize) == "U"
      oHmgApp():ActiveFontSize := 0
   Else
      oHmgApp():ActiveFontSize := FontSize
   Endif

   if valtype(Caption) == "U"
      Caption := ""
   endif

   if valtype(InitProcedure) == "U"
      InitProcedure := ""
   endif

   if valtype(PaintProcedure) == "U"
      PaintProcedure := ""
   endif

   if valtype(ReleaseProcedure) == "U"
      ReleaseProcedure := ""
   endif

   if valtype(MouseDragProcedure) == "U"
      MouseDragProcedure := ""
   endif

   if valtype(SizeProcedure) == "U"
      SizeProcedure := ""
   endif

   if valtype(ClickProcedure) == "U"
      ClickProcedure := ""
   endif

   if valtype(MouseMoveProcedure) == "U"
      MouseMoveProcedure := ""
   endif

   if valtype(GotFocus) == "U"
      GotFocus := ""
   endif

   if valtype(LostFocus) == "U"
      LostFocus := ""
   endif

   if valtype(scrollup) == "U"
      scrollup := ""
   endif
   if valtype(scrolldown) == "U"
      scrolldown := ""
   endif
   if valtype(scrollleft) == "U"
      scrollleft := ""
   endif
   if valtype(scrollright) == "U"
      scrollright := ""
   endif

   if valtype(hscrollbox) == "U"
      hscrollbox := ""
   endif
   if valtype(vscrollbox) == "U"
      vscrollbox := ""
   endif

   if valtype(VirtualHeight) == "U"
      VirtualHeight   := 0
      vscroll      := .f.
   Else
      If VirtualHeight <= h
         MsgHMGError("DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )
      EndIf

      vscroll      := .t.

   endif

   if valtype(VirtualWidth) == "U"
      VirtualWidth   := 0
      hscroll      := .f.
   Else
      If VirtualWidth <= w
         MsgHMGError("DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )

      EndIf

      hscroll      := .t.

   endif

   if Valtype ( aRGB ) == 'U'
      aRGB := { -1 , -1 , -1 }
   EndIf

   If oHmgApp():APP109 <> 0
      Parent := oHmgApp():APP109
   Else
      Parent = oHmgApp():MainHandle
   EndIf

   oHmgApp():ActiveFormName := FormName
   oHmgApp():APP264 := .T.

   UnRegisterWindow( HMG_MakeWindowsClassName ( FormName ) )

   IF ValType ( icon ) == 'U' .AND. ! Empty( oHmgApp():DefaultIconName )
      icon := oHmgApp():DefaultIconName
   ENDIF

   BrushHandle := RegisterWindow( icon, HMG_MakeWindowsClassName ( FormName ) , aRGB )

   Formhandle = InitModalWindow ( Caption , x, y, w, h , Parent ,nosize ,nosysmenu, nocaption , HMG_MakeWindowsClassName ( FormName ) , vscroll , hscroll , helpbutton , lLittleTitle )

   if Valtype ( cursor ) != "U"
      SetWindowCursor( Formhandle , cursor )
   EndIf

   htooltip := InitToolTip ( NIL , oHmgApp():APP055 )

   hWnd_ToolTip := TOOLTIP_INITMENU ( NIL , oHmgApp():APP055 )

   xTmp := FormByBlock( { | e | e:IsDeleted } )
   K    := iif( xTmp == Nil, 0, xTmp:Index )

   if k < 1
      oForm := oHmgApp():AddForm()
      k := oHmgApp():FormCount()
   ELSE
      oForm := FormByIndex( k )
   ENDIF

   Public &mVar. := k

   WITH OBJECT oForm
      :Name                  := FormName
      :Handle                := FormHandle
      :IsActive              := .f.
      :Type                  := "M"
      :ParentHandle          := Parent
      :ReleaseProcedure      := ReleaseProcedure
      :InitProcedure         := InitProcedure
      :TooltipHandle         := htooltip
      :FormContextMenuHandle := 0
      :FORM075 :=  MouseDragProcedure
      :FORM076 :=  SizeProcedure
      :FORM077 :=  ClickProcedure
      :FORM078 :=  MouseMoveProcedure
      :IsDeleted             := .F.
      :FORM079 :=  aRGB
      :FORM080 :=  PaintProcedure
      :NoShow :=  noshow
      :NotifyIconName :=  ''
      :FORM083 :=  ''
      :FORM084 :=  ''
      :FORM085 :=  GotFocus
      :FORM086 :=  LostFocus
      :FORM087 :=  0
      :FORM088 :=  0
      :FORM089 :=  {}
      :FORM090               :=  {}
      :VirtualHeight         := VirtualHeight
      :VirtualWidth          := VirtualWidth
      :FORM093               := .f.
      :FORM094               := ScrollUp
      :FORM095               := ScrollDown
      :FORM096               := ScrollLeft
      :FORM097               := ScrollRight
      :FORM098               := HScrollBox
      :FORM099               := VScrollBox
      :FORM100               := BrushHandle
      :FORM101               := 0
      :GraphTasks            := {}
      :FORM103               := Nil
      :FORM104               := Nil
      :AutoRelease           := .Not. NoAutoRelease
      :FORM106               := InteractiveCloseProcedure
      :FORM107               := 0
      :FORM108               := NIL
      :FORM504               := {x, y, w, h}
      :TooltipMenuHandle     := hWnd_ToolTip
      :FORM512               := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }
      :StopEventProcedure    := .F.
   ENDWITH

   InitDummy(FormHandle)

   If VirtualHeight > 0
      SetScrollRange ( Formhandle , SB_VERT , 0 , VirtualHeight - h , .T. )
   EndIf
   If VirtualWidth > 0
      SetScrollRange ( Formhandle , SB_HORZ , 0 , VirtualWidth - w , .T. )
   EndIf

   if valtype ( oHmgApp():APP056 ) = 'A'
      if HMG_LEN ( oHmgApp():APP056 ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( oHmgApp():APP056 [1] , oHmgApp():APP056 [2] , oHmgApp():APP056 [3] ), 0)
      endif
   endif

   if valtype ( oHmgApp():APP057 ) = 'A'
      if HMG_LEN ( oHmgApp():APP057 ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( oHmgApp():APP057 [1] , oHmgApp():APP057 [2] , oHmgApp():APP057 [3] ), 0)
      endif
   endif

   oForm := FormByIndex( GetFormIndex( FormName ) )
   oForm:FORM512[ 7 ] := oHmgApp():APP055
   SetToolTipCustomDrawForm ( FormName )

Return (FormHandle)

*-----------------------------------------------------------------------------*
Function _DefineSplitChildWindow ( FormName , w , h , break , grippertext  , nocaption , title , fontname , fontsize , gotfocus , lostfocus , virtualheight , VirtualWidth , Focused , scrollleft , scrollright , scrollup , scrolldown  , hscrollbox , vscrollbox , cursor , titlebar , PaintProcedure )
*-----------------------------------------------------------------------------*
Local i , htooltip , mVar , ParentForm , hscroll , BrushHandle , k := 0
Local FormHandle , vscroll
LOCAL hWnd_ToolTip, oForm, xTmp

DEFAULT w := GetDeskTopRealWidth()
DEFAULT h := GetDeskTopRealHeight()

   if valtype(titlebar) == "L"
      NoCaption := .Not. TitleBar
   endif

   if valtype(FormName) == "U"
      FormName := oHmgApp():APP214
   endif

IF oHmgApp():MainWindowFirst
   xTmp := FormByBlock( { | e | e:Type == "A" } )
   i := iif( xTmp == Nil, 0, xTmp:Index )
   IF i == Nil
      MsgHMGError("Main Window Not Defined. Program Terminated" )
   ENDIF
ENDIF

   IF _IsWindowDefined (FormName)
      MsgHMGError("Window: "+ FormName + " already defined. Program Terminated" )
   ENDIF

   If oHmgApp():APP262 == .F.
      MsgHMGError("SplitChild Windows Can be Defined Only Inside SplitBox. Program terminated" )
   EndIf

   if valtype(FontName) == "U"
      oHmgApp():APP224 := ""
   Else
      oHmgApp():APP224 := FontName
   Endif

   if valtype(FontSize) == "U"
      oHmgApp():ActiveFontSize := 0
   Else
      oHmgApp():ActiveFontSize := FontSize
   Endif

   if valtype(VirtualHeight) == "U"
      VirtualHeight   := 0
      vscroll      := .f.
   Else
      If VirtualHeight <= h
         MsgHMGError("DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )

      EndIf

      vscroll      := .t.

   endif

   if valtype(VirtualWidth) == "U"
      VirtualWidth   := 0
      hscroll      := .f.
   Else
      If VirtualWidth <= w
         MsgHMGError("DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )

      EndIf

      hscroll      := .t.

   endif

   oHmgApp():APP260 := .t.

   ParentForm := oHmgApp():ActiveFormName

   mVar := '_' + FormName

   oHmgApp():APP215 := oHmgApp():ActiveFormName

   oHmgApp():ActiveFormName := FormName
   oHmgApp():APP264 := .T.

   UnRegisterWindow( HMG_MakeWindowsClassName ( FormName ) )
   BrushHandle := RegisterSplitChildWindow( "", HMG_MakeWindowsClassName ( FormName ) , {-1,-1,-1} )

   i := GetFormIndex ( ParentForm )

   if i > 0

      Formhandle := InitSplitChildWindow ( w , h , HMG_MakeWindowsClassName ( FormName ) , nocaption , title , 0 , vscroll , hscroll )

      if Valtype ( cursor ) != "U"
         SetWindowCursor( Formhandle , cursor )
      EndIf

      If oHmgApp():APP216 == 'TOOLBAR' .And. oHmgApp():APP258 == .F.
         Break := .T.
      EndIf

      AddSplitBoxItem ( FormHandle , FormByIndex( I ):FORM087 , w , break , grippertext ,  ,  , oHmgApp():APP258 )

      oHmgApp():APP216   := 'SPLITCHILD'

   EndIf

   if valtype(scrollup) == "U"
      scrollup := ""
   endif
   if valtype(scrolldown) == "U"
      scrolldown := ""
   endif
   if valtype(scrollleft) == "U"
      scrollleft := ""
   endif
   if valtype(scrollright) == "U"
      scrollright := ""
   endif

   if valtype(hscrollbox) == "U"
      hscrollbox := ""
   endif
   if valtype(vscrollbox) == "U"
      vscrollbox := ""
   endif

   htooltip := InitToolTip (FormHandle , oHmgApp():APP055  )

   hWnd_ToolTip := TOOLTIP_INITMENU ( FormHandle , oHmgApp():APP055 )

   xTmp := FormByBlock( { | e | e:IsDeleted } )
   K := iif( xTmp == Nil, 0, xTmp:Index )

   if k < 1
      oForm := oHmgApp():AddForm()
      k := oHmgApp():FormCount()
   ELSE
      oForm := FormByIndex( k )
   ENDIF

      Public &mVar. := k
      oHmgApp():APP171 := k

   WITH OBJECT oForm
      :Name := FormName
      :Handle :=  FormHandle
      :IsActive :=  .f.
      :Type :=  'X'
      :ParentHandle :=  GetFormHandle(ParentForm)
      :ReleaseProcedure :=  ""
      :InitProcedure :=  ""
      :TooltipHandle :=  hToolTip
      :FormContextMenuHandle :=  0
      :FORM075 :=  ""
      :FORM076 :=  ""
      :FORM077 :=  ""
      :FORM078 :=  ""
      :IsDeleted := .F.
      :FORM079 := Nil
      :FORM080 :=  PaintProcedure
      :NoShow := .f.
      :NotifyIconName :=  ""
      :FORM083 :=  ""
      :FORM084 :=  ""
      :FORM085 := gotfocus
      :FORM086 :=     lostfocus
      :FORM087 :=  0
      :FORM088 :=     0
      :FORM089 :=     {}
      :FORM090 :=     {}
      :VirtualHeight :=     VirtualHeight
      :VirtualWidth  :=     VirtualWidth
      :FORM093 :=     Focused
      :FORM094 :=     ScrollUp
      :FORM095 :=     ScrollDown
      :FORM096 :=     ScrollLeft
      :FORM097 :=     ScrollRight
      :FORM098 :=     HScrollBox
      :FORM099 :=     VScrollBox
      :FORM100 :=     BrushHandle
      :FORM101 :=     0
      :GraphTasks :=     {}
      :FORM103 :=     Nil
      :FORM104 :=     Nil
      :AutoRelease :=  .T.
      :FORM106 :=  ""
      :FORM107 := 0
      :FORM108 := NIL
      :FORM504 := {NIL, NIL, NIL, NIL}
      :TooltipMenuHandle := hWnd_ToolTip
      :FORM512 := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }
   ENDWITH

      oForm:StopEventProcedure := .F.

   InitDummy(FormHandle)

   aAdd ( FormByIndex( I ):FORM090 , oHmgApp():APP171 )

   If VirtualHeight > 0
      SetScrollRange ( Formhandle , SB_VERT , 0 , VirtualHeight - h , .T. )
   EndIf
   If VirtualWidth > 0
      SetScrollRange ( Formhandle , SB_HORZ , 0 , VirtualWidth - w , .T. )
   EndIf

   if valtype ( oHmgApp():APP056 ) = 'A'
      if HMG_LEN ( oHmgApp():APP056 ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( oHmgApp():APP056 [1], oHmgApp():APP056 [2] , oHmgApp():APP056 [3] ), 0)
      endif
   endif

   if valtype ( oHmgApp():APP057 ) = 'A'
      if HMG_LEN ( oHmgApp():APP057 ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( oHmgApp():APP057 [1] , oHmgApp():APP057 [2] , oHmgApp():APP057 [3] ), 0)
      endif
   endif

   oForm := FormByIndex( GetFormIndex( FormName ) )
   oForm:FORM512[ 7 ] := oHmgApp():APP055
   SetToolTipCustomDrawForm ( FormName )

Return (FormHandle)



*-----------------------------------------------------------------------------*
Function _SetWindowSizePos ( FormName , row , col , width , height )
*-----------------------------------------------------------------------------*
local hWnd, hParent, nIndex, actpos:={0,0,0,0}

   IF ValType (FormName) == "N"
      hWnd := FormName
   ELSE
      hWnd := GetFormHandle(FormName)
   ENDIF

   GetWindowRect (hWnd, actpos)
   col    := if ( col    == NIL, actpos[1],           col    )
   row    := if ( row    == NIL, actpos[2],           row    )
   width  := if ( width  == NIL, actpos[3]-actpos[1], width  )
   height := if ( height == NIL, actpos[4]-actpos[2], height )

   nIndex := GetFormIndexByHandle (hWnd)
   IF nIndex > 0 .AND. GetFormTypeByIndex ( nIndex ) == "P"   // Panel Window,   ADD (May 2015, Fixed January 2016)
      hParent := FormByIndex( nIndex ):ParentHandle
      ScreenToClient (hParent, @col, @row)
   ENDIF

   MoveWindow (hWnd, col, row, width, height, .T.)
Return Nil


*-----------------------------------------------------------------------------*
Function _GetWindowSizePos ( FormName )   //   ADD   May 2015
*-----------------------------------------------------------------------------*
local hWnd, hParent, nIndex, actpos:={0,0,0,0}
local row, col, width, height

   IF ValType (FormName) == "N"
      hWnd := FormName
   ELSE
      hWnd := GetFormHandle(FormName)
   ENDIF

   GetWindowRect (hWnd, actpos)
   col    := actpos[1]
   row    := actpos[2]
   width  := actpos[3]-actpos[1]
   height := actpos[4]-actpos[2]

   nIndex := GetFormIndexByHandle (hWnd)
   IF GetFormTypeByIndex ( nIndex ) == "P"   // Panel Window
      hParent := FormByIndex( nIndex ):FormParent
      ScreenToClient (hParent, @col, @row)
   ENDIF

Return {row, col, width, height}



*-----------------------------------------------------------------------------*
Function GetFormIndex (FormName)
*-----------------------------------------------------------------------------*
Local mVar

   mVar := '_' + FormName

Return ( &mVar )
*-----------------------------------------------------------------------------*
Function _SetNotifyIconName ( FormName , IconName )
*-----------------------------------------------------------------------------*
Local i

   i := GetFormIndex ( FormName )

   ChangeNotifyIcon(  FormByIndex( i ):Handle , LoadTrayIcon(GETINSTANCE(), IconName ) , FormByIndex( I ):FORM083 )

   FormByIndex( I ):NotifyIconName := IconName

Return Nil
*-----------------------------------------------------------------------------*
Function _SetNotifyIconTooltip ( FormName , TooltipText )
*-----------------------------------------------------------------------------*
Local i

   i := GetFormIndex ( FormName )

   ChangeNotifyIcon( FormByIndex( i ):Handle , LoadTrayIcon(GETINSTANCE(), FormByIndex( I ):NotifyIconName ) , TooltipText )

   FormByIndex( I ):FORM083 := TooltipText

Return Nil
*-----------------------------------------------------------------------------*
Function _GetNotifyIconName ( FormName )
*-----------------------------------------------------------------------------*
Local i

   i := GetFormIndex ( FormName )

Return FormByIndex( I ):FORM082
*-----------------------------------------------------------------------------*
Function _GetNotifyIconTooltip ( FormName )
*-----------------------------------------------------------------------------*
Local i

   i := GetFormIndex ( FormName )

Return FormByIndex( I ):FORM083

*-----------------------------------------------------------------------------*
Function _DefineSplitBox ( ParentForm, bottom , inverted )
*-----------------------------------------------------------------------------*
Local i,cParentForm,Controlhandle

   if oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName()
   endif

   if oHmgApp():FrameLevel > 0
      MsgHMGError("SPLITBOX can't be defined inside Tab control. Program terminated" )
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If oHmgApp():APP260 == .T.
      MsgHMGError("SplitBox Can't Be Defined inside SplitChild Windows. Program terminated" )
   EndIf

   If oHmgApp():APP262 == .T.
      MsgHMGError("SplitBox Controls Can't Be Nested. Program terminated" )
   EndIf

   oHmgApp():APP258 := Inverted

   oHmgApp():APP262 := .T.

   oHmgApp():APP222 := ParentForm

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   ControlHandle := InitSplitBox ( ParentForm, bottom , inverted )

   i := GetFormIndex ( cParentForm )

   if i > 0
      FormByIndex( I ):FORM087 := ControlHandle
   EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _EndSplitBox ()
*-----------------------------------------------------------------------------*

   oHmgApp():APP216   := 'TOOLBAR'

   oHmgApp():APP262 := .F.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndSplitChildWindow ()
*-----------------------------------------------------------------------------*

   oHmgApp():ActiveFormName := oHmgApp():APP215
   oHmgApp():APP260 := .f.
   FormByIndex( oHmgApp():APP171 ):IsActive := .t.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndPanelWindow ()
*-----------------------------------------------------------------------------*

   oHmgApp():ActiveFormName := oHmgApp():APP215
   oHmgApp():APP240 := .f.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndWindow ()
*-----------------------------------------------------------------------------*

   oHmgApp():APP344 := oHmgApp():ActiveFormName

   If oHmgApp():APP260 == .t.
      _EndSplitChildWindow ()

   ElseIf   oHmgApp():APP240 == .T.
      _EndPanelWindow ()

   Else
      oHmgApp():APP264 := .F.
      oHmgApp():ActiveFormName := ""
   EndIf

Return Nil


// Pablo César (January 2015)
*-----------------------------------------------------------------------------*
Function InputBox ( cInputPrompt , cWindowTitle , cDefaultValue , nTimeout , cTimeoutValue , lMultiLine , nWidth )
*-----------------------------------------------------------------------------*
Local RetVal , mo

DEFAULT cInputPrompt   := ""
DEFAULT cWindowTitle   := ""
DEFAULT cDefaultValue  := ""

If !(nWidth=Nil)
   If nWidth<350
      nWidth:=350
   Endif
Endif

RetVal := ''

If ValType (lMultiLine) != 'U'
    If lMultiLine == .T.
        mo := 150
    Else
        mo := 0
    EndIf
Else
    mo := 0
EndIf

DEFINE WINDOW _InputBox                ;
    AT 0,0                             ;
    WIDTH If(nWidth=Nil, 350, nWidth)  ;
    HEIGHT 115 + mo + GetTitleHeight() ;
    TITLE cWindowTitle                 ;
    MODAL                              ;
    NOSIZE                             ;
    FONT 'Arial'                       ;
    SIZE 10

    ON KEY CONTROL+W ACTION ( oHmgApp():APP257 := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )
    ON KEY ESCAPE ACTION ( oHmgApp():APP257 := .T. , _InputBox.Release )

    @ 07,10 LABEL _Label    ;
        VALUE cInputPrompt  ;
        WIDTH 280

    If ValType (lMultiLine) != 'U' .and. lMultiLine == .T.
       @ 30,10 EDITBOX _TextBox ;
            VALUE cDefaultValue ;
            HEIGHT 26 + mo      ;
            WIDTH If(nWidth=Nil, 320, nWidth-30)
    else
        @ 30,10 TEXTBOX _TextBox                 ;
            VALUE cDefaultValue                  ;
            HEIGHT 26 + mo                       ;
            WIDTH If(nWidth=Nil, 320, nWidth-30) ;
            ON ENTER ( oHmgApp():APP257 := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )
    endif

    @ 67+mo,If(nWidth=Nil, 120, (nWidth/2)-10-100) BUTTON _Ok        ;
        CAPTION oHmgApp():APP128 [8]                             ;
        ACTION ( oHmgApp():APP257 := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )

    @ 67+mo,If(nWidth=Nil, 230, (nWidth/2)+10) BUTTON _Cancel        ;
        CAPTION oHmgApp():APP128 [7]                             ;
        ACTION   ( oHmgApp():APP257 := .T. , _InputBox.Release )

    If ValType (nTimeout) != 'U'
        If ValType (cTimeoutValue) != 'U'
            DEFINE TIMER _InputBox ;
            INTERVAL nTimeout ;
            ACTION  ( RetVal := cTimeoutValue , _InputBox.Release )
        Else
            DEFINE TIMER _InputBox ;
            INTERVAL nTimeout ;
            ACTION _InputBox.Release
        EndIf
    EndIf
END WINDOW
_InputBox._TextBox.SetFocus
CENTER WINDOW _InputBox
ACTIVATE WINDOW _InputBox
Return ( RetVal )


*-----------------------------------------------------------------------------*
Function _SetWindowRgn(name,col,row,w,h,lx)
*-----------------------------------------------------------------------------*
local lhand:=0

      lhand := GetFormHandle ( name )

      c_SetWindowRgn(lhand,col,row,w,h,lx)

Return Nil
*-----------------------------------------------------------------------------*
Function _SetPolyWindowRgn(name,apoints,lx)
*-----------------------------------------------------------------------------*
local lhand:=0,apx:={},apy:={}

      lhand := GetFormHandle ( name )

      aeval(apoints,{|x| aadd(apx,x[1]), aadd(apy,x[2])})

      c_SetPolyWindowRgn(lhand,apx,apy,lx)

Return Nil
*-----------------------------------------------------------------------------*
Procedure _SetNextFocus()
*-----------------------------------------------------------------------------*
Local i , NextControlHandle := 0, oControlI

   NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .F. )
   oControlI := ControlByHandle( NextControlHandle )
   i := iif( oControlI == Nil, 0, oControlI:Index )

   if i > 0
      If ControlByIndex( i ):Type == 'BUTTON'
         setfocus( NextControlHandle )
         SendMessage ( NextControlHandle , BM_SETSTYLE , LOWORD ( BS_DEFPUSHBUTTON ) , 1 )
      Else
         InsertTab()
      EndIf
   Else
      InsertTab()
   EndIf

Return


*-----------------------------------------------------------------------------------------------------*
Function _ActivateWindow ( aForm, lActivateMsgLoop, lNotExitAppAtCloseForm )
*-----------------------------------------------------------------------------------------------------*
__THREAD STATIC IsInstallHook := .F., IsLoopMessageActive := .F.
Local I , z , MainFound := .F.
local nForm := HMG_LEN( aForm )
Local FormName
Local VisibleModalCount := 0
Local VisibleModalName := ''
Local TmpId
Local FormCount := oHmgApp():FormCount
Local nLastWindowIndex := 0
Local x
LOCAL oFormX, oFormI

   DEFAULT lActivateMsgLoop            TO .T.
   DEFAULT lNotExitAppAtCloseForm      TO .F.

   If oHmgApp():ThisEventType == 'WINDOW_RELEASE'
      MsgHMGError("ACTIVATE WINDOW: activate windows within an 'on release' window procedure is not allowed. Program terminated" )
   EndIf

   If oHmgApp():APP264 = .T.
      MsgHMGError("ACTIVATE WINDOW: DEFINE WINDOW Structure is not closed. Program terminated" )
   Endif

   If oHmgApp():ThisEventType == 'WINDOW_GOTFOCUS'
      MsgHMGError("ACTIVATE WINDOW / Activate(): Not allowed in window's GOTFOCUS event procedure. Program terminated" )
   Endif

   If oHmgApp():ThisEventType == 'WINDOW_LOSTFOCUS'
      MsgHMGError("ACTIVATE WINDOW / Activate(): Not allowed in window's LOSTFOCUS event procedure. Program terminated" )
   Endif

   * Look For Main Window

   For z := 1 to nForm
      FormName := aForm [ z ]
      i := GetFormIndex (FormName)
      if FormByIndex( i ):Type == 'A'
         MainFound := .T.
         Exit
      EndIf
   Next z

   // Main Check

   // Dr. Claudio Soto (August 2013)
   IF oHmgApp():MainWindowFirst
      If oHmgApp():APP263 == .F.   // _HMG_IsMainFormActive
         If MainFound == .F.
            MsgHMGError("ACTIVATE WINDOW: Main Window Must be Activated In First ACTIVATE WINDOW Command. Program terminated" )
         EndIf
      Else
         If MainFound == .T.
            MsgHMGError("ACTIVATE WINDOW: Main Window Already Active. Program terminated" )
         EndIf
      EndIf
   ENDIF

   // Dr. Claudio Soto (July 2013)
   IF IsInstallHook == .F.
      IF HMG_HOOK_INSTALL() == .F.
         MsgHMGError("Error in the Installation of the Hooks that process the Keyboard Events")
      ENDIF
      IsInstallHook := .T.
   ENDIF


   nLastWindowIndex := GetFormIndex( aForm [nForm] )

   // Set Main Active Public Flag

   If MainFound == .T.
      oHmgApp():APP263 := .T.

      * Create Wait Window, add to form array and increment form counter

      InitWaitWindow()

      aadd ( aForm , '_HMG_CHILDWAITWINDOW'   )

      nForm+= 1

   EndIf

   If nForm > 1

      If oHmgApp():IsModalActive
         MsgHMGError("Multiple Activation can be used when a modal window is active. Program Terminated" )
      Endif

      TmpId := _GenActivateId(nForm)

      For z := 1 to nForm

         FormName := aForm[ z ]

         If .Not. _IsWindowDefined (Formname)
            MsgHMGError("Window: "+ FormName + " is not defined. Program terminated" )
         Endif

         If _IsWindowActive (FormName)
            MsgHMGError("Window: "+ FormName + " already active. Program terminated" )
         Endif

         If GetWindowType ( FormName ) == 'P'
            MsgHMGError("Panel Windows can't be explicity activated (They are activated via its parent). Program terminated" )
         EndIf

         i := GetFormIndex ( FormName )

         FOR EACH oFormX IN oHmgApp():AllForms

                 if oFormX:Type == 'P' .and. ;
                    oFormx:ParentHandle == oFormI:Handle

               _ShowWindow ( oFormX:Name )

               _SetActivationFlag( oFormX:Index )
               _ProcessInitProcedure( oFormX:Index )
               _RefreshDataControls( oFormX:Index )

               If _SetFocusedSplitChild( oFormX:Index ) == .f.
                  _SetActivationFocus( oFormX:Index )
               endif

            endif

         next


         * Only One Visible Modal is Allowed

         if FormByIndex( i ):Type == "M" .and. FormByIndex( I ):NoShow == .F.
            VisibleModalCount++
            VisibleModalName := FormByIndex( i ):Name
            if VisibleModalCount > 1
               MsgHMGError("ACTIVATE WINDOW: Only one initially visible modal window allowed. Program terminated" )
            EndIf
         Endif

         * Set Activate Id

         FormByIndex( I ):FORM107 := TmpId

         * If NOSHOW Is Not Specified, Show The Window.

         If FormByIndex( I ):NoShow == .F.
                      ShowWindow( FormByIndex( i ):Handle )
         EndIf

         _SetActivationFlag(i)
         _ProcessInitProcedure(i)
         _RefreshDataControls(i)

      Next z

      * If Specified, Execute Show Method For Visible Modal
      * If Not, Process Focus For Last Window In The List

      If VisibleModalCount == 1
         _ShowWindow ( VisibleModalName )
      Else
         If _SetFocusedSplitChild(nLastWindowIndex) == .f.
            _SetActivationFocus(nLastWindowIndex)
         Endif

      EndIf

   Else

      FormName := aForm[ 1 ]

      If .Not. _IsWindowDefined (Formname)
         MsgHMGError("Window: "+ FormName + " is not defined. Program terminated" )
      Endif

      If _IsWindowActive (FormName)
         MsgHMGError("Window: "+ FormName + " already active. Program terminated" )
      Endif

      If GetWindowType ( FormName ) == 'P'
         MsgHMGError("Panel Windows can't be explicity activated (They are activated via its parent). Program terminated" )
      EndIf

      i := GetFormIndex ( FormName )
      oFormI := FormByIndex( i )

      FormCount := oHmgApp():FormCount

      for x := 1 to FormCount
         oFormX := FormByIndex( x )

              if oFormX:Type == 'P' .and. ;
                 oFormX:ParentHandle == oFormI:Handle

            _ShowWindow ( oFormX:Name )

            _SetActivationFlag( oFormx:Index )
            _ProcessInitProcedure( oFormx:Index )
            _RefreshDataControls( oFormX:Index )

            If _SetFocusedSplitChild( oFormX:Index ) == .f.
               _SetActivationFocus( oFormX:Index )
            endif

         endif

      next x

      if oFormI:Type == "M"

         _ShowWindow ( oFormI:Name )

         _SetActivationFlag( oFormI:Index )
         _ProcessInitProcedure( oFormI:Index )
         _RefreshDataControls( oFormI:Index )

      Else
         If OhMGaPP():IsModalActive .AND. lActivateMsgLoop == .T.   // for HMG Debugger (by Dr. Claudio Soto, May 2016)
            MsgHMGError("Non Modal Windows can't be activated when a modal window is active. " + Formname +" Program Terminated" )
         endif

         If FormByIndex( I ):NoShow == .F.
            ShowWindow( GetFormHandle(FormName) )
         EndIf

         _SetActivationFlag( oFormI:Index )
         _ProcessInitProcedure( oFormI:Index )
         _RefreshDataControls( oFormI:Index )

         If _SetFocusedSplitChild( oFormI:Index ) == .f.
            _SetActivationFocus( oFormI:Index )
         endif

      Endif

   Endif


   IF lActivateMsgLoop == .T.                         // for HMG Debugger (by Dr. Claudio Soto, June 2015)
      DoMessageLoop()   // Start The Message Loop
   ENDIF

   IF nForm == 1 .AND. lNotExitAppAtCloseForm == .T.  // for HMG Debugger (by Dr. Claudio Soto, June 2015)
      i := GetFormIndex( FormName )
      FormByIndex( i ):FORM107 := _GenActivateId( nForm + 1 )
   ENDIF


Return Nil


*-----------------------------------------------------------------------------*
Function _ActivateAllWindows
*-----------------------------------------------------------------------------*
Local i
Local nFormCount := oHmgApp():FormCount
Local aFormList := {}
Local MainName := ''
LOCAL oForm

   * If Already Active Windows Abort Command

   IF FormByBlock( { | e | e:IsActive }:Index ) != Nil
      MsgHMGError("ACTIVATE WINDOW ALL: This Command Should Be Used At Application Startup Only. Program terminated" )
   ENDIF

   * Force NoShow And NoAutoRelease Styles For Non Main Windows
   * Excepting SplitChild and Panel
   * ( Force AutoRelease And Visible For Main )

   FOR i := 1 TO nFormCount
      oForm := FormByIndex( i )
      If ! oForm:IsDeleted
         If   oForm:Type != 'X' .AND. oForm:Type != "P"
            if oForm:Type == 'A'
               FormByIndex( I ):NoShow := .F.
               oForm:AutoRelease := .T.
               MainName := oForm:Name
            ELse
               FormByIndex( I ):NoShow := .T.
               oForm:AutoRelease := .F.
               aadd ( aFormList , oForm:Name )
            EndIf
         EndIf
      EndIf
   Next i

   aadd ( aFormList, MainName )

   * Check For Error And Call Activate Window Command

   if oHmgApp():FormCount > 0
      If Empty ( MainName )
         MsgHMGError("ACTIVATE WINDOW ALL: Main Window Not Defined. Program terminated" )
      EndIf
      _ActivateWindow ( aFormList )
   Else
      MsgHMGError("ACTIVATE WINDOW ALL: No Windows Defined. Program terminated" )
   EndIf

Return Nil
*------------------------------------------------------------------------------*
Procedure _PushEventInfo
*------------------------------------------------------------------------------*

   aadd ( oHmgApp():aEventInfo , { oHmgApp():ThisFormIndex , oHmgApp():ThisEventType , oHmgApp():ThisType , oHmgApp():ThisControlIndex , oHmgApp():ThisFormName , oHmgApp():ThisControlName } )

Return

*------------------------------------------------------------------------------*
Procedure _PopEventInfo
*------------------------------------------------------------------------------*
Local l

   l := Len( oHmgApp():aEventInfo )

   if l > 0

      oHmgApp():ThisFormIndex   := oHmgApp():aEventInfo [l] [1]
      oHmgApp():ThisEventType    := oHmgApp():aEventInfo [l] [2]
      oHmgApp():ThisType    := oHmgApp():aEventInfo [l] [3]
      oHmgApp():ThisControlIndex := oHmgApp():aEventInfo [l] [4]
      oHmgApp():ThisFormName    := oHmgApp():aEventInfo [l] [5]
      oHmgApp():ThisControlName    := oHmgApp():aEventInfo [l] [6]

      asize ( oHmgApp():aEventInfo , l-1 )

   Else

      oHmgApp():ThisControlIndex := 0    // oHmgApp():APP203 -> _HMG_ThisIndex
      oHmgApp():ThisFormIndex := 0    // -> _HMG_ThisFormIndex
      oHmgApp():ThisType := ''   //  -> _HMG_ThisType
      oHmgApp():ThisEventType := ''   //  -> _HMG_ThisEventType
      oHmgApp():ThisFormName := ''   // oHmgApp():APP316 -> _HMG_ThisFormName
      oHmgApp():ThisControlName := ''   // oHmgApp():APP317 -> _HMG_ThisControlName

   EndIf

Return
*------------------------------------------------------------------------------*
Procedure _RefreshDataControls (i)
*------------------------------------------------------------------------------*
   Local SplitIndex
   Local x
   Local w
   LOCAL oFormI := FormByIndex( I )

   For x := 1 To HMG_LEN ( oFormI:FORM089 )

      _Refresh( oFormI:FORM089 [x] )

      if ControlByIndex( oFormI:FORM089 [x] ):Type == 'COMBO' .Or. ControlByIndex( oFormI:FORM089 [x] ):Type == 'BROWSE'
         _SetValue ( '','', ControlByIndex( oFormI:FORM089 [x] ):CTRL008 , oFormI:FORM089 [x] )
      EndIf

   Next x

   if HMG_LEN ( FormByIndex( I ):FORM090 ) > 0

      For x := 1 To HMG_LEN ( FormByIndex( I ):FORM090 )
         SplitIndex := FormByIndex( I ):FORM090 [x]
         For w := 1 To HMG_LEN ( FormByIndex( SplitIndex ):FORM089 )
            _Refresh( FormByIndex( SplitIndex ):FORM089 [w] )
            if ControlByIndex( FormByIndex( SplitIndex ):FORM089 [w] ):Type == 'COMBO' .Or. ControlByIndex( FormByIndex( SplitIndex ):FORM089 [w] ):Type == 'BROWSE'
               _SetValue ( '','', ControlByIndex( FormByIndex( SplitIndex ):FORM089 [w] ):CTRL008 , FormByIndex( SplitIndex ):FORM089 [w] )
            EndIf
         Next w
      next x

   endif

Return
*------------------------------------------------------------------------------*
PROCEDURE _SetActivationFlag( i )

   LOCAL oFormI, nIndex

   oFormi := FormByIndex( I )
   oFormI:IsActive = .t.
   FOR EACH nIndex IN oFormI:FORM090
      FormByIndex( nIndex ):IsActive := .t.
   NEXT

   RETURN
*------------------------------------------------------------------------------*
PROCEDURE _ProcessInitProcedure(i)

   IF valtype( FormByIndex( i ):InitProcedure ) == 'B'
      DO EVENTS   // ProcessMessages()
      _PushEventInfo()
      oHmgApp():ThisEventType := 'WINDOW_INIT'
      oHmgApp():ThisFormIndex := i
      oHmgApp():ThisType := 'W'
      oHmgApp():ThisControlIndex := i
      oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name
      oHmgApp():ThisControlName :=  ""
      Eval( FormByIndex( i ):InitProcedure )
      _PopEventInfo()
   ENDIF
   // added in hmg 3.0.43 - start
   if valtype( FormByIndex( I ):FORM080  ) == 'B' .OR.  HMG_LEN ( FormByIndex( i ):GraphTasks ) > 0
      InvalidateRect ( FormByIndex( i ):Handle, NIL, .F.)
   endif
   // end


Return
*------------------------------------------------------------------------------*
Function _SetFocusedSplitChild(i)
*------------------------------------------------------------------------------*
   LOCAL oFormI, nIndex, oForm2
   LOCAL SplitFocusFlag

   oFormI := FormByIndex( I )
   SplitFocusFlag := .f.

   IF LEN ( oFormI:FORM090 ) > 0

      FOR EACH nIndex IN oFormI:FORM090
         oForm2 := FormByIndex( nIndex )
         IF oForm2:APP093 == .t.
            setfocus ( oForm2:Handle )
            SplitFocusFlag := .T.
         ENDIF
      NEXT

   ENDIF

   RETURN SplitFocusFlag
*------------------------------------------------------------------------------*
Procedure _SetActivationFocus(i)
*------------------------------------------------------------------------------*
Local Sp, xTmp
Local x
Local FocusDefined := .f.
local nFocusHandle
Local nControlIndex

      Sp := GetFocus()
      For x := 1 To oHmgApp():ControlCount
              If ControlByIndex( X ):ParentFormHandle == FormByIndex( i ):Handle
            If ValType ( ControlByIndex( x ):Handle ) == 'N'
               If ControlByIndex( x ):Handle   == Sp
                  FocusDefined := .T.
                  Exit
               EndIf
            ElseIf ValType ( ControlByIndex( x ):Handle ) == 'A'
               If ControlByIndex( x ):Handle[1] == Sp
                  FocusDefined := .T.
                  Exit
               EndIf
            EndIf
         EndIf
      Next x

      If FocusDefined == .F.

         nFocusHandle := GetNextDlgTabItem ( FormByIndex( i ):Handle , 0 , .F. )

         xTmp := ControlByHandle( nFocusHandle )
         nControlIndex := iif( xTmp == Nil, 0, xTmp:Index )

         if nControlIndex <> 0

            _SetFocus ( , , nControlIndex )

         else
            SetFocus ( nFocusHandle )

         endif

      EndIf

Return
*------------------------------------------------------------------------------*
Function _GenActivateId(nForm)
*------------------------------------------------------------------------------*
Local TmpStr
Local TmpId

   Do While .t.
      TmpId := Int ( Seconds() * 100 )
      TmpStr := '_HMG_ACTIVATE_' + ALLTRIM( STR ( TmpId ) )
      If ! __MVEXIST ( TmpStr )
         exit
      End If
   EndDo

   __MVPUBLIC ( TmpStr )
   __MVPUT ( TmpStr , nForm )

Return TmpId


*------------------------------------------------------------------------------*
PROCEDURE _hmg_OnHideFocusManagement(i)

   LOCAL FormCount, x, xTmp
   LOCAL oFormI, oFormZ

   oFormI := FormByIndex( i )

   FormCount := oHmgApp():FormCount

   IF oFormI:ParentHandle == 0   // _HMG_aFormParentHandle
      * Non Modal

      IF oHmgApp():IsModalActive == .F.   // _HMG_IsModalActive
         FOR EACH oFormZ IN oHmgApp():AllForms()
            IF ! oFormZ:IsDeleted
               EnableWindow( oFormZ:Handle )
            ENDIF
         NEXT
      ENDIF

   ELSE

      * Modal

      xTmp := FormByHandle( oFormI:ParentHandle ) // if exist FormParentHandle
      x := iif( xTmp == Nil, 0, xTmp:Index )
      IF x > 0
         IF FormByIndex( x ):Type == "M"   // Modal Window
            * Modal Parent
            oHmgApp():IsModalActive := .T.                       // _HMG_IsModalActive
            oHmgApp():ActiveModalHandle := oFormI:ParentHandle   // _HMG_ActiveModalHandle = _HMG_aFormParentHandle
            EnableWindow ( oFormI:ParentHandle )          // _HMG_aFormParentHandle
            SetFocus( oFormI:ParentHandle )                // _HMG_aFormParentHandle
         ELSE
            * Non Modal Parent
            oHmgApp():IsModalActive := .F.   // _HMG_IsModalActive
            oHmgApp():ActiveModalHandle := 0     // _HMG_ActiveModalHandle

            FOR EACH oFormZ IN oHmgApp():AllForms()
               IF ! oFormZ:IsDeleted
                  EnableWindow( oFormZ:Handle )
               ENDIF
            NEXT
            SetFocus( oFormI:ParentHandle )               // _HMG_aFormParentHandle
         ENDIF

      ELSE

         * Missing Parent

         oHmgApp():IsModalActive := .F.   // _HMG_IsModalActive
         oHmgApp():ActiveModalHandle := 0     // _HMG_ActiveModalHandle
         FOR EACH oFormZ IN oHmgApp():AllForms()
            IF ! oFormZ:IsDeleted
               EnableWindow( oFormZ:Handle )
            ENDIF
         NEXT
         SetFocus( oHmgApp():MainHandle )                 // _HMG_MainHandle

      ENDIF

   ENDIF

   RETURN

*------------------------------------------------------------------------------*
FUNCTION _DoControlEventProcedure ( bBlock , i )
*------------------------------------------------------------------------------*
   IF ControlByIndex( I ):StopEventProcedure == .T.   //   ( Dr. Claudio Soto, April 2013 )
      RETURN .F.
   ENDIF

   IF ControlByIndex( i ):Type <> "HOTKEY"   //  ADD, November 2016
      oHmgApp():LastActiveControlIndex := i
   ENDIF

   if valtype( bBlock ) =='B'
      _PushEventInfo()
      oHmgApp():ThisFormIndex := FormByHandle( ControlByIndex( i ):ParentFormHandle ):Index   // FormParentIndex
      oHmgApp():ThisType := 'C'
      oHmgApp():ThisControlIndex := i                                                      // ControlIndex
      oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name         // FormParentName
      oHmgApp():ThisControlName :=  ControlByIndex( oHmgApp():ThisControlIndex ):Name             // ControlName

      oHmgApp():APP293 := Eval( bBlock )

      _PopEventInfo()
      RETURN .T.
   EndIf

RETURN .F.


*------------------------------------------------------------------------------*
Function _DoWindowEventProcedure ( bBlock , i , cEventType )
*------------------------------------------------------------------------------*
Local lRetVal := .F.

   IF cEventType == "MOUSEMOVE" .AND. ValType (bBlock) <> "B"
      RETURN .F.
   ENDIF

   IF cEventType <> "TASKBAR"   //  ADD, November 2016
      oHmgApp():LastActiveFormIndex := i
   ENDIF

   IF FormByIndex( i ):StopEventProcedure   //   ( Dr. Claudio Soto, April 2013 )
      RETURN .F.
   ENDIF

   if valtype( bBlock )=='B'

      _PushEventInfo()
      oHmgApp():ThisFormIndex := i
      oHmgApp():ThisEventType := cEventType
      oHmgApp():ThisType := 'W'
      oHmgApp():ThisControlIndex := i
      oHmgApp():ThisFormName :=  FormByIndex( oHmgApp():ThisFormIndex ):Name
      oHmgApp():ThisControlName :=  ""
      lRetVal := Eval( bBlock )
      _PopEventInfo()

   EndIf

Return lRetVal


//  by Dr. Claudio Soto, April 2013
*------------------------------------------------------------------------------*
FUNCTION StopWindowEventProcedure (cFormName, lStop)

   LOCAL i

   i := GetFormIndex (cFormName)
   FormByIndex( i ):StopEventProcedure := IIF( ValType( lStop ) <> "L", .F., lStop )

   RETURN NIL


//  by Dr. Claudio Soto, April 2013
*------------------------------------------------------------------------------*
FUNCTION StopControlEventProcedure (cControlName, cFormName, lStop)
*------------------------------------------------------------------------------*
LOCAL i
   i := GetControlIndex (cControlName, cFormName)
   ControlByIndex( i ):StopEventProcedure := IIF (ValType(lStop) <> "L", .F., lStop )
RETURN NIL



*------------------------------------------------------------------------------*
Function _GetGridCellData (i)
*------------------------------------------------------------------------------*
Local ThisItemRowIndex
Local ThisItemColIndex
Local ThisItemCellRow
Local ThisItemCellCol
Local ThisItemCellWidth
Local ThisItemCellHeight
Local r
Local xs
Local xd
Local aCellData

LOCAL ControlHandle := ControlByIndex( i ):Handle

LOCAL nRowControl := IF (ValType( ControlByIndex( I ):CTRL018 ) == "N", ControlByIndex( I ):CTRL018, 0)   // check if number --> SplitBox
LOCAL nColControl := IF (ValType( ControlByIndex( I ):CTRL019 ) == "N", ControlByIndex( I ):CTRL019, 0)   // check if number --> SplitBox

LOCAL nWidthControl := ControlByIndex( I ):CTRL020

   r := ListView_HitTest ( ControlHandle , GetCursorRow() - GetWindowRow (ControlHandle)  , GetCursorCol() - GetWindowCol(ControlHandle) )
   If r [2] == 1
      ListView_Scroll ( ControlHandle , -10000  , 0 )
      r := ListView_HitTest ( ControlHandle, GetCursorRow() - GetWindowRow (ControlHandle), GetCursorCol() - GetWindowCol (ControlHandle) )
   Else
      r := LISTVIEW_GETSUBITEMRECT ( ControlHandle , r[1] - 1 , r[2] - 1 )
      xs := ( ( nColControl + r [2] ) + r[3] )  -  ( nColControl + nWidthControl )
      If ListView_GetItemCount (ControlHandle) >  ListViewGetCountPerPage (ControlHandle)
         xd := 20
      Else
         xd := 0
      EndIf

      If xs > -xd
         ListView_Scroll ( ControlHandle , xs + xd , 0 )
      Else
         If r [2] < 0
            ListView_Scroll ( ControlHandle , r[2] , 0 )
         EndIf
      EndIf

      r := ListView_HitTest ( ControlHandle , GetCursorRow() - GetWindowRow (ControlHandle)  , GetCursorCol() - GetWindowCol (ControlHandle) )

   EndIf

   ThisItemRowIndex := r[1]
   ThisItemColIndex := r[2]

   If r [2] == 1
      r := LISTVIEW_GETITEMRECT ( ControlHandle, r[1] - 1 )
   Else
      r := LISTVIEW_GETSUBITEMRECT ( ControlHandle, r[1] - 1 , r[2] - 1 )
   EndIf

   ThisItemCellRow    := nRowControl + r [1]
   ThisItemCellCol    := nColControl + r [2]
   ThisItemCellWidth  := r[3]
   ThisItemCellHeight := r[4]

   aCellData := { ThisItemRowIndex , ThisItemColIndex , ThisItemCellRow , ThisItemCellCol , ThisItemCellWidth , ThisItemCellHeight }

Return aCellData
*------------------------------------------------------------------------------*
Function IsXPThemeActive()
*------------------------------------------------------------------------------*
local uResult

   If oHmgApp():IsXP

      uResult := CallDll32 ( "IsThemeActive" , "UXTHEME.DLL" , 0 )

      if uResult != 0
         uResult := .T.
      Else
         uResult := .F.
      EndIf

   Else

      uResult := .F.

   EndIf

return uResult

*------------------------------------------------------------------------------*
Procedure InstallEventHandler ( cProcedure )
*------------------------------------------------------------------------------*

   aadd ( oHmgApp():APP060 , ALLTRIM ( HMG_UPPER ( cProcedure ) ) )

Return

*------------------------------------------------------------------------------*
Procedure InstallPropertyHandler ( cPropertyName , cSetProcedure , cGetProcedure )
*------------------------------------------------------------------------------*

   aadd ( oHmgApp():APP061 , { ALLTRIM ( HMG_UPPER ( cPropertyName ) ) , ALLTRIM ( HMG_UPPER ( cSetProcedure ) ) , ALLTRIM ( HMG_UPPER ( cGetProcedure ) ) } )

Return

*------------------------------------------------------------------------------*
Procedure InstallMethodHandler ( cEventName , cMethodProcedure )
*------------------------------------------------------------------------------*

   aadd ( oHmgApp():APP062 , { ALLTRIM ( HMG_UPPER ( cEventName ) ) , ALLTRIM ( HMG_UPPER ( cMethodProcedure ) ) } )

Return


*------------------------------------------------------------------------------*
FUNCTION SAVEWINDOW ( cWindowName , cFileName , nRow , nCol , nWidth , nHeight )
*------------------------------------------------------------------------------*
LOCAL hBitmap
   hBitmap := BT_BitmapCaptureClientArea (cWindowName, nRow, nCol, nWidth, nHeight)
   IF hBitmap <> 0
      DEFAULT cFileName TO cWindowName + '.BMP'
      BT_BitmapSaveFile (hBitmap, cFileName)
      BT_BitmapRelease (hBitmap)
   ENDIF
RETURN NIL


*------------------------------------------------------------------------------*
FUNCTION PRINTWINDOW ( cWindowName , lPreview , ldialog , nRow , nCol , nWidth , nHeight )
*------------------------------------------------------------------------------*
LOCAL lSuccess
LOCAL TempName
LOCAL W
LOCAL H
LOCAL HO
LOCAL VO
local bw , bh , r , tw , th , dc , wdif , hdif , dr
Local ntop , nleft , nbottom , nright

   if   valtype ( nRow ) = 'U' ;
      .or. ;
      valtype ( nCol ) = 'U' ;
      .or. ;
      valtype ( nWidth ) = 'U' ;
      .or. ;
      valtype ( nHeight ) = 'U'

      ntop   := -1
      nleft   := -1
      nbottom   := -1
      nright   := -1

   else

      ntop   := nRow
      nleft   := nCol
      nbottom   := nHeight + nRow
      nright   := nWidth + nCol

   endif

   if ValType ( lDialog ) = 'U'
      lDialog   := .F.
   endif

   if ValType ( lPreview ) = 'U'
      lPreview := .F.
   endif

   if lDialog

      IF lPreview
         SELECT PRINTER DIALOG TO lSuccess PREVIEW
      ELSE
         SELECT PRINTER DIALOG TO lSuccess
      ENDIF

      IF ! lSuccess
         RETURN NIL
      ENDIF

   else

      IF lPreview
         SELECT PRINTER DEFAULT TO lSuccess PREVIEW
      ELSE
         SELECT PRINTER DEFAULT TO lSuccess
      ENDIF

      IF ! lSuccess
         MSGHMGERROR ( "Can't Init Printer" )
         RETURN NIL
      ENDIF

   endif

   IF ! _IsWIndowDefined ( cWindowName )
      MSGHMGERROR ( 'Window Not Defined' )
      RETURN NIL
   ENDIF

   TempName := GetTempFolder() + '_hmg_printwindow_' + ALLTRIM(STR(int(seconds()*100))) + '.BMP'

   SAVEWINDOW ( cWindowName , TempName , nRow , nCol , nWidth , nHeight )

   HO := GETPRINTABLEAREAHORIZONTALOFFSET()
   VO := GETPRINTABLEAREAVERTICALOFFSET()

   W := GETPRINTABLEAREAWIDTH() - 10 - ( HO * 2 )
   H := GETPRINTABLEAREAHEIGHT() - 10 - ( VO * 2 )

   if ntop = -1

      bw := GetProperty ( cWindowName , 'Width' )
      bh := GetProperty ( cWindowName , 'Height' ) - GetTitleHeight ( GetFormHandle (cWindowName) )

   else

      bw := nright - nleft
      bh := nbottom - ntop

   endif


   r := bw / bh

   tw := 0
   th := 0

   do while .t.

      tw ++
      th := tw / r

      if tw > w .or. th > h
         exit
      endif

   enddo

   wdif := w - tw

   if wdif > 0
      dc := wdif / 2
   else
      dc := 0
   endif

   hdif := h - th

   if hdif > 0
      dr := hdif / 2
   else
      dr := 0
   endif


   START PRINTDOC

      START PRINTPAGE

         @ VO + 10 + ( ( h - th ) / 2 ) , HO + 10 + ( ( w - tw ) / 2 ) PRINT IMAGE TempName WIDTH tW HEIGHT tH

      END PRINTPAGE

   END PRINTDOC

   DO EVENTS

   FERASE( TempName )

RETURN NIL



*------------------------------------------------------------------------------*
Function IsAppThemed()
*------------------------------------------------------------------------------*
local uResult
Local nVersion

   nVersion := WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 )

   If nVersion >= 5.1

//      uResult := CallDll32 ( "IsAppThemed" , "UXTHEME.DLL", 0  )
      uResult := CallDll32 ( "IsAppThemed" , "UXTHEME.DLL"  )

      if uResult != 0
         uResult := .T.
      Else
         uResult := .F.
      EndIf

   Else

      uResult := .F.

   EndIf

return uResult


*------------------------------------------------------------------------------*
Function OpenThemeData( hwnd , pszClassList )
*------------------------------------------------------------------------------*
local uResult := CallDll32 ( "OpenThemeData" , "UXTHEME.DLL" , hwnd , pszClassList )
return uResult

*------------------------------------------------------------------------------*
Function CloseThemeData( hTheme )
*------------------------------------------------------------------------------*
local uResult := CallDll32 ( "CloseThemeData" , "UXTHEME.DLL" , hTheme )
return uResult

*------------------------------------------------------------------------------*
Function DrawThemeBackground( hTheme , hdc , iPartId , iStateId , pRect , pClipRect )
*------------------------------------------------------------------------------*
local uResult := CallDll32 ( "DrawThemeBackground" , "UXTHEME.DLL" , hTheme , hdc , iPartId , iStateId , pRect , pClipRect )
return uResult



*----------------------------------------------------------------*
Procedure VirtualChildControlFocusProcess( nControlHandle , nWindowHandle )
*----------------------------------------------------------------*
   Local x               := 0
   Local nWindowVirtualWidth      := 0
   Local nWindowVirtualHeight      := 0
   Local nWindowHeight         := 0
   Local nWindowWidth         := 0
   Local nControlHeight         := 0
   Local nControlWidth         := 0
   Local nControlRow         := 0
   Local nControlCol         := 0
   Local nHorizontalScrollBoxPos      := 0
   Local nVerticalScrollBoxPos      := 0
   Local nHorizontalScrollBarRangeMax   := 0
   Local nVerticalScrollBarRangeMax   := 0
   Local nVisibleAreaFromRow      := 0
   Local nVisibleAreaFromCol      := 0
   Local nVisibleAreaToRow         := 0
   Local nVisibleAreaToCol         := 0
   Local nNewScrollBarPos         := 0
   LOCAL oForm, oControl

   IF oHmgApp():AutoScroll == .F.
      Return
   ENDIF

   * Get Window Width / Height / Virtual Width / Virtual Height

   FOR EACH oForm IN oHmgApp():AllForms()

      If oForm:Handle == nWindowHandle
         nWindowVirtualHeight := oForm:VirtualHeight
         nWindowVirtualWidth  := oForm:VirtualWidth
         If    nWindowVirtualHeight == 0 .And. nWindowVirtualWidth == 0
            // Return .T.   // REMOVE
             Return
         Else
            nWindowHeight   := GetWindowHeight ( nWindowHandle )
            nWindowWidth   := GetWindowWidth ( nWindowHandle )
            Exit
         EndIf
      EndIf
   Next x

   * Get Control Row / Col / Width / Height

   For EACH oControl IN oHmgApp():AllControls()

      If VALTYPE ( oControl:Handle ) == 'N' .And. VALTYPE ( nControlHandle ) == 'N'

         If oControl:Handle == nControlHandle

            nControlHeight := oControl:CTRL021
            nControlWidth  := oControl:CTRL020
            nControlRow    := oControl:CTRL018
            nControlCol    := oControl:CTRL019

            Exit

         EndIf


      ElseIf   VALTYPE ( oControl:Handle ) == 'A' .And. VALTYPE ( nControlHandle ) == 'N'

         If aScan ( oControl:Handle , nControlHandle ) > 0

            nControlHeight  := oControl:CTRL021
            nControlWidth   := oControl:CTRL020
            nControlRow     := oControl:CTRL018
            nControlCol     := oControl:CTRL019

            Exit

         EndIf

      EndIf

   Next x

   * Get hScrollBox Position / vScrollBox Position

   nHorizontalScrollBoxPos   := GetScrollPos ( nWindowHandle , SB_HORZ )
   nVerticalScrollBoxPos   := GetScrollPos ( nWindowHandle , SB_VERT )

   * Get hScrollBar Maximun Range / vScrollBar Maximun Range

   nHorizontalScrollBarRangeMax   := GetScrollRangeMax( nWindowHandle , SB_HORZ )
   nVerticalScrollBarRangeMax   := GetScrollRangeMax( nWindowHandle , SB_VERT )

   * Calculate Current Visible Area

   nVisibleAreaFromRow   := nVerticalScrollBoxPos
   nVisibleAreaFromCol   := nHorizontalScrollBoxPos

   nVisibleAreaToRow   := nVisibleAreaFromRow + nWindowHeight - 50
   nVisibleAreaToCol   := nVisibleAreaFromCol + nWindowWidth - 10

   * Determine if Control Getting the Focus is out of Visible
   * Area. If So, scroll The Window.

   * Control is too LoW To be Visible

   If nControlRow + nControlHeight > nVisibleAreaToRow

      nNewScrollBarPos := nControlRow + nControlHeight - nWindowHeight + 100

      If nNewScrollBarPos > nVerticalScrollBarRangeMax
         nNewScrollBarPos := nVerticalScrollBarRangeMax
      EndIf

      _HMG_PRINTER_SETVSCROLLVALUE( nWindowHandle , nNewScrollBarPos )

   Else

      * Control is too high To be Visible

      If nControlRow + nControlHeight < nVisibleAreaFromRow

         nNewScrollBarPos := nControlRow - nWindowHeight - 100

         If nNewScrollBarPos < 0
            nNewScrollBarPos := 0
         EndIf

         _HMG_PRINTER_SETVSCROLLVALUE( nWindowHandle , nNewScrollBarPos )

      EndIf

   EndIf

   * Control Is Too RIGHT To Be Visible

   If nControlCol + nControlWidth > nVisibleAreaToCol

      nNewScrollBarPos := nControlCol + nControlWidth - nWindowWidth + 100

      If nNewScrollBarPos > nHorizontalScrollBarRangeMax
         nNewScrollBarPos := nHorizontalScrollBarRangeMax
      EndIf

      _HMG_PRINTER_SETHSCROLLVALUE( nWindowHandle , nNewScrollBarPos )

   Else

      * Control Is Too LEFT To Be Visible

      If nControlCol + nControlWidth < nVisibleAreaFromCol

         nNewScrollBarPos := nControlCol - nWindowWidth - 100

         If nNewScrollBarPos < 0
            nNewScrollBarPos := 0
         EndIf

         _HMG_PRINTER_SETHSCROLLVALUE( nWindowHandle , nNewScrollBarPos )


      EndIf

   EndIf

   RETURN

*------------------------------------------------------------------------------*
Function InitWaitWindow()
*------------------------------------------------------------------------------*

   DEFINE WINDOW _HMG_CHILDWAITWINDOW ;
      AT   0,0   ;
      WIDTH   500   ;
      HEIGHT   40   ;
      TITLE   ''   ;
      CHILD      ;
      NOSHOW      ;
      NOSYSMENU   ;
      NOCAPTION

      DEFINE LABEL Message
         ROW      5
         COL      10
         WIDTH      480
         HEIGHT      25
         VALUE      ''
         CENTERALIGN   .T.
      END LABEL

   END WINDOW

   _HMG_CHILDWAITWINDOW.CENTER

Return Nil

*------------------------------------------------------------------------------*
Function ShowWaitWindow( cMessage )
*------------------------------------------------------------------------------*

   _HMG_CHILDWAITWINDOW.MESSAGE.VALUE := cMessage

   _HMG_CHILDWAITWINDOW.SHOW

Return Nil

*------------------------------------------------------------------------------*
Function ShowWaitWindowModal( cMessage )
*------------------------------------------------------------------------------*
Local lExit, i

   lExit := .F.

   _HMG_CHILDWAITWINDOW.MESSAGE.VALUE := cMessage

   _HMG_CHILDWAITWINDOW.SHOW

   For i := 1 To 255
      GetAsyncKeyState(i)
   Next i

   Do While .Not. lExit
      For i := 1 To 255
         If GetAsyncKeyState(i) <> 0
            lExit := .T.
            Exit
         EndIf
      Next i
   EndDo

   _HMG_CHILDWAITWINDOW.HIDE

Return Nil

*------------------------------------------------------------------------------*
Function HideWaitWindow()
*------------------------------------------------------------------------------*

   _HMG_CHILDWAITWINDOW.HIDE

Return Nil

*------------------------------------------------------------------------------*
Function WaitWindow ( cMessage , lNoWait )
*------------------------------------------------------------------------------*

   if pcount() > 0

      If ValType ( lNoWait ) == 'L'

         If   lNoWait == .T.

            ShowWaitWindow( cMessage )

         Else

            ShowWaitWindowModal( cMessage )

         EndIf

      Else

         ShowWaitWindowModal( cMessage )

      EndIf

   Else

      HideWaitWindow()

   EndIf

Return Nil
