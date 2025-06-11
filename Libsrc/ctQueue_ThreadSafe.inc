!ABCIncludeFile

!Region Notices
! ======================================================================================
! (MIT License) as found on https://mit-license.org/ (with some CR/LF formatting added)
! ======================================================================================
!
! Copyright © 2023 <copyright holders>
! 
! Permission is hereby granted, free of charge, 
! to any person obtaining a copy of this software and associated documentation files (the “Software”), 
! to deal in the Software without restriction, including without limitation the rights to use, 
! copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
! and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
! 
! The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
! 
! THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
! THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
! IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
! WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
! OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
! ======================================================================================
!EndRegion Notices

   INCLUDE(       'CWSYNCHM.inc'),ONCE
   INCLUDE(        'ctQueue.inc'),ONCE
   INCLUDE('TypedProcedures.inc'),ONCE

TSQ:Replace EQUATE(TRUE)  !used in .CopyTo, means will FREE first
TSQ:Append  EQUATE(FALSE) !used in .CopyTo, means will NOT FREE first

!---------------------------------------------------------------
ctQueue_ThreadSafe CLASS,TYPE,MODULE('ctQueue_ThreadSafe.clw'),LINK('ctQueue_ThreadSafe.clw')
ThreadLock            &ICriticalSection,PROTECTED   
BaseQ                 &QUEUE!,PROTECTED ! This really should be protected, but I'm exposing it for .CopyTo's use
IsTracing             BOOL

!--------------------------------
CONSTRUCT             PROCEDURE()
DESTRUCT              PROCEDURE()

_Dispose              PROCEDURE(),VIRTUAL
Description           PROCEDURE(),STRING,VIRTUAL
SetBaseQ              PROCEDURE(*QUEUE xBaseQ)
Free                  PROCEDURE,VIRTUAL
Del                   PROCEDURE,VIRTUAL,PROTECTED   ! should ONLY be called by methods that have already aligned the Queue
Put                   PROCEDURE(STRING xQueueBuffer),PROTECTED,VIRTUAL 
Add                   PROCEDURE(STRING xQueueBuffer),VIRTUAL
SortedAdd             PROCEDURE(STRING xQueueBuffer, STRING xSortOrder),VIRTUAL

Count                 PROCEDURE(),LONG,VIRTUAL    !Alias of .Records
Records               PROCEDURE(),LONG,VIRTUAL    !Returns Records(Q)  !an interesting syntax:  RECORDS(MyQueueClass) works

GetRow                PROCEDURE( LONG xPointer               , *STRING xOutQueueBuffer),LONG,PROC !returns ErrorCode
GetFirstRow           PROCEDURE(                               *STRING xOutQueueBuffer),LONG,PROC !returns ErrorCode
GetNextRow            PROCEDURE(*LONG InPriorRow_OutCurrRow  , *STRING xOutQueueBuffer),LONG,PROC !returns ErrorCode
GetPrevRow            PROCEDURE(*LONG InPriorRow_OutCurrRow  , *STRING xOutQueueBuffer),LONG,PROC !returns ErrorCode
GetLastRow            PROCEDURE(                               *STRING xOutQueueBuffer),LONG,PROC !returns ErrorCode


!-------------
CopyTo                PROCEDURE(*QUEUE              xDestQ   , LONG xUserData=0, BOOL xFreeDestFirst=TRUE) !will use RTL FREE(DestQ)
CopyFrom              PROCEDURE(*QUEUE              xFromQ   , LONG xUserData=0, BOOL xFreeDestFirst=TRUE) !will use RTL FREE(QUEUE)

CopyTo                PROCEDURE(*ctQueue_ThreadSafe xDestTSQ , LONG xUserData=0, BOOL xFreeDestFirst=TRUE) !Will call DestQ.Free() - which will call DestQ.Del()...
CopyFrom              PROCEDURE(*ctQueue_ThreadSafe xFromTSQ , LONG xUserData=0, BOOL xFreeDestFirst=TRUE)

CopyQBuffer           PROCEDURE(*STRING xTo, STRING xFrom, LONG xUserData),VIRTUAL
!-------------


ToString              PROCEDURE(),STRING,VIRTUAL
Dump                  PROCEDURE(STRING xPrefix),VIRTUAL
DumpOneRow            PROCEDURE(STRING xPrefix),VIRTUAL

BufferSize            PROCEDURE(),LONG,VIRTUAL


!--------------------- 
!! ForEach !!  ftMethod_Long_QBuf     PROCEDURE(LONG   xUserData, STRING xQueueBuffer),TYPE
!! ForEach !!  ftMethod_String_QBuf   PROCEDURE(STRING xUserData, STRING xQueueBuffer),TYPE
!! ForEach !!  ftMethod_StarAny_QBuf  PROCEDURE(*?     xUserData, STRING xQueueBuffer),TYPE
!! ForEach !!  
!! ForEach !!  ForEach           PROCEDURE(ftProc_Long       xProc  , LONG   xUserData)
!! ForEach !!  ForEach           PROCEDURE(ftMethod_Long     xMethod, LONG   xUserData)
!! ForEach !!  
!! ForEach !!  ForEach           PROCEDURE(ftProc_String     xProc  , STRING xUserData)
!! ForEach !!  ForEach           PROCEDURE(ftMethod_String   xMethod, STRING xUserData)
!! ForEach !!  
!! ForEach !!  ForEach           PROCEDURE(ftProc_StarAny    xProc  , *?     xUserData)
!! ForEach !!  ForEach           PROCEDURE(ftMethod_StarAny  xMethod, *?     xUserData)
!---------------------
                    END
   

!RTL Related to QUEUE: Add,Changes,Delete,Free, Get,Pointer, Position, Put, Records, Sort
!Consider methods, to allow for  Yada.Records() == RECORDS(Yada) as well as RECORDS(Ydaa.BaseQ) 

!Possible Refactor:  .Get(N), .Next(N), .Previous(N) (or .Prev(N)) .First(), .Last()


