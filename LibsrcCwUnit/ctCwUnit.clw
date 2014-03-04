
  MEMBER()
  INCLUDE('ctCwUnit.inc'),ONCE
  MAP
  END

NoError EQUATE(0) !or do an INCLUDE('Errors.clw'),ONCE  
  
!Region ctCwUnit Methods  

ctCwUnit.GetICwUnit 	         PROCEDURE(INT_PTR UserData) !,*ICwUnit
	CODE
	SELF.Setup(UserData)
	RETURN SELF.ICwUnit
	
ctCwUnit.CONSTRUCT           PROCEDURE()
	CODE
	SELF.Tests   &= NEW qtOneTestFromDLL	
	SELF.Setup(0)

ctCwUnit.DESTRUCT            PROCEDURE()
	CODE
	SELF.TearDown()
	IF NOT     SELF.Tests &= NULL
	   FREE   (SELF.Tests) 
	   DISPOSE(SELF.Tests)
	END
	
ctCwUnit.Setup               PROCEDURE(INT_PTR UserData)!,VIRTUAL
	CODE
	!Stub - should be derived
ctCwUnit.TearDown            PROCEDURE()!,VIRTUAL
	CODE
	!Stub - should be derived
	
ctCwUnit.AddTest		       PROCEDURE(STRING Category, STRING TestName,  INT_PTR ProcedureAddress, INT_PTR UserData1, INT_PTR UserData2=0)	
   !Somewhat strange ordering of parameters: done to avoid "parameter ambiguous" errors, and allow omittiable UserData Parameters
	CODE
	SELF.Tests.Category         = Category
	SELF.Tests.TestName         = TestName
	SELF.Tests.ProcedureAddress = ProcedureAddress
	SELF.Tests.UserData1        = UserData1
	SELF.Tests.UserData2        = UserData2
	ADD(SELF.Tests)


ctCwUnit.Find               PROCEDURE(STRING Category, STRING TestName)!,LONG,PROC !Returns ErrorCode()
	CODE
	SELF.Tests.Category = Category
	SELF.Tests.TestName = TestName
	ADD(SELF.Tests, SELF.Tests.Category, SELF.Tests.TestName)
	RETURN ERRORCODE()

!Region ICwUnit Methods  
  
ctCwUnit.ICwUnit.InterfaceType           PROCEDURE()!,STRING
	CODE
	RETURN 'Base'
	
ctCwUnit.ICwUnit.GetTestCount            PROCEDURE() 
	CODE
	RETURN RECORDS(SELF.Tests)

ctCwUnit.ICwUnit.GetTest                 PROCEDURE(LONG TestNum, *gtOneTestFromDLL outOneTest)!,LONG Returns ErrorCode
RetError LONG,AUTO
	CODE
	GET(SELF.Tests, TestNum)
	RetError = ERRORCODE()
	IF RetError = NoError	
   	outOneTest = SELF.Tests  !Queue Buffer as a Group
   END
   RETURN RetError


!EndRegion ICwUnit Methods  

!EndRegion ctCwUnit Methods  

!

