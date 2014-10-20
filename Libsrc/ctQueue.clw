	MEMBER

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
	INCLUDE('ctQueue.inc'),ONCE
NoError  EQUATE(0) !or INCLUDE('Errors.inc')

eqDBG EQUATE('<4,2,7>') 
                        COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                   !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
!------------------------------------------------------------------------------------------------------	
ctQueue.CONSTRUCT			PROCEDURE
	CODE 
    !SELF.Q     &= NEW qt   !<-- example to appear in derived class
	!SELF.BaseQ &= SELF.Q   !<-- example to appear in derived class

!------------------------------------------------------------------------------------------------------	
ctQueue.DESTRUCT				PROCEDURE
	CODE 
                        COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                    Assert(0,eqDBG&'v ctQueue.DESTRUCT ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &'] Addr['& ADDRESS(SELF) &']')
                    !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
   
	SELF.Free()      !!  ;Assert(0,eqDBG&'  ctQueue.DESTRUCT after Free')
	SELF._Dispose()  !!  ;Assert(0,eqDBG&'  ctQueue.DESTRUCT after _Dispose')
                    !!   Assert(0,eqDBG&'^ ctQueue.DESTRUCT ['& SELF.Description() &']')

!------------------------------------------------------------------------------------------------------  
ctQueue._Dispose           PROCEDURE()!,VIRTUAL                     
   CODE
   DISPOSE(SELF.BaseQ)

!------------------------------------------------------------------------------------------------------  
ctQueue.Description       PROCEDURE()!,STRING,VIRTUAL
   CODE
   RETURN ''

!------------------------------------------------------------------------------------------------------	
ctQueue.Free					PROCEDURE
	CODE 
	IF (SELF.BaseQ &= NULL) 
			 		       COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                     Assert(0,eqDBG&'v ctQueue.Free early return .GenericQ &= NULL')
                      !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
       RETURN 
   END
			               COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                     Assert(0,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
                     !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)

	LOOP 
                          COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                     Assert(0,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &']')
                      !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
	   GET(SELF.BaseQ, 1)
	   IF ERRORCODE() THEN BREAK END
                           COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                     Assert(0,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
                      !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
	   SELF.Del()
                           COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                     Assert(0,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
                      !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
	END
					       COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                        Assert(0,eqDBG&'^ ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')     
                     !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
   
!------------------------------------------------------------------------------------------------------	
ctQueue.Del					PROCEDURE
	CODE 
?  ASSERT( ~SELF.BaseQ &= NULL, '.Q is null in .Del')
                      COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                        Assert(0,eqDBG&'v ctQueue.Del ['& SELF.Description() &'] Records['& SELF.Records() &']')     
                    !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)

   CLEAR (SELF.BaseQ)
   DELETE(SELF.BaseQ)
                      COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                        Assert(0,eqDBG&'^ ctQueue.Del ['& SELF.Description() &'] Records['& SELF.Records() &']')     
                    !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)

!------------------------------------------------------------------------------------------------------  
ctQueue.Put                PROCEDURE
   CODE 
   PUT(SELF.BaseQ)


!------------------------------------------------------------------------------------------------------  
ctQueue.Count              PROCEDURE()!,LONG    !Alias for .Records
   CODE
   RETURN SELF.Records()

!------------------------------------------------------------------------------------------------------  
ctQueue.Records            PROCEDURE()!,LONG    
   CODE
                         COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)    
                         Assert(0,eqDBG& SELF.Description() & 'Records['& RECORDS(SELF.BaseQ) &']')
                    !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
   RETURN RECORDS(SELF.BaseQ)

!------------------------------------------------------------------------------------------------------  
ctQueue.Pointer           PROCEDURE()!,LONG 
   CODE
   RETURN POINTER(SELF.BaseQ)

!------------------------------------------------------------------------------------------------------  
ctQueue.GetRow             PROCEDURE(LONG xPointer) 
   CODE
   GET(SELF.BaseQ, xPointer)
   RETURN ErrorCode()

!------------------------------------------------------------------------------------------------------  
ctQueue.GetFirstRow        PROCEDURE()
   CODE
   RETURN SELF.GetRow(1)

!------------------------------------------------------------------------------------------------------  
ctQueue.GetPrevRow        PROCEDURE(<*LONG InPriorRow_OutCurrRow>)!,LONG,PROC !returns ErrorCode
DesiredRow LONG,AUTO
   CODE
   IF ~OMITTED(InPriorRow_OutCurrRow)
      InPriorRow_OutCurrRow -= 1
      DesiredRow = InPriorRow_OutCurrRow
   ELSE
      DesiredRow  = POINTER(SELF.BaseQ) - 1
      IF DesiredRow < 0
         DesiredRow = SELF.Count()  !<-- POLICY: Could be argued to set DesiredRow=0 instead.
      END     
   END      
   RETURN SELF.GetRow(DesiredRow)

!------------------------------------------------------------------------------------------------------	
ctQueue.GetNextRow        PROCEDURE(<*LONG InPriorRow_OutCurrRow>)!,LONG,PROC !returns ErrorCode
RetErr     LONG,AUTO
DesiredRow LONG,AUTO
	CODE
                                             ! Assert(0,eqDBG&'V ctQueue.GetNextRow')
   IF ~OMITTED(InPriorRow_OutCurrRow)        !;Assert(0,eqDBG&'  ctQueue.GetNextRow')
      InPriorRow_OutCurrRow += 1
      DesiredRow = InPriorRow_OutCurrRow
   ELSE                                      !;Assert(0,eqDBG&'  ctQueue.GetNextRow')
      DesiredRow  = POINTER(SELF.BaseQ) + 1  !;Assert(0,eqDBG&'  ctQueue.GetNextRow')
   END                                       !;Assert(0,eqDBG&'  ctQueue.GetNextRow DesiredRow['& DesiredRow &']')
   RetErr =  SELF.GetRow(DesiredRow)         !;Assert(0,eqDBG&'^ ctQueue.GetNextRow RetErr['& RetErr &']')
   RETURN RetErr

!------------------------------------------------------------------------------------------------------  
ctQueue.GetLastRow         PROCEDURE()
   CODE
   RETURN SELF.GetRow( SELF.Count() )
   
	
!------------------------------------------------------------------------------------------------------  
ctQueue.CopyTo            PROCEDURE(*ctQueue DestQ , BOOL FreeDestFirst=TRUE) !Will call SELF.Free()
   CODE
   IF FreeDestFirst
      DestQ.Free()  !Allows for .DEL to run, this can be a very important difference
   END
   SELF.CopyTo( DestQ.BaseQ, FALSE)

!------------------------------------------------------------------------------------------------------  
ctQueue.CopyTo            PROCEDURE(  *QUEUE DestQ , BOOL FreeDestFirst=TRUE) !will use RTL FREE(QUEUE)
HoldPtr    LONG,AUTO
HoldBuffer ANY
CurrPtr    LONG(0) 
   CODE

   HoldPtr    = POINTER(SELF.BaseQ)
   HoldBuffer = SELF.BaseQ

   IF FreeDestFirst
      FREE(DestQ) 
   END

   LOOP WHILE SELF.GetNextRow(CurrPtr) = NoError
        DestQ = SELF.BaseQ
        ADD(DestQ)
   END      

   SELF.GetRow(HoldPtr)
   SELF.BaseQ = HoldBuffer
 
