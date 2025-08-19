/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

   "Harbour GUI framework for Win32"
   Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
   Copyright 2001 Antonio Linares <alinares@fivetech.com>
   www - http://www.harbour-project.org

   "Harbour Project"
   Copyright 1999-2003, http://www.harbour-project.org/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
   Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

#xcommand EDITOPTION          <editoption>         => oHmgApp():APP248  := <editoption>

#xcommand ONKEY               <onkey>              => oHmgApp():APP247  := <{onkey}>

#xcommand ON KEY              <onkey>              => oHmgApp():APP247  := <{onkey}>

#xcommand ONSELECT            <onselect>           => oHmgApp():APP386  := <{onselect}>

#xcommand ONLINK              <onlink>             => oHmgApp():APP387  := <{onlink}>

#xcommand ONVSCROLL           <onvscroll>          => oHmgApp():APP388  := <{onvscroll}>

#xcommand LOCKCOLUMNS         <value>              => oHmgApp():APP281  := <value>

#xcommand DISABLEDBACKCOLOR   <value>              => oHmgApp():APP298  := <value>

#xcommand DISABLEDFORECOLOR   <value>              => oHmgApp():APP299  := <value>

#xcommand DISABLEDFONTCOLOR   <value>              => oHmgApp():APP299  := <value>

#xcommand CELLNAVIGATION      <cellnavigation>     => oHmgApp():APP329  := <cellnavigation>

#xcommand DYNAMICDISPLAY      <value>              => oHmgApp():APP244  := <value>

#xcommand DRAGITEMS           <dragitems>          => oHmgApp():APP352  := <dragitems>

#xcommand MULTILINE           <multiline>          => oHmgApp():APP353  := <multiline>

#xcommand HEADERIMAGES        <headerimages>       => oHmgApp():APP246  := <headerimages>

#xcommand ONCANCEL            <oncancel>           => oHmgApp():APP299  := <{oncancel}>

#xcommand ONCLOSEUP           <oncloseup>          => oHmgApp():APP247  := <{oncloseup}>

#xcommand ON CLOSEUP          <oncloseup>          => oHmgApp():APP247  := <{oncloseup}>

#xcommand ONDROPDOWN          <ondropdown>         => oHmgApp():APP248  := <{ondropdown}>

#xcommand ON DROPDOWN         <ondropdown>         => oHmgApp():APP248  := <{ondropdown}>

#xcommand DROPPEDWIDTH        <droppedwidth>       => oHmgApp():APP249  := <droppedwidth>

#xcommand ITEMSOURCE          <itemsource, ...>    => oHmgApp():APP402  := \{<"itemsource">\}

#xcommand VALUESOURCE         <valuesource>        => oHmgApp():APP403  := <"valuesource">

#xcommand COLUMNCONTROLS      <editcontrols>       => oHmgApp():APP388  := <editcontrols>

#xcommand COLUMNVALID         <columnvalid>        => oHmgApp():APP387  := <columnvalid>

#xcommand COLUMNWHEN          <columnwhen>         => oHmgApp():APP386  := <columnwhen>

#xcommand WORKAREA            <workarea>           => oHmgApp():APP480  := <"workarea">

#xcommand FIELD               <field>              => oHmgApp():APP385  := <"field">

#xcommand FIELDS              <fields>             => oHmgApp():APP481  := <fields>

#xcommand ALLOWDELETE         <deletable>          => oHmgApp():APP482  := <deletable>

#xcommand NOVSCROLLBAR        <nvs>                => oHmgApp():APP398  := <nvs>

#xcommand VSCROLLBAR          <vs>                 => oHmgApp():APP398  := .NOT. <vs>

#xcommand NOHSCROLLBAR        <nvs>                => oHmgApp():APP394  := <nvs>

#xcommand HSCROLLBAR          <vs>                 => oHmgApp():APP394  := .NOT. <vs>

#xcommand INPLACEEDIT         <inplaceedit>        => oHmgApp():APP401  := <inplaceedit>

#xcommand DISPLAYITEMS        <displayitems>       => oHmgApp():APP354  := <displayitems>

#xcommand INPUTITEMS          <inputitems>         => oHmgApp():APP355  := <inputitems>

#xcommand DATE                <datetype>           => oHmgApp():APP400  := <datetype>

#xcommand DATATYPE DATE                            => oHmgApp():APP400  := .T.

#xcommand DATATYPE NUMERIC                         => oHmgApp():APP477  := .T.

#xcommand DATATYPE CHARACTER                       => oHmgApp():APP477  := .F.; oHmgApp():APP400 := .F.

#xcommand VALID               <valid>              => oHmgApp():APP483  := <valid>

#xcommand VALIDMESSAGES       <validmessages>      => oHmgApp():APP484  := <validmessages>

#xcommand READONLY            <readonly>           => oHmgApp():APP441  := <readonly>

#xcommand VIRTUAL             <virtual>            => oHmgApp():APP410  := <virtual>

#xcommand LOCK                <lock>               => oHmgApp():APP485  := <lock>

#xcommand ALLOWAPPEND         <appendable>         => oHmgApp():APP486  := <appendable>

#xcommand FONTITALIC          <i>                  => oHmgApp():APP413  := <i>

#xcommand FONTSTRIKEOUT       <s>                  => oHmgApp():APP414  := <s>

#xcommand FONTUNDERLINE       <u>                  => oHmgApp():APP415  := <u>

#xcommand AUTOSIZE            <a>                  => oHmgApp():APP409  := <a>

#xcommand ENDELLIPSES         <lvalue>             => oHmgApp():APP281  := <lvalue>

#xcommand NOPREFIX            <lvalue>             => oHmgApp():APP387  := <lvalue>

#xcommand ADJUSTIMAGE         <a>                  => oHmgApp():APP409  := <a>

#xcommand SHOWHEADERS         <columnheaders>      => oHmgApp():APP382  := <columnheaders>

#xcommand HEADERS             <headers>            => oHmgApp():APP445  := <headers>

#xcommand HEADER              <headers>            => oHmgApp():APP445  := <headers>

#xcommand WIDTHS              <widths>             => oHmgApp():APP446  := <widths>

#xcommand ONDBLCLICK          <dblclick>           => oHmgApp():APP447  := <{dblclick}>

#xcommand ON DBLCLICK         <dblclick>           => oHmgApp():APP447  := <{dblclick}>

#xcommand ADDRESS             <address>            => oHmgApp():APP406  := <address>

#xcommand ONHEADCLICK         <aHeadClick>         => oHmgApp():APP448  := <aHeadClick>

#xcommand DYNAMICBACKCOLOR    <aDynamicBackColor>  => oHmgApp():APP391  := <aDynamicBackColor>

#xcommand DYNAMICFORECOLOR    <aDynamicForeColor>  => oHmgApp():APP390  := <aDynamicForeColor>

#xcommand ON HEADCLICK        <aHeadClick>         => oHmgApp():APP448  := <aHeadClick>

#xcommand WHEN                <aWhenFields>        => oHmgApp():APP389  := <aWhenFields>

#xcommand NOLINES             <nolines>            => oHmgApp():APP449  := <nolines>

#xcommand LINES               <lines>              => oHmgApp():APP449  := .NOT. <lines>

#xcommand IMAGE               <aImage>             => oHmgApp():APP450  := <aImage>

#xcommand JUSTIFY             <aJustify>           => oHmgApp():APP451  := <aJustify>

#xcommand MULTISELECT         <multiselect>        => oHmgApp():APP455  := <multiselect>

#xcommand ALLOWEDIT           <edit>               => oHmgApp():APP456  := <edit>

#xcommand PROGID              <progid>             => oHmgApp():APP356  := <progid>

#xcommand SORT                <sort>               => oHmgApp():APP464  := <sort>

#xcommand OPAQUE              <opaque>             => oHmgApp():APP444  := <opaque>

#xcommand TRANSPARENTCOLOR    <transparentcolor>   => oHmgApp():APP444  := <transparentcolor>

#xcommand AUTOPLAY            <autoplay>           => oHmgApp():APP488  := <autoplay>

#xcommand CENTER              <center>             => oHmgApp():APP489  := <center>

#xcommand FILE                <file>               => oHmgApp():APP487  := <file>

#xcommand NOAUTOSIZEWINDOW    <noautosizewindow>   => oHmgApp():APP490  := <noautosizewindow>

#xcommand AUTOSIZEWINDOW      <autosizewindow>     => oHmgApp():APP490  := .NOT. <autosizewindow>

#xcommand NOAUTOSIZEMOVIE     <noautosizemovie>    => oHmgApp():APP384  := <noautosizemovie>

#xcommand AUTOSIZEMOVIE       <autosizemovie>      => oHmgApp():APP384  := .NOT. <autosizemovie>

#xcommand NOERRORDLG          <noerrordlg>         => oHmgApp():APP492  := <noerrordlg>

#xcommand ERRORDLG            <errordlg>           => oHmgApp():APP492  := .NOT. <errordlg>

#xcommand NOMENU              <nomenu>             => oHmgApp():APP493  := <nomenu>

#xcommand MENU                <menu>               => oHmgApp():APP493  := .NOT. <menu>

#xcommand NOOPEN              <noopen>             => oHmgApp():APP494  := <noopen>

#xcommand OPEN                <open>               => oHmgApp():APP494  := .NOT. <open>

#xcommand NOPLAYBAR           <noplaybar>          => oHmgApp():APP495  := <noplaybar>

#xcommand PLAYBAR             <playbar>            => oHmgApp():APP495  := .NOT. <playbar>

#xcommand SHOWALL             <showall>            => oHmgApp():APP496  := <showall>

#xcommand SHOWMODE            <showmode>           => oHmgApp():APP497  := <showmode>

#xcommand SHOWNAME            <showname>           => oHmgApp():APP498  := <showname>

#xcommand SHOWPOSITION        <showposition>       => oHmgApp():APP499  := <showposition>

#xcommand RANGEMIN            <lo>                 => oHmgApp():APP465  := <lo>

#xcommand RANGEMAX            <hi>                 => oHmgApp():APP466  := <hi>

#xcommand VERTICAL            <vertical>           => oHmgApp():ActiveControlVertical  := <vertical>

#xcommand SMOOTH              <smooth>             => oHmgApp():APP468  := <smooth>

#xcommand OPTIONS             <aOptions>           => oHmgApp():APP469  := <aOptions>

#xcommand SPACING             <spacing>            => oHmgApp():APP470]  := <spacing>

#xcommand NOTICKS             <noticks>            => oHmgApp():ActiveControlNoTicks := <noticks>

#xcommand TICKMARKS           <tickmarks>          => oHmgApp():ActiveControlNoTicks  := .NOT. <tickmarks>

#xcommand BOTH                <both>               => oHmgApp():APP472  := <both>

#xcommand TOP                 <top>                => oHmgApp():APP473  := <top>

#xcommand LEFT                <left>               => oHmgApp():APP474  := <left>

#xcommand UPPERCASE           <uppercase>          => oHmgApp():APP475  := <uppercase>

#xcommand LOWERCASE           <lowercase>          => oHmgApp():APP476  := <lowercase>

#xcommand CASECONVERT UPPER                        => oHmgApp():APP475  := .T.

#xcommand CASECONVERT LOWER                        => oHmgApp():APP476  := .T.

#xcommand CASECONVERT NONE                         => oHmgApp():APP476  := .F.; oHmgApp():APP475 := .F.

#xcommand NUMERIC             <numeric>            => oHmgApp():APP477  := <numeric>

#xcommand PASSWORD            <password>           => oHmgApp():APP478  := <password>

#xcommand INPUTMASK           <inputmask>          => oHmgApp():APP479  := <inputmask>

#xcommand FORMAT              <format>             => oHmgApp():APP500  := <format>

#xcommand NOTODAY             <notoday>            => oHmgApp():APP452  := <notoday>

#xcommand TODAY               <today>              => oHmgApp():APP452  := .NOT. <today>

#xcommand NOTODAYCIRCLE       <notodaycircle>      => oHmgApp():APP453  := <notodaycircle>

#xcommand TODAYCIRCLE         <todaycircle>        => oHmgApp():APP453  := .NOT. <todaycircle>

#xcommand WEEKNUMBERS         <weeknumbers>        => oHmgApp():APP454  := <weeknumbers>

#xcommand ROW                 <row>                => oHmgApp():APP431  := <row>

#xcommand COL                 <col>                => oHmgApp():APP432  := <col>

#xcommand PARENT              <of>                 => oHmgApp():APP417  := <"of">

#xcommand CAPTION             <caption>            => oHmgApp():APP418  := <caption>

#xcommand ACTION              <action>             => oHmgApp():APP419  := <{action}>

#xcommand ONCLICK             <action>             => oHmgApp():APP419  := <{action}>

#xcommand ON CLICK            <action>             => oHmgApp():APP419  := <{action}>

#xcommand DYNAMICFONT         <font>               => oHmgApp():APP453  := <font>

#xcommand ONCHECKBOXCLICKED   <action>             => oHmgApp():APP454  := <{action}>

#xcommand ON CHECKBOXCLICKED  <action>             => oHmgApp():APP454  := <{action}>

#xcommand ON INPLACEEDITEVENT <action>             => oHmgApp():APP352  := <{action}>

#xcommand ONINPLACEEDITEVENT  <action>             => oHmgApp():APP352  := <{action}>

#xcommand WIDTH               <width>              => oHmgApp():APP420  := <width>

#xcommand HEIGHT              <height>             => oHmgApp():APP421  := <height>

#xcommand FONTNAME            <font>               => oHmgApp():APP422  := <font>

#xcommand FONTSIZE            <size>               => oHmgApp():APP423  := <size>

#xcommand ITEMCOUNT           <itemcount>          => oHmgApp():APP407  := <itemcount>

#xcommand TOOLTIP             <tooltip>            => oHmgApp():APP424  := <tooltip>

#xcommand FLAT                <flat>               => oHmgApp():APP425  := <flat>

#xcommand ONGOTFOCUS          <ongotfocus>         => oHmgApp():APP426  := <{ongotfocus}>

#xcommand ON GOTFOCUS         <ongotfocus>         => oHmgApp():APP426  := <{ongotfocus}>

#xcommand ONLOSTFOCUS         <onlostfocus>        => oHmgApp():APP427  := <{onlostfocus}>

#xcommand ON LOSTFOCUS        <onlostfocus>        => oHmgApp():APP427  := <{onlostfocus}>

#xcommand TABSTOP             <notabstop>          => oHmgApp():APP428  := .NOT. <notabstop>

#xcommand HELPID              <helpid>             => oHmgApp():APP429  := <helpid>

#xcommand VISIBLE             <visible>            =>oHmgApp():APP430 := .NOT. <visible>

#xcommand PICTURE             <picture>            => oHmgApp():APP433  := <picture>

#xcommand TRANSPARENT         <transparent>        => oHmgApp():APP463  := <transparent>

#xcommand TRANSPARENTHEADER   <transparentheader>  => oHmgApp():APP452  := <transparentheader>

#xcommand PICTALIGNMENT       <alignment:LEFT,RIGHT,TOP,BOTTOM> => oHmgApp():APP381 := <"alignment">

#xcommand STRETCH             <stretch>            => oHmgApp():APP411  := <stretch>

#xcommand VALUE               <value>              => oHmgApp():APP434  := <value>

#xcommand ONCHANGE            <onchange>           => oHmgApp():APP435  := <{onchange}>

#xcommand ONSAVE              <onsave>             => oHmgApp():APP277  := IF ( valtype( <onsave> ) == 'U' , NIL , <{onsave}> )

#xcommand ON CHANGE           <onchange>           => oHmgApp():APP435  := <{onchange}>

#xcommand ON QUERYDATA        <onquerydata>        => oHmgApp():APP408  := <{onquerydata}>

#xcommand ONQUERYDATA         <onquerydata>        => oHmgApp():APP408  := <{onquerydata}>

#xcommand DISPLAYEDIT         <displayedit>        => oHmgApp():APP396  := <displayedit>

#xcommand GRIPPERTEXT         <grippertext>        => oHmgApp():APP395  := <grippertext>

#xcommand ON DISPLAYCHANGE    <displaychange>      => oHmgApp():APP397  := <{displaychange}>

#xcommand ONDISPLAYCHANGE     <displaychange>      => oHmgApp():APP397  := <{displaychange}>

#xcommand ITEM                <aRows>              => oHmgApp():APP436  := <aRows>

#xcommand ITEMS               <aRows>              => oHmgApp():APP436  := <aRows>

#xcommand ONENTER             <enter>              => oHmgApp():APP437  := <{enter}>

#xcommand ON ENTER            <enter>              => oHmgApp():APP437  := <{enter}>

#xcommand SHOWNONE            <shownone>           => oHmgApp():APP438  := <shownone>

#xcommand UPDOWN              <updown>             => oHmgApp():APP439  := <updown>

#xcommand READONLYFIELDS      <readonly>           => oHmgApp():APP441  := <readonly>

#xcommand MAXLENGTH           <maxlength>          => oHmgApp():APP442  := <maxlength>

#xcommand BREAK               <break>              => IF ( oHmgApp():APP383 , oHmgApp():APP443 := <break> , EVAL({|b| BREAK(b)}, <break>) )

#xcommand BACKCOLOR           <color>              => oHmgApp():APP457  := <color>

#xcommand BACKGROUNDCOLOR     <color>              => oHmgApp():APP457  := <color>     /* ADD */

#xcommand CENTERALIGN         <centeralign>        => oHmgApp():APP393  := <centeralign>

#xcommand RIGHTALIGN          <rightalign>         => oHmgApp():APP440  := <rightalign>

#xcommand ALIGNMENT RIGHT                          => oHmgApp():APP440  := .T. ; oHmgApp():APP393 := .F.

#xcommand ALIGNMENT CENTER                         => oHmgApp():APP440  := .F. ; oHmgApp():APP393 := .T.

#xcommand ALIGNMENT LEFT                           => oHmgApp():APP440  := .F. ; oHmgApp():APP393 := .F.

#xcommand FONTCOLOR           <color>              => oHmgApp():APP458  := <color>

#xcommand FORECOLOR           <color>              => oHmgApp():APP399  := <color>

#xcommand FONTBOLD            <bold>               => oHmgApp():APP412  := <bold>

#xcommand BORDER              <border>             => oHmgApp():APP459  := <border>

#xcommand CLIENTEDGE          <clientedge>         => oHmgApp():IsBCC77  := <clientedge>

#xcommand HSCROLL             <hscroll>            => oHmgApp():APP461  := <hscroll>

#xcommand VSCROLL             <vscroll>            => oHmgApp():APP462  := <vscroll>

#xcommand TRANSPARENT         <transparent>        => oHmgApp():APP463  := <transparent>

#xcommand ROWSOURCE           <value>              => oHmgApp():APP327  := <value>

#xcommand COLUMNFIELDS        <value>              => oHmgApp():APP326  := <value>

#xcommand BUFFERED            <value>              => oHmgApp():APP325  := <value>

#xcommand HANDCURSOR          <handcursor>         => oHmgApp():APP392  := <handcursor>

#xcommand WRAP                <wrap>               => oHmgApp():APP404  := <wrap>

#xcommand INCREMENT           <increment>          => oHmgApp():APP405  := <increment>

#xcommand HORIZONTAL          <horizontal>         => oHmgApp():APP357  := <horizontal>



/*----------------------------------------------------------------------------
Frame
---------------------------------------------------------------------------*/


#xcommand DEFINE FRAME <name> ;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP418      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP463   := .F.      ;;
   oHmgApp():APP444      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.


#xcommand END FRAME ;
   =>;
   _BeginFrame (;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP431,;
      oHmgApp():APP432,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP418,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP444,;
      oHmgApp():APP412,;
      oHmgApp():APP413,;
      oHmgApp():APP415,;
      oHmgApp():APP414,;
      oHmgApp():APP457,;
      oHmgApp():APP458,;
      oHmgApp():APP463 )


*-----------------------------------------------------------------------------*
* ACTIVEX
*-----------------------------------------------------------------------------*
#xcommand DEFINE ACTIVEX <name>;
   =>;
   oHmgApp():APP432      := 0      ;;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := ""      ;;
   oHmgApp():APP431      := 0      ;;
   oHmgApp():APP420      := 0      ;;
   oHmgApp():APP421      := 0      ;;
   oHmgApp():APP356      := 0

#xcommand END ACTIVEX;
   =>;
   _DefineActivex(;
      oHmgApp():APP416 , ;
      oHmgApp():APP417 , ;
      oHmgApp():APP431 , ;
      oHmgApp():APP432 , ;
      oHmgApp():APP420 , ;
      oHmgApp():APP421 , ;
      oHmgApp():APP356)

/*----------------------------------------------------------------------------
List Box
---------------------------------------------------------------------------*/
#xcommand DEFINE LISTBOX <name>;
   =>;
   oHmgApp():APP383      := .T.      ;;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP436      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP447   := NIL      ;;
   oHmgApp():APP455   := .F.      ;;
   oHmgApp():APP429      := NIL      ;;
   oHmgApp():APP443      := .F.      ;;
   430      := .F.      ;;
   oHmgApp():APP428      := .F.      ;;
   oHmgApp():APP464      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP352   := .F.      ;;
   oHmgApp():APP415   := .F.


#xcommand END LISTBOX;
   =>;
   oHmgApp():APP383 := .F.;;
   _DefineListBox(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP436,;
      oHmgApp():APP434,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP424,;
      oHmgApp():APP435,;
      oHmgApp():APP447,;
      oHmgApp():APP426,;
      oHmgApp():APP427,;
      oHmgApp():APP443,;
      oHmgApp():APP429,;
      430,;
      oHmgApp():APP428,;
      oHmgApp():APP464,;
      oHmgApp():APP412,;
      oHmgApp():APP413,;
      oHmgApp():APP415,;
      oHmgApp():APP414,;
      oHmgApp():APP457,;
      oHmgApp():APP458,;
      oHmgApp():APP455,;
      oHmgApp():APP352 )

///////////////////////////////////////////////////////////////////////////////
// ANIMATEBOX COMMANDS
///////////////////////////////////////////////////////////////////////////////

#xcommand DEFINE ANIMATEBOX <name>;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP488      := .F.      ;;
   oHmgApp():APP489      := .F.      ;;
   oHmgApp():APP463   := .F.      ;;
   oHmgApp():APP487      := NIL      ;;
   oHmgApp():APP429      := NIL


#xcommand END ANIMATEBOX;
   =>;
   _DefineAnimateBox(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP488,;
      oHmgApp():APP489,;
      oHmgApp():APP463,;
      oHmgApp():APP487,;
      oHmgApp():APP429)

#xcommand DEFINE PLAYER <name> ;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP487      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP490   := .F.      ;;
   oHmgApp():APP384   := .F.      ;;
   oHmgApp():APP492   := .F.      ;;
   oHmgApp():APP493      := .F.      ;;
   oHmgApp():APP494      := .F.      ;;
   oHmgApp():APP495      := .F.      ;;
   oHmgApp():APP496      := .F.      ;;
   oHmgApp():APP497      := .F.      ;;
   oHmgApp():APP498      := .F.      ;;
   oHmgApp():APP499   := .F.      ;;
   oHmgApp():APP429      := NIL


#xcommand END PLAYER;
   =>;
   _DefinePlayer(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP487,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP490,;
      oHmgApp():APP384,;
      oHmgApp():APP492,;
      oHmgApp():APP493,;
      oHmgApp():APP494,;
      oHmgApp():APP495,;
      oHmgApp():APP496,;
      oHmgApp():APP497,;
      oHmgApp():APP498,;
      oHmgApp():APP499,;
      oHmgApp():APP429)

/*----------------------------------------------------------------------------
Progress Bar
---------------------------------------------------------------------------*/


#xcommand DEFINE PROGRESSBAR <name>;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP465      := NIL      ;;
   oHmgApp():APP466      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():ActiveControlVertical := .F.      ;;
   oHmgApp():APP468      := .F.      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP399      := NIL      ;;
   oHmgApp():APP434      := NIL


#xcommand END PROGRESSBAR;
   =>;
   _DefineProgressBar(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP465,;
      oHmgApp():APP466,;
      oHmgApp():APP424,;
      oHmgApp():ActiveControlVertical,;
      oHmgApp():APP468,;
      oHmgApp():APP429,;
      430,;
      oHmgApp():APP434 , oHmgApp():APP457 , oHmgApp():APP399 )


/*----------------------------------------------------------------------------
Radio Group
---------------------------------------------------------------------------*/

#xcommand DEFINE RADIOGROUP <name>;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP469      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP470      := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.       ;;
   oHmgApp():APP428      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP463   := .F.      ;;
   oHmgApp():APP357   := .F.      ;;
   oHmgApp():APP415   := .F.


#xcommand END RADIOGROUP;
   =>;
   _DefineradioGroup(;
      oHmgApp():APP416 , ;
      oHmgApp():APP417 , ;
      oHmgApp():APP432 , ;
      oHmgApp():APP431 , ;
      oHmgApp():APP469 , ;
      oHmgApp():APP434 , ;
      oHmgApp():APP422 , ;
      oHmgApp():APP423 , ;
      oHmgApp():APP424 , ;
      oHmgApp():APP435 , ;
      oHmgApp():APP420 , ;
      oHmgApp():APP470 , ;
      oHmgApp():APP429 , ;
      430 , ;
      oHmgApp():APP428 , ;
      oHmgApp():APP412 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , ;
      oHmgApp():APP457 , ;
      oHmgApp():APP458 , ;
      oHmgApp():APP463 , ;
      oHmgApp():APP441 , oHmgApp():APP357 )


/*----------------------------------------------------------------------------
Slider
---------------------------------------------------------------------------*/

#xcommand DEFINE SLIDER <name>;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP465      := NIL      ;;
   oHmgApp():APP466      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():ActiveControlVertical      := .F.      ;;
   oHmgApp():ActiveControlNoTicks := .F.      ;;
   oHmgApp():APP472      := .F.      ;;
   oHmgApp():APP473      := .F.      ;;
   oHmgApp():APP474      := .F.      ;;
   oHmgApp():APP457      := NIL      ;;
   430      := .F.       ;;
   oHmgApp():APP428      := .F.      ;;
   oHmgApp():APP429      := NIL


#xcommand END SLIDER;
   =>;
   _DefineSlider(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP465,;
      oHmgApp():APP466,;
      oHmgApp():APP434,;
      oHmgApp():APP424,;
      oHmgApp():APP435,;
      oHmgApp():ActiveControlVertical,;
      oHmgApp():ActiveControlNoTicks,;
      oHmgApp():APP472],;
      oHmgApp():APP473,;
      oHmgApp():APP474,;
      oHmgApp():APP429,;
      430 ,;
      oHmgApp():APP428 , ;
      oHmgApp():APP457 )

/*----------------------------------------------------------------------------
Text Box
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTBOX <name>;
   =>;
   oHmgApp():APP416   := <"name">   ;;
   oHmgApp():APP417   := NIL      ;;
   oHmgApp():APP432   := NIL      ;;
   oHmgApp():APP298      := NIL      ;;
   oHmgApp():APP299      := NIL      ;;
   oHmgApp():APP431   := NIL      ;;
   oHmgApp():APP420   := NIL      ;;
   oHmgApp():APP421   := NIL      ;;
   oHmgApp():APP434   := NIL      ;;
   oHmgApp():APP422   := NIL      ;;
        oHmgApp():APP385     := NIL          ;;
   oHmgApp():APP423   := NIL      ;;
   oHmgApp():APP424   := NIL      ;;
   oHmgApp():APP442   := NIL      ;;
   oHmgApp():APP475   := .F.      ;;
   oHmgApp():APP476   := .F.      ;;
   oHmgApp():APP477   := .F.      ;;
   oHmgApp():APP478   := .F.      ;;
   oHmgApp():APP427 := NIL   ;;
   oHmgApp():APP426 := NIL      ;;
   oHmgApp():APP435   := NIL      ;;
   oHmgApp():APP437   := NIL      ;;
   oHmgApp():APP440 := .F.      ;;
        oHmgApp():APP441   := .F.         ;;
        oHmgApp():APP400   := .F.         ;;
        oHmgApp():APP429    := NIL          ;;
   oHmgApp():APP479   := NIL      ;;
   oHmgApp():ActiveControlFormat := NIL      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP428      := .F.      ;;
   430      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.


#xcommand END TEXTBOX;
   =>;
   iif( oHmgApp():APP479 == NIL .and. oHmgApp():APP400 == .F. ,;
      _DefineTextBox(;
         oHmgApp():APP416,;
         oHmgApp():APP417,;
         oHmgApp():APP432,;
         oHmgApp():APP431,;
         oHmgApp():APP420,;
         oHmgApp():APP421,;
         oHmgApp():APP434,;
         oHmgApp():APP422,;
         oHmgApp():APP423,;
         oHmgApp():APP424,;
         oHmgApp():APP442,;
         oHmgApp():APP475,;
         oHmgApp():APP476,;
         oHmgApp():APP477,;
         oHmgApp():APP478,;
         oHmgApp():APP427,;
         oHmgApp():APP426,;
         oHmgApp():APP435,;
         oHmgApp():APP437,;
         oHmgApp():APP440,;
                        oHmgApp():APP429 , ;
                        oHmgApp():APP441,;
                        oHmgApp():APP412 , ;
                        oHmgApp():APP413 , ;
                        oHmgApp():APP415 , ;
                        oHmgApp():APP414 ,;
                        oHmgApp():APP385, oHmgApp():APP457, oHmgApp():APP458,oHmgApp():APP430,oHmgApp():APP428 , oHmgApp():APP298 , oHmgApp():APP299 );
   ,;
      IF ( oHmgApp():APP477 == .T. , _DefineMaskedTextBox(;
         oHmgApp():APP416,;
         oHmgApp():APP417,;
         oHmgApp():APP432,;
         oHmgApp():APP431,;
         oHmgApp():APP479,;
         oHmgApp():APP420,;
         oHmgApp():APP434,;
         oHmgApp():APP422,;
         oHmgApp():APP423,;
          oHmgApp():APP424,;
         oHmgApp():APP427,;
         oHmgApp():APP426,;
         oHmgApp():APP435,;
         oHmgApp():APP421,;
         oHmgApp():APP437,;
         oHmgApp():APP440,;
         oHmgApp():APP429,;
                        oHmgApp():ActiveControlFormat , ;
                        oHmgApp():APP412 , ;
                        oHmgApp():APP413 , ;
                        oHmgApp():APP415 , ;
                        oHmgApp():APP414,;
                        oHmgApp():APP385,oHmgApp():APP457,oHmgApp():APP458,oHmgApp():APP441,oHmgApp():APP430,oHmgApp():APP428 , oHmgApp():APP298 , oHmgApp():APP299 ) , _DefineCharMaskTextBox ( oHmgApp():APP416 , oHmgApp():APP417, oHmgApp():APP432, oHmgApp():APP431, oHmgApp():APP479 , oHmgApp():APP420 , oHmgApp():APP434 , oHmgApp():APP422 , oHmgApp():APP423 , oHmgApp():APP424 , oHmgApp():APP427 , oHmgApp():APP426 , oHmgApp():APP435 , oHmgApp():APP421 , oHmgApp():APP437 , oHmgApp():APP440 , oHmgApp():APP429 , oHmgApp():APP412 , oHmgApp():APP413 , oHmgApp():APP415 , oHmgApp():APP414 , oHmgApp():APP385 , oHmgApp():APP458 , oHmgApp():APP458 , oHmgApp():APP400 , oHmgApp():APP441 ,oHmgApp():APP430, oHmgApp():APP428 , oHmgApp():APP298 , oHmgApp():APP299 ) ) ;
   )

/*----------------------------------------------------------------------------
Month Calendar
---------------------------------------------------------------------------*/

#xcommand DEFINE MONTHCALENDAR <name> ;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP452      := .F.      ;;
   oHmgApp():APP453   := .F.      ;;
   oHmgApp():APP454   := .F.      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP428      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.


#xcommand END MONTHCALENDAR;
   =>;
   _DefineMonthCal (;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      0,;
      0,;
      oHmgApp():APP434,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP424,;
      oHmgApp():APP452,;
      oHmgApp():APP453,;
      oHmgApp():APP454,;
      oHmgApp():APP435,;
      oHmgApp():APP429,;
      430,;
      oHmgApp():APP428 , oHmgApp():APP412 , oHmgApp():APP413 , oHmgApp():APP415 , oHmgApp():APP414 )

/*----------------------------------------------------------------------------
Button
---------------------------------------------------------------------------*/

#xcommand DEFINE BUTTON <name> ;
        =>;
        oHmgApp():APP416              := <"name"> ;;
        oHmgApp():APP417                := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
        oHmgApp():APP418           := NIL      ;;
        oHmgApp():APP419            := NIL      ;;
        oHmgApp():APP420             := NIL      ;;
        oHmgApp():APP421            := NIL      ;;
        oHmgApp():APP422              := NIL      ;;
        oHmgApp():APP423              := NIL      ;;
        oHmgApp():APP424           := NIL      ;;
        oHmgApp():APP425              := .F.      ;;
        oHmgApp():APP426        := NIL      ;;
        oHmgApp():APP427       := NIL      ;;
        oHmgApp():APP428         := .F.      ;;
        oHmgApp():APP429            := NIL      ;;
       oHmgApp():APP430        := .F.      ;;
        oHmgApp():APP431               := NIL      ;;
        oHmgApp():APP432               := NIL      ;;
        oHmgApp():APP433           := NIL      ;;
        oHmgApp():APP463     := .T.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP353   := .F.      ;;
   oHmgApp():APP415   := .F.


#xcommand END BUTTON ;
        =>;
        iif ( oHmgApp():APP433 == NIL ,;
            _DefineButton (;
          oHmgApp():APP416,;
          oHmgApp():APP417 ,;
          oHmgApp():APP432 ,;
          oHmgApp():APP431 ,;
          oHmgApp():APP418 ,;
          oHmgApp():APP419 ,;
          oHmgApp():APP420 ,;
          oHmgApp():APP421 ,;
          oHmgApp():APP422 ,;
          oHmgApp():APP423 ,;
          oHmgApp():APP424 ,;
          oHmgApp():APP426  ,;
          oHmgApp():APP427 ,;
          oHmgApp():APP425 ,;
          oHmgApp():APP428  ,;
          oHmgApp():APP429 ,;
         oHmgApp():APP430, ;
      oHmgApp():APP412 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , oHmgApp():APP353 ;
      ) ,;
      iif ( oHmgApp():APP418 == NIL , ;
      _DefineImageButton (;
          oHmgApp():APP416,;
          oHmgApp():APP417,;
          oHmgApp():APP432,;
          oHmgApp():APP431,;
          "",;
          oHmgApp():APP419 ,;
          oHmgApp():APP420 ,;
          oHmgApp():APP421 ,;
          oHmgApp():APP433 ,;
          oHmgApp():APP424 ,;
          oHmgApp():APP426  ,;
          oHmgApp():APP427  ,;
          oHmgApp():APP425  ,;
           .NOT. ( oHmgApp():APP463 ) ,;
          oHmgApp():APP429 ,;
         oHmgApp():APP430, oHmgApp():APP428 ) , ;
         _DefineMixedButton ( ;
          oHmgApp():APP416,;
          oHmgApp():APP417 ,;
          oHmgApp():APP432 ,;
          oHmgApp():APP431 ,;
          oHmgApp():APP418 ,;
          oHmgApp():APP419 ,;
          oHmgApp():APP420 ,;
          oHmgApp():APP421 ,;
          oHmgApp():APP422 ,;
          oHmgApp():APP423 ,;
          oHmgApp():APP424 ,;
          oHmgApp():APP426  ,;
          oHmgApp():APP427 ,;
          oHmgApp():APP425 ,;
          oHmgApp():APP428  ,;
          oHmgApp():APP429 ,;
         oHmgApp():APP430, ;
      oHmgApp():APP412 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , oHmgApp():APP433 , oHmgApp():APP381 , oHmgApp():APP353, ;
          .NOT.( oHmgApp():APP463 ) ) ) )

/*----------------------------------------------------------------------------
Image
---------------------------------------------------------------------------*/


#xcommand DEFINE IMAGE <name> ;
   =>;
   oHmgApp():APP416     := <"name"> ;;
   oHmgApp():APP417     := NIL      ;;
   oHmgApp():APP432     := NIL      ;;
   oHmgApp():APP431     := NIL      ;;
   oHmgApp():APP433     := NIL      ;;
   oHmgApp():APP420     := NIL      ;;
   oHmgApp():APP421     := NIL      ;;
   oHmgApp():APP419     := NIL      ;;
   oHmgApp():APP429     := NIL      ;;
   oHmgApp():APP411     := .F.      ;;
  oHmgApp():APP430    := .F.      ;;
   oHmgApp():APP463     := .F.      ;;
   oHmgApp():APP457     := NIL      ;;
   oHmgApp():APP409     := .F.      ;;
   oHmgApp():APP444     := NIL      ;;
   oHmgApp():APP424     := NIL

#xcommand END IMAGE ;
   =>;
   _DefineImage(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP433,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP419,;
      oHmgApp():APP429,;
     oHmgApp():APP430,;
      oHmgApp():APP411,;
      oHmgApp():APP463,;
      oHmgApp():APP457,;
      oHmgApp():APP409,;
      oHmgApp():APP444,;
      oHmgApp():APP424 )



/*----------------------------------------------------------------------------
Check Box/Button
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBOX <name> ;
   =>;
   oHmgApp():APP416       := <"name">    ;;
   oHmgApp():APP417         := NIL         ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP418      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
        oHmgApp():APP428         := .F.          ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
        oHmgApp():APP415     := .F.          ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP463   := .F.      ;;
        oHmgApp():APP385             := NIL;;
   oHmgApp():APP437 := NIL

#xcommand DEFINE CHECKBUTTON <name> ;
   =>;
   oHmgApp():APP416       := <"name">    ;;
   oHmgApp():APP417         := NIL         ;;
   oHmgApp():APP418      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
        oHmgApp():APP433           := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
        oHmgApp():APP415     := .F.          ;;
        oHmgApp():APP428         := .F.          ;;
        oHmgApp():APP385 := NIL;;
        oHmgApp():APP463 := .T.;;
        oHmgApp():APP437 := NIL

#xcommand END CHECKBOX ;
   =>;
   _DefineCheckBox (;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP418,;
      oHmgApp():APP434,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP424,;
      oHmgApp():APP435,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP427,;
      oHmgApp():APP426,;
      oHmgApp():APP429,;
               oHmgApp():APP430,;
                oHmgApp():APP428,;
                oHmgApp():APP412 ,;
                oHmgApp():APP413 , ;
                oHmgApp():APP415 , ;
                oHmgApp():APP414,;
                oHmgApp():APP385 ,oHmgApp():APP457,oHmgApp():APP458 , oHmgApp():APP463, oHmgApp():APP437 )

#xcommand END CHECKBUTTON ;
   =>;
   IIF ( oHmgApp():APP433 == NIL , _DefineCheckButton (;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP418,;
      oHmgApp():APP434,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP424,;
      oHmgApp():APP435,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP427,;
      oHmgApp():APP426,;
      oHmgApp():APP429,;
               oHmgApp():APP430 , ;
                oHmgApp():APP428 ,;
                oHmgApp():APP412 , ;
                oHmgApp():APP413 , ;
                oHmgApp():APP415 , ;
                oHmgApp():APP414 , oHmgApp():APP437 ) , ;
           _DefineImageCheckButton ( ;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP433,;
      oHmgApp():APP434,;
      "" ,;
      0 , ;
      oHmgApp():APP424  , ;
      oHmgApp():APP435  , ;
      oHmgApp():APP420 , ;
      oHmgApp():APP421 , ;
      oHmgApp():APP427, ;
      oHmgApp():APP426 , ;
      oHmgApp():APP429, ;
      430 ,;
      oHmgApp():APP428 ,;
      .NOT. oHmgApp():APP463, oHmgApp():APP437 ) )

/*----------------------------------------------------------------------------
Combo Box
---------------------------------------------------------------------------*/

#xcommand DEFINE COMBOBOX <name>;
   =>;
   oHmgApp():APP383      := .T.      ;;
   oHmgApp():APP416       := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421   := NIL      ;;
   oHmgApp():APP436      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424   := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP428   := .F.      ;;
   oHmgApp():APP464      := .F.      ;;
   oHmgApp():APP435   := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP437   := NIL      ;;
   oHmgApp():APP429   := NIL      ;;
   430   := .F.      ;;
   oHmgApp():APP412   := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP402   := NIL      ;;
   oHmgApp():APP403  := NIL      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP443      := .F.      ;;
   oHmgApp():APP395   := ""      ;;
   oHmgApp():APP396   := .F.      ;;
   oHmgApp():APP397 := NIL      ;;
   oHmgApp():APP450 := NIL      ;;
   oHmgApp():APP249 := NIL      ;;
   oHmgApp():APP248 := NIL      ;;
   oHmgApp():APP247 := NIL      ;;
   oHmgApp():APP415   := .F.;;
   oHmgApp():APP299 := NIL;;
   oHmgApp():APP463 := .T.

#xcommand END COMBOBOX ;
   =>;
   oHmgApp():APP383      := .F.      ;;
   _DefineCombo (;
      oHmgApp():APP416 , ;
      oHmgApp():APP417 , ;
      oHmgApp():APP432 , ;
      oHmgApp():APP431 , ;
      oHmgApp():APP420 , ;
      oHmgApp():APP436 , ;
      oHmgApp():APP434 , ;
      oHmgApp():APP422 , ;
      oHmgApp():APP423 , ;
      oHmgApp():APP424 , ;
      oHmgApp():APP435 , ;
      oHmgApp():APP421 , ;
      oHmgApp():APP426 , ;
      oHmgApp():APP427 , ;
      oHmgApp():APP437 , ;
      oHmgApp():APP429 , ;
      430 , ;
      oHmgApp():APP428 , ;
      oHmgApp():APP464 , ;
      oHmgApp():APP412 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , ;
      oHmgApp():APP402 , ;
      oHmgApp():APP403 , ;
      oHmgApp():APP396 , ;
      oHmgApp():APP397 , ;
      oHmgApp():APP443 , ;
      oHmgApp():APP395 , ;
      oHmgApp():APP450 , ;
      oHmgApp():APP249 , ;
      oHmgApp():APP248 , ;
      oHmgApp():APP247 , ;
      oHmgApp():APP299 , ;
      .not. oHmgApp():APP463 )

/*----------------------------------------------------------------------------
Datepicker
---------------------------------------------------------------------------*/


#xcommand DEFINE DATEPICKER <name> ;
   => ;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP438      := .F.      ;;
   oHmgApp():APP439      := .F.      ;;
   oHmgApp():APP440     := .F.      ;;
   oHmgApp():APP426     := NIL      ;;
   oHmgApp():APP385     := NIL      ;;
   oHmgApp():APP428     := .F.      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427     := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413      := .F.      ;;
   oHmgApp():APP414      := .F.      ;;
   oHmgApp():APP437      := NIL      ;;
   oHmgApp():APP415      := .F.      ;;
   oHmgApp():ActiveControlFormat     := NIL


#xcommand END DATEPICKER ;
   => ;
        _DefineDatePick (;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP434,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP424,;
      oHmgApp():APP435,;
      oHmgApp():APP427,;
      oHmgApp():APP426,;
      oHmgApp():APP438,;
      oHmgApp():APP439,;
      oHmgApp():APP440,;
      oHmgApp():APP429,;
               oHmgApp():APP430, ;
                oHmgApp():APP428,;
                oHmgApp():APP412 , ;
                oHmgApp():APP413 , ;
                oHmgApp():APP415 , ;
                oHmgApp():APP414,;
                oHmgApp():APP385 , oHmgApp():APP437 , oHmgApp():ActiveControlFormat )



/*----------------------------------------------------------------------------
Timepicker  ( by Dr. Claudio Soto, April 2013 )
---------------------------------------------------------------------------*/

#xcommand DEFINE TIMEPICKER <name> ;
      => ;
      oHmgApp():APP416  := <"name"> ;;
      oHmgApp():APP417  := NIL ;;
      oHmgApp():APP432  := NIL ;;
      oHmgApp():APP431  := NIL ;;
      oHmgApp():APP434  := NIL ;;
      oHmgApp():APP420  := NIL ;;
      oHmgApp():APP421  := NIL ;;
      oHmgApp():APP422  := NIL ;;
      oHmgApp():APP423  := NIL ;;
      oHmgApp():APP424  := NIL ;;
      oHmgApp():APP438  := .F. ;;
      oHmgApp():APP439  := .F. ;;
      oHmgApp():APP440  := .F. ;;
      oHmgApp():APP426  := NIL ;;
      oHmgApp():APP385  := NIL ;;
      oHmgApp():APP428  := .F. ;;
      oHmgApp():APP435  := NIL ;;
      oHmgApp():APP427  := NIL ;;
      oHmgApp():APP429  := NIL ;;
     oHmgApp():APP430 := .F. ;;
      oHmgApp():APP412  := .F. ;;
      oHmgApp():APP413  := .F. ;;
      oHmgApp():APP414  := .F. ;;
      oHmgApp():APP437  := NIL ;;
      oHmgApp():APP415  := .F. ;;
      oHmgApp():ActiveControlFormat  := ""


#xcommand END TIMEPICKER ;
      => ;
      _DefineTimePick (;
         oHmgApp():APP416,;
         oHmgApp():APP417,;
         oHmgApp():APP432,;
         oHmgApp():APP431,;
         oHmgApp():APP420,;
         oHmgApp():APP421,;
         oHmgApp():APP434,;
         oHmgApp():APP422,;
         oHmgApp():APP423,;
         oHmgApp():APP424,;
         oHmgApp():APP435,;
         oHmgApp():APP427,;
         oHmgApp():APP426,;
         oHmgApp():APP438,;
         oHmgApp():APP429,;
        oHmgApp():APP430,;
         oHmgApp():APP428,;
         oHmgApp():APP412,;
         oHmgApp():APP413,;
         oHmgApp():APP415,;
         oHmgApp():APP414,;
         oHmgApp():APP385,;
         oHmgApp():APP437,;
         oHmgApp():ActiveControlFormat )


/*----------------------------------------------------------------------------
Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE EDITBOX <name> ;
   =>;
   oHmgApp():APP383      := .T.      ;;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP298      := NIL      ;;
   oHmgApp():APP299      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP441      := .F.      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP442      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP443      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
        oHmgApp():APP415     := .F.          ;;
        oHmgApp():APP428         := .F.          ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
        oHmgApp():APP385             := NIL ;;
   oHmgApp():APP398         := .F.          ;;
   oHmgApp():APP394         := .F.


#xcommand END EDITBOX ;
   =>;
   oHmgApp():APP383      := .F.      ;;
      _DefineEditBox(;
         oHmgApp():APP416,;
         oHmgApp():APP417,;
         oHmgApp():APP432,;
         oHmgApp():APP431,;
         oHmgApp():APP420,;
         oHmgApp():APP421,;
         oHmgApp():APP434,;
         oHmgApp():APP422,;
         oHmgApp():APP423,;
         oHmgApp():APP424,;
         oHmgApp():APP442,;
         oHmgApp():APP426,;
         oHmgApp():APP435,;
         oHmgApp():APP427,;
         oHmgApp():APP441,;
         oHmgApp():APP443,;
         oHmgApp():APP429,;
                       oHmgApp():APP430, ;
                        oHmgApp():APP428 ,;
                        oHmgApp():APP412 , ;
                        oHmgApp():APP413 , ;
                        oHmgApp():APP415 , ;
                        oHmgApp():APP414 ,;
                        oHmgApp():APP385, ;
         oHmgApp():APP457, ;
         oHmgApp():APP458, ;
         oHmgApp():APP398, ;
         oHmgApp():APP394 , oHmgApp():APP298 , oHmgApp():APP299 )


/*----------------------------------------------------------------------------
Rich Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE RICHEDITBOX <name> ;
   =>;
   oHmgApp():APP383      := .T.      ;;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP441      := .F.      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP442      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP443      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415     := .F.          ;;
   oHmgApp():APP428         := .F.          ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP385     := NIL ;;
   oHmgApp():APP461  := NIL ;;
   oHmgApp():APP462  := NIL ;;
   oHmgApp():APP386     := NIL ;;
   oHmgApp():APP387  := NIL ;;
   oHmgApp():APP388  := NIL

#xcommand END RICHEDITBOX ;
   =>;
      oHmgApp():APP383      := .F.      ;;
      _DefineRichEditBox(;
         oHmgApp():APP416,;
         oHmgApp():APP417,;
         oHmgApp():APP432,;
         oHmgApp():APP431,;
         oHmgApp():APP420,;
         oHmgApp():APP421,;
         oHmgApp():APP434,;
         oHmgApp():APP422,;
         oHmgApp():APP423,;
         oHmgApp():APP424,;
         oHmgApp():APP442,;
         oHmgApp():APP426,;
         oHmgApp():APP435,;
         oHmgApp():APP427,;
         oHmgApp():APP441,;
         oHmgApp():APP443,;
         oHmgApp():APP429,;
                       oHmgApp():APP430, ;
                        oHmgApp():APP428 ,;
                        oHmgApp():APP412 , ;
                        oHmgApp():APP413 , ;
                        oHmgApp():APP415 , ;
                        oHmgApp():APP414 ,;
                        oHmgApp():APP385,;
         oHmgApp():APP457, oHmgApp():APP461, oHmgApp():APP462,;
         oHmgApp():APP386, oHmgApp():APP387, oHmgApp():APP388  )

/*----------------------------------------------------------------------------
Label
---------------------------------------------------------------------------*/

#xcommand DEFINE LABEL <name> ;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP459      := .F.      ;;
   oHmgApp():IsBCC77 := .F.      ;;
   oHmgApp():APP461      := .F.      ;;
   oHmgApp():APP462      := .F.      ;;
   oHmgApp():APP463   := .F.      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP419      := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   430      := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.      ;;
   oHmgApp():APP424           := NIL          ;;
   oHmgApp():APP440   := .F.      ;;
   oHmgApp():APP409      := .F. ;;
   oHmgApp():APP393 := .F.;;
   oHmgApp():APP281  := .F.;;
   oHmgApp():APP387  := .F.


#xcommand END LABEL ;
   =>;
   _DefineLabel(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP434,;
      oHmgApp():APP420,;
      oHmgApp():APP421,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP412,;
      oHmgApp():APP459,;
      oHmgApp():IsBCC77,;
      oHmgApp():APP461,;
      oHmgApp():APP462,;
      oHmgApp():APP463,;
      oHmgApp():APP457,;
      oHmgApp():APP458,;
      oHmgApp():APP419,;
      oHmgApp():APP424,;
      oHmgApp():APP429,;
      430 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , ;
      oHmgApp():APP409 , ;
      oHmgApp():APP440 , ;
      oHmgApp():APP393 , ;
      oHmgApp():APP281 , ;
      oHmgApp():APP387 )

/*----------------------------------------------------------------------------
IP Address
---------------------------------------------------------------------------*/

#xcommand DEFINE IPADDRESS <name> ;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   430      := .F.      ;;
        oHmgApp():APP428         := .F.          ;;
   oHmgApp():APP415   := .F.

#xcommand END IPADDRESS ;
=>;
   _DefineIPAddress( ;
      oHmgApp():APP416 , ;
      oHmgApp():APP417 , ;
      oHmgApp():APP432 , ;
      oHmgApp():APP431 , ;
      oHmgApp():APP420 , ;
      oHmgApp():APP421 , ;
      oHmgApp():APP434 , ;
      oHmgApp():APP422 , ;
      oHmgApp():APP423 , ;
      oHmgApp():APP424, ;
      oHmgApp():APP427 , ;
      oHmgApp():APP426 , ;
      oHmgApp():APP435 , ;
      oHmgApp():APP429  , ;
   430 , ;
   oHmgApp():APP428 ,;
   oHmgApp():APP412 , ;
   oHmgApp():APP413 , ;
   oHmgApp():APP415 , ;
   oHmgApp():APP414 )


/*----------------------------------------------------------------------------
Grid
---------------------------------------------------------------------------*/



#xcommand DEFINE GRID <name> ;
   =>;
   oHmgApp():APP383   := .T.      ;;
   oHmgApp():APP382   := NIL      ;;
   oHmgApp():APP416   := <"name">   ;;
   oHmgApp():APP417   := NIL      ;;
   oHmgApp():APP432   := NIL      ;;
   oHmgApp():APP431   := NIL      ;;
   oHmgApp():APP420   := NIL      ;;
   oHmgApp():APP421   := NIL      ;;
   oHmgApp():APP445   := NIL      ;;
   oHmgApp():APP446   := NIL      ;;
   oHmgApp():APP281   := NIL      ;;
   oHmgApp():APP436   := NIL      ;;
   oHmgApp():APP434   := NIL      ;;
   oHmgApp():APP422   := NIL      ;;
   oHmgApp():APP423   := NIL      ;;
   oHmgApp():APP424   := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435   := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP447   := NIL      ;;
   oHmgApp():APP448   := NIL      ;;
   oHmgApp():APP449   := .F.      ;;
   oHmgApp():APP450   := NIL      ;;
   oHmgApp():APP451   := NIL      ;;
   oHmgApp():APP429   := NIL      ;;
   oHmgApp():APP455   := .F.      ;;
   oHmgApp():APP443  := .F.      ;;
   oHmgApp():APP412   := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.      ;;
   oHmgApp():APP408   := NIL      ;;
   oHmgApp():APP407   := NIL      ;;
   oHmgApp():APP457   := NIL      ;;
   oHmgApp():APP458   := NIL      ;;
   oHmgApp():APP441   := NIL      ;;
   oHmgApp():APP410   := .F.      ;;
   oHmgApp():APP401   := .F.      ;;
   oHmgApp():APP456   := .F.      ;;
   oHmgApp():APP329   := .F.      ;;
   oHmgApp():APP391   := NIL      ;;
   oHmgApp():APP390   := NIL      ;;
   oHmgApp():APP388   := NIL      ;;
   oHmgApp():APP246   := NIL      ;;
   oHmgApp():APP387   := NIL      ;;
   oHmgApp():APP327   := NIL      ;;
   oHmgApp():APP326   := NIL      ;;
   oHmgApp():APP325   := .F.      ;;
   oHmgApp():APP482   := .F.      ;;
   oHmgApp():APP486   := NIL      ;;
   oHmgApp():APP244   := NIL      ;;
   oHmgApp():APP277   := NIL      ;;
   oHmgApp():APP386   := NIL   ;;
   oHmgApp():APP419  := NIL   ;; // ON CLICK
   oHmgApp():APP247  := NIL   ;; // ON KEY
   oHmgApp():APP248  := NIL   ;; // EditOption
   oHmgApp():APP463  := .T.   ;; // Transparent
   oHmgApp():APP453  := NIL   ;; // DynamicFont
   oHmgApp():APP454  := NIL   ;; // ON CHECKBOXCLICKED
   oHmgApp():APP452  := .T.   ;; // TransparentHeader
   oHmgApp():APP352  := NIL      // ON INPLACEEDITEVENT

#xcommand END GRID ;
   =>;
   oHmgApp():APP383      := .F.      ;;
_DefineGrid ( oHmgApp():APP416 ,         ;
      oHmgApp():APP417 ,         ;
      oHmgApp():APP432 ,         ;
      oHmgApp():APP431 ,         ;
      oHmgApp():APP420 ,       ;
      oHmgApp():APP421 ,       ;
      oHmgApp():APP445 ,       ;
      oHmgApp():APP446 ,       ;
      oHmgApp():APP436 ,       ;
      oHmgApp():APP434 ,      ;
      oHmgApp():APP422 ,       ;
      oHmgApp():APP423 ,       ;
      oHmgApp():APP424 ,       ;
      oHmgApp():APP435 ,      ;
      oHmgApp():APP447 ,     ;
      oHmgApp():APP448 ,      ;
      oHmgApp():APP426 ,      ;
      oHmgApp():APP427,     ;
      oHmgApp():APP449,      ;
      oHmgApp():APP450,      ;
      oHmgApp():APP451  ,       ;
      oHmgApp():APP443 ,       ;
      oHmgApp():APP429 ,      ;
      oHmgApp():APP412,       ;
      oHmgApp():APP413,       ;
      oHmgApp():APP415,   ;
      oHmgApp():APP414 ,   ;
      oHmgApp():APP410 ,      ;
      oHmgApp():APP408 ,      ;
      oHmgApp():APP407 ,      ;
      NIL ,;
      NIL ,;
      NIL ,;
      oHmgApp():APP455 , ;
      NIL ,;
      oHmgApp():APP457 , ;
      oHmgApp():APP458 , ;
      oHmgApp():APP456 , ;
      oHmgApp():APP388 , ;
      oHmgApp():APP391 , ;
      oHmgApp():APP390 , ;
      oHmgApp():APP387 , ;
      oHmgApp():APP386 , ;
      oHmgApp():APP382 , ;
      oHmgApp():APP246 , ;
      oHmgApp():APP329 , ;
      oHmgApp():APP327 , ;
      oHmgApp():APP326 , ;
      oHmgApp():APP486 , ;
      oHmgApp():APP325 , ;
      oHmgApp():APP482 , ;
      oHmgApp():APP244 , ;
      oHmgApp():APP277 , ;
      oHmgApp():APP281 , ;
      oHmgApp():APP419 , oHmgApp():APP247 , oHmgApp():APP248 , ;
      .not. oHmgApp():APP463 , .not. oHmgApp():APP452, oHmgApp():APP453, oHmgApp():APP454, oHmgApp():APP352 )

/*----------------------------------------------------------------------------
BROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE BROWSE <name> ;
   =>;
   oHmgApp():APP383      := .T.      ;;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432               := NIL          ;;
   oHmgApp():APP431               := NIL          ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP445      := NIL      ;;
   oHmgApp():APP446      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP447   := NIL      ;;
   oHmgApp():APP448   := NIL      ;;
   oHmgApp():APP449      := .F.      ;;
   oHmgApp():APP450      := NIL      ;;
   oHmgApp():APP451      := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
        oHmgApp():APP456              := .F.          ;;
        oHmgApp():APP443             := .F.      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.      ;;
   oHmgApp():APP480      := NIL      ;;
   oHmgApp():APP481      := NIL      ;;
   oHmgApp():APP482      := .F.      ;;
   oHmgApp():APP486        := .F.      ;;
   oHmgApp():APP483      := NIL      ;;
   oHmgApp():APP441      := NIL      ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP485      := .F.      ;;
   oHmgApp():APP484   := NIL      ;;
   oHmgApp():APP391   := NIL      ;;
   oHmgApp():APP390   := NIL      ;;
   oHmgApp():APP398      := .F.      ;;
   oHmgApp():APP389         := NIL ;;
   oHmgApp():APP479      := NIL      ;;
   oHmgApp():ActiveControlFormat := NIL      ;;
   oHmgApp():APP355      := NIL      ;;
   oHmgApp():APP354      := NIL      ;;
   oHmgApp():APP246      := NIL      ;;
   oHmgApp():APP401   := .F.

#xcommand END BROWSE ;
   =>;
   oHmgApp():APP383      := .F.      ;;
_DefineBrowse ( oHmgApp():APP416 ,    ;
      oHmgApp():APP417 ,    ;
      oHmgApp():APP432 ,      ;
      oHmgApp():APP431 ,      ;
      oHmgApp():APP420 ,       ;
      oHmgApp():APP421 ,       ;
      oHmgApp():APP445 ,    ;
      oHmgApp():APP446 ,    ;
      oHmgApp():APP481 ,    ;
      oHmgApp():APP434 ,   ;
      oHmgApp():APP422 ,    ;
      oHmgApp():APP423 ,    ;
      oHmgApp():APP424 ,    ;
      oHmgApp():APP435 ,   ;
      oHmgApp():APP447  ,  ;
      oHmgApp():APP448 ,;
      oHmgApp():APP426 ,   ;
      oHmgApp():APP427,    ;
      oHmgApp():APP480 ,   ;
      oHmgApp():APP482,     ;
      oHmgApp():APP449 ,   ;
      oHmgApp():APP450 ,   ;
      oHmgApp():APP451 ,    ;
      oHmgApp():APP429  , ;
      oHmgApp():APP412 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , ;
      oHmgApp():APP443  , ;
      oHmgApp():APP457 , ;
      oHmgApp():APP458 , ;
      oHmgApp():APP485  , ;
      oHmgApp():APP401 , ;
      oHmgApp():APP398 , ;
      oHmgApp():APP486 , ;
      oHmgApp():APP441 , ;
      oHmgApp():APP483 , ;
      oHmgApp():APP484 , ;
      oHmgApp():APP456 , oHmgApp():APP391 , oHmgApp():APP389 , oHmgApp():APP390 , oHmgApp():APP479 , oHmgApp():ActiveControlFormat , oHmgApp():APP355 , oHmgApp():APP354 , oHmgApp():APP246 )

/*----------------------------------------------------------------------------
Hyperlink
---------------------------------------------------------------------------*/

#xcommand DEFINE HYPERLINK <name> ;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432           := NIL          ;;
   oHmgApp():APP431           := NIL          ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP421   := NIL      ;;
        oHmgApp():APP406       := NIL          ;;
        oHmgApp():APP434         := NIL          ;;
        oHmgApp():APP409      := .F.          ;;
        oHmgApp():APP422          := NIL          ;;
        oHmgApp():APP423          := NIL          ;;
        oHmgApp():APP412      := .F.          ;;
        oHmgApp():APP413    := .F.          ;;
        oHmgApp():APP424       := NIL          ;;
        oHmgApp():APP457     := NIL          ;;
        oHmgApp():APP458     := NIL          ;;
        oHmgApp():APP459        := .F.          ;;
        oHmgApp():IsBCC77    := .F.          ;;
        oHmgApp():APP461       := .F.          ;;
        oHmgApp():APP462       := .F.          ;;
        oHmgApp():APP463   := .F.          ;;
        oHmgApp():APP429        := NIL          ;;
   oHmgApp():APP392   := .F.      ;;
       oHmgApp():APP430    := .F.          ;;
   oHmgApp():APP440   := .F.   ;;
   oHmgApp():APP393   := .F.



#xcommand END HYPERLINK ;
   =>;
_DefineLabel (      ;
   oHmgApp():APP416,    ;
   oHmgApp():APP417,    ;
   oHmgApp():APP432,     ;
   oHmgApp():APP431,     ;
   oHmgApp():APP434,    ;
   oHmgApp():APP420,    ;
   oHmgApp():APP421,    ;
   oHmgApp():APP422,    ;
   oHmgApp():APP423,    ;
   oHmgApp():APP412,    ;
   oHmgApp():APP459 ,   ;
   oHmgApp():IsBCC77 ,  ;
   .F. ,   ;
   .F. ,   ;
   oHmgApp():APP463 ,   ;
   oHmgApp():APP457  , ;
   IF ( valtype( oHmgApp():APP458 ) = "U" , { 0 , 0 , 255 } , oHmgApp():APP458 ) , ;
   oHmgApp():APP406,   ;
   oHmgApp():APP424,   ;
   oHmgApp():APP429, ;
   430, ;
   oHmgApp():APP413, ;
   .t., ;
   .F. , ;
   oHmgApp():APP409 , ;
   oHmgApp():APP440 , ;
   oHmgApp():APP393 ) ;;
   IF ( oHmgApp():APP392 , INITHYPERLINKCURSOR ( GetControlhandle ( oHmgApp():APP416 , IF ( !empty( oHmgApp():ActiveFormName ) , oHmgApp():ActiveFormName , oHmgApp():APP417 ) ) ) , _DUMMY() )

/*----------------------------------------------------------------------------
Spinner
---------------------------------------------------------------------------*/


#xcommand DEFINE SPINNER <name>;
   =>;
   oHmgApp():APP416      := <"name">   ;;
   oHmgApp():APP417      := NIL      ;;
   oHmgApp():APP432      := NIL      ;;
   oHmgApp():APP431      := NIL      ;;
   oHmgApp():APP420      := NIL      ;;
   oHmgApp():APP434      := NIL      ;;
   oHmgApp():APP422      := NIL      ;;
   oHmgApp():APP423      := NIL      ;;
   oHmgApp():APP465      := NIL      ;;
   oHmgApp():APP466      := NIL      ;;
   oHmgApp():APP424      := NIL      ;;
   oHmgApp():APP435      := NIL      ;;
   oHmgApp():APP427   := NIL      ;;
   oHmgApp():APP426   := NIL      ;;
   oHmgApp():APP421      := NIL      ;;
   oHmgApp():APP429      := NIL      ;;
   oHmgApp():APP412      := .F.      ;;
   oHmgApp():APP413   := .F.      ;;
   oHmgApp():APP414   := .F.      ;;
   oHmgApp():APP415   := .F.      ;;
   oHmgApp():APP428    := .F.   ;;
   oHmgApp():APP457      := NIL      ;;
   oHmgApp():APP458      := NIL      ;;
   oHmgApp():APP404      := .F.      ;;
   oHmgApp():APP441      := .F.      ;;
   oHmgApp():APP405      := NIL      ;;
       oHmgApp():APP430        := .F.   ;;
   oHmgApp():APP428      := .F.

#xcommand END SPINNER;
   =>;
   _DefineSpinner(;
      oHmgApp():APP416,;
      oHmgApp():APP417,;
      oHmgApp():APP432,;
      oHmgApp():APP431,;
      oHmgApp():APP420,;
      oHmgApp():APP434,;
      oHmgApp():APP422,;
      oHmgApp():APP423,;
      oHmgApp():APP465,;
      oHmgApp():APP466,;
      oHmgApp():APP424,;
      oHmgApp():APP435,;
      oHmgApp():APP427,;
      oHmgApp():APP426,;
      oHmgApp():APP421,;
      oHmgApp():APP429 , ;
          oHmgApp():APP430, ;
      oHmgApp():APP428 , ;
      oHmgApp():APP412 , ;
      oHmgApp():APP413 , ;
      oHmgApp():APP415 , ;
      oHmgApp():APP414 , ;
      oHmgApp():APP404 , ;
      oHmgApp():APP441 , ;
      oHmgApp():APP405 ,;
      oHmgApp():APP457,;
      oHmgApp():APP458)


