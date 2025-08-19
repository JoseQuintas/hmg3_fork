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

#include "SET_COMPILE_HMG_UNICODE.ch"   // UNICODE

MEMVAR _HMG_SYSDATA

#include "hmg.ch"

#define ABM_CRLF                HB_OsNewLine()

FUNCTION HMG_SupportUnicode()   // This FUNCTION is more intuitive that HMG_IsUnicode()

   RETURN HMG_IsUnicode()

FUNCTION HMG_IsCurrentCodePageUnicode()   // New FUNCTION HMG-UNICODE

   RETURN (SET(_SET_CODEPAGE) == "UTF8")

FUNCTION HMG_IsNotDefParam ( xDefineParam , xDefault )

   LOCAL xRet

   IF PCOUNT() == 1
      xRet := xDefault
   ELSE
      xRet := xDefineParam
   ENDIF

   RETURN xRet

FUNCTION Init()

   LOCAL aWinver, nIndex
   LOCAL COLOR_HIGHLIGHT      := 13
   LOCAL COLOR_HIGHLIGHTTEXT  := 14

   MEMVAR _HMG_MsgDebugTitle
   MEMVAR _HMG_MsgDebugType
   MEMVAR _HMG_MsgDebugTimeOut

   MEMVAR _HMG_InitCodepage

   //MEMVAR _HMG_StopWindowEventProcedure             // oForm()
   //MEMVAR _HMG_StopControlEventProcedure
   MEMVAR _HMG_SetControlContextMenu

   MEMVAR _HMG_MsgIDFindDlg
   MEMVAR _HMG_FindReplaceOnAction

   MEMVAR _HMG_CharRange_Min
   MEMVAR _HMG_CharRange_Max

   PUBLIC _HMG_MsgDebugTitle   := NIL
   PUBLIC _HMG_MsgDebugType    := NIL
   PUBLIC _HMG_MsgDebugTimeOut := NIL

   //PUBLIC _HMG_StopWindowEventProcedure         := {}    //ADD
   //PUBLIC _HMG_StopControlEventProcedure        := {}    //ADD
   PUBLIC _HMG_SetControlContextMenu            := .T.   //ADD

   PUBLIC _HMG_MsgIDFindDlg                     := 0           //ADD
   PUBLIC _HMG_FindReplaceOnAction              := {|| NIL }   //ADD

   PUBLIC _HMG_CharRange_Min            := 0   //ADD
   PUBLIC _HMG_CharRange_Max            := 0   //ADD

   PUBLIC _HMG_InitCodepage := SET (_SET_CODEPAGE)

#ifdef COMPILE_HMG_UNICODE
   SET CODEPAGE TO UNICODE
#endif

   //------------------------------------------------------------------------
   // Set Default: Title, TypeIconButton and TimeOut in MsgDebug() function
   //------------------------------------------------------------------------
   MsgDebugTitle()
   MsgDebugType()
   MsgDebugTimeOut()
   //------------------------------------------------------------------------

   aWinver := WindowsVersion()

   * _HMG_SYSDATA Reference ;)

   * CTRL001 CONTROL:Type  -> Control Data
   * CTRL002 CONTROL:Name  -> Control Data
   * CTRL003 CONTROL:Handle  -> Control Data
   * CTRL004 CONTROL:ParentHandle  -> Control Data
   * CTRL005 -> Control Data
   * CTRL006 -> Control Data
   * CTRL007 -> Control Data
   * CTRL008 -> Control Data
   * CTRL009 -> Control Data
   * CTRL010 -> Control Data
   * CTRL011 -> Control Data
   * CTRL012 -> Control Data
   * CTRL013 -> Control Data
   * CTRL014 -> Control Data
   * CTRL015 -> Control Data
   * CTRL016 -> Control Data
   * CTRL017 -> Control Data
   * CTRL018 -> Control Data
   * CTRL019 -> Control Data
   * CTRL020 -> Control Data
   * CTRL021 -> Control Data
   * CTRL022 -> Control Data
   * CTRL023 -> Control Data
   * CTRL024 -> Control Data
   * CTRL025 -> Control Data
   * CTRL026 ] -> Control Data
   * CTRL027 ] -> Control Data
   * CTRL028 ] -> Control Data
   * CTRL029 ] -> Control Data
   * CTRL030 ] -> Control Data
   * CTRL031 ] -> Control Data
   * CTRL032 ] -> Control Data
   * CTRL033 ] -> Control Data
   * CTRL034 ] -> Control Data
   * CTRL035 ] -> Control Data
   * CTRL036 ] -> Control Data
   * CTRL037 ] -> Control Data
   * CTRL038 ] -> Control Data
   * CTRL039 ] -> Control Data
   * CTRL040 ] -> Control Data

   * CTRL041 ] -> _RESERVED_   // array --> { OnKeyControlEventProc, OnMouseControlEventProc, ToolTip_CustomDrawData }
   * APP042 ] -> _RESERVED_
   * APP043 ] -> _RESERVED_
   * APP044 ] -> _RESERVED_
   * APP045 ] -> _RESERVED_
   * APP046 ] -> _RESERVED_
   * APP047 ] -> _RESERVED_
   * APP048 ] -> _RESERVED_
   * APP049 ] -> _RESERVED_
   * APP050 ] -> _RESERVED_
   * APP051 ] -> _RESERVED_
   * APP052 ] -> Drag ListBox 'ListId'
   * APP053 ] -> Drag ListBox 'DragItem'
   * APP054 ] -> Drag ListBox Notfycation message number
   * APP055 ] -> ToolTip Style
   * APP056 ] -> ToolTip BackColor
   * APP057 ] -> Tooltip ForeColor
   * APP058 ] -> _RESERVED_
   * APP059 ] -> _RESERVED_
   * APP060 ] -> Custom Event Procedures Array
   * APP061 ] -> Custom Properties Procedures Array
   * APP062 ] -> Custom Methods Procedures Array
   * APP063 ] -> User Component Process Flag
   * APP064 ] -> _RESERVED_
   * FORM065 :IsDeleted 065 ] -> _HMG_aFormDeleted
   * FORM066 :Name 066 ] -> _HMG_aFormNames
   * FORM067 :Handle 067 ] -> _HMG_aFormHandles
   * FORM068 068 ] -> _HMG_aFormActive
   * FORM069 ] -> _HMG_aFormType
   * FORM070 ] -> _HMG_aFormParentHandle
   * FORM071 FORM:ReleaseProcedure 71  -> _HMG_aFormReleaseProcedure
   * FORM072 FORM:InitProcedure 72 -> _HMG_aFormInitProcedure
   * FORM073 FORM:TooltipHandle 73 -> _HMG_aFormToolTipHandle
   * FORM074 FORM:ContextMenuHandle -> _HMG_aFormContextMenuHandle
   * FORM075 -> _HMG_aFormMouseDragProcedure
   * FORM076 -> _HMG_aFormSizeProcedure
   * FORM077 -> _HMG_aFormClickProcedure
   * FORM078 -> _HMG_aFormMouseMoveProcedure
   * FORM079 -> _HMG_aFormBkColor
   * FORM080 -> _HMG_aFormPaintProcedure
   * FORM081 -> _HMG_aFormNoShow
   * FORM082 -> _HMG_aFormNotifyIconName
   * FORM083 -> _HMG_aFormNotifyIconToolTip
   * FORM084 -> _HMG_aFormNotifyIconLeftClick
   * FORM085 -> _HMG_aFormGotFocusProcedure
   * FORM086 -> _HMG_aFormLostFocusProcedure
   * FORM087 -> _HMG_aFormReBarHandle
   * FORM088 -> _HMG_aFormNotifyMenuHandle
   * FORM089 -> _HMG_aFormBrowseList
   * FORM090 -> _HMG_aFormSplitChildList
   * FORM091 -> _HMG_aFormVirtualHeight
   * FORM092 -> _HMG_aFormVirtualWidth
   * FORM093 -> _HMG_aFormFocused
   * FORM094 -> _HMG_aFormScrollUp
   * FORM095 -> _HMG_aFormScrollDown
   * FORM096 -> _HMG_aFormScrollLeft
   * FORM097 -> _HMG_aFormScrollRight
   * FORM098 -> _HMG_aFormHScrollBox
   * FORM099 -> _HMG_aFormVScrollBox
   * FORM100 -> _HMG_aFormBrushHandle
   * FORM101 -> _HMG_aFormFocusedControl
   * FORM102 FORM:GraphTasks 102 -> _HMG_aFormGraphTasks
   * FORM103 -> _HMG_aFormMaximizeProcedure
   * FORM104 -> _HMG_aFormMinimizeProcedure
   * FORM105 FORM:AutoRelease 105  -> _HMG_aFormAutoRelease
   * FORM106 -> _HMG_aFormInteractiveCloseProcedure
   * FORM107 -> _HMG_aFormActivateId
   * FORM108 -> Coordinates For Window Graph
   * APP109 -> Current Alternate Modal Parent
   * APP110 -> Current Report Image FromRow
   * APP111 -> Current Report Image FromCol
   * APP112 -> Current Report Image ToRow
   * APP113 -> Current Report Image ToCol
   * APP114 -> Current Report Image PenWidth
   * APP115 -> Current Report Image PenColor
   * APP116 -> Current Report Text Expression
   * APP117 -> Current Report Page Number
   * APP118 -> Current Report Paper Width (User PaperSize)
   * APP119 -> Current Report Paper Length (User paperSize)
   * APP120 -> Current Report Group Count
   * APP121 -> Current Report Group Header Array
   * APP122 -> Current Report Group Footer Array
   * APP123 -> Current Report Group Footer Band Height
   * APP124 -> Current Report Group Header Band Height
   * APP125 -> Current Report Group Expression
   * APP126 -> Current Report Summary Array
   * APP127 -> Current Report Summary Band Height
   * APP128 -> _HMG_aLangButton
   * APP129 -> _HMG_aLangLabel
   * APP130 -> _HMG_aLangUser
   * APP131 -> _HMG_aABMLangUser
   * APP132 -> _HMG_aABMLangLabel
   * APP133 -> _HMG_aABMLangButton
   * APP134 -> _HMG_aABMLangError
   * APP135 -> _HMG_BRWLangButton
   * APP136 -> _HMG_BRWLangError
   * APP137 -> _HMG_BRWLangMessage
   * APP138 -> _HMG_aTreeMap
   * APP139 -> _HMG_aTreeIdMap
   * APP140 -> _HMG_ActiveTabFullPageMap
   * APP141 -> _HMG_ActiveTabCaptions
   * APP142 -> _HMG_ActiveTabCurrentPageMap
   * APP143 -> _hmg_CurrentStatusBarCaptions
   * APP144 -> _hmg_CurrentStatusBarWidths
   * APP145 -> _hmg_CurrentStatusBarImages
   * APP146 -> _hmg_CurrentStatusBarStyles
   * APP147 -> _hmg_CurrentStatusBarToolTips
   * APP148 -> _hmg_CurrentStatusBarActions
   * APP149 -> Current Report HTML Code
   * APP150 -> Current Report PDF File Generator Flag
   * APP151 -> Current Report PDF Object Variable
   * APP152 -> Current Report Header Band Height
   * APP153 -> Current Report Detail Band Height
   * APP154 -> Current Report Footer Band Height
   * APP155 -> Current Report Orientation
   * APP156 -> Current Report Paper Size
   * APP157 -> Current Report Footer Array
   * APP158 -> Current Report Detail Array
   * APP159 -> Current Report Layout Array
   * APP160 -> Current Report Header Array
   * APP161 -> Current Report Section
   * APP162 -> Current Report Name
   * APP163 -> Current Report HTML File Generator Flag
   * APP164 -> _HMG_MainIndex
   * APP165 -> _hmg_CurrentStatusBarFontSize
   * APP166 -> _hmg_UserWindowHandle ActiveWindowHandle
   * APP167 -> _hmg_activemodalhandle
   * APP168 -> _HMG_nTopic
   * APP169 -> _HMG_xContextMenuButtonIndex
   * APP170 -> _HMG_nMet
   * APP171 -> _HMG_ActiveSplitChildIndex
   * APP172 -> _HMG_xMainMenuHandle
   * APP173 -> _HMG_xMainMenuParentHandle
   * APP174 -> _HMG_xMenuPopupLevel
   * APP175 -> _HMG_xContextMenuHandle
   * APP176 -> _HMG_xContextMenuParentHandle
   * APP177 -> _HMG_xContextPopupLevel
   * APP178 -> _HMG_ActiveTreeValue
   * APP179 -> _HMG_ActiveTreeIndex
   * APP180 -> _HMG_ActiveTreeHandle
   * APP181 -> _HMG_MainHandle
   * APP182 -> _HMG_ActiveFontSize
   * APP183 -> _HMG_FrameLevel // moved to class
   * APP184 -> _HMG_ActiveTabPage
   * APP185 -> _HMG_ActiveTabRow
   * APP186 -> _HMG_ActiveTabCol
   * APP187 -> _HMG_ActiveTabWidth
   * APP188 -> _HMG_ActiveTabHeight
   * APP189 -> _HMG_ActiveTabValue
   * APP190 -> _HMG_ActiveTabFontSize
   * APP191 -> _HMG_MouseRow
   * APP192 -> _HMG_MouseCol
   * APP193 -> _HMG_MouseState
   * APP194 -> _HMG_ThisFormIndex
   * APP195 -> _HMG_ThisItemRowIndex
   * APP196 -> _HMG_ThisItemColIndex
   * APP197 -> _HMG_ThisItemCellRow
   * APP198 -> _HMG_ThisItemCellCol
   * APP199 -> _HMG_ThisItemCellWidth
   * APP200 -> _HMG_ThisItemCellHeight
   * APP201 -> _HMG_ThisQueryRowIndex
   * APP202 -> _HMG_ThisQueryColIndex
   * APP:ThisControlIndex APP203 -> _HMG_ThisIndex   ThisControlIndex
   * APP204 -> Current TAB multiline
   * APP205 -> _RESERVED_
   * APP206 -> Current Report Iterator Expression
   * APP207 -> Current Report EOF Expression
   * APP208 -> _RESERVED_
   * APP209 -> Current Cell Parent Control INDEX (Grid Inplace Edit)
   * APP210 -> _HMG_ActiveToolBarFormName
   * APP211 -> _HMG_LANG_ID
   * APP212 -> _hmg_CurrentStatusBarParent
   * APP213 -> _hmg_CurrentStatusBarFontName
   * APP214 -> _HMG_TempWindowName
   * APP215 -> _HMG_ActiveFormNameBak
   * APP216 -> _HMG_SplitLastControl
   * APP217 -> _HMG_ActiveHelpFile
   * APP218 -> _HMG_xMenuType
   * APP:ActiveIniFile APP219 -> _HMG_ActiveIniFile
   * APP:xMainMenuParentName APP220 -> _HMG_xMainMenuParentName
   * APP221 -> _HMG_xContextMenuParentName
   * APP222 -> _HMG_ActiveSplitBoxParentFormName
   * APP:ActiveFormName APP223 -> _HMG_ActiveFormName
   * APP224 -> _HMG_ActiveFontName
   * APP225 -> _HMG_ActiveTabName
   * APP226 -> _HMG_ActiveTabParentFormName
   * APP227 -> _HMG_ActiveTabFontName
   * APP228 -> _HMG_ActiveTabToolTip
   * APP229 -> _HMG_ActiveTabMnemonic
   * APP230 -> _HMG_ThisQueryData
   * APP:ThisType APP231 -> _HMG_ThisType
   * APP:ThisEventType APP232 -> _HMG_ThisEventType
   * APP233 -> Alternate Syntax: OnEditEnd Event Temporary Storage
   * APP234 -> _RESERVED_
   * APP235 -> LOAD WINDOW optional row
   * APP236 -> LOAD WINDOW optional col
   * APP237 -> LOAD WINDOW optional width
   * APP238 -> LOAD WINDOW optional height
   * APP239 -> _RESERVED_
   * APP240 -> Parent Window Active
   * APP241 -> _RESERVED_
   * APP242 -> TextBox GotFocus Execution Flag
   * APP243 -> TextBox LostFocus Execution Flag
   * APP244 -> Current DynamicDisplay
   * APP245 -> CellNavigation UpDown Flag
   * APP246 -> HeaderImages Property
   * APP247 -> OnCloseUp Event
   * APP248 -> OnDropDown Event
   * APP249 -> DroppedWidth Property
   * APP:IsXP APP250 -> _HMG_IsXP
   * APP251 -> _HMG_SetFocusExecuted
   * APP:InteractiveCloseStart APP252 -> _HMG_InteractiveCloseStarted
   * APP253 -> _HMG_DateTextBoxActive
   * APP254 -> _HMG_BrowseSyncStatus
   * APP:IsExtendedNavigation APP255 -> _HMG_ExtendedNavigation
   * APP256 -> _HMG_IPE_CANCELLED
   * APP257 -> _HMG_DialogCancelled
   * APP258 -> _HMG_ActiveSplitBoxInverted
   * APP259 -> _HMG_ActiveTreeItemIds
   * APP260 -> _HMG_SplitChildActive
   * APP261 -> _HMG_ActiveToolBarBreak
   * APP262 -> _HMG_ActiveSplitBox
   * APP263 -> _HMG_MainActive
   * APP264 -> _HMG_BeginWindowActive
   * APP265 -> _HMG_BeginTabActive
   * APP:ActiveTabButtons APP266 -> _HMG_ActiveTabButtons
   * APP:ActiveTabFlat APP267 -> _HMG_ActiveTabFlat
   * APP268 -> _HMG_ActiveTabHotTrack
   * APP269 -> _HMG_ActiveTabVertical
   * APP270 -> _HMG_ActiveTabNoTabStop
   * APP:IsModalActive APP271 -> _HMG_IsModalActive
   * APP272 -> _hmg_CurrentStatusBarFontBold
   * APP273 -> _hmg_CurrentStatusBarFontItalic
   * APP274 -> _hmg_CurrentStatusBarFontUnderLine
   * APP275 -> _hmg_CurrentStatusBarFontStrikeout
   * APP276 -> _hmg_CurrentStatusBarTop
   * APP277 -> Current OnSave
   * APP278 -> This.EditBuffer
   * APP279 -> This.DeleteBuffer
   * APP280 -> This.AppendBuffer
   * APP281 -> Current LockColumns
   * APP282 -> _RESERVED_
   * APP283 -> _RESERVED_
   * APP284 -> _RESERVED_
   * APP285 -> _RESERVED_
   * APP286 -> User Current Print Copies
   * APP287 -> User Current Print Collation
   * APP288 -> _RESERVED_
   * APP289 -> _RESERVED_
   * APP290 -> _HMG_SENDDATACOUNT
   * APP291 -> _HMG_COMMPATH
   * APP292 -> _HMG_STATIONNAME
   * APP293 -> _DoControlEventProcedure Eval Result
   * APP294 -> _RESERVED_
   * APP295 -> _RESERVED_
   * APP296 -> HFCL data
   * APP297 -> _RESERVED_
   * APP298 -> Current Disabled BackColor
   * APP299 -> Current Disabled ForeColor
   * APP300 -> _hmg_ActiveToolBarImageHeight
   * APP301 -> _HMG_ActiveTabBold
   * APP302 -> _HMG_ActiveTabItalic
   * APP303 -> _HMG_ActiveTabUnderline
   * APP304 -> _HMG_ActiveTabStrikeout
   * APP305 -> _HMG_ActiveTabImages
   * APP306 -> _HMG_IsMultiple
   * APP307 -> _HMG_NodeIndex
   * APP308 -> _HMG_ActiveTabChangeProcedure
   * APP309 -> _hmg_ActiveToolBarButtonCount
   * APP310 -> _hmg_ActiveToolBarHandle
   * APP311 -> _hmg_ActiveToolBarParentWindowName
   * APP312 -> _hmg_ActiveToolBarParentWindowHandle
   * APP313 -> _hmg_ActiveToolBarGripperText
   * APP314 -> _hmg_ActiveToolBarBreak
   * APP315 -> _hmg_ActiveToolBarImageWidth
   * APP316 -> _HMG_ThisFormName
   * APP:ThisControlName APP317 -> _HMG_ThisControlName
   * APP318 -> _HMG_THISItemCellValue
   * APP319 -> _RESERVED_
   * APP320 -> EXPERIMENTAL/NOT FULLY IMPLEMENTED: VIRTUAL GRID EDIT FLAG
   * APP321 -> EXPERIMENTAL/NOT FULLY IMPLEMENTED: VIRTUAL GRID EDIT ALLOW TAB FLAG
   * APP322 -> _RESERVED_
   * APP323 -> OOP Object Counter
   * APP324 -> OOP Last Window Object
   * APP325 -> Current Control Definition: 'Buffered'
   * APP326 -> Current Control Definition: 'ColumnFields'
   * APP327 -> Current Control Definition: 'RecordSource'
   * APP328 -> Last 'By Cell' Grid Event
   * APP329 -> Active CellNavigation
   * APP:aEventInfo APP330 -> _HMG_aEventInfo
   * APP331 -> _HMG_MESSAGE
   * APP332 -> _HMG_ActiveFrameParentFormName
   * APP333 -> _HMG_ActiveFrameRow
   * APP334 -> _HMG_ActiveFrameCol
   * APP335 -> _HMG_xMenuPopuphandle
   * APP336 -> _HMG_xMenuPopupCaption
   * APP337 -> _HMG_NodeHandle
   * APP338 -> _HMG_ShowContextMenus
   * APP339 -> _HMG_InteractiveClose
   * APP340 -> _HMG_IPE_COL
   * APP341 -> _HMG_IPE_ROW
   * APP342 -> _HMG_DefaultFontName
   * APP343 -> _HMG_DefaultFontSize
   * APP344 -> _HMG_LastWIndowDefinition
   * APP345 -> ScrollStep
   * APP  APP346 -> Set AutoScroll
   * APP347 -> Grid Automatic Update
   * APP348 -> Grid Selected Row ForeColor (by cell navigation)
   * APP349 -> Grid Selected Row BackColor (by cell navigation)
   * APP350 -> Grid Selected Cell ForeColor (by cell navigation)
   * APP351 -> Grid Selected Cell BackColor (by cell navigation)
   * APP352 -> Active Control DRAGITEMS
   * APP353 -> Active Control MULTILINE
   * APP354 -> Active Control DISPLAYITEMS
   * APP355 -> Active Control INPUTITEMS
   * APP356 -> Active Control PROGID
   * APP357 -> Active Control Horizontal
   * APP358 -> Print Job Name
   * APP359 -> PRINTER_DELTA_ZOOM
   * APP360 -> _hmg_printer_BasePageName
   * APP361 -> _hmg_printer_CurrentPageNumber
   * APP362 -> _hmg_printer_SizeFactor
   * APP363 -> _hmg_printer_Dx
   * APP364 -> _hmg_printer_Dy
   * APP365 -> _hmg_printer_Dz
   * APP366 -> _hmg_printer_scrollstep
   * APP367 -> _hmg_printer_zoomclick_xoffset
   * APP368 -> _HMG_PRINTER_THUMBUPDATE
   * APP369 -> _hmg_printer_thumbscroll
   * APP370 -> _hmg_printer_PrevPageNumber
   * APP371 -> _hmg_printer_usermessages
   * APP372 -> _hmg_printer_hdc_bak
   * APP373 -> _hmg_printer_aPrinterProperties
   * APP374 -> _hmg_printer_hdc
   * APP375 -> _hmg_printer_name
   * APP376 -> _hmg_printer_copies
   * APP377 -> _hmg_printer_collate
   * APP378 -> _hmg_printer_preview
   * APP379 -> _hmg_printer_timestamp
   * APP380 -> _hmg_printer_PageCount
   * APP381 -> Active PICTURE Alignment
   * APP382 -> Grid Column Header
   * APP383 -> Control Definition Active
   * APP384 -> _HMG_ActiveControlNoAutoSizeMovie
   * APP385 -> _HMG_ActiveControlField
   * APP386 -> _HMG_ActiveControlColumnWhen
   * APP387 -> _HMG_ActiveControlColumnValid
   * APP388 -> _HMG_ActiveControlEditControls
   * APP389 -> _HMG_ActiveControlWhen
   * APP390 -> _HMG_ActiveControlDynamicForeColor
   * APP391 -> _HMG_ActiveControlDynamicBackColor
   * APP392 -> _HMG_ActiveControlHandCursor
   * APP393 -> _HMG_ActiveControlCenterAlign
   * APP394 -> _HMG_ActiveControlNoHScroll
   * APP395 -> _HMG_ActiveControlGripperText
   * APP396 -> _HMG_ActiveControlDisplayEdit
   * APP397 -> _HMG_ActiveControlDisplayChange
   * APP398 -> _HMG_ActiveControlNoVScroll
   * APP399 -> _HMG_ActiveControlForeColor
   * APP400 -> _HMG_ActiveControlDateType
   * APP401 -> _HMG_ActiveControlInPlaceEdit
   * APP402 -> _HMG_ActiveControlItemSource
   * APP403 -> _HMG_ActiveControlValueSource
   * APP404 -> _HMG_ActiveControlWrap
   * APP405 -> _HMG_ActiveControlIncrement
   * APP406 -> _HMG_ActiveControlAddress
   * APP407 -> _HMG_ActiveControlItemCount
   * APP408 -> _HMG_ActiveControlOnQueryData
   * APP409 -> _HMG_ActiveControlAutoSize
   * APP410 -> _HMG_ActiveControlVirtual
   * APP411 -> _HMG_ActiveControlStretch
   * APP412 -> _HMG_ActiveControlFontBold
   * APP413 -> _HMG_ActiveControlFontItalic
   * APP414 -> _HMG_ActiveControlFontStrikeOut
   * APP415 -> _HMG_ActiveControlFontUnderLine
   * APP416 -> _HMG_ActiveControlName
   * APP417 -> _HMG_ActiveControlOf
   * APP418 -> _HMG_ActiveControlCaption
   * APP419 -> _HMG_ActiveControlAction
   * APP420  -> _HMG_ActiveControlWidth
   * APP421 -> _HMG_ActiveControlHeight
   * APP422 -> _HMG_ActiveControlFont
   * APP423 -> _HMG_ActiveControlSize
   * APP424 -> _HMG_ActiveControlTooltip
   * APP425 -> _HMG_ActiveControlFlat
   * APP426 -> _HMG_ActiveControlOnGotFocus
   * APP427 -> _HMG_ActiveControlOnLostFocus
   * APP428 -> _HMG_ActiveControlNoTabStop
   * APP429 -> _HMG_ActiveControlHelpId
   * APP430  -> _HMG_ActiveControlInvisible
   * APP431  -> _HMG_ActiveControlRow
   * APP432  -> _HMG_ActiveControlCol
   * APP433  -> _HMG_ActiveControlPicture
   * APP434  -> _HMG_ActiveControlValue
   * APP435  -> _HMG_ActiveControlOnChange
   * APP436  -> _HMG_ActiveControlItems
   * APP437  -> _HMG_ActiveControlOnEnter
   * APP438  -> _HMG_ActiveControlShowNone
   * APP439  -> _HMG_ActiveControlUpDown
   * APP440  -> _HMG_ActiveControlRightAlign
   * APP441  -> _HMG_ActiveControlReadOnly
   * APP442  -> _HMG_ActiveControlMaxLength
   * APP443  -> _HMG_ActiveControlBreak
   * APP444  -> _HMG_ActiveControlOpaque
   * APP445  -> _HMG_ActiveControlHeaders
   * APP446  -> _HMG_ActiveControlWidths
   * APP447  -> _HMG_ActiveControlOnDblClick
   * APP448  -> _HMG_ActiveControlOnHeadClick
   * APP449 -> _HMG_ActiveControlNoLines
   * APP450  -> _HMG_ActiveControlImage
   * APP451  -> _HMG_ActiveControlJustify
   * APP452  -> _HMG_ActiveControlNoToday
   * APP453  -> _HMG_ActiveControlNoTodayCircle
   * APP454  -> _HMG_ActiveControlWeekNumbers
   * APP455  -> _HMG_ActiveControlMultiSelect
   * APP456  -> _HMG_ActiveControlEdit
   * APP457  -> _HMG_ActiveControlBackColor
   * APP458  -> _HMG_ActiveControlFontColor
   * APP459  -> _HMG_ActiveControlBorder
   * xxxxx APP460 -> _HMG_ActiveControlClientEdge
   * APP461  -> _HMG_ActiveControlHScroll
   * APP462  -> _HMG_ActiveControlVscroll
   * APP463  -> _HMG_ActiveControlTransparent
   * APP464  -> _HMG_ActiveControlSort
   * APP465  -> _HMG_ActiveControlRangeLow
   * APP466  -> _HMG_ActiveControlRangeHigh
   * APP467  -> _HMG_ActiveControlVertical
   * APP468  -> _HMG_ActiveControlSmooth
   * APP469  -> _HMG_ActiveControlOptions
   * APP470  -> _HMG_ActiveControlSpacing
   * APP:ActiveControlNoTicks APP471 -> _HMG_ActiveControlNoTicks
   * APP472  -> _HMG_ActiveControlBoth
   * APP473  -> _HMG_ActiveControlTop
   * APP474  -> _HMG_ActiveControlLeft
   * APP475  -> _HMG_ActiveControlUpperCase
   * APP476  -> _HMG_ActiveControlLowerCase
   * APP477  -> _HMG_ActiveControlNumeric
   * APP478  -> _HMG_ActiveControlPassword
   * APP479  -> _HMG_ActiveControlInputMask
   * APP480 -> _HMG_ActiveControlWorkArea
   * APP481  -> _HMG_ActiveControlFields
   * APP482  -> _HMG_ActiveControlDelete
   * APP483  -> _HMG_ActiveControlValid
   * APP484  -> _HMG_ActiveControlValidMessages
   * APP485  -> _HMG_ActiveControlLock
   * APP486  -> _HMG_ActiveControlAppendable
   * APP487  -> _HMG_ActiveControlFile
   * APP488  -> _HMG_ActiveControlAutoPlay
   * APP489  -> _HMG_ActiveControlCenter
   * APP490  -> _HMG_ActiveControlNoAutoSizeWindow
   * APP491  -> _HMG_ActiveControlNoAuotSizeMovie
   * APP492  -> _HMG_ActiveControlNoErrorDlg
   * APP493  -> _HMG_ActiveControlNoMenu
   * APP494  -> _HMG_ActiveControlNoOpen
   * APP495  -> _HMG_ActiveControlNoPlayBar
   * APP496  -> _HMG_ActiveControlShowAll
   * APP497  -> _HMG_ActiveControlShowMode
   * APP498  -> _HMG_ActiveControlShowName
   * APP499  -> _HMG_ActiveControlShowPosition
   * APP:ActiveControlFormat () APP500 -> _HMG_ActiveControlFormat

   * APP501  -> ScrollPage
   * APP502  -> #xtranslate --> _HMG_PrinterMetaFileDC
   * APP503  -> #xtranslate --> _HMG_FindReplaceOptions
   * FORM:FORM504  -> {x,y,w,h}   --> Position of Panel Window

   * APP505  -> PrintPreview NotSaveButton --> .T. or .F.
   * APP506  -> PrintPreview Dialog cFileName
   * APP507  -> Print SaveAs cFullFileName
   * APP508  -> Open PrintPreview Dialog  --> .T. or .F.
   * APP509  -> ToolTip CustomDraw  --> .T. or .F.
   * APP510  -> ToolTip Menu --> .T. or .F.
   * FORM:TooltipMenuHandle -> ToolTip Menu Handle  --> { hWndToolTipMenu, ... }
   * FORM:FORM512  -> ToolTip Form Data
   * APP513  -> Default Print PDF Mode --> .T. or .F.
   * APP514  -> SetGridCustomDrawNewBehavior() --> .T. or .F.
   * APP515  -> #xtranslate --> OpenPrinterGetJobID()
   * APP516  -> cVarName of STOREJOBDATA <aJobData>
   * APP517  -> #xtranslate --> oString
   * ThisCargo [ 518 ] -> #xtranslate --> This.Cargo

   * Create Public Array and Give it Initial Values

   PUBLIC _HMG_SYSDATA := {}

   //FOR i := 1 to 39 // later change some values
   //   _HMG_SYSDATA [ i ] := {}
   //NEXT i

   //   For i := 128 to 148
   //      _HMG_SYSDATA [ i ] := {}
   //   Next i

   //   For i := 164 to 203
   //      _HMG_SYSDATA [ i ] := 0
   //   Next i

   //   For i := 210 to 232
   //      _HMG_SYSDATA [ i ] := ''
   //   Next i

   //   For i := 250 to 276
   //      _HMG_SYSDATA [ i ] := .F.
   //   Next i

   //   For i := 300 to 318
   //      _HMG_SYSDATA [ i ] := NIL
   //   Next i

   //   For i := 360 to 380
   //      _HMG_SYSDATA [ i ] := NIL
   //   Next i

   //   oHmgApp():APP330 := {}
   //   oHmgApp():APP331 := ARRAY (8)
   //   oHmgApp():APP332 := ARRAY (128)
   //   oHmgApp():APP333 := ARRAY (128)
   //   oHmgApp():APP334 := ARRAY (128)
   //   oHmgApp():APP335 := ARRAY (255)
   //   oHmgApp():APP336 := ARRAY (255)
   //   oHmgApp():APP337 := ARRAY (255)
   //   oHmgApp():APP338 := .T.
   //   oHmgApp():APP339 := 1
   //   oHmgApp():APP340 := 1
   //   oHmgApp():APP341 := 1
   //   oHmgApp():APP342 := 'Arial'
   //   oHmgApp():APP343 := 9
   //   oHmgApp():APP344 := 'None'
   //   oHmgApp():APP371 := ARRAY (29)
   //   oHmgApp():APP373 := {0,"",0,0}  // _hmg_printer_aPrinterProperties
   //_HMG_SYSDATA [  55 ] := .F.
   //_HMG_SYSDATA [  56 ] := NIL
   //_HMG_SYSDATA [  57 ] := NIL
   //   oHmgApp():APP383 := .F.
   //   oHmgApp():APP345 := 1   // ScrollStep
   //   //oHmgApp():APP501 := 20  // ScrollPage
   //   oHmgApp():APP357 := .F.
   //oHmgApp():APP109 := 0

   //   oHmgApp():APP348 := { 0 , 0 , 0 }
   //   oHmgApp():APP349 := { 235 , 235 , 235 }

   //   oHmgApp():APP350 := { GetRed ( GetSysColor (COLOR_HIGHLIGHTTEXT) )   , GetGreen ( GetSysColor ( COLOR_HIGHLIGHTTEXT) )   , GetBlue ( GetSysColor (COLOR_HIGHLIGHTTEXT) ) }
   //   oHmgApp():APP351 := { GetRed ( GetSysColor (COLOR_HIGHLIGHT) )   , GetGreen ( GetSysColor (COLOR_HIGHLIGHT ) )      , GetBlue ( GetSysColor (COLOR_HIGHLIGHT) )   }

   // for default the selected language is English
   HB_LANGSELECT ("EN")
   InitMessages ("EN")

   //   oHmgApp():APP306 := IsExeRunning (HB_UTF8STRTRAN (GetProgramFileName(), '\', '_'))

   IF 'XP' $ aWINver[1]
      oHmgApp():IsXP  := .T.
   ENDIF

   //   oHmgApp():APP320 := .F.
   //   oHmgApp():APP321 := .F.
   //   oHmgApp():APP299 := .F.
   //   oHmgApp():APP243 := .F.
   //   oHmgApp():APP242 := .F.

   //   oHmgApp():APP347 := .T.

   //   oHmgApp():APP286 := .F.
   //   oHmgApp():APP287 := .F.

   //   oHmgApp():APP240 := .F.

   //   oHmgApp():APP235 := -1
   //   oHmgApp():APP236 := -1
   //   oHmgApp():APP237 := -1
   //   oHmgApp():APP238 := -1
   //   oHmgApp():APP284 := .F.
   //   oHmgApp():APP285 := .F.

   //   oHmgApp():APP375 := ""  // OpenPrinterGetName()
   //oHmgApp():APP509 := .F. // ToolTip CustomDraw
   //oHmgApp():APP510 := .T. // ToolTip Menu
   //FORM:TooltipMenuHandle _HMG_SYSDATA [ 511 ] := {}  // ToolTip Menu Handle  --> { hWndToolTipMenu, ... }
   //FORM:FORM512 _HMG_SYSDATA [ 512 ] := {}  // ToolTip Form Data
   //oHmgApp():APP513 := .F. // Default Print PDF Mode off
   //oHmgApp():APP514 := .T. // SetGridCustomDrawNewBehavior(), for default is .T.
   //oHmgApp():APP515 := 0   // OpenPrinterGetJobID()
   //oHmgApp():APP516 := ""  // cVarName of STOREJOBDATA <aJobData>

   //_HMG_SYSDATA [54] := _GETDDLMESSAGE()           // ADD
   _HMG_MsgIDFindDlg := REGISTERFINDMSGSTRING ()   // ADD

   HMG_InitAllCommonControls()   // ADD
   OleInitialize()               // ADD

   SET WINDOW MAIN FIRST OFF     // ADD march 2017

   _HMG_DialogBoxProperty ( NIL, NIL, .F., 0, .F. )            // ADD
   _HMG_DialogBoxProcedure()                                   // ADD
   CREATE EVENT PROCNAME _HMG_DialogBoxProcedure(EventMsg())   // ADD

   CREATE EVENT PROCNAME _HMG_OnKey_OnMouse_Controls() STOREINDEX nIndex  // ADD
   EventProcessHMGWindowsMessage (nIndex, .F.)

   CREATE EVENT PROCNAME _HMG_GridOnClickAndOnKeyEvent()  STOREINDEX nIndex   // ADD
   EventProcessHMGWindowsMessage (nIndex, .F.)   // December 2014

   CREATE EVENT PROCNAME _HMG_GridInplaceEditEvent()      STOREINDEX nIndex   // ADD
   EventProcessHMGWindowsMessage (nIndex, .F.)   // December 2014

   // MsgDebug("Init Proc")

   RETURN Nil

   // Dr. Claudio Soto (May 2013)
   *--------------------------------------------------*

PROCEDURE SetMultiple (lSetMultiple, lWarning)

   *--------------------------------------------------*
   LOCAL lExeRunning := oHmgApp():APP306

   IF ( lExeRunning == .T.) .AND. (lSetMultiple == .F.)
      IF lWarning == .T.
         InitMessages()
         MsgStop (oHmgApp():APP331 [ 4 ])
      ENDIF
      ExitProcess(0)
   ENDIF

   RETURN

   // Dr. Claudio Soto (May 2013)
   *-----------------------------------------------*

FUNCTION HMG_GetLanguage ()

   *-----------------------------------------------*
   LOCAL cLang := oHmgApp():APP211

   RETURN cLang

   *------------------------------------------------------------------------------*

PROCEDURE InitMessages (cSetLang)

   *------------------------------------------------------------------------------*
   __THREAD STATIC cLang := "EN"

   IF cSetLang <> NIL
      cLang := cSetLang
   ENDIF

   oHmgApp():APP211 := cLang

   // cLang := Set ( _SET_LANGUAGE )

   // FINNISH and DUTCH: LANGUAGES NOT SUPPORTED BY hb_langSelect() FUNCTION.

   /*
   IF oHmgApp():APP211 == 'FI'      // FINNISH
   cLang := 'FI'
   ELSEIF oHmgApp():APP211 == 'NL'   // DUTCH
   cLang := 'NL'
   ENDIF
   */

   _hmg_printer_InitUserMessages (cLang)

   ********************************************************************************************************************************************************
   IF HMG_IsCurrentCodePageUnicode()
      ********************************************************************************************************************************************************

      DO CASE

         // case cLang == "TRWIN" .OR. cLang == "TR"
      CASE cLang == "TR"

         /////////////////////////////////////////////////////////////
         // T√úRK√áE
         ////////////////////////////////////////////////////////////

         // √áE√û√ùTL√ù MESAJLAR

         oHmgApp():APP331 [1] := 'Emin misiniz ?'
         oHmgApp():APP331 [2] := 'Pencereyi Kapat'
         oHmgApp():APP331 [3] := 'Kapat√Ωlam√Ωyor'
         oHmgApp():APP331 [4] := 'Program h√¢len √ßal√Ω√æ√Ωyor'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Tamam'
         oHmgApp():APP331 [7] := '√ùptal'
         oHmgApp():APP331 [8] := 'Syf.'

         // BROWSE MESAJLARI ( T√úRK√áE )

         oHmgApp():APP136  := { ;
            "Pencere: ", ;
            " tan√Ωms√Ωz. Program sonland√Ωr√Ωld√Ω.", ;
            "HMG Hatas√Ω", ;
            "Kontrol: ", ;
            " / ", ;
            " √ñnceden tan√Ωml√Ω. Program sonland√Ωr√Ωld√Ω.", ;
            "Browse: Ge√ßersiz Tip. Program sonland√Ωr√Ωld√Ω.", ;
            "Browse: Browse √ßal√Ω√æma alan√Ωnda olmayan sahalar i√ßin " + ;
            "Append ibaresi kullan√Ωlamaz. Program sonland√Ωr√Ωld√Ω.", ;
            "Bu kayd√Ω √æu anda ba√æka biri editliyor.", ;
            "Uyar√Ω", ;
            "Ge√ßersiz giri√æ"}

         oHmgApp():APP137 := { 'Emin misiniz ?' , 'Kay√Ωt silme' }

         // EDIT MESAJLARI ( T√úRK√áE )

         oHmgApp():APP131   := { Chr(13)+"Kay√Ωt silme"+CHR(13)+"Emin misiniz ?"+CHR(13), ;
            Chr(13)+"Indeks dosyas√Ω yok"+CHR(13)+"Arama yap√Ωlam√Ωyor"+CHR(13), ;
            Chr(13)+"Indeks dosyas√Ω bulunamad√Ω"+CHR(13)+"Arama yap√Ωlam√Ωyor"+CHR(13), ;
            Chr(13)+"Memo ve mant√Ωksal sahalarda"+CHR(13)+"Arama yap√Ωlamaz"+CHR(13), ;
            Chr(13)+"Kay√Ωt bulunamad√Ω"+CHR(13), ;
            Chr(13)+"√áok fazla s√ºtun var"+CHR(13)+"Rapor sayfaya s√Ω√∞m√Ωyor"+CHR(13) }

         oHmgApp():APP132  := { ;
            "Kay√Ωt", ;
            "Kay√Ωt say√Ωs√Ω", ;
            "       (Yeni)", ;
            "       (Edit)", ;
            " Kay√Ωt No.su :", ;
            "Ara", ;
            "Metin ara", ;
            "Tarih ara", ;
            "Say√Ω ara", ;
            "Rapor tan√Ωm√Ω", ;
            "Rapor s√ºtunlar√Ω", ;
            "M√ºsait s√ºtunlar", ;
            "√ùlk kay√Ωt", ;
            "Son kay√Ωt", ;
            "Rapor ad√Ω ", ;
            "Tarih:", ;
            "√ùlk kay√Ωt:", ;
            "Son kay√Ωt:", ;
            "S√Ωra d√ºzeni:", ;
            "Evet", ;
            "Hay√Ωr", ;
            "Sayfa ", ;
            " / "}

         oHmgApp():APP133 := { ;
            "Kapat", ;
            "Yeni", ;
            "Edit", ;
            "Sil", ;
            "Ara", ;
            "Git", ;
            "Rapor", ;
            "√ùlk", ;
            "√ñnceki", ;
            "Sonraki", ;
            "Son", ;
            "Kaydet", ;
            "√ùptal", ;
            "Ekle", ;
            "Kald√Ωr", ;
            "Print", ;
            "Kapat"}

         oHmgApp():APP134  := { ;
            "EDIT, √ßal√Ω√æma alan√Ω ismi noksan", ;
            "EDIT, bu √ßal√Ω√æma alan√Ωnda 16'dan fazla saha var", ;
            "EDIT, Tazeleme mod'u s√Ωn√Ωr √∂tesinde ( l√ºtfen hatay√Ω bildirin )", ;
            "EDIT, Temel olay numaras√Ω s√Ωn√Ωr √∂tesinde ( l√ºtfen hatay√Ω bildirin )", ;
            "EDIT, Liste olay numaras√Ω s√Ωn√Ωr √∂tesinde ( l√ºtfen hatay√Ω bildirin )" }

         // EDIT EXTENDED MESAJLARI ( T√úRK√áE )

         oHmgApp():APP128 := { ;
            "&Kapat",;                // 1
            "&Yeni",;                 // 2
            "&De√∞i√ætir",;             // 3
            "&Sil",;                  // 4
            "&Ara",;                  // 5
            "&Print",;                // 6
            "&√ùptal",;                // 7
            "&Tamam",;                // 8
            "&Kopyala",;              // 9
            "&S√ºzge√ßi etkinle√ætir",;  // 10
            "&S√ºzge√ßi kald√Ωr" }       // 11

         oHmgApp():APP129 := { ;
            "Yok",;                         // 1
            "Kay√Ωt",;                       // 2
            "Toplam",;                      // 3
            "Aktif s√Ωra",;                  // 4
            "Se√ßenekler",;                  // 5
            "Yeni kay√Ωt",;                  // 6
            "Kayd√Ω de√∞i√ætir",;              // 7
            "Kay√Ωt se√ß",;                   // 8
            "Kay√Ωt ara",;                   // 9
            "Print se√ßenekleri",;           // 10
            "M√ºsait sahalar",;              // 11
            "Print edilecek sahalar",;      // 12
            "M√ºsait printerler",;           // 13
            "Print ediecek ilk kay√Ωt",;     // 14
            "Print ediecek son kay√Ωt",;     // 15
            "Kay√Ωt sil",;                   // 16
            "√ñnizleme",;                    // 17
            "Sayfa ikonlar√Ωn√Ω g√∂ster",;     // 18
            "S√ºzge√ß √æart√Ω: ",;              // 19
            "S√ºzge√ßli: ",;                  // 20
            "S√ºzge√ß se√ßenekleri" ,;         // 21
            "Database Sahalar√Ω",;           // 22
            "Kar√æ√Ωla√æt√Ωrma operat√∂rleri",;  // 23
            "S√ºzge√ß de√∞eri",;               // 24
            "S√ºzge√ßlenecek sahalar√Ω se√ß",;  // 25
            "Kar√æ√Ωla√æt√Ωrma operat√∂r√º se√ß",; // 26
            "E√æit",;                        // 27
            "E√æit de√∞il",;                  // 28
            "Daha b√ºy√ºk",;                  // 29
            "Daha k√º√ß√ºk",;                  // 30
            "Daha b√ºy√ºk veya e√æit",;        // 31
            "Daha k√º√ß√ºk veya e√æit"}         // 32

         oHmgApp():APP130 := { ABM_CRLF + ;
            "Aktif bir alan bulunamad√Ω."  + ABM_CRLF + ;
            "L√ºtfen EDIT'i √ßa√∞√Ωrmadan √∂nce bir alan se√ßin" + ABM_CRLF,;           //  1
            "Saha de√∞eri girin ( metin )",;                                       //  2
            "Saha de√∞eri girin ( say√Ω )",;                                        //  3
            "Tarih se√ßimi",;                                                      //  4
            "Do√∞ru de√∞eri onayla",;                                               //  5
            "Saha de√∞eri girin",;                                                 //  6
            "Bir kay√Ωt se√ßip 'Tamam'a bas√Ωn",;                                    //  7
            ABM_CRLF + "Aktif kayd√Ω silmek √ºzeresiniz" + ABM_CRLF + ;
            "Emin misiniz ?    " + ABM_CRLF,;                          //  8
            ABM_CRLF + "Aktif bir s√Ωra d√ºzeni yok   " + ABM_CRLF + ;
            "L√ºtfen birini se√ßin " + ABM_CRLF,;                        //  9
            ABM_CRLF + "Memo ve mant√Ωksal sahada arama yap√Ωlam√Ωyor." + ABM_CRLF,; // 10
            ABM_CRLF + "Kay√Ωt bulunmad√Ω   " + ABM_CRLF,;                          // 11
            "Listeye girecek sahay√Ω se√ßin",;                                      // 12
            "Listeye girmeyecek sahay√Ω se√ßin",;                                   // 13
            "Printer se√ßin",;                                                     // 14
            "Sahay√Ω eklemek i√ßin d√º√∞meye bas√Ωn",;                                 // 15
            "Sahay√Ω √ß√Ωkarmak i√ßin d√º√∞meye bas√Ωn",;                                // 16
            "Print edilecek ilk kayd√Ω se√ßmek i√ßin d√º√∞meye bas√Ωn",;                // 17
            "Print edilecek son kayd√Ω se√ßmek i√ßin d√º√∞meye bas√Ωn",;                // 18
            ABM_CRLF + "Eklenecek ba√æka saha yok.   " + ABM_CRLF,;                // 19
            ABM_CRLF + "√ñnce eklenecek sahay√Ω se√ßin"   + ABM_CRLF,;               // 20
            ABM_CRLF + "D√Ω√ælanacak ba√æka saha yok   "   + ABM_CRLF,;              // 21
            ABM_CRLF + "√ñnce √ß√Ωkar√Ωlacak sahay√Ω se√ßin   " + ABM_CRLF,;            // 22
            ABM_CRLF + "Bir saha bile se√ßilmedi   " + ABM_CRLF + ;
            "L√ºtfen print edilecek sahalar√Ω se√ßin" + ABM_CRLF,;        // 23
            ABM_CRLF + "√áok fazla saha" + ABM_CRLF + ;
            "Saha say√Ωs√Ωn√Ω azalt√Ωn" + ABM_CRLF,;                       // 24
            ABM_CRLF + "Printer haz√Ωr de√∞il   " + ABM_CRLF,;                      // 25
            "S√Ωra d√ºzeni",;                                                       // 26
            "√ùlk Kay√Ωt",;                                                         // 27
            "Son kay√Ωt",;                                                         // 28
            "Evet",;                                                              // 29
            "Hay√Ωr",;                                                             // 30
            "Sayfa:",;                                                            // 31
            ABM_CRLF + "L√ºtfen bir printer se√ßin" + ABM_CRLF,;                    // 32
            "S√ºzge√ß : ",;                                                         // 33
            ABM_CRLF + "Aktif s√ºzge√ß yok" + ABM_CRLF,;                            // 34
            ABM_CRLF + "Memo sahalar s√ºzge√ßlenemiyor    " + ABM_CRLF,;            // 35
            ABM_CRLF + "S√ºzge√ßelenecek sahay√Ω se√ßin    " + ABM_CRLF,;             // 36
            ABM_CRLF + "S√ºzge√ß i√ßin bir operat√∂r se√ßin    " + ABM_CRLF,;          // 37
            ABM_CRLF + "S√ºzge√ß i√ßi bir de√∞er yaz√Ωn    " + ABM_CRLF,;              // 38
            ABM_CRLF + "Aktif bir s√ºzge√ß yok    " + ABM_CRLF,;                    // 39
            ABM_CRLF + "S√ºzge√ß kald√Ωr√Ωls√Ωn m√Ω   " + ABM_CRLF,;                    // 40
            ABM_CRLF + "Kayd√Ω ba√æka bir kullan√Ωc√Ω kilitlemi√æ    " + ABM_CRLF }    // 41

         // case cLang ==  "CS" .OR. cLang == "CSWIN"
      CASE cLang ==  "CS"
         /////////////////////////////////////////////////////////////
         // CZECH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP331 [1] := 'Jste si jist(a)?'
         oHmgApp():APP331 [2] := 'Zav√∏i okno'
         oHmgApp():APP331 [3] := 'Uzav√∏en√≠ zak√°z√°no'
         oHmgApp():APP331 [4] := 'Program u≈æ b√¨≈æ√≠'
         oHmgApp():APP331 [5] := '√öprava'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Storno'
         oHmgApp():APP331 [8] := 'Str.'

         // BROWSE MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP136  := { "Okno: "                                              , ;
            " nen√≠ definov√°no. Program ukon√®en"                   , ;
            "HMG Error"                                         , ;
            "Prvek: "                                             , ;
            " z "                                                  , ;
            " u≈æ definov√°n. Program ukon√®en"                  , ;
            "Browse: Typ nepovolen. Program ukon√®en"          , ;
            "Browse: Append fr√°zi nelze pou≈æ√≠t s poli nepat√∏√≠c√≠mi do Browse pracovn√≠ oblasti. Program ukon√®en", ;
            "Z√°znam edituje jin√Ω u≈æivatel"                , ;
            "Varov√°n√≠"                                              , ;
            "Chybn√Ω vstup"                                          }
         oHmgApp():APP137 := { 'Jste si jist(a)?' , 'Smazat z√°znam' }

         // EDIT MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP131   := { Chr(13)+"Smazat z√°znam"+CHR(13)+"Jste si jist(a)?"+CHR(13)                  , ;
            Chr(13)+"Chyb√≠ indexov√Ω soubor"+CHR(13)+"Nemohu hledat"+CHR(13)            , ;
            Chr(13)+"Nemohu naj√≠t indexovan√© pole"+CHR(13)+"Nemohu hledat"+CHR(13)        , ;
            Chr(13)+"Nemohu hledat podle"+CHR(13)+"pole memo nebo logick√©"+CHR(13)       , ;
            Chr(13)+"Z√°znam nenalezen"+CHR(13)                                        , ;
            Chr(13)+"P√∏√≠li≈° mnoho sloupc√π"+CHR(13)+"Sestava se nevejde na plochu"+CHR(13) }

         oHmgApp():APP132  := { "Z√°znam"      , ;
            "Po√®et z√°znam√π"         , ;
            "      (Nov√Ω)"          , ;
            "     (√öprava)"         , ;
            "Zadejte √®√≠slo z√°znamu" , ;
            "Hledej"                , ;
            "Hledan√Ω text"          , ;
            "Hledan√© datum"         , ;
            "Hledan√© √®√≠slo"         , ;
            "Definice sestavy"      , ;
            "Sloupce sestavy"       , ;
            "Dostupn√© sloupce"      , ;
            "Prvn√≠ z√°znam"          , ;
            "Posledn√≠ z√°znam"       , ;
            "Sestava "              , ;
            "Datum:"                , ;
            "Prvn√≠ z√°znam:"         , ;
            "Posledn√≠ z√°znam:"      , ;
            "T√∏√≠d√¨no dle:"          , ;
            "Ano"                   , ;
            "Ne"                    , ;
            "Strana "               , ;
            " z "                   }

         oHmgApp():APP133 := { "Zav√∏√≠t"    , ;
            "Nov√Ω"      , ;
            "√öprava"    , ;
            "Sma≈æ"      , ;
            "Najdi"     , ;
            "Jdi"       , ;
            "Sestava"   , ;
            "Prvn√≠"     , ;
            "P√∏edchoz√≠" , ;
            "Dal≈°√≠"     , ;
            "Posledn√≠"  , ;
            "Ulo≈æ"      , ;
            "Storno"    , ;
            "P√∏idej"    , ;
            "Odstra√≤"   , ;
            "Tisk"      , ;
            "Zav√∏i"     }
         oHmgApp():APP134  := { "EDIT, chyb√≠ jm√©no pracovn√≠ oblasti"                              , ;
            "EDIT, pracovn√≠ oblast m√° v√≠c jak 16 pol√≠"              , ;
            "EDIT, refresh mode mimo rozsah (pros√≠m, nahlaste chybu)"      , ;
            "EDIT, hlavn√≠ event √®√≠slo mimo rozsah (pros√≠m, nahlaste chybu)" , ;
            "EDIT, list event √®√≠slomimo rozsah (pros√≠m, nahlaste chybu)"  }

         // EDIT EXTENDED (ENGLISH DEFAULT)

         oHmgApp():APP128 := {            ;
            "&Zav√∏i",            ; // 1
            "&Nov√Ω",             ; // 2
            "√ö&prava",           ; // 3
            "S&ma≈æ  ",           ; // 4
            "Na&jdi",            ; // 5
            "&Tisk",             ; // 6
            "&Storno",           ; // 7
            "&Ok",               ; // 8
            "&Kop√≠ruj",          ; // 9
            "Aktivuj &filtr",    ; // 10
            "&Vypni filtr" }       // 11
         oHmgApp():APP129 := {                        ;
            "≈Ω√°dn√Ω",                        ; // 1
            "Z√°znam",                       ; // 2
            "Suma",                         ; // 3
            "Aktivn√≠ t√∏√≠d√¨n√≠",              ; // 4
            "Volby",                        ; // 5
            "Nov√Ω z√°znam",                  ; // 6
            "Uprav z√°znam",                 ; // 7
            "Vyber z√°znam",                 ; // 8
            "Najdi z√°znam",                 ; // 9
            "Tiskni volby",                 ; // 10
            "Dostupn√° pole",                ; // 11
            "Pole k tisku",                 ; // 12
            "Dostupn√© tisk√°rny",            ; // 13
            "Prvn√≠ z√°znam k tisku",         ; // 14
            "Posledn√≠ z√°znam k tisku",      ; // 15
            "Sma≈æ z√°znam",                  ; // 16
            "N√°hled",                       ; // 17
            "Zobraz miniatury stran",       ; // 18
            "Filtr: ",                      ; // 19
            "Filtrov√°n: ",                  ; // 20
            "Volby filtru",                 ; // 21
            "Pole datab√°ze",                ; // 22
            "Oper√°tor porovn√°n√≠",           ; // 23
            "Hodnota filtru",               ; // 24
            "Vyber pole do filtru",         ; // 25
            "Vyber oper√°tor porovn√°n√≠",     ; // 26
            "rovno",                        ; // 27
            "nerovno",                      ; // 28
            "v√¨t≈°√≠ ne≈æ",                    ; // 29
            "men≈°√≠ ne≈æ",                    ; // 30
            "v√¨t≈°√≠ nebo rovno ne≈æ",         ; // 31
            "men≈°√≠ nebo rovno ne≈æ",         } // 32

         oHmgApp():APP130 := { ;
            ABM_CRLF + "Nelze naj√≠t aktivn√≠ oblast   "  + ABM_CRLF + "Pros√≠m vyberte n√¨kterou p√∏ed vol√°n√≠m EDIT   " + ABM_CRLF,     ; // 1
            "Zadejte hodnotu pole (libovoln√Ω text)",                                                                                ; // 2
            "Zadejte hodnotu pole (libovoln√© √®√≠slo)",                                                                               ; // 3
            "Vyberte datum",                                                                                                        ; // 4
            "Zatrhn√¨te pro hodnotu true",                                                                                           ; // 5
            "Zadejte hodnotu pole",                                                                                                 ; // 6
            "Vyberte jak√Ωkoliv z√°znam s stiskn√¨te OK",                                                                              ; // 7
            ABM_CRLF + "Chcete smazat tento z√°znam  " + ABM_CRLF + "Jste si jist(a)?    " + ABM_CRLF,                               ; // 8
            ABM_CRLF + "Nen√≠ vybr√°no ≈æ√°dn√© t√∏√≠d√¨n√≠   " + ABM_CRLF + "Pros√≠m zvolte jedno   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Nelze hledat podle pole memo nebo logic   " + ABM_CRLF,                                                     ; // 10
            ABM_CRLF + "Z√°znam nenalezen   " + ABM_CRLF,                                                                            ; // 11
            "Vyberte pole k za√∏azen√≠ do seznamu",                                                                                   ; // 12
            "Vyberte pole k vy√∏azen√≠ ze seznamu",                                                                                   ; // 13
            "Vyberte tisk√°rnu",                                                                                                     ; // 14
            "Stiskn√¨te tla√®√≠tko pro za√∏azen√≠ pole",                                                                                 ; // 15
            "Stiskn√¨t√¨ tla√®√≠tko k vy√∏azen√≠ pole",                                                                                   ; // 16
            "Stiskn√¨te tla√®√≠tko k v√Ωb√¨ru prvn√≠ho z√°znamu k tisku",                                                                  ; // 17
            "Stiskn√¨t√¨ tla√®√≠tko k v√Ωb√¨ru posledn√≠ho z√°znamu k tisku",                                                               ; // 18
            ABM_CRLF + "K za√∏azen√≠ nezb√Ωvaj√≠ pole   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "Prvn√≠ v√Ωb√¨r pole k za√∏azen√≠   " + ABM_CRLF,                                                                 ; // 20
            ABM_CRLF + "Nelze vy√∏adit dal≈°√≠ pole   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "Prvn√≠ v√Ωb√¨r pole k vy√∏azen√≠   " + ABM_CRLF,                                                                 ; // 22
            ABM_CRLF + "Nebylo vybr√°no ≈æ√°dn√© pole   " + ABM_CRLF + "Pros√≠m vyberte pole pro za√∏azen√≠ do tisku   " + ABM_CRLF,       ; // 23
            ABM_CRLF + "P√∏√≠li≈° mnoho pol√≠   " + ABM_CRLF + "odeberte n√¨kter√° pole   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Tisk√°rna nen√≠ p√∏ipravena   " + ABM_CRLF,                                                                    ; // 25
            "T√∏√≠d√¨no dle",                                                                                                          ; // 26
            "Od z√°znamu",                                                                                                           ; // 27
            "Do z√°znamu",                                                                                                           ; // 28
            "Ano",                                                                                                                  ; // 29
            "Ne",                                                                                                                   ; // 30
            "Strana:",                                                                                                              ; // 31
            ABM_CRLF + "Pros√≠m vyberte tisk√°rnu   " + ABM_CRLF,                                                                     ; // 32
            "Filtrov√°no dle",                                                                                                       ; // 33
            ABM_CRLF + "Filtr nen√≠ aktivn√≠    " + ABM_CRLF,                                                                         ; // 34
            ABM_CRLF + "Nelze filtrovat podle memo    " + ABM_CRLF,                                                                 ; // 35
            ABM_CRLF + "Vyberte pole do filtru    " + ABM_CRLF,                                                                     ; // 36
            ABM_CRLF + "Vybarte oper√°tor do filtru    " + ABM_CRLF,                                                                 ; // 37
            ABM_CRLF + "Zadejte hodnotu do filtru    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "Nen√≠ ≈æ√°dn√Ω aktivn√≠ filtr    " + ABM_CRLF,                                                                   ; // 39
            ABM_CRLF + "Deactivovat filtr?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Z√°znam uzam√®en jin√Ωm u≈æivatelem  " + ABM_CRLF                                                                   } // 41

         /////////////////////////////////////////////////////////////
         // CROATIAN
         ////////////////////////////////////////////////////////////
         // case cLang == "HR852" // Croatian
      CASE cLang == "HR"

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Zatvori prozor'
         oHmgApp():APP331 [3] := 'Zatvaranje nije dozvoljeno'
         oHmgApp():APP331 [4] := 'Program je ve√¶ pokrenut'
         oHmgApp():APP331 [5] := 'Uredi'
         oHmgApp():APP331 [6] := 'U redu'
         oHmgApp():APP331 [7] := 'Prekid'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED MESSAGES

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

      CASE cLang == "EU"        // Basque.
         /////////////////////////////////////////////////////////////
         // BASQUE
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Close Window'
         oHmgApp():APP331 [3] := 'Close not allowed'
         oHmgApp():APP331 [4] := 'Program Already Running'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancel'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            "&Itxi",             ; // 1
            "&Berria",           ; // 2
            "&Aldatu",           ; // 3
            "&Ezabatu",          ; // 4
            "Bi&latu",           ; // 5
            "In&primatu",        ; // 6
            "&Utzi",             ; // 7
            "&Ok",               ; // 8
            "&Kopiatu",          ; // 9
            "I&ragazkia Ezarri", ; // 10
            "Ira&gazkia Kendu"   } // 11
         oHmgApp():APP129 := {                              ;
            "Bat ere ez",                         ; // 1
            "Erregistroa",                        ; // 2
            "Guztira",                            ; // 3
            "Orden Aktiboa",                      ; // 4
            "Aukerak",                            ; // 5
            "Erregistro Berria",                  ; // 6
            "Erregistroa Aldatu",                 ; // 7
            "Erregistroa Aukeratu",               ; // 8
            "Erregistroa Bilatu",                 ; // 9
            "Inprimatze-aukerak",                 ; // 10
            "Eremu Libreak",                      ; // 11
            "Inprimatzeko Eremuak",               ; // 12
            "Inprimagailu Libreak",               ; // 13
            "Inprimatzeko Lehenengo Erregistroa", ; // 14
            "Inprimatzeko Azken Erregistroa",     ; // 15
            "Erregistroa Ezabatu",                ; // 16
            "Aurreikusi",                         ; // 17
            "Orrien Irudi Txikiak Ikusi",         ; // 18
            "Iragazkiaren Baldintza: ",           ; // 19
            "Iragazita: ",                        ; // 20
            "Iragazte-aukerak" ,                  ; // 21
            "Datubasearen Eremuak" ,              ; // 22
            "Konparaketa Eragilea",               ; // 23
            "Iragazkiaren Balioa",                ; // 24
            "Iragazteko Eremua Aukeratu",         ; // 25
            "Konparaketa Eragilea Aukeratu",      ; // 26
            "Berdin",                             ; // 27
            "Ezberdin",                           ; // 28
            "Handiago",                           ; // 29
            "Txikiago",                           ; // 30
            "Handiago edo Berdin",                ; // 31
            "Txikiago edo Berdin"                 } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Ezin da area aktiborik aurkitu.   "  + ABM_CRLF + "Mesedez aukeratu area EDIT deitu baino lehen   " + ABM_CRLF,  ; // 1
            "Eremuaren balioa idatzi (edozein testu)",                                                                                   ; // 2
            "Eremuaren balioa idatzi (edozein zenbaki)",                                                                                 ; // 3
            "Data aukeratu",                                                                                                             ; // 4
            "Markatu egiazko baliorako",                                                                                                 ; // 5
            "Eremuaren balioa sartu",                                                                                                    ; // 6
            "Edozein erregistro aukeratu eta OK sakatu",                                                                                 ; // 7
            ABM_CRLF + "Erregistro aktiboa ezabatuko duzu   " + ABM_CRLF + "Ziur zaude?    " + ABM_CRLF,                                 ; // 8
            ABM_CRLF + "Ez dago orden aktiborik   " + ABM_CRLF + "Mesedez aukeratu bat   " + ABM_CRLF,                                   ; // 9
            ABM_CRLF + "Memo edo eremu logikoen arabera ezin bilaketarik egin   " + ABM_CRLF,                                            ; // 10
            ABM_CRLF + "Erregistroa ez da aurkitu   " + ABM_CRLF,                                                                        ; // 11
            "Zerrendan sartzeko eremua aukeratu",                                                                                        ; // 12
            "Zerrendatik kentzeko eremua aukeratu",                                                                                      ; // 13
            "Inprimagailua aukeratu",                                                                                                    ; // 14
            "Sakatu botoia eremua sartzeko",                                                                                             ; // 15
            "Sakatu botoia eremua kentzeko",                                                                                             ; // 16
            "Sakatu botoia inprimatzeko lehenengo erregistroa aukeratzeko",                                                              ; // 17
            "Sakatu botoia inprimatzeko azken erregistroa aukeratzeko",                                                                  ; // 18
            ABM_CRLF + "Sartzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 19
            ABM_CRLF + "Lehenago aukeratu sartzeko eremua   " + ABM_CRLF,                                                                ; // 20
            ABM_CRLF + "Kentzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 21
            ABM_CRLF + "Lehenago aukeratu kentzeko eremua   " + ABM_CRLF,                                                                ; // 22
            ABM_CRLF + "Ez duzu eremurik aukeratu  " + ABM_CRLF + "Mesedez aukeratu inprimaketan sartzeko eremuak   " + ABM_CRLF,        ; // 23
            ABM_CRLF + "Eremu gehiegi   " + ABM_CRLF + "Murriztu eremu kopurua   " + ABM_CRLF,                                           ; // 24
            ABM_CRLF + "Inprimagailua ez dago prest   " + ABM_CRLF,                                                                      ; // 25
            "Ordenatuta honen arabera:",                                                                                                 ; // 26
            "Erregistro honetatik:",                                                                                                     ; // 27
            "Erregistro honetara:",                                                                                                      ; // 28
            "Bai",                                                                                                                       ; // 29
            "Ez",                                                                                                                        ; // 30
            "Orrialdea:",                                                                                                                ; // 31
            ABM_CRLF + "Mesedez aukeratu inprimagailua   " + ABM_CRLF,                                                                   ; // 32
            "Iragazita honen arabera:",                                                                                                  ; // 33
            ABM_CRLF + "Iragazki aktiboa dago    " + ABM_CRLF,                                                                           ; // 34
            ABM_CRLF + "Ezin iragazi Memo eremuen arabera    " + ABM_CRLF,                                                               ; // 35
            ABM_CRLF + "Iragazteko eremua aukeratu    " + ABM_CRLF,                                                                      ; // 36
            ABM_CRLF + "Iragazteko edozein eragile aukeratu    " + ABM_CRLF,                                                             ; // 37
            ABM_CRLF + "Idatzi edozein balio iragazteko    " + ABM_CRLF,                                                                 ; // 38
            ABM_CRLF + "Ez dago iragazki aktiborik    " + ABM_CRLF,                                                                      ; // 39
            ABM_CRLF + "Iragazkia kendu?   " + ABM_CRLF,                                                                                  ; // 40
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

      CASE cLang == "EN"        // English
         /////////////////////////////////////////////////////////////
         // ENGLISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Close Window'
         oHmgApp():APP331 [3] := 'Close not allowed'
         oHmgApp():APP331 [4] := 'Program Already Running'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancel'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED (ENGLISH DEFAULT)

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

      CASE cLang == "FR"        // French
         /////////////////////////////////////////////////////////////
         // FRENCH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Etes-vous s√ªre ?'
         oHmgApp():APP331 [2] := 'Fermer la fen√™tre'
         oHmgApp():APP331 [3] := 'Fermeture interdite'
         oHmgApp():APP331 [4] := 'Programme d√©j√† activ√©'
         oHmgApp():APP331 [5] := 'Editer'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Abandonner'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Fen√™tre: "                                             , ;
            " n'est pas d√©finie. Programme termin√©"                 , ;
            "Erreur HMG"                                        , ;
            "Contr√¥le: "                                            , ;
            " De "                                                  , ;
            " D√©j√† d√©fini. Programme termin√©"                       , ;
            "Modification: Type non autoris√©. Programme termin√©"    , ;
            "Modification: La clause Ajout ne peut √™tre utilis√©e avec des champs n'appartenant pas √† la zone de travail de Modification. Programme termin√©", ;
            "L'enregistrement est utilis√© par un autre utilisateur"  , ;
            "Erreur"                                                , ;
            "Entr√©e invalide"                                        }
         oHmgApp():APP137 := { 'Etes-vous s√ªre ?' , 'Enregistrement d√©truit' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Suppression d'enregistrement"+CHR(13)+"Etes-vous s√ªre ?"+CHR(13)  , ;
            Chr(13)+"Index manquant"+CHR(13)+"Recherche impossible"+CHR(13)            , ;
            Chr(13)+"Champ Index introuvable"+CHR(13)+"Recherche impossible"+CHR(13)   , ;
            Chr(13)+"Recherche impossible"+CHR(13)+"sur champs memo ou logique"+CHR(13), ;
            Chr(13)+"Enregistrement non trouv√©"+CHR(13)                                                     , ;
            Chr(13)+"Trop de colonnes"+CHR(13)+"L'√©tat ne peut √™tre imprim√©"+CHR(13)      }
         oHmgApp():APP132  := { "Enregistrement"                       , ;
            "Nb. total enr."                       , ;
            "   (Ajouter)"                        , ;
            "  (Modifier)"                        , ;
            "Entrez le num√©ro de l'enregistrement" , ;
            "Trouver"                              , ;
            "Chercher texte"                       , ;
            "Chercher date"                        , ;
            "Chercher num√©ro"                      , ;
            "D√©finition de l'√©tat"                 , ;
            "Colonnes de l'√©tat"                   , ;
            "Colonnes disponibles"                 , ;
            "Enregistrement de d√©but"              , ;
            "Enregistrement de fin"                , ;
            "Etat de "                             , ;
            "Date:"                                , ;
            "Enregistrement de d√©but:"             , ;
            "Enregistrement de fin:"               , ;
            "Tri√© par:"                            , ;
            "Oui"                                  , ;
            "Non"                                  , ;
            " Page"                                , ;
            " de "                                 }
         oHmgApp():APP133 := { "Fermer"      , ;
            "Nouveau"     , ;
            "Modifier"    , ;
            "Supprimer"   , ;
            "Trouver"     , ;
            "Aller √†"     , ;
            "Etat"   , ;
            "Premier"     , ;
            "Pr√©c√©dent"   , ;
            "Suivant"     , ;
            "Dernier"     , ;
            "Enregistrer" , ;
            "Annuler"     , ;
            "Ajouter"     , ;
            "Retirer"     , ;
            "Imprimer"    , ;
            "Fermer"      }
         oHmgApp():APP134  := { "EDIT, nom de la table manquant"                                         , ;
            "EDIT, la table a plus de 16 champs"                                     , ;
            "EDIT, mode rafraichissement hors limite (Rapport d'erreur merci)"       , ;
            "EDIT, √©v√©nement principal nombre hors limite (Rapport d'erreur merci)"  , ;
            "EDIT, liste d'√©v√©nements nombre hors limite (Rapport d'erreur merci)"   }

         // EDIT EXTENDED

         oHmgApp():APP128 := {           ;
            "&Fermer",          ; // 1
            "&Nouveau",         ; // 2
            "&Modifier",        ; // 3
            "&Supprimer",       ; // 4
            "&Trouver",         ; // 5
            "&Imprimer",        ; // 6
            "&Abandon",         ; // 7
            "&Ok",              ; // 8
            "&Copier",          ; // 9
            "&Activer Filtre",  ; // 10
            "&D√©activer Filtre" } // 11
         oHmgApp():APP129 := {                                   ;
            "Aucun",                                   ; // 1
            "Enregistrement",                          ; // 2
            "Total",                                   ; // 3
            "Ordre actif",                             ; // 4
            "Options",                                 ; // 5
            "Nouvel enregistrement",                   ; // 6
            "Modifier enregistrement",                 ; // 7
            "Selectionner enregistrement",             ; // 8
            "Trouver enregistrement",                  ; // 9
            "Imprimer options",                        ; // 10
            "Champs disponibles",                      ; // 11
            "Champs √† imprimer",                       ; // 12
            "Imprimantes connect√©es",                  ; // 13
            "Premier enregistrement √† imprimer",       ; // 14
            "Dernier enregistrement √† imprimer",       ; // 15
            "Enregistrement supprim√©",                 ; // 16
            "Pr√©visualisation",                        ; // 17
            "Aper√ßu pages",                            ; // 18
            "Condition filtre : ",                     ; // 19
            "Filtr√© : ",                               ; // 20
            "Options de filtrage" ,                    ; // 21
            "Champs de la Bdd" ,                       ; // 22
            "Op√©rateurs de comparaison",               ; // 23
            "Valeur du filtre",                        ; // 24
            "Selectionner le champ √† filtrer",         ; // 25
            "Selectionner l'op√©rateur de comparaison", ; // 26
            "Egal",                                    ; // 27
            "Diff√©rent",                               ; // 28
            "Plus grand",                              ; // 29
            "Plus petit",                              ; // 30
            "Plus grand ou √©gal",                      ; // 31
            "Plus petit ou √©gal"                       } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Ne peut trouver une base active.   "  + ABM_CRLF + "S√©lectionner une base avant la fonction EDIT  " + ABM_CRLF,           ; // 1
            "Entrer la valeur du champ (du texte)",                                                                                               ; // 2
            "Entrer la valeur du champ (un nombre)",                                                                                              ; // 3
            "S√©lectionner la date",                                                                                                               ; // 4
            "V√©rifier la valeur logique",                                                                                                         ; // 5
            "Entrer la valeur du champ",                                                                                                          ; // 6
            "S√©lectionner un enregistrement et appuyer sur OK",                                                                                   ; // 7
            ABM_CRLF + "Vous voulez d√©truire l'enregistrement actif  " + ABM_CRLF + "Etes-vous s√ªre?   " + ABM_CRLF,                              ; // 8
            ABM_CRLF + "Il n'y a pas d'ordre actif   " + ABM_CRLF + "S√©lectionner en un   " + ABM_CRLF,                                           ; // 9
            ABM_CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + ABM_CRLF,                                                      ; // 10
            ABM_CRLF + "Enregistrement non trouv√©  " + ABM_CRLF,                                                                                  ; // 11
            "S√©lectionner le champ √† inclure √† la liste",                                                                                         ; // 12
            "S√©lectionner le champ √† exclure de la liste",                                                                                        ; // 13
            "S√©lectionner l'imprimante",                                                                                                          ; // 14
            "Appuyer sur le bouton pour inclure un champ",                                                                                        ; // 15
            "Appuyer sur le bouton pour exclure un champ",                                                                                        ; // 16
            "Appuyer sur le bouton pour s√©lectionner le premier enregistrement √† imprimer",                                                       ; // 17
            "Appuyer sur le bouton pour s√©lectionner le dernier champ √† imprimer",                                                                ; // 18
            ABM_CRLF + "Plus de champs √† inclure   " + ABM_CRLF,                                                                                  ; // 19
            ABM_CRLF + "S√©lectionner d'abord les champs √† inclure   " + ABM_CRLF,                                                                 ; // 20
            ABM_CRLF + "Plus de champs √† exclure   " + ABM_CRLF,                                                                                  ; // 21
            ABM_CRLF + "S√©lectionner d'abord les champs √† exclure   " + ABM_CRLF,                                                                 ; // 22
            ABM_CRLF + "Vous n'avez s√©lectionn√© aucun champ   " + ABM_CRLF + "S√©lectionner les champs √† inclure dans l'impression   " + ABM_CRLF, ; // 23
            ABM_CRLF + "Trop de champs   " + ABM_CRLF + "R√©duiser le nombre de champs   " + ABM_CRLF,                                             ; // 24
            ABM_CRLF + "Imprimante pas pr√™te   " + ABM_CRLF,                                                                                      ; // 25
            "Tri√© par",                                                                                                                           ; // 26
            "De l'enregistrement",                                                                                                                ; // 27
            "A l'enregistrement",                                                                                                                 ; // 28
            "Oui",                                                                                                                                ; // 29
            "Non",                                                                                                                                ; // 30
            "Page:",                                                                                                                              ; // 31
            ABM_CRLF + "S√©lectionner une imprimante   " + ABM_CRLF,                                                                               ; // 32
            "Filtr√© par",                                                                                                                         ; // 33
            ABM_CRLF + "Il y a un filtre actif    " + ABM_CRLF,                                                                                   ; // 34
            ABM_CRLF + "Filtre impossible sur champ memo    " + ABM_CRLF,                                                                         ; // 35
            ABM_CRLF + "S√©lectionner un champ de filtre    " + ABM_CRLF,                                                                          ; // 36
            ABM_CRLF + "S√©lectionner un op√©rateur de filtre   " + ABM_CRLF,                                                                       ; // 37
            ABM_CRLF + "Entrer une valeur au filtre    " + ABM_CRLF,                                                                              ; // 38
            ABM_CRLF + "Il n'y a aucun filtre actif    " + ABM_CRLF,                                                                              ; // 39
            ABM_CRLF + "D√©sactiver le filtre?   " + ABM_CRLF,                                                                                     ; // 40
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

         // case cLang == "DEWIN" .OR. cLang == "DE"       // German
      CASE cLang == "DE"
         /////////////////////////////////////////////////////////////
         // GERMAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Sind Sie sicher ?'
         oHmgApp():APP331 [2] := 'Fenster schlie√üen'
         oHmgApp():APP331 [3] := 'Schlie√üen nicht erlaubt'
         oHmgApp():APP331 [4] := 'Programm l√§uft bereits'
         oHmgApp():APP331 [5] := 'Bearbeiten'
         oHmgApp():APP331 [6] := 'OK'
         oHmgApp():APP331 [7] := 'Abbrechen'
         oHmgApp():APP331 [8] := 'Seite'

         // BROWSE

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Sind Sie sicher ?' , 'Datensatz l√∂schen' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Datensatz loeschen"+CHR(13)+"Sind Sie sicher ?"+CHR(13)                 , ;
            Chr(13)+" Falscher Indexdatensatz"+CHR(13)+"Suche unmoeglich"+CHR(13)         , ;
            Chr(13)+"Man kann nicht Indexdatenfeld finden"+CHR(13)+"Suche unmoeglich"+CHR(13) , ;
            Chr(13)+"Suche unmoeglich nach"+CHR(13)+"Feld memo oder logisch"+CHR(13)         , ;
            Chr(13)+"Datensatz nicht gefunden"+CHR(13)                                                     , ;
            Chr(13)+" zu viele Spalten"+CHR(13)+"Zu wenig Platz  fuer die Meldung auf dem Blatt" + Chr(13) }
         oHmgApp():APP132  := { "Datensatz"              , ;
            "Menge der Dat."        , ;
            "       (Neu)"        , ;
            " (Editieren)"        , ;
            "Datensatznummer eintragen" , ;
            "Suche"                , ;
            "Suche Text"         , ;
            "Suche Datum"         , ;
            "Suche Zahl"       , ;
            "Definition der Meldung"   , ;
            "Spalten der Meldung"      , ;
            "Zugaengliche Spalten"     , ;
            "Anfangsdatensatz"      , ;
            "Endedatensatz"        , ;
            "Datensatz vom "          , ;
            "Datum:"               , ;
            "Anfangsdatensatz:"     , ;
            "Endedatensatz:"       , ;
            "Sortieren nach:"         , ;
            "Ja"                 , ;
            "Nein"                  , ;
            "Seite "               , ;
            " von "                 }
         oHmgApp():APP133 := { "Schliesse"    , ;
            "Neu"      , ;
            "Editiere"     , ;
            "Loesche"   , ;
            "Finde"     , ;
            "Gehe zu"     , ;
            "Meldung"   , ;
            "Erster"    , ;
            "Zurueck" , ;
            "Naechst"     , ;
            "Letzter"     , ;
            "Speichern"     , ;
            "Aufheben"   , ;
            "Hinzufuegen"      , ;
            "Loeschen"   , ;
            "Drucken"    , ;
            "Schliessen"     }
         oHmgApp():APP134  := { "EDIT, falscher Name von Datenbank"                                  , ;
            "EDIT, Datenbank hat mehr als 16 Felder"                   , ;
            "EDIT, Auffrische-Modus ausser dem Bereich (siehe Fehlermeldungen)"      , ;
            "EDIT, Menge der Basisereignisse ausser dem Bereich (siehe Fehlermeldungen)" , ;
            "EDIT, Liste der Ereignisse ausser dem Bereich (siehe Fehlermeldungen)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {              ;
            "S&chlie√üen",          ; // 1
            "&Neu",                ; // 2
            "&Bearbeiten",         ; // 3
            "&L√∂schen",            ; // 4
            "&Suchen",             ; // 5
            "&Drucken",            ; // 6
            "&Abbruch",            ; // 7
            "&Ok",                 ; // 8
            "&Kopieren",           ; // 9
            "&Filter aktivieren",  ; // 10
            "&Filter deaktivieren" } // 11
         oHmgApp():APP129 := {                                         ;
            "Keine",                                         ; // 1
            "Datensatz",                                     ; // 2
            "Gesamt",                                        ; // 3
            "Aktive Sortierung",                             ; // 4
            "Einstellungen",                                 ; // 5
            "Neuer Datensatz",                               ; // 6
            "Datensatz bearbeiten",                          ; // 7
            "Datensatz ausw√§hlen",                           ; // 8
            "Datensatz finden",                              ; // 9
            "Druckeinstellungen",                            ; // 10
            "Verf√ºgbare Felder",                             ; // 11
            "Zu druckende Felder",                           ; // 12
            "Verf√ºgbare Drucker",                            ; // 13
            "Erster zu druckender Datensatz",                ; // 14
            "Letzter zu druckender Datensatz",               ; // 15
            "Datensatz l√∂schen",                             ; // 16
            "Vorschau",                                      ; // 17
            "√úbersicht",                                     ; // 18
            "Filterbedingung: ",                             ; // 19
            "Gefiltert: ",                                   ; // 20
            "Filter-Einstellungen" ,                         ; // 21
            "Datenbank-Felder" ,                             ; // 22
            "Vergleichs-Operator",                           ; // 23
            "Filterwert",                                    ; // 24
            "Zu filterndes Feld ausw√§hlen",                  ; // 25
            "Vergleichs-Operator ausw√§hlen",                 ; // 26
            "Gleich",                                        ; // 27
            "Ungleich",                                      ; // 28
            "Gr√∂√üer als",                                    ; // 29
            "Kleiner als",                                   ; // 30
            "Gr√∂√üer oder gleich als",                        ; // 31
            "Kleiner oder gleich als"                        } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Kein aktiver Arbeitsbereich gefunden.   "  + ABM_CRLF + "Bitte einen Arbeitsbereich ausw√§hlen vor dem Aufruf von EDIT   " + ABM_CRLF,       ; // 1
            "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 2
            "Eine Zahl eingeben",                                                                                                                                   ; // 3
            "Datum ausw√§hlen",                                                                                                                                      ; // 4
            "F√ºr positive Auswahl einen Haken setzen",                                                                                                              ; // 5
            "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 6
            "Einen Datensatz w√§hlen und mit OK best√§tigen",                                                                                                         ; // 7
            ABM_CRLF + "Sie sind im Begriff, den aktiven Datensatz zu l√∂schen.   " + ABM_CRLF + "Sind Sie sicher?    " + ABM_CRLF,                                  ; // 8
            ABM_CRLF + "Es ist keine Sortierung aktiv.   " + ABM_CRLF + "Bitte w√§hlen Sie eine Sortierung   " + ABM_CRLF,                                           ; // 9
            ABM_CRLF + "Suche nach den Feldern memo oder logisch nicht m√∂glich.   " + ABM_CRLF,                                                                     ; // 10
            ABM_CRLF + "Datensatz nicht gefunden   " + ABM_CRLF,                                                                                                    ; // 11
            "Bitte ein Feld zum Hinzuf√ºgen zur Liste w√§hlen",                                                                                                       ; // 12
            "Bitte ein Feld zum Entfernen aus der Liste w√§hlen ",                                                                                                   ; // 13
            "Drucker ausw√§hlen",                                                                                                                                    ; // 14
            "Schaltfl√§che  Feld hinzuf√ºgen",                                                                                                                        ; // 15
            "Schaltfl√§che  Feld Entfernen",                                                                                                                         ; // 16
            "Schaltfl√§che  Auswahl erster zu druckender Datensatz",                                                                                                 ; // 17
            "Schaltfl√§che  Auswahl letzte zu druckender Datensatz",                                                                                                 ; // 18
            ABM_CRLF + "Keine Felder zum Hinzuf√ºgen mehr vorhanden   " + ABM_CRLF,                                                                                  ; // 19
            ABM_CRLF + "Bitte erst ein Feld zum Hinzuf√ºgen w√§hlen   " + ABM_CRLF,                                                                                   ; // 20
            ABM_CRLF + "Keine Felder zum Entfernen vorhanden   " + ABM_CRLF,                                                                                        ; // 21
            ABM_CRLF + "Bitte ein Feld zum Entfernen w√§hlen   " + ABM_CRLF,                                                                                         ; // 22
            ABM_CRLF + "Kein Feld ausgew√§hlt   " + ABM_CRLF + "Bitte die Felder f√ºr den Ausdruck ausw√§hlen   " + ABM_CRLF,                                          ; // 23
            ABM_CRLF + "Zu viele Felder   " + ABM_CRLF + "Bitte Anzahl der Felder reduzieren   " + ABM_CRLF,                                                        ; // 24
            ABM_CRLF + "Drucker nicht bereit   " + ABM_CRLF,                                                                                                        ; // 25
            "Sortiert nach",                                                                                                                                        ; // 26
            "Von Datensatz",                                                                                                                                        ; // 27
            "Bis Datensatz",                                                                                                                                        ; // 28
            "Ja",                                                                                                                                                   ; // 29
            "Nein",                                                                                                                                                 ; // 30
            "Seite:",                                                                                                                                               ; // 31
            ABM_CRLF + "Bitte einen Drucker w√§hlen   " + ABM_CRLF,                                                                                                  ; // 32
            "Filtered by",                                                                                                                                          ; // 33
            ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 34
            ABM_CRLF + "Kann nicht nach Memo-Feldern filtern    " + ABM_CRLF,                                                                                       ; // 35
            ABM_CRLF + "Feld zum Filtern ausw√§hlen    " + ABM_CRLF,                                                                                                 ; // 36
            ABM_CRLF + "Einen Operator zum Filtern ausw√§hlen    " + ABM_CRLF,                                                                                       ; // 37
            ABM_CRLF + "Bitte einen Wert f√ºr den Filter angeben    " + ABM_CRLF,                                                                                    ; // 38
            ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 39
            ABM_CRLF + "Filter deaktivieren?   " + ABM_CRLF,                                                                                                         ; // 40
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

      CASE cLang == "IT"        // Italian
         /////////////////////////////////////////////////////////////
         // ITALIAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Sei sicuro ?'
         oHmgApp():APP331 [2] := 'Chiudi la finestra'
         oHmgApp():APP331 [3] := 'Chiusura non consentita'
         oHmgApp():APP331 [4] := 'Il programma √® gi√† in esecuzione'
         oHmgApp():APP331 [5] := 'Edita'
         oHmgApp():APP331 [6] := 'Conferma'
         oHmgApp():APP331 [7] := 'Annulla'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Window: " , ;
            " non ≈† definita. Programma terminato" , ;
            "Errore HMG"  , ;
            "Controllo: " , ;
            " Di " , ;
            " Gi‚Ä¶ definito. Programma Terminato" , ;
            "Browse: Tipo non valido. Programma Terminato"  , ;
            "Browse: Modifica non possibile: il campo non ≈† pertinente l'area di lavoro.Programma Terminato", ;
            "Record gi‚Ä¶ utilizzato da altro utente"                 , ;
            "Attenzione!"                                           , ;
            "Dato non valido" }
         oHmgApp():APP137 := { 'Sei sicuro ?' , 'Cancella Record' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Cancellare il record"+CHR(13)+"Sei sicuro ?"+CHR(13)                  , ;
            Chr(13)+"File indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)            , ;
            Chr(13)+"Campo indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)        , ;
            Chr(13)+"Ricerca impossibile per"+CHR(13)+"campi memo o logici"+CHR(13)       , ;
            Chr(13)+"Record non trovato"+CHR(13)                                        , ;
            Chr(13)+"Troppe colonne"+CHR(13)+"Il report non pu√≤ essere stampato"+CHR(13) }
         oHmgApp():APP132  := { "Record"              , ;
            "Record totali"       , ;
            "  (Aggiungi)"        , ;
            "     (Nuovo)"        , ;
            "Inserire il numero del record" , ;
            "Ricerca"                , ;
            "Testo da cercare"         , ;
            "Data da cercare"         , ;
            "Numero da cercare"       , ;
            "Definizione del report"   , ;
            "Colonne del report"      , ;
            "Colonne totali"     , ;
            "Record Iniziale"      , ;
            "Record Finale"        , ;
            "Report di "          , ;
            "Data:"               , ;
            "Primo Record:"     , ;
            "Ultimo Record:"       , ;
            "Ordinare per:"         , ;
            "S√¨"                 , ;
            "No"                  , ;
            "Pagina "               , ;
            " di "                 }
         oHmgApp():APP133 := { "Chiudi"    , ;
            "Nuovo"      , ;
            "Modifica"     , ;
            "Cancella"   , ;
            "Ricerca"     , ;
            "Vai a"     , ;
            "Report"   , ;
            "Primo"    , ;
            "Precedente" , ;
            "Successivo"     , ;
            "Ultimo"     , ;
            "Salva"     , ;
            "Annulla"   , ;
            "Aggiungi"      , ;
            "Rimuovi"   , ;
            "Stampa"    , ;
            "Chiudi"     }
         oHmgApp():APP134  := { "EDIT, il nome dell'area √® mancante"                              , ;
            "EDIT, quest'area contiene pi√π di 16 campi"              , ;
            "EDIT, modalit√† aggiornamento fuori dal limite (segnalare l'errore)"      , ;
            "EDIT, evento pricipale fuori dal limite (segnalare l'errore)" , ;
            "EDIT, lista eventi fuori dal limite (segnalare l'errore)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {           ;
            "&Chiudi",          ; // 1
            "&Nuovo",           ; // 2
            "&Modifica",        ; // 3
            "&Cancella",        ; // 4
            "&Trova",           ; // 5
            "&Stampa",          ; // 6
            "&Annulla",         ; // 7
            "&Ok",              ; // 8
            "C&opia",           ; // 9
            "A&ttiva Filtro",   ; // 10
            "&Disattiva Filtro" } // 11
         oHmgApp():APP129 := {                            ;
            "Nessuno",                          ; // 1
            "Record",                           ; // 2
            "Totale",                           ; // 3
            "Ordinamento attivo",               ; // 4
            "Opzioni",                          ; // 5
            "Nuovo record",                     ; // 6
            "Modifica record",                  ; // 7
            "Seleziona record",                 ; // 8
            "Trova record",                     ; // 9
            "Stampa opzioni",                   ; // 10
            "Campi disponibili",                ; // 11
            "Campi da stampare",                ; // 12
            "Stampanti disponibili",            ; // 13
            "Primo  record da stampare",        ; // 14
            "Ultimo record da stampare",        ; // 15
            "Cancella record",                  ; // 16
            "Anteprima",                        ; // 17
            "Visualizza pagina miniature",      ; // 18
            "Condizioni Filtro: ",              ; // 19
            "Filtrato: ",                       ; // 20
            "Opzioni Filtro" ,                  ; // 21
            "Campi del Database" ,              ; // 22
            "Operatori di comparazione",        ; // 23
            "Valore Filtro",                    ; // 24
            "Seleziona campo da filtrare",      ; // 25
            "Seleziona operatore comparazione", ; // 26
            "Uguale",                           ; // 27
            "Non Uguale",                       ; // 28
            "Maggiore di",                      ; // 29
            "Minore di",                        ; // 30
            "Maggiore o uguale a",              ; // 31
            "Minore o uguale a"                 } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Nessuna area attiva.   "  + ABM_CRLF + "Selezionare un'area prima della chiamata a EDIT   " + ABM_CRLF,  ; // 1
            "Digitare valore campo (testo)",                                                                                     ; // 2
            "Digitare valore campo (numerico)",                                                                                  ; // 3
            "Selezionare data",                                                                                                  ; // 4
            "Attivare per valore TRUE",                                                                                          ; // 5
            "Inserire valore campo",                                                                                             ; // 6
            "Seleziona un record and premi OK",                                                                                  ; // 7
            ABM_CRLF + "Cancellazione record attivo   " + ABM_CRLF + "Sei sicuro?      " + ABM_CRLF,                             ; // 8
            ABM_CRLF + "Nessun ordinamento attivo     " + ABM_CRLF + "Selezionarne uno " + ABM_CRLF,                             ; // 9
            ABM_CRLF + "Ricerca non possibile su campi MEMO o LOGICI   " + ABM_CRLF,                                             ; // 10
            ABM_CRLF + "Record non trovato   " + ABM_CRLF,                                                                       ; // 11
            "Seleziona campo da includere nel listato",                                                                          ; // 12
            "Seleziona campo da escludere dal listato",                                                                          ; // 13
            "Selezionare la stampante",                                                                                          ; // 14
            "Premi per includere il campo",                                                                                      ; // 15
            "Premi per escludere il campo",                                                                                      ; // 16
            "Premi per selezionare il primo record da stampare",                                                                 ; // 17
            "Premi per selezionare l'ultimo record da stampare",                                                                 ; // 18
            ABM_CRLF + "Nessun altro campo da inserire   " + ABM_CRLF,                                                           ; // 19
            ABM_CRLF + "Prima seleziona il campo da includere " + ABM_CRLF,                                                      ; // 20
            ABM_CRLF + "Nessun altro campo da escludere       " + ABM_CRLF,                                                      ; // 21
            ABM_CRLF + "Prima seleziona il campo da escludere " + ABM_CRLF,                                                      ; // 22
            ABM_CRLF + "Nessun campo selezionato     " + ABM_CRLF + "Selezionare campi da includere nel listato   " + ABM_CRLF,  ; // 23
            ABM_CRLF + "Troppi campi !   " + ABM_CRLF + "Redurre il numero di campi   " + ABM_CRLF,                              ; // 24
            ABM_CRLF + "Stampante non pronta..!   " + ABM_CRLF,                                                                  ; // 25
            "Ordinato per",                                                                                                      ; // 26
            "Dal record",                                                                                                        ; // 27
            "Al  record",                                                                                                        ; // 28
            "Si",                                                                                                                ; // 29
            "No",                                                                                                                ; // 30
            "Pagina:",                                                                                                           ; // 31
            ABM_CRLF + "Selezionare una stampante   " + ABM_CRLF,                                                                ; // 32
            "Filtrato per ",                                                                                                     ; // 33
            ABM_CRLF + "Esiste un filtro attivo     " + ABM_CRLF,                                                                ; // 34
            ABM_CRLF + "Filtro non previsto per campi MEMO   " + ABM_CRLF,                                                       ; // 35
            ABM_CRLF + "Selezionare campo da filtrare        " + ABM_CRLF,                                                       ; // 36
            ABM_CRLF + "Selezionare un OPERATORE per filtro  " + ABM_CRLF,                                                       ; // 37
            ABM_CRLF + "Digitare un valore per filtro        " + ABM_CRLF,                                                       ; // 38
            ABM_CRLF + "Nessun filtro attivo    " + ABM_CRLF,                                                                    ; // 39
            ABM_CRLF + "Disattivare filtro ?   " + ABM_CRLF,                                                                     ; // 40
            ABM_CRLF + "Record bloccato da altro utente" + ABM_CRLF                                                              } // 41

         // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish
      CASE cLang == "PL"
         /////////////////////////////////////////////////////////////
         // POLISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Czy jeste≈ì pewny ?'
         oHmgApp():APP331 [2] := 'Zamknij okno'
         oHmgApp():APP331 [3] := 'Zamkni√™cie niedozwolone'
         oHmgApp():APP331 [4] := 'Program ju¬ø uruchomiony'
         oHmgApp():APP331 [5] := 'Edycja'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Porzu√¶'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Okno: "                                              , ;
            " nie zdefiniowane.Program zako√±czony"         , ;
            "B¬≥¬πd HMG"                                         , ;
            "Kontrolka: "                                             , ;
            " z "                                                  , ;
            " ju¬ø zdefiniowana. Program zako√±czony"                  , ;
            "Browse: Niedozwolony typ danych. Program zako√±czony"          , ;
            "Browse: Klauzula Append nie mo¬øe by√¶ stosowana do p√≥l nie nale¬ø¬πcych do aktualnego obszaru roboczego. Program zako√±czony", ;
            "Rekord edytowany przez innego u¬øytkownika"                , ;
            "Ostrze¬øenie"                                               , ;
            "Nieprawid¬≥owy wpis"                                          }
         oHmgApp():APP137 := { 'Czy jesteo pewny ?' , 'Skasuj rekord' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Usuni¬©cie rekordu"+CHR(13)+"JesteÀú pewny ?"+CHR(13)                 , ;
            Chr(13)+"BÀÜ¬©dny zbi¬¢r Indeksowy"+CHR(13)+"Nie mo¬æna szuka‚Ä†"+CHR(13)         , ;
            Chr(13)+"Nie mo¬æna znaleÀú‚Ä† pola indeksu"+CHR(13)+"Nie mo¬æna szuka‚Ä†"+CHR(13) , ;
            Chr(13)+"Nie mo¬æna szuka√¶ wg"+CHR(13)+"pola memo lub logicznego"+CHR(13)         , ;
            Chr(13)+"Rekordu nie znaleziono"+CHR(13)                                                     , ;
            Chr(13)+"Zbyt wiele kolumn"+CHR(13)+"Raport nie mo¬æe zmieÀúci‚Ä† si¬© na arkuszu"+CHR(13)      }
         oHmgApp():APP132  := { "Rekord"              , ;
            "Liczba rekord¬¢w"        , ;
            "      (Nowy)"        , ;
            "    (Edycja)"        , ;
            "Wprowad¬´ numer rekordu" , ;
            "Szukaj"                , ;
            "Szukaj tekstu"         , ;
            "Szukaj daty"         , ;
            "Szukaj liczby"       , ;
            "Definicja Raportu"   , ;
            "Kolumny Raportu"      , ;
            "Dost¬©pne kolumny"     , ;
            "Pocz¬•tkowy rekord"      , ;
            "Ko√§cowy rekord"        , ;
            "Raport z "          , ;
            "Data:"               , ;
            "Pocz¬•tkowy rekord:"     , ;
            "Ko√§cowy rekord:"       , ;
            "Sortowanie wg:"         , ;
            "Tak"                 , ;
            "Nie"                  , ;
            "Strona "               , ;
            " z "                 }
         oHmgApp():APP133 := { "Zamknij"    , ;
            "Nowy"      , ;
            "Edytuj"     , ;
            "Usu√§"   , ;
            "Znajd¬´"     , ;
            "Id≈∏ do"     , ;
            "Raport"   , ;
            "Pierwszy"    , ;
            "Poprzedni" , ;
            "Nast¬©pny"     , ;
            "Ostatni"     , ;
            "Zapisz"     , ;
            "Rezygnuj"   , ;
            "Dodaj"      , ;
            "Usu√§"   , ;
            "Drukuj"    , ;
            "Zamknij"     }
         oHmgApp():APP134  := { "EDIT, bÀÜ¬©dna nazwa bazy"                                  , ;
            "EDIT, baza ma wi¬©cej ni¬æ 16 p¬¢l"                   , ;
            "EDIT, tryb odÀúwierzania poza zakresem (zobacz raport bÀÜ¬©d¬¢w)"      , ;
            "EDIT, liczba zdarz√§ podstawowych poza zakresem (zobacz raport bÀÜ¬©d¬¢w)" , ;
            "EDIT, lista zdarze√§ poza zakresem (zobacz raport bÀÜ¬©d¬¢w)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {          ;
            "&Zamknij",        ; // 1
            "&Nowy",           ; // 2
            "&Modyfikuj",      ; // 3
            "&Kasuj",          ; // 4
            "&Znajd≈∏",         ; // 5
            "&Drukuj",         ; // 6
            "&Porzu√¶",         ; // 7
            "&Ok",             ; // 8
            "&Kopiuj",         ; // 9
            "&Aktywuj Filtr",  ; // 10
            "&Deaktywuj Filtr" } // 11
         oHmgApp():APP129 := {                       ;
            "Brak",                        ; // 1
            "Rekord",                      ; // 2
            "Suma",                        ; // 3
            "Aktywny indeks",              ; // 4
            "Opcje",                       ; // 5
            "Nowy rekord",                 ; // 6
            "Modyfikuj rekord",            ; // 7
            "Wybierz rekord",              ; // 8
            "Znajd≈∏ rekord",               ; // 9
            "Opcje druku",                 ; // 10
            "Dost√™pne pola",               ; // 11
            "Pola do druku",               ; // 12
            "Dost√™pne drukarki",           ; // 13
            "Pierwszy rekord do druku",    ; // 14
            "Ostatni rekord do druku",     ; // 15
            "Skasuj rekord",               ; // 16
            "Podgl¬πd",                     ; // 17
            "Poka¬ø miniatury",             ; // 18
            "Stan filtru: ",               ; // 19
            "Filtrowane: ",                ; // 20
            "Opcje filtrowania" ,          ; // 21
            "Pola bazy danych" ,           ; // 22
            "Operator por√≥wnania",         ; // 23
            "Warto≈ì√¶ filtru",              ; // 24
            "Wybierz pola do filtru",      ; // 25
            "Wybierz operator por√≥wnania", ; // 26
            "R√≥wna si√™",                   ; // 27
            "Nie r√≥wna si√™",               ; // 28
            "Wi√™kszy ",                    ; // 29
            "Mniejszy ",                   ; // 30
            "Wi√™kszy lub r√≥wny ",          ; // 31
            "Mniejszy lub r√≥wny"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Aktywny obszar nie odnaleziony   "  + ABM_CRLF + "Wybierz obszar przed wywo¬≥aniem EDIT   " + ABM_CRLF,   ; // 1
            "Poszukiwany ci¬πg znak√≥w (dowolny tekst)",                                                                           ; // 2
            "Poszukiwana warto≈ì√¶ (dowolna liczba)",                                                                              ; // 3
            "Wybierz dat√™",                                                                                                      ; // 4
            "Check for true value",                                                                                              ; // 5
            "Wprowa√¶ warto≈ì√¶",                                                                                                   ; // 6
            "Wybierz dowolny rekord i naci≈ìcij OK",                                                                              ; // 7
            ABM_CRLF + "Wybra¬≥e≈ì opcj√™ kasowania rekordu   " + ABM_CRLF + "Czy jeste≈ì pewien?    " + ABM_CRLF,                   ; // 8
            ABM_CRLF + "Brak aktywnych indeks√≥w   " + ABM_CRLF + "Wybierz    " + ABM_CRLF,                                       ; // 9
            ABM_CRLF + "Nie mo¬øna szuka√¶ w polach typu MEMO lub LOGIC   " + ABM_CRLF,                                            ; // 10
            ABM_CRLF + "Rekord nie znaleziony   " + ABM_CRLF,                                                                    ; // 11
            "Wybierz rekord kt√≥ry nale¬øy doda√¶ do listy",                                                                        ; // 12
            "Wybierz rekord kt√≥ry nale¬øy wy¬≥¬πczy√¶ z listy",                                                                      ; // 13
            "Wybierz drukark√™",                                                                                                  ; // 14
            "Kliknij na przycisk by doda√¶ pole",                                                                                 ; // 15
            "Kliknij na przycisk by odj¬π√¶ pole",                                                                                 ; // 16
            "Kliknij, aby wybra√¶ pierwszy rekord do druku",                                                                      ; // 17
            "Kliknij, aby wybra√¶ ostatni rekord do druku",                                                                       ; // 18
            ABM_CRLF + "Brak p√≥l do w¬≥¬πczenia   " + ABM_CRLF,                                                                    ; // 19
            ABM_CRLF + "Najpierw wybierz pola do w¬≥¬πczenia   " + ABM_CRLF,                                                       ; // 20
            ABM_CRLF + "Brak p√≥l do wy¬≥¬πczenia   " + ABM_CRLF,                                                                   ; // 21
            ABM_CRLF + "Najpierw wybierz pola do wy¬≥¬πczenia   " + ABM_CRLF,                                                      ; // 22
            ABM_CRLF + "Nie wybra¬≥e≈ì ¬øadnych p√≥l   " + ABM_CRLF + "Najpierw wybierz pola do w¬≥¬πczenia do wydruku   " + ABM_CRLF, ; // 23
            ABM_CRLF + "Za wiele p√≥l   " + ABM_CRLF + "Zredukuj liczb√™ p√≥l   " + ABM_CRLF,                                       ; // 24
            ABM_CRLF + "Drukarka nie gotowa   " + ABM_CRLF,                                                                      ; // 25
            "Porz¬πdek wg",                                                                                                       ; // 26
            "Od rekordu",                                                                                                        ; // 27
            "Do rekordu",                                                                                                        ; // 28
            "Tak",                                                                                                               ; // 29
            "Nie",                                                                                                               ; // 30
            "Strona:",                                                                                                           ; // 31
            ABM_CRLF + "Wybierz drukark√™   " + ABM_CRLF,                                                                         ; // 32
            "Filtrowanie wg",                                                                                                    ; // 33
            ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 34
            ABM_CRLF + "Nie mo¬øna filtrowa√¶ wg. p√≥l typu MEMO    " + ABM_CRLF,                                                   ; // 35
            ABM_CRLF + "Wybierz pola dla filtru    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Wybierz operator por√≥wnania dla filtru    " + ABM_CRLF,                                                  ; // 37
            ABM_CRLF + "Wpisz dowoln¬π warto≈ì√¶ dla filtru    " + ABM_CRLF,                                                        ; // 38
            ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 39
            ABM_CRLF + "Deaktywowa√¶ filtr?   " + ABM_CRLF,                                                                        ;
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

         // case cLang == "pt.PT850"        // Portuguese
      CASE cLang == "PT"
         /////////////////////////////////////////////////////////////
         // PORTUGUESE
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Voc√™ tem Certeza ?'
         oHmgApp():APP331 [2] := 'Fechar Janela'
         oHmgApp():APP331 [3] := 'Fechamento n√£o permitido'
         oHmgApp():APP331 [4] := 'O programa j√° est√° em execu√ß√£o'
         oHmgApp():APP331 [5] := 'Edita'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancela'
         oHmgApp():APP331 [8] := 'P√°g.'

         // BROWSE

         oHmgApp():APP136:= {"Window: ",                                 ;
            " Erro n√£o definido. O programa ser√° fechado",                     ;
            "Erro na HMG.lib",                              ;
            "Control: ",                                 ;
            " Of ",                                    ;
            " N√£o pronto. O programa ser√° fechado",                        ;
            "Browse: Tipo Inv√°lido !!!. O programa ser√° fechado",                  ;
            "Browse: A edi√ß√£o n√£o √© poss√≠vel, o campo n√£o pertence a essa √°rea. O programa ser√° fechado",   ;
            "O arquivo est√° em uso e n√£o pode ser editado !!!",                  ;
            "Aguarde...",                                 ;
            "Dado Inv√°lido"                                 }
         oHmgApp():APP137 := { 'Voc√™ tem Certeza ?' , 'Apagar Registro' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Excluir o registro atual"+CHR(13)+"Tem certeza?"+CHR(13),               ;
            Chr(13)+"N√£o existe nenhum √≠ndice ativo"+CHR(13)+"N√£o √© poss√≠vel realizar a busca"+CHR(13),      ;
            Chr(13)+"N√£o foi encontrado o campo √≠ndice"+CHR(13)+"N√£o √© poss√≠vel realizar a busca"+CHR(13),   ;
            Chr(13)+"N√£o √© poss√≠vel realizar busca"+CHR(13)+"por campos Memo ou L√≥gicos"+CHR(13),      ;
            Chr(13)+"Registro n√£o encontrado"+CHR(13),                        ;
            Chr(13)+"Inclu√≠das colunas em excesso"+CHR(13)+"A listagem completa n√£o caber√° na tela"+CHR(13)     }

         oHmgApp():APP132  := { "Registro Atual",            ;
            "Total de Registros",         ;
            "      (Novo)",            ;
            "    (Editar)",            ;
            "Introduza o n√∫mero do registro",      ;
            "Buscar",               ;
            "Texto √† buscar",            ;
            "Data √† buscar",            ;
            "N√∫mero √† buscar",            ;
            "Definic√£o da lista",         ;
            "Colunas da lista",            ;
            "Colunas dispon√≠veis",         ;
            "Registro inicial",            ;
            "Registro final",            ;
            "Lista de ",               ;
            "Data:",               ;
            "Primeiro registro:",         ;
            "√öltimo registro:",            ;
            "Ordenado por:",            ;
            "Sim",               ;
            "N√£o",               ;
            "P√°gina ",               ;
            " de "               }

         oHmgApp():APP133 := { "Fechar",               ;
            "Novo",               ;
            "Alterar",               ;
            "Excluir",               ;
            "Buscar",               ;
            "Ir ao registro",            ;
            "Listar",               ;
            "Primeiro",               ;
            "Anterior",               ;
            "Seguinte",               ;
            "√öltimo",               ;
            "Salvar",               ;
            "Cancelar",               ;
            "Juntar",               ;
            "Sair",               ;
            "Imprimir",               ;
            "Fechar"               }

         oHmgApp():APP134  := { "EDIT, Nenhuma √Årea foi especificada",               ;
            "EDIT, A √Årea selecionada possui mais de 16 campos",            ;
            "EDIT, Atualiza√ß√£o est√° fora do limite (Favor comunicar este erro)",      ;
            "EDIT, Evento principal est√° fora do limite (Favor comunicar este erro)",   ;
            "EDIT, Evento mostrado est√°¬†fora do limite (Favor comunicar este erro)"   }

         // EDIT EXTENDED

         oHmgApp():APP128 :={"&Sair",       ; // 1
            "&Novo",      ; // 2
            "&Alterar",      ; // 3
            "&Excluir",      ; // 4
            "&Localizar",      ; // 5
            "&Imprimir",      ; // 6
            "&Cancelar",      ; // 7
            "&Aceitar",      ; // 8
            "&Copiar",      ; // 9
            "&Ativar Filtro",   ; // 10
            "&Desativar Filtro"   } // 11

         oHmgApp():APP129 :={"Nenhum",               ; // 1
            "Registro",               ; // 2
            "Total",               ; // 3
            "√çndice ativo",               ; // 4
            "Op√ß√£o",               ; // 5
            "Novo registro",            ; // 6
            "Modificar registro",            ; // 7
            "Selecionar registro",            ; // 8
            "Localizar registro",            ; // 9
            "Op√ß√£o de impress√£o",            ; // 10
            "Campos dispon√≠veis",            ; // 11
            "Campos selecionados",            ; // 12
            "Impressoras dispon√≠veis",         ; // 13
            "Primeiro registro a imprimir",         ; // 14
            "√öltimo registro a imprimir",         ; // 15
            "Apagar registro",            ; // 16
            "Visualizar impress√£o",            ; // 17
            "Miniaturas das p√°ginas",         ; // 18
            "Condi√ß√£o do filtro: ",            ; // 19
            "Filtrado: ",               ; // 20
            "Op√ß√µes do filtro" ,            ; // 21
            "Campos do BDD" ,            ; // 22
            "Operador de compara√ß√£o",         ; // 23
            "Argumento de compara√ß√£o",         ; // 24
            "Selecione o campo √† filtrar",         ; // 25
            "Selecione o operador de compara√ß√£o",      ; // 26
            "Igual",               ; // 27
            "Diferente",               ; // 28
            "Maior que",               ; // 29
            "Menor que",               ; // 30
            "Maior ou igual que",            ; // 31
            "Menor ou igual que"            } // 32

         oHmgApp():APP130 := { ABM_CRLF + "N√£o h√° uma √°rea ativa   "  + ABM_CRLF +                         ;
            "Por favor selecione uma √°rea antes de executar o EDIT EXTENDED   " + ABM_CRLF,            ; // 1
            "Introduza o valor do campo (texto)",                              ; // 2
            "Introduza o valor do campo (num√©rico)",                           ; // 3
            "Selecione a data",                                    ; // 4
            "Ative o indicar para valor verdadero",                              ; // 5
            "Introduza o valor do campo",                                 ; // 6
            "Selecione um registro e tecle Ok",                              ; // 7
            ABM_CRLF + "Confirma exclus√£o do registro selecionado ??   " + ABM_CRLF + "Tem certeza?    " + ABM_CRLF,   ; // 8
            ABM_CRLF + "N√£o ha um √≠ndice seleccionado    " + ABM_CRLF + "Por favor selecione um   " + ABM_CRLF,      ; // 9
            ABM_CRLF + "N√£o √© poss√≠vel excutar buscas em campos tipo Memo ou L√≥gico   " + ABM_CRLF,            ; // 10
            ABM_CRLF + "Registro n√£o encontrado   " + ABM_CRLF,                        ; // 11
            "Selecione o campo a incluir na lista",                              ; // 12
            "Selecione o campo a excluir da lista",                              ; // 13
            "Selecione a Impressora",                                 ; // 14
            "Pressione o bot√£o para incluir o campo",                           ; // 15
            "Pressione o bot√£o para excluir o campo",                           ; // 16
            "Pressione o bot√£o para selecionar o primeiro registro a imprimir",                  ; // 17
            "Pressione o bot√£o para selecionar o √∫ltimo registro a imprimir",                  ; // 18
            ABM_CRLF + "Foram inclu√≠dos todos os campos   " + ABM_CRLF,                     ; // 19
            ABM_CRLF + "Primeiro seleccione o campo a incluir   " + ABM_CRLF,                  ; // 20
            ABM_CRLF + "N√£o ha campos para excluir   " + ABM_CRLF,                        ; // 21
            ABM_CRLF + "Primeiro selecione o campo a excluir   " + ABM_CRLF,                  ; // 22
            ABM_CRLF + "N√£o h√° mais campos selecion√°veis   " + ABM_CRLF,                     ; // 23
            ABM_CRLF + "A lista n√£o cabe na p√°gina   " + ABM_CRLF + "Reduza o n√∫mero de campos   " + ABM_CRLF,      ; // 24
            ABM_CRLF + "A impressora n√£o est√° dispon√≠vel   " + ABM_CRLF,                     ; // 25
            "Ordenado por",                                       ; // 26
            "Do registro",                                       ; // 27
            "At√© o registro",                                    ; // 28
            "Sim",                                          ; // 29
            "N√£o",                                          ; // 30
            "P√°gina:",                                       ; // 31
            ABM_CRLF + "Por favor selecione uma impressora   " + ABM_CRLF,                     ; // 32
            "Filtrado por",                                       ; // 33
            ABM_CRLF + "N√£o h√° nenhum filtro ativo    " + ABM_CRLF,                        ; // 34
            ABM_CRLF + "N√£o √© poss√≠vel filtrar por campos Memo    " + ABM_CRLF,                  ; // 35
            ABM_CRLF + "Selecione o campo a filtrar    " + ABM_CRLF,                     ; // 36
            ABM_CRLF + "Selecione o operador de compara√ß√£o    " + ABM_CRLF,                     ; // 37
            ABM_CRLF + "Introduza o valor do filtro    " + ABM_CRLF,                     ; // 38
            ABM_CRLF + "N√£o ha nenhum filtro ativo    " + ABM_CRLF,                        ; // 39
            ABM_CRLF + "Limpar o filtro ativo?   " + ABM_CRLF,                        ; // 40
            ABM_CRLF + "Registro est√° bloqueado por outro usu√°rio" + ABM_CRLF                  } // 41

         // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
      CASE cLang == "RU"
         /////////////////////////////////////////////////////////////
         // RUSSIAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := '√Ç√ª √≥√¢√•√∞√•√≠√ª ?'
         oHmgApp():APP331 [2] := '√á√†√™√∞√ª√≤√º √Æ√™√≠√Æ'
         oHmgApp():APP331 [3] := '√á√†√™√∞√ª√≤√®√• √≠√• √§√Æ√±√≤√≥√Ø√≠√Æ'
         oHmgApp():APP331 [4] := '√è√∞√Æ√£√∞√†√¨√¨√† √≥√¶√• √ß√†√Ø√≥√π√•√≠√†'
         oHmgApp():APP331 [5] := '√à√ß√¨√•√≠√®√≤√º'
         oHmgApp():APP331 [6] := '√Ñ√†'
         oHmgApp():APP331 [7] := '√é√≤√¨√•√≠√†'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "√é√™√≠√Æ: "                                              , ;
            " √≠√• √Æ√Ø√∞√•√§√•√´√•√≠√Æ. √è√∞√Æ√£√∞√†√¨√¨√† √Ø√∞√•√∞√¢√†√≠√†"                 , ;
            "HMG √é√∏√®√°√™√†"                                     , ;
            "√ù√´√•√¨√•√≠√≤ √≥√Ø√∞√†√¢√´√•√≠√®: "                               , ;
            " √®√ß "                                               , ;
            " √ì√¶√• √Æ√Ø√∞√•√§√•√´√•√≠. √è√∞√Æ√£√∞√†√¨√¨√† √Ø√∞√•√∞√¢√†√≠√†"                         , ;
            "Browse: √í√†√™√Æ√© √≤√®√Ø √≠√• √Ø√Æ√§√§√•√∞√¶√®√¢√†√•√≤√±. √è√∞√Æ√£√∞√†√¨√¨√† √Ø√∞√•√∞√¢√†√≠√†"    , ;
            "Browse: Append √™√´√†√±√± √≠√• √¨√Æ√¶√•√≤ √°√ª√≤√º √®√±√Ø√Æ√´√º√ß√Æ√¢√†√≠ √± √Ø√Æ√´√¨√® √®√ß √§√∞√≥√£√Æ√© √∞√†√°√Æ√∑√•√© √Æ√°√´√†√±√≤√®. √è√∞√Æ√£√∞√†√¨√¨√† √Ø√∞√•√∞√¢√†√≠√†", ;
            "√á√†√Ø√®√±√º √±√•√©√∑√†√± √∞√•√§√†√™√≤√®√∞√≥√•√≤√± √§√∞√≥√£√®√¨ √Ø√Æ√´√º√ß√Æ√¢√†√≤√•√´√•√¨"           , ;
            "√è√∞√•√§√≥√Ø√∞√•√¶√§√•√≠√®√•"                                             , ;
            "√Ç√¢√•√§√•√≠√ª √≠√•√Ø√∞√†√¢√®√´√º√≠√ª√• √§√†√≠√≠√ª√•"                                 }
         oHmgApp():APP137 := { '√Ç√ª √≥√¢√•√∞√•√≠√ª ?' , '√ì√§√†√´√®√≤√º √ß√†√Ø√®√±√º' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"√ì√§√†√´√•√≠√®√• √ß√†√Ø√®√±√®."+CHR(13)+"√Ç√ª √≥√¢√•√∞√•√≠√ª ?"+CHR(13)                  , ;
            Chr(13)+"√é√≤√±√≥√≤√±√≤√¢√≥√•√≤ √®√≠√§√•√™√±√≠√ª√© √¥√†√©√´"+CHR(13)+"√è√Æ√®√±√™ √≠√•√¢√Æ√ß√¨√Æ√¶√•√≠"+CHR(13)   , ;
            Chr(13)+"√é√≤√±√≥√≤√±√≤√¢√≥√•√≤ √®√≠√§√•√™√±√≠√Æ√• √Ø√Æ√´√•"+CHR(13)+"√è√Æ√®√±√™ √≠√•√¢√Æ√ß√¨√Æ√¶√•√≠"+CHR(13)   , ;
            Chr(13)+"√è√Æ√®√±√™ √≠√•√¢√Æ√ß√¨√Æ√¶√•√≠ √Ø√Æ"+CHR(13)+"√¨√•√¨√Æ √®√´√® √´√Æ√£√®√∑√•√±√™√®√¨ √Ø√Æ√´√ø√¨"+CHR(13) , ;
            Chr(13)+"√á√†√Ø√®√±√º √≠√• √≠√†√©√§√•√≠√†"+CHR(13)                                       , ;
            Chr(13)+"√ë√´√®√∏√™√Æ√¨ √¨√≠√Æ√£√Æ √™√Æ√´√Æ√≠√Æ√™"+CHR(13)+"√é√≤√∑√•√≤ √≠√• √Ø√Æ√¨√•√±√≤√®√≤√±√ø √≠√† √´√®√±√≤√•"+CHR(13) }
         oHmgApp():APP132  := { "√á√†√Ø√®√±√º"              , ;
            "√Ç√±√•√£√Æ √ß√†√Ø√®√±√•√©"       , ;
            "     (√ç√Æ√¢√†√ø)"        , ;
            "  (√à√ß√¨√•√≠√®√≤√º)"        , ;
            "√Ç√¢√•√§√®√≤√• √≠√Æ√¨√•√∞ √ß√†√Ø√®√±√®", ;
            "√è√Æ√®√±√™"               , ;
            "√ç√†√©√≤√® √≤√•√™√±√≤"         , ;
            "√ç√†√©√≤√® √§√†√≤√≥"          , ;
            "√ç√†√©√≤√® √∑√®√±√´√Æ"         , ;
            "√ç√†√±√≤√∞√Æ√©√™√† √Æ√≤√∑√•√≤√†"    , ;
            "√ä√Æ√´√Æ√≠√™√® √Æ√≤√∑√•√≤√†"      , ;
            "√Ñ√Æ√±√≤√≥√Ø√≠√ª√• √™√Æ√´√Æ√≠√™√®"   , ;
            "√ç√†√∑√†√´√º√≠√†√ø √ß√†√Ø√®√±√º"    , ;
            "√ä√Æ√≠√•√∑√≠√†√ø √ß√†√Ø√®√±√º"     , ;
            "√é√≤√∑√•√≤ √§√´√ø "          , ;
            "√Ñ√†√≤√†:"               , ;
            "√è√•√∞√¢√†√ø √ß√†√Ø√®√±√º:"      , ;
            "√ä√Æ√≠√•√∑√≠√†√ø √ß√†√Ø√®√±√º:"    , ;
            "√É√∞√≥√Ø√Ø√®√∞√Æ√¢√™√† √Ø√Æ:"     , ;
            "√Ñ√†"                  , ;
            "√ç√•√≤"                 , ;
            "√ë√≤√∞√†√≠√®√∂√† "           , ;
            " √®√ß "                 }
         oHmgApp():APP133 := { "√á√†√™√∞√ª√≤√º"   , ;
            "√ç√Æ√¢√†√ø"     , ;
            "√à√ß√¨√•√≠√®√≤√º"  , ;
            "√ì√§√†√´√®√≤√º"   , ;
            "√è√Æ√®√±√™"     , ;
            "√è√•√∞√•√©√≤√®"   , ;
            "√é√≤√∑√•√≤"     , ;
            "√è√•√∞√¢√†√ø"    , ;
            "√ç√†√ß√†√§"     , ;
            "√Ç√Ø√•√∞√•√§"    , ;
            "√è√Æ√±√´√•√§√≠√ø√ø" , ;
            "√ë√Æ√µ√∞√†√≠√®√≤√º" , ;
            "√é√≤√¨√•√≠√†"    , ;
            "√Ñ√Æ√°√†√¢√®√≤√º"  , ;
            "√ì√§√†√´√®√≤√º"   , ;
            "√è√•√∑√†√≤√º"    , ;
            "√á√†√™√∞√ª√≤√º"    }
         oHmgApp():APP134  := { "EDIT, √≠√• √≥√™√†√ß√†√≠√Æ √®√¨√ø √∞√†√°√Æ√∑√•√© √Æ√°√´√†√±√≤√®"                     , ;
            "EDIT, √§√Æ√Ø√≥√±√™√†√•√≤√±√ø √≤√Æ√´√º√™√Æ √§√Æ 16 √Ø√Æ√´√•√©"                     , ;
            "EDIT, √∞√•√¶√®√¨ √Æ√°√≠√Æ√¢√´√•√≠√®√ø √¢√≠√• √§√®√†√Ø√†√ß√Æ√≠√† (√±√Æ√Æ√°√π√®√≤√• √Æ√° √Æ√∏√®√°√™√•)", ;
            "EDIT, √≠√Æ√¨√•√∞ √±√Æ√°√ª√≤√®√ø √¢√≠√• √§√®√†√Ø√†√ß√Æ√≠√† (√±√Æ√Æ√°√π√®√≤√• √Æ√° √Æ√∏√®√°√™√•)"   , ;
            "EDIT, √≠√Æ√¨√•√∞ √±√Æ√°√ª√≤√®√ø √´√®√±√≤√®√≠√£√† √¢√≠√• √§√®√†√Ø√†√ß√Æ√≠√† (√±√Æ√Æ√°√π√®√≤√• √Æ√° √Æ√∏√®√°√™√•)" }

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

         // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
      CASE cLang == "ES"
         /////////////////////////////////////////////////////////////
         // SPANISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Est√° seguro ?'
         oHmgApp():APP331 [2] := 'Cerrar Ventana'
         oHmgApp():APP331 [3] := 'Operaci√≥n no permitida'
         oHmgApp():APP331 [4] := 'EL programa ya est√° ejecut√°ndose'
         oHmgApp():APP331 [5] := 'Editar'
         oHmgApp():APP331 [6] := 'Aceptar'
         oHmgApp():APP331 [7] := 'Cancelar'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Window: "                                              , ;
            " no est√° definida. Ejecuci√≥n terminada"                , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " De "                                                  , ;
            " ya definido. Ejecuci√≥n terminada"                     , ;
            "Browse: Tipo no permitido. Ejecuci√≥n terminada"        , ;
            "Browse: La calusula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. Ejecuci√≥n terminada", ;
            "El registro est√° siendo editado por otro usuario"      , ;
            "Peligro"                                               , ;
            "Entrada no v√°lida"                                      }
         oHmgApp():APP137 := { 'Est√° Seguro ?' , 'Eliminar Registro' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Va a eliminar el registro actual"+CHR(13)+"¬ø Est√° seguro ?"+CHR(13)                 , ;
            Chr(13)+"No hay un indice activo"+CHR(13)+"No se puede realizar la busqueda"+CHR(13)         , ;
            Chr(13)+"No se encuentra el campo indice"+CHR(13)+"No se puede realizar la busqueda"+CHR(13) , ;
            Chr(13)+"No se pueden realizar busquedas"+CHR(13)+"por campos memo o l√≥gico"+CHR(13)         , ;
            Chr(13)+"Registro no encontrado"+CHR(13)                                                     , ;
            Chr(13)+"Ha inclido demasiadas columnas"+CHR(13)+"El listado no cabe en la hoja"+CHR(13)      }
         oHmgApp():APP132  := { "Registro Actual"                  , ;
            "Registros Totales"                , ;
            "     (Nuevo)"                     , ;
            "    (Editar)"                     , ;
            "Introducca el n√∫mero de registro" , ;
            "Buscar"                           , ;
            "Texto a buscar"                   , ;
            "Fecha a buscar"                   , ;
            "N√∫mero a buscar"                  , ;
            "Definici√≥n del listado"           , ;
            "Columnas del listado"             , ;
            "Columnas disponibles"             , ;
            "Registro inicial"                 , ;
            "Registro final"                   , ;
            "Listado de "                      , ;
            "Fecha:"                           , ;
            "Primer registro:"                 , ;
            "Ultimo registro:"                 , ;
            "Ordenado por:"                    , ;
            "Si"                               , ;
            "No"                               , ;
            "Pagina "                          , ;
            " de "                              }
         oHmgApp():APP133 := { "Cerrar"           , ;
            "Nuevo"            , ;
            "Modificar"        , ;
            "Eliminar"         , ;
            "Buscar"           , ;
            "Ir al registro"   , ;
            "Listado"          , ;
            "Primero"          , ;
            "Anterior"         , ;
            "Siguiente"        , ;
            "Ultimo"           , ;
            "Guardar"          , ;
            "Cancelar"         , ;
            "A√±adir"           , ;
            "Quitar"           , ;
            "Imprimir"         , ;
            "Cerrar"            }
         oHmgApp():APP134  := { "EDIT, No se ha especificado el area"                                  , ;
            "EDIT, El area contiene m√°s de 16 campos"                              , ;
            "EDIT, Refesco fuera de rango (por favor comunique el error)"          , ;
            "EDIT, Evento principal fuera de rango (por favor comunique el error)" , ;
            "EDIT, Evento listado fuera de rango (por favor comunique el error)"    }

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            "&Cerrar",           ; // 1
            "&Nuevo",            ; // 2
            "&Modificar",        ; // 3
            "&Eliminar",         ; // 4
            "&Buscar",           ; // 5
            "&Imprimir",         ; // 6
            "&Cancelar",         ; // 7
            "&Aceptar",          ; // 8
            "&Copiar",           ; // 9
            "&Activar Filtro",   ; // 10
            "&Desactivar Filtro" } // 11
         oHmgApp():APP129 := {                                 ;
            "Ninguno",                               ; // 1
            "Registro",                              ; // 2
            "Total",                                 ; // 3
            "Indice activo",                         ; // 4
            "Opciones",                              ; // 5
            "Nuevo registro",                        ; // 6
            "Modificar registro",                    ; // 7
            "Seleccionar registro",                  ; // 8
            "Buscar registro",                       ; // 9
            "Opciones de impresi√≥n",                 ; // 10
            "Campos disponibles",                    ; // 11
            "Campos del listado",                    ; // 12
            "Impresoras disponibles",                ; // 13
            "Primer registro a imprimir",            ; // 14
            "Ultimo registro a imprimir",            ; // 15
            "Borrar registro",                       ; // 16
            "Vista previa",                          ; // 17
            "P√°ginas en miniatura",                  ; // 18
            "Condici√≥n del filtro: ",                ; // 19
            "Filtrado: ",                            ; // 20
            "Opciones de filtrado" ,                 ; // 21
            "Campos de la bdd" ,                     ; // 22
            "Operador de comparaci√≥n",               ; // 23
            "Valor de comparaci√≥n",                  ; // 24
            "Seleccione el campo a filtrar",         ; // 25
            "Seleccione el operador de comparaci√≥n", ; // 26
            "Igual",                                 ; // 27
            "Distinto",                              ; // 28
            "Mayor que",                             ; // 29
            "Menor que",                             ; // 30
            "Mayor o igual que",                     ; // 31
            "Menor o igual que"                      } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "No hay un area activa   "  + ABM_CRLF + "Por favor seleccione un area antes de llamar a EDIT EXTENDED   " + ABM_CRLF,       ; // 1
            "Introduzca el valor del campo (texto)",                                                                                      ; // 2
            "Introduzca el valor del campo (num√©rico)",                                                                                    ; // 3
            "Seleccione la fecha",                                                                                                      ; // 4
            "Active la casilla para indicar un valor verdadero",                                                                                                 ; // 5
            "Introduzca el valor del campo",                                                                                                ; // 6
            "Seleccione un registro y pulse aceptar",                                                                                       ; // 7
            ABM_CRLF + "Se dispone a borrar el registro activo   " + ABM_CRLF + "¬øEsta seguro?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "No se ha seleccionado un indice   " + ABM_CRLF + "Por favor seleccione uno   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "No se pueden realizar busquedad por campos tipo memo o l√≥gico   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Registro no encontrado   " + ABM_CRLF,                                                                            ; // 11
            "Seleccione el campo a incluir en el listado",                                                                                  ; // 12
            "Seleccione el campo a excluir del listado",                                                                                ; // 13
            "Seleccione la impresora",                                                                                                   ; // 14
            "Pulse el bot√≥n para incluir el campo",                                                                                         ; // 15
            "Pulse el bot√≥n para excluir el campo",                                                                                         ; // 16
            "Pulse el bot√≥n para seleccionar el primer registro a imprimir",                                                                      ; // 17
            "Pulse el bot√≥n para seleccionar el √∫ltimo registro a imprimir",                                                                       ; // 18
            ABM_CRLF + "Ha incluido todos los campos   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "Primero seleccione el campo a incluir   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No hay campos para excluir   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "Primero seleccione el campo a excluir   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "No ha seleccionado ning√∫n campo   " + ABM_CRLF,                                              ; // 23
            ABM_CRLF + "El listado no cabe en la p√°gina   " + ABM_CRLF + "Reduzca el numero de campos   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "La impresora no est√° disponible   " + ABM_CRLF,                                                                           ; // 25
            "Ordenado por",                                                                                                           ; // 26
            "Del registro",                                                                                                          ; // 27
            "Al registro",                                                                                                            ; // 28
            "Si",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "P√°gina:",                                                                                                                ; // 31
            ABM_CRLF + "Por favor seleccione una impresora   " + ABM_CRLF,                                                                     ; // 32
            "Filtrado por",                                                                                                          ; // 33
            ABM_CRLF + "No hay un filtro activo    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "No se puede filtrar por campos memo    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Seleccione el campo a filtrar    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Seleccione el operador de comparaci√≥n    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Introduzca el valor del filtro    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "No hay ning√∫n filtro activo    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "¬øEliminar el filtro activo?   " + ABM_CRLF,                                                                           ; // 40
            ABM_CRLF + "Registro bloqueado por otro usuario    " + ABM_CRLF                                                                   } // 41

      CASE cLang == "FI"        // Finnish
         ///////////////////////////////////////////////////////////////////////
         // FINNISH
         ///////////////////////////////////////////////////////////////////////
         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Oletko varma ?'
         oHmgApp():APP331 [2] := 'Sulje ikkuna'
         oHmgApp():APP331 [3] := 'Sulkeminen ei sallittu'
         oHmgApp():APP331 [4] := 'Ohjelma on jo k√§ynniss√§'
         oHmgApp():APP331 [5] := 'Korjaa'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Keskeyt√§'
         oHmgApp():APP331 [8] := 'Sivu.'

         // BROWSE

         oHmgApp():APP136  := { "Ikkuna: " , ;
            " m√§√§rittelem√§t√∂n. Ohjelma lopetettu" , ;
            "HMG Virhe", ;
            "Kontrolli: ", ;
            " / " , ;
            " On jo m√§√§ritelty. Ohjelma lopetettu" , ;
            "Browse: Virheellinen tyyppi. Ohjelma lopetettu" , ;
            "Browse: Et voi lis√§t√§ kentti√§ jotka eiv√§t ole BROWSEN m√§√§rityksess√§. Ohjelma lopetettu", ;
            "Toinen k√§ytt√§j√§ korjaa juuri tietuetta" , ;
            "Varoitus" , ;
            "Virheellinen arvo" }

         oHmgApp():APP137 := { 'Oletko varma ?' , 'Poista tietue' }

         // EDIT
         oHmgApp():APP131   := { Chr(13)+"Poista tietue"+CHR(13)+"Oletko varma?"+CHR(13)                  , ;
            Chr(13)+"Indeksi tiedosto puuttuu"+CHR(13)+"En voihakea"+CHR(13)            , ;
            Chr(13)+"Indeksikentt√§ ei l√∂ydy"+CHR(13)+"En voihakea"+CHR(13)        , ;
            Chr(13)+"En voi hakea memo"+CHR(13)+"tai loogisen kent√§n mukaan"+CHR(13)       , ;
            Chr(13)+"Tietue ei l√∂ydy"+CHR(13), ;
            Chr(13)+"Liian monta saraketta"+CHR(13)+"raportti ei mahdu sivulle"+CHR(13) }

         oHmgApp():APP132  := { "Tietue"              , ;
            "Tietue lukum√§√§r√§"    , ;
            "       (Uusi)"       , ;
            "      (Korjaa)"      , ;
            "Anna tietue numero"  , ;
            "Hae"                 , ;
            "Hae teksti"          , ;
            "Hae p√§iv√§ys"         , ;
            "Hae numero"          , ;
            "Raportti m√§√§ritys"   , ;
            "Raportti sarake"     , ;
            "Sallitut sarakkeet"  , ;
            "Alku tietue"         , ;
            "Loppu tietue"        , ;
            "Raportti "           , ;
            "Pvm:"                , ;
            "Alku tietue:"        , ;
            "Loppu tietue:"       , ;
            "Lajittelu:"         , ;
            "Kyll√§"                 , ;
            "Ei"                  , ;
            "Sivu "               , ;
            " / "                 }

         oHmgApp():APP133 := { "Sulje"    , ;
            "Uusi"     , ;
            "Korjaa"   , ;
            "Poista"   , ;
            "Hae"      , ;
            "Mene"     , ;
            "Raportti" , ;
            "Ensimm√§inen" , ;
            "Edellinen"   , ;
            "Seuraava"    , ;
            "Viimeinen"   , ;
            "Tallenna"    , ;
            "Keskeyt√§"    , ;
            "Lis√§√§"       , ;
            "Poista"      , ;
            "Tulosta"     , ;
            "Sulje"     }
         oHmgApp():APP134  := { "EDIT, ty√∂alue puuttuu"   , ;
            "EDIT, ty√∂alueella yli 16 kentt√§√§", ;
            "EDIT, p√§ivitysalue ylitys (raportoi virhe)"      , ;
            "EDIT, tapahtuma numero ylitys (raportoi virhe)" , ;
            "EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            " Sulje",            ; // 1
            " Uusi",              ; // 2
            " Muuta",           ; // 3
            " Poista",           ; // 4
            " Hae",             ; // 5
            " Tulosta",            ; // 6
            " Keskeyt√§",           ; // 7
            " Ok",               ; // 8
            " Kopioi",             ; // 9
            " Aktivoi Filtteri",  ; // 10
            " Deaktivoi Filtteri" } // 11

         oHmgApp():APP129 := {                        ;
            "Ei mit√§√§n",                         ; // 1
            "Tietue",                       ; // 2
            "Yhteens√§",                        ; // 3
            "Aktiivinen lajittelu",                 ; // 4
            "Optiot",                      ; // 5
            "Uusi tietue",                   ; // 6
            "Muuta tietue",                ; // 7
            "Valitse tietue",                ; // 8
            "Hae tietue",                  ; // 9
            "Tulostus optiot",                ; // 10
            "Valittavat kent√§t",               ; // 11
            "Tulostettavat kent√§t",              ; // 12
            "Valittavat tulostimet",           ; // 13
            "Ensim. tulostuttava tietue",        ; // 14
            "Viim. tulostettava tietue",         ; // 15
            "Poista tietue",                ; // 16
            "Esikatselu",                      ; // 17
            "N√§yt√§ sivujen miniatyyrit",         ; // 18
            "Suodin ehto: ",           ; // 19
            "Suodatettu: ",                   ; // 20
            "Suodatus Optiot" ,           ; // 21
            "Tietokanta kent√§t" ,             ; // 22
            "Vertailu operaattori",        ; // 23
            "Suodatus arvo",                 ; // 24
            "Valitse suodatus kentt√§",       ; // 25
            "Valitse vertailu operaattori", ; // 26
            "Yht√§ kuin",                        ; // 27
            "Erisuuri kuin",                    ; // 28
            "Isompi kuin",                 ; // 29
            "Pienempi kuin",                   ; // 30
            "Isompi tai sama kuin",        ; // 31
            "Pienempi tai sama kuin"           } // 32

         oHmgApp():APP130 := { ;
            ABM_CRLF + "Ty√∂alue ei l√∂ydy.   "  + ABM_CRLF + "Valitse ty√∂aluetta ennenkun kutsut Edit  " + ABM_CRLF,       ; // 1
            "Anna kentt√§ arvo (teksti√§)",                                  ; // 2
            "Anna kentt√§ arvo (numeerinen)",                                  ; // 3
            "Valitse p√§iv√§ys",                            ; // 4
            "Tarkista tosi arvo",                     ; // 5
            "Anna kentt√§ arvo",                    ; // 6
            "Valitse joku tietue ja paina OK",                                     ; // 7
            ABM_CRLF + "Olet poistamassa aktiivinen tietue   "+ABM_CRLF + "Oletko varma?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "Ei aktiivista lajittelua   " + ABM_CRLF+"Valitse lajittelu   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + ABM_CRLF,; // 10
            ABM_CRLF + "Tietue ei l√∂ydy   " + ABM_CRLF,                                                ; // 11
            "Valitse listaan lis√§tt√§v√§t kent√§t",                                                    ; // 12
            "Valitse EI lis√§tt√§v√§t kent√§t",                                        ; // 13
            "Valitse tulostin",                   ; // 14
            "Paina n√§pp√§in lis√§√§t√§ksesi kentt√§",                                                                  ; // 15
            "Paina n√§pp√§in poistaaksesi kentt√§",                                                       ; //16
            "Paina n√§pp√§in valittaaksesi ensimm√§inen tulostettava tietue",  ; // 17
            "Paina n√§pp√§in valittaaksesi viimeinen tulostettava tietue",   ; // 18
            ABM_CRLF + "Ei lis√§√§ kentti√§   " + ABM_CRLF,                                 ; // 19
            ABM_CRLF + "Valitse ensin lis√§tt√§v√§ kentt√§   "+ABM_CRLF,                                                           ; //20
            ABM_CRLF + "EI Lis√§√§ ohitettavia kentti√§   " +ABM_CRLF,; // 21
            ABM_CRLF + "Valitse ensin ohitettava kentt√§   " +ABM_CRLF,                                                            ;//22
            ABM_CRLF + "Et valinnut kentti√§   " + ABM_CRLF + "Valitse tulosteen kent√§t   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Liikaa kentti√§   " + ABM_CRLF + "V√§henn√§ kentt√§ lukum√§√§r√§   " + ABM_CRLF,; // 24
            ABM_CRLF + "Tulostin ei valmiina   " + ABM_CRLF,                                                  ; // 25
            "Lajittelu",             ; // 26
            "Tietueesta",              ; // 27
            "Tietueeseen",                  ; // 28
            "Kyll√§",                ; // 29
            "EI",       ; // 30
            "Sivu:",          ; // 31
            ABM_CRLF + "Valitse tulostin   " + ABM_CRLF,                                       ; // 32
            "Lajittelu",            ; // 33
            ABM_CRLF + "Aktiivinen suodin olemassa    " + ABM_CRLF,                                                          ; // 34
            ABM_CRLF + "En voi suodattaa memo kentti√§    "+ABM_CRLF,;// 35
            ABM_CRLF + "Valitse suodattava kentt√§    " + ABM_CRLF,                                                           ; // 36
            ABM_CRLF + "Valitse suodattava operaattori    " +ABM_CRLF,                                                             ; //37
            ABM_CRLF + "Anna suodatusarvo    " + ABM_CRLF,                                         ; // 38
            ABM_CRLF + "Ei aktiivisia suotimia    " + ABM_CRLF,                                              ; // 39
            ABM_CRLF + "Poista suodin?   " + ABM_CRLF,                                        ; // 40
            ABM_CRLF + "Tietue lukittu    " + ABM_CRLF                                 } // 41

      CASE cLang == "NL"        // Dutch
         /////////////////////////////////////////////////////////////
         // DUTCH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Weet u het zeker?'
         oHmgApp():APP331 [2] := 'Sluit venster'
         oHmgApp():APP331 [3] := 'Sluiten niet toegestaan'
         oHmgApp():APP331 [4] := 'Programma is al actief'
         oHmgApp():APP331 [5] := 'Bewerken'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Annuleren'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Scherm: ", ;
            " is niet gedefinieerd. Programma be√´indigd"           , ;
            "HMG fout", ;
            "Control: ", ;
            " Van ", ;
            " Is al gedefinieerd. Programma be√´indigd"                   , ;
            "Browse: Type niet toegestaan. Programma be√´indigd"          , ;
            "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma be√´indigd", ;
            "Regel word al veranderd door een andere gebruiker"          , ;
            "Waarschuwing"                                               , ;
            "Onjuiste invoer"                                            }

         oHmgApp():APP137 := { 'Weet u het zeker?' , 'Verwijder regel' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Verwijder regel"+CHR(13)+"Weet u het zeker ?"+CHR(13)    , ;
            Chr(13)+"Index bestand is er niet"+CHR(13)+"Kan niet zoeken"+CHR(13)          , ;
            Chr(13)+"Kan index veld niet vinden"+CHR(13)+"Kan niet zoeken"+CHR(13)        , ;
            Chr(13)+"Kan niet zoeken op"+CHR(13)+"Memo of logische velden"+CHR(13)        , ;
            Chr(13)+"Regel niet gevonden"+CHR(13) , ;
            Chr(13)+"Te veel rijen"+CHR(13)+"Het rapport past niet op het papier"+CHR(13) }

         oHmgApp():APP132  := { "Regel"     , ;
            "Regel aantal"          , ;
            "       (Nieuw)"        , ;
            "      (Bewerken)"      , ;
            "Geef regel nummer"     , ;
            "Vind"                  , ;
            "Zoek tekst"            , ;
            "Zoek datum"            , ;
            "Zoek nummer"           , ;
            "Rapport definitie"     , ;
            "Rapport rijen"         , ;
            "Beschikbare rijen"     , ;
            "Eerste regel"          , ;
            "Laatste regel"         , ;
            "Rapport van "          , ;
            "Datum:"                , ;
            "Eerste regel:"         , ;
            "Laatste tegel:"        , ;
            "Gesorteerd op:"        , ;
            "Ja"                    , ;
            "Nee"                   , ;
            "Pagina "               , ;
            " van "                 }

         oHmgApp():APP133 := { "Sluiten"   , ;
            "Nieuw"                 , ;
            "Bewerken"              , ;
            "Verwijderen"           , ;
            "Vind"                  , ;
            "Ga naar"               , ;
            "Rapport"               , ;
            "Eerste"                , ;
            "Vorige"                , ;
            "Volgende"              , ;
            "Laatste"               , ;
            "Bewaar"                , ;
            "Annuleren"             , ;
            "Voeg toe"              , ;
            "Verwijder"             , ;
            "Print"                 , ;
            "Sluiten"               }
         oHmgApp():APP134  := { "BEWERKEN, werkgebied naam bestaat niet", ;
            "BEWERKEN, dit werkgebied heeft meer dan 16 velden", ;
            "BEWERKEN, ververs manier buiten bereik (a.u.b. fout melden)"           , ;
            "BEWERKEN, hoofd gebeurtenis nummer buiten bereik (a.u.b. fout melden)" , ;
            "BEWERKEN, list gebeurtenis nummer buiten bereik (a.u.b. fout melden)"  }

         // EDIT EXTENDED
         oHmgApp():APP128 := {            ;
            "&Sluiten",          ; // 1
            "&Nieuw",            ; // 2
            "&Aanpassen",        ; // 3
            "&Verwijderen",      ; // 4
            "&Vind",             ; // 5
            "&Print",            ; // 6
            "&Annuleren",        ; // 7
            "&Ok",               ; // 8
            "&Kopieer",          ; // 9
            "&Activeer filter",  ; // 10
            "&Deactiveer filter" } // 11
         oHmgApp():APP129 := {                            ;
            "Geen",                             ; // 1
            "Regel",                            ; // 2
            "Totaal",                           ; // 3
            "Actieve volgorde",                 ; // 4
            "Opties",                           ; // 5
            "Nieuw regel",                      ; // 6
            "Aanpassen regel",                  ; // 7
            "Selecteer regel",                  ; // 8
            "Vind regel",                       ; // 9
            "Print opties",                     ; //10
            "Beschikbare velden",               ; //11
            "Velden te printen",                ; //12
            "Beschikbare printers",             ; //13
            "Eerste regel te printen",          ; //14
            "Laatste regel te printen",         ; //15
            "Verwijder regel",                  ; //16
            "Voorbeeld",                        ; //17
            "Laat pagina klein zien",           ; //18
            "Filter condities: ",               ; //19
            "Gefilterd: ",                      ; //20
            "Filter opties" ,                   ; //21
            "Database velden" ,                 ; //22
            "Vergelijkings operator",           ; //23
            "Filter waarde",                    ; //24
            "Selecteer velden om te filteren",  ; //25
            "Selecteer vergelijkings operator", ; //26
            "Gelijk",                           ; //27
            "Niet gelijk",                      ; //28
            "Groter dan",                       ; //29
            "Kleiner dan",                      ; //30
            "Groter dan of gelijk aan",         ; //31
            "Kleiner dan of gelijk aan"         } //32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Kan geen actief werkgebied vinden   "  + ABM_CRLF + "Selecteer A.U.B. een actief werkgebied voor BEWERKEN aan te roepen   " + ABM_CRLF, ; // 1
            "Geef de veld waarde (een tekst)",; // 2
            "Geef de veld waarde (een nummer)",; // 3
            "Selecteer de datum",; // 4
            "Controleer voor geldige waarde",; // 5
            "Geef de veld waarde",; // 6
            "Selecteer een regel en druk op OK",; // 7
            ABM_CRLF + "Je gaat het actieve regel verwijderen  " + ABM_CRLF + "Zeker weten?    " + ABM_CRLF,; // 8
            ABM_CRLF + "Er is geen actieve volgorde " + ABM_CRLF + "Selecteer er A.U.B. een   " + ABM_CRLF,; // 9
            ABM_CRLF + "Kan niet zoeken in memo of logische velden   " + ABM_CRLF,; // 10
            ABM_CRLF + "Regel niet gevonden   " +ABM_CRLF,; // 11
            "Selecteer het veld om in de lijst in te sluiten",; // 12
            "Selecteer het veld om uit de lijst te halen",; // 13
            "Selecteer de printer",; // 14
            "Druk op de knop om het veld in te sluiten",; // 15
            "Druk op de knop om het veld uit te sluiten",; // 16
            "Druk op de knop om het eerste veld te selecteren om te printen",; // 17
            "Druk op de knop om het laatste veld te selecteren om te printen",; // 18
            ABM_CRLF + "Geen velden meer om in te sluiten   " + ABM_CRLF,; // 19
            ABM_CRLF + "Selecteer eerst het veld om in te sluiten   " + ABM_CRLF,; // 20
            ABM_CRLF + "Geen velden meer om uit te sluiten   " + ABM_CRLF,; // 21
            ABM_CRLF + "Selecteer eerst het veld om uit te sluiten   " + ABM_CRLF,; // 22
            ABM_CRLF + "Je hebt geen velden geselecteerd   " + ABM_CRLF + "Selecteer A.U.B. de velden om in te sluiten om te printen   " + ABM_CRLF, ; // 23
            ABM_CRLF + "Teveel velden   " + ABM_CRLF + "Selecteer minder velden   " + ABM_CRLF,; // 24
            ABM_CRLF + "Printer niet klaar   " + ABM_CRLF,; // 25
            "Volgorde op",; // 26
            "Van regel",; // 27
            "Tot regel",; // 28
            "Ja",; // 29
            "Nee",; // 30
            "Pagina:",; // 31
            ABM_CRLF + "Selecteer A.U.B. een printer " + ABM_CRLF,; // 32
            "Gefilterd op", ; // 33
            ABM_CRLF + "Er is een actief filter    " + ABM_CRLF,; // 34
            ABM_CRLF + "Kan niet filteren op memo velden    " + ABM_CRLF,; // 35
            ABM_CRLF + "Selecteer het veld om op te filteren    " + ABM_CRLF, ; // 36
            ABM_CRLF + "Selecteer een operator om te filteren    " + ABM_CRLF,; // 37
            ABM_CRLF + "Type een waarde om te filteren " + ABM_CRLF,; // 38
            ABM_CRLF + "Er is geen actief filter    "+ ABM_CRLF,; // 39
            ABM_CRLF + "Deactiveer filter?   " + ABM_CRLF,; // 40
            ABM_CRLF + "Regel geblokkeerd door een andere gebuiker" + ABM_CRLF } // 41

         // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
      CASE cLang == "SL"
         /////////////////////////////////////////////////////////////
         // SLOVENIAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Ste prepri√®ani ?'
         oHmgApp():APP331 [2] := 'Zapri okno'
         oHmgApp():APP331 [3] := 'Zapiranje ni dovoljeno'
         oHmgApp():APP331 [4] := 'Program je ≈æe zagnan'
         oHmgApp():APP331 [5] := 'Popravi'
         oHmgApp():APP331 [6] := 'V redu'
         oHmgApp():APP331 [7] := 'Prekini'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES

         oHmgApp():APP136  := { "Window: "                        , ;
            " not defined. Program terminated"     , ;
            "HMG Error"                        , ;
            "Control: "                            , ;
            " Of "                                 , ;
            " Already defined. Program Terminated" , ;
            "Type Not Allowed. Program terminated" , ;
            "False WorkArea. Program Terminated"   , ;
            "Zapis ureja drug uporabnik"           , ;
            "Opozorilo"                            , ;
            "Narobe vnos" }

         oHmgApp():APP137 := { 'Ste prepri√®ani ?' , 'Bri≈°i vrstico' }

         // EDIT MESSAGES

         oHmgApp():APP131   := { Chr(13)+"Bri≈°i vrstico"+CHR(13)+"Ste prepri√®ani ?"+CHR(13)     , ;
            Chr(13)+"Manjka indeksna datoteka"+CHR(13)+"Ne morem iskati"+CHR(13)       , ;
            Chr(13)+"Ne najdem indeksnega polja"+CHR(13)+"Ne morem iskati"+CHR(13)     , ;
            Chr(13)+"Ne morem iskati po"+CHR(13)+"memo ali logi√®nih poljih"+CHR(13)    , ;
            Chr(13)+"Ne najdem vrstice"+CHR(13)                                        , ;
            Chr(13)+"Preve√® kolon"+CHR(13)+"Poro√®ilo ne gre na list"+CHR(13) }

         oHmgApp():APP132  := { "Vrstica"    , ;
            "≈†tevilo vrstic"         , ;
            "       (Nova)"          , ;
            "      (Popravi)"        , ;
            "Vnesi ≈°tevilko vrstice" , ;
            "Poi≈°√®i"                 , ;
            "Besedilo za iskanje"    , ;
            "Datum za iskanje"       , ;
            "≈†tevilka za iskanje"    , ;
            "Parametri poro√®ila"     , ;
            "Kolon v poro√®ilu"       , ;
            "Kolon na razpolago"     , ;
            "Za√®etna vrstica"        , ;
            "Kon√®na vrstica"         , ;
            "Pporo√®ilo za "          , ;
            "Datum:"                 , ;
            "Za√®etna vrstica:"       , ;
            "Kon√®na vrstica:"        , ;
            "Urejeno po:"            , ;
            "Ja"                     , ;
            "Ne"                     , ;
            "Stran "                 , ;
            " od "                 }

         oHmgApp():APP133 := { "Zapri" , ;
            "Nova"              , ;
            "Uredi"             , ;
            "Bri≈°i"             , ;
            "Poi≈°√®i"            , ;
            "Pojdi na"          , ;
            "Poro√®ilo"          , ;
            "Prva"              , ;
            "Prej≈°nja"          , ;
            "Naslednja"         , ;
            "Zadnja"            , ;
            "Shrani"            , ;
            "Prekini"           , ;
            "Dodaj"             , ;
            "Odstrani"          , ;
            "Natisni"           , ;
            "Zapri"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                  , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {     ;
            "&Zapri",             ; // 1
            "&Nova",              ; // 2
            "&Spremeni",          ; // 3
            "&Bri≈°i",             ; // 4
            "&Poi≈°√®i",            ; // 5
            "&Natisni",           ; // 6
            "&Prekini",           ; // 7
            "&V redu",            ; // 8
            "&Kopiraj",           ; // 9
            "&Aktiviraj Filter",  ; // 10
            "&Deaktiviraj Filter" } // 11
         oHmgApp():APP129 := {                 ;
            "Prazno",                        ; // 1
            "Vrstica",                       ; // 2
            "Skupaj",                        ; // 3
            "Activni indeks",                ; // 4
            "Mo≈ænosti",                      ; // 5
            "Nova vrstica",                  ; // 6
            "Spreminjaj vrstico",            ; // 7
            "Ozna√®i vrstico",                ; // 8
            "Najdi vrstico",                 ; // 9
            "Mo≈ænosti tiskanja",             ; // 10
            "Polja na razpolago",            ; // 11
            "Polja za tiskanje",             ; // 12
            "Tiskalniki na razpolago",       ; // 13
            "Prva vrstica za tiskanje",      ; // 14
            "Zadnja vrstica za tiskanje",    ; // 15
            "Bri≈°i vrstico",                 ; // 16
            "Pregled",                       ; // 17
            "Mini pregled strani",           ; // 18
            "Pogoj za filter: ",             ; // 19
            "Filtrirano: ",                  ; // 20
            "Mo≈ænosti filtra" ,              ; // 21
            "Polja v datoteki" ,             ; // 22
            "Operator za primerjavo",        ; // 23
            "Vrednost filtra",               ; // 24
            "Izberi polje za filter",        ; // 25
            "Izberi operator za primerjavo", ; // 26
            "Enako",                         ; // 27
            "Neenako",                       ; // 28
            "Ve√®je od",                      ; // 29
            "Manj≈°e od",                     ; // 30
            "Ve√®je ali enako od",            ; // 31
            "Manj≈°e ali enako od"            } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,; // 1
            "Vnesi vrednost (tekst)",                                                                                        ; // 2
            "Vnesi vrednost (≈°tevilka)",                                                                                     ; // 3
            "Izberi datum",                                                                                                  ; // 4
            "Ozna√®i za logi√®ni DA",                                                                                          ; // 5
            "Vnesi vrednost",                                                                                                ; // 6
            "Izberi vrstico in pritisni <V redu>",                                                                           ; // 7
            ABM_CRLF + "Pobrisali boste trenutno vrstico   " + ABM_CRLF + "Ste prepri√®ani?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "Ni aktivnega indeksa   " + ABM_CRLF + "Prosimo, izberite ga   " + ABM_CRLF,                          ; // 9
            ABM_CRLF + "Ne morem iskati po logi√®nih oz. memo poljih   " + ABM_CRLF,                                          ; // 10
            ABM_CRLF + "Ne najdem vrstice   " + ABM_CRLF,                                                                    ; // 11
            "Izberite polje, ki bo vklju√®eno na listo",                                                                      ; // 12
            "Izberite polje, ki NI vklju√®eno na listo",                                                                      ; // 13
            "Izberite tisklanik",                                                                                            ; // 14
            "Pritisnite gumb za vklju√®itev polja",                                                                           ; // 15
            "Pritisnite gumb za izklju√®itev polja",                                                                          ; // 16
            "Pritisnite gumb za izbor prve vrstice za tiskanje",                                                             ; // 17
            "Pritisnite gumb za izbor zadnje vrstice za tiskanje",                                                           ; // 18
            ABM_CRLF + "Ni ve√® polj za dodajanje   " + ABM_CRLF,                                                             ; // 19
            ABM_CRLF + "Najprej izberite ppolje za vklju√®itev   " + ABM_CRLF,                                                ; // 20
            ABM_CRLF + "Ni ve√® polj za izklju√®itev   " + ABM_CRLF,                                                           ; // 21
            ABM_CRLF + "Najprej izberite polje za izklju√®itev   " + ABM_CRLF,                                                ; // 22
            ABM_CRLF + "Niste izbrali nobenega polja   " + ABM_CRLF + "Prosom, izberite polje za tiskalnje   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Preve√® polj   " + ABM_CRLF + "Zmanj≈°ajte ≈°tevilo polj   " + ABM_CRLF,                                ; // 24
            ABM_CRLF + "Tiskalnik ni pripravljen   " + ABM_CRLF,                                                             ; // 25
            "Urejeno po",                                                                                                    ; // 26
            "Od vrstice",                                                                                                    ; // 27
            "do vrstice",                                                                                                    ; // 28
            "Ja",                                                                                                            ; // 29
            "Ne",                                                                                                            ; // 30
            "Stran:",                                                                                                        ; // 31
            ABM_CRLF + "Izberite tiskalnik   " + ABM_CRLF,                                                                   ; // 32
            "Filtrirano z",                                                                                                  ; // 33
            ABM_CRLF + "Aktiven filter v uporabi    " + ABM_CRLF,                                                            ; // 34
            ABM_CRLF + "Ne morem filtrirati z memo polji    " + ABM_CRLF,                                                    ; // 35
            ABM_CRLF + "Izberi polje za filtriranje    " + ABM_CRLF,                                                         ; // 36
            ABM_CRLF + "Izberi operator za filtriranje    " + ABM_CRLF,                                                      ; // 37
            ABM_CRLF + "Vnesi vrednost za filtriranje    " + ABM_CRLF,                                                       ; // 38
            ABM_CRLF + "Ni aktivnega filtra    " + ABM_CRLF,                                                                 ; // 39
            ABM_CRLF + "Deaktiviram filter?   " + ABM_CRLF,                                                                  ; // 40
            ABM_CRLF + "Vrstica zaklenjena - uporablja jo drug uporabnik    " + ABM_CRLF                                     } // 41

      OTHERWISE
         /////////////////////////////////////////////////////////////
         // DEFAULT ENGLISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Close Window'
         oHmgApp():APP331 [3] := 'Close not allowed'
         oHmgApp():APP331 [4] := 'Program Already Running'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancel'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED (ENGLISH DEFAULT)

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

      ENDCASE

      ********************************************************************************************************************************************************
   ELSE   // ANSI
      ********************************************************************************************************************************************************

      DO CASE

         // case cLang == "TRWIN" .OR. cLang == "TR"
      CASE cLang == "TR"

         /////////////////////////////////////////////////////////////
         // T‹RK«E
         ////////////////////////////////////////////////////////////

         // «Eﬁ›TL› MESAJLAR

         oHmgApp():APP331 [1] := 'Emin misiniz ?'
         oHmgApp():APP331 [2] := 'Pencereyi Kapat'
         oHmgApp():APP331 [3] := 'Kapat˝lam˝yor'
         oHmgApp():APP331 [4] := 'Program h‚len Áal˝˛˝yor'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Tamam'
         oHmgApp():APP331 [7] := '›ptal'
         oHmgApp():APP331 [8] := 'Syf.'

         // BROWSE MESAJLARI ( T‹RK«E )

         oHmgApp():APP136  := { ;
            "Pencere: ", ;
            " tan˝ms˝z. Program sonland˝r˝ld˝.", ;
            "HMG Hatas˝", ;
            "Kontrol: ", ;
            " / ", ;
            " ÷nceden tan˝ml˝. Program sonland˝r˝ld˝.", ;
            "Browse: GeÁersiz Tip. Program sonland˝r˝ld˝.", ;
            "Browse: Browse Áal˝˛ma alan˝nda olmayan sahalar iÁin " + ;
            "Append ibaresi kullan˝lamaz. Program sonland˝r˝ld˝.", ;
            "Bu kayd˝ ˛u anda ba˛ka biri editliyor.", ;
            "Uyar˝", ;
            "GeÁersiz giri˛"}

         oHmgApp():APP137 := { 'Emin misiniz ?' , 'Kay˝t silme' }

         // EDIT MESAJLARI ( T‹RK«E )

         oHmgApp():APP131   := { Chr(13)+"Kay˝t silme"+CHR(13)+"Emin misiniz ?"+CHR(13), ;
            Chr(13)+"Indeks dosyas˝ yok"+CHR(13)+"Arama yap˝lam˝yor"+CHR(13), ;
            Chr(13)+"Indeks dosyas˝ bulunamad˝"+CHR(13)+"Arama yap˝lam˝yor"+CHR(13), ;
            Chr(13)+"Memo ve mant˝ksal sahalarda"+CHR(13)+"Arama yap˝lamaz"+CHR(13), ;
            Chr(13)+"Kay˝t bulunamad˝"+CHR(13), ;
            Chr(13)+"«ok fazla s¸tun var"+CHR(13)+"Rapor sayfaya s˝m˝yor"+CHR(13) }

         oHmgApp():APP132  := { ;
            "Kay˝t", ;
            "Kay˝t say˝s˝", ;
            "       (Yeni)", ;
            "       (Edit)", ;
            " Kay˝t No.su :", ;
            "Ara", ;
            "Metin ara", ;
            "Tarih ara", ;
            "Say˝ ara", ;
            "Rapor tan˝m˝", ;
            "Rapor s¸tunlar˝", ;
            "M¸sait s¸tunlar", ;
            "›lk kay˝t", ;
            "Son kay˝t", ;
            "Rapor ad˝ ", ;
            "Tarih:", ;
            "›lk kay˝t:", ;
            "Son kay˝t:", ;
            "S˝ra d¸zeni:", ;
            "Evet", ;
            "Hay˝r", ;
            "Sayfa ", ;
            " / "}

         oHmgApp():APP133 := { ;
            "Kapat", ;
            "Yeni", ;
            "Edit", ;
            "Sil", ;
            "Ara", ;
            "Git", ;
            "Rapor", ;
            "›lk", ;
            "÷nceki", ;
            "Sonraki", ;
            "Son", ;
            "Kaydet", ;
            "›ptal", ;
            "Ekle", ;
            "Kald˝r", ;
            "Print", ;
            "Kapat"}

         oHmgApp():APP134  := { ;
            "EDIT, Áal˝˛ma alan˝ ismi noksan", ;
            "EDIT, bu Áal˝˛ma alan˝nda 16'dan fazla saha var", ;
            "EDIT, Tazeleme mod'u s˝n˝r ˆtesinde ( l¸tfen hatay˝ bildirin )", ;
            "EDIT, Temel olay numaras˝ s˝n˝r ˆtesinde ( l¸tfen hatay˝ bildirin )", ;
            "EDIT, Liste olay numaras˝ s˝n˝r ˆtesinde ( l¸tfen hatay˝ bildirin )" }

         // EDIT EXTENDED MESAJLARI ( T‹RK«E )

         oHmgApp():APP128 := { ;
            "&Kapat",;                // 1
            "&Yeni",;                 // 2
            "&Dei˛tir",;             // 3
            "&Sil",;                  // 4
            "&Ara",;                  // 5
            "&Print",;                // 6
            "&›ptal",;                // 7
            "&Tamam",;                // 8
            "&Kopyala",;              // 9
            "&S¸zgeÁi etkinle˛tir",;  // 10
            "&S¸zgeÁi kald˝r" }       // 11

         oHmgApp():APP129 := { ;
            "Yok",;                         // 1
            "Kay˝t",;                       // 2
            "Toplam",;                      // 3
            "Aktif s˝ra",;                  // 4
            "SeÁenekler",;                  // 5
            "Yeni kay˝t",;                  // 6
            "Kayd˝ dei˛tir",;              // 7
            "Kay˝t seÁ",;                   // 8
            "Kay˝t ara",;                   // 9
            "Print seÁenekleri",;           // 10
            "M¸sait sahalar",;              // 11
            "Print edilecek sahalar",;      // 12
            "M¸sait printerler",;           // 13
            "Print ediecek ilk kay˝t",;     // 14
            "Print ediecek son kay˝t",;     // 15
            "Kay˝t sil",;                   // 16
            "÷nizleme",;                    // 17
            "Sayfa ikonlar˝n˝ gˆster",;     // 18
            "S¸zgeÁ ˛art˝: ",;              // 19
            "S¸zgeÁli: ",;                  // 20
            "S¸zgeÁ seÁenekleri" ,;         // 21
            "Database Sahalar˝",;           // 22
            "Kar˛˝la˛t˝rma operatˆrleri",;  // 23
            "S¸zgeÁ deeri",;               // 24
            "S¸zgeÁlenecek sahalar˝ seÁ",;  // 25
            "Kar˛˝la˛t˝rma operatˆr¸ seÁ",; // 26
            "E˛it",;                        // 27
            "E˛it deil",;                  // 28
            "Daha b¸y¸k",;                  // 29
            "Daha k¸Á¸k",;                  // 30
            "Daha b¸y¸k veya e˛it",;        // 31
            "Daha k¸Á¸k veya e˛it"}         // 32

         oHmgApp():APP130 := { ABM_CRLF + ;
            "Aktif bir alan bulunamad˝."  + ABM_CRLF + ;
            "L¸tfen EDIT'i Áa˝rmadan ˆnce bir alan seÁin" + ABM_CRLF,;           //  1
            "Saha deeri girin ( metin )",;                                       //  2
            "Saha deeri girin ( say˝ )",;                                        //  3
            "Tarih seÁimi",;                                                      //  4
            "Doru deeri onayla",;                                               //  5
            "Saha deeri girin",;                                                 //  6
            "Bir kay˝t seÁip 'Tamam'a bas˝n",;                                    //  7
            ABM_CRLF + "Aktif kayd˝ silmek ¸zeresiniz" + ABM_CRLF + ;
            "Emin misiniz ?    " + ABM_CRLF,;                          //  8
            ABM_CRLF + "Aktif bir s˝ra d¸zeni yok   " + ABM_CRLF + ;
            "L¸tfen birini seÁin " + ABM_CRLF,;                        //  9
            ABM_CRLF + "Memo ve mant˝ksal sahada arama yap˝lam˝yor." + ABM_CRLF,; // 10
            ABM_CRLF + "Kay˝t bulunmad˝   " + ABM_CRLF,;                          // 11
            "Listeye girecek sahay˝ seÁin",;                                      // 12
            "Listeye girmeyecek sahay˝ seÁin",;                                   // 13
            "Printer seÁin",;                                                     // 14
            "Sahay˝ eklemek iÁin d¸meye bas˝n",;                                 // 15
            "Sahay˝ Á˝karmak iÁin d¸meye bas˝n",;                                // 16
            "Print edilecek ilk kayd˝ seÁmek iÁin d¸meye bas˝n",;                // 17
            "Print edilecek son kayd˝ seÁmek iÁin d¸meye bas˝n",;                // 18
            ABM_CRLF + "Eklenecek ba˛ka saha yok.   " + ABM_CRLF,;                // 19
            ABM_CRLF + "÷nce eklenecek sahay˝ seÁin"   + ABM_CRLF,;               // 20
            ABM_CRLF + "D˝˛lanacak ba˛ka saha yok   "   + ABM_CRLF,;              // 21
            ABM_CRLF + "÷nce Á˝kar˝lacak sahay˝ seÁin   " + ABM_CRLF,;            // 22
            ABM_CRLF + "Bir saha bile seÁilmedi   " + ABM_CRLF + ;
            "L¸tfen print edilecek sahalar˝ seÁin" + ABM_CRLF,;        // 23
            ABM_CRLF + "«ok fazla saha" + ABM_CRLF + ;
            "Saha say˝s˝n˝ azalt˝n" + ABM_CRLF,;                       // 24
            ABM_CRLF + "Printer haz˝r deil   " + ABM_CRLF,;                      // 25
            "S˝ra d¸zeni",;                                                       // 26
            "›lk Kay˝t",;                                                         // 27
            "Son kay˝t",;                                                         // 28
            "Evet",;                                                              // 29
            "Hay˝r",;                                                             // 30
            "Sayfa:",;                                                            // 31
            ABM_CRLF + "L¸tfen bir printer seÁin" + ABM_CRLF,;                    // 32
            "S¸zgeÁ : ",;                                                         // 33
            ABM_CRLF + "Aktif s¸zgeÁ yok" + ABM_CRLF,;                            // 34
            ABM_CRLF + "Memo sahalar s¸zgeÁlenemiyor    " + ABM_CRLF,;            // 35
            ABM_CRLF + "S¸zgeÁelenecek sahay˝ seÁin    " + ABM_CRLF,;             // 36
            ABM_CRLF + "S¸zgeÁ iÁin bir operatˆr seÁin    " + ABM_CRLF,;          // 37
            ABM_CRLF + "S¸zgeÁ iÁi bir deer yaz˝n    " + ABM_CRLF,;              // 38
            ABM_CRLF + "Aktif bir s¸zgeÁ yok    " + ABM_CRLF,;                    // 39
            ABM_CRLF + "S¸zgeÁ kald˝r˝ls˝n m˝   " + ABM_CRLF,;                    // 40
            ABM_CRLF + "Kayd˝ ba˛ka bir kullan˝c˝ kilitlemi˛    " + ABM_CRLF }    // 41

         // case cLang ==  "CS" .OR. cLang == "CSWIN"
      CASE cLang ==  "CS"
         /////////////////////////////////////////////////////////////
         // CZECH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP331 [1] := 'Jste si jist(a)?'
         oHmgApp():APP331 [2] := 'Zav¯i okno'
         oHmgApp():APP331 [3] := 'Uzav¯enÌ zak·z·no'
         oHmgApp():APP331 [4] := 'Program uû bÏûÌ'
         oHmgApp():APP331 [5] := '⁄prava'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Storno'
         oHmgApp():APP331 [8] := 'Str.'

         // BROWSE MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP136  := { "Okno: "                                              , ;
            " nenÌ definov·no. Program ukonËen"                   , ;
            "HMG Error"                                         , ;
            "Prvek: "                                             , ;
            " z "                                                  , ;
            " uû definov·n. Program ukonËen"                  , ;
            "Browse: Typ nepovolen. Program ukonËen"          , ;
            "Browse: Append fr·zi nelze pouûÌt s poli nepat¯ÌcÌmi do Browse pracovnÌ oblasti. Program ukonËen", ;
            "Z·znam edituje jin˝ uûivatel"                , ;
            "Varov·nÌ"                                              , ;
            "Chybn˝ vstup"                                          }
         oHmgApp():APP137 := { 'Jste si jist(a)?' , 'Smazat z·znam' }

         // EDIT MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP131   := { Chr(13)+"Smazat z·znam"+CHR(13)+"Jste si jist(a)?"+CHR(13)                  , ;
            Chr(13)+"ChybÌ indexov˝ soubor"+CHR(13)+"Nemohu hledat"+CHR(13)            , ;
            Chr(13)+"Nemohu najÌt indexovanÈ pole"+CHR(13)+"Nemohu hledat"+CHR(13)        , ;
            Chr(13)+"Nemohu hledat podle"+CHR(13)+"pole memo nebo logickÈ"+CHR(13)       , ;
            Chr(13)+"Z·znam nenalezen"+CHR(13)                                        , ;
            Chr(13)+"P¯Ìliö mnoho sloupc˘"+CHR(13)+"Sestava se nevejde na plochu"+CHR(13) }

         oHmgApp():APP132  := { "Z·znam"      , ;
            "PoËet z·znam˘"         , ;
            "      (Nov˝)"          , ;
            "     (⁄prava)"         , ;
            "Zadejte ËÌslo z·znamu" , ;
            "Hledej"                , ;
            "Hledan˝ text"          , ;
            "HledanÈ datum"         , ;
            "HledanÈ ËÌslo"         , ;
            "Definice sestavy"      , ;
            "Sloupce sestavy"       , ;
            "DostupnÈ sloupce"      , ;
            "PrvnÌ z·znam"          , ;
            "PoslednÌ z·znam"       , ;
            "Sestava "              , ;
            "Datum:"                , ;
            "PrvnÌ z·znam:"         , ;
            "PoslednÌ z·znam:"      , ;
            "T¯ÌdÏno dle:"          , ;
            "Ano"                   , ;
            "Ne"                    , ;
            "Strana "               , ;
            " z "                   }

         oHmgApp():APP133 := { "Zav¯Ìt"    , ;
            "Nov˝"      , ;
            "⁄prava"    , ;
            "Smaû"      , ;
            "Najdi"     , ;
            "Jdi"       , ;
            "Sestava"   , ;
            "PrvnÌ"     , ;
            "P¯edchozÌ" , ;
            "DalöÌ"     , ;
            "PoslednÌ"  , ;
            "Uloû"      , ;
            "Storno"    , ;
            "P¯idej"    , ;
            "OdstraÚ"   , ;
            "Tisk"      , ;
            "Zav¯i"     }
         oHmgApp():APP134  := { "EDIT, chybÌ jmÈno pracovnÌ oblasti"                              , ;
            "EDIT, pracovnÌ oblast m· vÌc jak 16 polÌ"              , ;
            "EDIT, refresh mode mimo rozsah (prosÌm, nahlaste chybu)"      , ;
            "EDIT, hlavnÌ event ËÌslo mimo rozsah (prosÌm, nahlaste chybu)" , ;
            "EDIT, list event ËÌslomimo rozsah (prosÌm, nahlaste chybu)"  }

         // EDIT EXTENDED (ENGLISH DEFAULT)

         oHmgApp():APP128 := {            ;
            "&Zav¯i",            ; // 1
            "&Nov˝",             ; // 2
            "⁄&prava",           ; // 3
            "S&maû  ",           ; // 4
            "Na&jdi",            ; // 5
            "&Tisk",             ; // 6
            "&Storno",           ; // 7
            "&Ok",               ; // 8
            "&KopÌruj",          ; // 9
            "Aktivuj &filtr",    ; // 10
            "&Vypni filtr" }       // 11
         oHmgApp():APP129 := {                        ;
            "é·dn˝",                        ; // 1
            "Z·znam",                       ; // 2
            "Suma",                         ; // 3
            "AktivnÌ t¯ÌdÏnÌ",              ; // 4
            "Volby",                        ; // 5
            "Nov˝ z·znam",                  ; // 6
            "Uprav z·znam",                 ; // 7
            "Vyber z·znam",                 ; // 8
            "Najdi z·znam",                 ; // 9
            "Tiskni volby",                 ; // 10
            "Dostupn· pole",                ; // 11
            "Pole k tisku",                 ; // 12
            "DostupnÈ tisk·rny",            ; // 13
            "PrvnÌ z·znam k tisku",         ; // 14
            "PoslednÌ z·znam k tisku",      ; // 15
            "Smaû z·znam",                  ; // 16
            "N·hled",                       ; // 17
            "Zobraz miniatury stran",       ; // 18
            "Filtr: ",                      ; // 19
            "Filtrov·n: ",                  ; // 20
            "Volby filtru",                 ; // 21
            "Pole datab·ze",                ; // 22
            "Oper·tor porovn·nÌ",           ; // 23
            "Hodnota filtru",               ; // 24
            "Vyber pole do filtru",         ; // 25
            "Vyber oper·tor porovn·nÌ",     ; // 26
            "rovno",                        ; // 27
            "nerovno",                      ; // 28
            "vÏtöÌ neû",                    ; // 29
            "menöÌ neû",                    ; // 30
            "vÏtöÌ nebo rovno neû",         ; // 31
            "menöÌ nebo rovno neû",         } // 32

         oHmgApp():APP130 := { ;
            ABM_CRLF + "Nelze najÌt aktivnÌ oblast   "  + ABM_CRLF + "ProsÌm vyberte nÏkterou p¯ed vol·nÌm EDIT   " + ABM_CRLF,     ; // 1
            "Zadejte hodnotu pole (libovoln˝ text)",                                                                                ; // 2
            "Zadejte hodnotu pole (libovolnÈ ËÌslo)",                                                                               ; // 3
            "Vyberte datum",                                                                                                        ; // 4
            "ZatrhnÏte pro hodnotu true",                                                                                           ; // 5
            "Zadejte hodnotu pole",                                                                                                 ; // 6
            "Vyberte jak˝koliv z·znam s stisknÏte OK",                                                                              ; // 7
            ABM_CRLF + "Chcete smazat tento z·znam  " + ABM_CRLF + "Jste si jist(a)?    " + ABM_CRLF,                               ; // 8
            ABM_CRLF + "NenÌ vybr·no û·dnÈ t¯ÌdÏnÌ   " + ABM_CRLF + "ProsÌm zvolte jedno   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Nelze hledat podle pole memo nebo logic   " + ABM_CRLF,                                                     ; // 10
            ABM_CRLF + "Z·znam nenalezen   " + ABM_CRLF,                                                                            ; // 11
            "Vyberte pole k za¯azenÌ do seznamu",                                                                                   ; // 12
            "Vyberte pole k vy¯azenÌ ze seznamu",                                                                                   ; // 13
            "Vyberte tisk·rnu",                                                                                                     ; // 14
            "StisknÏte tlaËÌtko pro za¯azenÌ pole",                                                                                 ; // 15
            "StisknÏtÏ tlaËÌtko k vy¯azenÌ pole",                                                                                   ; // 16
            "StisknÏte tlaËÌtko k v˝bÏru prvnÌho z·znamu k tisku",                                                                  ; // 17
            "StisknÏtÏ tlaËÌtko k v˝bÏru poslednÌho z·znamu k tisku",                                                               ; // 18
            ABM_CRLF + "K za¯azenÌ nezb˝vajÌ pole   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "PrvnÌ v˝bÏr pole k za¯azenÌ   " + ABM_CRLF,                                                                 ; // 20
            ABM_CRLF + "Nelze vy¯adit dalöÌ pole   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "PrvnÌ v˝bÏr pole k vy¯azenÌ   " + ABM_CRLF,                                                                 ; // 22
            ABM_CRLF + "Nebylo vybr·no û·dnÈ pole   " + ABM_CRLF + "ProsÌm vyberte pole pro za¯azenÌ do tisku   " + ABM_CRLF,       ; // 23
            ABM_CRLF + "P¯Ìliö mnoho polÌ   " + ABM_CRLF + "odeberte nÏkter· pole   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Tisk·rna nenÌ p¯ipravena   " + ABM_CRLF,                                                                    ; // 25
            "T¯ÌdÏno dle",                                                                                                          ; // 26
            "Od z·znamu",                                                                                                           ; // 27
            "Do z·znamu",                                                                                                           ; // 28
            "Ano",                                                                                                                  ; // 29
            "Ne",                                                                                                                   ; // 30
            "Strana:",                                                                                                              ; // 31
            ABM_CRLF + "ProsÌm vyberte tisk·rnu   " + ABM_CRLF,                                                                     ; // 32
            "Filtrov·no dle",                                                                                                       ; // 33
            ABM_CRLF + "Filtr nenÌ aktivnÌ    " + ABM_CRLF,                                                                         ; // 34
            ABM_CRLF + "Nelze filtrovat podle memo    " + ABM_CRLF,                                                                 ; // 35
            ABM_CRLF + "Vyberte pole do filtru    " + ABM_CRLF,                                                                     ; // 36
            ABM_CRLF + "Vybarte oper·tor do filtru    " + ABM_CRLF,                                                                 ; // 37
            ABM_CRLF + "Zadejte hodnotu do filtru    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "NenÌ û·dn˝ aktivnÌ filtr    " + ABM_CRLF,                                                                   ; // 39
            ABM_CRLF + "Deactivovat filtr?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Z·znam uzamËen jin˝m uûivatelem  " + ABM_CRLF                                                                   } // 41

         /////////////////////////////////////////////////////////////
         // CROATIAN
         ////////////////////////////////////////////////////////////
         // case cLang == "HR852" // Croatian
      CASE cLang == "HR"

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Zatvori prozor'
         oHmgApp():APP331 [3] := 'Zatvaranje nije dozvoljeno'
         oHmgApp():APP331 [4] := 'Program je veÊ pokrenut'
         oHmgApp():APP331 [5] := 'Uredi'
         oHmgApp():APP331 [6] := 'U redu'
         oHmgApp():APP331 [7] := 'Prekid'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED MESSAGES

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

      CASE cLang == "EU"        // Basque.
         /////////////////////////////////////////////////////////////
         // BASQUE
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Close Window'
         oHmgApp():APP331 [3] := 'Close not allowed'
         oHmgApp():APP331 [4] := 'Program Already Running'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancel'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            "&Itxi",             ; // 1
            "&Berria",           ; // 2
            "&Aldatu",           ; // 3
            "&Ezabatu",          ; // 4
            "Bi&latu",           ; // 5
            "In&primatu",        ; // 6
            "&Utzi",             ; // 7
            "&Ok",               ; // 8
            "&Kopiatu",          ; // 9
            "I&ragazkia Ezarri", ; // 10
            "Ira&gazkia Kendu"   } // 11
         oHmgApp():APP129 := {                              ;
            "Bat ere ez",                         ; // 1
            "Erregistroa",                        ; // 2
            "Guztira",                            ; // 3
            "Orden Aktiboa",                      ; // 4
            "Aukerak",                            ; // 5
            "Erregistro Berria",                  ; // 6
            "Erregistroa Aldatu",                 ; // 7
            "Erregistroa Aukeratu",               ; // 8
            "Erregistroa Bilatu",                 ; // 9
            "Inprimatze-aukerak",                 ; // 10
            "Eremu Libreak",                      ; // 11
            "Inprimatzeko Eremuak",               ; // 12
            "Inprimagailu Libreak",               ; // 13
            "Inprimatzeko Lehenengo Erregistroa", ; // 14
            "Inprimatzeko Azken Erregistroa",     ; // 15
            "Erregistroa Ezabatu",                ; // 16
            "Aurreikusi",                         ; // 17
            "Orrien Irudi Txikiak Ikusi",         ; // 18
            "Iragazkiaren Baldintza: ",           ; // 19
            "Iragazita: ",                        ; // 20
            "Iragazte-aukerak" ,                  ; // 21
            "Datubasearen Eremuak" ,              ; // 22
            "Konparaketa Eragilea",               ; // 23
            "Iragazkiaren Balioa",                ; // 24
            "Iragazteko Eremua Aukeratu",         ; // 25
            "Konparaketa Eragilea Aukeratu",      ; // 26
            "Berdin",                             ; // 27
            "Ezberdin",                           ; // 28
            "Handiago",                           ; // 29
            "Txikiago",                           ; // 30
            "Handiago edo Berdin",                ; // 31
            "Txikiago edo Berdin"                 } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Ezin da area aktiborik aurkitu.   "  + ABM_CRLF + "Mesedez aukeratu area EDIT deitu baino lehen   " + ABM_CRLF,  ; // 1
            "Eremuaren balioa idatzi (edozein testu)",                                                                                   ; // 2
            "Eremuaren balioa idatzi (edozein zenbaki)",                                                                                 ; // 3
            "Data aukeratu",                                                                                                             ; // 4
            "Markatu egiazko baliorako",                                                                                                 ; // 5
            "Eremuaren balioa sartu",                                                                                                    ; // 6
            "Edozein erregistro aukeratu eta OK sakatu",                                                                                 ; // 7
            ABM_CRLF + "Erregistro aktiboa ezabatuko duzu   " + ABM_CRLF + "Ziur zaude?    " + ABM_CRLF,                                 ; // 8
            ABM_CRLF + "Ez dago orden aktiborik   " + ABM_CRLF + "Mesedez aukeratu bat   " + ABM_CRLF,                                   ; // 9
            ABM_CRLF + "Memo edo eremu logikoen arabera ezin bilaketarik egin   " + ABM_CRLF,                                            ; // 10
            ABM_CRLF + "Erregistroa ez da aurkitu   " + ABM_CRLF,                                                                        ; // 11
            "Zerrendan sartzeko eremua aukeratu",                                                                                        ; // 12
            "Zerrendatik kentzeko eremua aukeratu",                                                                                      ; // 13
            "Inprimagailua aukeratu",                                                                                                    ; // 14
            "Sakatu botoia eremua sartzeko",                                                                                             ; // 15
            "Sakatu botoia eremua kentzeko",                                                                                             ; // 16
            "Sakatu botoia inprimatzeko lehenengo erregistroa aukeratzeko",                                                              ; // 17
            "Sakatu botoia inprimatzeko azken erregistroa aukeratzeko",                                                                  ; // 18
            ABM_CRLF + "Sartzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 19
            ABM_CRLF + "Lehenago aukeratu sartzeko eremua   " + ABM_CRLF,                                                                ; // 20
            ABM_CRLF + "Kentzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 21
            ABM_CRLF + "Lehenago aukeratu kentzeko eremua   " + ABM_CRLF,                                                                ; // 22
            ABM_CRLF + "Ez duzu eremurik aukeratu  " + ABM_CRLF + "Mesedez aukeratu inprimaketan sartzeko eremuak   " + ABM_CRLF,        ; // 23
            ABM_CRLF + "Eremu gehiegi   " + ABM_CRLF + "Murriztu eremu kopurua   " + ABM_CRLF,                                           ; // 24
            ABM_CRLF + "Inprimagailua ez dago prest   " + ABM_CRLF,                                                                      ; // 25
            "Ordenatuta honen arabera:",                                                                                                 ; // 26
            "Erregistro honetatik:",                                                                                                     ; // 27
            "Erregistro honetara:",                                                                                                      ; // 28
            "Bai",                                                                                                                       ; // 29
            "Ez",                                                                                                                        ; // 30
            "Orrialdea:",                                                                                                                ; // 31
            ABM_CRLF + "Mesedez aukeratu inprimagailua   " + ABM_CRLF,                                                                   ; // 32
            "Iragazita honen arabera:",                                                                                                  ; // 33
            ABM_CRLF + "Iragazki aktiboa dago    " + ABM_CRLF,                                                                           ; // 34
            ABM_CRLF + "Ezin iragazi Memo eremuen arabera    " + ABM_CRLF,                                                               ; // 35
            ABM_CRLF + "Iragazteko eremua aukeratu    " + ABM_CRLF,                                                                      ; // 36
            ABM_CRLF + "Iragazteko edozein eragile aukeratu    " + ABM_CRLF,                                                             ; // 37
            ABM_CRLF + "Idatzi edozein balio iragazteko    " + ABM_CRLF,                                                                 ; // 38
            ABM_CRLF + "Ez dago iragazki aktiborik    " + ABM_CRLF,                                                                      ; // 39
            ABM_CRLF + "Iragazkia kendu?   " + ABM_CRLF,                                                                                  ; // 40
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

      CASE cLang == "EN"        // English
         /////////////////////////////////////////////////////////////
         // ENGLISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Close Window'
         oHmgApp():APP331 [3] := 'Close not allowed'
         oHmgApp():APP331 [4] := 'Program Already Running'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancel'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED (ENGLISH DEFAULT)

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

      CASE cLang == "FR"        // French
         /////////////////////////////////////////////////////////////
         // FRENCH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Etes-vous s˚re ?'
         oHmgApp():APP331 [2] := 'Fermer la fenÍtre'
         oHmgApp():APP331 [3] := 'Fermeture interdite'
         oHmgApp():APP331 [4] := 'Programme dÈj‡ activÈ'
         oHmgApp():APP331 [5] := 'Editer'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Abandonner'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "FenÍtre: "                                             , ;
            " n'est pas dÈfinie. Programme terminÈ"                 , ;
            "Erreur HMG"                                        , ;
            "ContrÙle: "                                            , ;
            " De "                                                  , ;
            " DÈj‡ dÈfini. Programme terminÈ"                       , ;
            "Modification: Type non autorisÈ. Programme terminÈ"    , ;
            "Modification: La clause Ajout ne peut Ítre utilisÈe avec des champs n'appartenant pas ‡ la zone de travail de Modification. Programme terminÈ", ;
            "L'enregistrement est utilisÈ par un autre utilisateur"  , ;
            "Erreur"                                                , ;
            "EntrÈe invalide"                                        }
         oHmgApp():APP137 := { 'Etes-vous s˚re ?' , 'Enregistrement dÈtruit' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Suppression d'enregistrement"+CHR(13)+"Etes-vous s˚re ?"+CHR(13)  , ;
            Chr(13)+"Index manquant"+CHR(13)+"Recherche impossible"+CHR(13)            , ;
            Chr(13)+"Champ Index introuvable"+CHR(13)+"Recherche impossible"+CHR(13)   , ;
            Chr(13)+"Recherche impossible"+CHR(13)+"sur champs memo ou logique"+CHR(13), ;
            Chr(13)+"Enregistrement non trouvÈ"+CHR(13)                                                     , ;
            Chr(13)+"Trop de colonnes"+CHR(13)+"L'Ètat ne peut Ítre imprimÈ"+CHR(13)      }
         oHmgApp():APP132  := { "Enregistrement"                       , ;
            "Nb. total enr."                       , ;
            "   (Ajouter)"                        , ;
            "  (Modifier)"                        , ;
            "Entrez le numÈro de l'enregistrement" , ;
            "Trouver"                              , ;
            "Chercher texte"                       , ;
            "Chercher date"                        , ;
            "Chercher numÈro"                      , ;
            "DÈfinition de l'Ètat"                 , ;
            "Colonnes de l'Ètat"                   , ;
            "Colonnes disponibles"                 , ;
            "Enregistrement de dÈbut"              , ;
            "Enregistrement de fin"                , ;
            "Etat de "                             , ;
            "Date:"                                , ;
            "Enregistrement de dÈbut:"             , ;
            "Enregistrement de fin:"               , ;
            "TriÈ par:"                            , ;
            "Oui"                                  , ;
            "Non"                                  , ;
            " Page"                                , ;
            " de "                                 }
         oHmgApp():APP133 := { "Fermer"      , ;
            "Nouveau"     , ;
            "Modifier"    , ;
            "Supprimer"   , ;
            "Trouver"     , ;
            "Aller ‡"     , ;
            "Etat"   , ;
            "Premier"     , ;
            "PrÈcÈdent"   , ;
            "Suivant"     , ;
            "Dernier"     , ;
            "Enregistrer" , ;
            "Annuler"     , ;
            "Ajouter"     , ;
            "Retirer"     , ;
            "Imprimer"    , ;
            "Fermer"      }
         oHmgApp():APP134  := { "EDIT, nom de la table manquant"                                         , ;
            "EDIT, la table a plus de 16 champs"                                     , ;
            "EDIT, mode rafraichissement hors limite (Rapport d'erreur merci)"       , ;
            "EDIT, ÈvÈnement principal nombre hors limite (Rapport d'erreur merci)"  , ;
            "EDIT, liste d'ÈvÈnements nombre hors limite (Rapport d'erreur merci)"   }

         // EDIT EXTENDED

         oHmgApp():APP128 := {           ;
            "&Fermer",          ; // 1
            "&Nouveau",         ; // 2
            "&Modifier",        ; // 3
            "&Supprimer",       ; // 4
            "&Trouver",         ; // 5
            "&Imprimer",        ; // 6
            "&Abandon",         ; // 7
            "&Ok",              ; // 8
            "&Copier",          ; // 9
            "&Activer Filtre",  ; // 10
            "&DÈactiver Filtre" } // 11
         oHmgApp():APP129 := {                                   ;
            "Aucun",                                   ; // 1
            "Enregistrement",                          ; // 2
            "Total",                                   ; // 3
            "Ordre actif",                             ; // 4
            "Options",                                 ; // 5
            "Nouvel enregistrement",                   ; // 6
            "Modifier enregistrement",                 ; // 7
            "Selectionner enregistrement",             ; // 8
            "Trouver enregistrement",                  ; // 9
            "Imprimer options",                        ; // 10
            "Champs disponibles",                      ; // 11
            "Champs ‡ imprimer",                       ; // 12
            "Imprimantes connectÈes",                  ; // 13
            "Premier enregistrement ‡ imprimer",       ; // 14
            "Dernier enregistrement ‡ imprimer",       ; // 15
            "Enregistrement supprimÈ",                 ; // 16
            "PrÈvisualisation",                        ; // 17
            "AperÁu pages",                            ; // 18
            "Condition filtre : ",                     ; // 19
            "FiltrÈ : ",                               ; // 20
            "Options de filtrage" ,                    ; // 21
            "Champs de la Bdd" ,                       ; // 22
            "OpÈrateurs de comparaison",               ; // 23
            "Valeur du filtre",                        ; // 24
            "Selectionner le champ ‡ filtrer",         ; // 25
            "Selectionner l'opÈrateur de comparaison", ; // 26
            "Egal",                                    ; // 27
            "DiffÈrent",                               ; // 28
            "Plus grand",                              ; // 29
            "Plus petit",                              ; // 30
            "Plus grand ou Ègal",                      ; // 31
            "Plus petit ou Ègal"                       } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Ne peut trouver une base active.   "  + ABM_CRLF + "SÈlectionner une base avant la fonction EDIT  " + ABM_CRLF,           ; // 1
            "Entrer la valeur du champ (du texte)",                                                                                               ; // 2
            "Entrer la valeur du champ (un nombre)",                                                                                              ; // 3
            "SÈlectionner la date",                                                                                                               ; // 4
            "VÈrifier la valeur logique",                                                                                                         ; // 5
            "Entrer la valeur du champ",                                                                                                          ; // 6
            "SÈlectionner un enregistrement et appuyer sur OK",                                                                                   ; // 7
            ABM_CRLF + "Vous voulez dÈtruire l'enregistrement actif  " + ABM_CRLF + "Etes-vous s˚re?   " + ABM_CRLF,                              ; // 8
            ABM_CRLF + "Il n'y a pas d'ordre actif   " + ABM_CRLF + "SÈlectionner en un   " + ABM_CRLF,                                           ; // 9
            ABM_CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + ABM_CRLF,                                                      ; // 10
            ABM_CRLF + "Enregistrement non trouvÈ  " + ABM_CRLF,                                                                                  ; // 11
            "SÈlectionner le champ ‡ inclure ‡ la liste",                                                                                         ; // 12
            "SÈlectionner le champ ‡ exclure de la liste",                                                                                        ; // 13
            "SÈlectionner l'imprimante",                                                                                                          ; // 14
            "Appuyer sur le bouton pour inclure un champ",                                                                                        ; // 15
            "Appuyer sur le bouton pour exclure un champ",                                                                                        ; // 16
            "Appuyer sur le bouton pour sÈlectionner le premier enregistrement ‡ imprimer",                                                       ; // 17
            "Appuyer sur le bouton pour sÈlectionner le dernier champ ‡ imprimer",                                                                ; // 18
            ABM_CRLF + "Plus de champs ‡ inclure   " + ABM_CRLF,                                                                                  ; // 19
            ABM_CRLF + "SÈlectionner d'abord les champs ‡ inclure   " + ABM_CRLF,                                                                 ; // 20
            ABM_CRLF + "Plus de champs ‡ exclure   " + ABM_CRLF,                                                                                  ; // 21
            ABM_CRLF + "SÈlectionner d'abord les champs ‡ exclure   " + ABM_CRLF,                                                                 ; // 22
            ABM_CRLF + "Vous n'avez sÈlectionnÈ aucun champ   " + ABM_CRLF + "SÈlectionner les champs ‡ inclure dans l'impression   " + ABM_CRLF, ; // 23
            ABM_CRLF + "Trop de champs   " + ABM_CRLF + "RÈduiser le nombre de champs   " + ABM_CRLF,                                             ; // 24
            ABM_CRLF + "Imprimante pas prÍte   " + ABM_CRLF,                                                                                      ; // 25
            "TriÈ par",                                                                                                                           ; // 26
            "De l'enregistrement",                                                                                                                ; // 27
            "A l'enregistrement",                                                                                                                 ; // 28
            "Oui",                                                                                                                                ; // 29
            "Non",                                                                                                                                ; // 30
            "Page:",                                                                                                                              ; // 31
            ABM_CRLF + "SÈlectionner une imprimante   " + ABM_CRLF,                                                                               ; // 32
            "FiltrÈ par",                                                                                                                         ; // 33
            ABM_CRLF + "Il y a un filtre actif    " + ABM_CRLF,                                                                                   ; // 34
            ABM_CRLF + "Filtre impossible sur champ memo    " + ABM_CRLF,                                                                         ; // 35
            ABM_CRLF + "SÈlectionner un champ de filtre    " + ABM_CRLF,                                                                          ; // 36
            ABM_CRLF + "SÈlectionner un opÈrateur de filtre   " + ABM_CRLF,                                                                       ; // 37
            ABM_CRLF + "Entrer une valeur au filtre    " + ABM_CRLF,                                                                              ; // 38
            ABM_CRLF + "Il n'y a aucun filtre actif    " + ABM_CRLF,                                                                              ; // 39
            ABM_CRLF + "DÈsactiver le filtre?   " + ABM_CRLF,                                                                                     ; // 40
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

         // case cLang == "DEWIN" .OR. cLang == "DE"       // German
      CASE cLang == "DE"
         /////////////////////////////////////////////////////////////
         // GERMAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Sind Sie sicher ?'
         oHmgApp():APP331 [2] := 'Fenster schlieﬂen'
         oHmgApp():APP331 [3] := 'Schlieﬂen nicht erlaubt'
         oHmgApp():APP331 [4] := 'Programm l‰uft bereits'
         oHmgApp():APP331 [5] := 'Bearbeiten'
         oHmgApp():APP331 [6] := 'OK'
         oHmgApp():APP331 [7] := 'Abbrechen'
         oHmgApp():APP331 [8] := 'Seite'

         // BROWSE

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Sind Sie sicher ?' , 'Datensatz lˆschen' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Datensatz loeschen"+CHR(13)+"Sind Sie sicher ?"+CHR(13)                 , ;
            Chr(13)+" Falscher Indexdatensatz"+CHR(13)+"Suche unmoeglich"+CHR(13)         , ;
            Chr(13)+"Man kann nicht Indexdatenfeld finden"+CHR(13)+"Suche unmoeglich"+CHR(13) , ;
            Chr(13)+"Suche unmoeglich nach"+CHR(13)+"Feld memo oder logisch"+CHR(13)         , ;
            Chr(13)+"Datensatz nicht gefunden"+CHR(13)                                                     , ;
            Chr(13)+" zu viele Spalten"+CHR(13)+"Zu wenig Platz  fuer die Meldung auf dem Blatt" + Chr(13) }
         oHmgApp():APP132  := { "Datensatz"              , ;
            "Menge der Dat."        , ;
            "       (Neu)"        , ;
            " (Editieren)"        , ;
            "Datensatznummer eintragen" , ;
            "Suche"                , ;
            "Suche Text"         , ;
            "Suche Datum"         , ;
            "Suche Zahl"       , ;
            "Definition der Meldung"   , ;
            "Spalten der Meldung"      , ;
            "Zugaengliche Spalten"     , ;
            "Anfangsdatensatz"      , ;
            "Endedatensatz"        , ;
            "Datensatz vom "          , ;
            "Datum:"               , ;
            "Anfangsdatensatz:"     , ;
            "Endedatensatz:"       , ;
            "Sortieren nach:"         , ;
            "Ja"                 , ;
            "Nein"                  , ;
            "Seite "               , ;
            " von "                 }
         oHmgApp():APP133 := { "Schliesse"    , ;
            "Neu"      , ;
            "Editiere"     , ;
            "Loesche"   , ;
            "Finde"     , ;
            "Gehe zu"     , ;
            "Meldung"   , ;
            "Erster"    , ;
            "Zurueck" , ;
            "Naechst"     , ;
            "Letzter"     , ;
            "Speichern"     , ;
            "Aufheben"   , ;
            "Hinzufuegen"      , ;
            "Loeschen"   , ;
            "Drucken"    , ;
            "Schliessen"     }
         oHmgApp():APP134  := { "EDIT, falscher Name von Datenbank"                                  , ;
            "EDIT, Datenbank hat mehr als 16 Felder"                   , ;
            "EDIT, Auffrische-Modus ausser dem Bereich (siehe Fehlermeldungen)"      , ;
            "EDIT, Menge der Basisereignisse ausser dem Bereich (siehe Fehlermeldungen)" , ;
            "EDIT, Liste der Ereignisse ausser dem Bereich (siehe Fehlermeldungen)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {              ;
            "S&chlieﬂen",          ; // 1
            "&Neu",                ; // 2
            "&Bearbeiten",         ; // 3
            "&Lˆschen",            ; // 4
            "&Suchen",             ; // 5
            "&Drucken",            ; // 6
            "&Abbruch",            ; // 7
            "&Ok",                 ; // 8
            "&Kopieren",           ; // 9
            "&Filter aktivieren",  ; // 10
            "&Filter deaktivieren" } // 11
         oHmgApp():APP129 := {                                         ;
            "Keine",                                         ; // 1
            "Datensatz",                                     ; // 2
            "Gesamt",                                        ; // 3
            "Aktive Sortierung",                             ; // 4
            "Einstellungen",                                 ; // 5
            "Neuer Datensatz",                               ; // 6
            "Datensatz bearbeiten",                          ; // 7
            "Datensatz ausw‰hlen",                           ; // 8
            "Datensatz finden",                              ; // 9
            "Druckeinstellungen",                            ; // 10
            "Verf¸gbare Felder",                             ; // 11
            "Zu druckende Felder",                           ; // 12
            "Verf¸gbare Drucker",                            ; // 13
            "Erster zu druckender Datensatz",                ; // 14
            "Letzter zu druckender Datensatz",               ; // 15
            "Datensatz lˆschen",                             ; // 16
            "Vorschau",                                      ; // 17
            "‹bersicht",                                     ; // 18
            "Filterbedingung: ",                             ; // 19
            "Gefiltert: ",                                   ; // 20
            "Filter-Einstellungen" ,                         ; // 21
            "Datenbank-Felder" ,                             ; // 22
            "Vergleichs-Operator",                           ; // 23
            "Filterwert",                                    ; // 24
            "Zu filterndes Feld ausw‰hlen",                  ; // 25
            "Vergleichs-Operator ausw‰hlen",                 ; // 26
            "Gleich",                                        ; // 27
            "Ungleich",                                      ; // 28
            "Grˆﬂer als",                                    ; // 29
            "Kleiner als",                                   ; // 30
            "Grˆﬂer oder gleich als",                        ; // 31
            "Kleiner oder gleich als"                        } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Kein aktiver Arbeitsbereich gefunden.   "  + ABM_CRLF + "Bitte einen Arbeitsbereich ausw‰hlen vor dem Aufruf von EDIT   " + ABM_CRLF,       ; // 1
            "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 2
            "Eine Zahl eingeben",                                                                                                                                   ; // 3
            "Datum ausw‰hlen",                                                                                                                                      ; // 4
            "F¸r positive Auswahl einen Haken setzen",                                                                                                              ; // 5
            "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 6
            "Einen Datensatz w‰hlen und mit OK best‰tigen",                                                                                                         ; // 7
            ABM_CRLF + "Sie sind im Begriff, den aktiven Datensatz zu lˆschen.   " + ABM_CRLF + "Sind Sie sicher?    " + ABM_CRLF,                                  ; // 8
            ABM_CRLF + "Es ist keine Sortierung aktiv.   " + ABM_CRLF + "Bitte w‰hlen Sie eine Sortierung   " + ABM_CRLF,                                           ; // 9
            ABM_CRLF + "Suche nach den Feldern memo oder logisch nicht mˆglich.   " + ABM_CRLF,                                                                     ; // 10
            ABM_CRLF + "Datensatz nicht gefunden   " + ABM_CRLF,                                                                                                    ; // 11
            "Bitte ein Feld zum Hinzuf¸gen zur Liste w‰hlen",                                                                                                       ; // 12
            "Bitte ein Feld zum Entfernen aus der Liste w‰hlen ",                                                                                                   ; // 13
            "Drucker ausw‰hlen",                                                                                                                                    ; // 14
            "Schaltfl‰che  Feld hinzuf¸gen",                                                                                                                        ; // 15
            "Schaltfl‰che  Feld Entfernen",                                                                                                                         ; // 16
            "Schaltfl‰che  Auswahl erster zu druckender Datensatz",                                                                                                 ; // 17
            "Schaltfl‰che  Auswahl letzte zu druckender Datensatz",                                                                                                 ; // 18
            ABM_CRLF + "Keine Felder zum Hinzuf¸gen mehr vorhanden   " + ABM_CRLF,                                                                                  ; // 19
            ABM_CRLF + "Bitte erst ein Feld zum Hinzuf¸gen w‰hlen   " + ABM_CRLF,                                                                                   ; // 20
            ABM_CRLF + "Keine Felder zum Entfernen vorhanden   " + ABM_CRLF,                                                                                        ; // 21
            ABM_CRLF + "Bitte ein Feld zum Entfernen w‰hlen   " + ABM_CRLF,                                                                                         ; // 22
            ABM_CRLF + "Kein Feld ausgew‰hlt   " + ABM_CRLF + "Bitte die Felder f¸r den Ausdruck ausw‰hlen   " + ABM_CRLF,                                          ; // 23
            ABM_CRLF + "Zu viele Felder   " + ABM_CRLF + "Bitte Anzahl der Felder reduzieren   " + ABM_CRLF,                                                        ; // 24
            ABM_CRLF + "Drucker nicht bereit   " + ABM_CRLF,                                                                                                        ; // 25
            "Sortiert nach",                                                                                                                                        ; // 26
            "Von Datensatz",                                                                                                                                        ; // 27
            "Bis Datensatz",                                                                                                                                        ; // 28
            "Ja",                                                                                                                                                   ; // 29
            "Nein",                                                                                                                                                 ; // 30
            "Seite:",                                                                                                                                               ; // 31
            ABM_CRLF + "Bitte einen Drucker w‰hlen   " + ABM_CRLF,                                                                                                  ; // 32
            "Filtered by",                                                                                                                                          ; // 33
            ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 34
            ABM_CRLF + "Kann nicht nach Memo-Feldern filtern    " + ABM_CRLF,                                                                                       ; // 35
            ABM_CRLF + "Feld zum Filtern ausw‰hlen    " + ABM_CRLF,                                                                                                 ; // 36
            ABM_CRLF + "Einen Operator zum Filtern ausw‰hlen    " + ABM_CRLF,                                                                                       ; // 37
            ABM_CRLF + "Bitte einen Wert f¸r den Filter angeben    " + ABM_CRLF,                                                                                    ; // 38
            ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 39
            ABM_CRLF + "Filter deaktivieren?   " + ABM_CRLF,                                                                                                         ; // 40
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

      CASE cLang == "IT"        // Italian
         /////////////////////////////////////////////////////////////
         // ITALIAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Sei sicuro ?'
         oHmgApp():APP331 [2] := 'Chiudi la finestra'
         oHmgApp():APP331 [3] := 'Chiusura non consentita'
         oHmgApp():APP331 [4] := 'Il programma Ë gi‡ in esecuzione'
         oHmgApp():APP331 [5] := 'Edita'
         oHmgApp():APP331 [6] := 'Conferma'
         oHmgApp():APP331 [7] := 'Annulla'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Window: " , ;
            " non ä definita. Programma terminato" , ;
            "Errore HMG"  , ;
            "Controllo: " , ;
            " Di " , ;
            " GiÖ definito. Programma Terminato" , ;
            "Browse: Tipo non valido. Programma Terminato"  , ;
            "Browse: Modifica non possibile: il campo non ä pertinente l'area di lavoro.Programma Terminato", ;
            "Record giÖ utilizzato da altro utente"                 , ;
            "Attenzione!"                                           , ;
            "Dato non valido" }
         oHmgApp():APP137 := { 'Sei sicuro ?' , 'Cancella Record' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Cancellare il record"+CHR(13)+"Sei sicuro ?"+CHR(13)                  , ;
            Chr(13)+"File indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)            , ;
            Chr(13)+"Campo indice mancante"+CHR(13)+"Ricerca impossibile"+CHR(13)        , ;
            Chr(13)+"Ricerca impossibile per"+CHR(13)+"campi memo o logici"+CHR(13)       , ;
            Chr(13)+"Record non trovato"+CHR(13)                                        , ;
            Chr(13)+"Troppe colonne"+CHR(13)+"Il report non puÚ essere stampato"+CHR(13) }
         oHmgApp():APP132  := { "Record"              , ;
            "Record totali"       , ;
            "  (Aggiungi)"        , ;
            "     (Nuovo)"        , ;
            "Inserire il numero del record" , ;
            "Ricerca"                , ;
            "Testo da cercare"         , ;
            "Data da cercare"         , ;
            "Numero da cercare"       , ;
            "Definizione del report"   , ;
            "Colonne del report"      , ;
            "Colonne totali"     , ;
            "Record Iniziale"      , ;
            "Record Finale"        , ;
            "Report di "          , ;
            "Data:"               , ;
            "Primo Record:"     , ;
            "Ultimo Record:"       , ;
            "Ordinare per:"         , ;
            "SÏ"                 , ;
            "No"                  , ;
            "Pagina "               , ;
            " di "                 }
         oHmgApp():APP133 := { "Chiudi"    , ;
            "Nuovo"      , ;
            "Modifica"     , ;
            "Cancella"   , ;
            "Ricerca"     , ;
            "Vai a"     , ;
            "Report"   , ;
            "Primo"    , ;
            "Precedente" , ;
            "Successivo"     , ;
            "Ultimo"     , ;
            "Salva"     , ;
            "Annulla"   , ;
            "Aggiungi"      , ;
            "Rimuovi"   , ;
            "Stampa"    , ;
            "Chiudi"     }
         oHmgApp():APP134  := { "EDIT, il nome dell'area Ë mancante"                              , ;
            "EDIT, quest'area contiene pi˘ di 16 campi"              , ;
            "EDIT, modalit‡ aggiornamento fuori dal limite (segnalare l'errore)"      , ;
            "EDIT, evento pricipale fuori dal limite (segnalare l'errore)" , ;
            "EDIT, lista eventi fuori dal limite (segnalare l'errore)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {           ;
            "&Chiudi",          ; // 1
            "&Nuovo",           ; // 2
            "&Modifica",        ; // 3
            "&Cancella",        ; // 4
            "&Trova",           ; // 5
            "&Stampa",          ; // 6
            "&Annulla",         ; // 7
            "&Ok",              ; // 8
            "C&opia",           ; // 9
            "A&ttiva Filtro",   ; // 10
            "&Disattiva Filtro" } // 11
         oHmgApp():APP129 := {                            ;
            "Nessuno",                          ; // 1
            "Record",                           ; // 2
            "Totale",                           ; // 3
            "Ordinamento attivo",               ; // 4
            "Opzioni",                          ; // 5
            "Nuovo record",                     ; // 6
            "Modifica record",                  ; // 7
            "Seleziona record",                 ; // 8
            "Trova record",                     ; // 9
            "Stampa opzioni",                   ; // 10
            "Campi disponibili",                ; // 11
            "Campi da stampare",                ; // 12
            "Stampanti disponibili",            ; // 13
            "Primo  record da stampare",        ; // 14
            "Ultimo record da stampare",        ; // 15
            "Cancella record",                  ; // 16
            "Anteprima",                        ; // 17
            "Visualizza pagina miniature",      ; // 18
            "Condizioni Filtro: ",              ; // 19
            "Filtrato: ",                       ; // 20
            "Opzioni Filtro" ,                  ; // 21
            "Campi del Database" ,              ; // 22
            "Operatori di comparazione",        ; // 23
            "Valore Filtro",                    ; // 24
            "Seleziona campo da filtrare",      ; // 25
            "Seleziona operatore comparazione", ; // 26
            "Uguale",                           ; // 27
            "Non Uguale",                       ; // 28
            "Maggiore di",                      ; // 29
            "Minore di",                        ; // 30
            "Maggiore o uguale a",              ; // 31
            "Minore o uguale a"                 } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Nessuna area attiva.   "  + ABM_CRLF + "Selezionare un'area prima della chiamata a EDIT   " + ABM_CRLF,  ; // 1
            "Digitare valore campo (testo)",                                                                                     ; // 2
            "Digitare valore campo (numerico)",                                                                                  ; // 3
            "Selezionare data",                                                                                                  ; // 4
            "Attivare per valore TRUE",                                                                                          ; // 5
            "Inserire valore campo",                                                                                             ; // 6
            "Seleziona un record and premi OK",                                                                                  ; // 7
            ABM_CRLF + "Cancellazione record attivo   " + ABM_CRLF + "Sei sicuro?      " + ABM_CRLF,                             ; // 8
            ABM_CRLF + "Nessun ordinamento attivo     " + ABM_CRLF + "Selezionarne uno " + ABM_CRLF,                             ; // 9
            ABM_CRLF + "Ricerca non possibile su campi MEMO o LOGICI   " + ABM_CRLF,                                             ; // 10
            ABM_CRLF + "Record non trovato   " + ABM_CRLF,                                                                       ; // 11
            "Seleziona campo da includere nel listato",                                                                          ; // 12
            "Seleziona campo da escludere dal listato",                                                                          ; // 13
            "Selezionare la stampante",                                                                                          ; // 14
            "Premi per includere il campo",                                                                                      ; // 15
            "Premi per escludere il campo",                                                                                      ; // 16
            "Premi per selezionare il primo record da stampare",                                                                 ; // 17
            "Premi per selezionare l'ultimo record da stampare",                                                                 ; // 18
            ABM_CRLF + "Nessun altro campo da inserire   " + ABM_CRLF,                                                           ; // 19
            ABM_CRLF + "Prima seleziona il campo da includere " + ABM_CRLF,                                                      ; // 20
            ABM_CRLF + "Nessun altro campo da escludere       " + ABM_CRLF,                                                      ; // 21
            ABM_CRLF + "Prima seleziona il campo da escludere " + ABM_CRLF,                                                      ; // 22
            ABM_CRLF + "Nessun campo selezionato     " + ABM_CRLF + "Selezionare campi da includere nel listato   " + ABM_CRLF,  ; // 23
            ABM_CRLF + "Troppi campi !   " + ABM_CRLF + "Redurre il numero di campi   " + ABM_CRLF,                              ; // 24
            ABM_CRLF + "Stampante non pronta..!   " + ABM_CRLF,                                                                  ; // 25
            "Ordinato per",                                                                                                      ; // 26
            "Dal record",                                                                                                        ; // 27
            "Al  record",                                                                                                        ; // 28
            "Si",                                                                                                                ; // 29
            "No",                                                                                                                ; // 30
            "Pagina:",                                                                                                           ; // 31
            ABM_CRLF + "Selezionare una stampante   " + ABM_CRLF,                                                                ; // 32
            "Filtrato per ",                                                                                                     ; // 33
            ABM_CRLF + "Esiste un filtro attivo     " + ABM_CRLF,                                                                ; // 34
            ABM_CRLF + "Filtro non previsto per campi MEMO   " + ABM_CRLF,                                                       ; // 35
            ABM_CRLF + "Selezionare campo da filtrare        " + ABM_CRLF,                                                       ; // 36
            ABM_CRLF + "Selezionare un OPERATORE per filtro  " + ABM_CRLF,                                                       ; // 37
            ABM_CRLF + "Digitare un valore per filtro        " + ABM_CRLF,                                                       ; // 38
            ABM_CRLF + "Nessun filtro attivo    " + ABM_CRLF,                                                                    ; // 39
            ABM_CRLF + "Disattivare filtro ?   " + ABM_CRLF,                                                                     ; // 40
            ABM_CRLF + "Record bloccato da altro utente" + ABM_CRLF                                                              } // 41

         // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish
      CASE cLang == "PL"
         /////////////////////////////////////////////////////////////
         // POLISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Czy jesteú pewny ?'
         oHmgApp():APP331 [2] := 'Zamknij okno'
         oHmgApp():APP331 [3] := 'ZamkniÍcie niedozwolone'
         oHmgApp():APP331 [4] := 'Program juø uruchomiony'
         oHmgApp():APP331 [5] := 'Edycja'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'PorzuÊ'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Okno: "                                              , ;
            " nie zdefiniowane.Program zakoÒczony"         , ;
            "B≥πd HMG"                                         , ;
            "Kontrolka: "                                             , ;
            " z "                                                  , ;
            " juø zdefiniowana. Program zakoÒczony"                  , ;
            "Browse: Niedozwolony typ danych. Program zakoÒczony"          , ;
            "Browse: Klauzula Append nie moøe byÊ stosowana do pÛl nie naleøπcych do aktualnego obszaru roboczego. Program zakoÒczony", ;
            "Rekord edytowany przez innego uøytkownika"                , ;
            "Ostrzeøenie"                                               , ;
            "Nieprawid≥owy wpis"                                          }
         oHmgApp():APP137 := { 'Czy jesteo pewny ?' , 'Skasuj rekord' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Usuni©cie rekordu"+CHR(13)+"Jesteò pewny ?"+CHR(13)                 , ;
            Chr(13)+"Bà©dny zbi¢r Indeksowy"+CHR(13)+"Nie moæna szukaÜ"+CHR(13)         , ;
            Chr(13)+"Nie moæna znaleòÜ pola indeksu"+CHR(13)+"Nie moæna szukaÜ"+CHR(13) , ;
            Chr(13)+"Nie moæna szukaÊ wg"+CHR(13)+"pola memo lub logicznego"+CHR(13)         , ;
            Chr(13)+"Rekordu nie znaleziono"+CHR(13)                                                     , ;
            Chr(13)+"Zbyt wiele kolumn"+CHR(13)+"Raport nie moæe zmieòciÜ si© na arkuszu"+CHR(13)      }
         oHmgApp():APP132  := { "Rekord"              , ;
            "Liczba rekord¢w"        , ;
            "      (Nowy)"        , ;
            "    (Edycja)"        , ;
            "Wprowad´ numer rekordu" , ;
            "Szukaj"                , ;
            "Szukaj tekstu"         , ;
            "Szukaj daty"         , ;
            "Szukaj liczby"       , ;
            "Definicja Raportu"   , ;
            "Kolumny Raportu"      , ;
            "Dost©pne kolumny"     , ;
            "Pocz•tkowy rekord"      , ;
            "Ko‰cowy rekord"        , ;
            "Raport z "          , ;
            "Data:"               , ;
            "Pocz•tkowy rekord:"     , ;
            "Ko‰cowy rekord:"       , ;
            "Sortowanie wg:"         , ;
            "Tak"                 , ;
            "Nie"                  , ;
            "Strona "               , ;
            " z "                 }
         oHmgApp():APP133 := { "Zamknij"    , ;
            "Nowy"      , ;
            "Edytuj"     , ;
            "Usu‰"   , ;
            "Znajd´"     , ;
            "Idü do"     , ;
            "Raport"   , ;
            "Pierwszy"    , ;
            "Poprzedni" , ;
            "Nast©pny"     , ;
            "Ostatni"     , ;
            "Zapisz"     , ;
            "Rezygnuj"   , ;
            "Dodaj"      , ;
            "Usu‰"   , ;
            "Drukuj"    , ;
            "Zamknij"     }
         oHmgApp():APP134  := { "EDIT, bà©dna nazwa bazy"                                  , ;
            "EDIT, baza ma wi©cej niæ 16 p¢l"                   , ;
            "EDIT, tryb odòwierzania poza zakresem (zobacz raport bà©d¢w)"      , ;
            "EDIT, liczba zdarz‰ podstawowych poza zakresem (zobacz raport bà©d¢w)" , ;
            "EDIT, lista zdarze‰ poza zakresem (zobacz raport bà©d¢w)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {          ;
            "&Zamknij",        ; // 1
            "&Nowy",           ; // 2
            "&Modyfikuj",      ; // 3
            "&Kasuj",          ; // 4
            "&Znajdü",         ; // 5
            "&Drukuj",         ; // 6
            "&PorzuÊ",         ; // 7
            "&Ok",             ; // 8
            "&Kopiuj",         ; // 9
            "&Aktywuj Filtr",  ; // 10
            "&Deaktywuj Filtr" } // 11
         oHmgApp():APP129 := {                       ;
            "Brak",                        ; // 1
            "Rekord",                      ; // 2
            "Suma",                        ; // 3
            "Aktywny indeks",              ; // 4
            "Opcje",                       ; // 5
            "Nowy rekord",                 ; // 6
            "Modyfikuj rekord",            ; // 7
            "Wybierz rekord",              ; // 8
            "Znajdü rekord",               ; // 9
            "Opcje druku",                 ; // 10
            "DostÍpne pola",               ; // 11
            "Pola do druku",               ; // 12
            "DostÍpne drukarki",           ; // 13
            "Pierwszy rekord do druku",    ; // 14
            "Ostatni rekord do druku",     ; // 15
            "Skasuj rekord",               ; // 16
            "Podglπd",                     ; // 17
            "Pokaø miniatury",             ; // 18
            "Stan filtru: ",               ; // 19
            "Filtrowane: ",                ; // 20
            "Opcje filtrowania" ,          ; // 21
            "Pola bazy danych" ,           ; // 22
            "Operator porÛwnania",         ; // 23
            "WartoúÊ filtru",              ; // 24
            "Wybierz pola do filtru",      ; // 25
            "Wybierz operator porÛwnania", ; // 26
            "RÛwna siÍ",                   ; // 27
            "Nie rÛwna siÍ",               ; // 28
            "WiÍkszy ",                    ; // 29
            "Mniejszy ",                   ; // 30
            "WiÍkszy lub rÛwny ",          ; // 31
            "Mniejszy lub rÛwny"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Aktywny obszar nie odnaleziony   "  + ABM_CRLF + "Wybierz obszar przed wywo≥aniem EDIT   " + ABM_CRLF,   ; // 1
            "Poszukiwany ciπg znakÛw (dowolny tekst)",                                                                           ; // 2
            "Poszukiwana wartoúÊ (dowolna liczba)",                                                                              ; // 3
            "Wybierz datÍ",                                                                                                      ; // 4
            "Check for true value",                                                                                              ; // 5
            "WprowaÊ wartoúÊ",                                                                                                   ; // 6
            "Wybierz dowolny rekord i naciúcij OK",                                                                              ; // 7
            ABM_CRLF + "Wybra≥eú opcjÍ kasowania rekordu   " + ABM_CRLF + "Czy jesteú pewien?    " + ABM_CRLF,                   ; // 8
            ABM_CRLF + "Brak aktywnych indeksÛw   " + ABM_CRLF + "Wybierz    " + ABM_CRLF,                                       ; // 9
            ABM_CRLF + "Nie moøna szukaÊ w polach typu MEMO lub LOGIC   " + ABM_CRLF,                                            ; // 10
            ABM_CRLF + "Rekord nie znaleziony   " + ABM_CRLF,                                                                    ; // 11
            "Wybierz rekord ktÛry naleøy dodaÊ do listy",                                                                        ; // 12
            "Wybierz rekord ktÛry naleøy wy≥πczyÊ z listy",                                                                      ; // 13
            "Wybierz drukarkÍ",                                                                                                  ; // 14
            "Kliknij na przycisk by dodaÊ pole",                                                                                 ; // 15
            "Kliknij na przycisk by odjπÊ pole",                                                                                 ; // 16
            "Kliknij, aby wybraÊ pierwszy rekord do druku",                                                                      ; // 17
            "Kliknij, aby wybraÊ ostatni rekord do druku",                                                                       ; // 18
            ABM_CRLF + "Brak pÛl do w≥πczenia   " + ABM_CRLF,                                                                    ; // 19
            ABM_CRLF + "Najpierw wybierz pola do w≥πczenia   " + ABM_CRLF,                                                       ; // 20
            ABM_CRLF + "Brak pÛl do wy≥πczenia   " + ABM_CRLF,                                                                   ; // 21
            ABM_CRLF + "Najpierw wybierz pola do wy≥πczenia   " + ABM_CRLF,                                                      ; // 22
            ABM_CRLF + "Nie wybra≥eú øadnych pÛl   " + ABM_CRLF + "Najpierw wybierz pola do w≥πczenia do wydruku   " + ABM_CRLF, ; // 23
            ABM_CRLF + "Za wiele pÛl   " + ABM_CRLF + "Zredukuj liczbÍ pÛl   " + ABM_CRLF,                                       ; // 24
            ABM_CRLF + "Drukarka nie gotowa   " + ABM_CRLF,                                                                      ; // 25
            "Porzπdek wg",                                                                                                       ; // 26
            "Od rekordu",                                                                                                        ; // 27
            "Do rekordu",                                                                                                        ; // 28
            "Tak",                                                                                                               ; // 29
            "Nie",                                                                                                               ; // 30
            "Strona:",                                                                                                           ; // 31
            ABM_CRLF + "Wybierz drukarkÍ   " + ABM_CRLF,                                                                         ; // 32
            "Filtrowanie wg",                                                                                                    ; // 33
            ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 34
            ABM_CRLF + "Nie moøna filtrowaÊ wg. pÛl typu MEMO    " + ABM_CRLF,                                                   ; // 35
            ABM_CRLF + "Wybierz pola dla filtru    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Wybierz operator porÛwnania dla filtru    " + ABM_CRLF,                                                  ; // 37
            ABM_CRLF + "Wpisz dowolnπ wartoúÊ dla filtru    " + ABM_CRLF,                                                        ; // 38
            ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 39
            ABM_CRLF + "DeaktywowaÊ filtr?   " + ABM_CRLF,                                                                        ;
            ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

         // case cLang == "pt.PT850"        // Portuguese
      CASE cLang == "PT"
         /////////////////////////////////////////////////////////////
         // PORTUGUESE
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'VocÍ tem Certeza ?'
         oHmgApp():APP331 [2] := 'Fechar Janela'
         oHmgApp():APP331 [3] := 'Fechamento n„o permitido'
         oHmgApp():APP331 [4] := 'O programa j· est· em execuÁ„o'
         oHmgApp():APP331 [5] := 'Edita'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancela'
         oHmgApp():APP331 [8] := 'P·g.'

         // BROWSE

         oHmgApp():APP136:= {"Window: ",                                 ;
            " Erro n„o definido. O programa ser· fechado",                     ;
            "Erro na HMG.lib",                              ;
            "Control: ",                                 ;
            " Of ",                                    ;
            " N„o pronto. O programa ser· fechado",                        ;
            "Browse: Tipo Inv·lido !!!. O programa ser· fechado",                  ;
            "Browse: A ediÁ„o n„o È possÌvel, o campo n„o pertence a essa ·rea. O programa ser· fechado",   ;
            "O arquivo est· em uso e n„o pode ser editado !!!",                  ;
            "Aguarde...",                                 ;
            "Dado Inv·lido"                                 }
         oHmgApp():APP137 := { 'VocÍ tem Certeza ?' , 'Apagar Registro' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Excluir o registro atual"+CHR(13)+"Tem certeza?"+CHR(13),               ;
            Chr(13)+"N„o existe nenhum Ìndice ativo"+CHR(13)+"N„o È possÌvel realizar a busca"+CHR(13),      ;
            Chr(13)+"N„o foi encontrado o campo Ìndice"+CHR(13)+"N„o È possÌvel realizar a busca"+CHR(13),   ;
            Chr(13)+"N„o È possÌvel realizar busca"+CHR(13)+"por campos Memo ou LÛgicos"+CHR(13),      ;
            Chr(13)+"Registro n„o encontrado"+CHR(13),                        ;
            Chr(13)+"IncluÌdas colunas em excesso"+CHR(13)+"A listagem completa n„o caber· na tela"+CHR(13)     }

         oHmgApp():APP132  := { "Registro Atual",            ;
            "Total de Registros",         ;
            "      (Novo)",            ;
            "    (Editar)",            ;
            "Introduza o n˙mero do registro",      ;
            "Buscar",               ;
            "Texto ‡ buscar",            ;
            "Data ‡ buscar",            ;
            "N˙mero ‡ buscar",            ;
            "Definic„o da lista",         ;
            "Colunas da lista",            ;
            "Colunas disponÌveis",         ;
            "Registro inicial",            ;
            "Registro final",            ;
            "Lista de ",               ;
            "Data:",               ;
            "Primeiro registro:",         ;
            "⁄ltimo registro:",            ;
            "Ordenado por:",            ;
            "Sim",               ;
            "N„o",               ;
            "P·gina ",               ;
            " de "               }

         oHmgApp():APP133 := { "Fechar",               ;
            "Novo",               ;
            "Alterar",               ;
            "Excluir",               ;
            "Buscar",               ;
            "Ir ao registro",            ;
            "Listar",               ;
            "Primeiro",               ;
            "Anterior",               ;
            "Seguinte",               ;
            "⁄ltimo",               ;
            "Salvar",               ;
            "Cancelar",               ;
            "Juntar",               ;
            "Sair",               ;
            "Imprimir",               ;
            "Fechar"               }

         oHmgApp():APP134  := { "EDIT, Nenhuma ¡rea foi especificada",               ;
            "EDIT, A ¡rea selecionada possui mais de 16 campos",            ;
            "EDIT, AtualizaÁ„o est· fora do limite (Favor comunicar este erro)",      ;
            "EDIT, Evento principal est· fora do limite (Favor comunicar este erro)",   ;
            "EDIT, Evento mostrado est·†fora do limite (Favor comunicar este erro)"   }

         // EDIT EXTENDED

         oHmgApp():APP128 :={"&Sair",       ; // 1
            "&Novo",      ; // 2
            "&Alterar",      ; // 3
            "&Excluir",      ; // 4
            "&Localizar",      ; // 5
            "&Imprimir",      ; // 6
            "&Cancelar",      ; // 7
            "&Aceitar",      ; // 8
            "&Copiar",      ; // 9
            "&Ativar Filtro",   ; // 10
            "&Desativar Filtro"   } // 11

         oHmgApp():APP129 :={"Nenhum",               ; // 1
            "Registro",               ; // 2
            "Total",               ; // 3
            "Õndice ativo",               ; // 4
            "OpÁ„o",               ; // 5
            "Novo registro",            ; // 6
            "Modificar registro",            ; // 7
            "Selecionar registro",            ; // 8
            "Localizar registro",            ; // 9
            "OpÁ„o de impress„o",            ; // 10
            "Campos disponÌveis",            ; // 11
            "Campos selecionados",            ; // 12
            "Impressoras disponÌveis",         ; // 13
            "Primeiro registro a imprimir",         ; // 14
            "⁄ltimo registro a imprimir",         ; // 15
            "Apagar registro",            ; // 16
            "Visualizar impress„o",            ; // 17
            "Miniaturas das p·ginas",         ; // 18
            "CondiÁ„o do filtro: ",            ; // 19
            "Filtrado: ",               ; // 20
            "OpÁıes do filtro" ,            ; // 21
            "Campos do BDD" ,            ; // 22
            "Operador de comparaÁ„o",         ; // 23
            "Argumento de comparaÁ„o",         ; // 24
            "Selecione o campo ‡ filtrar",         ; // 25
            "Selecione o operador de comparaÁ„o",      ; // 26
            "Igual",               ; // 27
            "Diferente",               ; // 28
            "Maior que",               ; // 29
            "Menor que",               ; // 30
            "Maior ou igual que",            ; // 31
            "Menor ou igual que"            } // 32

         oHmgApp():APP130 := { ABM_CRLF + "N„o h· uma ·rea ativa   "  + ABM_CRLF +                         ;
            "Por favor selecione uma ·rea antes de executar o EDIT EXTENDED   " + ABM_CRLF,            ; // 1
            "Introduza o valor do campo (texto)",                              ; // 2
            "Introduza o valor do campo (numÈrico)",                           ; // 3
            "Selecione a data",                                    ; // 4
            "Ative o indicar para valor verdadero",                              ; // 5
            "Introduza o valor do campo",                                 ; // 6
            "Selecione um registro e tecle Ok",                              ; // 7
            ABM_CRLF + "Confirma exclus„o do registro selecionado ??   " + ABM_CRLF + "Tem certeza?    " + ABM_CRLF,   ; // 8
            ABM_CRLF + "N„o ha um Ìndice seleccionado    " + ABM_CRLF + "Por favor selecione um   " + ABM_CRLF,      ; // 9
            ABM_CRLF + "N„o È possÌvel excutar buscas em campos tipo Memo ou LÛgico   " + ABM_CRLF,            ; // 10
            ABM_CRLF + "Registro n„o encontrado   " + ABM_CRLF,                        ; // 11
            "Selecione o campo a incluir na lista",                              ; // 12
            "Selecione o campo a excluir da lista",                              ; // 13
            "Selecione a Impressora",                                 ; // 14
            "Pressione o bot„o para incluir o campo",                           ; // 15
            "Pressione o bot„o para excluir o campo",                           ; // 16
            "Pressione o bot„o para selecionar o primeiro registro a imprimir",                  ; // 17
            "Pressione o bot„o para selecionar o ˙ltimo registro a imprimir",                  ; // 18
            ABM_CRLF + "Foram incluÌdos todos os campos   " + ABM_CRLF,                     ; // 19
            ABM_CRLF + "Primeiro seleccione o campo a incluir   " + ABM_CRLF,                  ; // 20
            ABM_CRLF + "N„o ha campos para excluir   " + ABM_CRLF,                        ; // 21
            ABM_CRLF + "Primeiro selecione o campo a excluir   " + ABM_CRLF,                  ; // 22
            ABM_CRLF + "N„o h· mais campos selecion·veis   " + ABM_CRLF,                     ; // 23
            ABM_CRLF + "A lista n„o cabe na p·gina   " + ABM_CRLF + "Reduza o n˙mero de campos   " + ABM_CRLF,      ; // 24
            ABM_CRLF + "A impressora n„o est· disponÌvel   " + ABM_CRLF,                     ; // 25
            "Ordenado por",                                       ; // 26
            "Do registro",                                       ; // 27
            "AtÈ o registro",                                    ; // 28
            "Sim",                                          ; // 29
            "N„o",                                          ; // 30
            "P·gina:",                                       ; // 31
            ABM_CRLF + "Por favor selecione uma impressora   " + ABM_CRLF,                     ; // 32
            "Filtrado por",                                       ; // 33
            ABM_CRLF + "N„o h· nenhum filtro ativo    " + ABM_CRLF,                        ; // 34
            ABM_CRLF + "N„o È possÌvel filtrar por campos Memo    " + ABM_CRLF,                  ; // 35
            ABM_CRLF + "Selecione o campo a filtrar    " + ABM_CRLF,                     ; // 36
            ABM_CRLF + "Selecione o operador de comparaÁ„o    " + ABM_CRLF,                     ; // 37
            ABM_CRLF + "Introduza o valor do filtro    " + ABM_CRLF,                     ; // 38
            ABM_CRLF + "N„o ha nenhum filtro ativo    " + ABM_CRLF,                        ; // 39
            ABM_CRLF + "Limpar o filtro ativo?   " + ABM_CRLF,                        ; // 40
            ABM_CRLF + "Registro est· bloqueado por outro usu·rio" + ABM_CRLF                  } // 41

         // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
      CASE cLang == "RU"
         /////////////////////////////////////////////////////////////
         // RUSSIAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := '¬˚ Û‚ÂÂÌ˚ ?'
         oHmgApp():APP331 [2] := '«‡Í˚Ú¸ ÓÍÌÓ'
         oHmgApp():APP331 [3] := '«‡Í˚ÚËÂ ÌÂ ‰ÓÒÚÛÔÌÓ'
         oHmgApp():APP331 [4] := 'œÓ„‡ÏÏ‡ ÛÊÂ Á‡ÔÛ˘ÂÌ‡'
         oHmgApp():APP331 [5] := '»ÁÏÂÌËÚ¸'
         oHmgApp():APP331 [6] := 'ƒ‡'
         oHmgApp():APP331 [7] := 'ŒÚÏÂÌ‡'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "ŒÍÌÓ: "                                              , ;
            " ÌÂ ÓÔÂ‰ÂÎÂÌÓ. œÓ„‡ÏÏ‡ ÔÂ‚‡Ì‡"                 , ;
            "HMG Œ¯Ë·Í‡"                                     , ;
            "›ÎÂÏÂÌÚ ÛÔ‡‚ÎÂÌË: "                               , ;
            " ËÁ "                                               , ;
            " ”ÊÂ ÓÔÂ‰ÂÎÂÌ. œÓ„‡ÏÏ‡ ÔÂ‚‡Ì‡"                         , ;
            "Browse: “‡ÍÓÈ ÚËÔ ÌÂ ÔÓ‰‰ÂÊË‚‡ÂÚÒ. œÓ„‡ÏÏ‡ ÔÂ‚‡Ì‡"    , ;
            "Browse: Append ÍÎ‡ÒÒ ÌÂ ÏÓÊÂÚ ·˚Ú¸ ËÒÔÓÎ¸ÁÓ‚‡Ì Ò ÔÓÎÏË ËÁ ‰Û„ÓÈ ‡·Ó˜ÂÈ Ó·Î‡ÒÚË. œÓ„‡ÏÏ‡ ÔÂ‚‡Ì‡", ;
            "«‡ÔËÒ¸ ÒÂÈ˜‡Ò Â‰‡ÍÚËÛÂÚÒ ‰Û„ËÏ ÔÓÎ¸ÁÓ‚‡ÚÂÎÂÏ"           , ;
            "œÂ‰ÛÔÂÊ‰ÂÌËÂ"                                             , ;
            "¬‚Â‰ÂÌ˚ ÌÂÔ‡‚ËÎ¸Ì˚Â ‰‡ÌÌ˚Â"                                 }
         oHmgApp():APP137 := { '¬˚ Û‚ÂÂÌ˚ ?' , '”‰‡ÎËÚ¸ Á‡ÔËÒ¸' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"”‰‡ÎÂÌËÂ Á‡ÔËÒË."+CHR(13)+"¬˚ Û‚ÂÂÌ˚ ?"+CHR(13)                  , ;
            Chr(13)+"ŒÚÒÛÚÒÚ‚ÛÂÚ ËÌ‰ÂÍÒÌ˚È Ù‡ÈÎ"+CHR(13)+"œÓËÒÍ ÌÂ‚ÓÁÏÓÊÂÌ"+CHR(13)   , ;
            Chr(13)+"ŒÚÒÛÚÒÚ‚ÛÂÚ ËÌ‰ÂÍÒÌÓÂ ÔÓÎÂ"+CHR(13)+"œÓËÒÍ ÌÂ‚ÓÁÏÓÊÂÌ"+CHR(13)   , ;
            Chr(13)+"œÓËÒÍ ÌÂ‚ÓÁÏÓÊÂÌ ÔÓ"+CHR(13)+"ÏÂÏÓ ËÎË ÎÓ„Ë˜ÂÒÍËÏ ÔÓÎˇÏ"+CHR(13) , ;
            Chr(13)+"«‡ÔËÒ¸ ÌÂ Ì‡È‰ÂÌ‡"+CHR(13)                                       , ;
            Chr(13)+"—ÎË¯ÍÓÏ ÏÌÓ„Ó ÍÓÎÓÌÓÍ"+CHR(13)+"ŒÚ˜ÂÚ ÌÂ ÔÓÏÂÒÚËÚÒˇ Ì‡ ÎËÒÚÂ"+CHR(13) }
         oHmgApp():APP132  := { "«‡ÔËÒ¸"              , ;
            "¬ÒÂ„Ó Á‡ÔËÒÂÈ"       , ;
            "     (ÕÓ‚‡ˇ)"        , ;
            "  (»ÁÏÂÌËÚ¸)"        , ;
            "¬‚Â‰ËÚÂ ÌÓÏÂ Á‡ÔËÒË", ;
            "œÓËÒÍ"               , ;
            "Õ‡ÈÚË ÚÂÍÒÚ"         , ;
            "Õ‡ÈÚË ‰‡ÚÛ"          , ;
            "Õ‡ÈÚË ˜ËÒÎÓ"         , ;
            "Õ‡ÒÚÓÈÍ‡ ÓÚ˜ÂÚ‡"    , ;
            " ÓÎÓÌÍË ÓÚ˜ÂÚ‡"      , ;
            "ƒÓÒÚÛÔÌ˚Â ÍÓÎÓÌÍË"   , ;
            "Õ‡˜‡Î¸Ì‡ˇ Á‡ÔËÒ¸"    , ;
            " ÓÌÂ˜Ì‡ˇ Á‡ÔËÒ¸"     , ;
            "ŒÚ˜ÂÚ ‰Îˇ "          , ;
            "ƒ‡Ú‡:"               , ;
            "œÂ‚‡ˇ Á‡ÔËÒ¸:"      , ;
            " ÓÌÂ˜Ì‡ˇ Á‡ÔËÒ¸:"    , ;
            "√ÛÔÔËÓ‚Í‡ ÔÓ:"     , ;
            "ƒ‡"                  , ;
            "ÕÂÚ"                 , ;
            "—Ú‡ÌËˆ‡ "           , ;
            " ËÁ "                 }
         oHmgApp():APP133 := { "«‡Í˚Ú¸"   , ;
            "ÕÓ‚‡ˇ"     , ;
            "»ÁÏÂÌËÚ¸"  , ;
            "”‰‡ÎËÚ¸"   , ;
            "œÓËÒÍ"     , ;
            "œÂÂÈÚË"   , ;
            "ŒÚ˜ÂÚ"     , ;
            "œÂ‚‡ˇ"    , ;
            "Õ‡Á‡‰"     , ;
            "¬ÔÂÂ‰"    , ;
            "œÓÒÎÂ‰Ìˇˇ" , ;
            "—Óı‡ÌËÚ¸" , ;
            "ŒÚÏÂÌ‡"    , ;
            "ƒÓ·‡‚ËÚ¸"  , ;
            "”‰‡ÎËÚ¸"   , ;
            "œÂ˜‡Ú¸"    , ;
            "«‡Í˚Ú¸"    }
         oHmgApp():APP134  := { "EDIT, ÌÂ ÛÍ‡Á‡ÌÓ ËÏˇ ‡·Ó˜ÂÈ Ó·Î‡ÒÚË"                     , ;
            "EDIT, ‰ÓÔÛÒÍ‡ÂÚÒˇ ÚÓÎ¸ÍÓ ‰Ó 16 ÔÓÎÂÈ"                     , ;
            "EDIT, ÂÊËÏ Ó·ÌÓ‚ÎÂÌËˇ ‚ÌÂ ‰Ë‡Ô‡ÁÓÌ‡ (ÒÓÓ·˘ËÚÂ Ó· Ó¯Ë·ÍÂ)", ;
            "EDIT, ÌÓÏÂ ÒÓ·˚ÚËˇ ‚ÌÂ ‰Ë‡Ô‡ÁÓÌ‡ (ÒÓÓ·˘ËÚÂ Ó· Ó¯Ë·ÍÂ)"   , ;
            "EDIT, ÌÓÏÂ ÒÓ·˚ÚËˇ ÎËÒÚËÌ„‡ ‚ÌÂ ‰Ë‡Ô‡ÁÓÌ‡ (ÒÓÓ·˘ËÚÂ Ó· Ó¯Ë·ÍÂ)" }

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

         // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
      CASE cLang == "ES"
         /////////////////////////////////////////////////////////////
         // SPANISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Est· seguro ?'
         oHmgApp():APP331 [2] := 'Cerrar Ventana'
         oHmgApp():APP331 [3] := 'OperaciÛn no permitida'
         oHmgApp():APP331 [4] := 'EL programa ya est· ejecut·ndose'
         oHmgApp():APP331 [5] := 'Editar'
         oHmgApp():APP331 [6] := 'Aceptar'
         oHmgApp():APP331 [7] := 'Cancelar'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Window: "                                              , ;
            " no est· definida. EjecuciÛn terminada"                , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " De "                                                  , ;
            " ya definido. EjecuciÛn terminada"                     , ;
            "Browse: Tipo no permitido. EjecuciÛn terminada"        , ;
            "Browse: La calusula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. EjecuciÛn terminada", ;
            "El registro est· siendo editado por otro usuario"      , ;
            "Peligro"                                               , ;
            "Entrada no v·lida"                                      }
         oHmgApp():APP137 := { 'Est· Seguro ?' , 'Eliminar Registro' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Va a eliminar el registro actual"+CHR(13)+"ø Est· seguro ?"+CHR(13)                 , ;
            Chr(13)+"No hay un indice activo"+CHR(13)+"No se puede realizar la busqueda"+CHR(13)         , ;
            Chr(13)+"No se encuentra el campo indice"+CHR(13)+"No se puede realizar la busqueda"+CHR(13) , ;
            Chr(13)+"No se pueden realizar busquedas"+CHR(13)+"por campos memo o lÛgico"+CHR(13)         , ;
            Chr(13)+"Registro no encontrado"+CHR(13)                                                     , ;
            Chr(13)+"Ha inclido demasiadas columnas"+CHR(13)+"El listado no cabe en la hoja"+CHR(13)      }
         oHmgApp():APP132  := { "Registro Actual"                  , ;
            "Registros Totales"                , ;
            "     (Nuevo)"                     , ;
            "    (Editar)"                     , ;
            "Introducca el n˙mero de registro" , ;
            "Buscar"                           , ;
            "Texto a buscar"                   , ;
            "Fecha a buscar"                   , ;
            "N˙mero a buscar"                  , ;
            "DefiniciÛn del listado"           , ;
            "Columnas del listado"             , ;
            "Columnas disponibles"             , ;
            "Registro inicial"                 , ;
            "Registro final"                   , ;
            "Listado de "                      , ;
            "Fecha:"                           , ;
            "Primer registro:"                 , ;
            "Ultimo registro:"                 , ;
            "Ordenado por:"                    , ;
            "Si"                               , ;
            "No"                               , ;
            "Pagina "                          , ;
            " de "                              }
         oHmgApp():APP133 := { "Cerrar"           , ;
            "Nuevo"            , ;
            "Modificar"        , ;
            "Eliminar"         , ;
            "Buscar"           , ;
            "Ir al registro"   , ;
            "Listado"          , ;
            "Primero"          , ;
            "Anterior"         , ;
            "Siguiente"        , ;
            "Ultimo"           , ;
            "Guardar"          , ;
            "Cancelar"         , ;
            "AÒadir"           , ;
            "Quitar"           , ;
            "Imprimir"         , ;
            "Cerrar"            }
         oHmgApp():APP134  := { "EDIT, No se ha especificado el area"                                  , ;
            "EDIT, El area contiene m·s de 16 campos"                              , ;
            "EDIT, Refesco fuera de rango (por favor comunique el error)"          , ;
            "EDIT, Evento principal fuera de rango (por favor comunique el error)" , ;
            "EDIT, Evento listado fuera de rango (por favor comunique el error)"    }

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            "&Cerrar",           ; // 1
            "&Nuevo",            ; // 2
            "&Modificar",        ; // 3
            "&Eliminar",         ; // 4
            "&Buscar",           ; // 5
            "&Imprimir",         ; // 6
            "&Cancelar",         ; // 7
            "&Aceptar",          ; // 8
            "&Copiar",           ; // 9
            "&Activar Filtro",   ; // 10
            "&Desactivar Filtro" } // 11
         oHmgApp():APP129 := {                                 ;
            "Ninguno",                               ; // 1
            "Registro",                              ; // 2
            "Total",                                 ; // 3
            "Indice activo",                         ; // 4
            "Opciones",                              ; // 5
            "Nuevo registro",                        ; // 6
            "Modificar registro",                    ; // 7
            "Seleccionar registro",                  ; // 8
            "Buscar registro",                       ; // 9
            "Opciones de impresiÛn",                 ; // 10
            "Campos disponibles",                    ; // 11
            "Campos del listado",                    ; // 12
            "Impresoras disponibles",                ; // 13
            "Primer registro a imprimir",            ; // 14
            "Ultimo registro a imprimir",            ; // 15
            "Borrar registro",                       ; // 16
            "Vista previa",                          ; // 17
            "P·ginas en miniatura",                  ; // 18
            "CondiciÛn del filtro: ",                ; // 19
            "Filtrado: ",                            ; // 20
            "Opciones de filtrado" ,                 ; // 21
            "Campos de la bdd" ,                     ; // 22
            "Operador de comparaciÛn",               ; // 23
            "Valor de comparaciÛn",                  ; // 24
            "Seleccione el campo a filtrar",         ; // 25
            "Seleccione el operador de comparaciÛn", ; // 26
            "Igual",                                 ; // 27
            "Distinto",                              ; // 28
            "Mayor que",                             ; // 29
            "Menor que",                             ; // 30
            "Mayor o igual que",                     ; // 31
            "Menor o igual que"                      } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "No hay un area activa   "  + ABM_CRLF + "Por favor seleccione un area antes de llamar a EDIT EXTENDED   " + ABM_CRLF,       ; // 1
            "Introduzca el valor del campo (texto)",                                                                                      ; // 2
            "Introduzca el valor del campo (numÈrico)",                                                                                    ; // 3
            "Seleccione la fecha",                                                                                                      ; // 4
            "Active la casilla para indicar un valor verdadero",                                                                                                 ; // 5
            "Introduzca el valor del campo",                                                                                                ; // 6
            "Seleccione un registro y pulse aceptar",                                                                                       ; // 7
            ABM_CRLF + "Se dispone a borrar el registro activo   " + ABM_CRLF + "øEsta seguro?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "No se ha seleccionado un indice   " + ABM_CRLF + "Por favor seleccione uno   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "No se pueden realizar busquedad por campos tipo memo o lÛgico   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Registro no encontrado   " + ABM_CRLF,                                                                            ; // 11
            "Seleccione el campo a incluir en el listado",                                                                                  ; // 12
            "Seleccione el campo a excluir del listado",                                                                                ; // 13
            "Seleccione la impresora",                                                                                                   ; // 14
            "Pulse el botÛn para incluir el campo",                                                                                         ; // 15
            "Pulse el botÛn para excluir el campo",                                                                                         ; // 16
            "Pulse el botÛn para seleccionar el primer registro a imprimir",                                                                      ; // 17
            "Pulse el botÛn para seleccionar el ˙ltimo registro a imprimir",                                                                       ; // 18
            ABM_CRLF + "Ha incluido todos los campos   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "Primero seleccione el campo a incluir   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No hay campos para excluir   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "Primero seleccione el campo a excluir   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "No ha seleccionado ning˙n campo   " + ABM_CRLF,                                              ; // 23
            ABM_CRLF + "El listado no cabe en la p·gina   " + ABM_CRLF + "Reduzca el numero de campos   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "La impresora no est· disponible   " + ABM_CRLF,                                                                           ; // 25
            "Ordenado por",                                                                                                           ; // 26
            "Del registro",                                                                                                          ; // 27
            "Al registro",                                                                                                            ; // 28
            "Si",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "P·gina:",                                                                                                                ; // 31
            ABM_CRLF + "Por favor seleccione una impresora   " + ABM_CRLF,                                                                     ; // 32
            "Filtrado por",                                                                                                          ; // 33
            ABM_CRLF + "No hay un filtro activo    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "No se puede filtrar por campos memo    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Seleccione el campo a filtrar    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Seleccione el operador de comparaciÛn    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Introduzca el valor del filtro    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "No hay ning˙n filtro activo    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "øEliminar el filtro activo?   " + ABM_CRLF,                                                                           ; // 40
            ABM_CRLF + "Registro bloqueado por otro usuario    " + ABM_CRLF                                                                   } // 41

      CASE cLang == "FI"        // Finnish
         ///////////////////////////////////////////////////////////////////////
         // FINNISH
         ///////////////////////////////////////////////////////////////////////
         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Oletko varma ?'
         oHmgApp():APP331 [2] := 'Sulje ikkuna'
         oHmgApp():APP331 [3] := 'Sulkeminen ei sallittu'
         oHmgApp():APP331 [4] := 'Ohjelma on jo k‰ynniss‰'
         oHmgApp():APP331 [5] := 'Korjaa'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Keskeyt‰'
         oHmgApp():APP331 [8] := 'Sivu.'

         // BROWSE

         oHmgApp():APP136  := { "Ikkuna: " , ;
            " m‰‰rittelem‰tˆn. Ohjelma lopetettu" , ;
            "HMG Virhe", ;
            "Kontrolli: ", ;
            " / " , ;
            " On jo m‰‰ritelty. Ohjelma lopetettu" , ;
            "Browse: Virheellinen tyyppi. Ohjelma lopetettu" , ;
            "Browse: Et voi lis‰t‰ kentti‰ jotka eiv‰t ole BROWSEN m‰‰rityksess‰. Ohjelma lopetettu", ;
            "Toinen k‰ytt‰j‰ korjaa juuri tietuetta" , ;
            "Varoitus" , ;
            "Virheellinen arvo" }

         oHmgApp():APP137 := { 'Oletko varma ?' , 'Poista tietue' }

         // EDIT
         oHmgApp():APP131   := { Chr(13)+"Poista tietue"+CHR(13)+"Oletko varma?"+CHR(13)                  , ;
            Chr(13)+"Indeksi tiedosto puuttuu"+CHR(13)+"En voihakea"+CHR(13)            , ;
            Chr(13)+"Indeksikentt‰ ei lˆydy"+CHR(13)+"En voihakea"+CHR(13)        , ;
            Chr(13)+"En voi hakea memo"+CHR(13)+"tai loogisen kent‰n mukaan"+CHR(13)       , ;
            Chr(13)+"Tietue ei lˆydy"+CHR(13), ;
            Chr(13)+"Liian monta saraketta"+CHR(13)+"raportti ei mahdu sivulle"+CHR(13) }

         oHmgApp():APP132  := { "Tietue"              , ;
            "Tietue lukum‰‰r‰"    , ;
            "       (Uusi)"       , ;
            "      (Korjaa)"      , ;
            "Anna tietue numero"  , ;
            "Hae"                 , ;
            "Hae teksti"          , ;
            "Hae p‰iv‰ys"         , ;
            "Hae numero"          , ;
            "Raportti m‰‰ritys"   , ;
            "Raportti sarake"     , ;
            "Sallitut sarakkeet"  , ;
            "Alku tietue"         , ;
            "Loppu tietue"        , ;
            "Raportti "           , ;
            "Pvm:"                , ;
            "Alku tietue:"        , ;
            "Loppu tietue:"       , ;
            "Lajittelu:"         , ;
            "Kyll‰"                 , ;
            "Ei"                  , ;
            "Sivu "               , ;
            " / "                 }

         oHmgApp():APP133 := { "Sulje"    , ;
            "Uusi"     , ;
            "Korjaa"   , ;
            "Poista"   , ;
            "Hae"      , ;
            "Mene"     , ;
            "Raportti" , ;
            "Ensimm‰inen" , ;
            "Edellinen"   , ;
            "Seuraava"    , ;
            "Viimeinen"   , ;
            "Tallenna"    , ;
            "Keskeyt‰"    , ;
            "Lis‰‰"       , ;
            "Poista"      , ;
            "Tulosta"     , ;
            "Sulje"     }
         oHmgApp():APP134  := { "EDIT, tyˆalue puuttuu"   , ;
            "EDIT, tyˆalueella yli 16 kentt‰‰", ;
            "EDIT, p‰ivitysalue ylitys (raportoi virhe)"      , ;
            "EDIT, tapahtuma numero ylitys (raportoi virhe)" , ;
            "EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

         // EDIT EXTENDED

         oHmgApp():APP128 := {            ;
            " Sulje",            ; // 1
            " Uusi",              ; // 2
            " Muuta",           ; // 3
            " Poista",           ; // 4
            " Hae",             ; // 5
            " Tulosta",            ; // 6
            " Keskeyt‰",           ; // 7
            " Ok",               ; // 8
            " Kopioi",             ; // 9
            " Aktivoi Filtteri",  ; // 10
            " Deaktivoi Filtteri" } // 11

         oHmgApp():APP129 := {                        ;
            "Ei mit‰‰n",                         ; // 1
            "Tietue",                       ; // 2
            "Yhteens‰",                        ; // 3
            "Aktiivinen lajittelu",                 ; // 4
            "Optiot",                      ; // 5
            "Uusi tietue",                   ; // 6
            "Muuta tietue",                ; // 7
            "Valitse tietue",                ; // 8
            "Hae tietue",                  ; // 9
            "Tulostus optiot",                ; // 10
            "Valittavat kent‰t",               ; // 11
            "Tulostettavat kent‰t",              ; // 12
            "Valittavat tulostimet",           ; // 13
            "Ensim. tulostuttava tietue",        ; // 14
            "Viim. tulostettava tietue",         ; // 15
            "Poista tietue",                ; // 16
            "Esikatselu",                      ; // 17
            "N‰yt‰ sivujen miniatyyrit",         ; // 18
            "Suodin ehto: ",           ; // 19
            "Suodatettu: ",                   ; // 20
            "Suodatus Optiot" ,           ; // 21
            "Tietokanta kent‰t" ,             ; // 22
            "Vertailu operaattori",        ; // 23
            "Suodatus arvo",                 ; // 24
            "Valitse suodatus kentt‰",       ; // 25
            "Valitse vertailu operaattori", ; // 26
            "Yht‰ kuin",                        ; // 27
            "Erisuuri kuin",                    ; // 28
            "Isompi kuin",                 ; // 29
            "Pienempi kuin",                   ; // 30
            "Isompi tai sama kuin",        ; // 31
            "Pienempi tai sama kuin"           } // 32

         oHmgApp():APP130 := { ;
            ABM_CRLF + "Tyˆalue ei lˆydy.   "  + ABM_CRLF + "Valitse tyˆaluetta ennenkun kutsut Edit  " + ABM_CRLF,       ; // 1
            "Anna kentt‰ arvo (teksti‰)",                                  ; // 2
            "Anna kentt‰ arvo (numeerinen)",                                  ; // 3
            "Valitse p‰iv‰ys",                            ; // 4
            "Tarkista tosi arvo",                     ; // 5
            "Anna kentt‰ arvo",                    ; // 6
            "Valitse joku tietue ja paina OK",                                     ; // 7
            ABM_CRLF + "Olet poistamassa aktiivinen tietue   "+ABM_CRLF + "Oletko varma?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "Ei aktiivista lajittelua   " + ABM_CRLF+"Valitse lajittelu   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + ABM_CRLF,; // 10
            ABM_CRLF + "Tietue ei lˆydy   " + ABM_CRLF,                                                ; // 11
            "Valitse listaan lis‰tt‰v‰t kent‰t",                                                    ; // 12
            "Valitse EI lis‰tt‰v‰t kent‰t",                                        ; // 13
            "Valitse tulostin",                   ; // 14
            "Paina n‰pp‰in lis‰‰t‰ksesi kentt‰",                                                                  ; // 15
            "Paina n‰pp‰in poistaaksesi kentt‰",                                                       ; //16
            "Paina n‰pp‰in valittaaksesi ensimm‰inen tulostettava tietue",  ; // 17
            "Paina n‰pp‰in valittaaksesi viimeinen tulostettava tietue",   ; // 18
            ABM_CRLF + "Ei lis‰‰ kentti‰   " + ABM_CRLF,                                 ; // 19
            ABM_CRLF + "Valitse ensin lis‰tt‰v‰ kentt‰   "+ABM_CRLF,                                                           ; //20
            ABM_CRLF + "EI Lis‰‰ ohitettavia kentti‰   " +ABM_CRLF,; // 21
            ABM_CRLF + "Valitse ensin ohitettava kentt‰   " +ABM_CRLF,                                                            ;//22
            ABM_CRLF + "Et valinnut kentti‰   " + ABM_CRLF + "Valitse tulosteen kent‰t   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Liikaa kentti‰   " + ABM_CRLF + "V‰henn‰ kentt‰ lukum‰‰r‰   " + ABM_CRLF,; // 24
            ABM_CRLF + "Tulostin ei valmiina   " + ABM_CRLF,                                                  ; // 25
            "Lajittelu",             ; // 26
            "Tietueesta",              ; // 27
            "Tietueeseen",                  ; // 28
            "Kyll‰",                ; // 29
            "EI",       ; // 30
            "Sivu:",          ; // 31
            ABM_CRLF + "Valitse tulostin   " + ABM_CRLF,                                       ; // 32
            "Lajittelu",            ; // 33
            ABM_CRLF + "Aktiivinen suodin olemassa    " + ABM_CRLF,                                                          ; // 34
            ABM_CRLF + "En voi suodattaa memo kentti‰    "+ABM_CRLF,;// 35
            ABM_CRLF + "Valitse suodattava kentt‰    " + ABM_CRLF,                                                           ; // 36
            ABM_CRLF + "Valitse suodattava operaattori    " +ABM_CRLF,                                                             ; //37
            ABM_CRLF + "Anna suodatusarvo    " + ABM_CRLF,                                         ; // 38
            ABM_CRLF + "Ei aktiivisia suotimia    " + ABM_CRLF,                                              ; // 39
            ABM_CRLF + "Poista suodin?   " + ABM_CRLF,                                        ; // 40
            ABM_CRLF + "Tietue lukittu    " + ABM_CRLF                                 } // 41

      CASE cLang == "NL"        // Dutch
         /////////////////////////////////////////////////////////////
         // DUTCH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Weet u het zeker?'
         oHmgApp():APP331 [2] := 'Sluit venster'
         oHmgApp():APP331 [3] := 'Sluiten niet toegestaan'
         oHmgApp():APP331 [4] := 'Programma is al actief'
         oHmgApp():APP331 [5] := 'Bewerken'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Annuleren'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE

         oHmgApp():APP136  := { "Scherm: ", ;
            " is niet gedefinieerd. Programma beÎindigd"           , ;
            "HMG fout", ;
            "Control: ", ;
            " Van ", ;
            " Is al gedefinieerd. Programma beÎindigd"                   , ;
            "Browse: Type niet toegestaan. Programma beÎindigd"          , ;
            "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma beÎindigd", ;
            "Regel word al veranderd door een andere gebruiker"          , ;
            "Waarschuwing"                                               , ;
            "Onjuiste invoer"                                            }

         oHmgApp():APP137 := { 'Weet u het zeker?' , 'Verwijder regel' }

         // EDIT

         oHmgApp():APP131   := { Chr(13)+"Verwijder regel"+CHR(13)+"Weet u het zeker ?"+CHR(13)    , ;
            Chr(13)+"Index bestand is er niet"+CHR(13)+"Kan niet zoeken"+CHR(13)          , ;
            Chr(13)+"Kan index veld niet vinden"+CHR(13)+"Kan niet zoeken"+CHR(13)        , ;
            Chr(13)+"Kan niet zoeken op"+CHR(13)+"Memo of logische velden"+CHR(13)        , ;
            Chr(13)+"Regel niet gevonden"+CHR(13) , ;
            Chr(13)+"Te veel rijen"+CHR(13)+"Het rapport past niet op het papier"+CHR(13) }

         oHmgApp():APP132  := { "Regel"     , ;
            "Regel aantal"          , ;
            "       (Nieuw)"        , ;
            "      (Bewerken)"      , ;
            "Geef regel nummer"     , ;
            "Vind"                  , ;
            "Zoek tekst"            , ;
            "Zoek datum"            , ;
            "Zoek nummer"           , ;
            "Rapport definitie"     , ;
            "Rapport rijen"         , ;
            "Beschikbare rijen"     , ;
            "Eerste regel"          , ;
            "Laatste regel"         , ;
            "Rapport van "          , ;
            "Datum:"                , ;
            "Eerste regel:"         , ;
            "Laatste tegel:"        , ;
            "Gesorteerd op:"        , ;
            "Ja"                    , ;
            "Nee"                   , ;
            "Pagina "               , ;
            " van "                 }

         oHmgApp():APP133 := { "Sluiten"   , ;
            "Nieuw"                 , ;
            "Bewerken"              , ;
            "Verwijderen"           , ;
            "Vind"                  , ;
            "Ga naar"               , ;
            "Rapport"               , ;
            "Eerste"                , ;
            "Vorige"                , ;
            "Volgende"              , ;
            "Laatste"               , ;
            "Bewaar"                , ;
            "Annuleren"             , ;
            "Voeg toe"              , ;
            "Verwijder"             , ;
            "Print"                 , ;
            "Sluiten"               }
         oHmgApp():APP134  := { "BEWERKEN, werkgebied naam bestaat niet", ;
            "BEWERKEN, dit werkgebied heeft meer dan 16 velden", ;
            "BEWERKEN, ververs manier buiten bereik (a.u.b. fout melden)"           , ;
            "BEWERKEN, hoofd gebeurtenis nummer buiten bereik (a.u.b. fout melden)" , ;
            "BEWERKEN, list gebeurtenis nummer buiten bereik (a.u.b. fout melden)"  }

         // EDIT EXTENDED
         oHmgApp():APP128 := {            ;
            "&Sluiten",          ; // 1
            "&Nieuw",            ; // 2
            "&Aanpassen",        ; // 3
            "&Verwijderen",      ; // 4
            "&Vind",             ; // 5
            "&Print",            ; // 6
            "&Annuleren",        ; // 7
            "&Ok",               ; // 8
            "&Kopieer",          ; // 9
            "&Activeer filter",  ; // 10
            "&Deactiveer filter" } // 11
         oHmgApp():APP129 := {                            ;
            "Geen",                             ; // 1
            "Regel",                            ; // 2
            "Totaal",                           ; // 3
            "Actieve volgorde",                 ; // 4
            "Opties",                           ; // 5
            "Nieuw regel",                      ; // 6
            "Aanpassen regel",                  ; // 7
            "Selecteer regel",                  ; // 8
            "Vind regel",                       ; // 9
            "Print opties",                     ; //10
            "Beschikbare velden",               ; //11
            "Velden te printen",                ; //12
            "Beschikbare printers",             ; //13
            "Eerste regel te printen",          ; //14
            "Laatste regel te printen",         ; //15
            "Verwijder regel",                  ; //16
            "Voorbeeld",                        ; //17
            "Laat pagina klein zien",           ; //18
            "Filter condities: ",               ; //19
            "Gefilterd: ",                      ; //20
            "Filter opties" ,                   ; //21
            "Database velden" ,                 ; //22
            "Vergelijkings operator",           ; //23
            "Filter waarde",                    ; //24
            "Selecteer velden om te filteren",  ; //25
            "Selecteer vergelijkings operator", ; //26
            "Gelijk",                           ; //27
            "Niet gelijk",                      ; //28
            "Groter dan",                       ; //29
            "Kleiner dan",                      ; //30
            "Groter dan of gelijk aan",         ; //31
            "Kleiner dan of gelijk aan"         } //32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Kan geen actief werkgebied vinden   "  + ABM_CRLF + "Selecteer A.U.B. een actief werkgebied voor BEWERKEN aan te roepen   " + ABM_CRLF, ; // 1
            "Geef de veld waarde (een tekst)",; // 2
            "Geef de veld waarde (een nummer)",; // 3
            "Selecteer de datum",; // 4
            "Controleer voor geldige waarde",; // 5
            "Geef de veld waarde",; // 6
            "Selecteer een regel en druk op OK",; // 7
            ABM_CRLF + "Je gaat het actieve regel verwijderen  " + ABM_CRLF + "Zeker weten?    " + ABM_CRLF,; // 8
            ABM_CRLF + "Er is geen actieve volgorde " + ABM_CRLF + "Selecteer er A.U.B. een   " + ABM_CRLF,; // 9
            ABM_CRLF + "Kan niet zoeken in memo of logische velden   " + ABM_CRLF,; // 10
            ABM_CRLF + "Regel niet gevonden   " +ABM_CRLF,; // 11
            "Selecteer het veld om in de lijst in te sluiten",; // 12
            "Selecteer het veld om uit de lijst te halen",; // 13
            "Selecteer de printer",; // 14
            "Druk op de knop om het veld in te sluiten",; // 15
            "Druk op de knop om het veld uit te sluiten",; // 16
            "Druk op de knop om het eerste veld te selecteren om te printen",; // 17
            "Druk op de knop om het laatste veld te selecteren om te printen",; // 18
            ABM_CRLF + "Geen velden meer om in te sluiten   " + ABM_CRLF,; // 19
            ABM_CRLF + "Selecteer eerst het veld om in te sluiten   " + ABM_CRLF,; // 20
            ABM_CRLF + "Geen velden meer om uit te sluiten   " + ABM_CRLF,; // 21
            ABM_CRLF + "Selecteer eerst het veld om uit te sluiten   " + ABM_CRLF,; // 22
            ABM_CRLF + "Je hebt geen velden geselecteerd   " + ABM_CRLF + "Selecteer A.U.B. de velden om in te sluiten om te printen   " + ABM_CRLF, ; // 23
            ABM_CRLF + "Teveel velden   " + ABM_CRLF + "Selecteer minder velden   " + ABM_CRLF,; // 24
            ABM_CRLF + "Printer niet klaar   " + ABM_CRLF,; // 25
            "Volgorde op",; // 26
            "Van regel",; // 27
            "Tot regel",; // 28
            "Ja",; // 29
            "Nee",; // 30
            "Pagina:",; // 31
            ABM_CRLF + "Selecteer A.U.B. een printer " + ABM_CRLF,; // 32
            "Gefilterd op", ; // 33
            ABM_CRLF + "Er is een actief filter    " + ABM_CRLF,; // 34
            ABM_CRLF + "Kan niet filteren op memo velden    " + ABM_CRLF,; // 35
            ABM_CRLF + "Selecteer het veld om op te filteren    " + ABM_CRLF, ; // 36
            ABM_CRLF + "Selecteer een operator om te filteren    " + ABM_CRLF,; // 37
            ABM_CRLF + "Type een waarde om te filteren " + ABM_CRLF,; // 38
            ABM_CRLF + "Er is geen actief filter    "+ ABM_CRLF,; // 39
            ABM_CRLF + "Deactiveer filter?   " + ABM_CRLF,; // 40
            ABM_CRLF + "Regel geblokkeerd door een andere gebuiker" + ABM_CRLF } // 41

         // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
      CASE cLang == "SL"
         /////////////////////////////////////////////////////////////
         // SLOVENIAN
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES

         oHmgApp():APP331 [1] := 'Ste prepriËani ?'
         oHmgApp():APP331 [2] := 'Zapri okno'
         oHmgApp():APP331 [3] := 'Zapiranje ni dovoljeno'
         oHmgApp():APP331 [4] := 'Program je ûe zagnan'
         oHmgApp():APP331 [5] := 'Popravi'
         oHmgApp():APP331 [6] := 'V redu'
         oHmgApp():APP331 [7] := 'Prekini'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES

         oHmgApp():APP136  := { "Window: "                        , ;
            " not defined. Program terminated"     , ;
            "HMG Error"                        , ;
            "Control: "                            , ;
            " Of "                                 , ;
            " Already defined. Program Terminated" , ;
            "Type Not Allowed. Program terminated" , ;
            "False WorkArea. Program Terminated"   , ;
            "Zapis ureja drug uporabnik"           , ;
            "Opozorilo"                            , ;
            "Narobe vnos" }

         oHmgApp():APP137 := { 'Ste prepriËani ?' , 'Briöi vrstico' }

         // EDIT MESSAGES

         oHmgApp():APP131   := { Chr(13)+"Briöi vrstico"+CHR(13)+"Ste prepriËani ?"+CHR(13)     , ;
            Chr(13)+"Manjka indeksna datoteka"+CHR(13)+"Ne morem iskati"+CHR(13)       , ;
            Chr(13)+"Ne najdem indeksnega polja"+CHR(13)+"Ne morem iskati"+CHR(13)     , ;
            Chr(13)+"Ne morem iskati po"+CHR(13)+"memo ali logiËnih poljih"+CHR(13)    , ;
            Chr(13)+"Ne najdem vrstice"+CHR(13)                                        , ;
            Chr(13)+"PreveË kolon"+CHR(13)+"PoroËilo ne gre na list"+CHR(13) }

         oHmgApp():APP132  := { "Vrstica"    , ;
            "ätevilo vrstic"         , ;
            "       (Nova)"          , ;
            "      (Popravi)"        , ;
            "Vnesi ötevilko vrstice" , ;
            "PoiöËi"                 , ;
            "Besedilo za iskanje"    , ;
            "Datum za iskanje"       , ;
            "ätevilka za iskanje"    , ;
            "Parametri poroËila"     , ;
            "Kolon v poroËilu"       , ;
            "Kolon na razpolago"     , ;
            "ZaËetna vrstica"        , ;
            "KonËna vrstica"         , ;
            "PporoËilo za "          , ;
            "Datum:"                 , ;
            "ZaËetna vrstica:"       , ;
            "KonËna vrstica:"        , ;
            "Urejeno po:"            , ;
            "Ja"                     , ;
            "Ne"                     , ;
            "Stran "                 , ;
            " od "                 }

         oHmgApp():APP133 := { "Zapri" , ;
            "Nova"              , ;
            "Uredi"             , ;
            "Briöi"             , ;
            "PoiöËi"            , ;
            "Pojdi na"          , ;
            "PoroËilo"          , ;
            "Prva"              , ;
            "Prejönja"          , ;
            "Naslednja"         , ;
            "Zadnja"            , ;
            "Shrani"            , ;
            "Prekini"           , ;
            "Dodaj"             , ;
            "Odstrani"          , ;
            "Natisni"           , ;
            "Zapri"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                  , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED

         oHmgApp():APP128 := {     ;
            "&Zapri",             ; // 1
            "&Nova",              ; // 2
            "&Spremeni",          ; // 3
            "&Briöi",             ; // 4
            "&PoiöËi",            ; // 5
            "&Natisni",           ; // 6
            "&Prekini",           ; // 7
            "&V redu",            ; // 8
            "&Kopiraj",           ; // 9
            "&Aktiviraj Filter",  ; // 10
            "&Deaktiviraj Filter" } // 11
         oHmgApp():APP129 := {                 ;
            "Prazno",                        ; // 1
            "Vrstica",                       ; // 2
            "Skupaj",                        ; // 3
            "Activni indeks",                ; // 4
            "Moûnosti",                      ; // 5
            "Nova vrstica",                  ; // 6
            "Spreminjaj vrstico",            ; // 7
            "OznaËi vrstico",                ; // 8
            "Najdi vrstico",                 ; // 9
            "Moûnosti tiskanja",             ; // 10
            "Polja na razpolago",            ; // 11
            "Polja za tiskanje",             ; // 12
            "Tiskalniki na razpolago",       ; // 13
            "Prva vrstica za tiskanje",      ; // 14
            "Zadnja vrstica za tiskanje",    ; // 15
            "Briöi vrstico",                 ; // 16
            "Pregled",                       ; // 17
            "Mini pregled strani",           ; // 18
            "Pogoj za filter: ",             ; // 19
            "Filtrirano: ",                  ; // 20
            "Moûnosti filtra" ,              ; // 21
            "Polja v datoteki" ,             ; // 22
            "Operator za primerjavo",        ; // 23
            "Vrednost filtra",               ; // 24
            "Izberi polje za filter",        ; // 25
            "Izberi operator za primerjavo", ; // 26
            "Enako",                         ; // 27
            "Neenako",                       ; // 28
            "VeËje od",                      ; // 29
            "Manjöe od",                     ; // 30
            "VeËje ali enako od",            ; // 31
            "Manjöe ali enako od"            } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,; // 1
            "Vnesi vrednost (tekst)",                                                                                        ; // 2
            "Vnesi vrednost (ötevilka)",                                                                                     ; // 3
            "Izberi datum",                                                                                                  ; // 4
            "OznaËi za logiËni DA",                                                                                          ; // 5
            "Vnesi vrednost",                                                                                                ; // 6
            "Izberi vrstico in pritisni <V redu>",                                                                           ; // 7
            ABM_CRLF + "Pobrisali boste trenutno vrstico   " + ABM_CRLF + "Ste prepriËani?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "Ni aktivnega indeksa   " + ABM_CRLF + "Prosimo, izberite ga   " + ABM_CRLF,                          ; // 9
            ABM_CRLF + "Ne morem iskati po logiËnih oz. memo poljih   " + ABM_CRLF,                                          ; // 10
            ABM_CRLF + "Ne najdem vrstice   " + ABM_CRLF,                                                                    ; // 11
            "Izberite polje, ki bo vkljuËeno na listo",                                                                      ; // 12
            "Izberite polje, ki NI vkljuËeno na listo",                                                                      ; // 13
            "Izberite tisklanik",                                                                                            ; // 14
            "Pritisnite gumb za vkljuËitev polja",                                                                           ; // 15
            "Pritisnite gumb za izkljuËitev polja",                                                                          ; // 16
            "Pritisnite gumb za izbor prve vrstice za tiskanje",                                                             ; // 17
            "Pritisnite gumb za izbor zadnje vrstice za tiskanje",                                                           ; // 18
            ABM_CRLF + "Ni veË polj za dodajanje   " + ABM_CRLF,                                                             ; // 19
            ABM_CRLF + "Najprej izberite ppolje za vkljuËitev   " + ABM_CRLF,                                                ; // 20
            ABM_CRLF + "Ni veË polj za izkljuËitev   " + ABM_CRLF,                                                           ; // 21
            ABM_CRLF + "Najprej izberite polje za izkljuËitev   " + ABM_CRLF,                                                ; // 22
            ABM_CRLF + "Niste izbrali nobenega polja   " + ABM_CRLF + "Prosom, izberite polje za tiskalnje   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "PreveË polj   " + ABM_CRLF + "Zmanjöajte ötevilo polj   " + ABM_CRLF,                                ; // 24
            ABM_CRLF + "Tiskalnik ni pripravljen   " + ABM_CRLF,                                                             ; // 25
            "Urejeno po",                                                                                                    ; // 26
            "Od vrstice",                                                                                                    ; // 27
            "do vrstice",                                                                                                    ; // 28
            "Ja",                                                                                                            ; // 29
            "Ne",                                                                                                            ; // 30
            "Stran:",                                                                                                        ; // 31
            ABM_CRLF + "Izberite tiskalnik   " + ABM_CRLF,                                                                   ; // 32
            "Filtrirano z",                                                                                                  ; // 33
            ABM_CRLF + "Aktiven filter v uporabi    " + ABM_CRLF,                                                            ; // 34
            ABM_CRLF + "Ne morem filtrirati z memo polji    " + ABM_CRLF,                                                    ; // 35
            ABM_CRLF + "Izberi polje za filtriranje    " + ABM_CRLF,                                                         ; // 36
            ABM_CRLF + "Izberi operator za filtriranje    " + ABM_CRLF,                                                      ; // 37
            ABM_CRLF + "Vnesi vrednost za filtriranje    " + ABM_CRLF,                                                       ; // 38
            ABM_CRLF + "Ni aktivnega filtra    " + ABM_CRLF,                                                                 ; // 39
            ABM_CRLF + "Deaktiviram filter?   " + ABM_CRLF,                                                                  ; // 40
            ABM_CRLF + "Vrstica zaklenjena - uporablja jo drug uporabnik    " + ABM_CRLF                                     } // 41

      OTHERWISE
         /////////////////////////////////////////////////////////////
         // DEFAULT ENGLISH
         ////////////////////////////////////////////////////////////

         // MISC MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP331 [1] := 'Are you sure ?'
         oHmgApp():APP331 [2] := 'Close Window'
         oHmgApp():APP331 [3] := 'Close not allowed'
         oHmgApp():APP331 [4] := 'Program Already Running'
         oHmgApp():APP331 [5] := 'Edit'
         oHmgApp():APP331 [6] := 'Ok'
         oHmgApp():APP331 [7] := 'Cancel'
         oHmgApp():APP331 [8] := 'Pag.'

         // BROWSE MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP136  := { "Window: "                                              , ;
            " is not defined. Program terminated"                   , ;
            "HMG Error"                                         , ;
            "Control: "                                             , ;
            " Of "                                                  , ;
            " Already defined. Program Terminated"                  , ;
            "Browse: Type Not Allowed. Program terminated"          , ;
            "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated", ;
            "Record Is Being Edited By Another User"                , ;
            "Warning"                                               , ;
            "Invalid Entry"                                          }
         oHmgApp():APP137 := { 'Are you sure ?' , 'Delete Record' }

         // EDIT MESSAGES (ENGLISH DEFAULT)

         oHmgApp():APP131   := { Chr(13)+"Delete record"+CHR(13)+"Are you sure ?"+CHR(13)                  , ;
            Chr(13)+"Index file missing"+CHR(13)+"Can`t do search"+CHR(13)            , ;
            Chr(13)+"Can`t find index field"+CHR(13)+"Can`t do search"+CHR(13)        , ;
            Chr(13)+"Can't do search by"+CHR(13)+"fields memo or logic"+CHR(13)       , ;
            Chr(13)+"Record not found"+CHR(13)                                        , ;
            Chr(13)+"To many cols"+CHR(13)+"The report can't fit in the sheet"+CHR(13) }

         oHmgApp():APP132  := { "Record"              , ;
            "Record count"        , ;
            "       (New)"        , ;
            "      (Edit)"        , ;
            "Enter record number" , ;
            "Find"                , ;
            "Search text"         , ;
            "Search date"         , ;
            "Search number"       , ;
            "Report definition"   , ;
            "Report columns"      , ;
            "Available columns"   , ;
            "Initial record"      , ;
            "Final record"        , ;
            "Report of "          , ;
            "Date:"               , ;
            "Initial record:"     , ;
            "Final record:"       , ;
            "Ordered by:"         , ;
            "Yes"                 , ;
            "No"                  , ;
            "Page "               , ;
            " of "                 }

         oHmgApp():APP133 := { "Close"    , ;
            "New"      , ;
            "Edit"     , ;
            "Delete"   , ;
            "Find"     , ;
            "Goto"     , ;
            "Report"   , ;
            "First"    , ;
            "Previous" , ;
            "Next"     , ;
            "Last"     , ;
            "Save"     , ;
            "Cancel"   , ;
            "Add"      , ;
            "Remove"   , ;
            "Print"    , ;
            "Close"     }
         oHmgApp():APP134  := { "EDIT, workarea name missing"                              , ;
            "EDIT, this workarea has more than 16 fields"              , ;
            "EDIT, refresh mode out of range (please report bug)"      , ;
            "EDIT, main event number out of range (please report bug)" , ;
            "EDIT, list event number out of range (please report bug)"  }

         // EDIT EXTENDED (ENGLISH DEFAULT)

         oHmgApp():APP128 := {            ;
            "&Close",            ; // 1
            "&New",              ; // 2
            "&Modify",           ; // 3
            "&Delete",           ; // 4
            "&Find",             ; // 5
            "&Print",            ; // 6
            "&Cancel",           ; // 7
            "&Ok",               ; // 8
            "&Copy",             ; // 9
            "&Activate Filter",  ; // 10
            "&Deactivate Filter" } // 11
         oHmgApp():APP129 := {                        ;
            "None",                         ; // 1
            "Record",                       ; // 2
            "Total",                        ; // 3
            "Active order",                 ; // 4
            "Options",                      ; // 5
            "New record",                   ; // 6
            "Modify record",                ; // 7
            "Select record",                ; // 8
            "Find record",                  ; // 9
            "Print options",                ; // 10
            "Available fields",               ; // 11
            "Fields to print",              ; // 12
            "Available printers",           ; // 13
            "First record to print",        ; // 14
            "Last record to print",         ; // 15
            "Delete record",                ; // 16
            "Preview",                      ; // 17
            "View page thumbnails",         ; // 18
            "Filter Condition: ",           ; // 19
            "Filtered: ",                   ; // 20
            "Filtering Options" ,           ; // 21
            "Database Fields" ,             ; // 22
            "Comparission Operator",        ; // 23
            "Filter Value",                 ; // 24
            "Select Field To Filter",       ; // 25
            "Select Comparission Operator", ; // 26
            "Equal",                        ; // 27
            "Not Equal",                    ; // 28
            "Greater Than",                 ; // 29
            "Lower Than",                   ; // 30
            "Greater or Equal Than",        ; // 31
            "Lower or Equal Than"           } // 32
         oHmgApp():APP130 := { ;
            ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
            "Type the field value (any text)",                                                                                      ; // 2
            "Type the field value (any number)",                                                                                    ; // 3
            "Select the date",                                                                                                      ; // 4
            "Check for true value",                                                                                                 ; // 5
            "Enter the field value",                                                                                                ; // 6
            "Select any record and press OK",                                                                                       ; // 7
            ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
            ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
            ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
            ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
            "Select the field to include to list",                                                                                  ; // 12
            "Select the field to exclude from list",                                                                                ; // 13
            "Select the printer",                                                                                                   ; // 14
            "Push button to include field",                                                                                         ; // 15
            "Push button to exclude field",                                                                                         ; // 16
            "Push button to select the first record to print",                                                                      ; // 17
            "Push button to select the last record to print",                                                                       ; // 18
            ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
            ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
            ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
            ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
            ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
            ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
            ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
            "Ordered by",                                                                                                           ; // 26
            "From record",                                                                                                          ; // 27
            "To record",                                                                                                            ; // 28
            "Yes",                                                                                                                  ; // 29
            "No",                                                                                                                   ; // 30
            "Page:",                                                                                                                ; // 31
            ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
            "Filtered by",                                                                                                          ; // 33
            ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
            ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
            ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
            ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
            ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
            ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
            ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
            ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                                   } // 41

      ENDCASE

   ENDIF // HMG_IsCurrentCodePageUnicode()

   RETURN
