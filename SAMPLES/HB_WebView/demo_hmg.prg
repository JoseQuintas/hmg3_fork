
#include "hmg.ch"

#include "hb_webview.ch"

// #include "../hb_webview-lib/hb_webview.ch"
// #include "hb_webview-lib/hb_webview.prg"

FUNCTION Main
LOCAL w, allowDevTools, myScript
LOCAL hWnd, hWidget, hBrowserController

   DEFINE WINDOW Win_1 ;
      ROW 0 ;
      COL 0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "HMG WebView2";
      ON INIT     RESIZE_WEBVIEW2( hWidget );
      ON SIZE     RESIZE_WEBVIEW2( hWidget );
      ON MAXIMIZE RESIZE_WEBVIEW2( hWidget );
      MAIN

      DEFINE MAIN MENU
         DEFINE POPUP "Navigate ..."
            
//            MENUITEM "Webview2 runtime version"       ACTION MsgInfo( "Your installed webview2 runtime version is: " + hb_osNewline() + GETVERSION_WEBVIEW2(), "HMG WebView2" )
//            SEPARATOR

            MENUITEM "Webview C/C++ library version"  ACTION MsgInfo( "Webview C/C++ library version: " + hb_webview_version()[4] )
            SEPARATOR
            
            MENUITEM "HB_Webview wrapper version"     ACTION MsgInfo( hb_webview_wrapper_version()[5] )
            SEPARATOR
            
            MENUITEM "Get URL"         ACTION MsgInfo( ACTION_WEBVIEW2( hBrowserController, 0 ) )
            SEPARATOR
            
            MENUITEM "Go hmgforum.com" ACTION hb_webview_navigate(w, "http://www.hmgforum.com" )
            SEPARATOR
            
            MENUITEM "Exec Script"     ACTION hb_webview_eval(w, "alert('hello webview, ' + Hello() );" )
            SEPARATOR

            MENUITEM "Go Back"         ACTION ACTION_WEBVIEW2( hBrowserController, 2 )
            MENUITEM "Go Forward"      ACTION ACTION_WEBVIEW2( hBrowserController, 3 )
            SEPARATOR
            
            MENUITEM "Reload page"     ACTION ACTION_WEBVIEW2( hBrowserController, 4 )
            MENUITEM "Stop load page"  ACTION ACTION_WEBVIEW2( hBrowserController, 5 )
            SEPARATOR
            
            MENUITEM "Open DevTools"   ACTION ACTION_WEBVIEW2( hBrowserController, 1 )
            SEPARATOR
            
            MENUITEM "Set Settings"    ACTION SETTINGS_WEBVIEW2( hBrowserController )

         END POPUP

         DEFINE POPUP "Demo"
            MENUITEM "Bind Function Demo" ACTION demo2()
            MENUITEM "Data Base Demo"     ACTION demo3()
         END POPUP

      END MENU

   END WINDOW

myScript = "function Hello() { return 'hello myScript'; }"

hWnd = NUM2PTR( Win_1.Handle )

allowDevTools := .F.

   w = hb_webview_create( allowDevTools, hWnd )

hWidget = hb_webview_get_native_handle( w, WEBVIEW_NATIVE_HANDLE_KIND_UI_WIDGET )

hBrowserController := hb_webview_get_native_handle(w, WEBVIEW_NATIVE_HANDLE_KIND_BROWSER_CONTROLLER)

      hb_webview_init(w, myScript )

      hb_webview_set_size(w, 800, 480, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - Navigate Demo")

      hb_webview_navigate(w, "https://harbour.github.io/doc/")

   Win_1.Center
   Win_1.show

   Win_1.Activate

// hb_webview_terminate( w )

RETURN NIL


/******************************************************************************************************************/


REQUEST hb_alert, hb_memoread, hb_memowrit

*--------------------------------------------------------*
FUNCTION Demo2
*--------------------------------------------------------*
LOCAL w, html, allowDevTools
LOCAL hWnd, hWidget
LOCAL context1, context2, context3, context4, context5

DECLARE WINDOW Win_2

   IF IsWindowDefined( Win_2 ) == .T.
      Win_2.SetFocus
      RETURN NIL
   ENDIF

   DEFINE WINDOW Win_2 ;
      ROW 0 ;
      COL 0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "HMG WebView2";
      ON INIT     RESIZE_WEBVIEW2( hWidget );
      ON SIZE     RESIZE_WEBVIEW2( hWidget );
      ON MAXIMIZE RESIZE_WEBVIEW2( hWidget );
      WINDOWTYPE STANDARD

   END WINDOW


html = ''
html += '<div>'
html += '  <p>Press CTRL+SHIFT+I to open the DevTools window</p>'
html += '  <button onclick="disp1()"> callHB( "funcHB",1,2,3 )     </button>'
html += '  <button onclick="disp2()"> callMACRO( "funcHB(1,2,3)" ) </button>'
html += '  <button onclick="disp3()"> hb_memoread( "demo1.prg" )   </button>'
html += '  <button onclick="disp4()"> GetAllFuncNames()            </button>'
html += '  <pre id="idResult"></pre>'
html += '</div>'
html += '<script>'
html += '   async function disp1(){'
html += '      document.getElementById("idResult").textContent = "Counter: " + await callHB("funcHB",1,2,3);'
html += '   }'
html += '   async function disp2(){'
html += '      document.getElementById("idResult").textContent = "Counter: " + await callMACRO( "funcHB(1,2,3)" );'
html += '   }'
html += '   async function disp3(){'
html += '      document.getElementById("idResult").textContent = await hb_memoread("demo1.prg");'
html += '      await msginfo("HB_MemoRead(\"demo1.prg\") done!", "Hello HMG");'
html += '   }'
html += '   async function disp4(){'
html += '      let aList = await GetAllFuncNames();'
html += '      let result = "";'
html += '      for( let i=0; i < aList.length; i++ )'
html += '         result += ("" + (i+1) + ") " + aList[i].toString()).padEnd(30) + ( (i+1)%3 == 0 ? "\n" : "" );'
html += '      document.getElementById("idResult").textContent = "List of all functions available in the Harbour environment in this instance: \n\n" + result;'
html += '   }'
html += '</script>'

hWnd = NUM2PTR( Win_2.Handle )

allowDevTools = .T.

   w = hb_webview_create( allowDevTools, hWnd )

hWidget = hb_webview_get_native_handle( w, WEBVIEW_NATIVE_HANDLE_KIND_UI_WIDGET )

      hb_webview_set_size(w, 480, 320, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - Bind Demo")

/*
   Remember that JavaScript is case sensitive: 
   If you bind the HB_ALERT() function as "hb_Alert" in the Harbour environment, 
   you must call it as hb_Alert() in JavaScript environment.

   On the other hand, Harbour binding functions are passed as promises to JavaScript. 
   Therefore, they are executed in the JavaScript environment as asynchronous functions.

   For more details on promises in JavaScript, see:
   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

   For promises to execute synchronously, you must chain the calls in chained .then() statements 
   or call them with the await statement inside an asynchronous function.
   For more details see:
   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then
   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await

*/

      context1 = hb_webview_bind2(w, "callHB",       HB_CALL_FUNC_INDIRECT)  // e.g. callHB( "hb_memoread", "text.txt" )
      context2 = hb_webview_bind2(w, "callMACRO",    HB_CALL_FUNC_MACRO)     // e.g. callMACRO( 'hb_memoread("text.txt")' )

      context3 = hb_webview_bind2(w, "hb_memoread",  HB_CALL_FUNC_DIRECT)    // e.g. hb_memoread( "text.txt" )
      context4 = hb_webview_bind2(w, "msginfo",      HB_CALL_FUNC_DIRECT)    // e.g. msginfo( "Hello Harbour" )

      context5 = hb_webview_bind2(w, "GetAllFuncNames", HB_CALL_FUNC_DIRECT)

      hb_webview_set_html(w, html)

   Win_2.Center
   Win_2.show

   Win_2.Activate

   hb_webview_destroy_context( context1 )
   hb_webview_destroy_context( context2 )
   hb_webview_destroy_context( context3 )
   hb_webview_destroy_context( context4 )
   hb_webview_destroy_context( context5 )

// hb_webview_terminate( w )

RETURN NIL



FUNCTION funcHB( a, b, c )
STATIC r := 0
   r += a + b + c
RETURN r



FUNCTION GetAllFuncNames()
LOCAL i, cSymName, aSym := {}
/*
__DYNSCOUNT()    // How much symbols do we have:    dsCount = __dynsCount()
__DYNSGETNAME()  // Get name of symbol:             cSymbol = __dynsGetName( dsIndex )
__DYNSGETINDEX() // Get index number of symbol:     dsIndex = __dynsGetIndex( cSymbol )
__DYNSISFUN()    // returns .T. if a symbol has a function/procedure pointer given its symbol index or name:   __DynsIsFun( cSymbol | dsIndex )
HB_ISFUNCTION()  // returns .T. if a symbol has a function/procedure pointer:                                  hb_IsFunction( cSymbol )
*/
   FOR i := __dynsCount() TO 1 STEP -1
      cSymName := __dynsGetName( i )
      IF __DynsIsFun( cSymName )
         AAdd( aSym, cSymName )
      ENDIF
   NEXT
RETURN aSym



/******************************************************************************************************************/


REQUEST FCount, FieldName, FieldGet, FieldPut, dbAppend, dbDelete, RecNo, LastRec, dbSkip, dbGoTop, dbGoBottom, Bof, Eof, hb_alert

*--------------------------------------------------------*
FUNCTION demo3
*--------------------------------------------------------*
LOCAL w, allowDevTools, i, cAbsolutePath, hWnd, hWidget

LOCAL aListFunc := { "FCount", "FieldName", "FieldGet", "FieldPut", "dbAppend", "dbDelete", "RecNo", ;
                     "LastRec", "dbSkip", "dbGoTop", "dbGoBottom", "Bof", "Eof", "hb_alert" }
LOCAL aContext := {}

DECLARE WINDOW Win_3

   IF IsWindowDefined( Win_3 ) == .T.
      Win_3.SetFocus
      RETURN NIL
   ENDIF

   DEFINE WINDOW Win_3 ;
      ROW 0 ;
      COL 0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "HMG WebView2";
      ON INIT     RESIZE_WEBVIEW2( hWidget );
      ON SIZE     RESIZE_WEBVIEW2( hWidget );
      ON MAXIMIZE RESIZE_WEBVIEW2( hWidget );
      ON RELEASE  CloseTable();
      WINDOWTYPE STANDARD

   END WINDOW

OpenTable()

hWnd = NUM2PTR( Win_3.Handle )

allowDevTools = .T.

   w = hb_webview_create( allowDevTools, hWnd )

hWidget = hb_webview_get_native_handle( w, WEBVIEW_NATIVE_HANDLE_KIND_UI_WIDGET )

      hb_webview_set_size(w, 800, 480, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - Data Base Demo")

/*
   Remember that JavaScript is case sensitive: 
   If you bind the HB_ALERT() function as "hb_Alert" in the Harbour environment, 
   you must call it as hb_Alert() in JavaScript environment.

   On the other hand, Harbour binding functions are passed as promises to JavaScript. 
   Therefore, they are executed in the JavaScript environment as asynchronous functions.

   For more details on promises in JavaScript, see:
   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

   For promises to execute synchronously, you must chain the calls in chained .then() statements 
   or call them with the await statement inside an asynchronous function.
   For more details see:
   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then
   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await

*/

      FOR i = 1 TO LEN( aListFunc )
         AADD( aContext, hb_webview_bind2(w, aListFunc[ i ],  HB_CALL_FUNC_DIRECT) )   // e.g. call hb_memoread( "text.txt" )
      NEXT

      cAbsolutePath = hb_CurDrive() + ":"+ hb_osPathSeparator() + CurDir() + hb_osPathSeparator()  // absolute path in Windows like C:\Users\srvet\Downloads\hb_webview\ 
      // hb_alert( cAbsolutePath )

      hb_webview_navigate(w, "file:///" + cAbsolutePath + "database_demo.html")   // load local html file

   Win_3.Center
   Win_3.show

   Win_3.Activate

   FOR i = 1 TO LEN( aContext )
      hb_webview_destroy_context( aContext[ i ] )
   NEXT

// hb_webview_terminate( w )

RETURN NIL



FUNCTION OpenTable
LOCAL aStruct, cFileName := "database_demo.dbf"

   IF File( cFileName )
      dbUseArea( .T., NIL, cFileName )
   ELSE
      aStruct :=  {{ "CODE",      "C",  3, 0 },;
                   { "NAME",      "C", 50, 0 },;
                   { "RESIDENTS", "N", 11, 0 };
                  }
      dbCreate("database_demo.dbf", aStruct, NIL, .T.)

      dbAppend()
      REPLACE CODE WITH 'LTU', NAME WITH 'Lithuania', RESIDENTS WITH 3369600

      dbAppend()
      REPLACE CODE WITH 'USA', NAME WITH 'United States of America', RESIDENTS WITH 305397000

      dbAppend()
      REPLACE CODE WITH 'POR', NAME WITH 'Portugal', RESIDENTS WITH 10617600

      dbAppend()
      REPLACE CODE WITH 'POL', NAME WITH 'Poland', RESIDENTS WITH 38115967

      dbAppend()
      REPLACE CODE WITH 'AUS', NAME WITH 'Australia', RESIDENTS WITH 21446187

      dbAppend()
      REPLACE CODE WITH 'FRA', NAME WITH 'France', RESIDENTS WITH 64473140

      dbAppend()
      REPLACE CODE WITH 'RUS', NAME WITH 'Russia', RESIDENTS WITH 141900000

      dbGoTop()
   ENDIF
RETURN NIL


FUNCTION CloseTable
      dbCloseArea()
RETURN NIL



FUNCTION runPrg( cCodePrg, includePATH, includeFILE )
LOCAL pPP, cPreprocessedCode, cBufferCompile, pHrb, ret

// cCodePrg := hb_memoread( "myFunc.prg" )
// includePATH = "C:\harbour\include"
// includeFILE = "directry.ch"

   IF Empty( includePATH )
      includePATH = ""
   ENDIF

   IF Empty( includeFILE )
      includeFILE = ""
   ENDIF

   pPP := __PP_Init( includePATH, includeFILE )
   cPreprocessedCode :=__PP_Process( pPP, cCodePrg )
   pPP := NIL

// hb_memowrit("result_code.pp", cPreprocessedCode)

   cBufferCompile := HB_CompileFromBuf( cPreprocessedCode, .T., "-n", "-q2", "-I" + includePATH )

   IF !Empty( cBufferCompile )
         pHrb := hb_HrbLoad( cBufferCompile )
      IF !Empty( pHrb )
         ret = hb_hrbDo( pHrb )
      ENDIF
      hb_HrbUnload( pHrb )
   ENDIF
RETURN ret





/******************************************************************************************************************/



//=================================================================================================================

#pragma BEGINDUMP

#include "SET_COMPILE_HMG_UNICODE.ch"
#include "HMG_UNICODE.h"
#include <windows.h>
#include "hbapi.h"


#define CINTERFACE
#include "WebView2/WebView2.h"
#include "WebView2/EventToken.h"

// #include "../WebView2/WebView2.h"
// #include "../WebView2/EventToken.h"

void resize_webview(HWND m_widget, ICoreWebView2Controller* m_controller) {
   if (m_widget && m_controller) {
      RECT bounds;
      if (GetClientRect(m_widget, &bounds)) {
#ifdef CINTERFACE
         m_controller->lpVtbl->put_Bounds(m_controller, bounds);
#else
         m_controller->put_Bounds(bounds);
#endif
      }
   }
}



void resize_widget(HWND m_widget) {
   if (m_widget) {
      RECT r;
      if (GetClientRect(GetParent(m_widget), &r)) {
        MoveWindow(m_widget, r.left, r.top, r.right - r.left, r.bottom - r.top, TRUE);
      }
   }
}



HB_FUNC( RESIZE_WEBVIEW2 ){
   HWND hWndWidget = (HWND) hb_parptr( 1 );
   resize_widget(hWndWidget);
}



HB_FUNC( SETTINGS_WEBVIEW2 ){
   ICoreWebView2Controller *m_controller = (ICoreWebView2Controller*) hb_parptr( 1 ); // --> hb_webview_get_native_handle(w, WEBVIEW_NATIVE_HANDLE_KIND_BROWSER_CONTROLLER)
   ICoreWebView2           *m_webview2;
   ICoreWebView2Settings   *m_settings;
#ifdef CINTERFACE
   m_controller->lpVtbl->get_CoreWebView2( m_controller, &m_webview2 );
   m_webview2->lpVtbl->get_Settings(m_webview2, &m_settings);

   m_settings->lpVtbl->put_IsScriptEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_AreDefaultScriptDialogsEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_IsWebMessageEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_AreDevToolsEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_AreDefaultContextMenusEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_IsStatusBarEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_AreHostObjectsAllowed(m_settings, TRUE);
   m_settings->lpVtbl->put_IsBuiltInErrorPageEnabled(m_settings, TRUE);
   m_settings->lpVtbl->put_IsZoomControlEnabled(m_settings, TRUE);
#else
   m_controller->get_CoreWebView2( &m_webview2 );
   m_webview2->get_Settings( &m_settings );

   m_settings->put_IsScriptEnabled( TRUE );
   m_settings->put_AreDefaultScriptDialogsEnabled( TRUE );
   m_settings->put_IsWebMessageEnabled( TRUE );
   m_settings->put_AreDevToolsEnabled( TRUE );
   m_settings->put_AreDefaultContextMenusEnabled( TRUE );
   m_settings->put_IsStatusBarEnabled( TRUE );
   m_settings->put_AreHostObjectsAllowed( TRUE );
   m_settings->put_IsBuiltInErrorPageEnabled( TRUE );
   m_settings->put_IsZoomControlEnabled( TRUE );
#endif
}



HB_FUNC( ACTION_WEBVIEW2 ){
   ICoreWebView2           *m_webview2;
   ICoreWebView2Controller *m_controller = (ICoreWebView2Controller*) hb_parptr( 1 ); // --> hb_webview_get_native_handle(w, WEBVIEW_NATIVE_HANDLE_KIND_BROWSER_CONTROLLER)
   int nAction = hb_parni( 2 );
#ifdef CINTERFACE
   m_controller->lpVtbl->get_CoreWebView2( m_controller, &m_webview2 );
#else
   m_controller->get_CoreWebView2( &m_webview2 );
#endif
   switch( nAction ){
      case 0:
         WCHAR *URI;
#ifdef CINTERFACE
         m_webview2->lpVtbl->get_Source(m_webview2, (WCHAR **) &URI);
#else
         m_webview2->get_Source((WCHAR **) &URI);
#endif
         hb_retc( HMG_WCHAR_TO_CHAR( URI ) );
         break;
      case 1:
#ifdef CINTERFACE
         m_webview2->lpVtbl->OpenDevToolsWindow( m_webview2 );
#else
         m_webview2->OpenDevToolsWindow();
#endif
         break;
      case 2:
#ifdef CINTERFACE
         m_webview2->lpVtbl->GoBack( m_webview2 );
#else
         m_webview2->GoBack();
#endif
         break;
      case 3:
#ifdef CINTERFACE
         m_webview2->lpVtbl->GoForward( m_webview2 );
#else
         m_webview2->GoForward();
#endif
         break;
      case 4:
#ifdef CINTERFACE
         m_webview2->lpVtbl->Reload( m_webview2 );
#else
         m_webview2->Reload();
#endif
         break;
      case 5:
#ifdef CINTERFACE
         m_webview2->lpVtbl->Stop(m_webview2);
#else
         m_webview2->Stop();
#endif
         break;
   }
}



HB_FUNC( GETVERSION_WEBVIEW2 )
{
   WCHAR *ver;
//   GetAvailableCoreWebView2BrowserVersionString( NULL , (WCHAR **) &ver );
   hb_retc( HMG_WCHAR_TO_CHAR( ver ) );
}



HB_FUNC( NUM2PTR ){   // Harbour MiniGUI use integers instead of pointers for Window handles.
#if defined ( _WIN64 )
   void *ptr = (void *) hb_parnll( 1 );
#else
   void *ptr = (void *) hb_parnl ( 1 );
#endif
   hb_retptr( ptr );
}


#pragma ENDDUMP
