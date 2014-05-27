
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

 	 	INCLUDE('Time.equ'),ONCE
 	 	
gtDateTimeLong			GROUP,TYPE
Date								LONG
Time								LONG
								END
								

Static_DateTimeLong     CLASS(),TYPE,MODULE('ctDateTimeLong.CLW'),LINK('ctDateTimeLong.CLW')
Zero                       PROCEDURE(      *gtDateTimeLong DT)
Now                        PROCEDURE(      *gtDateTimeLong DT)
ToString                   PROCEDURE(CONST *gtDateTimeLong DT),STRING
NowAsString                PROCEDURE(),STRING

AsSpan                     PROCEDURE(      *gtDateTimeLong outDTSpan, CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd)
SpanToString               PROCEDURE(                                 CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd),STRING
SpanTicks                  PROCEDURE(                                 CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd),STRING
AsTicks                    PROCEDURE( CONST *gtDateTimeLong DT),STRING
								END


ctDateTimeLong          CLASS(Static_DateTimeLong),TYPE,MODULE('ctDateTimeLong.CLW'),LINK('ctDateTimeLong.CLW')
DT                         LIKE(gtDateTimeLong)
!-----
Zero                       PROCEDURE()
Now                        PROCEDURE()
ToString                   PROCEDURE(),STRING
NewNow                     PROCEDURE(),*ctDateTimeLong
NewZero                    PROCEDURE(),*ctDateTimeLong
AsTicks                    PROCEDURE(),STRING
								END

	
	