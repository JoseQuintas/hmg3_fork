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


REQUEST hb_alert, hb_memoread, hb_memowrit

FUNCTION Main
LOCAL w, html, allowDevTools
LOCAL context1, context2, context3, context4, context5


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
html += '      hb_alert("HB_MemoRead(\"demo1.prg\") done!");'
html += '   }'
html += '   async function disp4(){'
html += '      let aList = await GetAllFuncNames();'
html += '      let result = "";'
html += '      for( let i=0; i < aList.length; i++ )'
html += '         result += ("" + (i+1) + ") " + aList[i].toString()).padEnd(30) + ( (i+1)%3 == 0 ? "\n" : "" );'
html += '      document.getElementById("idResult").textContent = "List of all functions available in the Harbour environment in this instance: \n\n" + result;'
html += '   }'
html += '</script>'

allowDevTools = .T.

   w = hb_webview_create( allowDevTools, NIL )

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
      context4 = hb_webview_bind2(w, "hb_alert",     HB_CALL_FUNC_DIRECT)    // e.g. hb_alert( "Hello Harbour" )

      context5 = hb_webview_bind2(w, "GetAllFuncNames", HB_CALL_FUNC_DIRECT)

      hb_webview_set_html(w, html)

   hb_webview_run(w)

   hb_webview_destroy_context( context1 )
   hb_webview_destroy_context( context2 )
   hb_webview_destroy_context( context3 )
   hb_webview_destroy_context( context4 )
   hb_webview_destroy_context( context5 )

   hb_webview_terminate( w )

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

