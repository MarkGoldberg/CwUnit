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
  INCLUDE('ctTimedResults.inc'),ONCE

!=====================================
ctTimedResults.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.Q     &= NEW qtTimedResult
  SELF.BaseQ &= SELF.Q

!=====================================
ctTimedResults.DESTRUCT                       PROCEDURE()
  CODE


!=====================================
ctTimedResults.Del                            PROCEDURE!,DERIVED
  CODE
  DISPOSE(SELF.Q.OneResult)
  DISPOSE(SELF.Q.Started)
  DISPOSE(SELF.Q.Finished)
  PARENT.Del()
!=====================================
ctTimedResults.Description                    PROCEDURE()!,STRING,DERIVED
  CODE
  RETURN 'ctTimedResults'
	
!=====================================
ctTimedResults.Starting                      PROCEDURE(LONG ResultSetID, ? Data1, ? Data2)
  CODE
  CLEAR(SELF.Q)
  SELF.Q.OneResult         &= NEW CwUnit_ctResult
  SELF.Q.OneResult.Data1        = Data1
  SELF.Q.OneResult.Data2        = Data2    

  SELF.Q.ResultSetID            = ResultSetID 
  SELF.Q.Started           &= NEW ctDateTimeLong !SELF.Q.Started.NewNow()
  SELF.Q.Started.Now()
  SELF.Q.Finished          &= NEW ctDateTimeLong !SELF.Q.Finished.NewZero()
  SELF.Q.Finished.Zero()
  ADD(SELF.Q)

!=====================================
ctTimedResults.Finished                       PROCEDURE()
  CODE
  SELF.Q.Finished.Now()
  PUT(SELF.Q)

