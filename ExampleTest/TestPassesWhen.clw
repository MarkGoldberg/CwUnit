
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



