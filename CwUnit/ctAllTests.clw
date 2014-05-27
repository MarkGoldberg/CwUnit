  MEMBER()

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

  INCLUDE('ctAllTests.inc'),ONCE

fpCurrentTest  INT_PTR,NAME('CurrentTest'),STATIC  !Must be STATIC
  MAP
    MODULE('InLoadedDLL')
      CurrentTest(INT_PTR _SELF, *CwUnit_ctResult Test),NAME('CurrentTest'),DLL(1)
    END
  END
  
!    INCLUDE('ctOutputDebugString.inc'),ONCE
!ODSAllTests  ctOutputDebugString

!=====================================
ctAllTests.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.Q     &= NEW qtTestMethodWithResults
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
ctAllTests.Run                            PROCEDURE(LONG ResultSetID, *CwUnit_gtTestMethod TestMethod)	 !Assumes SELF.Q is Aligned
	CODE
                                          	!	ODSAllTests.Add('v ctAllTests.Run   ResultSetID['& ResultSetID &']')	
	 fpCurrentTest = SELF.Q.ProcedureAddress  ! ; ODSAllTests.Add('  ctAllTests.Run fpCurrentTest['& fpCurrentTest &'] Category['& SELF.Q.Category &'] TestName['& SELF.Q.TestName &']')	
	                                          !   ODSAllTests.Add('  ctAllTests.Run SELF.Q.TimedResults['& CHOOSE( SELF.Q.TimedResults &= NULL, 'IsNull','Exists') &']')
	 SELF.Q.TimedResults.Starting(ResultSetID, TestMethod.Data1, TestMethod.Data2)      !Will add a SELF.Q.TimedResults.Q.OneResult
	 	                                       !  ; ODSAllTests.Add('  ctAllTests.Run after .TimedResults.Starting(ResultSetID)')
	                                          !  ; ODSAllTests.Add('  ctAllTests.Run SELF.Q.TimedResults.OneResult['& CHOOSE( SELF.Q.TimedResults.Q.OneResult &= NULL, 'IsNull','Exists') &']')    	                                                                                
	 CurrentTest( SELF.Q._SELF,  SELF.Q.TimedResults.Q.OneResult )   
	                                          !  ; ODSAllTests.Add('  ctAllTests.Run ')	
    SELF.Q.TimedResults.Finished()          !   ; ODSAllTests.Add('^ ctAllTests.Run ResultSetID['& ResultSetID &']')
                                                 
!=====================================
ctAllTests.Add                            PROCEDURE(CONST *CwUnit_gtTestMethod TestMethodFromDLL)    
	CODE
	CLEAR(SELF.Q)
	SELF.Q               = TestMethodFromDLL
	SELF.Q.TimedResults &= NEW ctTimedResults
	ADD(SELF.Q)
	
   
  
