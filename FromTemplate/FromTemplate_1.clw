
  MEMBER('FromTemplate')
  MAP
  END

!Region =============== MODULE DATA ================

MyTests    CLASS(CwUnit_ctTestFixture)
IsTrue         PROCEDURE(*CwUnit_ctResult Test)
           END

!EndRegion =============== MODULE DATA ================ 


FromTemplate_1:AddTests   PROCEDURE(*CwUnit_ctTestSuite TestSuite)
  CODE   
  MyTests.Init(MyTestSuite,'PassesWhen')

  MyTests.AddTest('IsTrue(1)'   , ADDRESS(MyTests.IsTrue)      , 1)  !<-- last argument is optional
  MyTests.AddTest('IsTrue(0)'   , ADDRESS(MyTests.IsTrue)      , 0)
  MyTests.AddTest('IsTrue(2)'   , ADDRESS(MyTests.IsTrue)      , 2)


!Region MyTests Methods
MyTests.IsTrue         PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.IsTrue( Test.Data1 )

!EndRegion MyTests Methods

