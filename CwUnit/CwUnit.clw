
   PROGRAM

!Region Notices 
! ================================================================================
! Program: CwUnit - Clarion for Windows Unit Test Runner
! Created: March, 1st, 2014 by Mark Goldberg
! ================================================================================


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

 	