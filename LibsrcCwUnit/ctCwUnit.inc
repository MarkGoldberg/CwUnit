
  INCLUDE('ICwUnit.int'),ONCE
  
qtOneTestFromDLL        QUEUE(gtOneTestFromDLL),TYPE  !gtOneTest is declared in ICwUnit.int
                        END  
  
ctCwUnit	   CLASS,TYPE,IMPLEMENTS(ICwUnit),MODULE('ctCwUnit.clw'),LINK('ctCwUnit.clw')
Tests               &qtOneTestFromDLL
CONSTRUCT           PROCEDURE
DESTRUCT            PROCEDURE
Setup               PROCEDURE(INT_PTR UserData),VIRTUAL
TearDown            PROCEDURE(),VIRTUAL
GetICwUnit          PROCEDURE(INT_PTR UserData),*ICwUnit
AddTest		        PROCEDURE(STRING Category, STRING TestName,  INT_PTR ProcedureAddress, INT_PTR UserData1, INT_PTR UserData2=0)	
Find                PROCEDURE(STRING Category, STRING TestName),LONG,PROC !Returns ErrorCode()
			   END  

