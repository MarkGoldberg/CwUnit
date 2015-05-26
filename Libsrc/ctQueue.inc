
!Region Notices 
! ================================================================================
! Notice : Copyright (C) 2014, Mark Goldberg
!          Distributed under LGPLv3 (http://www.gnu.org/licenses/lgpl.html)
!
!    This file is part of CwUnit (https://github.com/MarkGoldberg/CwUnit)
!
!    CwUnit is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    CwUnit is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with CwUnit.  If not, see <http://www.gnu.org/licenses/>.
! ================================================================================
!EndRegion Notices 

Copy:Replace EQUATE(TRUE)  !used in .CopyTo, means will FREE first
Copy:Append  EQUATE(FALSE) !used in .CopyTo, means will NOT FREE first

   INCLUDE('TypedProcedures.inc'),ONCE

gtPtrBuffer     GROUP,TYPE
Ptr               LONG !a POINTER(Q)
Buf               ANY  !to hold the buffer of a queue
                END   

QState:Preserve EQUATE(TRUE)            
QState:Alter    EQUATE(FALSE)

!---------------------------------------------------------------
ctQueue CLASS,TYPE,MODULE('ctQueue.clw'),LINK('ctQueue.clw')
BaseQ	    			&QUEUE
IsTracing         BOOL

CONSTRUCT		   PROCEDURE                     
DESTRUCT		      PROCEDURE
_Dispose          PROCEDURE(),VIRTUAL                  
Description       PROCEDURE(),STRING,VIRTUAL
Free              PROCEDURE,VIRTUAL                
Del               PROCEDURE,VIRTUAL                
Put               PROCEDURE,VIRTUAL
Add               PROCEDURE,VIRTUAL   !pretty meaningless, could add a sortOrder string...

Count             PROCEDURE(),LONG    !Alias of .Records
Records           PROCEDURE(),LONG    !Returns Records(Q)  !an interesting syntax:  RECORDS(MyQueueClass) works
Pointer           PROCEDURE(),LONG    !Returns Pointer(Q)  !an interesting syntax:  POINTER(MyQueueClass) works


GetRow            PROCEDURE(LONG xPointer),LONG,PROC !returns ErrorCode
GetFirstRow       PROCEDURE(),LONG,PROC !returns ErrorCode
GetNextRow        PROCEDURE(<*LONG InPriorRow_OutCurrRow>),LONG,PROC !returns ErrorCode
GetPrevRow        PROCEDURE(<*LONG InPriorRow_OutCurrRow>),LONG,PROC !returns ErrorCode
GetLastRow        PROCEDURE(),LONG,PROC !returns ErrorCode

CopyTo            PROCEDURE(*ctQueue DestQ , BOOL FreeDestFirst=TRUE) !Will call DestQ.Free() - which will call DestQ.Del()...
CopyTo            PROCEDURE(  *QUEUE DestQ , BOOL FreeDestFirst=TRUE) !will use RTL FREE(DestQ)

Dump              PROCEDURE(STRING xPrefix)
DumpOneRow        PROCEDURE(STRING xPrefix),VIRTUAL
!--------------------- 
ftMethod_Long     PROCEDURE(LONG   xUserData),TYPE
ftMethod_String   PROCEDURE(STRING xUserData),TYPE
ftMethod_StarAny  PROCEDURE(*?     xUserData),TYPE

ForEach           PROCEDURE(ftProc_Long       xProc  , LONG   xUserData, BOOL xPreserveState = QState:Preserve)
ForEach           PROCEDURE(ftMethod_Long     xMethod, LONG   xUserData, BOOL xPreserveState = QState:Preserve)

ForEach           PROCEDURE(ftProc_String     xProc  , STRING xUserData, BOOL xPreserveState = QState:Preserve)
ForEach           PROCEDURE(ftMethod_String   xMethod, STRING xUserData, BOOL xPreserveState = QState:Preserve)

ForEach           PROCEDURE(ftProc_StarAny    xProc  , *?     xUserData, BOOL xPreserveState = QState:Preserve)
ForEach           PROCEDURE(ftMethod_StarAny  xMethod, *?     xUserData, BOOL xPreserveState = QState:Preserve)
!---------------------


QState_Save        PROCEDURE(*gtPtrBuffer xgPtrBuffer)
QState_Restore     PROCEDURE(*gtPtrBuffer xgPtrBuffer)
          END
   

!RTL Related to QUEUE: Add,Changes,Delete,Free, Get,Pointer, Position, Put, Records, Sort
!Consider methods, to allow for  Yada.Records() == RECORDS(Yada) as well as RECORDS(Ydaa.BaseQ) 

!Possible Refactor:  .Get(N), .Next(N), .Previous(N) (or .Prev(N)) .First(), .Last()


