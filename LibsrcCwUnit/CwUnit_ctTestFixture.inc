   
     INCLUDE('ctCwUnit.inc'),ONCE

CwUnit_ctTestFixture CLASS,TYPE,MODULE('CwUnit_ctTestFixture.clw'),LINK('CwUnit_ctTestFixture.clw')
TestSuite             &CwUnit_ctTestSuite
Category              LIKE(CwUnit_gtTestMethod.Category)
!----------
Init                  PROCEDURE(*CwUnit_ctTestSuite TestSuite, STRING Category)
AddCategoryAndTest    PROCEDURE(STRING Category, STRING TestName, INT_PTR MethodAddress, <? Data1>, <? Data2>)
AddTest               PROCEDURE(                 STRING TestName, INT_PTR MethodAddress, <? Data1>, <? Data2>)

!SetupFixture          PROCEDURE(),VIRTUAL  --- just use CONSTRUCT, unless want to control timing
!SetupTest             PROCEDURE(),VIRTUAL
!RunTest               PROCEDURE(STRING TestName, INT_PTR MethodAddress, INT_PTR UserData2),VIRTUAL
!TeardownTest          PROCEDURE(),VIRTUAL
!TeardownFixture       PROCEDURE(),VIRTUAL  --- just use DESTRUCT, unless want to control timing
                     END
 
                     
