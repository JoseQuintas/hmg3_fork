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


// WINDOWS (THIS)

   #xtranslate This . <p:Title,NotifyIcon,NotifyTooltip,FocusedControl> => GetProperty ( oHmgApp():ThisFormName, <"p"> )
   #xtranslate This . <p:Title,Cursor,NotifyTooltip> := <arg> => SetProperty ( oHmgApp():ThisFormName , <"p"> , <arg> )
   #xtranslate This . <p:Activate,Center,Release,Maximize,Minimize,Restore> [ () ] => DoMethod ( oHmgApp():ThisFormName , <"p"> )


// WINDOWS (THISWINDOW)

   #xtranslate ThisWindow . <p:Title,NotifyIcon,NotifyTooltip,FocusedControl,Name,Row,Col,Width,Height> => GetProperty ( oHmgApp():ThisFormName , <"p"> )
   #xtranslate ThisWindow . <p:Title,Cursor,NotifyIcon,NotifyTooltip,Row,Col,Width,Height> := <arg> => SetProperty ( oHmgApp():ThisFormName , <"p"> , <arg> )
   #xtranslate ThisWindow . <p:Activate,Center,Redraw,CenterDesktop,Release,Maximize,Minimize,Restore,Show,Hide,SetFocus> [ () ] => DoMethod ( oHmgApp():ThisFormName , <"p"> )
   #xtranslate ThisWindow . <p:CenterIn> (\<arg\>) => DoMethod ( oHmgApp():ThisFormName , \<"p"\> , \<"arg"\> )
   #xtranslate ThisWindow . <p:HANDLE,INDEX,IsMinimized,IsMaximized,ClientAreaWidth,ClientAreaHeight> => GetProperty ( oHmgApp():ThisFormName , <"p"> )
   #xtranslate ThisWindow . <p:NoClose,NoCaption,NoMaximize,NoMinimize,NoSize,NoSysMenu,HScroll,VScroll,Enabled> => GetProperty ( oHmgApp():ThisFormName , <"p"> )
   #xtranslate ThisWindow . <p:NoClose,NoCaption,NoMaximize,NoMinimize,NoSize,NoSysMenu,HScroll,VScroll,Enabled> := <arg> => SetProperty ( oHmgApp():ThisFormName , <"p"> , <arg> )
   #xtranslate ThisWindow . <p:AlphaBlendTransparent,BackColorTransparent> := <arg> => SetProperty ( oHmgApp():ThisFormName , <"p"> , <arg> )


// CONTROLS

// RichEditBox ( by Dr. Claudio Soto, January 2014 )
#xtranslate ThisRichEditBox . <p: GetClickLinkRange, GetClickLinkText > => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> )

// GridEx ( by Dr. Claudio Soto, April 2013 )
#xtranslate This . <p:ColumnCOUNT> => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> )

#xtranslate This . <p:ColumnHEADER, ColumnWIDTH, ColumnJUSTIFY, ColumnCONTROL, ColumnDYNAMICBACKCOLOR, ColumnDYNAMICFORECOLOR,;
                      ColumnVALID, ColumnWHEN, ColumnONHEADCLICK, ColumnDISPLAYPOSITION> (<n>) => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n>)

#xtranslate This . <p:ColumnHEADER, ColumnWIDTH, ColumnJUSTIFY, ColumnCONTROL, ColumnDYNAMICBACKCOLOR, ColumnDYNAMICFORECOLOR,;
                      ColumnVALID, ColumnWHEN, ColumnONHEADCLICK, ColumnDISPLAYPOSITION> (<n>) := <arg> => SetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n> , <arg> )

#xtranslate This . <p:CellEx> (<n1>, <n2>) => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n1>, <n2>)
#xtranslate This . <p:CellEx> (<n1>, <n2>) := <arg> => SetProperty (  oHmgApp():ThisFormName , oHmgApp():ThisControlName  , <"p"> , <n1>, <n2>, <arg>)

#xtranslate This . <p:AddColumnEx> (<a1> , <a2> , <a3> , <a4> , <a5> ) => Domethod (  oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <a1> , <a2> , <a3> , <a4> , <a5> )

#xtranslate This . <p:AddItemEx> (<a1> , <a2>) => Domethod (  oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <a1> , <a2> )

#xtranslate This . <p:BackGroundImage> (<a1> , <a2> , <a3> , <a4>) => SetProperty (  oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <a1> , <a2> , <a3> , <a4> )

#xtranslate This . <p:CellRowFocused, CellColFocused, CellRowClicked, CellColClicked> => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> )


* Property without arguments

   #xtranslate This . <p:Format,BackColor,FontColor,ForeColor,Value,Address,Picture,Tooltip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeout,Caption,Displayvalue,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Length,Position,CaretPos> => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> )
   #xtranslate This . <p:Format,BackColor,FontColor,ForeColor,Value,ReadOnly,Address,Picture,Tooltip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeout,Caption,DisplayValue,Enabled,Checked,RangeMin,RangeMax,Repeat,Speed,Volume,Zoom,Position,CaretPos>   := <arg>   => SetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <arg> )
   #xtranslate This . <p:HANDLE,INDEX,TYPE> => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> )

* Property with 1 argument

   #xtranslate This . <p:Item,Caption,Header> (<n>) => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n> )
   #xtranslate This . <p:Item,Caption,Header> (<n>) := <arg> => SetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n> , <arg> )

* Property with 2 arguments

   #xtranslate This . <p:Cell> ( <n1> , <n2> ) => GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n1> , <n2> )
   #xtranslate This . <p:Cell> ( <n1> , <n2> ) := <arg> => SetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <n1> , <n2> , <arg> )

* Method without arguments

   #xtranslate This . <p:Redraw,Refresh,DeleteAllItems,Release,Play,Stop,Close,PlayReverse,Pause,Eject,OpenDialog,Resume,Save> [ () ] => DoMethod ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> )

* Method with 1 argument

   #xtranslate This . <p:AddItem,DeleteItem,Open,Seek,DeletePage,DeleteColumn,Expand,Collapse> (<arg>) => DoMethod ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <arg> )

* Method with 2 arguments

   #xtranslate This . <p:AddItem> (<arg1>,<arg2>) => DoMethod ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <arg1> , <arg2> )

* Method with 3 arguments

   #xtranslate This . <p:AddItem,AddPage> (<arg1>,<arg2>,<arg3>) => DoMethod ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <arg1> , <arg2> , <arg3> )

* Method with 4 arguments

   #xtranslate This . <p:AddControl,AddColumn> ( <arg1> , <arg2> , <arg3>  , <arg4> ) => DoMethod ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <arg1> , <arg2> , <arg3> , <arg4> )


// COMMON ( REQUIRES TYPE CHECK )

   #xtranslate This . <p:Name,Row,Col,Width,Height> => if ( oHmgApp():APP231 == 'C' , GetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> ) , GetProperty ( oHmgApp():ThisFormName , <"p"> ) )
   #xtranslate This . <p:Row,Col,Width,Height> := <arg> => if ( oHmgApp():APP231 == 'C' , SetProperty ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> , <arg> ) , SetProperty ( oHmgApp():ThisFormName , <"p"> , <arg> ) )
   #xtranslate This . <p:Show,Hide,SetFocus> [ () ] => if ( oHmgApp():APP231 == 'C' , DoMethod ( oHmgApp():ThisFormName , oHmgApp():ThisControlName , <"p"> ) , DoMethod ( oHmgApp():ThisFormName , <"p"> ) )

// EVENT PROCEDURES

   #xtranslate This.QueryRowIndex      => oHmgApp():APP201
   #xtranslate This.QueryColIndex      => oHmgApp():APP202
   #xtranslate This.QueryData          => oHmgApp():APP230
   #xtranslate This.CellRowIndex       => oHmgApp():ThisItemRowIndex
   #xtranslate This.CellColIndex       => oHmgApp():ThisItemColIndex
   #xtranslate This.CellRow            => oHmgApp():ThisItemRow
   #xtranslate This.CellCol            => oHmgApp():ThisItemCol
   #xtranslate This.CellWidth          => oHmgApp():ThisItemCellWidth
   #xtranslate This.CellHeight         => oHmgApp():APP200
   #xtranslate This.CellValue          => oHmgApp():APP318
   #xtranslate This.CellValueEx := <arg> => oHmgApp():APP318 := <arg>
   #xtranslate This.CellValue   := <arg> => _HMG_SetGridCellEditValue ( <arg> )

   #xtranslate This.EditBuffer         => oHmgApp():APP278
   #xtranslate This.MarkBuffer         => oHmgApp():APP279
   #xtranslate This.AppendBuffer       => oHmgApp():APP280


// by Dr. Claudio Soto, April 2016
   #xtranslate This.InplaceEditControlHandle  => GridInplaceEdit_ControlHandle()
   #xtranslate This.InplaceEditControlIndex   => GridInplaceEdit_ControlIndex()
   #xtranslate This.InplaceEditGridName       => GridInplaceEdit_GridName()
   #xtranslate This.InplaceEditParentName     => GridInplaceEdit_ParentName()

   #xtranslate This.IsInplaceEditEventInit       => IIF( oHmgApp():GridInplaceEdit_StageEvent == 1, .T., .F. )
   #xtranslate This.IsInplaceEditEventRun        => IIF( oHmgApp():GridInplaceEdit_StageEvent == 2, .T., .F. )
   #xtranslate This.IsInplaceEditEventFinish     => IIF( oHmgApp():GridInplaceEdit_StageEvent == 3, .T., .F. )
