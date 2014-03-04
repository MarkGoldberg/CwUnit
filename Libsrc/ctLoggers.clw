  MEMBER()
  MAP
  END
  INCLUDE('ctLoggers.inc'),ONCE

!!=====================================
!ctLoggers.CONSTRUCT                      PROCEDURE()
!  CODE
!
!!=====================================
!ctLoggers.DESTRUCT                       PROCEDURE()
!  CODE

ctLoggers.Init                       PROCEDURE(*iLog OutputLog, *iLog DebugLog)
	CODE
	SELF.OutputLog &= OutputLog
	SELF.DebugLog  &= DebugLog
	
!Region Logging Methods
ctLoggers.Log                        PROCEDURE(BOOL Output, BOOL Debugging, STRING Message)
	CODE
	IF Output     THEN SELF.OutputLog(Message) END
	IF Debugging  THEN SELF.DebugLog (Message) END
	

ctLoggers.Log                        PROCEDURE(STRING Message)
	CODE
	SELF.DebugLog (Message)
	SELF.OutputLog(Message)
   
ctLoggers.DebugLog                   PROCEDURE(STRING Message)   
	CODE
	IF NOT (SELF.DebugLog &= NULL)
	        SELF.DebugLog.Add(Message)
	END
   
ctLoggers.OutputLog                  PROCEDURE(STRING Message)   
	CODE
	IF NOT (SELF.OutputLog &= NULL)
			  SELF.OutputLog.Add(Message)
   END
!EndRegion Logging Methods


