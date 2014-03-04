
  MEMBER()
  MAP
  END
  INCLUDE('ctAsciiLogger.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE
 
  PRAGMA ('link (C%V%ASC%X%%L%.LIB)') !<-- so don't have to add Ascii Driver to .CWProj

LogFile	FILE,DRIVER('ASCII'),CREATE
Record    RECORD
Line         STRING(4096) !HACK: arbitrary limit of LogFile
		  END
		END
 
ctAsciiLogger.FormatLine            PROCEDURE(STRING Msg)!,STRING,VIRTUAL 
	CODE
	RETURN Msg

!Region iLog Mirror Methods	
 
ctAsciiLogger.Add                   PROCEDURE(STRING Msg)!,VIRTUAL
 	CODE
 	LogFile.Line = SELF.FormatLine(Msg)
 	ADD(LogFile) 
	
ctAsciiLogger.Finish	PROCEDURE(STRING Info)!,LONG,PROC	
	CODE
	CLOSE(LogFile)
	RETURN ERRORCODE()
 
ctAsciiLogger.Start	PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	LogFile{PROP:Name} = Info
	SELF.Started = TRUE
	LOOP
		OPEN(LogFile)
		CASE ERRORCODE()
		  OF NoError     ; BREAK
		  OF IsOpenErr   ; BREAK 
		  OF NoFileErr   ; CREATE(LogFile)
		                   IF ERRORCODE() THEN BREAK END
		END
	END
	RETURN ERRORCODE()

ctAsciiLogger.ClearLog   PROCEDURE()
	CODE
	IF SELF.Started 
	   EMPTY(LogFile)
	END

!EndRegion iLog Mirror Methods	
!Region ILog 
	
ctAsciiLogger.ILog.Start	PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN SELF.Start(Info)
	
ctAsciiLogger.ILog.Finish	PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN SELF.Finish(Info)
	
ctAsciiLogger.ILog.Add     PROCEDURE(STRING ToAdd)
	CODE
	SELF.Add(ToAdd)


ctAsciiLogger.ILog.ClearLog   PROCEDURE()
	CODE
	SELF.ClearLog()
	
!EndRegion ILog