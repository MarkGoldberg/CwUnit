
  MEMBER('ExampleTest.clw')
  
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  
  MAP
Test:AllPointers    PROCEDURE(INT_PTR _SELF, INT_PTR  lpTestCase)  !<-- alternate prototype
  END

TestFixture CLASS(CwUnit_ctTestFixture)
NotRun         PROCEDURE(*CwUnit_ctResult Test)
Pass           PROCEDURE(*CwUnit_ctResult Test)
Ignore         PROCEDURE(*CwUnit_ctResult Test)
Fail           PROCEDURE(*CwUnit_ctResult Test)
Inconclusive   PROCEDURE(*CwUnit_ctResult Test)
Running        PROCEDURE(*CwUnit_ctResult Test)
IsTrue         PROCEDURE(*CwUnit_ctResult Test)
            END


AddTests_TestResultTypes   PROCEDURE(*CwUnit_ctTestSuite TestSuite)
_SELF  INT_PTR(0)
  CODE
  TestFixture.Init(TestSuite,'TestResults - ABNORMAL:OK TO SEE FAILURE')

  TestFixture.AddTest('NotRun'      , ADDRESS(TestFixture.NotRun)         )
  TestFixture.AddTest('Pass'        , ADDRESS(TestFixture.Pass)           )
  TestFixture.AddTest('Fail'        , ADDRESS(TestFixture.Fail)           )
  TestFixture.AddTest('Ignore'      , ADDRESS(TestFixture.Ignore)         )
  TestFixture.AddTest('Inconclusive', ADDRESS(TestFixture.Inconclusive)   )
  TestFixture.AddTest('Running'     , ADDRESS(TestFixture.Running)        )  
  
  TestFixture.AddTest('IsTrue(1)'   , ADDRESS(TestFixture.IsTrue)      , 1)
  TestFixture.AddTest('IsTrue(0)'   , ADDRESS(TestFixture.IsTrue)      , 0)
  TestFixture.AddTest('IsTrue(2)'   , ADDRESS(TestFixture.IsTrue)      , 2)

  TestSuite.AddTest('TestRestults','AllPointers' , _SELF, ADDRESS(Test:AllPointers)    )   !Doesn't *Have* to be a method, not recommended 

!Test:AllPointers This Test has an ALTERNATE Prototype, but it still works.
TEST:AllPointers     PROCEDURE(INT_PTR _SELF, INT_PTR lpTestCase)
Test  &CwUnit_ctResult
   CODE
   Test &= (lpTestCase)   
   Test.SetStatus( Status:Pass )

TestFixture.NotRun         PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.SetStatus( Status:NotRun )
   
TestFixture.Pass           PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.SetStatus( Status:Pass )
   
TestFixture.Ignore         PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.SetStatus( Status:Ignore )
   
TestFixture.Fail           PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.SetStatus( Status:Fail )
   
TestFixture.Inconclusive   PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.SetStatus( Status:Inconclusive )
   
TestFixture.Running        PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.SetStatus( Status:Running )

TestFixture.IsTrue         PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.IsTrue( Test.Data1 )

