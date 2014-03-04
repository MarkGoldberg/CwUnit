 MEMBER()

 MAP
 	MODULE('API')
     OutputDebugSTRING(*CSTRING Message),PASCAL,RAW,NAME('OutputDebugStringA')
 	END
 END
 INCLUDE('ctOutputDebugString.inc'),ONCE
 
 	
ctOutputDebugString.ODS                 PROCEDURE(STRING Msg) 	
sz &CSTRING
	CODE
	sz &= NEW CSTRING( SIZE(Msg)+1 )
	sz  =                   Msg
	OutputDebugSTRING(sz)
	DISPOSE(sz)
 
 !Region ILog Mirror Methods
 
ctOutputDebugString.Start	             PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	IF LEN(CLIP(Info))
	   SELF.Prefix = Info & ': '
	END
	RETURN 0
	
ctOutputDebugString.Finish	             PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN 0
	
ctOutputDebugString.Add                 PROCEDURE(STRING ToAdd)
   !This method is virtual, so that the message can be altered (ex: prepend a prefix)
	CODE
	SELF.ODS(SELF.Prefix & ToAdd) 

ctOutputDebugString.ClearLog            PROCEDURE()
 	CODE
 	SELF.ODS('DBGVIEWCLEAR')  !Magic String for DbgView and DebugView++

 !EndRegion ILog	rror Methods
	
 !Region ILog 
 
ctOutputDebugString.ILog.Start   	    PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN SELF.Start(Info)
	
ctOutputDebugString.ILog.Finish	       PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN SELF.Finish(Info)
	
ctOutputDebugString.ILog.Add            PROCEDURE(STRING ToAdd)
	CODE
	SELF.Add(ToAdd)

ctOutputDebugString.ILog.ClearLog       PROCEDURE()
 	CODE
 	SELF.ClearLog()

 !EndRegion ILog