
   PROGRAM
! ================================================================================
! Program: CwUnit - Clarion for Windows Unit Test Runner
! Created: March, 1st, 2014 by Monolith Custom Computing, All rights reserved.
! ================================================================================

   MAP
   END
 
     INCLUDE('ctCwUnitRunner.inc'),ONCE
CwUnitRunner ctCwUnitRunner

	 INCLUDE('ctLoggers.inc'),ONCE
Loggers      ctLoggers	 

    INCLUDE('ctOutputDebugString.inc'),ONCE
ODS          ctOutputDebugString

    INCLUDE('ctAsciiLogger.inc'),ONCE
Log          ctAsciiLogger

  CODE  
  
  IF COMMAND('/?')
  	  CwUnitRunner.ShowUsage()		
  ELSE    
     Loggers.Init(Log.ILog, ODS.ILog)
  	  ODS.Start('CwUnit')
  	  ODS.ClearLog()  !<------------- TEMPORARY
  	  CwUnitRunner.Init(Loggers)
     CwUnitRunner.ReadSettings('CwUnit.Ini')   !currently uses ODS.iLog
     Log.Start( CwUnitRunner.Loggers.OutputLogFile )
     IF CwUnitRunner.ClearLog
     	  Log.ClearLog()
     END
     
     CwUnitRunner.Go()
     IF CwUnitRunner.Interactive
     	  MESSAGE('Interactive CwUnit Running is under Construction') !TODO: Interactive Runs
     END
     CwUnitRunner.Finished()
  END

 	