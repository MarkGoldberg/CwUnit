
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
  INCLUDE('ctResultSets.inc'),ONCE

!=====================================
ctResultSets.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.Q     &= NEW qtResultSets
  SELF.BaseQ &= SELF.Q
  SELF.NextID = 1
  
!=====================================
ctResultSets.DESTRUCT                       PROCEDURE()
  CODE


!=====================================
ctResultSets.Del                            PROCEDURE!,DERIVED
  CODE
  DISPOSE(SELF.Q.Started)
  DISPOSE(SELF.Q.Finished)
 !DISPOSE(SELF.Q.DLL_Info) !TBD: Injected vs. New'd 
  PARENT.Del()
!=====================================
ctResultSets.Description                    PROCEDURE()!,STRING,DERIVED
  CODE
  RETURN 'ctResultSets'
	
!=====================================
ctResultSets.Starting                       PROCEDURE(*ctFileHelper DLLFileHelper)

  CODE
  !SELF.GetByPtr( SELF.Records() )
  SELF.Q.SetID     			 = SELF.NextID
  SELF.NextID              += 1
  SELF.Q.Started           &= NEW ctDateTimeLong
  SELF.Q.Started.Now()
  SELF.Q.Finished          &= NEW ctDateTimeLong
  SELF.Q.DLLFileHelper     &= DLLFileHelper  !Consider doing a COPY (Injected vs. NEW)
 !SELF.Q.WorkDirectory      = CSTRING(FILE:MaxFilePath)
 
  SELF.Q.Status             = 0 !TODO: Status Enum
  ADD(SELF.Q)
  RETURN SELF.Q.SetID
	
!=====================================
ctResultSets.Finished                       PROCEDURE()
	CODE
	SELF.Q.Status = 1 !TODO: Status Enum
	SELF.Q.Finished.Now()
	PUT(SELF.Q)

