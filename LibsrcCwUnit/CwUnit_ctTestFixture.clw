   MEMBER()
   INCLUDE('CwUnit_ctTestFixture.inc'),ONCE
   MAP   
   END

CwUnit_ctTestFixture.Init              PROCEDURE(*CwUnit_ctTestSuite TestSuite, STRING Category)
   CODE
   SELF.Category = Category
   SELF.TestSuite  &= TestSuite   

CwUnit_ctTestFixture.AddTest               PROCEDURE(STRING TestName, INT_PTR MethodAddress, <? Data1>, <? Data2>)
   CODE
   SELF.TestSuite.AddTest(SELF.Category, TestName, ADDRESS(SELF), MethodAddress,  Data1, Data2)   

CwUnit_ctTestFixture.AddCategoryAndTest    PROCEDURE(STRING Category, STRING TestName, INT_PTR MethodAddress, <? Data1>, <? Data2>)
   CODE
   SELF.TestSuite.AddTest(     Category, TestName, ADDRESS(SELF), MethodAddress,  Data1, Data2)


! CwUnit_ctTestFixture.RunTest             PROCEDURE(STRING TestName, INT_PTR MethodAddress, INT_PTR UserData2)
!   CODE
!   SELF.SetupTest()
!   SELF.Run             <----- how will I pass everything I want?
!   SELF.TearDownTest()

