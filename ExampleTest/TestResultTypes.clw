
  MEMBER('ExampleTest.clw')

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
  
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  !The Tests here are atypical, in that they are designed to confirm Results are being passed back correctly
  
  MAP
Test:AllPointers    PROCEDURE(INT_PTR _SELF, INT_PTR  lpTestCase)  !<-- alternate prototype example (not recommended)
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

!Test:AllPointers This Test has an ALTERNATE Prototype, but it still works. (not recommended)
TEST:AllPointers     PROCEDURE(INT_PTR _SELF, INT_PTR lpTestCase) 
   !_SELF is needed for the prototype, but we're not using it here.
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

