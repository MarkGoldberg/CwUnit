   INCLUDE(       'ctQueue.inc'),ONCE
   INCLUDE('ctTimedResults.inc'),ONCE
   INCLUDE(     'DataTypes.equ'),ONCE
   INCLUDE(       'ICwUnit.int'),ONCE !for gtOneTestFromDLL


gtOneTest      GROUP(gtOneTestFromDLL),TYPE
TimedResults       &ctTimedResults
               END

qtOneTest      QUEUE(gtOneTest),TYPE
					END


ctAllTests 		CLASS(ctQueue),TYPE,MODULE('ctAllTests.clw'),LINK('ctAllTests.clw')
Q                             &qtOneTest
!----------
CONSTRUCT                      PROCEDURE()
DESTRUCT                       PROCEDURE()
Del                            PROCEDURE,DERIVED
Description                    PROCEDURE(),STRING,DERIVED
Run                            PROCEDURE(LONG ResultSetID)
Add                            PROCEDURE(gtOneTestFromDLL OneTestFromDLL)
       			END

!gtOneTestRef   GROUP,TYPE
!OneTest           &ctOneTest
!               END

!  BUG BUG BUG 
!  ==========================================
!  The issue is, will the DLL create instance of classes ?
!  I think if the call becomes
!     ATest(INT_PTR Arg1, *ctOneResult OneResult, <INT_PTR Arg2>)   then that can be:
!     ATest(  SELF                      OneResult,           Arg2 )   which is 
!     SELF.ATest(                       OneResult,           Arg2 )
!     
!  Then we can have Arg2 be whatever the UnitTest wants it to be.
!     Granted that means, instantiating objects when the tests are Loaded
!     WHEN (if ever) would they be cleaned up ?
!    
!  Since the call has become something that *can* be called as CLASS
!      Then I think the UnitTest itself, can have OneResult as an argument
!      vs. as SELF
!      
!  OTOH, we could instantiate the ctOneResult in the DLL
!     and then it could derive from it, however it sees fit
!     Then the call becomes: 
!     SELF.ATest(INT_PTR UserData)
!     
!  In this case, we would want a clear way to DISPOSE of the tests
!     So add .UnLoadTests  ctTestDlls[.LoadTests, .RunTests, .UnLoadTests]
!     
