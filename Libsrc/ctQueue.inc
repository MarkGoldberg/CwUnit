
ctQueue CLASS,TYPE,MODULE('ctQueue.clw'),LINK('ctQueue.clw')
BaseQ	    			&QUEUE

CONSTRUCT			PROCEDURE                     
DESTRUCT				PROCEDURE
_Dispose          PROCEDURE(),VIRTUAL                  
Description       PROCEDURE(),STRING,VIRTUAL
Free              PROCEDURE,VIRTUAL                
Del               PROCEDURE,VIRTUAL                
Put               PROCEDURE,VIRTUAL
Records           PROCEDURE(),LONG               
Count             PROCEDURE(),LONG    !Alias for Records
GetByPtr          PROCEDURE(LONG xPointer),LONG,PROC !returns ErrorCode
NextByPtr         PROCEDURE(),LONG,PROC !returns ErrorCode
          END
   



