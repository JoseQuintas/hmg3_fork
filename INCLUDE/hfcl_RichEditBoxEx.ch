
************************************
*   Extended rich edit file type   *
************************************

#define RICHEDITFILEEX_ANSI      1   // ANSI text file
#define RICHEDITFILEEX_UTF8      2   // UTF-8 text file
#define RICHEDITFILEEX_UTF16LE   3   // UTF-16 LE (little endian) text file
#define RICHEDITFILEEX_RTF       4   // RTF file
#define RICHEDITFILEEX_UTF16BE   5   // UTF-16 BE (big endian) text file

***************************************
*   Extended properties and methods   *
***************************************

#xtranslate Ex. <w>. <c> . <p:HasNonAsciiChars,HasNonAnsiChars> => GetPropertyEx ( <"w">, <"c"> , <"p"> )
#xtranslate Ex. <w>. <c> . <p:LoadFile,SaveFile> (<arg1>,<arg2>,<arg3>) => DoMethodEx ( <"w">, <"c"> , <"p"> , <arg1> , <arg2>, <arg3> )
#xtranslate Ex. <w>. <c> . <p:LoadFile,SaveFile> (<arg1>,<arg2>) => DoMethodEx ( <"w">, <"c"> , <"p"> , <arg1> , <arg2> )
#xtranslate Ex. <w>. <c> . <p:LoadFile,SaveFile> (<arg1>) => DoMethodEx ( <"w">, <"c"> , <"p"> , <arg1> )
#xtranslate Ex. <w>. <p:GetScreenPos,GetWindowPos> (<arg1>,<arg2>) => GetPropertyEx ( <"w">, <"p"> , <arg1>, <arg2> )
#xtranslate Ex. <w>. <c> . <p:GetScreenPos,GetWindowPos> (<arg1>,<arg2>) => GetPropertyEx ( <"w">, <"c"> , <"p"> , <arg1>, <arg2> )
#xtranslate Ex. <w>. <p:DrawBorder> [()] => DoMethodEx ( <"w">, <"p"> )
#xtranslate Ex. <w>. <p:DrawBorder> (<arg1>) => DoMethodEx ( <"w">, <"p">, <arg1> )
#xtranslate Ex. <w>. <p:DrawBorder> (,<arg2>) => DoMethodEx ( <"w">, <"p">,, <arg2> )
#xtranslate Ex. <w>. <p:DrawBorder> (<arg1>,<arg2>) => DoMethodEx ( <"w">, <"p">, <arg1>, <arg2> )

******************************
*   Extended print dialog    *
******************************

#xcommand SELECT PRINTER DIALOG EX ;
   [ PARENT <parent> ] ;
   [ <Preview  : PREVIEW> ] ;
   [ <NoSaveButton   : NOSAVEBUTTON> ] ;
   [ DIALOGFILENAME <DialogFileName> ] ;
   [ SAVEAS <FullFileName> ] ;
=> ;
oHmgApp():APP513 := .f. ;;
oHmgApp():APP373  = HMG_PrintDialogEx( <(parent)> )  ;;
oHmgApp():APP374 := oHmgApp():APP373 \[1\]    ;;
oHmgApp():APP375 := oHmgApp():APP373 \[2\]  ;;
oHmgApp():APP376 := oHmgApp():APP373 \[3\] ;;
oHmgApp():APP377 := oHmgApp():APP373 \[4\] ;;
oHmgApp():APP378 := <.Preview.>       ;;
oHmgApp():APP505 := <.NoSaveButton.> ;;
oHmgApp():APP506 := HMG_IsNotDefParam ( <DialogFileName> , NIL );;
oHmgApp():APP507 := HMG_IsNotDefParam ( <FullFileName>   , NIL );;
oHmgApp():APP508 := <.Preview.> ;;
oHmgApp():APP378 := if ( oHmgApp():APP507 <> NIL, .T., <.Preview.> ) ;;
_hmg_printer_InitUserMessages()         ;;
oHmgApp():APP379 := strzero( Seconds() * 100 , 8 )

#xcommand SELECT PRINTER DIALOG EX ;
   [ PARENT <parent> ] ;
   TO <lSuccess> ;
   [ <Preview  : PREVIEW> ] ;
   [ <NoSaveButton   : NOSAVEBUTTON> ] ;
   [ DIALOGFILENAME <DialogFileName> ] ;
   [ SAVEAS <FullFileName> ] ;
=> ;
oHmgApp():APP513 := .f. ;;
oHmgApp():APP373  = HMG_PrintDialogEx( <(parent)> )  ;;
oHmgApp():APP374 := oHmgApp():APP373 \[1\]    ;;
oHmgApp():APP375 := oHmgApp():APP373 \[2\]  ;;
oHmgApp():APP376 := oHmgApp():APP373 \[3\] ;;
oHmgApp():APP377 := oHmgApp():APP373 \[4\] ;;
<lSuccess> := if ( oHmgApp():APP374 <> 0 , .T. , .F. ) ;;
oHmgApp():APP378 := <.Preview.> ;;
oHmgApp():APP505 := <.NoSaveButton.> ;;
oHmgApp():APP506 := HMG_IsNotDefParam ( <DialogFileName> , NIL );;
oHmgApp():APP507 := HMG_IsNotDefParam ( <FullFileName>   , NIL );;
oHmgApp():APP508 := <.Preview.> ;;
oHmgApp():APP378 := if ( oHmgApp():APP507 <> NIL, .T., <.Preview.> ) ;;
_hmg_printer_InitUserMessages() ;;
oHmgApp():APP379 := strzero( Seconds() * 100 , 8 )


