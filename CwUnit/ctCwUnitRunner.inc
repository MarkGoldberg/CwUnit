
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