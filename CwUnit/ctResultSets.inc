
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

   INCLUDE(       'ctQueue.inc'),ONCE
   INCLUDE(    'ctTestDlls.inc'),ONCE  !for gtDLL_Info
   INCLUDE('ctDateTimeLong.inc'),ONCE   
   INCLUDE(  'ctFileHelper.inc'),ONCE

gtResultSets    GROUP,TYPE
SetID     			LONG 
Started           &ctDateTimeLong
Finished          &ctDateTimeLong
DLLFileHelper     &ctFileHelper  
!DLL_Info          &gtDLL_Info
!WorkDirectory     CSTRING(FILE:MaxFilePath)
Status            LONG  
					 END
					 
qtResultSets    QUEUE(gtResultSets),TYPE
					 END
			 
ctResultSets CLASS(ctQueue),TYPE,MODULE('ctResultSets.clw'),LINK('ctResultSets.clw')
Q                             &qtResultSets
NextID                        LIKE(gtResultSets.SetID)
!----------
CONSTRUCT                      PROCEDURE()
DESTRUCT                       PROCEDURE()
Del                            PROCEDURE,DERIVED
Description                    PROCEDURE(),STRING,DERIVED
Starting                       PROCEDURE(*ctFileHelper DLLFileHelper),LONG !Returns SetID
Finished                       PROCEDURE()
       END


