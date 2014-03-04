
  MEMBER('ExampleTest.clw')
  
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  
  MAP
Test:AllINT_PTRs    PROCEDURE(INT_PTR UserData1, INT_PTR  lpOneResult, INT_PTR UserData2)  !<-- alternate prototype

Test:NotRun         PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2) !<--- recommended prototype
Test:Pass           PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
Test:Ignore         PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
Test:Fail           PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
Test:Inconclusive   PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
Test:Running        PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
Test:IsTrue         PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
Test:Is             PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
  END

AddTests_TestResultTypes   PROCEDURE(*ctCwUnit CwUnit)
  CODE
  CwUnit.AddTest('TestRestuls','AllINT_PTRs'  , ADDRESS(Test:AllINT_PTRs) , 0) !, 0)
  
  CwUnit.AddTest('TestResults', 'NotRun'      , ADDRESS(Test:NotRun)      , 0) !, 0)
  CwUnit.AddTest('TestResults', 'Pass'        , ADDRESS(Test:Pass)        , 0) !, 0)
  CwUnit.AddTest('TestResults', 'Fail'        , ADDRESS(Test:Fail)        , 0) !, 0)
  CwUnit.AddTest('TestResults', 'Ignore'      , ADDRESS(Test:Ignore)      , 0) !, 0)
  CwUnit.AddTest('TestResults', 'Inconclusive', ADDRESS(Test:Inconclusive), 0) !, 0)
  CwUnit.AddTest('TestResults', 'Running'     , ADDRESS(Test:Running)     , 0) !, 0)
  
  CwUnit.AddTest('TestResults', 'IsTrue(1)'   , ADDRESS(Test:IsTrue)      , 0, 1)
  CwUnit.AddTest('TestResults', 'IsTrue(0)'   , ADDRESS(Test:IsTrue)      , 0, 0)
  CwUnit.AddTest('TestResults', 'IsTrue(2)'   , ADDRESS(Test:IsTrue)      , 0, 2)

  CwUnit.AddTest('TestResults', 'Is:IsTrue(1)'   , ADDRESS(Test:Is)      , 0, 1)
  CwUnit.AddTest('TestResults', 'Is:IsTrue(0)'   , ADDRESS(Test:Is)      , 0, 0)
  CwUnit.AddTest('TestResults', 'Is:IsTrue(2)'   , ADDRESS(Test:Is)      , 0, 2)


!Test:AllINT_PTRs This Test has an ALTERNATE Prototype, but it still works.
Test:AllINT_PTRs     PROCEDURE(INT_PTR UserData1, INT_PTR lpOneResult,  INT_PTR UserData2)
Result  &ctOneResult
   CODE
   Result &= (lpOneResult)   
   Result.Status = Status:Pass

Test:NotRun         PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Status = Status:NotRun 
   
Test:Pass           PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Status = Status:Pass    
   
Test:Ignore         PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Status = Status:Ignore 
   
Test:Fail           PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Status = Status:Fail  
   
Test:Inconclusive   PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Status = Status:Inconclusive 
   
Test:Running        PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Status = Status:Running      

Test:IsTrue         PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.IsTrue( UserData2 )

Test:Is          PROCEDURE(INT_PTR UserData1,  *ctOneResult Result,  INT_PTR UserData2)
   CODE
   Result.Is( UserData2, Op:IsTrue )
   
   