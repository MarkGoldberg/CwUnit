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
   DELETE(SELF.BaseQ)

!------------------------------------------------------------------------------------------------------  
ctQueue.Put                PROCEDURE
   CODE 
   PUT(SELF.BaseQ)

!------------------------------------------------------------------------------------------------------	
ctQueue.Records				PROCEDURE()!,LONG
	CODE
	                     COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)   	
   !   Assert(0,eqDBG& SELF.Description() & 'Records['& RECORDS(SELF.BaseQ) &']')
                   !END-COMPILE('*** AssertHookDebugging ***', AssertHookDebugging)
   
	RETURN RECORDS(SELF.BaseQ)


!------------------------------------------------------------------------------------------------------	
ctQueue.GetByPtr				PROCEDURE(LONG xPointer)
	CODE
	GET(SELF.BaseQ, xPointer)
	RETURN ErrorCode()

!------------------------------------------------------------------------------------------------------	
ctQueue.NextByPtr			PROCEDURE()
	CODE
	RETURN SELF.GetByPtr( POINTER(SELF.BaseQ) + 1)
	
