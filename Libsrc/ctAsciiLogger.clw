
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