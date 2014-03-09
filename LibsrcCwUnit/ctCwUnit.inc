
  INCLUDE('ICwUnit.int'),ONCE
  INCLUDE('ctQueue.inc'),ONCE
  
CwUnit_qtTestMethod QUEUE(CwUnit_gtTestMethod),TYPE  !gtOneTest is declared in ICwUnit.int
                    END  
  
CwUnit_ctTestSuite  CLASS(ctQueue),TYPE,IMPLEMENTS(ICwUnit),MODULE('ctCwUnit.clw'),LINK('ctCwUnit.clw')
Tests               &CwUnit_qtTestMethod
CONSTRUCT           PROCEDURE
DESTRUCT            PROCEDURE
!Del                 PROCEDURE,DERIVED
Description         PROCEDURE(),STRING,DERIVED

Setup               PROCEDURE(INT_PTR UserData),VIRTUAL
TearDown            PROCEDURE(),VIRTUAL
GetICwUnit          PROCEDURE(INT_PTR UserData),*ICwUnit
AddTest		        PROCEDURE(STRING Category, STRING TestName, INT_PTR _SELF, INT_PTR ProcedureAddress, <? Data1>, <? Data2>)	
Find                PROCEDURE(STRING Category, STRING TestName),LONG,PROC !Returns ErrorCode()

			   END  

