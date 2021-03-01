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

MyTests     CLASS(CwUnit_ctTestFixture)
Equal         PROCEDURE(*CwUnit_ctResult Test)
StartsWith    PROCEDURE(*CwUnit_ctResult Test)
Contains      PROCEDURE(*CwUnit_ctResult Test)
AppearsIn     PROCEDURE(*CwUnit_ctResult Test)
EndsWith      PROCEDURE(*CwUnit_ctResult Test)

PassesWhenEqual         PROCEDURE(*CwUnit_ctResult Test)
PassesWhenStartsWith    PROCEDURE(*CwUnit_ctResult Test)
PassesWhenContains      PROCEDURE(*CwUnit_ctResult Test)
PassesWhenAppearsIn     PROCEDURE(*CwUnit_ctResult Test)
PassesWhenEndsWith      PROCEDURE(*CwUnit_ctResult Test)

            END


TestStrings:AddTests   PROCEDURE(*CwUnit_ctTestSuite TestSuite)
  CODE
  MyTests.Init(TestSuite,'TestStrings')

  MyTests.AddTest('Equal_Case(Same)_Hi_Hi'                       , ADDRESS(MyTests.Equal), 'Hi', 'Hi' )
  MyTests.AddTest('Equal_Case(Same)_HI_HI'                       , ADDRESS(MyTests.Equal), 'HI', 'HI' )

  MyTests.AddTest('StartsWith_Case(Same)'                        , ADDRESS(MyTests.StartsWith), 'HiThere'  , 'Hi')
  MyTests.AddTest('StartsWith_Case(Same)'                        , ADDRESS(MyTests.StartsWith), 'HITHERE'  , 'HI')

  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'HiThere'        , 'Hi')
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'HITHERE'        , 'HI')
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'abcHiTheredef'  , 'Hi')
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'xHiThere'       , 'Hi')

  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'Hi', 'HiThere' )
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'HI', 'HITHERE' )
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'Hi', 'xHiThere' )
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'Hi', 'abcHiTheredef' )

  MyTests.AddTest('EndsWith_Case(Same)'                          , ADDRESS(MyTests.EndsWith), 'HiThere', 're' )
  MyTests.AddTest('EndsWith_Case(Same)'                          , ADDRESS(MyTests.EndsWith), 'HITHERE', 'RE' )
  MyTests.AddTest('EndsWith_Case(Same)'                          , ADDRESS(MyTests.EndsWith), 'xHiThere', 'e'  )

!------
  MyTests.AddTest('PassesWhenEqual_Case(Same)_Hi_Hi'                       , ADDRESS(MyTests.PassesWhenEqual), 'Hi', 'Hi' )
  MyTests.AddTest('PassesWhenEqual_Case(Same)_HI_HI'                       , ADDRESS(MyTests.PassesWhenEqual), 'HI', 'HI' )
  MyTests.AddTest('PassesWhenStartsWith_Case(Same)'                        , ADDRESS(MyTests.PassesWhenStartsWith), 'HiThere'  , 'Hi')
  MyTests.AddTest('PassesWhenStartsWith_Case(Same)'                        , ADDRESS(MyTests.PassesWhenStartsWith), 'HITHERE'  , 'HI')
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'HiThere'        , 'Hi')
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'HITHERE'        , 'HI')
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'abcHiTheredef'  , 'Hi')
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'xHiThere'       , 'Hi')
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'Hi', 'HiThere' )
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'HI', 'HITHERE' )
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'Hi', 'xHiThere' )
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'Hi', 'abcHiTheredef' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Same)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 'HiThere', 're' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Same)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 'HITHERE', 'RE' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Same)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 'xHiThere', 'e'  )





  MyTests.Category = 'TestStrings - ABNORMAL: TESTS SHOULD FAIL'
  MyTests.AddTest('Equal_Case(Diff)'                             , ADDRESS(MyTests.Equal), 'Hi', 'HI' )  
  MyTests.AddTest('StartsWith_Case(Diff)'                        , ADDRESS(MyTests.StartsWith), 'HITHERE'  , 'Hi')
  MyTests.AddTest('StartsWith_Case(Same)'                        , ADDRESS(MyTests.StartsWith), 'xHiThere' , 'Hi')
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'Hi', 'HiThere' )
  MyTests.AddTest('Contains_Case(Diff)'                          , ADDRESS(MyTests.Contains), 'Hi', 'HITHERE' )
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'HI', 'HITHERE' )
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'Hi', 'xHiThere' )
  MyTests.AddTest('Contains_Case(Same)'                          , ADDRESS(MyTests.Contains), 'Hi', 'abcHiTheredef' )
  MyTests.AddTest('Contains_Case(Diff)'                          , ADDRESS(MyTests.Contains), 'HITHERE'        , 'Hi')  
  MyTests.AddTest('AppearsIn_Case(Diff)'                         , ADDRESS(MyTests.AppearsIn), 'Hi', 'HITHERE' )
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'HiThere'        , 'Hi')
  MyTests.AddTest('AppearsIn_Case(Diff)'                         , ADDRESS(MyTests.AppearsIn), 'HITHERE'        , 'Hi')
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'HITHERE'        , 'HI')
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'xHiThere'       , 'Hi')
  MyTests.AddTest('AppearsIn_Case(Same)'                         , ADDRESS(MyTests.AppearsIn), 'abcHiTheredef'  , 'Hi')
  MyTests.AddTest('EndsWith_Case(Diff)'                          , ADDRESS(MyTests.EndsWith), 'HITHERE', 're' )
  MyTests.AddTest('EndsWith_Case(Same)'                          , ADDRESS(MyTests.EndsWith), 're', 'HiThere' )
  MyTests.AddTest('EndsWith_Case(Diff)'                          , ADDRESS(MyTests.EndsWith), 're', 'HITHERE' )
  MyTests.AddTest('EndsWith_Case(Same)'                          , ADDRESS(MyTests.EndsWith), 'RE', 'HITHERE' )
  MyTests.AddTest('EndsWith_Case(Same)'                          , ADDRESS(MyTests.EndsWith), 'e', 'xHiThere' )

!----
  MyTests.AddTest('PassesWhenEqual_Case(Diff)'                             , ADDRESS(MyTests.PassesWhenEqual), 'Hi', 'HI' )  
  MyTests.AddTest('PassesWhenStartsWith_Case(Diff)'                        , ADDRESS(MyTests.PassesWhenStartsWith), 'HITHERE'  , 'Hi')
  MyTests.AddTest('PassesWhenStartsWith_Case(Same)'                        , ADDRESS(MyTests.PassesWhenStartsWith), 'xHiThere' , 'Hi')
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'Hi', 'HiThere' )
  MyTests.AddTest('PassesWhenContains_Case(Diff)'                          , ADDRESS(MyTests.PassesWhenContains), 'Hi', 'HITHERE' )
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'HI', 'HITHERE' )
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'Hi', 'xHiThere' )
  MyTests.AddTest('PassesWhenContains_Case(Same)'                          , ADDRESS(MyTests.PassesWhenContains), 'Hi', 'abcHiTheredef' )
  MyTests.AddTest('PassesWhenContains_Case(Diff)'                          , ADDRESS(MyTests.PassesWhenContains), 'HITHERE'        , 'Hi')  
  MyTests.AddTest('PassesWhenAppearsIn_Case(Diff)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'Hi', 'HITHERE' )
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'HiThere'        , 'Hi')
  MyTests.AddTest('PassesWhenAppearsIn_Case(Diff)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'HITHERE'        , 'Hi')
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'HITHERE'        , 'HI')
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'xHiThere'       , 'Hi')
  MyTests.AddTest('PassesWhenAppearsIn_Case(Same)'                         , ADDRESS(MyTests.PassesWhenAppearsIn), 'abcHiTheredef'  , 'Hi')
  MyTests.AddTest('PassesWhenEndsWith_Case(Diff)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 'HITHERE', 're' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Same)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 're', 'HiThere' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Diff)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 're', 'HITHERE' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Same)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 'RE', 'HITHERE' )
  MyTests.AddTest('PassesWhenEndsWith_Case(Same)'                          , ADDRESS(MyTests.PassesWhenEndsWith), 'e', 'xHiThere' )


MyTests.Equal         PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.Equal( Test.Data1, Test.Data2)
   !Test.PassesWhen(Test.Data1, is:EqualTo, Test.Data2)

MyTests.StartsWith   PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.StartsWith( Test.Data1, Test.Data2)
   !Test.PassesWhen(Test.Data1, String:StartsWith, Test.Data2)

MyTests.Contains     PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.Contains( Test.Data1, Test.Data2)
   !Test.PassesWhen(Test.Data1, String:Contains, Test.Data2)

MyTests.AppearsIn    PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.AppearsIn( Test.Data1, Test.Data2)
   !Test.PassesWhen(Test.Data1, String:AppearsIn, Test.Data2)


MyTests.EndsWith   PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.EndsWith( Test.Data1, Test.Data2)
   !Test.PassesWhen(Test.Data1, String:EndsWith, Test.Data2)



MyTests.PassesWhenEqual         PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.PassesWhen(Test.Data1, is:EqualTo, Test.Data2)

MyTests.PassesWhenStartsWith   PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.PassesWhen(Test.Data1, String:StartsWith, Test.Data2)

MyTests.PassesWhenContains     PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.PassesWhen(Test.Data1, String:Contains, Test.Data2)

MyTests.PassesWhenAppearsIn    PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.PassesWhen(Test.Data1, String:AppearsIn, Test.Data2)


MyTests.PassesWhenEndsWith   PROCEDURE(*CwUnit_ctResult Test)
   CODE
   Test.PassesWhen(Test.Data1, String:EndsWith, Test.Data2)


