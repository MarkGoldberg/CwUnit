

ctQueue CLASS,TYPE,MODULE('ctQueue.clw'),LINK('ctQueue.clw')
BaseQ	    			&QUEUE

CONSTRUCT			PROCEDURE                     
DESTRUCT				PROCEDURE
_Dispose          PROCEDURE(),VIRTUAL                  
Description       PROCEDURE(),STRING,VIRTUAL
Free              PROCEDURE,VIRTUAL                
Del               PROCEDURE,VIRTUAL                
Put               PROCEDURE,VIRTUAL

Count             PROCEDURE(),LONG    !Alias of .Records
Records           PROCEDURE(),LONG    !Returns Records(Q)  !an interesting syntax:  RECORDS(MyQueueClass) works
Pointer           PROCEDURE(),LONG    !Returns Pointer(Q)  !an interesting syntax:  POINTER(MyQueueClass) works


GetRow            PROCEDURE(LONG xPointer),LONG,PROC !returns ErrorCode
GetFirstRow       PROCEDURE(),LONG,PROC !returns ErrorCode
GetNextRow        PROCEDURE(<*BOOL IsFirstTime>),LONG,PROC !returns ErrorCode
GetPrevRow        PROCEDURE(<*BOOL IsFirstTime>),LONG,PROC !returns ErrorCode
GetLastRow        PROCEDURE(),LONG,PROC !returns ErrorCode

CopyTo            PROCEDURE(*ctQueue DestQ , BOOL FreeDestFirst=TRUE) !Will call DestQ.Free() - which will call DestQ.Del()...
CopyTo            PROCEDURE(  *QUEUE DestQ , BOOL FreeDestFirst=TRUE) !will use RTL FREE(DestQ)
          END
   

!RTL Related to QUEUE: Add,Changes,Delete,Free, Get,Pointer, Position, Put, Records, Sort
!Consider methods, to allow for  Yada.Records() == RECORDS(Yada) as well as RECORDS(Ydaa.BaseQ) 



