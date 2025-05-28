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


FUNCTION Main
LOCAL w, allowDevTools := .F.

   w = hb_webview_create( allowDevTools, NIL )

      hb_webview_set_size(w, 800, 480, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - Navigate Demo")

      hb_webview_navigate(w, "https://harbour.github.io/doc/")

   hb_webview_run(w)

   hb_webview_terminate( w )

RETURN NIL
