
  PROGRAM

! ================================================================================
! CwUnit Unit Test DLL
! Please add {include %CwUnit%\CwUnit.RED} to your .RED
! ================================================================================

OMIT('***')
 * Created with Clarion 9.1
 * User: Mark.Live
 * Date: 5/27/2014
 * Time: 9:29 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 ***


  INCLUDE('CwUnit_ctTestFixture.inc'),ONCE   !implies ctCwUnit.inc
  INCLUDE(         'ctOneResult.inc'),ONCE

  MAP
    GetICwUnit(INT_PTR UserData),*ICwUnit,NAME(ExportName:Get_ICwUnit)   

    MODULE('FromTemplate_1.clw') 
            FromTemplate_1:AddTests(*CwUnit_ctTestSuite TestSuite)  
    END  
  END



  INCLUDE('ctOutputDebugString.inc'),ONCE
ODS        ctOutputDebugString   

MyTestSuite      CLASS(CwUnit_ctTestSuite)
Setup               PROCEDURE(INT_PTR UserData),DERIVED
Teardown            PROCEDURE(),DERIVED
                 END

  CODE
  ODS.Add('ExampleTest - MainCode') !<-- never runs
  
  
GetICwUnit                     PROCEDURE(INT_PTR UserData)  !<-- Exported Procedure
   !UserData is for Future Use
   CODE            
                                        ODS.Add('ExampleTest GetICwUnit')
   RETURN MyTestSuite.GetICwUnit(UserData)


MyTestSuite.Setup                PROCEDURE(INT_PTR UserData)
   CODE
                                        ODS.Add('v ExampleTest MyTestSuite.Setup TestCount['& SELF.ICwUnit.GetTestCount() &'] UserData['& UserData &']')
   IF SELF.ICwUnit.GetTestCount() = 0                                       
      !v================================================= <=== ADD TESTS HERE
      FromTemplate_1:AddTests(SELF)
      !^================================================= <=== ADD TESTS HERE
   END      
                                        ODS.Add('^ ExampleTest MyTestSuite.Setup TestCount['& SELF.ICwUnit.GetTestCount() &']')
  
MyTestSuite.Teardown            PROCEDURE()!,DERIVED
   CODE
                                        ODS.Add('ExampleTest.MyTestSuite.Teardown')

   
   