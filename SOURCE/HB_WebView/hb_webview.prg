/*
 * HB_WebView 
 * Harbour wrapper for the cross-platform
 * Webview C/C++ library ( https://github.com/webview/webview )
 *
 * Copyright 2025 by Dr. Claudio Soto (from Uruguay). 
 *
 * mail: <srvet@adinet.com.uy>
 * blog: http://srvet.blogspot.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file LICENSE.txt.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA (or visit https://www.gnu.org/licenses/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

// #define HB_WEBVIEW_DEBUG

#include "hb_webview.ch"

STATIC _ANSI_codepage_ := NIL

FUNCTION hb_webview_HbBridgeJS( par_cJsPromiseId, par_cJsonParameter, par_ptrContext, par_cFuncName, par_nCallType, ;
                                no_translate_param_toANSI, no_translate_ret_toUTF8 )
LOCAL i, ini
LOCAL nLen
LOCAL aJsonFields
LOCAL cCodeInvoke
LOCAL xResult
LOCAL ret

   HB_SYMBOL_UNUSED( par_cJsPromiseId )
   HB_SYMBOL_UNUSED( par_ptrContext )

   IF ( no_translate_param_toANSI == .T. ) .OR. ( hb_cdpSelect() == "UTF8" ) //.OR. ( _ANSI_codepage_  == "UTF8" )
      aJsonFields = hb_jsonDecode( par_cJsonParameter )   // Parameters in UTF8
   ELSE
      aJsonFields = hb_jsonDecode( hb_UTF8ToStr( par_cJsonParameter, _ANSI_codepage_ ) )   // Parameters in UTF8 or ANSI, depends of the codepage
   ENDIF

   nLen = len( aJsonFields )

   IF par_nCallType == HB_CALL_FUNC_MACRO
      cCodeInvoke = aJsonFields[ 1 ]            // hb_webview_bind2() --> par_cJsonParameter --> e.g. [ 'hb_memoread("text.txt")' ]
   ELSE

      IF par_nCallType == HB_CALL_FUNC_DIRECT
         cCodeInvoke = par_cFuncName +"( "      // hb_webview_bind2() --> par_cJsonParameter --> e.g. [ "c:/text.txt" ]
         ini = 1
      ELSE   // HB_CALL_FUNC_INDIRECT
         cCodeInvoke = aJsonFields[ 1 ] +"( "   // hb_webview_bind()  --> par_cJsonParameter --> e.g. [ "hb_MemoRead", "c:/text.txt" ]
         ini = 2
      ENDIF

      FOR i = ini TO nLen
         cCodeInvoke += hb_ValToExp( aJsonFields[ i ] ) + IIF(i < nLen, ", ", "")
      NEXT
      cCodeInvoke += " )"

   ENDIF

#ifdef HB_WEBVIEW_DEBUG
      hb_alert( cCodeInvoke + hb_eol() + ;
                par_cJsonParameter + hb_eol() + ;
                par_cFuncName + " | " + hb_NToS( par_nCallType ) + hb_eol() + ;
                hb_ValToExp( no_translate_param_toANSI ) + " | " + hb_ValToExp( no_translate_ret_toUTF8 ) ;
              )
#endif

   xResult = &cCodeInvoke  // --> e.g. &'hb_MemoRead("c:/text.txt")'

   ret = hb_jsonEncode( xResult )   // Return UTF8 or ANSI, depends of the codepage

//   IF( ( no_translate_ret_toUTF8 != .T. ) .AND. ( ;
//       ( hb_StrIsUTF8( ret ) == .F. .AND. _ANSI_codepage_ != "UTF8" ) .OR. ;
//       ( hb_StrIsUTF8( ret ) == .F. .AND. Empty( _ANSI_codepage_ ) .AND. hb_cdpSelect() != "UTF8" ) ) )

   IF ( no_translate_ret_toUTF8 == .F. ) .AND. ( hb_StrIsUTF8( ret ) == .F. )
      ret = hb_StrToUTF8( ret, _ANSI_codepage_ )   // Return in UTF8
   ENDIF

RETURN ret



FUNCTION hb_webview_translate_ansi_codepage( cCP, lSet )
LOCAL oldCP := _ANSI_codepage_
   IF lSet != .F.
      _ANSI_codepage_ = cCP
   ENDIF
RETURN oldCP



FUNCTION hb_webview_bind2( w, cFuncName, nCallType, no_translate_param_toANSI, no_translate_ret_toUTF8 )
LOCAL context
   cFuncName = AllTrim( cFuncName )
   context = hb_webview_create_context( w, cFuncName, nCallType, no_translate_param_toANSI, no_translate_ret_toUTF8, NIL /* cargo */ )
   hb_webview_bind( w, cFuncName, NIL /* ptrFunc*/, context)
RETURN context



FUNCTION hb_webview_wrapper_version()
LOCAL major := 1
LOCAL minor := 1
LOCAL patch := 0
LOCAL cVer  := hb_StrFormat( "%d.%d.%d", major, minor, patch )
LOCAL cCopyright := ""
   cCopyright += "HB_WebView   Ver " + cVer + hb_eol()
   cCopyright += "Harbour wrapper for the cross-platform Webview C/C++ library" + hb_eol()
   cCopyright += hb_eol()
   cCopyright += "Copyright 2025 by Dr. Claudio Soto (from Uruguay)." + hb_eol() 
   cCopyright += hb_eol()
   cCopyright += "mail: <srvet@adinet.com.uy>" + hb_eol()
   cCopyright += "blog: http://srvet.blogspot.com" + hb_eol()
RETURN { major, minor, patch, cVer, cCopyright }



//=================================================================================================================

#pragma BEGINDUMP


#include <windows.h>

#include "WebView2/WebView2.h"
#include "WebView2/EventToken.h"

#include "webview-master/core/include/webview/webview.h"    // link to the source code of the webview library

#include "webview-master/core/include/webview/api.h"        // webview library api header file

#include "hbapi.h"
#include "hbvm.h"


#define MAX_LEN_NAME 256


/// Type of way in which Harbour functions are called

#define HB_CALL_FUNC_INDIRECT    0     // e.g. callHB( "hb_memoread", "text.txt" )     --> &'hb_memoread("text.txt")'
#define HB_CALL_FUNC_DIRECT      1     // e.g. hb_memoread( "text.txt" )               --> &'hb_memoread("text.txt")'
#define HB_CALL_FUNC_MACRO       2     // e.g. callMACRO( 'hb_memoread("text.txt")' )  --> &'hb_memoread("text.txt")'



typedef struct {
   webview_t w;
   char func_name [ MAX_LEN_NAME ];
   int  call_type;
   int  no_translate_param_toANSI;
   int  no_translate_ret_toUTF8;
   void *cargo;
} hb_webview_context_t;


HB_FUNC( HB_WEBVIEW_CREATE_CONTEXT ){
   webview_t w    = (webview_t *) hb_parptr( 1 );
   const char * func_name = hb_parc( 2 );
   int call_type  = hb_parni( 3 );
   int  no_translate_param_toANSI = hb_parl( 4 );
   int  no_translate_ret_toUTF8  = hb_parl( 5 );
   void *cargo    = hb_parptr( 6 );
   hb_webview_context_t * context = (hb_webview_context_t *) hb_xgrab( sizeof( hb_webview_context_t ) );
   context->w = w;
   strcpy( context->func_name, ( func_name ? func_name : "" ) );
   context->call_type = call_type;
   context->no_translate_param_toANSI = no_translate_param_toANSI;
   context->no_translate_ret_toUTF8 = no_translate_ret_toUTF8;
   context->cargo = cargo;
   hb_retptr( (void *) context );
}


HB_FUNC( HB_WEBVIEW_DESTROY_CONTEXT ){
   void * context = hb_parptr( 1 );
   if( context )
      hb_xfree( context );
   context = NULL;
}


char hb_callback_function_name [ MAX_LEN_NAME ] = { 0 };


HB_FUNC( HB_WEBVIEW_SET_CALLHB_FUNC ){
   strcpy( hb_callback_function_name, hb_parc( 1 ) );
}


void hb_callFunc( const char *id, const char *req, void *arg ){
   hb_webview_context_t *context = (hb_webview_context_t *)arg;
   hb_vmPushSymbol( hb_dynsymGetSymbol( strlen( hb_callback_function_name ) > 0 ? hb_callback_function_name : "hb_webview_HbBridgeJS" ) );
   hb_vmPushNil();
   hb_vmPushString( id, strlen( id ) );
   hb_vmPushString( req, strlen( req ) );
   hb_vmPushPointer( arg );
   hb_vmPushString( context->func_name, strlen( context->func_name ) );
   hb_vmPushInteger( context->call_type );
   hb_vmPushLogical( context->no_translate_param_toANSI );
   hb_vmPushLogical( context->no_translate_ret_toUTF8 );
   hb_vmFunction( 7 );
   if( HB_ISCHAR( -1 ) ){
      const char * result = hb_parc( -1 );
      webview_return(context->w, id, 0, result);
   }
}


HB_FUNC( HB_WEBVIEW_CREATE ) {
   int debug    = hb_parl  ( 1 );
   void *window = hb_parptr( 2 );
   webview_t w  = webview_create( debug, window );
   hb_retptr( (void *) w );
}


HB_FUNC( HB_WEBVIEW_DESTROY ) {
   webview_t w = (webview_t *) hb_parptr( 1 );
   int error   = webview_destroy( w );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_RUN ) {
   webview_t w = (webview_t *) hb_parptr( 1 );
   int error   = webview_run( w );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_TERMINATE ) {
   webview_t w = (webview_t *) hb_parptr( 1 );
   int error   = webview_terminate( w );
   hb_retni( error );
}


typedef void (*dispatch_fn)(webview_t w, void *arg);

HB_FUNC( HB_WEBVIEW_DISPATCH ) {
   webview_t w    = (webview_t *) hb_parptr( 1 );
   dispatch_fn fn = ( dispatch_fn ) hb_parptr( 2 );
   void *arg      =  hb_parptr( 3 );
   int error      = webview_dispatch( w, fn, arg );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_GET_WINDOW ) {
   webview_t w    = (webview_t *) hb_parptr( 1 );
   void *handle   = webview_get_window( w );
   hb_retptr( handle );
}


HB_FUNC( HB_WEBVIEW_GET_NATIVE_HANDLE ) {
   webview_t w                        = (webview_t *) hb_parptr( 1 );
   webview_native_handle_kind_t kind  = (webview_native_handle_kind_t) hb_parni( 2 );
   void *handle                       = webview_get_native_handle( w, kind );
   hb_retptr( handle );
}


HB_FUNC( HB_WEBVIEW_SET_TITLE ) {
   webview_t w       = (webview_t *) hb_parptr( 1 );
   const char *title = hb_parc( 2 );
   int error         = webview_set_title( w, title );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_SET_SIZE ) {
   webview_t w          = (webview_t *) hb_parptr( 1 );
   int width            = hb_parni( 2 );
   int height           = hb_parni( 3 );
   webview_hint_t kind  = (webview_hint_t) hb_parni( 4 );
   int error            = webview_set_size( w, width, height, kind );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_NAVIGATE ) {
   webview_t w     = (webview_t *) hb_parptr( 1 );
   const char *url = hb_parc( 2 );
   int error       = webview_navigate( w, url );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_SET_HTML ) {
   webview_t w      = (webview_t *) hb_parptr( 1 );
   const char *html = hb_parc( 2 );
   int error        = webview_set_html( w, html );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_INIT ) {
   webview_t w    = (webview_t *) hb_parptr( 1 );
   const char *js = hb_parc( 2 );
   int error      = webview_init( w, js );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_EVAL ) {
   webview_t w    = (webview_t *) hb_parptr( 1 );
   const char *js = hb_parc( 2 );
   int error      = webview_eval( w, js );
   hb_retni( error );
}


typedef void (*bind_fn)(const char *id, const char *req, void *arg );

HB_FUNC( HB_WEBVIEW_BIND ) {
   webview_t w      = (webview_t *) hb_parptr( 1 );
   const char *name = hb_parc( 2 ) ? hb_parc( 2 ) : "";
   bind_fn fn       = hb_parptr( 3 ) ? ( bind_fn ) hb_parptr( 3 ) : &hb_callFunc;
   void *arg        =  hb_parptr( 4 );
   int error        = webview_bind( w, name, fn, arg );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_UNBIND ) {
   webview_t w      = (webview_t *) hb_parptr( 1 );
   const char *name = hb_parc( 2 );
   int error        = webview_unbind( w, name );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_RETURN ) {
   webview_t w        = (webview_t *) hb_parptr( 1 );
   const char *id     = hb_parc( 2 );
   int status         = hb_parni( 3 );
   const char *result = hb_parc( 4 );
   int error          = webview_return( w, id, status, result );
   hb_retni( error );
}


HB_FUNC( HB_WEBVIEW_VERSION ) {
   const webview_version_info_t * info = webview_version();
   hb_reta( 6 );
   hb_storvni( info->version.major,  -1, 1 );
   hb_storvni( info->version.minor,  -1, 2 );
   hb_storvni( info->version.patch,  -1, 3 );
   hb_storvc ( info->version_number, -1, 4 );
   hb_storvc ( info->pre_release,    -1, 5 );
   hb_storvc ( info->build_metadata, -1, 6 );
}


#pragma ENDDUMP

