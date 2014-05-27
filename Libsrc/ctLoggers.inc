
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

