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
NoError  EQUATE(0)      !or INCLUDE('Errors.inc')

Mod:Assert EQUATE(TRUE) !use FALSE to show the ASSERT,  only set to FALSE if you have a DebugerClass which uses SYSTEM{PROP:AssertHook2}

eqDBG EQUATE('<4,2,7>') 
!!                        COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
!!                   !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
!------------------------------------------------------------------------------------------------------	
ctQueue.CONSTRUCT			PROCEDURE
	CODE 
   !SELF.Q     &= NEW qt   !<-- example to appear in derived class
	!SELF.BaseQ &= SELF.Q   !<-- example to appear in derived class

!------------------------------------------------------------------------------------------------------	
ctQueue.DESTRUCT				PROCEDURE
	CODE 
                    Assert(MOD:Assert,eqDBG&'v ctQueue.DESTRUCT ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &'] Addr['& ADDRESS(SELF) &']')
   
	SELF.Free()      !!  ;Assert(MOD:Assert,eqDBG&'  ctQueue.DESTRUCT after Free')
	SELF._Dispose()  !!  ;Assert(MOD:Assert,eqDBG&'  ctQueue.DESTRUCT after _Dispose')
                    !!   Assert(MOD:Assert,eqDBG&'^ ctQueue.DESTRUCT ['& SELF.Description() &']')

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
	IF (SELF.BaseQ &= NULL)                ;Assert(MOD:Assert,eqDBG&'v ctQueue.Free early return .GenericQ &= NULL')
       RETURN 
   END
                                           Assert(MOD:Assert,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
	LOOP                                   ;Assert(MOD:Assert,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &']')
	   GET(SELF.BaseQ, 1)
	   IF ERRORCODE() THEN BREAK END
                                           Assert(MOD:Assert,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
	   SELF.Del()                          ;Assert(MOD:Assert,eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
	END
                                           Assert(MOD:Assert,eqDBG&'^ ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')     
   
!------------------------------------------------------------------------------------------------------	
ctQueue.Del					PROCEDURE
	CODE 
?  ASSERT( ~SELF.BaseQ &= NULL, '.Q is null in .Del')
                                          Assert(MOD:Assert,eqDBG&'v ctQueue.Del ['& SELF.Description() &'] Records['& SELF.Records() &']')     

   CLEAR (SELF.BaseQ)
   DELETE(SELF.BaseQ)
                                          Assert(MOD:Assert,eqDBG&'^ ctQueue.Del ['& SELF.Description() &'] Records['& SELF.Records() &']')     

!------------------------------------------------------------------------------------------------------  
ctQueue.Put                PROCEDURE
   CODE 
   PUT(SELF.BaseQ)


!------------------------------------------------------------------------------------------------------  
ctQueue.Add                PROCEDURE
   CODE 
   ADD(SELF.BaseQ)


!------------------------------------------------------------------------------------------------------  
ctQueue.Count              PROCEDURE()!,LONG    !Alias for .Records
   CODE
   RETURN SELF.Records()

!------------------------------------------------------------------------------------------------------  
ctQueue.Records            PROCEDURE()!,LONG    
   CODE
                                           Assert(MOD:Assert,eqDBG& SELF.Description() & 'Records['& RECORDS(SELF.BaseQ) &']')
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
                                             ! Assert(MOD:Assert,eqDBG&'V ctQueue.GetNextRow')
   IF ~OMITTED(InPriorRow_OutCurrRow)        !;Assert(MOD:Assert,eqDBG&'  ctQueue.GetNextRow')
      InPriorRow_OutCurrRow += 1
      DesiredRow = InPriorRow_OutCurrRow
   ELSE                                      !;Assert(MOD:Assert,eqDBG&'  ctQueue.GetNextRow')
      DesiredRow  = POINTER(SELF.BaseQ) + 1  !;Assert(MOD:Assert,eqDBG&'  ctQueue.GetNextRow')
   END                                       !;Assert(MOD:Assert,eqDBG&'  ctQueue.GetNextRow DesiredRow['& DesiredRow &']')
   RetErr =  SELF.GetRow(DesiredRow)         !;Assert(MOD:Assert,eqDBG&'^ ctQueue.GetNextRow RetErr['& RetErr &']')
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

   HoldPtr    = SELF.Pointer()
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
 


!------------------------------------------------------------------------------------------------------  
ctQueue.Dump              PROCEDURE(STRING xPrefix)
HoldPtr    LONG,AUTO
HoldBuffer ANY
CurrPtr    LONG !NoAuto
   CODE
   HoldPtr    = SELF.Pointer()
   HoldBuffer = SELF.BaseQ
   !-------------
   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      SELF.DumpOneRow(xPrefix)
   END
   !-------------
   SELF.GetRow(HoldPtr)
   SELF.BaseQ = HoldBuffer

!------------------------------------------------------------------------------------------------------  
ctQueue.DumpOneRow        PROCEDURE(STRING xPrefix)!,VIRTUAL
   CODE
   !stub method, (could write something using reflection...)
