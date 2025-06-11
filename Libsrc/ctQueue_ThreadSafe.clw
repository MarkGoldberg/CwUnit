    MEMBER

!Region Notices
! ======================================================================================
! (MIT License) as found on https://mit-license.org/ (with some CR/LF formatting added)
! ======================================================================================
!
! Copyright © 2023 <copyright holders>
! 
! Permission is hereby granted, free of charge, 
! to any person obtaining a copy of this software and associated documentation files (the “Software”), 
! to deal in the Software without restriction, including without limitation the rights to use, 
! copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
! and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
! 
! The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
! 
! THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
! THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
! IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
! WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
! OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
! ======================================================================================
!EndRegion Notices

    INCLUDE('ctQueue_ThreadSafe.inc'),ONCE

    MAP
    END

NoError  EQUATE(0)      !or INCLUDE('Errors.inc')

eqDBG EQUATE('<4,2,7>') 

!------------------------------------------------------------------------------------------------------ 
ctQueue_ThreadSafe.CONSTRUCT           PROCEDURE
    CODE 
    SELF.IsTracing = FALSE
    !SELF.Q     &= NEW qt      !<-- example to appear in derived class
    !SELF.SetBaseQ( SELF.Q )   !<-- example to appear in derived class
    SELF.ThreadLock &= NewCriticalSection()    

!------------------------------------------------------------------------------------------------------ 
ctQueue_ThreadSafe.DESTRUCT                PROCEDURE
    CODE 
                        !Assert(~SELF.IsTracing, eqDBG&'v ctQueue_ThreadSafe.DESTRUCT ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &'] Addr['& ADDRESS(SELF) &']')                    
                         Assert(~SELF.IsTracing, eqDBG&'v ctQueue_ThreadSafe.DESTRUCT')
                         Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.DESTRUCT ADDRESS(SELF)['& ADDRESS(SELF) &']')
                        !Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.DESTRUCT ['& SELF.Description() &']')
                         Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.DESTRUCT SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &']')
   
    SELF.Free()        !!  ;Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.DESTRUCT after Free')
    SELF._Dispose()    !!  ;Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.DESTRUCT after _Dispose')
                       !!   Assert(~SELF.IsTracing, eqDBG&'^ ctQueue_ThreadSafe.DESTRUCT ['& SELF.Description() &']')
    SELF.ThreadLock.Kill()

                         Assert(~SELF.IsTracing, eqDBG&'^ ctQueue_ThreadSafe.DESTRUCT') ! ['& SELF.Description() &']')
!=======================================================================================================================
ctQueue_ThreadSafe._Dispose           PROCEDURE()!,VIRTUAL                     
   CODE
    SELF.ThreadLock.Wait()
        DISPOSE(SELF.BaseQ)
    SELF.ThreadLock.Release()

!=======================================================================================================================
ctQueue_ThreadSafe.Description       PROCEDURE()!,STRING,VIRTUAL
   CODE
   RETURN ''

!------------------------------------------------------------------------------------------------------ 
ctQueue_ThreadSafe.SetBaseQ          PROCEDURE(*QUEUE xBaseQ)
    CODE 
    SELF.ThreadLock.Release()

       SELF.BaseQ &= xBaseQ

    SELF.ThreadLock.Release()

!------------------------------------------------------------------------------------------------------ 
ctQueue_ThreadSafe.Free                    PROCEDURE
QPtr LONG,AUTO
    CODE 
                                                Assert(~SELF.IsTracing,eqDBG&'v ctQueue_ThreadSafe.Free')
    SELF.ThreadLock.Wait()

       IF (SELF.BaseQ &= NULL)                     ;Assert(~SELF.IsTracing, eqDBG&'v ctQueue_ThreadSafe.Free early return .GenericQ &= NULL')
           RETURN 
       END
                                                    Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.Free  Records['& SELF.Records() &']')
       LOOP QPtr = RECORDS(SELF.BaseQ) TO 1 BY -1  ;Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.Free  SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &']')
         GET(SELF.BaseQ, QPtr)
         IF ERRORCODE() THEN BREAK END
                                                    Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.Free  Records['& SELF.Records() &']')
         SELF.Del()                                ;Assert(~SELF.IsTracing, eqDBG&'  ctQueue_ThreadSafe.Free  Records['& SELF.Records() &']')
       END
                                                    Assert(~SELF.IsTracing, eqDBG&'^ ctQueue_ThreadSafe.Free  Records['& SELF.Records() &']')     
    SELF.ThreadLock.Release()
                                                Assert(~SELF.IsTracing,eqDBG&'^ ctQueue_ThreadSafe.Free')
   
!------------------------------------------------------------------------------------------------------ 
ctQueue_ThreadSafe.Del                 PROCEDURE
    CODE 
                                                  Assert(~SELF.IsTracing, eqDBG&'v ctQueue_ThreadSafe.Del  SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &']')     
    SELF.ThreadLock.Wait()
?     ASSERT( ~SELF.BaseQ &= NULL, '.Q is null in .Del')
                                                  Assert(~SELF.IsTracing, eqDBG&'v ctQueue_ThreadSafe.Del  Records['& SELF.Records() &']')     

      CLEAR (SELF.BaseQ)
      DELETE(SELF.BaseQ)
                                                  Assert(~SELF.IsTracing, eqDBG&'^ ctQueue_ThreadSafe.Del  Records['& SELF.Records() &']')     
    SELF.ThreadLock.Release()

!=======================================================================================================================
ctQueue_ThreadSafe.Put                PROCEDURE(STRING xQueueBuffer)!,VIRTUAL   ! ASSUMES Q is aligned.  Also Assume already inside of ThreadLock
   CODE 
    SELF.ThreadLock.Wait()

       SELF.BaseQ = xQueueBuffer
       PUT(SELF.BaseQ)         

    SELF.ThreadLock.Release()


!=======================================================================================================================
ctQueue_ThreadSafe.Add                PROCEDURE(STRING xQueueBuffer)!,VIRTUAL
   CODE 
    SELF.ThreadLock.Wait()

       SELF.BaseQ = xQueueBuffer
       ADD(SELF.BaseQ)         

    SELF.ThreadLock.Release()


!=======================================================================================================================
ctQueue_ThreadSafe.SortedAdd                   PROCEDURE(STRING xQueueBuffer, STRING xSortOrder)!,VIRTUAL   
    CODE 
    SELF.ThreadLock.Wait()

       SELF.BaseQ = xQueueBuffer
       ADD(SELF.BaseQ, xSortOrder)

       ! HELP Add(Queue,Name) re: Name:
       !   Inserts a new queue entry in a sorted memory queue. 
       !   The name string must contain the NAME attributes of the fields, separated by commas, 
       !   with optional leading plus or minus signs to indicate ascending or descending sequence. 
       !   The entry is inserted immediately after all other entries with matching field values. 
       !   If there are no entries, ADD(queue,name) may be used to build the QUEUE in sorted order.
 

    SELF.ThreadLock.Release()


!=======================================================================================================================
ctQueue_ThreadSafe.Count              PROCEDURE()!,LONG    !Alias for .Records
   CODE

    RETURN SELF.Records()  
    

!=======================================================================================================================
ctQueue_ThreadSafe.Records            PROCEDURE()!,LONG    
Answer LONG,AUTO
   CODE
    SELF.ThreadLock.Wait()
                                           Assert(~SELF.IsTracing, eqDBG& SELF.Description() & 'Records['& CHOOSE(SELF.BaseQ &= NULL, 'Null', RECORDS(SELF.BaseQ)) &']')
        Answer = CHOOSE( SELF.BaseQ &= NULL, 0, RECORDS(SELF.BaseQ) ) ! I doubt I really need to ThreadLock.Wait for this...

    SELF.ThreadLock.Release()
    RETURN Answer 

!=======================================================================================================================
!ctQueue_ThreadSafe.Pointer           PROCEDURE()!,LONG   ! there's no need for this
!   CODE
!   RETURN POINTER(SELF.BaseQ)

!=======================================================================================================================
!ctQueue_ThreadSafe.PrepForLoop        PROCEDURE() 
!   CODE
!   SELF.GetRow(0)

!=======================================================================================================================
ctQueue_ThreadSafe.GetRow             PROCEDURE(LONG xPointer, *STRING xOutQueueBuffer) 
RetGetError LONG,AUTO
   CODE
    SELF.ThreadLock.Wait()

      GET(SELF.BaseQ, xPointer)
      RetGetError = ErrorCode()
      xOutQueueBuffer = SELF.BaseQ  ! could confirm that the SIZE is appropriate

    SELF.ThreadLock.Release()

    RETURN RetGetError
!=======================================================================================================================
ctQueue_ThreadSafe.GetFirstRow        PROCEDURE(*STRING xOutQueueBuffer)
   CODE
   RETURN SELF.GetRow(1, xOutQueueBuffer)

!=======================================================================================================================
ctQueue_ThreadSafe.GetPrevRow        PROCEDURE(*LONG InPriorRow_OutCurrRow, *STRING xOutQueueBuffer)!,LONG,PROC !returns ErrorCode
   CODE
                                           ! Assert(0,eqDBG&'v ctQueue_ThreadSafe.GetPrevRow InPriorRow_OutCurrRow['& InPriorRow_OutCurrRow &']')

   IF   InPriorRow_OutCurrRow <= 0            |
     OR InPriorRow_OutCurrRow >  SELF.Count() |
   THEN 
        InPriorRow_OutCurrRow  = SELF.Count()
   ELSE
        InPriorRow_OutCurrRow -= 1
   END
                                            !   Assert(0,eqDBG&'v ctQueue_ThreadSafe.GetPrevRow InPriorRow_OutCurrRow['& InPriorRow_OutCurrRow &']')
   RETURN SELF.GetRow(InPriorRow_OutCurrRow, xOutQueueBuffer)

!------------------------------------------------------------------------------------------------------ 
ctQueue_ThreadSafe.GetNextRow        PROCEDURE(*LONG InPriorRow_OutCurrRow, *STRING xOutQueueBuffer)!,LONG,PROC !returns ErrorCode
RetErr     LONG,AUTO
DesiredRow LONG,AUTO
    CODE                                                                     ! Assert(~SELF.IsTracing, eqDBG&'V ctQueue_ThreadSafe.GetNextRow')

    InPriorRow_OutCurrRow += 1

           RetErr =  SELF.GetRow(InPriorRow_OutCurrRow, xOutQueueBuffer )    !;Assert(~SELF.IsTracing, eqDBG&'^ ctQueue_ThreadSafe.GetNextRow RetErr['& RetErr &']')
    RETURN RetErr

!=======================================================================================================================
ctQueue_ThreadSafe.GetLastRow         PROCEDURE(*STRING xOutQueueBuffer)
   CODE
   RETURN SELF.GetRow( SELF.Count(), xOutQueueBuffer )
   
   
!=======================================================================================================================
ctQueue_ThreadSafe.BufferSize            PROCEDURE()!,LONG,VIRTUAL
    CODE 
    !MESSAGE('ctQueue_ThreadSafe.BufferSize needs to be derived','Programmer Error', SYSTEM{PROP:Icon})
    RETURN SIZE(SELF.BaseQ)



!=======================================================================================================================
ctQueue_ThreadSafe.CopyTo             PROCEDURE(*QUEUE xDestQ , LONG xUserData, BOOL xFreeDestFirst=TRUE) !will use RTL FREE(QUEUE)
CurrPtr      LONG(0) 
FromBuffer   &STRING
DestBuffer   &STRING 
   CODE
   FromBuffer &= NEW STRING( SELF.BufferSize() )   
   DestBuffer &= NEW STRING( SIZE(xDestQ)      )

            !Assert(0,eqDBG&'ctQueue_ThreadSafe.CopyTo SELF.BufferSize()['& SELF.BufferSize() &'] SIZE(SELF.BaseQ)['& SIZE(SELF.BaseQ) &']')

   SELF.ThreadLock.Wait() ! Not Strictly needed, but it seems like a good idea to copy a snapshot
   
      IF xFreeDestFirst
         FREE(xDestQ) ! Warning notice this is an RTL Free, not self.Free() which calls .Del which disposes of References
      END
   
      LOOP WHILE SELF.GetNextRow(CurrPtr, FromBuffer) = NoError
           SELF.CopyQBuffer(DestBuffer  , FromBuffer, xUserData)
               xDestQ =     DestBuffer 
           ADD(xDestQ) 
      END      

   SELF.ThreadLock.Release()

   DISPOSE(FromBuffer)
   DISPOSE(DestBuffer)

!=======================================================================================================================
ctQueue_ThreadSafe.CopyFrom             PROCEDURE(*QUEUE xFromQ , LONG xUserData, BOOL xFreeDestFirst=TRUE) !will use RTL FREE(QUEUE)
CurrPtr      LONG,AUTO
FromBuffer   &STRING
DestBuffer   &STRING 
   CODE
   FromBuffer &= NEW STRING( SIZE(xFromQ)      )   
   DestBuffer &= NEW STRING( SELF.BufferSize() )

            !Assert(0,eqDBG&'ctQueue_ThreadSafe.CopyTo SELF.BufferSize()['& SELF.BufferSize() &'] SIZE(SELF.BaseQ)['& SIZE(SELF.BaseQ) &']')

   SELF.ThreadLock.Wait()
   
      IF xFreeDestFirst
         SELF.Free()
      END
   
      LOOP CurrPtr = 1 TO RECORDS( xFromQ )
           GET( xFromQ, CurrPtr )
           SELF.CopyQBuffer(DestBuffer , xFromQ, xUserData)
               SELF.BaseQ = DestBuffer 
           ADD(SELF.BaseQ) ! do not use SELF.Add(), as that often will NEW child objects that were just built in .CopyQBuffer
      END      

   SELF.ThreadLock.Release()

   DISPOSE(FromBuffer)
   DISPOSE(DestBuffer)

!!=======================================================================================================================
!ctQueue_ThreadSafe.CopyTo            PROCEDURE(*ctQueue xDestQ , LONG xUserData, BOOL xFreeDestFirst=TRUE) !Will call SELF.Free()
!   CODE
!   IF xFreeDestFirst
!      xDestQ.Free()  ! note: IMPORTANT to call .FREE > .DEL   vs.   a SIMPLE FREE(Q)  
!                     ! vs. just passing FreeDestFirst on the *Queue overload                    
!   END
!
!   SELF.CopyTo( xDestQ.BaseQ, FALSE, xUserData)

!=======================================================================================================================
ctQueue_ThreadSafe.CopyTo            PROCEDURE(*ctQueue_ThreadSafe xDestTSQ , LONG xUserData, BOOL xFreeDestFirst=TRUE) !Will call DestQ.Free() - which will call DestQ.Del()...
    CODE 
    xDestTSQ.CopyFrom( SELF, xFreeDestFirst, xUserData )

!=======================================================================================================================
ctQueue_ThreadSafe.CopyFrom          PROCEDURE(*ctQueue_ThreadSafe xFromTSQ , BOOL xFreeDestFirst=TRUE, LONG xUserData) !Will call DestQ.Free() - which will call DestQ.Del()...
CurrPtr      LONG(0) 
FromBuffer   &STRING
DestBuffer   &STRING 
   CODE
   !Assert(0,eqDBG&'ctQueue_ThreadSafe.CopyTo( TSQ ) SELF.BufferSize()['& SELF.BufferSize() &'] SIZE(SELF.BaseQ)['& SIZE(SELF.BaseQ) &']')
   FromBuffer &= NEW STRING( xFromTSQ.BufferSize() ) 
   DestBuffer &= NEW STRING(     SELF.BufferSize() ) 

   ! Should I complain if the queue sizes do not match ?

   SELF.ThreadLock.Wait()

      IF xFreeDestFirst
         SELF.Free()
      END
   
      LOOP WHILE xFromTSQ.GetNextRow(CurrPtr, FromBuffer) = NoError
           SELF.CopyQBuffer( DestBuffer     , FromBuffer, xUserData )
                SELF.BaseQ = DestBuffer
           ADD( SELF.BaseQ) ! do not use SELF.Add(), as that often will NEW child objects that were just built in .CopyQBuffer
      END

   SELF.ThreadLock.Release()

   DISPOSE(FromBuffer)
   DISPOSE(DestBuffer)

  

!=======================================================================================================================
ctQueue_ThreadSafe.CopyQBuffer PROCEDURE(*STRING xTo, STRING xFrom, LONG xUserData)
    ! called by Copy[To|From] intended to be derived to support queues with references 
    CODE 
    xTo = xFrom 




!=======================================================================================================================
ctQueue_ThreadSafe.Dump              PROCEDURE(STRING xPrefix)
CurrPtr    LONG(0)
   CODE
   SELF.ThreadLock.Wait()
                                                                  Assert(0,eqDBG&'v Dumping ['& SELF.Description() &'] - ['& xPrefix &'] .Count['& SELF.Count() &']')
                                                                 !   SELF.ForEach( ctQueue_ThreadSafe.DumpOneRow, xPrefix, QState:Preserve)
      LOOP CurrPtr = 1 TO SELF.Count() 
         GET( SELF.BaseQ, CurrPtr)
         SELF.DumpOneRow( xPrefix )
      END

                                                                  Assert(0,eqDBG&'^ Dumping ['& SELF.Description() &'] - ['& xPrefix &']')
   SELF.ThreadLock.Release()

!=======================================================================================================================
ctQueue_ThreadSafe.ToString          PROCEDURE()!,STRING,VIRTUAL
   CODE
   RETURN 'Row['& POINTER(SELF.BaseQ) &']'
   !stub method, (could write something using reflection...)

!=======================================================================================================================
ctQueue_ThreadSafe.DumpOneRow        PROCEDURE(STRING xPrefix)!,VIRTUAL
   CODE
   Assert(0,eqDBG & xPrefix & ' ' & SELF.ToString() ) 
   !stub method, (could write something using reflection...)

!=======================================================================================================================
!! ForEach !! ctQueue_ThreadSafe.ForEach           PROCEDURE(ftProc_Long_QBuf   xProc  , LONG xUserData)
!! ForEach !! CurrPtr    LONG(0)
!! ForEach !! HoldState  LIKE(gtPtrBuffer)
!! ForEach !!    CODE
!! ForEach !!    SELF.ThreadLock.Wait()
!! ForEach !! 
!! ForEach !!       LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!! ForEach !!          xProc( xUserData, SELF.BaseQ )
!! ForEach !!       END
!! ForEach !! 
!! ForEach !!    SELF.ThreadLock.Release()
!! ForEach !! 
!! ForEach !! 
!! ForEach !! ctQueue_ThreadSafe.ForEach           PROCEDURE(ftMethod_Long_QBuf xMethod, LONG xUserData)
!! ForEach !! CurrPtr    LONG(0)
!! ForEach !! HoldState  LIKE(gtPtrBuffer)
!! ForEach !!    CODE
!! ForEach !!    SELF.ThreadLock.Wait()
!! ForEach !!    
!! ForEach !!       LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!! ForEach !!          xMethod( SELF, xUserData, SELF.BaseQ )
!! ForEach !!       END
!! ForEach !! 
!! ForEach !!    SELF.ThreadLock.Release()
!! ForEach !! 
!! ForEach !! 
!=======================================================================================================================
!! ForEach !! ctQueue_ThreadSafe.ForEach           PROCEDURE(ftProc_String_QBuf   xProc  , STRING xUserData)
!! ForEach !! CurrPtr    LONG(0)
!! ForEach !!    CODE
!! ForEach !!    SELF.ThreadLock.Wait()   
!! ForEach !! 
!! ForEach !!      LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!! ForEach !!         xProc(         xUserData, SELF.BaseQ )
!! ForEach !!      END
!! ForEach !! 
!! ForEach !!    SELF.ThreadLock.Release()
!! ForEach !! 
!! ForEach !! 
!! ForEach !! ctQueue_ThreadSafe.ForEach           PROCEDURE(ftMethod_String_QBuf xMethod, STRING xUserData)
!! ForEach !! CurrPtr    LONG(0)
!! ForEach !!    CODE
!! ForEach !!    SELF.ThreadLock.Wait()
!! ForEach !!    
!! ForEach !!       LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!! ForEach !!          xMethod( SELF, xUserData, SELF.BaseQ )
!! ForEach !!       END
!! ForEach !! 
!! ForEach !!    SELF.ThreadLock.Release()
!! ForEach !! 
!! ForEach !! 
!! ForEach !! ctQueue_ThreadSafe.ForEach           PROCEDURE(ftProc_StarAny_QBuf    xProc  , *?     xUserData)
!! ForEach !! CurrPtr   LONG(0)
!! ForEach !!    CODE
!! ForEach !!    SELF.ThreadLock.Wait()
!! ForEach !! 
!! ForEach !!       LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!! ForEach !!          xProc(        xUserData, SELF.BaseQ )
!! ForEach !!       END
!! ForEach !! 
!! ForEach !!    SELF.ThreadLock.Release()
!! ForEach !! 
!! ForEach !! ctQueue_ThreadSafe.ForEach           PROCEDURE(ftMethod_StarAny_QBuf  xMethod, *?     xUserData)   
!! ForEach !! CurrPtr   LONG(0)
!! ForEach !!    CODE
!! ForEach !!    SELF.ThreadLock.Wait()   
!! ForEach !! 
!! ForEach !!       LOOP WHILE SELF.GetNextRow(CurrPtr)=NoError
!! ForEach !!          xMethod( SELF, xUserData, SELF.BaseQ )
!! ForEach !!       END
!! ForEach !! 
!! ForEach !!    SELF.ThreadLock.Release()
!! ForEach !! 

!=======================================================================================================================
!ctQueue_ThreadSafe.QState_Save         PROCEDURE(*gtPtrBuffer xgPtrBuffer)
!   CODE
!   xgPtrBuffer.Ptr = SELF.Pointer()
!   xgPtrBuffer.Buf = SELF.BaseQ
!
!=======================================================================================================================
!ctQueue_ThreadSafe.QState_Restore      PROCEDURE(*gtPtrBuffer xgPtrBuffer)
!   CODE
!   SELF.GetRow(xgPtrBuffer.Ptr) 
!   SELF.BaseQ = xgPtrBuffer.Buf


