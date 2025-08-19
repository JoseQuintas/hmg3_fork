/*----------------------------------------------------------------------------
HMG Source File --> h_TimePicker.prg

Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

mail: <srvet@adinet.com.uy>
blog: http://srvet.blogspot.com

Permission to use, copy, modify, distribute and sell this software
and its documentation for any purpose is hereby granted without fee,
provided that the above copyright notice appear in all copies and
that both that copyright notice and this permission notice appear
in supporting documentation.
It is provided "as is" without express or implied warranty.

----------------------------------------------------------------------------*/

#include "hmg.ch"
#include "common.ch"

*-----------------------------------------------------------------------------*

FUNCTION _DefineTimePick ( ControlName, ParentForm, x, y, w, h, cValue, ;
      fontname, fontsize, tooltip, change, lostfocus, ;
      gotfocus, shownone, HelpId, invisible, notabstop, ;
      bold, italic, underline, strikeout , Field, Enter, cTimeFormat)
   *-----------------------------------------------------------------------------*
   LOCAL cParentForm , mVar , k := 0, oControl
   LOCAL ControlHandle
   LOCAL FontHandle
   LOCAL cParentTabName
   LOCAL TimeValue24h
   LOCAL WorkArea

   DEFAULT cValue      TO ""
   DEFAULT cTimeFormat TO _TIMELONG24H
   DEFAULT w           TO 110
   DEFAULT h           TO 24
   DEFAULT change      TO ""
   DEFAULT lostfocus   TO ""
   DEFAULT gotfocus    TO ""
   DEFAULT invisible   TO FALSE
   DEFAULT notabstop   TO FALSE
   DEFAULT shownone    TO FALSE

   IF ValType ( Field ) != 'U'
      IF HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      ELSE
         WORKAREA := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
         IF Select (WorkArea) != 0
            cValue := &(Field)
         ENDIF
      ENDIF
   ENDIF

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
         x := x + oHmgApp():APP334 [ oHmgApp():FrameLevel ]
         y := y + oHmgApp():APP333 [ oHmgApp():FrameLevel ]
         ParentForm := oHmgApp():APP332 [ oHmgApp():FrameLevel ]
         cParentTabName := oHmgApp():APP225
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program terminated" )
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

   //------------------------------------------------------------------------------------------------//

   ControlHandle := InitTimePick (ParentForm, x, y, w, h, shownone, invisible, notabstop)

   IF DateTime_SetFormat (ControlHandle, cTimeFormat) == .F.
      MsgHMGError ( "Time Picker Control: " + ControlName + " Of " + ParentForm + ": Invalid Time Format" )
   ENDIF

   IF .NOT. EMPTY (cValue)
      TimeValue24h := HMG_TimeToValue (cValue)
      SetTimePick ( ControlHandle, TimeValue24h [1], TimeValue24h [2], TimeValue24h [3])
   ENDIF

   //------------------------------------------------------------------------------------------------//

   IF valtype(fontname) != "U" .AND. valtype(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   ELSE
      FontHandle := _SetFont (ControlHandle,oHmgApp():APP342,oHmgApp():APP343,bold,italic,underline,strikeout)
   ENDIF

   IF oHmgApp():BeginTabActive = .T.
      aAdd ( oHmgApp():APP142 , Controlhandle )
   ENDIF

   IF valtype(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   ENDIF

   k := _GetControlFree()

   PUBLIC &mVar. := k

   oControl := ControlByIndex( K )

   WITH OBJECT oControl
      :Type :=  "TIMEPICK"
      :Name :=  ControlName
      :Handle :=  ControlHandle
      :ParentFormHandle :=  ParentForm
      :CTRL005 :=  0
      :CTRL006 :=  Enter
      :CTRL007 :=  Field
      :CTRL008 :=  Nil
      :CTRL009 :=  cTimeFormat
      :CTRL010 :=  lostfocus
      :CTRL011 :=  gotfocus
      :CTRL012 :=  change
      :IsDeleted :=  .F.
      :CTRL014 :=  Nil
      :CTRL015 :=  Nil
      :CTRL016 :=  ""
      :CTRL017 :=  {}
      :CTRL018 :=  y
      :CTRL019 :=  x
      :CTRL020 :=  w
      :CTRL021 :=  h
      :CTRL022 :=  0
      :CTRL023 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP333 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL024 :=  iif ( oHmgApp():FrameLevel > 0 ,oHmgApp():APP334 [ oHmgApp():FrameLevel ] , -1 )
      :CTRL025 :=  ""
      :CTRL026 :=  0
      :CTRL027 :=  fontname
      :CTRL028 :=  fontsize
      :CTRL029 :=  {bold,italic,underline,strikeout}
      :CTRL030 :=  tooltip
      :CTRL031 :=  cParentTabName
      :CTRL032 :=  0
      :CTRL033 :=  ''
      :CTRL034 :=  iif (invisible,FALSE,TRUE)
      :CTRL035 :=  HelpId
      :CTRL036 :=  FontHandle
      :CTRL037 :=  0
      :CTRL038 :=  .T.
      :CTRL039 :=  0
      :CTRL040 :=  { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }
   ENDWITH

   RETURN Nil

PROCEDURE _DataTimePickerRefresh (i)

   LOCAL Field
   Field := ControlByIndex( I ):CTRL007

   _SetValue ( '' , '' , &Field , i )

   RETURN

PROCEDURE _DataTimePickerSave (ControlName, ParentForm)

   LOCAL Field , i

   i := GetControlIndex ( ControlName , ParentForm)
   Field := ControlByIndex( I ):CTRL007

   REPLACE &Field WITH _GetValue ( Controlname , ParentForm )

   RETURN

   //*****************************************************************************************

   //---------------------------------------------------

FUNCTION HMG_GetNextTimeDigits (cTime, nValue)

   //---------------------------------------------------
   LOCAL cDigit, nPos

   cTime := ALLTRIM (cTime)
   nPos  := HB_UAT (":",cTime)
   IF nPos > 1
      cDigit := HB_USUBSTR (cTime, 1, nPos-1)
      IF TYPE (cDigit) == "N"
         nValue := VAL (cDigit)
         cTime  := HB_USUBSTR (cTime, nPos+1)
      ELSE
         nValue := -100
         cTime  := ""
      ENDIF
   ELSE
      nValue := -100
      cTime  := ""
   ENDIF
   // MsgDebug (cDigit, nValue, cTime)

   RETURN cTime

   //------------------------------------------

FUNCTION HMG_GetTimeAMPM (cTime)   // Return "am", "pm" or "", IF cTime is passed by reference and exist "am" or "pm" in cTime : "am|pm" is removed from cTime.

   //------------------------------------------
   LOCAL nPos, nPosAM, nPosPM, cAMPM

   IF ValType (cTime) == "C"
      cTime  := HMG_LOWER (AllTrim(cTime))
      nPosAM := HB_UTF8RAT ("am", cTime)
      nPosPM := HB_UTF8RAT ("pm", cTime)
      IF nPosAM <> 0 .AND. nPosPM <> 0
         MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
      ELSEIF nPosAM <> 0 .OR. nPosPM <> 0
         nPos  := MAX (nPosAM, nPosPM)
         cAMPM := HB_USUBSTR (cTime, nPos, 2)
         cTime := ALLTRIM (HB_USUBSTR (cTime, 1, nPos-1))
      ELSE
         cAMPM := ""
      ENDIF
   ELSE
      MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
   ENDIF

   RETURN cAMPM

   //------------------------------------------

FUNCTION HMG_IsTimeAMPM (cTime) // Return .T. IF cTime contains the substring "am" or "pm"

   //------------------------------------------
   LOCAL cAMPM := HMG_GetTimeAMPM (cTime)

   IF HMG_LOWER(cAMPM) == "am" .OR. HMG_LOWER(cAMPM) == "pm"
      RETURN .T.
   ENDIF

   RETURN .F.

   //------------------------------------------

FUNCTION HMG_TimeToValue (cTime)

   //------------------------------------------
   LOCAL cAMPM
   LOCAL nHour, nMinute, nSecond

   IF ValType (cTime) == "C"
      cAMPM := HMG_GetTimeAMPM (@cTime)   //  IF exist "am"|"pm" remove of cTime and return cAMPM or ""
      cTime := cTime  + ":00:"
      cTime := HMG_GetNextTimeDigits (cTime, @nHour)
      cTime := HMG_GetNextTimeDigits (cTime, @nMinute)
      cTime := HMG_GetNextTimeDigits (cTime, @nSecond)

      IF (nHour == 12) .AND. (HMG_LOWER(cAMPM) == "am")
         nHour := 0
      ENDIF
      IF (nHour < 12) .AND. HMG_LOWER(cAMPM) == "pm"
         nHour := nHour + 12
      ENDIF

      // MsgDebug (nHour, nMinute, nSecond, cAMPM)
      IF (nHour < 0 .OR. nHour > 23) .OR. (nMinute < 0 .OR. nMinute > 59) .OR. (nSecond < 0 .OR. nSecond > 59)
         MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
      ENDIF
   ELSE
      MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
   ENDIF

   RETURN {nHour, nMinute, nSecond}

   //-----------------------------------------------

FUNCTION HMG_ValueToTime (aValue, cTimeFormat)

   //-----------------------------------------------
   LOCAL cTime, cAMPM, nHour, nMinute, nSecond

   DEFAULT cTimeFormat TO _TIMELONG24H
   nHour   := aValue [1]
   nMinute := aValue [2]
   nSecond := aValue [3]

   IF (nHour < 0 .OR. nHour > 23) .OR. (nMinute < 0 .OR. nMinute > 59) .OR. (nSecond < 0 .OR. nSecond > 59)
      MsgHMGError ("Invalid Time Value. Program Terminated")
   ENDIF

   DO CASE
   CASE AllTrim(cTimeFormat) == AllTrim( _TIMELONG24H )
      cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2) +":"+ STRZERO (nSecond, 2)

   CASE AllTrim(cTimeFormat) == AllTrim( _TIMESHORT24H )
      cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2)

   CASE AllTrim(cTimeFormat) == AllTrim( _TIMELONG12H )
      IF     nHour == 0
         cAMPM := "am"
         nHour := 12
      ELSEIF nHour > 0 .AND. nHour < 12
         cAMPM := "am"
      ELSEIF nHour == 12
         cAMPM := "pm"
      ELSEIF nHour > 12
         cAMPM := "pm"
         nHour := nHour - 12
      ENDIF
      cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2) +":"+ STRZERO (nSecond, 2) +" "+ cAMPM

   CASE AllTrim(cTimeFormat) == AllTrim( _TIMESHORT12H )
      IF     nHour == 0
         cAMPM := "am"
         nHour := 12
      ELSEIF nHour > 0 .AND. nHour < 12
         cAMPM := "am"
      ELSEIF nHour == 12
         cAMPM := "pm"
      ELSEIF nHour > 12
         cAMPM := "pm"
         nHour := nHour - 12
      ENDIF
      cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2) +" "+ cAMPM

   OTHERWISE
      MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
   ENDCASE

   RETURN cTime

   //------------------------------------------------

FUNCTION HMG_TimeToTime (cTime, cNewTimeFormat)

   //------------------------------------------------
   LOCAL aValue   := HMG_TimeToValue (cTime)
   LOCAL cNewTime := HMG_ValueToTime (aValue, cNewTimeFormat)

   RETURN cNewTime
