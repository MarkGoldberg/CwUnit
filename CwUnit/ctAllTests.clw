
  MEMBER()
  INCLUDE('ctAllTests.inc'),ONCE

fpCurrentTest  INT_PTR,NAME('CurrentTest'),STATIC  !Must be STATIC
  MAP
    MODULE('InLoadedDLL')
      CurrentTest(INT_PTR _SELF, *ctOneResult Result, INT_PTR UserData),NAME('CurrentTest'),DLL(1)
    ! CurrentTest(INT_PTR UserData1, INT_PTR lpOneResult, INT_PTR UserData2),NAME('CurrentTest'),DLL(1)
    END
  END
  
!    INCLUDE('ctOutputDebugString.inc'),ONCE
!ODSAllTests  ctOutputDebugString

!=====================================
ctAllTests.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.Q     &= NEW qtOneTest
  SELF.BaseQ &= SELF.Q

!=====================================
ctAllTests.DESTRUCT                       PROCEDURE()
  CODE  

!=====================================
ctAllTests.Del                            PROCEDURE() !,DERIVED
	CODE
	DISPOSE(SELF.Q.TimedResults)	
	PARENT.Del()
	
!=====================================
ctAllTests.Description                    PROCEDURE()!,STRING,DERIVED
	CODE
	RETURN 'ctAllTests'
	
!=====================================
ctAllTests.Run                            PROCEDURE(LONG ResultSetID)	 !Assumes SELF.Q is Aligned
	CODE
                                          	!	ODSAllTests.Add('v ctAllTests.Run   ResultSetID['& ResultSetID &']')	
	 fpCurrentTest = SELF.Q.ProcedureAddress  ! ; ODSAllTests.Add('  ctAllTests.Run fpCurrentTest['& fpCurrentTest &'] Category['& SELF.Q.Category &'] TestName['& SELF.Q.TestName &']')	
	                                          !   ODSAllTests.Add('  ctAllTests.Run SELF.Q.TimedResults['& CHOOSE( SELF.Q.TimedResults &= NULL, 'IsNull','Exists') &']')
	 SELF.Q.TimedResults.Starting(ResultSetID)      !Will add a SELF.Q.TimedResults.Q.OneResult
	 	                                       !  ; ODSAllTests.Add('  ctAllTests.Run after .TimedResults.Starting(ResultSetID)')
	                                          !  ; ODSAllTests.Add('  ctAllTests.Run SELF.Q.TimedResults.OneResult['& CHOOSE( SELF.Q.TimedResults.Q.OneResult &= NULL, 'IsNull','Exists') &']')    	                                                                                
	 CurrentTest( SELF.Q._SELF,         SELF.Q.TimedResults.Q.OneResult , SELF.Q.UserData)   
	                                          !  ; ODSAllTests.Add('  ctAllTests.Run ')	
    SELF.Q.TimedResults.Finished()          !   ; ODSAllTests.Add('^ ctAllTests.Run ResultSetID['& ResultSetID &']')
                                                 
!=====================================
ctAllTests.Add                            PROCEDURE(gtOneTestFromDLL OneTestFromDLL)    
	CODE
	CLEAR(SELF.Q)
	SELF.Q               = OneTestFromDLL
	SELF.Q.TimedResults &= NEW ctTimedResults
	ADD(SELF.Q)
	
   
  