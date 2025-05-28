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
LOCAL w, allowDevTools
LOCAL context

allowDevTools = .T.

   w = hb_webview_create( allowDevTools, NIL )

      hb_webview_set_size(w, 800, 480, WEBVIEW_HINT_NONE)

      hb_webview_set_title(w, "Harbour WebView - SQLite Query Demo")

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
      context = hb_webview_bind2(w, "HB_SQLiteQueryDemo", HB_CALL_FUNC_DIRECT)

      hb_webview_navigate(w, "file:///" + hb_DirBase() + "sqlite_demo.html")   // load local html file

   hb_webview_run(w)

   hb_webview_destroy_context( context )

   hb_webview_terminate( w )

RETURN NIL



FUNCTION HB_SQLiteQueryDemo()
   LOCAL cDbName := "contacts.db3"
   LOCAL DbExist := File( cDbName )
   LOCAL oDb, aContacts, i, k, old
   LOCAL cSqlText, pStmt
   LOCAL cType, cValue, xValue

   // Connect to SQLite and create the table if it does not exist
   oDb := SQLite3_Open( cDbName, .T. )

   IF Empty( oDb )
      hb_Alert( "Error opening the database: " + cDbName )
      RETURN {}
   ENDIF

   IF .NOT. DbExist
      SQLite3_Exec(oDb, "CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, salary FLOAT, birth DATE)")
      displayIfError( oDb )

      // Insert sample data
      SQLite3_Exec(oDb, "INSERT INTO contacts (name, salary, birth) VALUES ('John Doe',   1300.5, '1993-03-12')")
      displayIfError( oDb )

      SQLite3_Exec(oDb, "INSERT INTO contacts (name, salary, birth) VALUES ('Jane Smith', 1500.6, '1995-10-24')")
      displayIfError( oDb )
      
      SQLite3_Exec(oDb, "INSERT INTO contacts (name, salary, birth) VALUES ('Ken Reyes',  1480.0, '1990-04-01')")
      displayIfError( oDb )

      SQLite3_Exec(oDb, "INSERT INTO contacts (name, salary, birth) VALUES ('Pink Love',  2500.0, '1998-06-12')")
      displayIfError( oDb )

      SQLite3_Exec(oDb, "INSERT INTO contacts (name, salary, birth) VALUES ('Sam Green',  1250.0, '2000-01-31')")
      displayIfError( oDb )
   ENDIF

   // Retrieve contacts
   cSqlText = "SELECT * FROM contacts"
   aContacts := SQLite3_Get_Table( oDb, cSqlText )
   displayIfError( oDb )

   // Retrieves information from query fields and converts the response string into values
   pStmt := SQLite3_Prepare( oDb, cSqlText )
   displayIfError( oDb )
   IF ! Empty( pStmt )
      FOR k := 1 TO SQLite3_Column_Count( pStmt )
         cType = SQLite3_Column_DeclType( pStmt, k )
         FOR i := 2 TO LEN( aContacts ) // Skips the first row because it only contains the field names, no contains data values
            cValue = aContacts[ i ][ k ]
            IF cType == "INTEGER" .OR. cType == "REAL" .OR. cType == "FLOAT"
               xValue = Val( cValue )
            ELSEIF cType == "DATE"
               #if 0
                  old = Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
                  xValue = ctod( cValue )
                  Set( _SET_DATEFORMAT, old )
               #else
                  HB_SYMBOL_UNUSED( old )
                  xValue = cValue
               #endif
            ELSE
               xValue = cValue
            ENDIF
            aContacts[ i ][ k ] = xValue
         NEXT
      NEXT
   ENDIF

RETURN aContacts


FUNCTION displayIfError( oDb )
   IF SQLite3_ErrCode( oDb ) > 0
      hb_Alert( SQLite3_ErrMsg( oDb ) )
      RETURN .T.
   ENDIF
RETURN .F.

