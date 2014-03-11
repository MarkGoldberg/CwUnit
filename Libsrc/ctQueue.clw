	MEMBER
	MAP
	END
	INCLUDE('ctQueue.inc'),ONCE

                       	COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
eqDBG EQUATE('<4,2,7>') 
                   !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
!------------------------------------------------------------------------------------------------------	
ctQueue.CONSTRUCT			PROCEDURE
	CODE 
	!SELF.BaseQ &= NEW qt

!------------------------------------------------------------------------------------------------------	
ctQueue.DESTRUCT				PROCEDURE
	CODE 
	                     COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
  !                  Assert(0,eqDBG&'v ctQueue.DESTRUCT ['& SELF.Description() &'] SELF.BaseQ['& CHOOSE(SELF.BaseQ&=NULL,'IsNull','Ok') &'] Addr['& ADDRESS(SELF) &']')
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
	   GET(SELF.BaseQ, 1)
	   IF ERRORCODE() THEN BREAK END
	   SELF.Del()
	END
					      COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
                       Assert(0,eqDBG&'^ ctQueue.Free ['& SELF.Description() &'] Records['& SELF.Records() &']')     
                   !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
   
!------------------------------------------------------------------------------------------------------	
ctQueue.Del					PROCEDURE
	CODE 
?  ASSERT( ~SELF.BaseQ &= NULL, '.Q is null in .Del')
   CLEAR (SELF.BaseQ)
   DELETE(SELF.BaseQ)

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
   !   Assert(0,eqDBG& SELF.Description() & 'Records['& RECORDS(SELF.BaseQ) &']')
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
ctQueue.GetPrevRow        PROCEDURE(<*BOOL IsFirstTime>)!,LONG,PROC !returns ErrorCode
   CODE
   IF ~OMITTED(IsFirstTime) AND IsFirstTime
      IsFirstTime = FALSE
      RETURN SELF.GetLastRow()
   END      
   RETURN SELF.GetRow( POINTER(SELF.BaseQ) - 1)

!------------------------------------------------------------------------------------------------------	
ctQueue.GetNextRow        PROCEDURE(<*BOOL IsFirstTime>)!,LONG,PROC !returns ErrorCode
	CODE
   IF ~OMITTED(IsFirstTime) AND IsFirstTime
      IsFirstTime = FALSE
      RETURN SELF.GetFirstRow()
   END      
   
	RETURN SELF.GetRow( POINTER(SELF.BaseQ) + 1)

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
FirstTime  BOOL(TRUE) !Signal, GetRow(1) on the first pass
   CODE
   HoldPtr    = POINTER(SELF.BaseQ)
   HoldBuffer = SELF.BaseQ

   IF FreeDestFirst
      FREE(DestQ) 
   END

   LOOP WHILE SELF.GetNextRow(FirstTime)
        DestQ = SELF.BaseQ
        ADD(DestQ)
   END      

   SELF.GetRow(HoldPtr)
   SELF.BaseQ = HoldBuffer
