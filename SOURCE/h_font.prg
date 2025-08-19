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
   Copyright 1999-2008, http://www.harbour-project.org/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
     Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

#include 'hmg.ch'


*----------------------------------------------------------------------------*
FUNCTION RedrawLabel (i)   // by Giancarlo, Febraury 2015
*----------------------------------------------------------------------------*
   IF ControlByIndex( I ):Type  ==  "LABEL"
      IF ValType ( ControlByIndex( I ):CTRL009 ) == 'L'
         IF ControlByIndex( I ):CTRL009 == .T.
            RedrawWindowControlRect( ControlByIndex( I ):ParentFormHandle , ControlByIndex( I ):CTRL018 , ControlByIndex( I ):CTRL019 , ControlByIndex( I ):CTRL018 + ControlByIndex( I ):CTRL021 , ControlByIndex( I ):CTRL019 + ControlByIndex( I ):CTRL020 )
         ENDIF
      ENDIF
   ENDIF
RETURN NIL


*-----------------------------------------------------------------------------*
Function _GetFontName ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( ControlName, ParentForm )

Return   ( ControlByIndex( I ):CTRL027 )
*-----------------------------------------------------------------------------*
Function _GetFontSize ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( ControlName, ParentForm )

Return   ( ControlByIndex( I ):CTRL028 )
*-----------------------------------------------------------------------------*
Function _GetFontBold ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( ControlName, ParentForm )

Return   ( ControlByIndex( I ):CTRL029 [1] )
*-----------------------------------------------------------------------------*
Function _GetFontItalic ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( ControlName, ParentForm )

Return   ( ControlByIndex( I ):CTRL029 [2] )
*-----------------------------------------------------------------------------*
Function _GetFontUnderline ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( ControlName, ParentForm )

Return   ( ControlByIndex( I ):CTRL029 [3] )
*-----------------------------------------------------------------------------*
Function _GetFontStrikeOut ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local i

   i := GetControlIndex ( ControlName, ParentForm )

Return   ( ControlByIndex( I ):CTRL029 [4] )
*-----------------------------------------------------------------------------*
Function _SetFontName ( ControlName, ParentForm , Value )
*-----------------------------------------------------------------------------*
Local i , h , s, ab , ai , au , as , x

   //H = GetControlHandle( ControlName , ParentForm )
   //T = GetControlType (ControlName,ParentForm)

   i := GetControlIndex ( ControlName, ParentForm )
   DeleteObject ( ControlByIndex( I ):CTRL036 )
   h := ControlByIndex( i ):Handle
   s := ControlByIndex( I ):CTRL028
   ab := ControlByIndex( I ):CTRL029 [1]
   ai := ControlByIndex( I ):CTRL029 [2]
   au := ControlByIndex( I ):CTRL029 [3]
   as := ControlByIndex( I ):CTRL029 [4]
   ControlByIndex( I ):CTRL027 := Value
   do case
   case ControlByIndex( i ):Type == "SPINNER"
      SetFontNameSize ( h [1] , Value , s , ab , ai , au , as )

   case ControlByIndex( i ):Type == "RADIOGROUP"

      For x := 1 To HMG_LEN (h)
         SetFontNameSize ( h [x] , Value , s , ab , ai , au , as )
      Next x

   otherwise
      SetFontNameSize ( h , Value , s , ab , ai , au , as )
   Endcase

   RedrawLabel (i)
Return Nil
*-----------------------------------------------------------------------------*
Function _SetFontSize ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Local i , h , n , ab , ai , au , as , x

   i := GetControlIndex ( ControlName, ParentForm )
   DeleteObject ( ControlByIndex( I ):CTRL036 )
   h := ControlByIndex( i ):Handle
   n := ControlByIndex( I ):CTRL027
   ab := ControlByIndex( I ):CTRL029 [1]
   ai := ControlByIndex( I ):CTRL029 [2]
   au := ControlByIndex( I ):CTRL029 [3]
   as := ControlByIndex( I ):CTRL029 [4]
   ControlByIndex( I ):CTRL028 := Value
   do case
   case ControlByIndex( i ):Type == "SPINNER"
      SetFontNameSize ( h [1], n , Value , ab , ai , au , as )

   case ControlByIndex( i ):Type == "RADIOGROUP"

      For x := 1 To HMG_LEN (h)
         SetFontNameSize ( h [x], n , Value , ab , ai , au , as )
      Next x

   otherwise
      SetFontNameSize ( h , n , Value , ab , ai , au , as )
   Endcase

   RedrawLabel (i)
Return Nil
*-----------------------------------------------------------------------------*
Function _SetFontBold ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Local i , h , n , s , ai , au , as , x

   i := GetControlIndex ( ControlName, ParentForm )
   DeleteObject ( ControlByIndex( I ):CTRL036 )
   h := ControlByIndex( i ):Handle
   n := ControlByIndex( I ):CTRL027
   s := ControlByIndex( I ):CTRL028
   ai := ControlByIndex( I ):CTRL029 [2]
   au := ControlByIndex( I ):CTRL029 [3]
   as := ControlByIndex( I ):CTRL029 [4]
   ControlByIndex( I ):CTRL029 [1] := Value
   do case
   case ControlByIndex( i ):Type == "SPINNER"

      SetFontNameSize ( h [1], n , s , Value , ai , au , as )

   case ControlByIndex( i ):Type == "RADIOGROUP"

      For x := 1 To HMG_LEN (h)

         SetFontNameSize ( h [x], n , s , Value , ai , au , as )

      Next x

   otherwise
      SetFontNameSize ( h , n , s , Value , ai , au , as )
   Endcase

   RedrawLabel (i)
Return Nil
*-----------------------------------------------------------------------------*
Function _SetFontItalic ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Local i , h , n , s , ab , au , as , x

   i := GetControlIndex ( ControlName, ParentForm )
   DeleteObject ( ControlByIndex( I ):CTRL036 )
   h := ControlByIndex( i ):Handle
   n := ControlByIndex( I ):CTRL027
   s := ControlByIndex( I ):CTRL028
   ab := ControlByIndex( I ):CTRL029 [1]
   au := ControlByIndex( I ):CTRL029 [3]
   as := ControlByIndex( I ):CTRL029 [4]
   ControlByIndex( I ):CTRL029 [2] := Value
   do case
   case ControlByIndex( i ):Type == "SPINNER"

      SetFontNameSize ( h [1], n , s , ab , Value , au , as )

   case ControlByIndex( i ):Type == "RADIOGROUP"

      For x := 1 To HMG_LEN (h)

         SetFontNameSize ( h [x], n , s , ab , Value , au , as )

      Next x

   otherwise
      SetFontNameSize ( h , n , s , ab , Value , au , as )
   Endcase

   RedrawLabel (i)
Return Nil
*-----------------------------------------------------------------------------*
Function _SetFontUnderline ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Local i , h , n , s , ab , ai , as , x

   i := GetControlIndex ( ControlName, ParentForm )
   DeleteObject ( ControlByIndex( I ):CTRL036 )
   h := ControlByIndex( i ):Handle
   n := ControlByIndex( I ):CTRL027
   s := ControlByIndex( I ):CTRL028
   ab := ControlByIndex( I ):CTRL029 [1]
   ai := ControlByIndex( I ):CTRL029 [2]
   as := ControlByIndex( I ):CTRL029 [4]
   ControlByIndex( I ):CTRL029 [3] := Value
   do case
   case ControlByIndex( i ):Type == "SPINNER"
      SetFontNameSize ( h [1], n , s , ab , ai , Value , as )

   case ControlByIndex( i ):Type == "RADIOGROUP"

      For x := 1 To HMG_LEN (h)

         SetFontNameSize ( h [x], n , s , ab , ai , Value , as )

      Next x

   otherwise
      SetFontNameSize ( h , n , s , ab , ai , Value , as )
   Endcase

   RedrawLabel (i)
Return Nil
*-----------------------------------------------------------------------------*
Function _SetFontStrikeOut ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Local i , h , n , s , ab , ai , au , x

   i := GetControlIndex ( ControlName, ParentForm )
   DeleteObject ( ControlByIndex( I ):CTRL036 )
   h := ControlByIndex( i ):Handle
   n := ControlByIndex( I ):CTRL027
   s := ControlByIndex( I ):CTRL028
   ab := ControlByIndex( I ):CTRL029 [1]
   ai := ControlByIndex( I ):CTRL029 [2]
   au := ControlByIndex( I ):CTRL029 [3]
   ControlByIndex( I ):CTRL029 [4] := Value
   do case
   case ControlByIndex( i ):Type == "SPINNER"
      SetFontNameSize ( h [1], n , s , ab , ai , au , Value )

   case ControlByIndex( i ):Type == "RADIOGROUP"

      For x := 1 To HMG_LEN (h)

         SetFontNameSize ( h [x], n , s , ab , ai , au , Value )

      Next x

   otherwise
      SetFontNameSize ( h , n , s , ab , ai , au , Value )
   Endcase

   RedrawLabel (i)
Return Nil



*******************************************************************************
* by Dr. Claudio Soto (July 2014)
*******************************************************************************


*-----------------------------------------------------------------------------*
Function GetControlFont ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
LOCAL i := GetControlIndex ( ControlName, ParentForm )
LOCAL aFontData := {}
      AADD ( aFontData , ControlByIndex( I ):CTRL027 )         //   FontName
      AADD ( aFontData , ControlByIndex( I ):CTRL028 )         //   FontSize
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 1 ] )   //   Bold
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 2 ] )   //   Italic
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 3 ] )   //   Underline
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 4 ] )   //   Strikeout
Return aFontData


*-----------------------------------------------------------------------------*
Function GetControlFontByIndex ( i )
*-----------------------------------------------------------------------------*
LOCAL aFontData := {}
      AADD ( aFontData , ControlByIndex( I ):CTRL027 )         //   FontName
      AADD ( aFontData , ControlByIndex( I ):CTRL028 )         //   FontSize
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 1 ] )   //   Bold
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 2 ] )   //   Italic
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 3 ] )   //   Underline
      AADD ( aFontData , ControlByIndex( I ):CTRL029 [ 4 ] )   //   Strikeout
Return aFontData


*-----------------------------------------------------------------------------*
Function GetControlFontHandle ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
LOCAL i := GetControlIndex ( ControlName, ParentForm )
Return ControlByIndex( I ):CTRL036


*-----------------------------------------------------------------------------*
Function GetControlFontHandleByIndex ( i )
*-----------------------------------------------------------------------------*
Return ControlByIndex( I ):CTRL036



*-----------------------------------------------------------------------------*
Function SetControlFont ( ControlName, ParentForm , aFont )
*-----------------------------------------------------------------------------*
LOCAL i := GetControlIndex (ControlName, ParentForm)
LOCAL ControlHandle := GetControlHandle (ControlName, ParentForm)
LOCAL hFont := _SetFont (ControlHandle, aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6])
   DeleteObject (ControlByIndex( I ):CTRL036)
   ControlByIndex( I ):CTRL036 := hFont
   RedrawLabel (i)
Return hFont


*-----------------------------------------------------------------------------*
Function SetControlFontByIndex ( i , aFont )
*-----------------------------------------------------------------------------*
LOCAL ControlHandle := ControlByIndex( I ):Handle
LOCAL hFont := _SetFont (ControlHandle, aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6])
   DeleteObject (ControlByIndex( I ):CTRL036)
   ControlByIndex( I ):CTRL036 := hFont
   RedrawLabel (i)
Return hFont


*-----------------------------------------------------------------------------*
Function ChangeControlFontSize ( ControlName, ParentForm , nSize )
*-----------------------------------------------------------------------------*
LOCAL i             := GetControlIndex  (ControlName, ParentForm)
LOCAL ControlHandle := ControlHandle := ControlByIndex( I ):Handle
LOCAL aFont         := GetControlFontByIndex ( i )
LOCAL hFont
   IF ValType (nSize) == "N" .AND. nSize > 0
      aFont[2] := nSize
   ENDIF
   hFont := _SetFont (ControlHandle, aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6])
   DeleteObject (ControlByIndex( I ):CTRL036)
   ControlByIndex( I ):CTRL036 := hFont
   RedrawLabel (i)
Return hFont
