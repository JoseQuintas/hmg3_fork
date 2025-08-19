/*
h_HmgAppClass
*/

#include "hbclass.ch"
#define COLOR_HIGHLIGHT      13
#define COLOR_HIGHLIGHTTEXT  14

FUNCTION oHmgApp()

   THREAD STATIC oApp

   IF ValType( oApp ) != "O"
      oApp := _hmgAppClass():New()
   ENDIF

   RETURN oApp

CREATE CLASS _HmgAppClass STATIC

   VAR    aFormList                      INIT {}
   VAR    aControlList                   INIT {}

   VAR    ActiveControlVertical          INIT Nil
   VAR    ActiveControlFormat            INIT Nil
   VAR    ActiveControlImageList         INIT Nil
   VAR    ActiveControlNoTicks           INIT Nil
   VAR    ActiveFontSize                 INIT 0
   VAR    ActiveIniFile                  INIT ""
   VAR    ActiveFormName                 INIT ""
   VAR    ActiveMessageBarName           INIT ""
   VAR    ActiveModalHandle              INIT 0
   VAR    ActiveTabFlat                  INIT .F.
   VAR    ActiveTabButtons               INIT .F.
   VAR    ActiveTabPage                  INIT 0
   VAR    ActiveTabCol                   INIT 0
   VAR    ActiveTabRow                   INIT 0
   VAR    ActiveTabWidth                 INIT 0
   VAR    ActiveTabHeight                INIT 0
   VAR    ActiveTabValue                 INIT 0
   VAR    ActiveTabFontSize              INIT 0
   VAR    ActiveToolbarExtend            INIT .F.
   VAR    ActiveWindowHandle             INIT 0
   VAR    AutoScroll                     INIT .T.
   VAR    BeginTabActive                 INIT .F.
   VAR    CurrentStatusbarFontSize       INIT 0
   VAR    DefaultIconName                INIT Nil
   VAR    aEventInfo                     INIT {}
   VAR    EventData                      INIT {}
   VAR    EventHookID                    INIT -1
   VAR    EventHookCode                  INIT -1
   VAR    EventINDEX                     INIT 0
   VAR    EventHWnd                      INIT 0
   VAR    EventMsg                       INIT 0
   VAR    EventWParam                    INIT 0
   VAR    EventLParam                    INIT 0
   VAR    EventProcName                  INIT ""
   VAR    EventIsInProgress              INIT .F.
   VAR    EventIsMouseMessage            INIT .F.
   VAR    EventIsKeyboardMessage         INIT .F.
   VAR    EventIsHMGWindowsMessage       INIT .F.
   VAR    FrameLevel                     INIT 0
   VAR    GridInPlaceEdit_StageEvent     INIT 0
   VAR    GridInPlaceEdit_ControlHandle  INIT 0
   VAR    GridInplaceEdit_GridIndex      INIT 0
   VAR    GridEx_InplaceEditOption       INIT 0
   VAR    GridEx_InplaceEdit_nMsg        INIT 0
   VAR    Grid_SelectedRow_DisplayColor  INIT .T.
   VAR    Grid_SelectedCell_DisplayColor INIT .T.
   VAR    InteractiveCloseStarted        INIT .F.
   VAR    IsExtendedNavigation           INIT .F.
   VAR    IsXP                           INIT .F.
   VAR    IsBCC77                        INIT .F.
   VAR    IsModalActive                  INIT .F.
   VAR    LastActiveControlIndex         INIT 0
   VAR    LastActiveFormIndex            INIT 0
   VAR    LastFormIndexWithCursor        INIT 0
   VAR    MainIndex                      INIT 0
   VAR    MainWindowFirst                INIT .T.
   VAR    MainHandle                     INIT 0
   VAR    MainFormIndex                  INIT 0
   VAR    MouseRow                       INIT 0
   VAR    MouseCol                       INIT 0
   VAR    MouseState                     INIT 0
   VAR    nTopic                         INIT 0
   VAR    StatusItemCount                INIT 0
   VAR    ToolbarActive                  INIT .F.
   VAR    ThisCargo                      INIT Nil
   VAR    ThisControlName                INIT ""
   VAR    ThisControlIndex               INIT 0
   VAR    ThisEventType                  INIT ""
   VAR    ThisFormName                   INIT ""
   VAR    ThisItemRow                    INIT 0
   VAR    ThisItemCellWidth              INIT 0
   VAR    ThisItemCellHeight             INIT 0
   VAR    ThisItemCol                    INIT 0
   VAR    ThisItemColIndex               INIT 0
   VAR    ThisItemRowIndex               INIT 0
   VAR    ThisFormIndex                  INIT 0
   VAR    ThisType                       INIT ""
   VAR    This_TreeItem_Value            INIT Nil
   VAR    xContextMenuButtonIndex        INIT 0
   VAR    xMainMenuParentName            INIT ""
   VAR    APP053                         INIT {}
   VAR    APP054                         INIT _GETDDLMESSAGE()
   VAR    APP055                         INIT .F.
   VAR    APP056                         INIT Nil
   VAR    APP057                         INIT Nil
   VAR    APP058                         INIT {}
   VAR    APP059                         INIT {}
   VAR    APP060                         INIT {}
   VAR    APP061                         INIT {}
   VAR    APP062                         INIT {}
   VAR    APP063                         INIT {}
   VAR    APP109                         INIT 0
   VAR    APP110                         INIT Nil
   VAR    APP111                         INIT Nil
   VAR    APP112                         INIT Nil
   VAR    APP113                         INIT Nil
   VAR    APP114                         INIT Nil
   VAR    APP115                         INIT Nil
   VAR    APP116                         INIT Nil
   VAR    APP117                         INIT Nil
   VAR    APP118                         INIT Nil
   VAR    APP119                         INIT Nil
   VAR    APP120                         INIT Nil
   VAR    APP121                         INIT Nil
   VAR    APP122                         INIT Nil
   VAR    APP123                         INIT Nil
   VAR    APP124                         INIT Nil
   VAR    APP125                         INIT Nil
   VAR    APP126                         INIT Nil
   VAR    APP127                         INIT Nil
   VAR    APP128                         INIT {}
   VAR    APP129                         INIT {}
   VAR    APP130                         INIT {}
   VAR    APP131                         INIT {}
   VAR    APP132                         INIT {}
   VAR    APP133                         INIT {}
   VAR    APP134                         INIT {}
   VAR    APP135                         INIT {}
   VAR    APP136                         INIT {}
   VAR    APP137                         INIT {}
   VAR    APP138                         INIT {}
   VAR    APP139                         INIT {}
   VAR    APP140                         INIT {}
   VAR    APP141                         INIT {}
   VAR    APP142                         INIT {}
   VAR    APP143                         INIT {}
   VAR    APP144                         INIT {}
   VAR    APP145                         INIT {}
   VAR    APP146                         INIT {}
   VAR    APP147                         INIT {}
   VAR    APP148                         INIT {}
   VAR    APP149                         INIT Nil
   VAR    APP150                         INIT Nil
   VAR    APP151                         INIT Nil
   VAR    APP152                         INIT Nil
   VAR    APP153                         INIT Nil
   VAR    APP154                         INIT Nil
   VAR    APP155                         INIT Nil
   VAR    APP156                         INIT Nil
   VAR    APP157                         INIT Nil
   VAR    APP158                         INIT Nil
   VAR    APP159                         INIT Nil
   VAR    APP160                         INIT Nil
   VAR    APP161                         INIT Nil
   VAR    APP162                         INIT Nil
   VAR    APP163                         INIT Nil
   VAR    APP164                         INIT 0
   VAR    APP165                         INIT 0
   VAR    APP166                         INIT 0
   VAR    APP167                         INIT 0
   VAR    APP168                         INIT 0
   VAR    APP169                         INIT 0
   VAR    APP170                         INIT 0
   VAR    APP172                         INIT 0
   VAR    APP173                         INIT 0
   VAR    APP174                         INIT 0
   VAR    APP175                         INIT 0
   VAR    APP176                         INIT 0
   VAR    APP177                         INIT 0
   VAR    APP178                         INIT 0
   VAR    APP179                         INIT 0
   VAR    APP180                         INIT 0
   VAR    APP181                         INIT 0
   VAR    APP182                         INIT 0
   VAR    APP183                         INIT 0
   VAR    APP184                         INIT 0
   VAR    APP185                         INIT 0
   VAR    APP186                         INIT 0
   VAR    APP187                         INIT 0
   VAR    APP188                         INIT 0
   VAR    APP189                         INIT 0
   VAR    APP190                         INIT 0
   VAR    APP191                         INIT 0
   VAR    APP192                         INIT 0
   VAR    APP193                         INIT 0
   VAR    APP194                         INIT 0
   VAR    APP195                         INIT 0
   VAR    APP196                         INIT 0
   VAR    APP197                         INIT 0
   VAR    APP198                         INIT 0
   VAR    APP199                         INIT 0
   VAR    APP200                         INIT 0
   VAR    APP201                         INIT 0
   VAR    APP202                         INIT 0
   VAR    APP203                         INIT 0
   VAR    APP204                         INIT Nil
   VAR    APP205                         INIT Nil
   VAR    APP206                         INIT Nil
   VAR    APP207                         INIT Nil
   VAR    APP208                         INIT Nil
   VAR    APP209                         INIT Nil
   VAR    APP210                         INIT ""
   VAR    APP211                         INIT ""
   VAR    APP212                         INIT ""
   VAR    APP213                         INIT ""
   VAR    APP214                         INIT ""
   VAR    APP215                         INIT ""
   VAR    APP216                         INIT ""
   VAR    APP217                         INIT ""
   VAR    APP218                         INIT ""
   VAR    APP219                         INIT ""
   VAR    APP220                         INIT ""
   VAR    APP221                         INIT ""
   VAR    APP222                         INIT ""
   VAR    APP223                         INIT ""
   VAR    APP224                         INIT ""
   VAR    APP225                         INIT ""
   VAR    APP226                         INIT ""
   VAR    APP227                         INIT ""
   VAR    APP228                         INIT ""
   VAR    APP229                         INIT ""
   VAR    APP230                         INIT ""
   VAR    APP231                         INIT ""
   VAR    APP232                         INIT ""
   VAR    APP233                         INIT Nil
   VAR    APP234                         INIT Nil
   VAR    APP235                         INIT -1
   VAR    APP236                         INIT -1
   VAR    APP237                         INIT -1
   VAR    APP238                         INIT -1
   VAR    APP239                         INIT Nil
   VAR    APP240                         INIT .F.
   VAR    APP241                         INIT Nil
   VAR    APP242                         INIT .F.
   VAR    APP243                         INIT .F.
   VAR    APP244                         INIT Nil
   VAR    APP245                         INIT Nil
   VAR    APP246                         INIT Nil
   VAR    APP247                         INIT Nil
   VAR    APP248                         INIT Nil
   VAR    APP249                         INIT Nil
   VAR    APP250                         INIT .F.
   VAR    APP251                         INIT .F.
   VAR    APP252                         INIT .F.
   VAR    APP253                         INIT .F.
   VAR    APP254                         INIT .F.
   VAR    APP255                         INIT .F.
   VAR    APP256                         INIT .F.
   VAR    APP257                         INIT .F.
   VAR    APP258                         INIT .F.
   VAR    APP259                         INIT .F.
   VAR    APP260                         INIT .F.
   VAR    APP261                         INIT .F.
   VAR    APP262                         INIT .F.
   VAR    APP263                         INIT .F.
   VAR    APP264                         INIT .F.
   VAR    APP265                         INIT .F.
   VAR    APP266                         INIT .F.
   VAR    APP267                         INIT .F.
   VAR    APP268                         INIT .F.
   VAR    APP269                         INIT .F.
   VAR    APP270                         INIT .F.
   VAR    APP272                         INIT .F.
   VAR    APP273                         INIT .F.
   VAR    APP274                         INIT .F.
   VAR    APP275                         INIT .F.
   VAR    APP276                         INIT .F.
   VAR    APP277                         INIT Nil
   VAR    APP278                         INIT Nil
   VAR    APP279                         INIT Nil
   VAR    APP280                         INIT Nil
   VAR    APP281                         INIT Nil
   VAR    APP282                         INIT Nil
   VAR    APP283                         INIT Nil
   VAR    APP284                         INIT .F.
   VAR    APP285                         INIT .F.
   VAR    APP286                         INIT .F.
   VAR    APP287                         INIT .F.
   VAR    APP288                         INIT Nil
   VAR    APP289                         INIT Nil
   VAR    APP290                         INIT Nil
   VAR    APP291                         INIT Nil
   VAR    APP292                         INIT Nil
   VAR    APP293                         INIT Nil
   VAR    APP294                         INIT Nil
   VAR    APP295                         INIT Nil
   VAR    APP296                         INIT Nil
   VAR    APP297                         INIT Nil
   VAR    APP298                         INIT Nil
   VAR    APP299                         INIT .F.
   VAR    APP300                         INIT Nil
   VAR    APP301                         INIT Nil
   VAR    APP302                         INIT Nil
   VAR    APP303                         INIT Nil
   VAR    APP304                         INIT Nil
   VAR    APP305                         INIT Nil
   VAR    APP306                         INIT IsExeRunning (HB_UTF8STRTRAN (GetProgramFileName(), '\', '_'))
   VAR    APP307                         INIT Nil
   VAR    APP308                         INIT Nil
   VAR    APP309                         INIT Nil
   VAR    APP310                         INIT Nil
   VAR    APP311                         INIT Nil
   VAR    APP312                         INIT Nil
   VAR    APP313                         INIT Nil
   VAR    APP314                         INIT Nil
   VAR    APP315                         INIT Nil
   VAR    APP316                         INIT Nil
   VAR    APP317                         INIT Nil
   VAR    APP318                         INIT Nil
   VAR    APP319                         INIT Nil
   VAR    APP320                         INIT .F.
   VAR    APP321                         INIT .F.
   VAR    APP322                         INIT Nil
   VAR    APP323                         INIT Nil
   VAR    APP324                         INIT Nil
   VAR    APP325                         INIT Nil
   VAR    APP326                         INIT Nil
   VAR    APP327                         INIT Nil
   VAR    APP328                         INIT Nil
   VAR    APP329                         INIT Nil
   VAR    APP330                         INIT {}
   VAR    APP331                         INIT Array(8)
   VAR    APP332                         INIT Array(128)
   VAR    APP333                         INIT Array(128)
   VAR    APP334                         INIT Array(128)
   VAR    APP335                         INIT Array(255)
   VAR    APP336                         INIT Array(255)
   VAR    APP337                         INIT Array(255)
   VAR    APP338                         INIT .T.
   VAR    APP339                         INIT 1
   VAR    APP340                         INIT 1
   VAR    APP341                         INIT 1
   VAR    APP342                         INIT "Arial"
   VAR    APP343                         INIT 9
   VAR    APP344                         INIT "None"
   VAR    APP345                         INIT 1
   VAR    APP346                         INIT Nil
   VAR    APP347                         INIT .T.
   VAR    APP348                         INIT {0,0,0}
   VAR    APP349                         INIT { 235 , 235 , 235 }
   VAR    APP350                         INIT { GetRed ( GetSysColor (COLOR_HIGHLIGHTTEXT) )   , GetGreen ( GetSysColor ( COLOR_HIGHLIGHTTEXT) )   , GetBlue ( GetSysColor (COLOR_HIGHLIGHTTEXT) ) }
   VAR    APP351                         INIT { GetRed ( GetSysColor (COLOR_HIGHLIGHT) )   , GetGreen ( GetSysColor (COLOR_HIGHLIGHT ) )      , GetBlue ( GetSysColor (COLOR_HIGHLIGHT) )   }
   VAR    APP352                         INIT Nil
   VAR    APP353                         INIT Nil
   VAR    APP354                         INIT Nil
   VAR    APP355                         INIT Nil
   VAR    APP356                         INIT Nil
   VAR    APP357                         INIT .F.
   VAR    APP358                         INIT Nil
   VAR    APP359                         INIT Nil
   VAR    APP360                         INIT Nil
   VAR    APP361                         INIT Nil
   VAR    APP362                         INIT Nil
   VAR    APP363                         INIT Nil
   VAR    APP364                         INIT Nil
   VAR    APP365                         INIT Nil
   VAR    APP366                         INIT Nil
   VAR    APP367                         INIT Nil
   VAR    APP368                         INIT Nil
   VAR    APP369                         INIT Nil
   VAR    APP370                         INIT Nil
   VAR    APP371                         INIT Array(29)
   VAR    APP372                         INIT Nil
   VAR    APP373                         INIT {0,"",0,0}
   VAR    APP374                         INIT Nil
   VAR    APP375                         INIT ""
   VAR    APP376                         INIT Nil
   VAR    APP377                         INIT Nil
   VAR    APP378                         INIT Nil
   VAR    APP379                         INIT Nil
   VAR    APP380                         INIT Nil
   VAR    APP381                         INIT Nil
   VAR    APP382                         INIT Nil
   VAR    APP383                         INIT Nil
   VAR    APP384                         INIT Nil
   VAR    APP385                         INIT Nil
   VAR    APP386                         INIT Nil
   VAR    APP387                         INIT Nil
   VAR    APP388                         INIT Nil
   VAR    APP389                         INIT Nil
   VAR    APP390                         INIT Nil
   VAR    APP391                         INIT Nil
   VAR    APP392                         INIT Nil
   VAR    APP393                         INIT Nil
   VAR    APP394                         INIT Nil
   VAR    APP395                         INIT Nil
   VAR    APP396                         INIT Nil
   VAR    APP397                         INIT Nil
   VAR    APP398                         INIT Nil
   VAR    APP399                         INIT Nil
   VAR    APP400                         INIT Nil
   VAR    APP401                         INIT Nil
   VAR    APP402                         INIT Nil
   VAR    APP403                         INIT Nil
   VAR    APP404                         INIT Nil
   VAR    APP405                         INIT Nil
   VAR    APP406                         INIT Nil
   VAR    APP407                         INIT Nil
   VAR    APP408                         INIT Nil
   VAR    APP409                         INIT Nil
   VAR    APP410                         INIT Nil
   VAR    APP411                         INIT Nil
   VAR    APP412                         INIT Nil
   VAR    APP413                         INIT Nil
   VAR    APP414                         INIT Nil
   VAR    APP415                         INIT Nil
   VAR    APP416                         INIT Nil
   VAR    APP417                         INIT Nil
   VAR    APP418                         INIT Nil
   VAR    APP419                         INIT Nil
   VAR    APP420                         INIT Nil
   VAR    APP421                         INIT Nil
   VAR    APP422                         INIT Nil
   VAR    APP423                         INIT Nil
   VAR    APP424                         INIT Nil
   VAR    APP425                         INIT Nil
   VAR    APP426                         INIT Nil
   VAR    APP427                         INIT Nil
   VAR    APP428                         INIT Nil
   VAR    APP429                         INIT Nil
   VAR    APP430                         INIT Nil
   VAR    APP431                         INIT Nil
   VAR    APP432                         INIT Nil
   VAR    APP433                         INIT Nil
   VAR    APP434                         INIT Nil
   VAR    APP435                         INIT Nil
   VAR    APP436                         INIT Nil
   VAR    APP437                         INIT Nil
   VAR    APP438                         INIT Nil
   VAR    APP439                         INIT Nil
   VAR    APP440                         INIT Nil
   VAR    APP441                         INIT Nil
   VAR    APP442                         INIT Nil
   VAR    APP443                         INIT Nil
   VAR    APP444                         INIT Nil
   VAR    APP445                         INIT Nil
   VAR    APP446                         INIT Nil
   VAR    APP447                         INIT Nil
   VAR    APP448                         INIT Nil
   VAR    APP449                         INIT Nil
   VAR    APP450                         INIT Nil
   VAR    APP451                         INIT Nil
   VAR    APP452                         INIT Nil
   VAR    APP453                         INIT Nil
   VAR    APP454                         INIT Nil
   VAR    APP455                         INIT Nil
   VAR    APP456                         INIT Nil
   VAR    APP457                         INIT Nil
   VAR    APP458                         INIT Nil
   VAR    APP459                         INIT Nil
   VAR    APP460                         INIT Nil
   VAR    APP461                         INIT Nil
   VAR    APP462                         INIT Nil
   VAR    APP463                         INIT Nil
   VAR    APP464                         INIT Nil
   VAR    APP465                         INIT Nil
   VAR    APP466                         INIT Nil
   VAR    APP467                         INIT Nil
   VAR    APP468                         INIT Nil
   VAR    APP469                         INIT Nil
   VAR    APP470                         INIT Nil
   VAR    APP472                         INIT Nil
   VAR    APP473                         INIT Nil
   VAR    APP474                         INIT Nil
   VAR    APP475                         INIT Nil
   VAR    APP476                         INIT Nil
   VAR    APP477                         INIT Nil
   VAR    APP478                         INIT Nil
   VAR    APP479                         INIT Nil
   VAR    APP480                         INIT Nil
   VAR    APP481                         INIT Nil
   VAR    APP482                         INIT Nil
   VAR    APP483                         INIT Nil
   VAR    APP484                         INIT Nil
   VAR    APP485                         INIT Nil
   VAR    APP486                         INIT Nil
   VAR    APP487                         INIT Nil
   VAR    APP488                         INIT Nil
   VAR    APP489                         INIT Nil
   VAR    APP490                         INIT Nil
   VAR    APP491                         INIT Nil
   VAR    APP492                         INIT Nil
   VAR    APP493                         INIT Nil
   VAR    APP494                         INIT Nil
   VAR    APP495                         INIT Nil
   VAR    APP496                         INIT Nil
   VAR    APP497                         INIT Nil
   VAR    APP498                         INIT Nil
   VAR    APP499                         INIT Nil
   VAR    APP501                         INIT 20
   VAR    APP502                         INIT 0
   VAR    APP503                         INIT { Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil }
   VAR    APP507                         INIT Nil
   VAR    APP508                         INIT Nil
   VAR    APP509                         INIT .F.
   VAR    APP510                         INIT .T.
   VAR    APP513                         INIT .F.
   VAR    APP514                         INIT .T.
   VAR    APP515                         INIT 0
   VAR    APP516                         INIT ""
   VAR    APP517                         INIT HMG_TString():New()

   METHOD AddForm()
   METHOD AddControl()
   METHOD FormByBlock( bCode )
   METHOD ControlByBlock( bCode )
   METHOD FormListBy( bCode, nLimit )
   METHOD FormCount()             INLINE Len( ::aFormList )
   METHOD ControlCount()          INLINE Len( ::aControlList )
   METHOD AllForms()              INLINE ::aFormList
   METHOD AllControls()           INLINE ::aControlList

   ENDCLASS

METHOD FormByBlock( xField, xValue ) CLASS _HMGAppClass

   LOCAL bCode, nIndex

   DO CASE
   CASE ValType( xField ) == "B"; bCode := xField
   CASE xField == "index" ;  RETURN ::aFormList[ xValue ] // bCode := { | e | e:Index == xValue }
   CASE xField == "name" ;   bCode := { | e | e:Name == xValue }
   CASE xField == "handle" ; bCode := { | e | e:handle == xValue }
   ENDCASE

   nIndex := hb_ASCan( ::aFormList, bCode )
   IF nIndex != 0
      RETURN ::aFormList[ nIndex ]
   ENDIF

   RETURN Nil

METHOD ControlByBlock( xField, xValue ) CLASS _HMGAppClass

   LOCAL bCode, nIndex

   DO CASE
   CASE ValType( xField ) == "B"; bCode := xField
   CASE xField == "index" ;  RETURN ::aControlList[ xValue ] // bCode := { | e | e:Index == xValue }
   CASE xField == "handle" ; bCode := { | e | ValType( e:Handle ) == "N" .AND. e:handle == xValue }
   ENDCASE

   nIndex := hb_ASCan( ::aControlList, bCode )
   IF nIndex != 0
      RETURN ::aControlList[ nIndex ]
   ENDIF

   RETURN Nil

METHOD FormListBy( bCode, nLimit ) CLASS _HmgAppClass

   LOCAL aItem, aList := {}

   FOR EACH aItem IN ::aFormList
      IF Eval( bCode, aItem )
         AAdd( aList, aItem )
         IF nLimit != Nil .AND. Len( aList ) >= nLimit
            EXIT
         ENDIF
      ENDIF
   NEXT

   RETURN aList

METHOD AddForm() CLASS _HmgAppClass

   LOCAL oform, nIndex

   ::FormCount() // test for bug on array
   nIndex := Len( ::aFormList ) + 1
   oForm := _hmgFormClass():New()
   oForm:Index := nIndex
   AAdd( ::aFormList, oForm )

   RETURN oForm

METHOD AddControl() CLASS _HmgAppClass

   LOCAL oControl, nIndex

   nIndex := Len( ::aControlList ) + 1
   oControl := _hmgControlClass():New()
   oControl:Index := nIndex
   AAdd( ::aControlList, oControl )

   RETURN oControl
