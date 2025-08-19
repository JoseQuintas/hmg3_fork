/*
h_HmgFormClass
*/

#include "hbclass.ch"

CREATE CLASS _HmgFormClass

   VAR    Index                     INIT 0
   VAR    Name                      INIT ""
   VAR    Handle                    INIT 0
   VAR    IsActive                  INIT .F.
   VAR    Type                      INIT ""
   VAR    StopEventProcedure        INIT .T.
   VAR    IsDeleted                 INIT .T.
   VAR    ToolTipMenuHandle         INIT 0
   VAR    AutoRelease               INIT .F.
   VAR    GraphTasks                INIT {}
   VAR    VirtualHeight             INIT 0
   VAR    VirtualWidth              INIT 0
   VAR    NoShow                    INIT .F.
   VAR    NotifyIconName            INIT ""
   VAR    ParentHandle              INIT 0
   VAR    ReleaseProcedure          INIT ""
   VAR    InitProcedure             INIT ""
   VAR    TooltipHandle             INIT 0
   VAR    FormContextMenuHandle     INIT 0

   VAR    FORM075                   INIT ""
   VAR    FORM076                   INIT ""
   VAR    FORM077                   INIT ""
   VAR    FORM078                   INIT ""
   VAR    FORM079                   INIT Nil
   VAR    FORM080                   INIT ""
   VAR    FORM083                   INIT ""
   VAR    FORM084                   INIT ""
   VAR    FORM085                   INIT ""
   VAR    FORM086                   INIT ""
   VAR    FORM087                   INIT 0
   VAR    FORM088                   INIT 0
   VAR    FORM089                   INIT {}
   VAR    FORM090                   INIT {}
   VAR    FORM093                   INIT .F.
   VAR    FORM094                   INIT ""
   VAR    FORM095                   INIT ""
   VAR    FORM096                   INIT ""
   VAR    FORM097                   INIT ""
   VAR    FORM098                   INIT ""
   VAR    FORM099                   INIT ""
   VAR    FORM100                   INIT 0
   VAR    FORM101                   INIT 0
   VAR    FORM103                   INIT Nil
   VAR    FORM104                   INIT Nil
   VAR    FORM106                   INIT ""
   VAR    FORM107                   INIT 0
   VAR    FORM108                   INIT Nil
   VAR    FORM504                   INIT { Nil, Nil, Nil, Nil }
   VAR    FORM512                   INIT { Nil, Nil, Nil, Nil, Nil, Nil, Nil }

   ENDCLASS

FUNCTION FormByIndex( nIndex )

   RETURN oHmgApp():aFormList[ nIndex ]

FUNCTION FormByHandle( nHandle )

   RETURN oHmgApp():FormByBlock( { | e | e:Handle == nHandle } )

FUNCTION FormByName( cName )

   RETURN oHmgApp():FormByBlock( { | e | e:Name == cName } )

FUNCTION FormByBlock( bCode )

   RETURN oHmgApp():FormByBlock( bCode )
