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
   Copyright 1999-2009, http://www.harbour-project.org/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
     Copyright 2001-2009 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

MEMVAR _HMG_SYSDATA

#include "hmg.ch"
#include "Fileio.ch"


* Main ************************************************************************

Procedure _DefineReport ( cName )

   oHmgApp():APP206 := Nil
   oHmgApp():APP207 := Nil

   oHmgApp():APP118 := 0
   oHmgApp():APP119 := 0

   oHmgApp():APP120 := 0

   oHmgApp():APP121 := {}
   oHmgApp():APP122 := {}

   oHmgApp():APP123 := 0
   oHmgApp():APP124 := 0

   oHmgApp():APP155 := 0
   oHmgApp():APP156 := 0

   oHmgApp():APP157 := {}
   oHmgApp():APP158 := {}
   oHmgApp():APP159 := {}
   oHmgApp():APP160 := {}
   oHmgApp():APP126 := {}
   oHmgApp():APP127 := 0
   oHmgApp():APP161 := 'MAIN'

   If cName <> '_TEMPLATE_'

      oHmgApp():APP162 := cName

   Else

      cName := oHmgApp():APP162

   EndIf

   Public &cName := {}

Return

Procedure _EndReport
Local cReportName
Local aMiscdata

   aMiscData := {}

   aadd ( aMiscData , oHmgApp():APP120 ) // nGroupCount
   aadd ( aMiscData , oHmgApp():APP152 ) // nHeadeHeight
   aadd ( aMiscData , oHmgApp():APP153 ) // nDetailHeight
   aadd ( aMiscData , oHmgApp():APP154 ) // nFooterHeight
   aadd ( aMiscData , oHmgApp():APP127 ) // nSummaryHeight
   aadd ( aMiscData , oHmgApp():APP124 ) // nGroupHeaderHeight
   aadd ( aMiscData , oHmgApp():APP123 ) // nGroupFooterHeight
   aadd ( aMiscData , oHmgApp():APP125 ) // xGroupExpression
   aadd ( aMiscData , oHmgApp():APP206 ) // xSkipProcedure
   aadd ( aMiscData , oHmgApp():APP207 ) // xEOF

   cReportName := oHmgApp():APP162

   &cReportName := { oHmgApp():APP159 , oHmgApp():APP160 , oHmgApp():APP158 , oHmgApp():APP157 , oHmgApp():APP126 , oHmgApp():APP121 , oHmgApp():APP122 , aMiscData }

Return

* Layout **********************************************************************

Procedure _BeginLayout

   oHmgApp():APP161 := 'LAYOUT'

Return

Procedure _EndLayout

   aadd ( oHmgApp():APP159 , oHmgApp():APP155 )
   aadd ( oHmgApp():APP159 , oHmgApp():APP156 )
   aadd ( oHmgApp():APP159 , oHmgApp():APP118 )
   aadd ( oHmgApp():APP159 , oHmgApp():APP119 )

Return

* Header **********************************************************************

Procedure _BeginHeader

   oHmgApp():APP161 := 'HEADER'

   oHmgApp():APP160 := {}

Return

Procedure _EndHeader


Return


* Detail **********************************************************************

Procedure _BeginDetail

   oHmgApp():APP161 := 'DETAIL'

   oHmgApp():APP158 := {}

Return

Procedure _EndDetail


Return

* Footer **********************************************************************

Procedure _BeginFooter

   oHmgApp():APP161 := 'FOOTER'

   oHmgApp():APP157 := {}

Return

Procedure _EndFooter


Return

* Summary **********************************************************************

Procedure _BeginSummary

   oHmgApp():APP161 := 'SUMMARY'

Return

Procedure _EndSummary


Return


* Text **********************************************************************

Procedure _BeginText

   oHmgApp():APP116 := ''         // Text
   oHmgApp():APP431 := 0         // Row
   oHmgApp():APP432 := 0         // Col
   oHmgApp():APP420 := 0                  // Width
   oHmgApp():APP421 := 0         // Height
   oHmgApp():APP422 := 'Arial'      // FontName
   oHmgApp():APP423 := 9         // FontSize
   oHmgApp():APP412 := .F.      // FontBold
   oHmgApp():APP413 := .F.      // FontItalic
   oHmgApp():APP415 := .F.      // FontUnderLine
   oHmgApp():APP414 := .F.      // FontStrikeout
   oHmgApp():APP458 := { 0 , 0 , 0 }   // FontColor
   oHmgApp():APP440 := .F.      // Alignment
   oHmgApp():APP393 := .F.      // Alignment

Return

Procedure _EndText

Local aText

   aText := {           ;
      'TEXT'         , ;
      oHmgApp():APP116   , ;
      oHmgApp():APP431   , ;
      oHmgApp():APP432   , ;
      oHmgApp():APP420   , ;
      oHmgApp():APP421   , ;
      oHmgApp():APP422   , ;
      oHmgApp():APP423   , ;
      oHmgApp():APP412   , ;
      oHmgApp():APP413   , ;
      oHmgApp():APP415   , ;
      oHmgApp():APP414   , ;
      oHmgApp():APP458   , ;
      oHmgApp():APP440   , ;
      oHmgApp():APP393     ;
      }

   If   oHmgApp():APP161 == 'HEADER'

           aadd (    oHmgApp():APP160 , aText )

   ElseIf   oHmgApp():APP161 == 'DETAIL'

           aadd ( oHmgApp():APP158 , aText )

   ElseIf   oHmgApp():APP161 == 'FOOTER'

           aadd ( oHmgApp():APP157 , aText )

   ElseIf   oHmgApp():APP161 == 'SUMMARY'

           aadd ( oHmgApp():APP126 , aText )

   ElseIf   oHmgApp():APP161 == 'GROUPHEADER'

           aadd ( oHmgApp():APP121 , aText )

   ElseIf   oHmgApp():APP161 == 'GROUPFOOTER'

           aadd ( oHmgApp():APP122 , aText )

   EndIf

Return

* Band Height *****************************************************************

Procedure _BandHeight ( nValue )

   IF   oHmgApp():APP161 == 'HEADER'

      oHmgApp():APP152 := nValue

   ELSEIF   oHmgApp():APP161 == 'DETAIL'

      oHmgApp():APP153 := nValue

   ELSEIF   oHmgApp():APP161 == 'FOOTER'

      oHmgApp():APP154 := nValue

   ELSEIF   oHmgApp():APP161 == 'SUMMARY'

      oHmgApp():APP127 := nValue

   ELSEIF   oHmgApp():APP161 == 'GROUPHEADER'

      oHmgApp():APP124 := nValue

   ELSEIF   oHmgApp():APP161 == 'GROUPFOOTER'

      oHmgApp():APP123 := nValue

   ENDIF

Return

* Execute *********************************************************************

Procedure ExecuteReport ( cReportName , lPreview , lSelect , cOutputFileName )

Local aLayout
Local aHeader
Local aDetail
Local aFooter
Local aSummary
Local aTemp
Local cPrinter
Local nDetailBandsPerPage
Local nPaperWidth
Local nPaperHeight
Local nOrientation
Local nPaperSize
Local nHeadeHeight
Local nDetailHeight
Local nFooterHeight
Local nBandSpace
Local nCurrentOffset
Local nPreviousRecNo
Local nSummaryHeight
Local aGroupHeader
Local aGroupFooter
Local nGroupHeaderHeight
Local nGroupFooterHeight
Local xGroupExpression
Local nGroupCount
Local xPreviousGroupExpression
Local lGroupStarted
Local aMiscData
Local xTemp
Local aPaper [18] [2]
Local cPdfPaperSize := ''
Local cPdfOrientation := ''
Local nOutfile
Local xSkipProcedure
Local xEOF
Local aReport, lSuccess, lTempEof

   IF oHmgApp():APP120 > 1
      MsgHMGError('Only One Group Level Allowed')
   ENDIF

   oHmgApp():APP149 := ''
   oHmgApp():APP151 := .F.
   oHmgApp():APP163 := .F.

   If ValType ( cOutputFileName ) == 'C'

      If ALLTRIM ( HMG_UPPER ( HB_URIGHT ( cOutputFileName , 4 ) ) ) == '.PDF'

         oHmgApp():APP151 := .T.

      ElseIf ALLTRIM ( HMG_UPPER ( HB_URIGHT ( cOutputFileName , 5 ) ) ) == '.HTML'

         oHmgApp():APP163 := .T.

      EndIf

   EndIf

   IF oHmgApp():APP163 == .T.

      oHmgApp():APP149 += '<html>' + CHR(13) + CHR(10)

      oHmgApp():APP149 += '<style>' + CHR(13) + CHR(10)
      oHmgApp():APP149 += 'div {position:absolute}' + CHR(13) + CHR(10)
      oHmgApp():APP149 += '.line { }' + CHR(13) + CHR(10)
      oHmgApp():APP149 += '</style>' + CHR(13) + CHR(10)

      oHmgApp():APP149 += '<body>' + CHR(13) + CHR(10)

   ENDIF

   IF oHmgApp():APP151 == .T.
      aReport := PdfInit()
      pdfOpen( cOutputFileName , 200 , .t. )
   ENDIF

   If ValType ( xSkipProcedure ) = 'U'

      * If not workarea open, cancel report execution

      If Select() == 0
         Return
      EndIf

      nPreviousRecNo := RecNo()

   EndIf

   ***********************************************************************
   * Determine Print Parameters
   ***********************************************************************

   aTemp := __MVGET ( cReportName )

   aLayout      := aTemp [1]
   aHeader      := aTemp [2]
   aDetail      := aTemp [3]
   aFooter      := aTemp [4]
   aSummary   := aTemp [5]
   aGroupHeader   := aTemp [6]
   aGroupFooter   := aTemp [7]
   aMiscData   := aTemp [8]

   nGroupCount      := aMiscData [1]
   nHeadeHeight      := aMiscData [2]
   nDetailHeight      := aMiscData [3]
   nFooterHeight      := aMiscData [4]
   nSummaryHeight      := aMiscData [5]
   nGroupHeaderHeight   := aMiscData [6]
   nGroupFooterHeight   := aMiscData [7]
   xTemp         := aMiscData [8]
   xSkipProcedure      := aMiscData [9]
   xEOF         := aMiscData [10]

   nOrientation      := aLayout [1]
   nPaperSize      := aLayout [2]
   nPaperWidth      := aLayout [3]
   nPaperHeight      := aLayout [4]

   If ValType ( lPreview ) <> 'L'
      lPreview := .F.
   EndIf

   If ValType ( lSelect ) <> 'L'
      lSelect := .F.
   EndIf

   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      If lSelect == .T.
         cPrinter := GetPrinter()
      Else
         cPrinter := GetDefaultPrinter()
      EndIf

      If Empty (cPrinter)
         Return
      EndIf

   ENDIF

   ***********************************************************************
   * Select Printer
   ***********************************************************************

   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      IF lPreview == .T.

         If nPaperSize == PRINTER_PAPER_USER

            SELECT PRINTER cPrinter         ;
               TO lSuccess         ;
               ORIENTATION   nOrientation   ;
               PAPERSIZE   nPaperSize   ;
               PAPERWIDTH   nPaperWidth   ;
               PAPERLENGTH   nPaperHeight   ;
               PREVIEW

         Else

            SELECT PRINTER cPrinter         ;
               TO lSuccess         ;
               ORIENTATION   nOrientation   ;
               PAPERSIZE   nPaperSize   ;
               PREVIEW

         EndIf

      ELSE

         If nPaperSize == PRINTER_PAPER_USER

            SELECT PRINTER cPrinter         ;
               TO lSuccess         ;
               ORIENTATION   nOrientation   ;
               PAPERSIZE   nPaperSize   ;
               PAPERWIDTH   nPaperWidth   ;
               PAPERLENGTH   nPaperHeight

         Else

            SELECT PRINTER cPrinter         ;
               TO lSuccess         ;
               ORIENTATION   nOrientation   ;
               PAPERSIZE   nPaperSize

         EndIf

      ENDIF

   ENDIF

   ***********************************************************************
   * Determine Paper Dimensions in mm.
   ***********************************************************************

   If npaperSize >=1 .and. nPaperSize <= 18

/*
      aPaper [ PRINTER_PAPER_LETTER          ] := { 215.9   , 279.4  }
      aPaper [ PRINTER_PAPER_LETTERSMALL     ] := { 215.9   , 279.4  }
      aPaper [ PRINTER_PAPER_TABLOID         ] := { 279.4   , 431.8  }
      aPaper [ PRINTER_PAPER_LEDGER          ] := { 431.8   , 279.4  }
      aPaper [ PRINTER_PAPER_LEGAL           ] := { 215.9   , 355.6  }
      aPaper [ PRINTER_PAPER_STATEMENT       ] := { 139.7   , 215.9  }
      aPaper [ PRINTER_PAPER_EXECUTIVE       ] := { 184.15  , 266.7  }
      aPaper [ PRINTER_PAPER_A3              ] := { 297     , 420    }
      aPaper [ PRINTER_PAPER_A4              ] := { 210     , 297    }
      aPaper [ PRINTER_PAPER_A4SMALL         ] := { 210     , 297    }
      aPaper [ PRINTER_PAPER_A5              ] := { 148     , 210    }
      aPaper [ PRINTER_PAPER_B4              ] := { 250     , 354    }
      aPaper [ PRINTER_PAPER_B5              ] := { 182     , 257    }
      aPaper [ PRINTER_PAPER_FOLIO           ] := { 215.9   , 330.2  }
      aPaper [ PRINTER_PAPER_QUARTO          ] := { 215     , 275    }
      aPaper [ PRINTER_PAPER_10X14           ] := { 254     , 355.6  }
      aPaper [ PRINTER_PAPER_11X17           ] := { 279.4   , 431.8  }
      aPaper [ PRINTER_PAPER_NOTE            ] := { 215.9   , 279.4  }
*/

      aPaper [ 1 ] := { 215.9   , 279.4 }
      aPaper [ 2 ] := { 215.9   , 279.4 }
      aPaper [ 3 ] := { 279.4   , 431.8 }
      aPaper [ 4 ] := { 431.8   , 279.4 }
      aPaper [ 5 ] := { 215.9   , 355.6 }
      aPaper [ 6 ] := { 139.7   , 215.9 }
      aPaper [ 7 ] := { 184.15   , 266.7 }
      aPaper [ 8 ] := { 297   , 420   }
      aPaper [ 9 ] := { 210   , 297   }
      aPaper [ 10 ] := { 210   , 297   }
      aPaper [ 11 ] := { 148   , 210   }
      aPaper [ 12 ] := { 250   , 354   }
      aPaper [ 13 ] := { 182   , 257   }
      aPaper [ 14 ] := { 215.9   , 330.2   }
      aPaper [ 15 ] := { 215   , 275   }
      aPaper [ 16 ] := { 254   , 355.6   }
      aPaper [ 17 ] := { 279.4   , 431.8   }
      aPaper [ 18 ] := { 215.9   , 279.4 }


      If    nOrientation == PRINTER_ORIENT_PORTRAIT

         nPaperWidth   := aPaper [ nPaperSize ] [ 1 ]
         npaperHeight   := aPaper [ nPaperSize ] [ 2 ]

      ElseIf   nOrientation == PRINTER_ORIENT_LANDSCAPE

         nPaperWidth   := aPaper [ nPaperSize ] [ 2 ]
         npaperHeight   := aPaper [ nPaperSize ] [ 1 ]

      Else

         MsgHMGError('Report: Orientation Not Supported')

      EndIf

   Else

      MsgHMGError('Report: Paper Size Not Supported')

   EndIf


   IF oHmgApp():APP151 == .T.

      * PDF Paper Size

      If   nPaperSize == PRINTER_PAPER_LETTER

              cPdfPaperSize := "LETTER"

      ElseIf   nPaperSize == PRINTER_PAPER_LEGAL

              cPdfPaperSize := "LEGAL"

      ElseIf nPaperSize == PRINTER_PAPER_A4

         cPdfPaperSize := "A4"

      ElseIf nPaperSize == PRINTER_PAPER_TABLOID

         cPdfPaperSize := "LEDGER"

      ElseIf nPaperSize == PRINTER_PAPER_EXECUTIVE

         cPdfPaperSize := "EXECUTIVE"

      ElseIf nPaperSize == PRINTER_PAPER_A3

         cPdfPaperSize := "A3"

      ElseIf nPaperSize == PRINTER_PAPER_ENV_10

         cPdfPaperSize := "COM10"

      ElseIf nPaperSize == PRINTER_PAPER_B4

         cPdfPaperSize := "JIS B4"

      ElseIf nPaperSize == PRINTER_PAPER_B5

         cPdfPaperSize := "B5"

      ElseIf nPaperSize == PRINTER_PAPER_P32K

         cPdfPaperSize := "JPOST"

      ElseIf nPaperSize == PRINTER_PAPER_ENV_C5

         cPdfPaperSize := "C5"

      ElseIf nPaperSize == PRINTER_PAPER_ENV_DL

         cPdfPaperSize := "DL"

      ElseIf nPaperSize == PRINTER_PAPER_ENV_B5

         cPdfPaperSize := "B5"

      ElseIf nPaperSize == PRINTER_PAPER_ENV_MONARCH

         cPdfPaperSize := "MONARCH"

      Else

         MsgHMGError("Report: PDF Paper Size Not Supported")

      EndIf

      * PDF Orientation

      If    nOrientation == PRINTER_ORIENT_PORTRAIT

         cPdfOrientation := 'P'

      ElseIf   nOrientation == PRINTER_ORIENT_LANDSCAPE

         cPdfOrientation := 'L'

      Else

         MsgHMGError('Report: Orientation Not Supported')

      EndIf

   ENDIF

   ***********************************************************************
   * Calculate Bands
   ***********************************************************************

   nBandSpace      := nPaperHeight - nHeadeHeight - nFooterHeight

   nDetailBandsPerPage   := Int ( nBandSpace / nDetailHeight )

   ***********************************************************************
   * Print Document
   ***********************************************************************

   If nGroupCount > 0

      xGroupExpression := &(xTemp)

   EndIf

   oHmgApp():APP117 := 1

   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      START PRINTDOC

   ENDIF

   If ValType ( xSkipProcedure ) = 'U'
      Go Top
   EndIf

   xPreviousGroupExpression := ''
   lGroupStarted := .f.

   If ValType ( xSkipProcedure ) = 'U'
      lTempEof := Eof()
   Else
      lTempEof := Eval(xEof)
   EndIf

   Do While .Not. lTempEof

      IF oHmgApp():APP163 == .F.

         IF oHmgApp():APP151 == .T.

            pdfNewPage( cPdfPaperSize , cPdfOrientation, 6 )

         ELSE

            START PRINTPAGE

         ENDIF

         nCurrentOffset := 0

         _ProcessBand ( aHeader , 0 )

         nCurrentOffset := nHeadeHeight

         do while .t.

            If nGroupCount > 0

               If ( valtype (xPreviousGroupExpression) != valtype (xGroupExpression) ) .or. ( xPreviousGroupExpression <> xGroupExpression )

                  If lGroupStarted

                     _ProcessBand ( aGroupFooter , nCurrentOffset )
                     nCurrentOffset += nGroupFooterHeight

                  EndIf

                  _ProcessBand ( aGroupHeader , nCurrentOffset )
                  nCurrentOffset += nGroupHeaderHeight

                  xPreviousGroupExpression := xGroupExpression

                  lGroupStarted := .T.

               EndIf

            EndIf

            _ProcessBand ( aDetail , nCurrentOffset )

            nCurrentOffset += nDetailHeight

            If ValType ( xSkipProcedure ) = 'U'
               Skip
               lTempEof := Eof()
            Else
               Eval(xSkipProcedure)
               lTempEof := Eval(xEof)
            EndIf

            If lTempEof

               * If group footer defined, print it.

               If nGroupFooterHeight > 0

                  * If group footer don't fit in the current page, print page footer,
                  * start a new page and print header first

                  If nCurrentOffset + nGroupFooterHeight > nPaperHeight - nFooterHeight

                     nCurrentOffset := nPaperHeight - nFooterHeight
                     _ProcessBand ( aFooter , nCurrentOffset )

                     IF oHmgApp():APP151 == .F.

                        END PRINTPAGE
                        START PRINTPAGE

                     ELSE

                        pdfNewPage( cPdfPaperSize , cPdfOrientation, 6 )

                     ENDIF

                     oHmgApp():APP117++

                     nCurrentOffset := 0
                     _ProcessBand ( aHeader , 0 )
                     nCurrentOffset := nHeadeHeight

                  EndIf

                  _ProcessBand ( aGroupFooter , nCurrentOffset )
                  nCurrentOffset += nGroupFooterHeight

               EndIf

               * If Summary defined, print it.

               If HMG_LEN ( aSummary ) > 0

                  * If summary don't fit in the current page, print footer,
                  * start a new page and print header first

                  If nCurrentOffset + nSummaryHeight > nPaperHeight - nFooterHeight

                     nCurrentOffset := nPaperHeight - nFooterHeight
                     _ProcessBand ( aFooter , nCurrentOffset )

                     IF oHmgApp():APP151 == .F.

                        END PRINTPAGE
                        START PRINTPAGE

                     ELSE

                        pdfNewPage( cPdfPaperSize , cPdfOrientation, 6 )

                     ENDIF

                     oHmgApp():APP117++

                     nCurrentOffset := 0
                     _ProcessBand ( aHeader , 0 )
                     nCurrentOffset := nHeadeHeight

                  EndIf

                  _ProcessBand ( aSummary , nCurrentOffset )

                  Exit

               EndIf

               Exit

            EndIf

            If nGroupCount > 0

               xGroupExpression := &(xTemp)

            EndIf

            If nCurrentOffset + nDetailHeight > nPaperHeight - nFooterHeight

               Exit

            EndIf

         EndDo

         nCurrentOffset := nPaperHeight - nFooterHeight

         _ProcessBand ( aFooter , nCurrentOffset )

         IF oHmgApp():APP151 == .F.

            END PRINTPAGE

         ENDIF

         oHmgApp():APP117++

      ELSE

         nCurrentOffset := 0

         _ProcessBand ( aHeader , 0 )

         nCurrentOffset := nHeadeHeight

         do while .t.

            If nGroupCount > 0

               If xPreviousGroupExpression <> xGroupExpression

                  If lGroupStarted

                     _ProcessBand ( aGroupFooter , nCurrentOffset )
                     nCurrentOffset += nGroupFooterHeight

                  EndIf

                  _ProcessBand ( aGroupHeader , nCurrentOffset )
                  nCurrentOffset += nGroupHeaderHeight

                  xPreviousGroupExpression := xGroupExpression

                  lGroupStarted := .T.

               EndIf

            EndIf

            _ProcessBand ( aDetail , nCurrentOffset )

            nCurrentOffset += nDetailHeight

            If ValType ( xSkipProcedure ) = 'U'
               Skip
               lTempEof := Eof()
            Else
               Eval(xSkipProcedure)
               lTempEof := Eval(xEof)
            EndIf

            If lTempEof

               * If group footer defined, print it.

               If nGroupFooterHeight > 0

                  _ProcessBand ( aGroupFooter , nCurrentOffset )
                  nCurrentOffset += nGroupFooterHeight

               EndIf

               * If Summary defined, print it.

               If HMG_LEN ( aSummary ) > 0
                  _ProcessBand ( aSummary , nCurrentOffset )
                  nCurrentOffset += nSummaryHeight
               EndIf

               Exit

            EndIf

            If nGroupCount > 0
               xGroupExpression := &(xTemp)
            EndIf

         EndDo

         _ProcessBand ( aFooter , nCurrentOffset )

      ENDIF

   EndDo

   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      END PRINTDOC

   ELSEIF oHmgApp():APP151 == .T.

      pdfClose()

   ELSEIF oHmgApp():APP163 == .T.

      oHmgApp():APP149 += '</body>' + CHR(13) + CHR(10)
      oHmgApp():APP149 += '</html>' + CHR(13) + CHR(10)

      nOutfile := FCREATE( cOutputFileName , FC_NORMAL)

      FWRITE( nOutfile , oHmgApp():APP149 , HMG_LEN(oHmgApp():APP149) )

      FCLOSE(nOutfile)

   ENDIF

   If ValType ( xSkipProcedure ) = 'U'
      Go nPreviousRecNo
   EndIf

Return

*.............................................................................*
Procedure _ProcessBand ( aBand  , nOffset )
*.............................................................................*
Local i

   For i := 1 To HMG_LEN ( aBand )

      _PrintObject ( aBand [i] , nOffset )

   Next i

Return

*.............................................................................*
Procedure _PrintObject ( aObject , nOffset )
*.............................................................................*


   If   aObject [1] == 'TEXT'

      _PrintText( aObject , nOffset )

   ElseIf aObject [1] == 'IMAGE'

      _PrintImage( aObject , nOffset )

   ElseIf aObject [1] == 'LINE'

      _PrintLine( aObject , nOffset )

   ElseIf aObject [1] == 'RECTANGLE'

      _PrintRectangle( aObject , nOffset )

   EndIf


Return

*-----------------------------------------------------------------------------*
Procedure _PrintText( aObject , nOffset )
*-----------------------------------------------------------------------------*

Local cValue      := aObject [ 2]
Local nRow      := aObject [ 3]
Local nCol      := aObject [ 4]
Local nWidth      := aObject [ 5]
Local nHeight      := aObject [ 6]
Local cFontname      := aObject [ 7]
Local nFontSize      := aObject [ 8]
Local lFontBold      := aObject [ 9]
Local lFontItalic   := aObject [10]
Local lFontUnderLine   := aObject [11]
Local lFOntStrikeout   := aObject [12]
Local aFontColor   := aObject [13]
Local lAlignment_1    := aObject [14]
Local lAlignment_2    := aObject [15]
Local cAlignment   := ''
Local nFontStyle   := 0
Local nTextRowFix   := 5
Local cHtmlAlignment


   cValue := &cValue


   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      If   lAlignment_1 == .F. .and.  lAlignment_2 == .T.

         cAlignment   := 'CENTER'

      ElseIf   lAlignment_1 == .T. .and.  lAlignment_2 == .F.

         cAlignment   := 'RIGHT'

      ElseIf   lAlignment_1 == .F. .and.  lAlignment_2 == .F.

         cAlignment   := ''

      EndIf

      _HMG_PRINTER_H_MULTILINE_PRINT ( oHmgApp():APP374 , nRow  + nOffset , nCol , nRow + nHeight  + nOffset , nCol + nWidth , cFontName , nFontSize , aFontColor[1] , aFontColor[2] , aFontColor[3] , cValue , lFontBold , lFontItalic , lFontUnderline , lFontStrikeout , .T. , .T. , .T. , cAlignment )

   ELSEIF oHmgApp():APP163 == .T.

      if   ValType (cValue) == "N"

         cValue := ALLTRIM(STR(cValue))

      Elseif   ValType (cValue) == "D"

         cValue := dtoc (cValue)

      Elseif   ValType (cValue) == "L"

         cValue := if ( cValue == .T. , oHmgApp():APP371 [24] , oHmgApp():APP371 [25] )

      EndIf

      If   lAlignment_1 == .F. .and.  lAlignment_2 == .T.

         cHtmlAlignment   := 'center'

      ElseIf   lAlignment_1 == .T. .and.  lAlignment_2 == .F.

         cHtmlAlignment   := 'RIGHT'

      ElseIf   lAlignment_1 == .F. .and.  lAlignment_2 == .F.

         cHtmlAlignment   := 'LEFT'

      EndIf

      oHmgApp():APP149 += '<div style=position:absolute;LEFT:' + ALLTRIM(STR(nCol)) +  'mm;top:' +  ALLTRIM(STR(nRow+nOffset)) + 'mm;width:' +  ALLTRIM(STR(nWidth)) + 'mm;font-size:' + ALLTRIM(STR(nFontSize)) + 'pt;font-family:"' +  cFontname + '";text-align:' + cHtmlAlignment + ';font-weight:' + if(lFontBold,'bold','normal') + ';font-style:' + if(lFontItalic,'italic','normal') + ';text-decoration:' + if(lFontUnderLine,'underline','none') + ';color:rgb(' + ALLTRIM(STR(aFontColor[1])) + ',' + ALLTRIM(STR(aFontColor[2])) + ',' +  ALLTRIM(STR(aFontColor[3])) + ');>' + cValue + '</div>' + CHR(13) + CHR(10)

   ELSEIF oHmgApp():APP151 == .T.

      if   ValType (cValue) == "N"

         cValue := ALLTRIM(STR(cValue))

      Elseif   ValType (cValue) == "D"

         cValue := dtoc (cValue)

      Elseif   ValType (cValue) == "L"

         cValue := if ( cValue == .T. , oHmgApp():APP371 [24] , oHmgApp():APP371 [25] )

      EndIf

      If   lFontBold == .f. .and. lFontItalic == .f.

         nFontStyle := 0

      ElseIf   lFontBold == .t. .and. lFontItalic == .f.

         nFontStyle := 1

      ElseIf   lFontBold == .f. .and. lFontItalic == .t.

         nFontStyle := 2

      ElseIf   lFontBold == .t. .and. lFontItalic == .t.

         nFontStyle := 3

      EndIf

      pdfSetFont( cFontname , nFontStyle , nFontSize )

      If   lAlignment_1 == .F. .and.  lAlignment_2 == .T. // Center

         If lFontUnderLine

            pdfAtSay ( cValue + CHR(254) , nRow + nOffset + nTextRowFix , nCol + ( nWidth - ( pdfTextWidth( cValue ) * 25.4 ) ) / 2  , 'M' )

         Else

            pdfAtSay ( CHR(253) + CHR(aFontColor[1]) + CHR(aFontColor[2]) + CHR(aFontColor[3]) + cValue , nRow + nOffset + nTextRowFix , nCol + ( nWidth - ( pdfTextWidth( cValue ) * 25.4 ) ) / 2  , 'M' )

         EndIf

      ElseIf   lAlignment_1 == .T. .and.  lAlignment_2 == .F. // RIGHT

         If lFontUnderLine

            pdfAtSay ( cValue + CHR(254) , nRow + nOffset + nTextRowFix , nCol + nWidth - pdfTextWidth( cValue ) * 25.4 , 'M' )

         Else

            pdfAtSay ( CHR(253) + CHR(aFontColor[1]) + CHR(aFontColor[2]) + CHR(aFontColor[3]) + cValue , nRow + nOffset + nTextRowFix , nCol + nWidth - pdfTextWidth( cValue ) * 25.4 , 'M' )

         EndIf

      ElseIf   lAlignment_1 == .F. .and.  lAlignment_2 == .F. // LEFT

         If lFontUnderLine

            pdfAtSay ( cValue + CHR(254) , nRow + nOffset + nTextRowFix , nCol , 'M' )

         Else

            pdfAtSay ( CHR(253) + CHR(aFontColor[1]) + CHR(aFontColor[2]) + CHR(aFontColor[3]) + cValue , nRow + nOffset + nTextRowFix , nCol , 'M' )

         EndIf

      EndIf

   ENDIF

Return

*-----------------------------------------------------------------------------*
Procedure _PrintImage( aObject , nOffset )
*-----------------------------------------------------------------------------*
Local cValue      := aObject [ 2]
Local nRow      := aObject [ 3]
Local nCol      := aObject [ 4]
Local nWidth      := aObject [ 5]
Local nHeight      := aObject [ 6]
Local lStretch      := aObject [ 7]

   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      _HMG_PRINTER_H_IMAGE ( oHmgApp():APP374 , cValue , nRow + nOffset , nCol , nHeight , nWidth , .T. )

   ELSEIF oHmgApp():APP151 == .T.

      IF HMG_UPPER ( HB_URIGHT( cValue , 4 ) ) == '.JPG'

         pdfImage( cValue , nRow + nOffset , nCol , "M" , nHeight , nWidth )

      ELSE

         MsgHMGError("Report: Only JPG images allowed" )

      ENDIF

   ELSEIF oHmgApp():APP163 == .T.

      oHmgApp():APP149 += '<div style=position:absolute;LEFT:' + ALLTRIM(STR(nCol)) + 'mm;top:' + ALLTRIM(STR(nRow+nOffset))  + 'mm;> <img src="' + cValue + '" ' + 'width=' + ALLTRIM(STR(nWidth*3.85)) + 'mm height=' + ALLTRIM(STR(nHeight*3.85)) + 'mm/> </div>' + CHR(13) + CHR(10)

   ENDIF

Return

*-----------------------------------------------------------------------------*
Procedure _PrintLine( aObject , nOffset )
*-----------------------------------------------------------------------------*
Local nFromRow      := aObject [ 2]
Local nFromCol      := aObject [ 3]
Local nToRow      := aObject [ 4]
Local nToCol      := aObject [ 5]
Local nPenWidth      := aObject [ 6]
Local aPenColor      := aObject [ 7]

   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      _HMG_PRINTER_H_LINE ( oHmgApp():APP374 , nFromRow + nOffset , nFromCol , nToRow  + nOffset , nToCol , nPenWidth , aPenColor[1] , aPenColor[2] , aPenColor[3]  , .T. , .T. )

   ELSEIF oHmgApp():APP151 == .T.

      If nFromRow <> nToRow .and. nFromCol <> nToCol
         MsgHMGError('Report: Only horizontal and vertical lines are supported with PDF output')
      EndIf

      pdfBox( nFromRow + nOffset , nFromCol, nToRow + nOffset + nPenWidth , nToCol , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )

   ELSEIF oHmgApp():APP163 == .T.

      oHmgApp():APP149 += '<div style="LEFT:' + ALLTRIM(STR(nFromCol)) + 'mm;top:' +  ALLTRIM(STR(nFromRow+nOffset)) +  'mm;width:' +  ALLTRIM(STR(nToCol-nFromCol)) +  'mm;height:0mm;BORDER-STYLE:SOLID;BORDER-COLOR:' + 'rgb(' + ALLTRIM(STR(aPenColor[1])) + ',' + ALLTRIM(STR(aPenColor[2])) + ',' +  ALLTRIM(STR(aPenColor[3])) + ')' + ';BORDER-WIDTH:' + ALLTRIM(STR(nPenWidth)) + 'mm;BACKGROUND-COLOR:#FFFFFF;"><span class="line"></span></DIV>' + CHR(13) + CHR(10)

   ENDIF

Return

*-----------------------------------------------------------------------------*
Procedure _PrintRectangle( aObject , nOffset )
*-----------------------------------------------------------------------------*
Local nFromRow      := aObject [ 2]
Local nFromCol      := aObject [ 3]
Local nToRow      := aObject [ 4]
Local nToCol      := aObject [ 5]
Local nPenWidth      := aObject [ 6]
Local aPenColor      := aObject [ 7]


   IF oHmgApp():APP151 == .F. .AND. oHmgApp():APP163 == .F.

      _HMG_PRINTER_H_RECTANGLE ( oHmgApp():APP374 , nFromRow + nOffset , nFromCol , nToRow  + nOffset , nToCol , nPenWidth , aPenColor[1] , aPenColor[2] , aPenColor[3] , .T. , .T. )

   ELSEIF oHmgApp():APP151 == .T.

      pdfBox( nFromRow + nOffset , nFromCol, nFromRow + nOffset + nPenWidth , nToCol , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )
      pdfBox( nToRow + nOffset , nFromCol, nToRow + nOffset + nPenWidth , nToCol , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )
      pdfBox( nFromRow + nOffset , nFromCol, nToRow + nOffset , nFromCol + nPenWidth , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )
      pdfBox( nFromRow + nOffset , nToCol, nToRow + nOffset , nToCol + nPenWidth , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )

   ELSEIF oHmgApp():APP163 == .T.

      oHmgApp():APP149 += '<div style="LEFT:' + ALLTRIM(STR(nFromCol)) + 'mm;top:' +  ALLTRIM(STR(nFromRow+nOffset)) +  'mm;width:' +  ALLTRIM(STR(nToCol-nFromCol)) +  'mm;height:' + ALLTRIM(STR(nToRow-nFromRow)) + 'mm;BORDER-STYLE:SOLID;BORDER-COLOR:' + 'rgb(' + ALLTRIM(STR(aPenColor[1])) + ',' + ALLTRIM(STR(aPenColor[2])) + ',' +  ALLTRIM(STR(aPenColor[3])) + ')' + ';BORDER-WIDTH:' + ALLTRIM(STR(nPenWidth)) + 'mm;BACKGROUND-COLOR:#FFFFFF;"><span class="line"></span></DIV>' + CHR(13) + CHR(10)

   ENDIF

Return

* Line **********************************************************************

Procedure _BeginLine

   oHmgApp():APP110 := 0      // FromRow
   oHmgApp():APP111 := 0      // FromCol
   oHmgApp():APP112 := 0      // ToRow
   oHmgApp():APP113 := 0      // ToCol
   oHmgApp():APP114 := 1      // PenWidth
   oHmgApp():APP115 := { 0 , 0 , 0 }   // PenColor

Return

Procedure _EndLine

Local aLine

   aLine := {           ;
      'LINE'         , ;
      oHmgApp():APP110   , ;
      oHmgApp():APP111   , ;
      oHmgApp():APP112   , ;
      oHmgApp():APP113   , ;
      oHmgApp():APP114   , ;
      oHmgApp():APP115     ;
      }

   If   oHmgApp():APP161 == 'HEADER'

           aadd (    oHmgApp():APP160 , aLine )

   ElseIf   oHmgApp():APP161 == 'DETAIL'

           aadd ( oHmgApp():APP158 , aLine )

   ElseIf   oHmgApp():APP161 == 'FOOTER'

           aadd ( oHmgApp():APP157 , aLine )

   ElseIf   oHmgApp():APP161 == 'SUMMARY'

           aadd ( oHmgApp():APP126 , aLine )

   ElseIf   oHmgApp():APP161 == 'GROUPHEADER'

           aadd ( oHmgApp():APP121 , aLine )

   ElseIf   oHmgApp():APP161 == 'GROUPFOOTER'

           aadd ( oHmgApp():APP122 , aLine )

   EndIf

Return

* Image **********************************************************************

Procedure _BeginImage

   oHmgApp():APP434 := ''   // Value
   oHmgApp():APP431 := 0    // Row
   oHmgApp():APP432 := 0    // Col
   oHmgApp():APP420 := 0    // Width
   oHmgApp():APP421 := 0    // Height
   oHmgApp():APP411 := .F.  // Stretch

Return

Procedure _EndImage

Local aImage

   aImage := {           ;
      'IMAGE'         , ;
      oHmgApp():APP434   , ;
      oHmgApp():APP431   , ;
      oHmgApp():APP432   , ;
      oHmgApp():APP420   , ;
      oHmgApp():APP421   , ;
      oHmgApp():APP411     ;
      }

   If   oHmgApp():APP161 == 'HEADER'

           aadd (    oHmgApp():APP160 , aImage )

   ElseIf   oHmgApp():APP161 == 'DETAIL'

           aadd ( oHmgApp():APP158 , aImage )

   ElseIf   oHmgApp():APP161 == 'FOOTER'

           aadd ( oHmgApp():APP157 , aImage )

   ElseIf   oHmgApp():APP161 == 'SUMMARY'

           aadd ( oHmgApp():APP126 , aImage )

   ElseIf   oHmgApp():APP161 == 'GROUPHEADER'

          // aadd ( oHmgApp():APP121 , aLine )    // REMOVE
           aadd ( oHmgApp():APP121 , aImage )      // ADD

   ElseIf   oHmgApp():APP161 == 'GROUPFOOTER'

         // aadd ( oHmgApp():APP122 , aLine )    // REMOVE
          aadd ( oHmgApp():APP122 , aImage )      // ADD

   EndIf

Return

* Rectangle **********************************************************************

Procedure _BeginRectangle

   oHmgApp():APP110 := 0      // FromRow
   oHmgApp():APP111 := 0      // FromCol
   oHmgApp():APP112 := 0      // ToRow
   oHmgApp():APP113 := 0      // ToCol
   oHmgApp():APP114 := 1      // PenWidth
   oHmgApp():APP115 := { 0 , 0 , 0 }   // PenColor

Return

Procedure _EndRectangle

Local aRectangle

   aRectangle := {           ;
      'RECTANGLE'      , ;
      oHmgApp():APP110   , ;
      oHmgApp():APP111   , ;
      oHmgApp():APP112   , ;
      oHmgApp():APP113   , ;
      oHmgApp():APP114   , ;
      oHmgApp():APP115     ;
      }

   If   oHmgApp():APP161 == 'HEADER'

           aadd (    oHmgApp():APP160 , aRectangle )

   ElseIf   oHmgApp():APP161 == 'DETAIL'

           aadd ( oHmgApp():APP158 , aRectangle )

   ElseIf   oHmgApp():APP161 == 'FOOTER'

           aadd ( oHmgApp():APP157 , aRectangle )

   ElseIf   oHmgApp():APP161 == 'SUMMARY'

           aadd ( oHmgApp():APP126 , aRectangle )

   ElseIf   oHmgApp():APP161 == 'GROUPHEADER'

          // aadd ( oHmgApp():APP121 , aLine )      // REMOVE
           aadd ( oHmgApp():APP121 , aRectangle )    // ADD

   ElseIf   oHmgApp():APP161 == 'GROUPFOOTER'

         // aadd ( oHmgApp():APP122 , aLine )      // REMOVE
          aadd ( oHmgApp():APP122 , aRectangle )    // ADD

   EndIf

Return

*..............................................................................
Procedure _BeginGroup()
*..............................................................................

   oHmgApp():APP161 := 'GROUP'

   oHmgApp():APP120++

Return

*..............................................................................
Procedure _EndGroup()
*..............................................................................

Return

*..............................................................................
Procedure _BeginGroupHeader()
*..............................................................................

   oHmgApp():APP161 := 'GROUPHEADER'

Return

*..............................................................................
Procedure _EndGroupHeader()
*..............................................................................

Return

*..............................................................................
Procedure _BeginGroupFooter()
*..............................................................................

   oHmgApp():APP161 := 'GROUPFOOTER'

Return

*..............................................................................
Procedure _EndGroupFooter()
*..............................................................................

Return

*..............................................................................
Function _dbSum( cField )
*..............................................................................
Local nVar

   if type ( cField ) == 'N'

      SUM &(cField) TO nVar

   Else

      nVar := 0

   EndIf

Return nVar


Procedure _BeginData()
Return

Procedure _EndData()
Return
