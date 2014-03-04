
	INCLUDE('ctTestDLLs.inc'),ONCE
	INCLUDE( 'ctLoggers.inc'),ONCE
	

CwUnitRunner:SkipCommandLine   EQUATE(FALSE)

ctCwUnitRunner CLASS,TYPE,MODULE('ctCwUnitRunner.clw'),LINK('ctCwUnitRunner.clw')
SettingsStore        		STRING(FILE:MaxFilePath)  !INI File 
AutoRun        				BOOL  !Only applies to Interactive
Interactive	   				BOOL
ClearLog                   BOOL

Loggers                    &ctLoggers !Injected
TestDLLs                   &ctTestDLLs
!----------

CONSTRUCT                  PROCEDURE()
DESTRUCT                   PROCEDURE()
Init                       PROCEDURE(*ctLoggers Loggers)
ShowUsage                  PROCEDURE()

Go                         PROCEDURE()
Finished                   PROCEDURE()

ReadSettings               PROCEDURE(STRING SettingsStore, BOOL UseCommandLine=TRUE)  
ReadSettingsPersisted      PROCEDURE(STRING SettingsStore)
ReadSettingsCommandLine    PROCEDURE()
Get                        PROCEDURE(STRING xSection, STRING xItem, STRING xDefault),STRING
GetFlag                    PROCEDURE(STRING xSection, STRING xItem, BOOL   xDefault),BOOL
Set                        PROCEDURE(STRING xSection, STRING xItem, STRING xNewValue)
SetFlag                    PROCEDURE(STRING xSection, STRING xItem, BOOL   xNewValue)
       END