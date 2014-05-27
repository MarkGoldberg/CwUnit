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


