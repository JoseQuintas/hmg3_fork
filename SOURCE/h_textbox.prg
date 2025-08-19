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
this software; see the file COPYING. IF not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
visit the web site http://www.gnu.org/).

As a special exception, you have permission for additional uses of the text
contained in this release of HMG.

The exception is that, IF you link the HMG library with other
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

#include "SET_COMPILE_HMG_UNICODE.ch"

#include "common.ch"
#include "hmg.ch"

#define EM_REPLACESEL   194   // ok
#define WM_UNDO        772   // ok
#define EM_SETMODIFY    185   // ok
#define WM_PASTE       770   // ok
#define EM_GETLINE      196   // ok
#define EM_SETSEL       177   // ok
#define WM_CLEAR        771   // ok
#define EM_GETSEL       176   // ok
#define EM_UNDO        199    // ok
#define WM_SETTEXT     12      // ok

*--------------------------------------------------------*

FUNCTION _DefineTextBox( cControlName, cParentForm, nx, ny, nWidth, nHeight, ;
      cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
      lUpper, lLower, lNumeric, lPassword, ;
      uLostFocus, uGotFocus, uChange , uEnter , RIGHT  , ;
      HelpId , readonly , bold, italic, underline, ;
      strikeout , field , backcolor , fontcolor , ;
      invisible , notabstop , disabledbackcolor , disabledfontcolor )
   *--------------------------------------------------------*

   LOCAL nParentForm := 0
   LOCAL nControlHandle := 0
   LOCAL mVar
   LOCAL FontHandle
   LOCAL WorkArea
   LOCAL k
   LOCAL cParentTabName, oControl

   // Asign STANDARD values to optional params.
   DEFAULT nWidth     TO 120
   DEFAULT nHeight    TO 24
   DEFAULT cValue     TO ""
   DEFAULT uChange    TO ""
   DEFAULT uGotFocus  TO ""
   DEFAULT uLostFocus TO ""
   DEFAULT nMaxLength TO 0 // 255
   DEFAULT lUpper     TO .f.
   DEFAULT lLower     TO .f.
   DEFAULT lNumeric   TO .f.
   DEFAULT lPassword  TO .f.
   DEFAULT uEnter     TO ""

   DEFAULT readonly TO .f.
   DEFAULT bold TO .f.
   DEFAULT italic TO .f.
   DEFAULT underline TO .f.
   DEFAULT strikeout TO .f.
   DEFAULT RIGHT TO .f.
   DEFAULT invisible TO .f.
   DEFAULT notabstop TO .f.

   IF ValType ( Field ) != 'U'
      IF  HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + cControlName + " Of " + cParentForm + " : You must specify a fully qualified field name. Program Terminated")
      ELSE
         WORKAREA := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
         IF Select (WorkArea) != 0
            cValue := &(Field)
         ENDIF
      ENDIF
   ENDIF

   IF oHmgApp():APP264 = .T.
      cParentForm := oHmgApp():ActiveFormName
      IF .NOT. Empty (oHmgApp():APP224) .AND. ValType(cFontName) == "U"
         cFontName := oHmgApp():APP224
      ENDIF
      IF .NOT. Empty ( oHmgApp():ActiveFontSize ) .AND. ValType(nFontSize) == "U"
         nFontSize := oHmgApp():ActiveFontSize
      ENDIF
   ENDIF

   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         nx    := nx + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         ny    := ny + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         cParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
         cParentTabName := oHmgApp():APP225
      ENDIF
   ENDIF

   nParentForm  := GetFormHandle( cParentForm )

   // Check IF the window/form is defined.
   IF ( .NOT. _IsWindowDefined( cParentForm ) )
      MsgHMGError( "Window: " + cParentForm + " is not defined. Program terminated." )
   ENDIF

   // Check IF the control is already defined.
   IF ( _IsControlDefined( cControlName, cParentForm ) )
      MsgHMGError( "Control: " + cControlName + " of " + cParentForm + " already defined. Program Terminated." )
   ENDIF

   mVar := '_' + cParentForm + '_' + cControlName

   // Creates the control window.
   nControlHandle := InitTextBox( nParentForm, 0, nx, ny, nWidth, nHeight, '', 0, nMaxLength, ;
      lUpper, lLower, .f., lPassword , RIGHT , readonly , invisible , notabstop )

   IF valtype(cfontname) != "U" .AND. valtype(nfontsize) != "U"
      FontHandle := _SetFont (nControlHandle,cFontName,nFontSize,bold,italic,underline,strikeout)
   ELSE
      FontHandle := _SetFont (nControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   ENDIF

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , nControlHandle )
   ENDIF

   // Add a tooltip IF param has value.
   IF ( ValType( cToolTip ) != "U" )
      SetToolTip( nControlHandle, cToolTip, GetFormToolTipHandle( cParentForm ) )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := if( lNumeric, "NUMTEXT", "TEXT" )
      :Name :=  cControlName
      :Handle :=  nControlHandle
      :ParentFormHandle :=  nParentForm
      :CTRL005 :=  0
      :CTRL006 :=  ""
      :CTRL007 :=  Field
      :CTRL008 :=  nil
      :CTRL009 :=  ""
      :CTRL010 :=   uLostFocus
      :CTRL011 := uGotFocus
      :CTRL012 :=  uChange
      :IsDeleted :=  .F.
      :CTRL014 :=  backcolor
      :CTRL015 :=   fontcolor
      :CTRL016 :=  uEnter
      :CTRL017 :=  {}
      :CTRL018 :=  ny
      :CTRL019 :=  nx
      :CTRL020 := nwidth
      :CTRL021 := nheight
      :CTRL022 :=  0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=  cfontname
      :CTRL028 :=  nfontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=   ctooltip
      :CTRL031 :=   cParentTabName
      :CTRL032 :=   0
      :CTRL033 :=   ''
      :CTRL034 :=  .NOT.  invisible
      :CTRL035 :=   HelpId
      :CTRL036 :=   FontHandle
      :CTRL037 :=   0
      :CTRL038 :=   .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

      :CTRL040 [  9 ] := DISABLEDBACKCOLOR
      :CTRL040 [ 10 ] := DISABLEDFONTCOLOR
      :CTRL040 [ 11 ] := readonly
   ENDWITH

   // With NUMERIC clause, transform numeric value into a string.
   IF ( lNumeric )
      IF Valtype(cValue) != 'C'
         cValue := AllTrim( Str( cValue ) )
      ENDIF
   ENDIF

   // Fill the TEXTBOX with the text given.
   IF ( HMG_LEN( cValue ) > 0 )
      SetWindowText ( nControlHandle , cValue )
   ENDIF

   IF valtype ( Field ) != 'U'
      aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , k )
   ENDIF

   RETURN Nil
   *-----------------------------------------------------------------------------*

FUNCTION _DefineMaskedTextbox ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , Format , bold, italic, underline, strikeout , field  , backcolor , fontcolor , readonly  , invisible , notabstop  , disabledbackcolor , disabledfontcolor )

   *-----------------------------------------------------------------------------*
   LOCAL i, cParentForm ,c,mVar , WorkArea , k := 0
   LOCAL ControlHandle, oControl
   LOCAL FontHandle
   LOCAL cParentTabName

   * Unused Parameters
   RIGHTALIGN := NIL
   *
   DEFAULT readonly TO .f.
   DEFAULT bold TO .f.
   DEFAULT italic TO .f.
   DEFAULT underline TO .f.
   DEFAULT strikeout TO .f.
   DEFAULT RightAlign TO .f. // not used, but is defined as argument
   DEFAULT invisible TO .f.
   DEFAULT notabstop TO .f.

   IF ValType ( Field ) != 'U'
      IF  HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      ELSE
         WORKAREA := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
         IF Select (WorkArea) != 0
            VALUE := &(Field)
         ENDIF
      ENDIF
   ENDIF

   IF valtype(Format) == "U"
      Format := ""
   ENDIF

   FOR i := 1 To HMG_LEN (InputMask)

      c := HB_USUBSTR ( InputMask , i , 1 )

#ifdef COMPILE_HMG_UNICODE
      IF c != '9' .AND.  c != '$' .AND. c != '*' .AND. c !='.' .AND. c != ','  .AND. c != ' ' .AND. c != '€' .AND. c != 'â‚¬'
#else
         IF c != '9' .AND.  c != '$' .AND. c != '*' .AND. c !='.' .AND. c != ','  .AND. c != ' ' .AND. c != '€'
#endif
            MsgHMGError("@...TEXTBOX: Wrong InputMask Definition" )
         ENDIF

      NEXT i

      FOR i := 1 To HMG_LEN (Format)

         c := HB_USUBSTR ( Format , i , 1 )

         IF c!='C' .AND. c!='X' .AND. c!= '('  .AND. c!= 'E'
            MsgHMGError("@...TEXTBOX: Wrong Format Definition" )
         ENDIF

      NEXT i

      IF valtype(change) == "U"
         change := ""
      ENDIF

      IF valtype(gotfocus) == "U"
         gotfocus := ""
      ENDIF

      IF valtype(enter) == "U"
         enter := ""
      ENDIF

      IF valtype(lostfocus) == "U"
         lostfocus := ""
      ENDIF

      IF valtype(Width) == "U"
         WIDTH := 120
      ENDIF

      IF valtype(height) == "U"
         HEIGHT := 24
      ENDIF

      IF valtype(Value) == "U"
         VALUE := ""
      ENDIF

      IF .NOT. Empty (Format)
         Format := '@' + AllTrim(Format)
      ENDIF

      INPUTMASK :=  Format + ' ' + InputMask

      VALUE := Transform ( value , InputMask )

      IF oHmgApp():APP264 = .T.
         ParentForm := oHmgApp():ActiveFormName
         IF .NOT. Empty (oHmgApp():APP224) .AND. ValType(FontName) == "U"
            FONTNAME := oHmgApp():APP224
         ENDIF
         IF .NOT. Empty ( oHmgApp():ActiveFontSize ) .AND. ValType(FontSize) == "U"
            FONTSIZE := oHmgApp():ActiveFontSize
         ENDIF
      ENDIF
      IF oHmgApp():FrameLevel > 0
         IF oHmgApp():APP240 == .F.
            x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
            y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
            ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
            cParentTabName := oHmgApp():APP225
         ENDIF
      ENDIF

      IF .NOT. _IsWindowDefined (ParentForm)
         MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
      ENDIF

      IF _IsControlDefined (ControlName,ParentForm)
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
      ENDIF

      mVar := '_' + ParentForm + '_' + ControlName

      cParentForm := ParentForm

      ParentForm = GetFormHandle (ParentForm)

      ControlHandle := InitMaskedTextBox ( ParentForm, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , .t. , readonly  , invisible , notabstop )
      IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
         FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
      ELSE
         FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
      ENDIF

      IF oHmgApp():BeginTabActive = .T.
         aAdd ( oHmgApp():APP142 , ControlHandle )
      ENDIF

      IF valtype(tooltip) != "U"
         SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
      ENDIF

      k := _GetControlFree()

      PUBLIC &mVar. := k

      oControl := ControlByIndex( k )

      WITH OBJECT oControl
         :Type := "MASKEDTEXT"
         :Name :=  ControlName
         :Handle :=   ControlHandle
         :ParentFormHandle :=   ParentForm
         :CTRL005 :=  0
         :CTRL006 :=  ""
         :CTRL007 :=   InputMask
         :CTRL008 :=  Nil
         :CTRL009 :=  GetNumMask ( InputMask )
         :CTRL010 :=  lostfocus
         :CTRL011 :=  gotfocus
         :CTRL012 :=  Change
         :IsDeleted :=  .F.
         :CTRL014 :=  backcolor
         :CTRL015 :=  fontcolor
         :CTRL016 :=  enter
         :CTRL017 :=  Field
         :CTRL018 :=  y
         :CTRL019 :=  x
         :CTRL020 :=  width
         :CTRL021 :=  height
         :CTRL022 :=  .F.
         :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
         :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
         :CTRL025 := ""
         :CTRL026 :=  0
         :CTRL027 :=  fontname
         :CTRL028 :=  fontsize
         :CTRL029 :=  {bold,italic,underline,strikeout}
         :CTRL030 :=  tooltip
         :CTRL031 :=   cParentTabName
         :CTRL032 :=   0
         :CTRL033 :=   ''
         :CTRL034 :=  .NOT.  invisible
         :CTRL035 :=   HelpId
         :CTRL036 :=   FontHandle
         :CTRL037 :=  0
         :CTRL038 :=   .T.
         :CTRL039 := 0
         :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

         :CTRL040 [  9 ] := DISABLEDBACKCOLOR
         :CTRL040 [ 10 ] := DISABLEDFONTCOLOR
         :CTRL040 [ 11 ] := readonly
      ENDWITH

      SetWindowText ( ControlHandle , value )

      IF valtype ( Field ) != 'U'
         aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , k )
      ENDIF

      RETURN Nil

FUNCTION GetNumFromText ( Text , i )

   LOCAL x , c , s

   s := ''

   FOR x := 1 To HMG_LEN ( Text )

      c := HB_USUBSTR(Text,x,1)

      IF c='0' .OR. c='1' .OR. c='2' .OR. c='3' .OR. c='4' .OR. c='5' .OR. c='6' .OR. c='7' .OR. c='8' .OR. c='9' .OR. c='.' .OR. c='-'
         s := s + c
      ENDIF

   NEXT x

   IF HB_ULEFT ( AllTrim(Text) , 1 ) == '(' .OR.  HB_URIGHT ( AllTrim(Text) , 2 ) == 'DB'
      s := '-' + s
   ENDIF

   s := Transform ( Val(s) , ControlByIndex( I ):CTRL009 )

   RETURN Val(s)

FUNCTION GetNumMask ( Text )

   LOCAL i , c , s

   s := ''

   FOR i := 1 To HMG_LEN ( Text )

      c := HB_USUBSTR(Text,i,1)

      IF c='9' .OR. c='.'
         s := s + c
      ENDIF

      IF c = '$' .OR. c = '*'
         s := s+'9'
      ENDIF

   NEXT i

   RETURN s

   *-----------------------------------------------------------------------------*

FUNCTION _DefineCharMaskTextbox ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , bold, italic, underline, strikeout , field  , backcolor , fontcolor , date , readonly  , invisible , notabstop , disabledbackcolor , disabledfontcolor )

   *-----------------------------------------------------------------------------*
   LOCAL cParentForm, mVar, WorkArea , dateformat , k := 0
   LOCAL ControlHandle, oControl
   LOCAL FontHandle
   LOCAL cParentTabName

   DEFAULT invisible  TO .F.

   IF ValType ( Field ) != 'U'
      IF  HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      ELSE
         WORKAREA := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
         IF Select (WorkArea) != 0
            VALUE := &(Field)
         ENDIF
      ENDIF
   ENDIF

   IF valtype(date) == "U"
      date := .F.
   ENDIF

   IF valtype(change) == "U"
      change := ""
   ENDIF

   IF valtype(gotfocus) == "U"
      gotfocus := ""
   ENDIF

   IF valtype(enter) == "U"
      enter := ""
   ENDIF

   IF valtype(lostfocus) == "U"
      lostfocus := ""
   ENDIF

   IF valtype(Width) == "U"
      WIDTH := 120
   ENDIF

   IF valtype(height) == "U"
      HEIGHT := 24
   ENDIF

   IF valtype(Value) == "U"
      IF date == .F.
         VALUE := ""
      ELSE
         VALUE := ctod ('  /  /  ')
      ENDIF
   ENDIF

   dateformat := set ( _SET_DATEFORMAT )

   IF date == .t.
      IF HMG_LOWER ( HB_ULEFT ( dateformat , 4 ) ) == "yyyy"

         IF '/' $ dateformat
            INPUTMASK := '9999/99/99'
         ELSEIF '.' $ dateformat
            INPUTMASK := '9999.99.99'
         ELSEIF '-' $ dateformat
            INPUTMASK := '9999-99-99'
         ENDIF

      ELSEIF HMG_LOWER ( HB_URIGHT ( dateformat , 4 ) ) == "yyyy"

         IF '/' $ dateformat
            INPUTMASK := '99/99/9999'
         ELSEIF '.' $ dateformat
            INPUTMASK := '99.99.9999'
         ELSEIF '-' $ dateformat
            INPUTMASK := '99-99-9999'
         ENDIF

      ELSE

         IF '/' $ dateformat
            INPUTMASK := '99/99/99'
         ELSEIF '.' $ dateformat
            INPUTMASK := '99.99.99'
         ELSEIF '-' $ dateformat
            INPUTMASK := '99-99-99'
         ENDIF

      ENDIF
   ENDIF

   IF oHmgApp():APP264 = .T.
      ParentForm := oHmgApp():ActiveFormName
      IF .NOT. Empty ( oHmgApp():APP224 ) .AND. ValType( FontName ) == "U"
         FONTNAME := oHmgApp():APP224
      ENDIF
      IF .NOT. Empty ( oHmgApp():ActiveFontSize ) .AND. ValType( FontSize ) == "U"
         FONTSIZE := oHmgApp():ActiveFontSize
      ENDIF
   ENDIF
   IF oHmgApp():FrameLevel > 0
      IF oHmgApp():APP240 == .F.
         x    := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         y    := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
         cParentTabName := oHmgApp():APP225
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   ControlHandle := InitCharMaskTextBox ( ParentForm, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , rightalign , readonly  , invisible , notabstop )
   IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   ELSE
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   ENDIF

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , ControlHandle )
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( k )

   WITH OBJECT oControl
      :Type := "CHARMASKTEXT"
      :Name := ControlName
      :Handle := ControlHandle
      :ParentFormHandle := ParentForm
      :CTRL005 := 0
      :CTRL006 := ""
      :CTRL007 := Field
      :CTRL008 := Nil
      :CTRL009 := InputMask
      :CTRL010 := lostfocus
      :CTRL011 := gotfocus
      :CTRL012 := Change
      :IsDeleted := .F.
      :CTRL014 := backcolor
      :CTRL015 := fontcolor
      :CTRL016 := enter
      :CTRL017 :=date
      :CTRL018 := y
      :CTRL019 := x
      :CTRL020 := width
      :CTRL021 := height
      :CTRL022 := 0
      :CTRL023 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 := iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 := ""
      :CTRL026 := 0
      :CTRL027 := fontname
      :CTRL028 := fontsize
      :CTRL029 := {bold,italic,underline,strikeout}
      :CTRL030 := tooltip
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  0
      :CTRL033 :=  ''
      :CTRL034 := .NOT.  invisible
      :CTRL035 := HelpId
      :CTRL036 :=  FontHandle
      :CTRL037 := 0
      :CTRL038 :=  .T.
      :CTRL039 := 0
      :CTRL040 := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

      :CTRL040 [  9 ] := DISABLEDBACKCOLOR
      :CTRL040 [ 10 ] := DISABLEDFONTCOLOR
      :CTRL040 [ 11 ] := readonly
   ENDWITH

   IF date == .F.
      SetWindowText ( ControlHandle , Value  )
   ELSE
      SetWindowText ( ControlHandle , dtoc ( Value ) )
   ENDIF

   IF valtype ( Field ) != 'U'
      aAdd ( FormByIndex( GetFormIndex ( cParentForm ) ):FORM089 , k )
   ENDIF

   RETURN Nil

   *------------------------------------------------------------------------------*

PROCEDURE ProcessCharMask ( i , d )

   *------------------------------------------------------------------------------*
   LOCAL InBuffer , OutBuffer := '' , icp , x , CB , CM , BadEntry := .F. , InBufferLeft , InBufferRight , Mask , OldChar , BackInbuffer
   LOCAL pc := 0
   LOCAL fnb := 0
   LOCAL dc := 0
   LOCAL pFlag := .F.
   LOCAL ncp := 0
   LOCAL NegativeZero := .F.
   LOCAL Output := ''
   LOCAL ol := 0

   * Unused Parameters
   d := Nil
   *

   IF ValType (ControlByIndex( I ):CTRL022 ) == 'L'
      IF ControlByIndex( I ):CTRL022 == .F.
         RETURN
      ENDIF
   ENDIF

   Mask := ControlByIndex( I ):CTRL009

   // Store Initial CaretPos

   icp := HiWord ( SendMessage( ControlByIndex( i ):Handle , EM_GETSEL , 0 , 0 ) )

   // GET Current Content

   InBuffer := GetWindowText ( ControlByIndex( i ):Handle )

   // RL 104

   IF HB_ULEFT ( AllTrim(InBuffer) , 1 ) == '-' .AND. Val(InBuffer) == 0
      // Tone (1000,1)
      NegativeZero := .T.
   ENDIF

   //

   IF Pcount() > 1

      // Point Count For Numeric InputMask

      FOR x := 1 To HMG_LEN ( InBuffer )
         CB := HB_USUBSTR (InBuffer , x , 1 )
         IF CB == '.' .OR. ;
               CB == ","   // MOL, April 2016
            pc++
         ENDIF
      NEXT x

      // RL 89
      IF HB_ULEFT (InbuFfer,1) == '.' .OR. ;
            HB_ULEFT (InbuFfer,1) == ','   // MOL, April 2016
         pFlag := .T.
      ENDIF
      //

      // Find First Non-Blank Position

      FOR x := 1 To HMG_LEN ( InBuffer )
         CB := HB_USUBSTR (InBuffer , x , 1 )
         IF CB != ' '
            fnb := x
            EXIT
         ENDIF
      NEXT x

   ENDIF

   //

   BackInBuffer := InBuffer

   OldChar := HB_USUBSTR ( InBuffer , icp+1 , 1 )

   IF HMG_LEN ( InBuffer ) < HMG_LEN ( Mask )

      InBufferLeft := HB_ULEFT ( InBuffer , icp )

      InBufferRight := HB_URIGHT ( InBuffer , HMG_LEN (InBuffer) - icp )

      // JK

      IF CharMaskTekstOK(InBufferLeft + ' ' + InBufferRight,Mask) .AND. CharMaskTekstOK(InBufferLeft + InBufferRight,Mask)==.f.
         InBuffer := InBufferLeft + ' ' + InBufferRight
      ELSE
         InBuffer := InBufferLeft +InBufferRight
      ENDIF

   ENDIF

   IF HMG_LEN ( InBuffer ) > HMG_LEN ( Mask )

      InBufferLeft := HB_ULEFT ( InBuffer , icp )

      InBufferRight := HB_URIGHT ( InBuffer , HMG_LEN (InBuffer) - icp - 1 )

      InBuffer := InBufferLeft + InBufferRight

   ENDIF

   // Process Mask

   FOR x := 1 To HMG_LEN (Mask)

      CB := HB_USUBSTR (InBuffer , x , 1 )
      CM := HB_USUBSTR (Mask , x , 1 )

      DO CASE

      CASE (CM) == '!'

         OutBuffer := OutBuffer + HMG_UPPER(CB)

      CASE (CM) == 'A'

         IF HMG_ISALPHA ( CB ) .OR. CB == ' '

            OutBuffer := OutBuffer + CB

         ELSE

            IF x == icp
               BadEntry := .T.
               OutBuffer := OutBuffer + OldChar
            ELSE
               OutBuffer := OutBuffer + ' '
            ENDIF

         ENDIF

      CASE CM == '9'

         IF HMG_ISDIGIT ( CB ) .OR. CB == ' ' .OR. ( CB == '-' .AND. x == fnb .AND. Pcount() > 1 )

            OutBuffer := OutBuffer + CB

         ELSE

            IF x == icp
               BadEntry := .T.
               OutBuffer := OutBuffer + OldChar
            ELSE
               OutBuffer := OutBuffer + ' '
            ENDIF

         ENDIF

      CASE CM == ' '

         IF CB == ' '

            OutBuffer := OutBuffer + CB

         ELSE

            IF x == icp
               BadEntry := .T.
               OutBuffer := OutBuffer + OldChar
            ELSE
               OutBuffer := OutBuffer + ' '
            ENDIF

         ENDIF

      OTHERWISE

         OutBuffer := OutBuffer + CM

      END CASE

   NEXT x

   // Replace Content

   IF ! ( BackInBuffer == OutBuffer )
      SetWindowText ( ControlByIndex( i ):Handle , OutBuffer )
   ENDIF

   IF pc > 1

      IF NegativeZero == .T.

         Output := Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , Mask )

         Output := HB_URIGHT (Output , ol - 1 )

         Output := '-' + Output

         // Replace Text

         SetWindowText ( ControlByIndex( i ):Handle , Output )
         SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , HB_UAT('.',OutBuffer) + dc , HB_UAT('.',OutBuffer) + dc )

      ELSE

         SetWindowText ( ControlByIndex( i ):Handle , Transform ( GetNumFromText ( GetWindowText ( ControlByIndex( i ):Handle ) , i ) , Mask ) )
         SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , HB_UAT('.',OutBuffer) + dc , HB_UAT('.',OutBuffer) + dc )

      ENDIF

   ELSE

      IF pFlag == .T.
         ncp := HB_UAT ( '.' , GetWindowText ( ControlByIndex( i ):Handle ) )
         SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , ncp , ncp )

      ELSE

         // Restore Initial CaretPos

         IF BadEntry
            icp--
         ENDIF

         SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , icp , icp )

         // Skip Protected Characters

         FOR x := 1 To HMG_LEN (OutBuffer)

            CB := HB_USUBSTR ( OutBuffer , icp+x , 1 )
            CM := HB_USUBSTR ( Mask , icp+x , 1 )

            IF ( .NOT. HMG_ISDIGIT(CB) ) .AND. ( .NOT. HMG_ISALPHA(CB) ) .AND. ( ( .NOT. CB = ' ' ) .OR. ( CB == ' ' .AND. CM == ' ' ) )
               SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , icp+x , icp+x )
            ELSE
               EXIT
            ENDIF

         NEXT x

      ENDIF

   ENDIF

   RETURN
   // JK

   *------------------------------------------------------------------------------*

FUNCTION CharMaskTekstOK(cString,cMask)

   *------------------------------------------------------------------------------*

   LOCAL lPassed:=.f.,CB,CM,x

   FOR x := 1 To min(HMG_LEN(cString),HMG_LEN(cMask))

      CB := HB_USUBSTR ( cString , x , 1 )
      CM := HB_USUBSTR ( cMask , x , 1 )

      DO CASE

      CASE (CM) == '!'

         IF HMG_ISUPPER ( CB ) .OR. CB == ' '
            lPassed:=.t.
         ENDIF

      CASE (CM) == 'A'

         IF HMG_ISALPHA ( CB ) .OR. CB == ' '
            lPassed:=.t.
         ELSE
            lPassed:=.f.
            RETURN lPassed
         ENDIF

      CASE CM == '9'

         IF HMG_ISDIGIT ( CB ) .OR. CB == ' '
            lPassed:=.t.
         ELSE
            lPassed:=.f.
            RETURN lPassed
         ENDIF

      CASE CM == ' '

         IF CB == ' '
            lPassed:=.t.
         ELSE
            lPassed:=.f.
            RETURN lPassed
         ENDIF

      OTHERWISE

         lPassed:=.t.

      END CASE

   NEXT i

   RETURN lPassed
   *------------------------------------------------------------------------------*

PROCEDURE _DataTextBoxRefresh (i)

   *------------------------------------------------------------------------------*
   LOCAL Field

   IF ControlByIndex( i ):Type == "MASKEDTEXT"
      Field      := ControlByIndex( I ):CTRL017

   ELSE
      Field      := ControlByIndex( I ):CTRL007

   ENDIF

   IF Type ( Field ) == 'C'
      _SetValue ( '' , '' , RTRIM( &(Field)) , i )
   ELSE
      _SetValue ( '' , '' , &(Field) , i )
   ENDIF

   RETURN
   *------------------------------------------------------------------------------*

PROCEDURE _DataTextBoxSave ( ControlName , ParentForm)

   *------------------------------------------------------------------------------*
   LOCAL Field , i

   i := GetControlIndex ( ControlName , ParentForm)

   IF ControlByIndex( i ):Type == "MASKEDTEXT"
      Field      := ControlByIndex( I ):CTRL017

   ELSE
      Field      := ControlByIndex( I ):CTRL007

   ENDIF

   &(Field) := _GetValue ( Controlname , ParentForm )

   RETURN
   *------------------------------------------------------------------------------*

PROCEDURE ProcessNumText ( i )

   *------------------------------------------------------------------------------*
   LOCAL InBuffer , OutBuffer := '' , icp , x , CB , BackInBuffer , BadEntry := .F. , fnb

   // Store Initial CaretPos
   icp := HiWord ( SendMessage( ControlByIndex( i ):Handle , EM_GETSEL , 0 , 0 ) )

   // GET Current Content

   InBuffer := GetWindowText ( ControlByIndex( i ):Handle )

   BackInBuffer := InBuffer

   // Find First Non-Blank Position

   FOR x := 1 To HMG_LEN ( InBuffer )
      CB := HB_USUBSTR (InBuffer , x , 1 )
      IF CB != ' '
         fnb := x
         EXIT
      ENDIF
   NEXT x

   // Process Mask

   FOR x := 1 To HMG_LEN(InBuffer)

      CB := HB_USUBSTR(InBuffer , x , 1 )

      IF HMG_ISDIGIT ( CB ) .OR. ( CB == '-' .AND. x == fnb ) .OR. (CB == '.' .AND. HB_UAT (CB, OutBuffer) == 0)  .OR. ;
            (CB == ',' .AND. HB_UAT ('.', OutBuffer) == 0)   // MOL, April 2016

         OutBuffer := OutBuffer + CB
      ELSE
         BadEntry  := .t.
      ENDIF

   NEXT x

   IF BadEntry
      icp--
   ENDIF

   // JK Replace Content

   IF ! ( BackInBuffer == OutBuffer )
      SetWindowText ( ControlByIndex( i ):Handle , OutBuffer )
   ENDIF

   // Restore Initial CaretPos

   SendMessage( ControlByIndex( i ):Handle , EM_SETSEL , icp , icp )

   RETURN

   *------------------------------------------------------------------------------*

FUNCTION GETNumFromTextSP(Text,i)

   *------------------------------------------------------------------------------*
   LOCAL x , c , s

   s := ''

   FOR x := 1 To HMG_LEN ( Text )

      c := HB_USUBSTR(Text,x,1)

      IF c='0' .OR. c='1' .OR. c='2' .OR. c='3' .OR. c='4' .OR. c='5' .OR. c='6' .OR. c='7' .OR. c='8' .OR. c='9' .OR. c=',' .OR. c='-' .OR. c = '.'

         IF c == '.'
            c :=''
         ENDIF

         IF C == ','
            C:= '.'
         ENDIF

         s := s + c

      ENDIF

   NEXT x

   IF HB_ULEFT ( AllTrim(Text) , 1 ) == '(' .OR.  HB_URIGHT ( AllTrim(Text) , 2 ) == 'DB'
      s := '-' + s
   ENDIF

   s := Transform ( Val(s) , ControlByIndex( I ):CTRL009 )

   RETURN Val(s)
