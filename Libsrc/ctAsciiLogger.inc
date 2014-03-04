	INCLUDE('ILog.int'),ONCE
	
ctAsciiLogger CLASS,TYPE,IMPLEMENTS(ILog),MODULE('ctAsciiLogger.clw'),LINK('ctAsciiLogger.clw')
Started               BOOL
FormatLine            PROCEDURE(STRING Msg),STRING,VIRTUAL

!v---- ILog Mirror Methods
Start	                PROCEDURE(STRING Info),LONG,PROC
Finish	             PROCEDURE(STRING Info),LONG,PROC
Add                   PROCEDURE(STRING ToAdd),VIRTUAL
ClearLog              PROCEDURE()
!^---- ILog Mirror Methods
                    END
      