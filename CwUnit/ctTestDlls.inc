
	INCLUDE(     'ctQueue.inc'),ONCE
	INCLUDE('ctFileHelper.inc'),ONCE
   INCLUDE(  'ctAllTests.inc'),ONCE
   INCLUDE(   'DataTypes.equ'),ONCE
   INCLUDE(     'ICwUnit.int'),ONCE
	INCLUDE(      'errors.clw'),ONCE
   INCLUDE('ctResultSets.inc'),ONCE 
   INCLUDE(   'ctLoggers.inc'),ONCE


gtTestDLLBase GROUP,TYPE      !designed for injecting into ctResultSets
FileHelper       &ctFileHelper
CwUnit           &ICwUnit
hLib             HMODULE
LoadError        LONG
				  END
gtTestDLL	  GROUP(gtTestDLLBase),TYPE  
AllTests         &ctAllTests
				  END

qtTestDLL     QUEUE(gtTestDLL)
			     END



ctTestDLLs CLASS(ctQueue),TYPE,MODULE('ctTestDLLs.clw'),LINK('ctTestDLLs.clw')
Q                             &qtTestDLL
ResultSets                    &ctResultSets
Loggers                       &ctLoggers,PRIVATE !Injected
LoggersInjected               BOOL,PRIVATE
!----------
CONSTRUCT                      PROCEDURE()
DESTRUCT                       PROCEDURE()
Del                            PROCEDURE,DERIVED
Description                    PROCEDURE(),STRING,DERIVED
Init                           PROCEDURE(*ctLoggers Loggers)

Add                            PROCEDURE(STRING FileName)

LoadAllTests                   PROCEDURE()
RunAllTests                    PROCEDURE()
UnLoadAllTests                 PROCEDURE()

LoadTests                      PROCEDURE(*gtTestDLL TestDLL)
RunTests                       PROCEDURE(*ctAllTests AllTests, LONG ResultSetID)
UnLoadTests                    PROCEDURE(*gtTestDLL TestDLL)

Get_ICwUnit                    PROCEDURE(*gtTestDLL TestDLL),BOOL,PROC !TRUE when ICwUnit was found and set
FreeLibrary                    PROCEDURE(*gtTestDLL TestDLL)
LogResults                     PROCEDURE(*gtTestMethodWithResults OneTest),VIRTUAL 
       END



