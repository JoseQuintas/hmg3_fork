/*----------------------------------------------------------------------------
 HMG Source File --> h_EventCB.prg

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

#include "SET_COMPILE_HMG_UNICODE.ch"


MEMVAR _HMG_SYSDATA

*--------------------------------------------------------------------*
Function EventCompareParam (Param1, Param2)

   IF ValType (Param1) <> "U" .AND. ValType (Param2) <> "U"
      IF ValType (Param1) == "C" .AND. ValType (Param2) == "C"
         Return (ALLTRIM(Param1) == ALLTRIM(Param2))
      ELSE
         Return (Param1 == Param2)
      ENDIF
   ENDIF
Return .T.


*-------------------------------------------------------------------------------------*
Function EventCreate (cProcName, hWnd, nMsg)

LOCAL lStopEvent := .F., lProcessKeyboardMessage := .T., lProcessMouseMessage := .T.
LOCAL lProcessHMGWindowsMessage := .T., lProcessAllHookMessage := .F.
LOCAL i, nIndex := 0
   IF ValType( cProcName ) == "C"
      cProcName := AllTrim( cProcName )
   ENDIF
   FOR i := 1 TO EventCount()
      IF ValType (  oHmgApp():EventData [i] ) <> "A"
         nIndex := i
          oHmgApp():EventData [ nIndex ] := { cProcName, hWnd, nMsg, lStopEvent, lProcessKeyboardMessage, lProcessMouseMessage, lProcessHMGWindowsMessage, lProcessAllHookMessage, nIndex }
         EXIT
      ENDIF
   NEXT
   IF nIndex == 0
      nIndex := EventCount() + 1
      AADD ( oHmgApp():EventData, { cProcName, hWnd, nMsg, lStopEvent, lProcessKeyboardMessage, lProcessMouseMessage, lProcessHMGWindowsMessage, lProcessAllHookMessage, nIndex })
   ENDIF
Return nIndex


*----------------------------------------------------------------------------------------*
Function EventRemove (nIndex)

LOCAL i
   FOR i := 1 TO EventCount()
      IF ValType ( oHmgApp():EventData [i]) == "A" .AND.  oHmgApp():EventData [i] [ HMG_LEN( oHmgApp():EventData[1]) ] == nIndex   // July 2015
          oHmgApp():EventData [i] := NIL
         Return .T.
      ENDIF
   NEXT
Return .F.



*----------------------------------------------------------------------------------------*
Function EventRemoveAll()

   IF HMG_LEN ( oHmgApp():EventData) > 0
       oHmgApp():EventData := {}
      Return .T.
   ENDIF
Return .F.



*---------------------------------*
Function EventCount()

Return HMG_LEN ( oHmgApp():EventData)


*------------------------------------------------------------------------------------------------------------------------------*
Function EventProcess (hWnd, nMsg, wParam, lParam, IsKeyboardMessage, IsMouseMessage, IsHMGWindowsMessage, nHookID, nHookCode)

LOCAL nIndex
LOCAL cProcName, Ret := NIL
LOCAL lProcessMessage

   FOR nIndex = 1 TO EventCount()

      IF ValType ( oHmgApp():EventData [ nIndex ] ) <> "A"   // avoids processing the events removed
         LOOP
      ENDIF

      lProcessMessage := .F.
      IF EventProcessAllHookMessage (nIndex) == .T.
         lProcessMessage := .T.
      ELSEIF EventProcessHMGWindowsMessage (nIndex) == .T. .AND. IsHMGWindowsMessage == .T.
         lProcessMessage := .T.
      ELSEIF EventProcessKeyboardMessage   (nIndex) == .T. .AND. IsKeyboardMessage   == .T.
         lProcessMessage := .T.
      ELSEIF EventProcessMouseMessage      (nIndex) == .T. .AND. IsMouseMessage      == .T.
         lProcessMessage := .T.
      ENDIF

      IF lProcessMessage == .T.                              .AND. ;
         EventSTOP (nIndex) <> .T.                           .AND. ;
         EventCompareParam ( oHmgApp():EventData[nIndex][2], hWnd) .AND. ;
         EventCompareParam ( oHmgApp():EventData[nIndex][3], nMsg)

         EventSTOP (nIndex, .T.)   // avoids re-entry
         _PushEventInfo()
            oHmgApp():EventIsInProgress        := .T.
            oHmgApp():EventIsKeyboardMessage   := IsKeyboardMessage
            oHmgApp():EventIsMouseMessage      := IsMouseMessage
            oHmgApp():EventIsHMGWindowsMessage := IsHMGWindowsMessage
            oHmgApp():EventHookID              := nHookID
            oHmgApp():EventHookCode            := nHookCode
            oHmgApp():EventINDEX               := nIndex
            oHmgApp():EventHWND                := hWnd
            oHmgApp():EventMSG                 := nMsg
            oHmgApp():EventWPARAM              := wParam
            oHmgApp():EventLPARAM              := lParam
            oHmgApp():EventPROCNAME := EventGetPROCNAME (nIndex)

            IF ValType( oHmgApp():EventPROCNAME ) <> "C"
               Ret := EVAL( oHmgApp():EventPROCNAME )   // is codeblock
            ELSE
               cProcName := oHmgApp():EventPROCNAME
               IF HB_URIGHT(cProcName, 1) <> ")"
                  Ret := &cProcName()
               ELSE
                  Ret := &cProcName
               ENDIF
            ENDIF

            oHmgApp():EventIsInProgress        := .F.
            oHmgApp():EventIsKeyboardMessage   := .F.
            oHmgApp():EventIsMouseMessage      := .F.
            oHmgApp():EventIsHMGWindowsMessage := .F.
            oHmgApp():EventHookID              := -1
            oHmgApp():EventHookCode            := -1
            oHmgApp():EventINDEX               := 0
            oHmgApp():EventHWND                := 0
            oHmgApp():EventMSG                 := 0
            oHmgApp():EventWPARAM              := 0
            oHmgApp():EventLPARAM              := 0
            oHmgApp():EventPROCNAME            := ""
         _PopEventInfo()
         EventSTOP (nIndex, .F.)   // restore entry
         IF ValType (Ret) == "N"
            Return Ret
         ENDIF
      ENDIF
   NEXT
Return Ret


*--------------------------------------------------------------------*
Function EventHookID ()

   Return oHmgApp():EventHookID

Function EventHookCode ()

   Return oHmgApp():EventHookCode

Function EventINDEX ()

   Return oHmgApp():EventINDEX

Function EventPROCNAME ()

   Return oHmgApp():EventPROCNAME

Function EventHWND ()

   RETURN oHmgApp():EventHWND

Function EventMSG ()

   Return oHmgApp():EventMSG

Function EventWPARAM ()

   Return oHmgApp():EventWPARAM

Function EventLPARAM ()

   Return oHmgApp():EventLPARAM

*--------------------------------------------------------------------*

Function EventGetPROCNAME (nIndex)

   Return oHmgApp():EventData [nIndex] [1]
*--------------------------------------------------------------------*

Function EventGetHWND (nIndex)

   Return oHmgApp():EventData [nIndex] [2]
*--------------------------------------------------------------------*

Function EventGetMSG (nIndex)

   Return oHmgApp():EventData [nIndex] [3]
*--------------------------------------------------------------------*


Function EventSTOP (nIndex, lStop)

   LOCAL lRet := oHmgApp():EventData [nIndex] [4]

   IF ValType (lStop) == "L"
      oHmgApp():EventData [nIndex] [4] := lStop
   ENDIF

   Return lRet


Function EventProcessKeyboardMessage (nIndex, lProcess)

   LOCAL lRet := oHmgApp():_EventData [nIndex] [5]

   IF ValType (lProcess) == "L"
      oHmgApp():EventData [nIndex] [5] := lProcess
   ENDIF

   RETURN lRet
*--------------------------------------------------------------------*


FUNCTION EventProcessMouseMessage( nIndex, lProcess )

   LOCAL lRet := oHmgApp():EventData [nIndex] [6]

   IF ValType( lProcess ) == "L"
      oHmgApp():EventData[ nIndex ] [ 6 ] := lProcess
   ENDIF

   RETURN lRet
*--------------------------------------------------------------------*


FUNCTION EventProcessHMGWindowsMessage( nIndex, lProcess )

   LOCAL lRet := oHmgApp():EventData[ nIndex ] [ 7 ]

   IF ValType( lProcess ) == "L"
      oHmgApp():EventData[ nIndex ] [ 7 ] := lProcess
   ENDIF

   RETURN lRet
*--------------------------------------------------------------------*


FUNCTION EventProcessAllHookMessage( nIndex, lProcess )

   LOCAL lRet := oHmgApp():EventData[ nIndex ] [ 8 ]

   IF ValType( lProcess ) == "L"
      oHmgApp():EventData[ nIndex ] [ 8 ] := lProcess
   ENDIF

   RETURN lRet



//*****************************************************************************************************************//
//*   Events Complementary Functions                                                                              *//
//*****************************************************************************************************************//


* ListCalledFunctions ( [ nActivation ], [ @aInfo ] ) --> Return cInfo

* GetFormHandleByIndex    (nIndex) --> Return hWnd
* GetControlHandleByIndex (nIndex) --> Return hWnd

* GetFormNameByIndex    ( nFormIndex )    --> Return cName
* GetControlNameByIndex ( nControlIndex ) --> Return cName

* GetFormNameByHandle    (hWnd, @cFormName,    @cFormParentName) --> Return nFormIndex
* GetControlNameByHandle (hWnd, @cControlName, @cFormParentName) --> Return nControlIndex

* GetFormIndexByHandle    ( hWnd, [ @nFormSubIndex1 ],    [ @nFormSubIndex2 ]    ) --> Return nIndex
* GetControlIndexByHandle ( hWnd, [ @nControlSubIndex1 ], [ @nControlSubIndex2 ] ) --> Return nIndex

* GetFormParentHandleByIndex    ( nIndex ) --> Return hWnd
* GetControlParentHandleByIndex ( nIndex ) --> Return hWnd

// GetFormParentNameByIndex    ( nFormIndex )    --> Return cName
// GetControlParentNameByIndex ( nControlIndex ) --> Return cName

* GetFormTypeByIndex    ( nIndex ) --> Return cType
* GetControlTypeByIndex ( nIndex ) --> Return cType

* GetWindowInfoByHandle   (hWnd, [ @aInfo ], [ lShowType ] ) --> Return cInfo = "FormName1(FormType1).FormNameN(FormTypeN).ControlName(ControlType)"
* GetWindowInfoByHandleEx (hWnd, [ @aInfo ], [ lShowType ] ) --> Return cInfo = "FormName1(FormType1).FormNameN(FormTypeN).ControlName(ControlType)"

* GetFormInfoByHandle    (hWnd, [ aInfo ], [ lShowType ] ) --> Return cInfo = "FormName1(FormType1).FormNameN(FormTypeN)"
* GetControlInfoByHandle (hWnd, [ aInfo ], [ lShowType ] ) --> Return cInfo = "FormName1(FormType1).FormNameN(FormTypeN).ControlName(ControlType)"

* HMG_CompareHandle ( Handle1, Handle2, [ @nSubIndex1 ], [ @nSubIndex2 ] ) --> Return .T. or .F.

* IsFormDeletedByIndex    (nIndex) --> Return .T. or .F.
* IsControlDeletedByIndex (nIndex) --> Return .T. or .F.

* GetMainFormName   () --> Return cName
* GetMainFormHandle () --> Return hWnd


*------------------------------------------------------------------------------*
Function ListCalledFunctions (nActivation, aInfo)
*-----------------------------------------------------------------------------*
LOCAL cMsg := "", i:= 1
LOCAL nProcLine, cProcFile, cProcName
   aInfo := {}
   nActivation := IF (ValType(nActivation) <> "N", 1, nActivation)
   DO WHILE .NOT.(PROCNAME(nActivation) == "")
      cProcName := PROCNAME(nActivation)
      nProcLine := PROCLINE(nActivation)
      cProcFile := PROCFILE(nActivation)
      AADD (aInfo, {cProcName, nProcLine, cProcFile})
      cMsg := cMsg + aInfo[i,1] + "(" + HB_NTOS(aInfo[i,2]) + ") ("+ aInfo[i,3] + ")" + HB_OSNEWLINE()
      nActivation++
      i++
   ENDDO
Return cMsg


*-----------------------------------------------------------------------------*
Function GetFormHandleByIndex (nIndex)

   RETURN FormByIndex( nIndex ):nHandle


*-----------------------------------------------------------------------------*
FUNCTION GetControlHandleByIndex (nIndex)


   RETURN ControlByIndex( nIndex ):Handle   // aControlHandle

Function GetFormNameByIndex (nIndex)

   RETURN FormByIndex( nIndex ):Name


*-----------------------------------------------------------------------------*
Function GetControlNameByIndex (nIndex)


   RETURN ControlByIndex( nIndex ):Name   // aControlName


*-----------------------------------------------------------------------------*
Function GetFormIndexByHandle (hWnd, nFormSubIndex1, nFormSubIndex2)

   LOCAL i, FormHandle, nIndex := 0

   FOR i = 1 TO oHmgApp():FormCount()
      FormHandle :=  FormByIndex( I ):Handle
      IF HMG_CompareHandle (hWnd, FormHandle, @nFormSubIndex1, @nFormSubIndex2) == .T.
         nIndex := i
         EXIT
      ENDIF
   NEXT

   RETURN nIndex


*-----------------------------------------------------------------------------*
Function GetControlIndexByHandle (hWnd, nControlSubIndex1, nControlSubIndex2)
*-----------------------------------------------------------------------------*
LOCAL i, ControlHandle, nIndex := 0
   FOR i = 1 TO oHmgApp():ControlCount()   // aControlHandle
      ControlHandle :=  ControlByIndex( i ):Handle
      IF HMG_CompareHandle (hWnd, ControlHandle, @nControlSubIndex1, @nControlSubIndex2) == .T.
         nIndex := i
         EXIT
      ENDIF
   NEXT
Return nIndex


*-----------------------------------------------------------------------------*
Function GetFormParentHandleByIndex (nIndex)

RETURN FormByIndex( nIndex ):ParentHandle   // aFormParentHandle


*-----------------------------------------------------------------------------*
Function GetControlParentHandleByIndex (nIndex)

   RETURN ControlByIndex( nIndex ):ParentFormHandle   // aControlParentHandle


*-----------------------------------------------------------------------------*
Function GetFormTypeByIndex ( nIndex )

   LOCAL oForm

   IF nIndex != 0
      oForm  := FormByIndex( nIndex )
   ENDIF

RETURN iif( oForm == Nil .OR. oForm:Index == 0, "", oForm:Type )

*-----------------------------------------------------------------------------*
Function GetFormTypeByIndexEx (nIndex)

   LOCAL aType1 := { 'A',    'C',     'P',     'S',        'M',     'X'         }
   LOCAL aType2 := { "MAIN", "CHILD", "PANEL", "STANDARD", "MODAL", "SPLITCHILD" }
   LOCAL oForm := FormByIndex( nIndex )
   LOCAL nPos := ASCAN( aType1, oForm:Type )   // aFormType

   RETURN IIF( nPos > 0, aType2[ nPos ] , "<Unknown>" )
*-----------------------------------------------------------------------------*
FUNCTION GetControlTypeByIndex (nIndex)

   RETURN ControlByIndex( nIndex ):Type   // aControlType
*-----------------------------------------------------------------------------*
Function GetWindowInfoByHandle (hWnd, aInfo, lShowType)

LOCAL i, ControlParentHandle:=0, FormParentHandle:=0, cInfo := "", lFlagControl := .F.
LOCAL nIndexForm := 0, nIndexControl := 0, nInfoLen := 0, Text := "", nControlSubIndex2 := 0

   IF ValType (lShowType) <> "L"
      lShowType := .T.
   ENDIF

   aInfo := {}
   nIndexControl := GetControlIndexByHandle (hWnd, NIL, @nControlSubIndex2)
   WHILE nIndexControl > 0
      IF nIndexControl > 0
         lFlagControl := .T.
         Text := ALLTRIM(GetControlNameByIndex(nIndexControl)) + IF (lShowType, "("+ ALLTRIM(GetControlTypeByIndex (nIndexControl)) +")", "")
         AADD (aInfo, Text)
         ControlParentHandle := GetControlParentHandleByIndex (nIndexControl)
         IF ControlParentHandle <> 0
            nIndexControl := GetControlIndexByHandle (ControlParentHandle)
         ELSE
            nIndexControl := 0
         ENDIF
      ENDIF
   ENDDO

   IF lFlagControl == .T.
      IF ControlParentHandle <> 0
         nIndexForm := GetFormIndexByHandle (ControlParentHandle)
      ELSE
         nIndexForm := 0
      ENDIF
   ELSE
      nIndexForm := GetFormIndexByHandle (hWnd)
   ENDIF

   WHILE nIndexForm > 0
      IF nIndexForm > 0
         Text := ALLTRIM(GetFormNameByIndex(nIndexForm)) + IF (lShowType, "("+ ALLTRIM(GetFormTypeByIndexEx (nIndexForm)) +")", "")
         AADD (aInfo, Text)
         FormParentHandle := GetFormParentHandleByIndex (nIndexForm)
         IF FormParentHandle <> 0
            nIndexForm := GetFormIndexByHandle (FormParentHandle)
         ELSE
            nIndexForm := 0
         ENDIF
      ENDIF
   ENDDO

   nInfoLen := HMG_LEN(aInfo)
   FOR i = nInfoLen TO 1 STEP -1
      cInfo := cInfo + IF(i == nInfoLen,"",".") + aInfo [i]
   NEXT
Return cInfo


*-----------------------------------------------------------------------------*
Function GetWindowInfoByHandleEx (hWnd, aInfo, lShowType)

LOCAL i, ControlParentHandle:=0, FormParentHandle:=0, cInfo := "", lFlagControl := .F.
LOCAL nIndexForm := 0, nIndexControl := 0, nInfoLen := 0, Text := ""
LOCAL nControlSubIndex1 := 0, nControlSubIndex2 := 0

   IF ValType (lShowType) <> "L"
      lShowType := .T.
   ENDIF

   aInfo := {}
   nIndexControl := GetControlIndexByHandle (hWnd, @nControlSubIndex1, @nControlSubIndex2)
   IF nIndexControl > 0 .AND. nControlSubIndex1 > 0
      hWnd := hWnd [nControlSubIndex1]
   ENDIF

   WHILE nIndexControl > 0
      IF nIndexControl > 0
         lFlagControl := .T.
         Text := ALLTRIM(GetControlNameByIndex(nIndexControl)) + IF (lShowType, "("+ ALLTRIM(GetControlTypeByIndex (nIndexControl)) +")", "")
         AADD (aInfo, Text)
         ControlParentHandle := GetParent (hWnd)
         IF ControlParentHandle <> 0
            nIndexControl := GetControlIndexByHandle (ControlParentHandle)
            hWnd := ControlParentHandle
         ELSE
            nIndexControl := 0
         ENDIF
      ENDIF
   ENDDO

   IF lFlagControl == .T.
      IF ControlParentHandle <> 0
         nIndexForm := GetFormIndexByHandle (ControlParentHandle)
         hWnd := ControlParentHandle
      ELSE
         nIndexForm := 0
      ENDIF
   ELSE
      nIndexForm := GetFormIndexByHandle (hWnd)
   ENDIF

   WHILE nIndexForm > 0
      IF nIndexForm > 0
         Text := ALLTRIM(GetFormNameByIndex(nIndexForm)) + IF (lShowType, "("+ ALLTRIM(GetFormTypeByIndexEx (nIndexForm)) +")", "")
         AADD (aInfo, Text)
         FormParentHandle := GetParent (hWnd)
         IF FormParentHandle <> 0
            nIndexForm := GetFormIndexByHandle (FormParentHandle)
            hWnd := FormParentHandle
         ELSE
            nIndexForm := 0
         ENDIF
      ENDIF
   ENDDO

   nInfoLen := HMG_LEN(aInfo)
   FOR i = nInfoLen TO 1 STEP -1
      cInfo := cInfo + IF(i == nInfoLen,"",".") + aInfo [i]
   NEXT
Return cInfo


*-----------------------------------------------------------------------------*
Function HMG_CompareHandle (Handle1, Handle2, nSubIndex1, nSubIndex2)

LOCAL i,k
      nSubIndex1 := nSubIndex2 := 0

      IF ValType (Handle1) == "N" .AND. ValType (Handle2) == "N"
         IF Handle1 == Handle2
            Return .T.
         ENDIF

      ELSEIF ValType (Handle1) == "A" .AND. ValType (Handle2) == "N"
         FOR i = 1 TO HMG_LEN (Handle1)
            IF Handle1 [i] == Handle2
               nSubIndex1 := i
               Return .T.
            ENDIF
         NEXT

      ELSEIF ValType (Handle1) == "N" .AND. ValType (Handle2) == "A"
         FOR k = 1 TO HMG_LEN (Handle2)
            IF Handle1 == Handle2 [k]
               nSubIndex2 := k
               Return .T.
            ENDIF
         NEXT

      ELSEIF ValType (Handle1) == "A" .AND. ValType (Handle2) == "A"
         FOR i = 1 TO HMG_LEN (Handle1)
            FOR k = 1 TO HMG_LEN (Handle2)
               IF Handle1 [i] == Handle2 [k]
                  nSubIndex1 := i
                  nSubIndex2 := k
                  Return .T.
               ENDIF
            NEXT
         NEXT
      ENDIF
Return .F.


*-----------------------------------------------------------------------------*
Function GetFormInfoByHandle (hWnd, aInfo, lShowType)

LOCAL i, FormParentHandle:=0, cInfo := ""
LOCAL nIndexForm := 0, nInfoLen := 0, Text := ""

   IF ValType (lShowType) <> "L"
      lShowType := .T.
   ENDIF

   aInfo := {}
   nIndexForm := GetFormIndexByHandle (hWnd)
   WHILE nIndexForm > 0
      IF nIndexForm > 0
         Text := ALLTRIM(GetFormNameByIndex(nIndexForm)) + IF( lShowType, "("+ ALLTRIM(GetFormTypeByIndex (nIndexForm)) +")", "")
         AADD (aInfo, Text)
         FormParentHandle := GetFormParentHandleByIndex (nIndexForm)
         IF FormParentHandle <> 0
            nIndexForm := GetFormIndexByHandle (FormParentHandle)
         ELSE
            nIndexForm := 0
         ENDIF
      ENDIF
   ENDDO

   nInfoLen := HMG_LEN(aInfo)
   FOR i = nInfoLen TO 1 STEP -1
      cInfo := cInfo + IF(i == nInfoLen,"",".") + aInfo [i]
   NEXT
Return cInfo


*-----------------------------------------------------------------------------*
Function GetControlInfoByHandle (hWnd, aInfo, lShowType)

LOCAL i, ControlParentHandle:=0, FormParentHandle:=0, cInfo := "", lFlagControl := .F.
LOCAL nIndexForm := 0, nIndexControl := 0, nInfoLen := 0, Text := "", nControlSubIndex2 := 0

   IF ValType (lShowType) <> "L"
      lShowType := .T.
   ENDIF

   aInfo := {}
   nIndexControl := GetControlIndexByHandle (hWnd, NIL, @nControlSubIndex2)
   WHILE nIndexControl > 0
      IF nIndexControl > 0
         lFlagControl := .T.
         Text := ALLTRIM(GetControlNameByIndex(nIndexControl)) + IF( lShowType, "("+ ALLTRIM(GetControlTypeByIndex (nIndexControl)) +")", "")
         AADD (aInfo, Text)
         ControlParentHandle := GetControlParentHandleByIndex (nIndexControl)
         IF ControlParentHandle <> 0
            nIndexControl := GetControlIndexByHandle (ControlParentHandle)
         ELSE
            nIndexControl := 0
         ENDIF
      ENDIF
   ENDDO

   IF lFlagControl == .T.
      IF ControlParentHandle <> 0
         nIndexForm := GetFormIndexByHandle (ControlParentHandle)
      ELSE
         nIndexForm := 0
      ENDIF

      WHILE nIndexForm > 0
         IF nIndexForm > 0
            Text := ALLTRIM(GetFormNameByIndex(nIndexForm)) + IF( lShowType, "("+ ALLTRIM(GetFormTypeByIndex (nIndexForm)) +")", "")
            AADD (aInfo, Text)
            FormParentHandle := GetFormParentHandleByIndex (nIndexForm)
            IF FormParentHandle <> 0
               nIndexForm := GetFormIndexByHandle (FormParentHandle)
            ELSE
               nIndexForm := 0
            ENDIF
         ENDIF
      ENDDO
   ENDIF

   nInfoLen := HMG_LEN(aInfo)
   FOR i = nInfoLen TO 1 STEP -1
      cInfo := cInfo + IF(i == nInfoLen,"",".") + aInfo [i]
   NEXT
Return cInfo


*-----------------------------------------------------------------------------*
Function IsFormDeletedByIndex (nIndex)

Return FormByIndex( nIndex ):IsDeleted


*-----------------------------------------------------------------------------*
Function IsControlDeletedByIndex (nIndex)

Return ControlByIndex( NINDEX ):IsDeleted   // _HMG_aControlDeleted


*-----------------------------------------------------------------------------*
FUNCTION GetMainFormName ()

  IF oHmgApp():MainFormIndex > 0
    RETURN GetFormNameByIndex ( oHmgApp():MainFormIndex )
  ENDIF

   RETURN ""

*-----------------------------------------------------------------------------*
FUNCTION GetMainFormHandle ()

  IF oHmgApp():MainFormIndex > 0
     RETURN GetFormHandleByIndex( oHmgApp():MainFormIndex )
  ENDIF

   RETURN 0

*-----------------------------------------------------------------------------*
Function GetFormNameByHandle( hWnd, cFormName, cFormParentName )

   LOCAL nIndexFormParent, FormParentHandle
   LOCAL nIndexForm := GetFormIndexByHandle( hWnd )

   cFormName := cFormParentName := ""
   IF nIndexForm > 0
      cFormName := GetFormNameByIndex( nIndexForm )
      FormParentHandle := GetFormParentHandleByIndex( nIndexForm )
      IF FormParentHandle <> 0
         nIndexFormParent := GetFormIndexByHandle( FormParentHandle )
         cFormParentName  := GetFormNameByIndex( nIndexFormParent )
      ENDIF
   ENDIF

   RETURN nIndexForm


*-----------------------------------------------------------------------------*
Function GetControlNameByHandle (hWnd, cControlName, cFormParentName)
*-----------------------------------------------------------------------------*
LOCAL nIndexControlParent, ControlParentHandle
LOCAL nIndexControl := GetControlIndexByHandle (hWnd)
   cControlName := cFormParentName := ""
   IF nIndexControl > 0
      cControlName := GetControlNameByIndex (nIndexControl)
      ControlParentHandle := GetControlParentHandleByIndex (nIndexControl)
      IF ControlParentHandle <> 0
         nIndexControlParent := GetFormIndexByHandle (ControlParentHandle)
         cFormParentName     := GetFormNameByIndex (nIndexControlParent)
      ENDIF
   ENDIF
Return nIndexControl



//*****************************************************************************************************************************

/*
#xtranslate CHECK TYPE [ <lSoft: SOFT> ] <var> AS <type> [, <varN> AS <typeN> ] => ;
            HMG_CheckType( <.lSoft.>, { <"type"> , ValType( <var> ), <"var"> } [, { <"typeN"> , ValType( <varN> ), <"varN"> } ] )
*/

PROCEDURE HMG_CheckType( lSoft, ... )
LOCAL i, j
LOCAL aParams, aData
LOCAL aType := {;
         { "ARRAY"      , "A" } ,;
         { "BLOCK"      , "B" } ,;
         { "CHARACTER"  , "C" } ,;
         { "DATE"       , "D" } ,;
         { "HASH"       , "H" } ,;
         { "LOGICAL"    , "L" } ,;
         { "NIL"        , "U" } ,;
         { "NUMERIC"    , "N" } ,;
         { "MEMO"       , "M" } ,;
         { "POINTER"    , "P" } ,;
         { "SYMBOL"     , "S" } ,;
         { "TIMESTAMP"  , "T" } ,;
         { "OBJECT"     , "O" } ,;
         { "USUAL"      , ""  }}

   aParams := hb_aParams()

   hb_ADEL( aParams, 1, .T. )   // Remove lSoft param of the array

   FOR EACH aData IN aParams

      IF HMG_UPPER( AllTrim( aData[ 1 ] ) ) <> "USUAL"

         IF .NOT. ( lSoft == .T. .AND. HMG_UPPER( AllTrim( aData[ 2 ] ) ) == "U" )

            // aData := { cTypeDef, cValType, cVarName }
            // aType := { cTypeDef, cValType }

            i := ASCAN( aType, { | x | HMG_UPPER( AllTrim( x[ 1 ] ) ) == HMG_UPPER( AllTrim( aData[ 1 ] ) ) } )

            IF i == 0 .OR. HMG_UPPER( AllTrim( aType[ i ][ 2 ] ) ) <> HMG_UPPER( AllTrim( aData[ 2 ] ) )

               j := ASCAN( aType, { | x | HMG_UPPER( AllTrim( x[ 2 ] ) ) == HMG_UPPER( AllTrim( aData[ 2 ] ) ) } )

               MsgHMGError( "CHECK TYPE ( Param # "+ hb_NtoS( aData:__enumindex() ) + " ) : " + AllTrim( aData[ 3 ] ) + " is declared as " + HMG_UPPER( AllTrim( aData[ 1 ] ) ) + " but it is of type " + HMG_UPPER( AllTrim( aType[ j ][ 1 ] ) ) + ". Program terminated", "HMG Error" )

            ENDIF

         ENDIF

      ENDIF

   NEXT
RETURN


//*****************************************************************************************************************************


*-----------------------------------------------*
Function HMG_GetAllSubMenu (hMenu)

LOCAL aMenuInfo:={}, hSubMenu
LOCAL nParent:=0, n1:=0, n2:=0, nItem:=0
// nParent := parent position in array
   IF IsMenu (hMenu)
      WHILE .T.
         FOR nItem = 0 TO GetMenuItemCount (hMenu) - 1
            hSubMenu := GetSubMenu (hMenu, nItem)
            IF IsMenu (hSubMenu)
               AADD (aMenuInfo, {hSubMenu, nParent, nItem})
               n1 ++
            ENDIF
         NEXT
         n2 ++
         nParent++
         IF n2 > n1
            EXIT
         ELSE
            hMenu := aMenuInfo [n2] [1]
         ENDIF
      ENDDO
   ENDIF
Return aMenuInfo


*-----------------------------------------------------------------------------*
Function HMG_GetSubMenuItemFromPoint (hWnd, aMenuInfo, x_scr, y_scr, aInfo)

LOCAL nPos, i, cText:="", hMenu, nIndex, nParent
// nParent := parent position in array
   aInfo := {}
   FOR i = 1 TO HMG_LEN (aMenuInfo)
      hMenu := aMenuInfo [i] [1]
      nPos := MenuItemFromPoint (hWnd, hMenu, x_scr, y_scr)
      IF nPos >= 0
         cText   := HB_NTOS (nPos+1)
         AADD (aInfo, nPos+1)
         nParent := aMenuInfo [i] [2]
         IF nParent == 0
            cText := HB_NTOS (aMenuInfo [i] [3] + 1) + ":" + cText
            AADD (aInfo, (aMenuInfo [i] [3] + 1))
            Return cText
         ENDIF

         nIndex  := i
         WHILE nParent > 0
            cText := HB_NTOS (aMenuInfo [nIndex] [3] + 1) + ":" + cText
            AADD (aInfo, (aMenuInfo [nIndex] [3] + 1))
            nIndex  := nParent
            nParent := aMenuInfo [nIndex] [2]
         ENDDO
         IF nParent == 0
            cText := HB_NTOS (aMenuInfo [nIndex] [3] + 1) + ":" + cText
            AADD (aInfo, (aMenuInfo [nIndex] [3] + 1))
            Return cText
         ENDIF

         EXIT
      ENDIF
   NEXT
Return cText



//*****************************************************************************************************************************



*--------------------------------------------------------------------*
FUNCTION GetSplitChildWindowHandle ( cFormName, cParentForm )

LOCAL hWnd := GetFormHandle (cParentForm), oForm

   FOR EACH oForm IN oHmgApp():AllForms()
       IF oForm:Name == cFormName .AND. ;
          oForm:Type ==  'X' .AND. oForm:ParentHandle == hWnd
           RETURN oForm:Handle
       ENDIF
   NEXT

RETURN 0


*---------------------------------------------*
Function GetSplitBoxHandle (cParentForm)

LOCAL i := GetFormIndex (cParentForm)
   if i > 0 .AND. FormByIndex( I ):FORM087 <> 0
      Return FormByIndex( I ):FORM087
   EndIf
Return 0


*---------------------------------------------*
Function GetSplitBoxRect (cParentForm)

LOCAL hWnd, aPos := {0,0,0,0}
   hWnd := GetSplitBoxHandle (cParentForm)
   GetWindowRect (hWnd, aPos)
Return aPos   // return array --> { Left, Top, Right, Bottom }


*---------------------------------------------*
Function GetSplitBoxWIDTH (cParentForm)

LOCAL hWnd, aPos := {0,0,0,0}
   hWnd := GetSplitBoxHandle (cParentForm)
   GetWindowRect (hWnd, aPos)
Return (aPos[3] - aPos[1])


*---------------------------------------------*
Function GetSplitBoxHEIGHT (cParentForm)

LOCAL hWnd, aPos := {0,0,0,0}
   hWnd := GetSplitBoxHandle (cParentForm)
   GetWindowRect (hWnd, aPos)
Return (aPos[4] - aPos[2])
