
  MEMBER('ExampleTest.clw')
  MAP
  END

!=============== MODULE DATA ================

MyTests    CLASS(CwUnit_ctTestFixture)
!v-------- actual tests
PassesWhen_IsEqual                            PROCEDURE(*CwUnit_ctResult Test) 
FailsWhen_IsEqual_SHOULDFAIL                  PROCEDURE(*CwUnit_ctResult Test) 
           END


!=============== MODULE DATA ================ -end


TestPassesWhen:AddTests   PROCEDURE(*CwUnit_ctTestSuite TestSuite)
TestData INT_PTR(0) !omittable last argument of .AddTest
  CODE   
  MyTests.Init(TestSuite,'PassesWhen')

  MyTests.AddTest('PassesWhen_IsEqual' , ADDRESS(MyTests.PassesWhen_IsEqual) )
  
  !----------------------------------
  MyTests.Category = 'Abnormal Tests - Should FAIL'   !<-- replace Category set in .Init for remaining tests
  !----------------------------------
  MyTests.AddTest('FailsWhen_IsEqual_SHOULDFAIL'  , ADDRESS(MyTests.FailsWhen_IsEqual_SHOULDFAIL) )



!=============================== METHODS


MyTests.PassesWhen_IsEqual                            PROCEDURE(*CwUnit_ctResult Test) 
   CODE       
   Test.PassesWhen( 5, Is:EqualTo, 2 + 3)

MyTests.FailsWhen_IsEqual_SHOULDFAIL                  PROCEDURE(*CwUnit_ctResult Test) 
   CODE       
   Test.FailsWhen( 5, Is:EqualTo, 2 + 3)



