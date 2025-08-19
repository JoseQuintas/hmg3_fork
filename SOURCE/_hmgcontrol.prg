/*
h_HmgControlClass

Copy from form, not used this momment
*/

#include "hbclass.ch"

CREATE CLASS _HmgControlClass

   VAR    Index                  INIT 0
   VAR    Type                   INIT ""
   VAR    Name                   INIT ""
   VAR    Handle                 INIT 0
   VAR    ParentFormHandle       INIT 0
   VAR    IsDeleted              INIT .F.
   VAR    StopEventProcedure     INIT .F.
   VAR    CTRL005                INIT Nil
   VAR    CTRL006                INIT Nil
   VAR    CTRL007                INIT Nil
   VAR    CTRL008                INIT Nil
   VAR    CTRL009                INIT Nil
   VAR    CTRL010                INIT Nil
   VAR    CTRL011                INIT Nil
   VAR    CTRL012                INIT Nil
   VAR    CTRL014                INIT Nil
   VAR    CTRL015                INIT Nil
   VAR    CTRL016                INIT Nil
   VAR    CTRL017                INIT Nil
   VAR    CTRL018                INIT Nil
   VAR    CTRL019                INIT Nil
   VAR    CTRL020                INIT Nil
   VAR    CTRL021                INIT Nil
   VAR    CTRL022                INIT Nil
   VAR    CTRL023                INIT Nil
   VAR    CTRL024                INIT Nil
   VAR    CTRL025                INIT Nil
   VAR    CTRL026                INIT Nil
   VAR    CTRL027                INIT Nil
   VAR    CTRL028                INIT Nil
   VAR    CTRL029                INIT Nil
   VAR    CTRL030                INIT Nil
   VAR    CTRL031                INIT Nil
   VAR    CTRL032                INIT Nil
   VAR    CTRL033                INIT Nil
   VAR    CTRL034                INIT Nil
   VAR    CTRL035                INIT Nil
   VAR    CTRL036                INIT Nil
   VAR    CTRL037                INIT Nil
   VAR    CTRL038                INIT Nil
   VAR    CTRL039                INIT Nil
   VAR    CTRL040                INIT Nil
   VAR    CTRL041                INIT { Nil, Nil, Nil }  // array --> { OnKeyControlEventProc, OnMouseControlEventProc, ToolTip_CustomDrawData }

   //METHOD AutoRelease( ... )        SETGET
   //METHOD ReleaseProcedure( ... )   SETGET
   //METHOD IsActive( ... )           SETGET
   //METHOD NotifyIconName( ... )     SETGET
   //METHOD GraphTasks( ... )         SETGET

   ENDCLASS

FUNCTION ControlByIndex( nIndex )

   RETURN oHmgApp():aControlList[ nIndex ]

FUNCTION ControlByHandle( nHandle )

   RETURN oHmgApp():ControlByBlock( { | e | ValType( e:Handle ) == "N" .AND. e:Handle == nHandle } )

FUNCTION ControlByBlock( bCode )

   RETURN oHmgApp():ControlByBlock( bCode )

