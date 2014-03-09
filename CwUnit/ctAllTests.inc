   INCLUDE(       'ctQueue.inc'),ONCE
   INCLUDE('ctTimedResults.inc'),ONCE
   INCLUDE(     'DataTypes.equ'),ONCE
   INCLUDE(       'ICwUnit.int'),ONCE !for CwUnit_gtTestCase


gtTestMethodWithResults  GROUP(CwUnit_gtTestMethod),TYPE  !TODO: Rename to ____  
TimedResults                &ctTimedResults
                         END

qtTestMethodWithResults QUEUE(gtTestMethodWithResults),TYPE
					         END

ctAllTests 		CLASS(ctQueue),TYPE,MODULE('ctAllTests.clw'),LINK('ctAllTests.clw')
Q                       &qtTestMethodWithResults
!----------                    
CONSTRUCT               PROCEDURE()
DESTRUCT                PROCEDURE()
Del                     PROCEDURE,DERIVED
Description             PROCEDURE(),STRING,DERIVED
Run                     PROCEDURE(LONG ResultSetID, *CwUnit_gtTestMethod TestMethod)
Add                     PROCEDURE(            CONST *CwUnit_gtTestMethod TestMethodFromDLL)
       			END
