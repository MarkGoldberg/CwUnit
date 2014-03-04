
  PROGRAM
! ================================================================================
! Program: ExampleTest - Example CwUnit Unit Test DLL
! Created: March, 3rd, 2014 by Monolith Custom Computing, All rights reserved.
! ================================================================================
  INCLUDE(   'ctCwUnit.inc'),ONCE  
  INCLUDE('ctOneResult.inc'),ONCE
  MAP
  	  GetICwUnit(INT_PTR UserData),*ICwUnit,NAME(ExportName:Get_ICwUnit)    !I Think I want to a pass a flag, inidicating the Purpose for the request [JustNames, ToRun, UnLoad]
     
     MODULE('TestResultTypes.clw')
     	  AddTests_TestResultTypes(*ctCwUnit CwUnit)
     END
  END


  INCLUDE('ctOutputDebugString.inc'),ONCE
ODS        ctOutputDebugString   

MyCwUnit        CLASS(ctCwUnit)
Setup               PROCEDURE(INT_PTR UserData),DERIVED
Teardown            PROCEDURE(),DERIVED
			        END
  CODE
  ODS.Add('ExampleTest - MainCode') !<-- never runs
  
  
GetICwUnit 	                   PROCEDURE(INT_PTR UserData)  !<-- Exported Procedure
   !UserData is for Future Use
	CODE	          
	                                     ODS.Add('ExampleTest GetICwUnit')
	RETURN MyCwUnit.GetICwUnit(UserData)


MyCwUnit.Setup                PROCEDURE(INT_PTR UserData)
	CODE
	                                     ODS.Add('v ExampleTest MyCwUnit.Setup TestCount['& SELF.ICwUnit.GetTestCount() &'] UserData['& UserData &']')
   IF SELF.ICwUnit.GetTestCount() = 0 	                                     
      !v================================================= <=== ADD TESTS HERE
      AddTests_TestResultTypes(SELF)
      !^================================================= <=== ADD TESTS HERE
   END      
	                                     ODS.Add('^ ExampleTest MyCwUnit.Setup TestCount['& SELF.ICwUnit.GetTestCount() &']')
  
MyCwUnit.Teardown            PROCEDURE()!,DERIVED
	CODE
	                                     ODS.Add('ExampleTest.MyCwUnit.Teardown')




!EndRegion Debugging Code  


	
	