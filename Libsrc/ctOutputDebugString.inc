
	INCLUDE('ILog.int'),ONCE
	
ctOutputDebugString CLASS,TYPE,IMPLEMENTS(ILog),MODULE('ctOutputDebugString.clw'),LINK('ctOutputDebugString.clw')
ODS                   PROCEDURE(STRING Msg)
Prefix                ANY
!v---- ILog Mirror Methods
Start	                PROCEDURE(STRING Info),LONG,PROC
Finish	             PROCEDURE(STRING Info),LONG,PROC
Add                   PROCEDURE(STRING ToAdd),VIRTUAL
ClearLog              PROCEDURE()
!^---- ILog Mirror Methods
                    END
      