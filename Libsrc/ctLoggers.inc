	INCLUDE(      'iLog.int'),ONCE

ctLoggers CLASS,TYPE,MODULE('ctLoggers.clw'),LINK('ctLoggers.clw')
OutputLog                  &iLog
DebugLog                   &iLog
OutputLogFile              STRING(FILE:MaxFilePath)

!----------
!CONSTRUCT                  PROCEDURE()
!DESTRUCT                   PROCEDURE()
Init                       PROCEDURE(*iLog OutputLog, *iLog DebugLog)
Log                        PROCEDURE(BOOL Output, BOOL Debugging, STRING Message)
Log                        PROCEDURE(STRING Message)
DebugLog                   PROCEDURE(STRING Message)
OutputLog                  PROCEDURE(STRING Message)

       END

