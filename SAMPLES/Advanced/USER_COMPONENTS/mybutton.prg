
#define WM_COMMAND      0x0111
#define BN_CLICKED      0

*------------------------------------------------------------------------------*
Init Procedure _InitMyButton
*------------------------------------------------------------------------------*

   InstallEventHandler ( 'MyButtonEventHandler' )
   InstallMethodHandler ( 'SetFocus' , 'MyButtonSetFocus' )
   InstallMethodHandler ( 'Enable' , 'MyButtonEnable' )
   InstallMethodHandler ( 'Disable' , 'MyButtonDisable' )
   InstallPropertyHandler ( 'Handle' , 'SetMyButtonHandle' , 'GetMyButtonHandle' )
   InstallPropertyHandler ( 'Caption' , 'SetMyButtonCaption' , 'GetMyButtonCaption' )

Return

*------------------------------------------------------------------------------*
Procedure _DefineMyButton ( cName , nRow , nCol , cCaption , bAction , cParent )
*------------------------------------------------------------------------------*
Local nControlHandle,nId,nParentFormHandle,k,cMacroVar. oControl

   If .Not. _IsWindowDefined (cParent)
      MsgHMGError("Window: "+ cParent + " is not defined.")
   Endif

   If _IsControlDefined (cName,cParent)
      MsgHMGError ("Control: " + cName + " Of " + cParent + " Already defined.")
   Endif

   cMacroVar := '_' + cParent + '_' + cName
   k         := _GetControlFree()
   nId         := _GetId()
   nParentFormHandle   := GetFormHandle (cParent)
   nControlHandle      := InitMyButton    ( ;
                     nParentFormHandle , ;
                     nRow , ;
                     nCol , ;
                     cCaption , ;
                     nId ;
                     )

   Public &cMacroVar. := k
   oControl := ControlByIndex( k )

   oControl:Type := 'MYBUTTON'
   oControl:Name := cName
   oControl:Handle := nControlHandle
   oControl:ParentHandle  := nParentFormHandle
   oControl:CTRL005 := NIL
   oControl:CTRL006 := bAction
   oControl:CTRL007 := NIL
   oControl:CTRL008 := NIL
   oControl:CTRL009 := NIL
   oControl:CTRL010 := NIL
   oControl:CTRL011 := NIL
   oControl:CTRL012 := NIL
   oControl:IsDeleted := .F.
   oControl:CTRL014 := NIL
   oControl:CTRL015 := NIL
   oControl:CTRL016 := NIL
   oControl:CTRL017 := NIL
   oControl:CTRL018 := NIL
   oControl:CTRL019 := NIL
   oControl:CTRL020 := NIL
   oControl:CTRL021 := NIL
   oControl:CTRL022 := NIL
   oControl:CTRL023 := NIL
   oControl:CTRL024 := NIL
   oControl:CTRL025 := NIL
   oControl:CTRL026 := NIL
   oControl:CTRL027 := NIL
   oControl:CTRL028 := NIL
   oControl:CTRL029 := NIL
   oControl:CTRL030 := NIL
   oControl:CTRL031 := NIL
   oControl:CTRL032 := NIL
   oControl:CTRL033 := NIL
   oControl:CTRL034 := NIL
   oControl:CTRL035 := NIL
   oControl:CTRL036 := NIL
   oControl:CTRL037 := NIL
   oControl:CTRL038 := NIL
   oControl:CTRL039 := NIL
   oControl:CTRL040 := NIL

Return

*------------------------------------------------------------------------------*
Function MyButtonEventhandler ( hWnd, nMsg, wParam, lParam )
*------------------------------------------------------------------------------*
Local i, oTmpControl
Local RetVal := Nil

   if nMsg == WM_COMMAND

      oTmpControl := ControlByHandle( lParam )
      I := iif( oTmpControl == Nil .OR. oTmpControl:Index == 0, 0, oTmpControl:Index )

      If i > 0

         IF HiWord (wParam) == BN_CLICKED
            RetVal := 0
            _DoControlEventProcedure ( ControlByIndex( I ):CTRL006 , i )
         Endif

      Endif

   endif

Return RetVal

*------------------------------------------------------------------------------*
Procedure MyButtonSetFocus ( cWindow , cControl )
*------------------------------------------------------------------------------*
Local i

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      SetFocus ( GetControlHandle ( cControl , cWindow ) )

      oHmgApp():APP063 := .T.

   else

      oHmgApp():APP063 := .F.

   endif

Return

*------------------------------------------------------------------------------*
Procedure MyButtonEnable ( cWindow , cControl )
*------------------------------------------------------------------------------*
Local i

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      EnableWindow ( GetControlHandle ( cControl , cWindow ) )

      oHmgApp():APP063 := .T.

   else

      oHmgApp():APP063 := .F.

   endif

Return

*------------------------------------------------------------------------------*
Procedure MyButtonDisable ( cWindow , cControl )
*------------------------------------------------------------------------------*
Local i

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      DisableWindow ( GetControlHandle ( cControl , cWindow ) )

      oHmgApp():APP063 := .T.

   else

      oHmgApp():APP063 := .F.

   endif

Return

*------------------------------------------------------------------------------*
Function SetMyButtonHandle ( cWindow , cControl )
*------------------------------------------------------------------------------*

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      MsgExclamation ( 'This Property is Read Only!' )

   endif

   oHmgApp():APP063 := .F.

Return Nil

*------------------------------------------------------------------------------*
Function GetMyButtonHandle ( cWindow , cControl )
*------------------------------------------------------------------------------*
Local RetVal := Nil

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      oHmgApp():APP063 := .T.
      RetVal := GetControlHandle ( cControl , cWindow )

   else

      oHmgApp():APP063 := .F.

   endif

Return RetVal

*------------------------------------------------------------------------------*
Function SetMyButtonCaption ( cWindow , cControl , cProperty , cValue )
*------------------------------------------------------------------------------*

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      oHmgApp():APP063 := .T.

      SetWindowText ( GetControlHandle ( cControl , cWindow ) , cValue )

   else

      oHmgApp():APP063 := .F.

   endif

Return Nil

*------------------------------------------------------------------------------*
Function GetMyButtonCaption ( cWindow , cControl )
*------------------------------------------------------------------------------*
Local RetVal := Nil

   If GetControlType ( cControl , cWindow ) == 'MYBUTTON'

      oHmgApp():APP063 := .T.

      RetVal := GetWindowText ( GetControlHandle ( cControl , cWindow ) )

   else

      oHmgApp():APP063 := .F.

   endif

Return RetVal

*------------------------------------------------------------------------------*
* Low Level C Routines
*------------------------------------------------------------------------------*

#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"

HB_FUNC( INITMYBUTTON )
{

   HWND hwnd = (HWND) hb_parnl (1) ;
   HWND hbutton;

   hbutton = CreateWindow( "button" ,
                           hb_parc(4) ,
                           BS_NOTIFY | WS_CHILD | BS_PUSHBUTTON | WS_VISIBLE,
                           hb_parni(3) ,
                           hb_parni(2) ,
                           100 ,
                           28 ,
                           hwnd ,
                           (HMENU)hb_parni(5) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

   hb_retnl ( (LONG) hbutton );

}

#pragma ENDDUMP
