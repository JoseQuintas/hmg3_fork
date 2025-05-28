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


REQUEST dbUseArea, dbCloseArea, FCount, FieldName, FieldGet, FieldPut, dbAppend, dbDelete, RecNo, LastRec, dbSkip, dbGoTop, dbGoBottom, Bof, Eof
REQUEST File, Used, hb_alert


FUNCTION Main
LOCAL w, allowDevTools
LOCAL context

allowDevTools = .T.

   w = hb_webview_create( allowDevTools, NIL )

      hb_webview_set_size(w, 800, 480, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - Run PRG Code Demo")

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
      context = hb_webview_bind2(w, "runPrg", HB_CALL_FUNC_DIRECT)

      hb_webview_navigate(w, "file:///" + hb_DirBase() + "runprg_demo.html")   // load local html file

   hb_webview_run(w)

   hb_webview_destroy_context( context )

   hb_webview_terminate( w )

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

