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


/* Second parameter for HB_WEBVIEW_GET_NATIVE_HANDLE() function */

/// Native handle kind. The actual type depends on the backend.

  /// Top-level window. @c GtkWindow pointer (GTK), @c NSWindow pointer (Cocoa)
  /// or @c HWND (Win32).
#define  WEBVIEW_NATIVE_HANDLE_KIND_UI_WINDOW            0
  /// Browser widget. @c GtkWidget pointer (GTK), @c NSView pointer (Cocoa) or
  /// @c HWND (Win32).
#define  WEBVIEW_NATIVE_HANDLE_KIND_UI_WIDGET            1
  /// Browser controller. @c WebKitWebView pointer (WebKitGTK), @c WKWebView
  /// pointer (Cocoa/WebKit) or @c ICoreWebView2Controller pointer
  /// (Win32/WebView2).
#define  WEBVIEW_NATIVE_HANDLE_KIND_BROWSER_CONTROLLER   2



/* Third parameter for HB_WEBVIEW_SET_SIZE() function */

/// Window size hints

  /// Width and height are default size.
#define  WEBVIEW_HINT_NONE       0
  /// Width and height are minimum bounds.
#define  WEBVIEW_HINT_MIN        1
  /// Width and height are maximum bounds.
#define  WEBVIEW_HINT_MAX        2
  /// Window size can not be changed by a user.
#define  WEBVIEW_HINT_FIXED      3



/* Third parameter for hb_webview_bind2() function */

/// Type of way in which Harbour functions are called

#define HB_CALL_FUNC_INDIRECT    0     // e.g. callHB( "hb_memoread", "text.txt" )     --> &'hb_memoread("text.txt")'
#define HB_CALL_FUNC_DIRECT      1     // e.g. hb_memoread( "text.txt" )               --> &'hb_memoread("text.txt")'
#define HB_CALL_FUNC_MACRO       2     // e.g. callMACRO( 'hb_memoread("text.txt")' )  --> &'hb_memoread("text.txt")'

