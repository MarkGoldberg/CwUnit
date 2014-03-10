
  PROGRAM
! ================================================================================
! Program: ExampleTest - Example CwUnit Unit Test DLL
! Created: March, 3rd, 2014 by Monolith Custom Computing, All rights reserved.
! ================================================================================
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


	
	
