  PROGRAM

!Region Notices 
! ================================================================================
! Program: ExampleText - Example DLL to run by CwUnit - Clarion for Windows Unit Test Runner
! Created: March, 1st, 2014 by Mark Goldberg
! ================================================================================
!
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

  INCLUDE('CwUnit_ctTestFixture.inc'),ONCE   !implies ctCwUnit.inc
  INCLUDE(         'ctOneResult.inc'),ONCE
  MAP
  	  GetICwUnit(INT_PTR UserData),*ICwUnit,NAME(ExportName:Get_ICwUnit)    !I Think I want to a pass a flag, inidicating the Purpose for the request [JustNames, ToRun, UnLoad]
     
     MODULE('TestResultTypes.clw') ;  AddTests_TestResultTypes(*CwUnit_ctTestSuite TestSuite)  END
     MODULE('TestPassesWhen.clw')  ;  TestPassesWhen:AddTests (*CwUnit_ctTestSuite TestSuite)  END
     MODULE('TestStrings.clw')     ;  TestStrings:AddTests    (*CwUnit_ctTestSuite TestSuite)  END
  END


  INCLUDE('ctOutputDebugString.inc'),ONCE
ODS        ctOutputDebugString   

MyTestSuite        CLASS(CwUnit_ctTestSuite)
Setup               PROCEDURE(INT_PTR UserData),DERIVED
Teardown            PROCEDURE(),DERIVED
			        END
  CODE
  ODS.Add('ExampleTest - MainCode') !<-- never runs
  
  
GetICwUnit 	                   PROCEDURE(INT_PTR UserData)  !<-- Exported Procedure
   !UserData is for Future Use
	CODE	          
	                                     ODS.Add('ExampleTest GetICwUnit')
	RETURN MyTestSuite.GetICwUnit(UserData)


MyTestSuite.Setup                PROCEDURE(INT_PTR UserData)
	CODE
	                                     ODS.Add('v ExampleTest MyTestSuite.Setup TestCount['& SELF.ICwUnit.GetTestCount() &'] UserData['& UserData &']')
   IF SELF.ICwUnit.GetTestCount() = 0 	                                     
      !v================================================= <=== ADD TESTS HERE
      AddTests_TestResultTypes(SELF)
      TestPassesWhen:AddTests (SELF)
      TestStrings:AddTests    (SELF)
      !^================================================= <=== ADD TESTS HERE
   END      
	                                     ODS.Add('^ ExampleTest MyTestSuite.Setup TestCount['& SELF.ICwUnit.GetTestCount() &']')
  
MyTestSuite.Teardown            PROCEDURE()!,DERIVED
	CODE
	                                     ODS.Add('ExampleTest.MyTestSuite.Teardown')




!EndRegion Debugging Code  


	
	
