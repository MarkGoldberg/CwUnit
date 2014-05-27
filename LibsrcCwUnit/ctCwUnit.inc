
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

  INCLUDE('ICwUnit.int'),ONCE
  INCLUDE('ctQueue.inc'),ONCE
  
CwUnit_qtTestMethod QUEUE(CwUnit_gtTestMethod),TYPE  !gtOneTest is declared in ICwUnit.int
                    END  
  
CwUnit_ctTestSuite  CLASS(ctQueue),TYPE,IMPLEMENTS(ICwUnit),MODULE('ctCwUnit.clw'),LINK('ctCwUnit.clw')
Tests               &CwUnit_qtTestMethod
CONSTRUCT           PROCEDURE
DESTRUCT            PROCEDURE
!Del                 PROCEDURE,DERIVED
Description         PROCEDURE(),STRING,DERIVED

Setup               PROCEDURE(INT_PTR UserData),VIRTUAL
TearDown            PROCEDURE(),VIRTUAL
GetICwUnit          PROCEDURE(INT_PTR UserData),*ICwUnit
AddTest		        PROCEDURE(STRING Category, STRING TestName, INT_PTR _SELF, INT_PTR ProcedureAddress, <? Data1>, <? Data2>)	
Find                PROCEDURE(STRING Category, STRING TestName),LONG,PROC !Returns ErrorCode()

			   END  

