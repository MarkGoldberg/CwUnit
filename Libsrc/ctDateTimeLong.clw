
 MEMBER

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
 INCLUDE('ctDateTimeLong.inc'),ONCE

!Region Static_DateTimeLong

Static_DateTimeLong.Zero                       PROCEDURE(      *gtDateTimeLong DT)
	CODE
   DT.Date = 0
   DT.Time = 0

Static_DateTimeLong.Now                        PROCEDURE(      *gtDateTimeLong DT)
	CODE
   DT.Date = TODAY()
   DT.Time = CLOCK()
	
Static_DateTimeLong.ToString                   PROCEDURE(CONST *gtDateTimeLong DT)!,STRING
	CODE
   RETURN FORMAT(DT.Date,@D1) &' @ '& FORMAT(DT.Time,@T4)

Static_DateTimeLong.NowAsString                PROCEDURE()!,STRING   
tmpDTL LIKE(gtDateTimeLong)
	CODE
	SELF.Now(tmpDTL)
	RETURN SELF.ToString(tmpDTL)


Static_DateTimeLong.AsSpan                     PROCEDURE(      *gtDateTimeLong outDTSpan, CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd)
	CODE
	outDTSpan.Date = inDTEnd.Date - inDTStart.Date
	outDTSpan.Time = inDTEnd.Time - inDTStart.Time
	IF outDTSpan.Time < 0
		outDTSpan.Time += TIME:Day
	   outDTSpan.Date -= 1 
	END
	
Static_DateTimeLong.SpanTicks                  PROCEDURE(                                 CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd)!,STRING
DTSpan LIKE(gtDateTimeLong)
	CODE
	SELF.AsSpan( DTSpan, inDTStart, inDTEnd)
	RETURN SELF.AsTicks(DTSpan)
	
Static_DateTimeLong.AsTicks                    PROCEDURE( CONST *gtDateTimeLong DT)!,STRING	
	CODE
	RETURN (DT.Date * TIME:Day) + DT.Time
	

Static_DateTimeLong.SpanToString               PROCEDURE(                                 CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd)!,STRING
DTSpan LIKE(gtDateTimeLong)
	CODE
	SELF.AsSpan( DTSpan, inDTStart, inDTEnd)
	RETURN SELF.ToString(DTSpan)
	
!EndRegion Static_DateTimeLong


  
 !Region ctDateTimeLong

ctDateTimeLong.Zero                            PROCEDURE()
	CODE   
   SELF.Zero(SELF.DT)
   
ctDateTimeLong.Now                             PROCEDURE()
	CODE
	SELF.Now(SELF.DT)

ctDateTimeLong.ToString                        PROCEDURE()!,STRING
	CODE
	RETURN SELF.ToString(SELF.DT)

ctDateTimeLong.NewNow                     PROCEDURE()!,*ctDateTimeLong
_SELF  &ctDateTimeLong
	CODE
	_SELF &= NEW ctDateTimeLong
	_SELF.Now()
	RETURN _SELF
	
ctDateTimeLong.NewZero                    PROCEDURE()!,*ctDateTimeLong
_SELF  &ctDateTimeLong
	CODE
	_SELF &= NEW ctDateTimeLong
	_SELF.Zero()
	RETURN _SELF

ctDateTimeLong.AsTicks                    PROCEDURE()!,STRING
	CODE
   RETURN SELF.AsTicks( SELF.DT )
	

!EndRegion ctDateTimeLong	
   
 
	