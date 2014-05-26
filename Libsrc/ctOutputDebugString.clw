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
 	MODULE('API')
     OutputDebugString(CONST *CSTRING Message),PASCAL,RAW,NAME('OutputDebugStringA')
 	END
 END
 INCLUDE('ctOutputDebugString.inc'),ONCE
 
 	
ctOutputDebugString.ODS                 PROCEDURE(STRING Msg) 	
sz &CSTRING
	CODE
	sz &= NEW CSTRING( SIZE(Msg)+1 )
	sz  =                   Msg
	OutputDebugString(sz)
	DISPOSE(sz)
 
 !Region ILog Mirror Methods
 
ctOutputDebugString.Start	             PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	IF LEN(CLIP(Info))
	   SELF.Prefix = Info & ': '
	END
	RETURN 0
	
ctOutputDebugString.Finish	             PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN 0
	
ctOutputDebugString.Add                 PROCEDURE(STRING ToAdd)
   !This method is virtual, so that the message can be altered (ex: prepend a prefix)
	CODE
	SELF.ODS(SELF.Prefix & ToAdd) 

ctOutputDebugString.ClearLog            PROCEDURE()
 	CODE
 	SELF.ODS('DBGVIEWCLEAR')  !Magic String for DbgView and DebugView++

 !EndRegion ILog	rror Methods
	
 !Region ILog 
 
ctOutputDebugString.ILog.Start   	    PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN SELF.Start(Info)
	
ctOutputDebugString.ILog.Finish	       PROCEDURE(STRING Info)!,LONG,PROC
	CODE
	RETURN SELF.Finish(Info)
	
ctOutputDebugString.ILog.Add            PROCEDURE(STRING ToAdd)
	CODE
	SELF.Add(ToAdd)

ctOutputDebugString.ILog.ClearLog       PROCEDURE()
 	CODE
 	SELF.ClearLog()

 !EndRegion ILog
