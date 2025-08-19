
    #command @ <row>, <col> COMBOSEARCHBOX <name>                  ;
             [ <dummy1: OF, PARENT> <parent> ] ;
                            [ HEIGHT <height> ]             ;
                            [ WIDTH <width> ]               ;
                            [ VALUE <value> ]               ;
                            [ FONT <fontname> ]             ;
                            [ SIZE <fontsize> ]             ;
                            [ <bold : BOLD> ] ;
                            [ <italic : ITALIC> ] ;
                            [ <underline : UNDERLINE> ] ;
                            [ TOOLTIP <tooltip> ]           ;
                            [ BACKCOLOR <backcolor> ] ;
                            [ FONTCOLOR <fontcolor> ] ;
                            [ MAXLENGTH <maxlength> ]       ;
                            [ <upper: UPPERCASE> ]          ;
                            [ <lower: LOWERCASE> ]          ;
                            [ <numeric: NUMERIC> ]          ;
                            [ ON GOTFOCUS <gotfocus> ]      ;
                            [ ON LOSTFOCUS <lostfocus> ]    ;
                            [ ON ENTER <enter> ]      ;
                            [ <RightAlign: RIGHTALIGN> ]   ;
                            [ <notabstop: NOTABSTOP> ]   ;
                            [ HELPID <helpid> ]       ;
                            [ ITEMS <aitems>  ]     ;
                            [ <anywhere :ANYWHERESEARCH> ];
                            [ <dropheight :DROPPEDHEIGHT> ];
                            [ <additive :ADDITIVE> ];
                            [ ROWOFFSET <nrowoffset> ];
                            [ COLOFFSET <ncoloffset> ];
             =>;
             _DefineComboSearchBox( <"name">, <"parent">, <col>, <row>, <width>, <height>, <value>, ;
                <fontname>, <fontsize>, <tooltip>, <maxlength>, ;
                            <.upper.>, <.lower.>, <.numeric.>, ;
                <{lostfocus}>, <{gotfocus}>, <{enter}>, ;
                <.RightAlign.>, <helpid>, <.bold.>, <.italic.>, <.underline.>, <backcolor> , <fontcolor> , <.notabstop.>, <aitems>,<.anywhere.>,<dropheight>, <.additive.>, <nrowoffset>, <ncoloffset>)

   #xcommand ANYWHERESEARCH   <sort>   ;
   =>;
   oHmgApp():APP464      := <sort>
   #xcommand DROPHEIGHT   <dropheight>   ;
   =>;
   oHmgApp():APP249      := <dropheight>
   #xcommand ADDITIVE   <additive>   ;
   =>;
   oHmgApp():APP439      := <additive>
   #xcommand ROWOFFSET   <rowoffset>   ;
   =>;
   oHmgApp():APP449      := <rowoffset>
   #xcommand COLOFFSET   <coloffset>   ;
   =>;
   oHmgApp():APP450      := <coloffset>



    #xcommand DEFINE COMBOSEARCHBOX <name>;
       =>;
       oHmgApp():APP416   := <"name">   ;; //name
       oHmgApp():APP417   := Nil      ;; //parent
       oHmgApp():APP431   := Nil      ;; //row
       oHmgApp():APP432   := Nil      ;; //col
       oHmgApp():APP421   := Nil      ;; // height
       oHmgApp():APP420   := Nil      ;; // width
       oHmgApp():APP434   := Nil      ;; //value
       oHmgApp():APP422  := Nil      ;; //font
       oHmgApp():APP423   := Nil      ;; // size
       oHmgApp():APP412   := .f.      ;; //bold
       oHmgApp():APP413   := .f.      ;; // italic
       oHmgApp():APP415   := .f.      ;; // underline
       oHmgApp():APP424   := Nil      ;; //tooltip
       oHmgApp():APP457   := Nil      ;; // backcolor
       oHmgApp():APP458   := Nil      ;; // fontcolor
       oHmgApp():APP442 := Nil   ;; // maxlength
       oHmgApp():APP475 := .f.      ;; //upper
       oHmgApp():APP476   := .f.      ;;  //lower
       oHmgApp():APP477   := .f.      ;;  // numeric
       oHmgApp():APP426 := Nil      ;; // gotfocus
       oHmgApp():APP427   := Nil         ;; //lostfocus
       oHmgApp():APP437   := Nil         ;; //enter
       oHmgApp():APP440    := .f.          ;; //rightalign
       oHmgApp():APP428   := .t.      ;; //tabstop
       oHmgApp():APP429   := Nil      ;; // helpid
       oHmgApp():APP436      := Nil   ;;    // items
       oHmgApp():APP464      := .f.   ;;    // anywhere search
       oHmgApp():APP249      := 0    ;;// dropped height
       oHmgApp():APP439      := .f.  ;;  // additive
       oHmgApp():APP449      := 0    ;;// rowoffset
       oHmgApp():APP450      := 0    // coloffset

    #xcommand END COMBOSEARCHBOX;
       =>;
          _DefineComboSearchBox(;
             oHmgApp():APP416,; //name
             oHmgApp():APP417,; //parent
             oHmgApp():APP432,; //col
             oHmgApp():APP431,; //row
             oHmgApp():APP420,; //width
             oHmgApp():APP421,; //height
             oHmgApp():APP434,; //value
             oHmgApp():APP422,; //fontname
             oHmgApp():APP423,; //fontsize
             oHmgApp():APP424,; //tooltip
             oHmgApp():APP442,; //maxlength
             oHmgApp():APP475,; //upper
             oHmgApp():APP476,; //lower
             oHmgApp():APP477,; //numeric
             oHmgApp():APP427,; //lostfocus
             oHmgApp():APP426,; //gotfocus
             oHmgApp():APP437,; //enter
             oHmgApp():APP440,; //rightalign
             oHmgApp():APP429,; //helpid
             oHmgApp():APP412,; //bold
             oHmgApp():APP413 , ; //italic
             oHmgApp():APP415,; //underline
             oHmgApp():APP457 , ; //backcolor
             oHmgApp():APP458 , ;// fontcolor
             oHmgApp():APP428 ,; //tabstop
             oHmgApp():APP436 ,; // aitems
             oHmgApp():APP464 ,; //  anywhere search
             oHmgApp():APP249 ,; //  droppedheight
             oHmgApp():APP439 ,; //  additive
             oHmgApp():APP449 ,; //  rowoffset
             oHmgApp():APP450 ; //  coloffset
             )



