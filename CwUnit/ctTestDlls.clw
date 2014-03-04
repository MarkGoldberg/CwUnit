  MEMBER()
  INCLUDE('ctTestDLLs.inc'),ONCE

  MAP
  		 MODULE('')
            LoadLibrary    (         CONST *CSTRING),HMODULE,PASCAL,NAME('LoadLibraryA')
            FreeLibrary    (HMODULE                ),BOOL,PASCAL,PROC
            GetProcAddress (HMODULE, CONST *CSTRING),LONG,PASCAL
		 END
  END
  
fpGetInterface INT_PTR,NAME('GetInterface'),STATIC	!Must be STATIC (all modular data is static)
	MAP
	   MODULE('LoadLibary')
		    GetInterface(INT_PTR UserData),*ICwUnit  ,NAME('GetInterface'),DLL(1)
		END
	END


!=====================================
ctTestDLLs.CONSTRUCT                      PROCEDURE()
   CODE  
   SELF.Q          &= NEW qtTestDLL
   SELF.BaseQ      &= SELF.Q
   SELF.ResultSets &= NEW ctResultSets
   
   SELF.Loggers    &= NEW ctLoggers  !Empty to be REPLACED in .init - this allows me to say SELF.Loggers.* without having to constantly check for &= NULL
   SELF.LoggersInjected = FALSE
   
!=====================================
ctTestDLLs.DESTRUCT                       PROCEDURE()
   CODE
   DISPOSE(SELF.ResultSets)
   IF NOT SELF.LoggersInjected 
      DISPOSE(SELF.Loggers)
   END

!=====================================
ctTestDLLs.Del                            PROCEDURE() !,DERIVED
	CODE
	SELF.FreeLibrary(SELF.Q)
	DISPOSE(SELF.Q.FileHelper)
	DISPOSE(SELF.Q.AllTests)
	PARENT.Del()
!=====================================
ctTestDLLs.Description                    PROCEDURE() !,STRING,DERIVED
	CODE
	RETURN 'ctTestDLLs'
	
!=====================================
ctTestDLLs.Init                           PROCEDURE(*ctLoggers Loggers)	
	CODE
	IF ADDRESS(SELF.Loggers) <> ADDRESS(Loggers)
	   DISPOSE(SELF.Loggers)
	   SELF.Loggers &= Loggers
	   SELF.LoggersInjected = TRUE
	END

!Region LoadLibary Related	Methods
!=====================================
ctTestDLLs.Get_ICwUnit                    PROCEDURE(*gtTestDLL TestDLL)!,BOOL,PROC !TRUE when ICwUnit was found and set
szFileName     CSTRING(FILE:MaxFilePath)
szGet_ICwUnit  CSTRING(ExportName:Get_ICwUnit),STATIC !Not required to be static, but it never changes...
HoldPath       STRING(FILE:MaxFilePath)
   CODE   																	
   szFileName = TestDLL.FileHelper.WholeFileName()                     ;SELF.Loggers.DebugLog('v  ctTestDLLs.Get_ICwUnit File['& szFileName &']')
   TestDLL.CwUnit &= NULL                                               
   TestDLL.hLib    = 0   

   IF  ~ TestDLL.FileHelper.Exists()                     
         TestDLL.LoadError = NoFileErr
           
	ELSIF UPPER(TestDLL.FileHelper.Extension()) <> '.DLL' 
	      TestDLL.LoadError = BadFileErr
	      
   ELSE
   		TestDLL.LoadError = NoError   		
   		HoldPath = LONGPATH()
   		SETPATH(TestDLL.FileHelper.DriveDir() )   !<-------- Is this a good idea - probably - as the DLL may have DLL dependencies which it would look for in it's current folder. (guessing at this behavior)
   		
			szFileName = TestDLL.FileHelper.WholeFileName()
			TestDLL.hLib = LoadLibrary( szFileName )                          ;SELF.Loggers.DebugLog('  ctTestDLLs.Get_ICwUnit -  v LoadLibrary')
			IF TestDLL.hLib <> 0                                              ;SELF.Loggers.DebugLog('  ctTestDLLs.Get_ICwUnit -  ^ LoadLibrary')
			   szGet_ICwUnit  = UPPER(szGet_ICwUnit) 
				fpGetInterface = GetProcAddress(TestDLL.hLib, szGet_ICwUnit)   ;SELF.Loggers.DebugLog('  ctTestDLLs.Get_ICwUnit -  fpGetInterface['& fpGetInterface &']')
				IF fpGetInterface <> 0 
					TestDll.CwUnit &= GetInterface(47)			        	         ;SELF.Loggers.DebugLog('  ctTestDLLs.Get_ICwUnit - Interface Type[' & TestDll.CwUnit.InterfaceType() &']')
				ELSE
				 	SELF.Loggers.Log('Failed to find GET_ICwUnit in ['& szFileName &']')
				END
			END
			SETPATH(HoldPath)		
   END			
   																	                     ;SELF.Loggers.DebugLog('^  ctTestDLLs.Get_ICwUnit File['& szFileName &'] Returning['& CHOOSE( NOT TestDLL.CwUnit &= NULL) &']')
   RETURN CHOOSE( NOT TestDLL.CwUnit &= NULL)
   
!=====================================
ctTestDLLs.FreeLibrary                    PROCEDURE(*gtTestDLL TestDLL)
	CODE
	                                    ; SELF.Loggers.DebugLog('v ctTestDLLs.FreeLibrary TestDLL.hLib['& TestDLL.hLib &']')
	IF TestDLL.hLib 
	   FreeLibrary(TestDLL.hLib)
	END
   !TestDLL.hLib    = 0
   !TestDLL.CwUnit &= NULL
   
!EndRegion LoadLibary Related	Methods

!=====================================
ctTestDLLs.Add                            PROCEDURE(STRING FileName)
	CODE
	CLEAR(SELF.Q)
	SELF.Q.FileHelper &= SELF.Q.FileHelper.NewAndSetFileName(FileName) !Static Notation 	
	SELF.Q.AllTests   &= NEW ctAllTests
	SELF.Q.CwUnit     &= NULL
	SELF.Q.hLib        = 0
	SELF.Q.LoadError   = NoError
	ADD(SELF.Q)


!=====================================
ctTestDLLs.LoadAllTests PROCEDURE()
QPtr LONG,AUTO
TheError  LONG,AUTO
  CODE  
  LOOP QPtr = 1 TO SELF.Records()
     SELF.GetByPtr(QPtr)
     SELF.LoadTests( SELF.Q ) !Pass Q as Group
     PUT(SELF.Q)
  END  
!=====================================
ctTestDLLs.RunAllTests PROCEDURE() 
QPtr        LONG,AUTO
ResultSetID LIKE(gtResultSets.SetID)
  CODE    
  															                           SELF.Loggers.DebugLog('v ctTestDLLs.RunAllTests')
  LOOP QPtr = 1 TO SELF.Records()
     SELF.GetByPtr(QPtr)                                              ; SELF.Loggers.DebugLog('  ctTestDLLs.RunAllTests        QPtr['& Qptr &']')     
     ResultSetID = SELF.ResultSets.Starting( SELF.Q.FileHelper)       ; SELF.Loggers.DebugLog('  ctTestDLLs.RunAllTests ResultSetID['& ResultSetID &']')     
     SELF.RunTests( SELF.Q.AllTests, ResultSetID )                    !Pass Q as Group
     						                                                 ; SELF.Loggers.DebugLog('  ctTestDLLs.RunAllTests After RunTests')     
     SELF.ResultSets.Finished()
  END  
                           															SELF.Loggers.DebugLog('^ ctTestDLLs.RunAllTests')
!=====================================
ctTestDLLs.UnLoadAllTests PROCEDURE()
QPtr      LONG,AUTO
  CODE  
  												   ;SELF.Loggers.DebugLog('v ctTestDLLs.UnLoadAllTests')
  LOOP QPtr = 1 TO SELF.Records()
     SELF.GetByPtr(QPtr)
     SELF.UnLoadTests( SELF.Q ) !Pass Q as Group
     PUT(SELF.Q)
  END  
  	  											   ;SELF.Loggers.DebugLog('  ctTestDLLs.UnLoadAllTests')
  SELF.FreeLibrary(SELF.Q)  			   ;SELF.Loggers.DebugLog('^ ctTestDLLs.UnLoadAllTests')


!=====================================
ctTestDLLs.LoadTests PROCEDURE(*gtTestDLL TestDLL)
	CODE
	                                    ;SELF.Loggers.DebugLog('v  ctTests.LoadTests - '& TestDLL.FileHelper.ToString() )
	IF SELF.Get_ICwUnit(TestDLL)
		DO LoadTests:LoadFromDLL
	!	                                  SELF.Loggers.DebugLog('!!!Disabled .FreeLibary in ctTestDLLs.LoadTests')
   !	!SELF.FreeLibrary(TestDLL)       !See UnLoadAllTests()
	ELSE
		SELF.Loggers.Log('CWTest Interface not found for DLL['& TestDLL.FileHelper.WholeFileName() &']')
	END
	                                    ;SELF.Loggers.DebugLog('^  ctTests.LoadTests - '& TestDLL.FileHelper.ToString() )

!=====================================
LoadTests:LoadFromDLL	ROUTINE
	DATA
QPtr            LONG,AUTO
AllTests        &ctAllTests
OneTestFromDLL  LIKE(gtOneTestFromDLL)
	CODE
	AllTests &= SELF.Q.AllTests
	
	LOOP QPtr = 1 TO SELF.Q.CWUnit.GetTestCount() 
	   CLEAR(                         OneTestFromDLL )
		IF SELF.Q.CWUnit.GetTest(QPtr, OneTestFromDLL )	= NoError
		    AllTests.Add(              OneTestFromDLL ) 		
		END
	END

	
!=====================================
ctTestDLLs.RunTests                       PROCEDURE(*ctAllTests AllTests, LONG ResultSetID)	
QPtr LONG,AUTO
	CODE
															;SELF.Loggers.DebugLog('v  ctTestDLLs.RunTests')
	LOOP QPtr = 1 TO AllTests.Records()
		AllTests.GetByPtr(QPtr)          ;SELF.Loggers.DebugLog('   ctTestDLLs.RunTests QPtr['& QPtr &'] About to run: Category['& AllTests.Q.Category &']  Test['& AllTests.Q.TestName &']')
		AllTests.Run(ResultSetID)		  
		SELF.LogResults(AllTests.Q)		 
	END
															;SELF.Loggers.DebugLog('^  ctTestDLLs.RunTests')	

!=====================================	
ctTestDLLs.LogResults                     PROCEDURE(*gtOneTest  OneTest)!,VIRTUAL
   !Assumes TimedResults.Q is aligned
	CODE
	SELF.Loggers.Log('Category['& OneTest.Category &']  Test['& OneTest.TestName &']')
	SELF.Loggers.Log('  Result['& OneTest.TimedResults.Q.OneResult.StatusToString() &']')
	SELF.Loggers.Log('  Output['& OneTest.TimedResults.Q.OneResult.Output           &']')
	SELF.Loggers.Log('-{47}')
!=====================================
ctTestDLLs.UnLoadTests PROCEDURE(*gtTestDLL TestDLL)
	CODE	
	!Nothing todo
!	                               ;SELF.Loggers.DebugLog('v  ctTests.UnLoadTests - '& TestDLL.FileHelper.ToString() )
!   IF SELF.Get_ICwUnit(TestDLL)	                               
!  	   DO UnLoadTests:UnloadFromDLL 
!      SELF.FreeLibrary(TestDLL)
!  	ELSE
!      SELF.Loggers.Log('CWTest Interface not found for DLL['& TestDLL.FileHelper.WholeFileName() &']')
!   END
!	                               ;SELF.Loggers.DebugLog('^  ctTests.UnLoadTests - '& TestDLL.FileHelper.ToString() )
!	
!UnLoadTests:UnloadFromDLL 	ROUTINE	
!   SELF.Loggers.DebugLog('ctTestDLLs.UnLoadTests:UnloadFromDLL  Under Construction')
!	!MESSAGE('Unload From DLL UnderConstruction') !TODO: UnderConstruction - UnLoadTests:UnloadFromDLL
