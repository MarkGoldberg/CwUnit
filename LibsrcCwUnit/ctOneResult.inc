
!Inspired by Assertions found in nUnit 

!http://www.nunit.com/index.php?p=comparisonAsserts&r=2.6.2
! "...  Contrary to the normal order of Asserts, 
!           these methods are designed to be read in the "natural" English-language or mathematical order. 
!           Thus Assert.GreaterOrEqual( x, y ) asserts that x is greater than or equal to y ( x >= y ). 
! ..."

Op:EqualTo             EQUATE('=')
Op:NotEqualTo          EQUATE('<>')
Op:GreaterThan         EQUATE('>')
Op:GreaterThanOrEqual  EQUATE('>=')
Op:LessThan            EQUATE('<')
Op:LessThanOrEqual     EQUATE('<=')
Op:IsNull              EQUATE('IsNull')
Op:IsNotNull           EQUATE('IsNotNull')
Op:StartsWith          EQUATE('StartsWith')
Op:Contains            EQUATE('Contains')
Op:EndsWith            EQUATE('EndsWith')
Op:IsTrue              EQUATE('IsTrue')  !really IsNotFalse
Op:IsFalse             EQUATE('IsTrue')


Status:NotRun       EQUATE(0)
Status:Pass         EQUATE(1)  !Compatible with DCL_ClarionTest_Status_Pass
Status:Fail         EQUATE(2)  !Compatible with DCL_ClarionTest_Status_Fail
Status:Ignore       EQUATE(3)  !Compatible with DCL_ClarionTest_Status_Ignore
Status:Inconclusive EQUATE(4)
Status:Running      EQUATE(5)
Status:Missing      EQUATE(6)


gtOneResult GROUP,TYPE
ResultSetID       LONG !LIKE(gtResultSets.SetID)
Status            LONG  
Output            ANY 
            END



ctOneResult CLASS(gtOneResult),TYPE,MODULE('ctOneResult.clw'),LINK('ctOneResult.clw')
CONSTRUCT        PROCEDURE
DESTRUCT         PROCEDURE

StatusToString   PROCEDURE(),STRING
StatusToString   PROCEDURE(LONG Status),STRING
DefaultOutput    PROCEDURE(? LHS, STRING Operator, <? RHS>),STRING,VIRTUAL
!---
SetStatus        PROCEDURE(LONG NewStatus, STRING Operator, <? Output>, ? DefaultOutput )
SetStatus        PROCEDURE(LONG NewStatus, <? Output>)
Pass             PROCEDURE(                <? Output>)
Fail             PROCEDURE(                <? Output>)
Ignore           PROCEDURE(                <? Output>)
Inconclusive     PROCEDURE(                <? Output>)
!---
Is               PROCEDURE(? Actual, STRING Operator,        <? Passed>, <? Failed> ) ! Uses natural order, so Test.Is(5, Op:LessThan, 8) will return a Status:Pass
Is               PROCEDURE(? LHS   , STRING Operator, ? RHS, <? Passed>, <? Failed> ) ! Uses natural order, so Test.Is(5, Op:LessThan, 8) will return a Status:Pass
PassFail         PROCEDURE(BOOL TestPassed, ? LHS, STRING Operator, <? RHS>, <? Passed>, <? Failed> )

!---
Equal            PROCEDURE(? Expected, ? Actual         , <? Passed>, <? Failed> )
NotEqual         PROCEDURE(? Expected, ? Actual         , <? Passed>, <? Failed> )
Greater          PROCEDURE(? Actual   ,? CompareTo      , <? Passed>, <? Failed> ) !Pass when:  Actual >  CompareTo
GreaterOrEqual   PROCEDURE(? Actual   ,? CompareTo      , <? Passed>, <? Failed> ) !Pass when:  Actual >= CompareTo
Less             PROCEDURE(? Actual   ,? CompareTo      , <? Passed>, <? Failed> ) !Pass when:  Actual <  CompareTo
LessOrEqual      PROCEDURE(? Actual   ,? CompareTo      , <? Passed>, <? Failed> ) !Pass when:  Actual <= CompareTo
IsTrue           PROCEDURE(            ? Actual         , <? Passed>, <? Failed> )
IsFalse          PROCEDURE(            ? Actual         , <? Passed>, <? Failed> )
IsNull           PROCEDURE(           *? Actual         , <? Passed>, <? Failed> )
IsNotNull        PROCEDURE(           *? Actual         , <? Passed>, <? Failed> )
StartsWith       PROCEDURE(? LookFor , ? LookIn         , <? Passed>, <? Failed> )
Contains         PROCEDURE(? LookFor , ? LookIn         , <? Passed>, <? Failed> )
EndsWith         PROCEDURE(? LookFor , ? LookIn         , <? Passed>, <? Failed> )
            END
!With Strings in mind, caller can handle CLIP() and UPPER()


