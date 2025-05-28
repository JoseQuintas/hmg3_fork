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


REQUEST FCount, FieldName, FieldGet, FieldPut, dbAppend, dbDelete, RecNo, LastRec, dbSkip, dbGoTop, dbGoBottom, Bof, Eof, hb_alert


FUNCTION Main
LOCAL w, allowDevTools, i

LOCAL aListFunc := { "FCount", "FieldName", "FieldGet", "FieldPut", "dbAppend", "dbDelete", "RecNo", ;
                     "LastRec", "dbSkip", "dbGoTop", "dbGoBottom", "Bof", "Eof", "hb_alert" }
LOCAL aContext := {}

allowDevTools = .T.

OpenTable()

   w = hb_webview_create( allowDevTools, NIL )

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
         AADD( aContext, hb_webview_bind2(w, aListFunc[ i ],  HB_CALL_FUNC_DIRECT) )   // e.g. hb_memoread( "text.txt" )
      NEXT

      hb_webview_navigate(w, "file:///" + hb_DirBase() + "dbf_demo.html")   // load local html file

   hb_webview_run(w)

   FOR i = 1 TO LEN( aContext )
      hb_webview_destroy_context( aContext[ i ] )
   NEXT

   hb_webview_terminate( w )

CloseTable()

RETURN NIL


*--------------------------------------------------------*
FUNCTION OpenTable
*--------------------------------------------------------*
LOCAL aStruct, cFileName := "database_demo.dbf"

   IF File( cFileName )
      dbUseArea( .T., NIL, cFileName )
   ELSE
      aStruct :=  {{ "CODE",      "C",  3, 0 },;
                   { "NAME",      "C", 50, 0 },;
                   { "RESIDENTS", "N", 11, 0 };
                  }
      dbCreate( cFileName, aStruct, NIL, .T. )

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


*--------------------------------------------------------*
FUNCTION CloseTable
*--------------------------------------------------------*

      dbCloseArea()

RETURN NIL
