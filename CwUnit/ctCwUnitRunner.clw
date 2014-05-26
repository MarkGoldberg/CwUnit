  MEMBER()

!Region Notices 
! ================================================================================
! Notice : Copyright (C) 2014, Mark Goldberg
!          Distributed under LGPLv3 (http://www.gnu.org/licenses/lgpl.html)
!
!    This file is part of CwUnit (https://github.com/MarkGoldberg/CwUnit)
!
!    CwUnit is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    CwUnit is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with CwUnit.  If not, see <http://www.gnu.org/licenses/>.
! ================================================================================
!EndRegion Notices 

  MAP
  END
  INCLUDE('ctCwUnitRunner.inc'),ONCE

!Region Setup/TearDown
!=====================================
ctCwUnitRunner.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.TestDLLs &= NEW ctTestDLLs

!=====================================
ctCwUnitRunner.DESTRUCT                       PROCEDURE()
  CODE
  DISPOSE(SELF.TestDLLs)

!=====================================
ctCwUnitRunner.Init                       PROCEDURE(*ctLoggers Loggers)
	CODE
	SELF.Loggers &= Loggers
	SELF.TestDLLs.Init(Loggers)
!EndRegion Setup/TearDown

!=====================================
ctCwUnitRunner.Go          PROCEDURE()
  CODE
                                   		   	 SELF.Loggers.DebugLog('v ctCwUnitRunner.Go')
  SELF.TestDLLs.LoadAllTests()             ; SELF.Loggers.DebugLog('  ctCwUnitRunner.Go After .LoadAllTests, .AutoRun['& SELF.AutoRun &'] .Interactive['& SELF.Interactive &']')
  IF SELF.AutoRun OR NOT SELF.Interactive  ; SELF.Loggers.DebugLog('  ctCwUnitRunner.Go Pre .RunAllTests')
     SELF.TestDLLs.RunAllTests()
  END     
                                   			 SELF.Loggers.DebugLog('^ ctCwUnitRunner.Go')

!=====================================
ctCwUnitRunner.Finished                   PROCEDURE()  
  CODE
                                   		   	 SELF.Loggers.DebugLog('v ctCwUnitRunner.Finished')
  SELF.TestDLLs.UnLoadAllTests()           ; SELF.Loggers.DebugLog('^ ctCwUnitRunner.Finished')
  

!=====================================
ctCwUnitRunner.ShowUsage   PROCEDURE()
Usage  ANY
Delim  CSTRING('<13,10>')
   CODE
   !TODO: Support STDOut 
   Usage = 'CwUnit Usage'                                            & Delim & |
                                                                       Delim & |
           'CwUnit [/?] [/Run] [/NoUI] [/ToLog] [/ClearLog] TestDll [TestDllN]*' & Delim & |
                                                                       Delim & |
           '/?        - Show this usage'                             & Delim & |
           '/Run      - When Interactive, Run all tests at start up' & Delim & |
           '/NoUI     - NonInteractive'                              & Delim & |
           '/Log      - Send Results to this file'                   & Delim & |
           '/ClearLog - Clear Log at start'                          & Delim & |
           'TestDll   - FileName DLL to load and test'               & Delim & |
           'TellDllN  - Additional DLLs to load and test'            & Delim & |
           ''
   MESSAGE(Usage,'CwUnit Usage')
   
!Region Settings Methods   
!=====================================
ctCwUnitRunner.ReadSettings           PROCEDURE(STRING SettingsStore, BOOL UseCommandLine=TRUE)
	CODE
	SELF.SettingsStore = SettingsStore
	
   SELF.ReadSettingsPersisted(SELF.SettingsStore)
   IF UseCommandLine
  		SELF.ReadSettingsCommandLine()
 	END
 	
!=====================================
ctCwUnitRunner.Get                        PROCEDURE(STRING xSection, STRING xItem, STRING xDefault)!,STRING
	CODE
	RETURN GETINI(xSection, xItem, xDefault, SELF.SettingsStore)

!=====================================
ctCwUnitRunner.GetFlag                    PROCEDURE(STRING xSection, STRING xItem, BOOL   xDefault)!,BOOL
	CODE
	RETURN CHOOSE( SELF.Get(xSection, xItem, xDefault) = FALSE, FALSE, TRUE)
!=====================================
ctCwUnitRunner.Set                        PROCEDURE(STRING xSection, STRING xItem, STRING xNewValue)
	CODE
	PUTINI(xSection, xItem, xNewValue, SELF.SettingsStore)
!=====================================
ctCwUnitRunner.SetFlag                    PROCEDURE(STRING xSection, STRING xItem, BOOL   xNewValue)	
	CODE
	PUTINI(xSection, xItem, xNewValue, SELF.SettingsStore)

!=====================================
ctCwUnitRunner.ReadSettingsPersisted     PROCEDURE(STRING SettingsStore)
	CODE
   SELF.Interactive           = SELF.GetFlag('Core','Interactive',FALSE)
   SELF.AutoRun               = SELF.GetFlag('Core','AutoRun'    ,FALSE)
  !SELF.RunAll                = SELF.GetFlag('Core','RunAll'     ,TRUE )
   SELF.ClearLog              = SELF.GetFlag('Core','ClearLog'   ,FALSE)
  !SELF.DLLFile               = SELF.Get    ('Core','DLLFile'    ,'CwUnitTest.DLL')
   SELF.Loggers.OutputLogFile = SELF.Get    ('Core','LogFile'    ,'CwUnit.LOG')

!=====================================
ctCwUnitRunner.ReadSettingsCommandLine   PROCEDURE()
ArgCount   LONG(1)
Debugging  BOOL(TRUE)
Output     BOOL(FALSE) !<-- too early to turn on, as the logfile can be set here.
   CODE
   										SELF.Loggers.DebugLog('v -{47}Command Line Settings-{47}')
   IF COMMAND('/Run')
      SELF.AutoRun = TRUE
      ArgCount += 1
                                 SELF.Loggers.Log(Output, Debugging, '/Run Found')
   ELSE                         ;SELF.Loggers.Log(Output, Debugging, '/Run NOT Found') 
   END
   
   IF COMMAND('/NoUI')
      SELF.Interactive = FALSE
      ArgCount += 1
                                 SELF.Loggers.Log(Output, Debugging, '/NoUI Found')
   ELSE                         ;SELF.Loggers.Log(Output, Debugging, '/NoUI NOT Found') 
   END
   
   IF COMMAND('Log') <> ''
      SELF.Loggers.OutputLogFile = COMMAND('Log')
      ArgCount += 1
                                 SELF.Loggers.Log(Output, Debugging, 'Log Found['& COMMAND('Log') &']')
   ELSE                         ;SELF.Loggers.Log(Output, Debugging, 'Log NOT Found')         
   END

   IF COMMAND('/ClearLog') <> ''
      SELF.ClearLog = COMMAND('/ClearLog')
      ArgCount += 1
                                 SELF.Loggers.Log(Output, Debugging, 'ClearLog Found')
   ELSE                         ;SELF.Loggers.Log(Output, Debugging, 'ClearLog NOT Found')         
   END
                                 SELF.Loggers.DebugLog('ArgCount['& ArgCount &']')
   LOOP WHILE COMMAND( ArgCount )
      SELF.TestDLLs.Add( COMMAND( ArgCount ) )
                                 SELF.Loggers.Log(Output, Debugging, 'DLL Added['& COMMAND( ArgCount ) &']')
      ArgCount += 1
   END
   										SELF.Loggers.DebugLog('^ -{47}Command Line Settings-{47}')

!EndRegion Settings Methods
