	MEMBER

!Region Notices
! ================================================================================
! Notice : Copyright (C) 2014-2017, Monolith Custom Computing, Inc.
!          Distributed under MIT (https://opensource.org/licenses/MIT) 
! 
!    This file is part of Monolith-Common (https://github.com/MarkGoldberg/MonolithCC-Common) 
! 
!    MonolithCC-Common is free software: you can redistribute it and/or modify 
!    it under the terms of the MIT License as published by 
!    the Open Source Initiative. 
! 
!    MonolithCC-Common is distributed in the hope that it will be useful, 
!    but WITHOUT ANY WARRANTY; without even the implied warranty of 
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
!    MIT License for more details. 
! 
!    You should have received a copy of the MIT License 
!    along with MonolithCC-Common.  If not, see <https://opensource.org/licenses/MIT>. 
! ================================================================================
!EndRegion Notices

	MAP
	END
	INCLUDE('ctQueue.inc'),ONCE
NoError  EQUATE(0)      !or INCLUDE('Errors.inc')

eqDBG EQUATE('<4,2,7>') 
!!                        COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
!!                   !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
!------------------------------------------------------------------------------------------------------	
ctQueue.CONSTRUCT			PROCEDURE
	CODE 
   SELF.IsTracing = FALSE
   !SELF.Q     &= NEW qt   !<-- example to appear in derived class
	!SELF.BaseQ &= SELF.Q   !<-- example to appear in derived class

!------------------------------------------------------------------------------------------------------	
ctQueue.DESTRUCT				PROCEDURE
	CODE 
                    Assert(~SELF.IsTracing, eqDBG&'v ctQueue.DESTRUCT ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &'] Addr['& ADDRESS(SELF) &']')                    
   
	SELF.Free()      !!  ;Assert(~SELF.IsTracing, eqDBG&'  ctQueue.DESTRUCT after Free')
	SELF._Dispose()  !!  ;Assert(~SELF.IsTracing, eqDBG&'  ctQueue.DESTRUCT after _Dispose')
                    !!   Assert(~SELF.IsTracing, eqDBG&'^ ctQueue.DESTRUCT ['& SELF.Description() &']')
                    Assert(~SELF.IsTracing, eqDBG&'^ ctQueue.DESTRUCT ['& SELF.Description() &']')
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
	IF (SELF.BaseQ &= NULL)                ;Assert(~SELF.IsTracing, eqDBG&'v ctQueue.Free early return .GenericQ &= NULL')
       RETURN 
   END
                                           Assert(~SELF.IsTracing, eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
	LOOP                                   ;Assert(~SELF.IsTracing, eqDBG&'v ctQueue.Free ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &']')
	   GET(SELF.BaseQ, 1)
	   IF ERRORCODE() THEN BREAK END
                                           Assert(~SELF.IsTracing, eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
	   SELF.Del()                          ;Assert(~SELF.IsTracing, eqDBG&'v ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')
	END
                                           Assert(~SELF.IsTracing, eqDBG&'^ ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')     
   
!------------------------------------------------------------------------------------------------------	
ctQueue.Del					PROCEDURE
	CODE 
?  ASSERT( ~SELF.BaseQ &= NULL, '.Q is null in .Del')
                                          Assert(~SELF.IsTracing, eqDBG&'v ctQueue.Del ['& SELF.Description() &'] Records['& SELF.Records() &']')     

   CLEAR (SELF.BaseQ)
   DELETE(SELF.BaseQ)
                                          Assert(~SELF.IsTracing, eqDBG&'^ ctQueue.Del ['& SELF.Description() &'] Records['& SELF.Records() &']')     

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
                                           Assert(~SELF.IsTracing, eqDBG& SELF.Description() & 'Records['& CHOOSE(SELF.BaseQ &= NULL, 'Null', RECORDS(SELF.BaseQ)) &']')
   RETURN CHOOSE( SELF.BaseQ &= NULL, 0, RECORDS(SELF.BaseQ) )

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
                                           ! Assert(0,eqDBG&'v ctQueue.GetPrevRow InPriorRow_OutCurrRow['& InPriorRow_OutCurrRow &']')
      IF InPriorRow_OutCurrRow = 0
         InPriorRow_OutCurrRow = SELF.Count()
      ELSE
         InPriorRow_OutCurrRow -= 1
      END
      DesiredRow = InPriorRow_OutCurrRow                                             
   ELSE
      DesiredRow  = POINTER(SELF.BaseQ) - 1
      IF DesiredRow < 0
         DesiredRow = SELF.Count()  !<-- POLICY: Could be argued to set DesiredRow=0 instead.
      END     
   END      
                                            !   Assert(0,eqDBG&'v ctQueue.GetPrevRow DesiredRow['& DesiredRow &']')
   RETURN SELF.GetRow(DesiredRow)

!------------------------------------------------------------------------------------------------------	
ctQueue.GetNextRow        PROCEDURE(<*LONG InPriorRow_OutCurrRow>)!,LONG,PROC !returns ErrorCode
RetErr     LONG,AUTO
DesiredRow LONG,AUTO
	CODE
                                             ! Assert(~SELF.IsTracing, eqDBG&'V ctQueue.GetNextRow')
   IF ~OMITTED(InPriorRow_OutCurrRow)        !;Assert(~SELF.IsTracing, eqDBG&'  ctQueue.GetNextRow')
      InPriorRow_OutCurrRow += 1
      DesiredRow = InPriorRow_OutCurrRow
   ELSE                                      !;Assert(~SELF.IsTracing, eqDBG&'  ctQueue.GetNextRow')
      DesiredRow  = POINTER(SELF.BaseQ) + 1  !;Assert(~SELF.IsTracing, eqDBG&'  ctQueue.GetNextRow')
   END                                       !;Assert(~SELF.IsTracing, eqDBG&'  ctQueue.GetNextRow DesiredRow['& DesiredRow &']')
   RetErr =  SELF.GetRow(DesiredRow)         !;Assert(~SELF.IsTracing, eqDBG&'^ ctQueue.GetNextRow RetErr['& RetErr &']')
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
CurrPtr    LONG(0) 
HoldState  LIKE(gtPtrBuffer)   
   CODE
   SELF.QState_Save(HoldState) 

   IF FreeDestFirst
      FREE(DestQ) 
   END

   LOOP WHILE SELF.GetNextRow(CurrPtr) = NoError
        DestQ = SELF.BaseQ
        ADD(DestQ)
   END      

   SELF.QState_Restore(HoldState)
 


!------------------------------------------------------------------------------------------------------  
ctQueue.Dump              PROCEDURE(STRING xPrefix)
CurrPtr    LONG(0)
HoldState  LIKE(gtPtrBuffer)
   CODE
                                                               Assert(0,eqDBG&'v Dumping ['& SELF.Description() &'] - ['& xPrefix &'] .Count['& SELF.Count() &']')
                                                              !   SELF.ForEach( ctQueue.DumpOneRow, xPrefix, QState:Preserve)
   SELF.QState_Save(HoldState) 

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      SELF.DumpOneRow( xPrefix )
   END

   SELF.QState_Restore(HoldState)
                                                               Assert(0,eqDBG&'^ Dumping ['& SELF.Description() &'] - ['& xPrefix &']')
!-! !------------------------------------------------------------------------------------------------------  
!-! ctQueue.Dump              PROCEDURE(STRING xPrefix)
!-! !HoldPtr    LONG,AUTO
!-! !HoldBuffer ANY
!-! HoldState  LIKE(gtPtrBuffer)
!-! CurrPtr    LONG(0) !NoAuto
!-!    CODE
!-!    !HoldPtr    = SELF.Pointer()
!-!    !HoldBuffer = SELF.BaseQ
!-!    SELF.SaveState(HoldState)
!-!    !-------------
!-! 
!-!    Assert(0,eqDBG & xPrefix & 'Count()['& SELF.Count() &']')  !rel ! <--- todo, consider using an iLog 
!-! 
!-!    LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!-!       SELF.DumpOneRow(xPrefix)
!-!    END
!-!    !-------------
!-!    SELF.RestoreState(HoldState)
!-!    !SELF.GetRow(HoldPtr)
!-!    !SELF.BaseQ = HoldBuffer

!------------------------------------------------------------------------------------------------------  
ctQueue.ToString          PROCEDURE()!,STRING,VIRTUAL
   CODE
   RETURN 'Pointer['& SELF.Pointer() &']'
   !stub method, (could write something using reflection...)

!------------------------------------------------------------------------------------------------------  
ctQueue.DumpOneRow        PROCEDURE(STRING xPrefix)!,VIRTUAL
   CODE
   Assert(0,eqDBG & xPrefix & ' ' & SELF.ToString() ) 
   !stub method, (could write something using reflection...)

!------------------------------------------------------------------------------------------------------  
ctQueue.ForEach           PROCEDURE(ftProc_Long   xProc  , LONG xUserData, BOOL xPreserveState = FALSE)
CurrPtr    LONG(0)
HoldState  LIKE(gtPtrBuffer)
   CODE
   IF xPreserveState THEN SELF.QState_Save(HoldState) END

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      xProc( xUserData )
   END

   IF xPreserveState THEN SELF.QState_Restore(HoldState) END


ctQueue.ForEach           PROCEDURE(ftMethod_Long xMethod, LONG xUserData, BOOL xPreserveState = FALSE)
CurrPtr    LONG(0)
HoldState  LIKE(gtPtrBuffer)
   CODE
   IF xPreserveState THEN SELF.QState_Save(HoldState) END

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      xMethod( SELF, xUserData )
   END

   IF xPreserveState THEN SELF.QState_Restore(HoldState) END


!------------------------------------------------------------------------------------------------------  
ctQueue.ForEach           PROCEDURE(ftProc_String   xProc  , STRING xUserData, BOOL xPreserveState = FALSE)
CurrPtr    LONG(0)
HoldState  LIKE(gtPtrBuffer)
   CODE
   IF xPreserveState THEN SELF.QState_Save(HoldState) END

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      xProc( xUserData )
   END

   IF xPreserveState THEN SELF.QState_Restore(HoldState) END


ctQueue.ForEach           PROCEDURE(ftMethod_String xMethod, STRING xUserData, BOOL xPreserveState = FALSE)
CurrPtr    LONG(0)
HoldState  LIKE(gtPtrBuffer)
   CODE
   IF xPreserveState THEN SELF.QState_Save(HoldState) END

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      xMethod( SELF, xUserData )
   END

   IF xPreserveState THEN SELF.QState_Restore(HoldState) END


ctQueue.ForEach           PROCEDURE(ftProc_StarAny    xProc  , *?     xUserData, BOOL xPreserveState = QState:Preserve)
CurrPtr   LONG(0)
HoldState LIKE(gtPtrBuffer)
   CODE
   IF xPreserveState THEN SELF.QState_Save(HoldState) END

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      xProc( xUserData )
   END

   IF xPreserveState THEN SELF.QState_Restore(HoldState) END

ctQueue.ForEach           PROCEDURE(ftMethod_StarAny  xMethod, *?     xUserData, BOOL xPreserveState = QState:Preserve)   
CurrPtr   LONG(0)
HoldState LIKE(gtPtrBuffer)
   CODE
   IF xPreserveState THEN SELF.QState_Save(HoldState) END

   LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
      xMethod( SELF, xUserData )
   END

   IF xPreserveState THEN SELF.QState_Restore(HoldState) END


!------------------------------------------------------------------------------------------------------  
ctQueue.QState_Save         PROCEDURE(*gtPtrBuffer xgPtrBuffer)
   CODE
   xgPtrBuffer.Ptr = SELF.Pointer()
   xgPtrBuffer.Buf = SELF.BaseQ

!------------------------------------------------------------------------------------------------------  
ctQueue.QState_Restore      PROCEDURE(*gtPtrBuffer xgPtrBuffer)
   CODE
   SELF.GetRow(xgPtrBuffer.Ptr) 
   SELF.BaseQ = xgPtrBuffer.Buf


