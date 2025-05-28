/*
 * HB_WebView Demo
 *
 * Copyright 2025 by Dr. Claudio Soto (from Uruguay). 
 * mail: <srvet@adinet.com.uy>
 * blog: http://srvet.blogspot.com
 */

#include "hb_webview.ch"

// #include "../hb_webview-lib/hb_webview.ch"
// #include "hb_webview-lib/hb_webview.prg"


REQUEST Directory, hb_DirBase, hb_osPathSeparator, hb_CurDrive, hb_osDriveSeparator, hb_MemoRead, hb_Alert

REQUEST HB_CODEPAGE_ESWIN  // request your ANSI codepage


FUNCTION Main
LOCAL w, allowDevTools
LOCAL aListFunc := { "directory", "hb_dirbase", "hb_ospathseparator", "hb_curdrive", "hb_osdriveseparator", "hb_memoread", "hb_alert" } 
LOCAL aContext1 := {}, aContext2 := {}, context, i


//LOCAL myCP := "ESWIN"  // your ANSI codepage ( e.g. ESWIN )
LOCAL myCP := "cp1252"  // your ANSI codepage ( e.g. Windows-1252 )

#if 1
   SET( _SET_CODEPAGE, "UTF8" )
   hb_webview_translate_ansi_codepage( myCP )   // Enter your ANSI codepage here to work with ANSI data
#else
   SET( _SET_CODEPAGE, myCP )
#endif

allowDevTools = .T.

   w = hb_webview_create( allowDevTools, NIL )

      hb_webview_set_size(w, 800, 480, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - Directory Demo")

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
         AADD( aContext1, hb_webview_bind2(w, aListFunc[ i ],  HB_CALL_FUNC_DIRECT) )   // e.g. hb_memoread( "text.txt" )
      NEXT

      aContext2 = hb_webview_bind_webview( w )   // bind all webview functions

      hb_webview_unbind(w, "js_hb_webview_set_html")
      context = hb_webview_bind2(w, "js_hb_webview_set_html", HB_CALL_FUNC_DIRECT, .T., NIL)  // no translate parameters to ANSI, always are UTF8

      hb_webview_navigate(w, "file:///" + hb_DirBase() + "directory_demo.html")   // load local html file

   hb_webview_run(w)

   FOR i = 1 TO LEN( aContext1 )
      hb_webview_destroy_context( aContext1[ i ] )
   NEXT

   FOR i = 1 TO LEN( aContext2 )
      hb_webview_destroy_context( aContext2[ i ] )
   NEXT

   hb_webview_destroy_context( context )

   hb_webview_terminate( w )

RETURN NIL



/************************************************************************************************/

/*
   Since pointers cannot be passed as such from Harbour to JavaScript, you cannot 
   directly bind Webview functions to JavaScript. You must first create a small 
   wrapper for the Webview functions to convert the pointers to integers.
*/


FUNCTION js_hb_webview_create( debug, window )
LOCAL w := hb_webview_create( debug, window )
RETURN PTR2NUM( w )

FUNCTION js_hb_webview_destroy( w )
RETURN hb_webview_destroy( NUM2PTR( w ) )

FUNCTION js_hb_webview_run( w )
RETURN hb_webview_run( NUM2PTR( w ) )

FUNCTION js_hb_webview_terminate( w )
RETURN hb_webview_terminate( NUM2PTR( w ) )

FUNCTION js_hb_webview_get_window( w )
LOCAL window := hb_webview_get_window( NUM2PTR( w ) )
RETURN PTR2NUM( window )

FUNCTION js_hb_webview_get_native_handle( w, kind )
LOCAL handle := hb_webview_get_native_handle( NUM2PTR( w ), kind )
RETURN PTR2NUM( handle )

FUNCTION js_hb_webview_set_title( w, title )
RETURN hb_webview_set_title( NUM2PTR( w ), title )

FUNCTION js_hb_webview_set_size( w, width, height, hints )
RETURN hb_webview_set_size( NUM2PTR( w ), width, height, hints )

FUNCTION js_hb_webview_navigate( w, url )
RETURN hb_webview_navigate( NUM2PTR( w ), url )

FUNCTION js_hb_webview_set_html( w, html )
RETURN hb_webview_set_html( NUM2PTR( w ), html )

FUNCTION js_hb_webview_init( w, js )
RETURN hb_webview_init( NUM2PTR( w ), js )

FUNCTION js_hb_webview_eval( w, js )
RETURN hb_webview_eval( NUM2PTR( w ), js )

FUNCTION js_hb_webview_bind2( w, funcName, callType )
LOCAL context := hb_webview_bind2( NUM2PTR( w ), funcName, callType )
RETURN PTR2NUM( context )

FUNCTION js_hb_webview_unbind( w, funcName )
RETURN hb_webview_unbind( NUM2PTR( w ), funcName )

FUNCTION js_hb_webview_destroy_context( context )
RETURN hb_webview_destroy_context( NUM2PTR( context ) )

FUNCTION js_hb_webview_version()
RETURN hb_webview_version()

FUNCTION js_hb_webview_wrapper_version()
RETURN hb_webview_wrapper_version()

FUNCTION js_hb_webview_translate_ansi_codepage( cCP )
RETURN hb_webview_translate_ansi_codepage( cCP )


FUNCTION hb_webview_bind_webview( w )
LOCAL i, aContext := {}

LOCAL aListFunc := { ;
   "js_hb_webview_create", ;
   "js_hb_webview_destroy", ;
   "js_hb_webview_run", ;
   "js_hb_webview_terminate", ;
   "js_hb_webview_get_window", ;
   "js_hb_webview_get_native_handle", ;
   "js_hb_webview_set_title", ;
   "js_hb_webview_set_size", ;
   "js_hb_webview_navigate", ;
   "js_hb_webview_set_html", ;
   "js_hb_webview_init", ;
   "js_hb_webview_eval", ;
   "js_hb_webview_bind2", ;
   "js_hb_webview_translate_ansi_codepage", ;
   "js_hb_webview_unbind", ;
   "js_hb_webview_destroy_context", ;
   "js_hb_webview_version", ;
   "js_hb_webview_wrapper_version"  }

   FOR i = 1 TO LEN( aListFunc )
      AADD( aContext, hb_webview_bind2( w, aListFunc[ i ],  HB_CALL_FUNC_DIRECT) )
   NEXT

RETURN aContext


/************************************************************************************************/


#pragma BEGINDUMP

#include "hbdefs.h"
#include "hbapi.h"


HB_FUNC( NUM2PTR ){
   #if defined ( HB_ARCH_64BIT )
      void *ptr = (void *) hb_parnll( 1 );
   #else
      void *ptr = (void *) hb_parnl ( 1 );
   #endif
   hb_retptr( ptr );
}


HB_FUNC( PTR2NUM ){
   #if defined ( HB_ARCH_64BIT )
      HB_LONGLONG nPtr = ( HB_LONGLONG ) hb_parptr( 1 );
      hb_retnll( nPtr );
   #else
      int nPtr = (int) hb_parptr( 1 );
      hb_retnl( nPtr );
   #endif
}


HB_FUNC( IS64BIT ){
   #if defined ( HB_ARCH_64BIT )
      hb_retl( 1 );
   #else
      hb_retl( 0 );
   #endif
}


#pragma ENDDUMP
