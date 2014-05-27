
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

  INCLUDE('ctCwUnit.inc'),ONCE
  MAP
  END

NoError EQUATE(0) !or do an INCLUDE('Errors.clw'),ONCE  
  
!Region CwUnit_ctTestSuite Methods  

CwUnit_ctTestSuite.GetICwUnit 	         PROCEDURE(INT_PTR UserData) !,*ICwUnit
	CODE
	SELF.Setup(UserData)
	RETURN SELF.ICwUnit
	
CwUnit_ctTestSuite.CONSTRUCT           PROCEDURE()
	CODE
	SELF.Tests   &= NEW CwUnit_qtTestMethod
    SELF.BaseQ   &= SELF.Tests
	SELF.Setup(0)

CwUnit_ctTestSuite.DESTRUCT            PROCEDURE()
	CODE
	SELF.TearDown()
	! IF NOT     SELF.Tests &= NULL
	!    FREE   (SELF.Tests) 
	!    DISPOSE(SELF.Tests)
	! END

! CwUnit_ctTestSuite.Del                 PROCEDURE!,DERIVED
!    CODE
!    CLEAR(SELF.Tests)
!    PARENT.Del()

CwUnit_ctTestSuite.Description         PROCEDURE()!,STRING,DERIVED   
   CODE
   RETURN 'CwUnit_ctTestSuite'
	
CwUnit_ctTestSuite.Setup               PROCEDURE(INT_PTR UserData)!,VIRTUAL
	CODE
	!Stub - should be derived
CwUnit_ctTestSuite.TearDown            PROCEDURE()!,VIRTUAL
	CODE
	!Stub - should be derived
	
CwUnit_ctTestSuite.AddTest		       PROCEDURE(STRING Category, STRING TestName, INT_PTR _SELF,  INT_PTR ProcedureAddress, <? Data1>, <? Data2>)  
	CODE
   CLEAR(SELF.Tests) !Important when using ANY
	SELF.Tests.Category         = Category
	SELF.Tests.TestName         = TestName
	SELF.Tests._SELF            = _SELF
	SELF.Tests.ProcedureAddress = ProcedureAddress
   SELF.Tests.Data1            = Data1
   SELF.Tests.Data2            = Data2
	ADD(SELF.Tests)


CwUnit_ctTestSuite.Find               PROCEDURE(STRING Category, STRING TestName)!,LONG,PROC !Returns ErrorCode()
	CODE
	SELF.Tests.Category = Category
	SELF.Tests.TestName = TestName
	ADD(SELF.Tests, SELF.Tests.Category, SELF.Tests.TestName)
	RETURN ERRORCODE()

!Region ICwUnit Methods  
  
CwUnit_ctTestSuite.ICwUnit.InterfaceType           PROCEDURE()!,STRING
	CODE
	RETURN 'Base'
	
CwUnit_ctTestSuite.ICwUnit.GetTestCount            PROCEDURE() 
	CODE
	RETURN RECORDS(SELF.Tests)

CwUnit_ctTestSuite.ICwUnit.GetTest                 PROCEDURE(LONG TestNum, *CwUnit_gtTestMethod outTestMethod)!,LONG Returns ErrorCode
RetError LONG,AUTO
	CODE
	GET(SELF.Tests, TestNum)
	RetError = ERRORCODE()
	IF RetError = NoError	
   	outTestMethod = SELF.Tests  !Queue Buffer as a Group
   END
   RETURN RetError


!EndRegion ICwUnit Methods  

!EndRegion CwUnit_ctTestSuite Methods  



