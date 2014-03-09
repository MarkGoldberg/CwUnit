     INCLUDE('DataTypes.equ'),ONCE !for Enum

!Inspired by Assertions found in nUnit 

!http://www.nunit.com/index.php?p=comparisonAsserts&r=2.6.2
! "...  Contrary to the normal order of Asserts, 
!           these methods are designed to be read in the "natural" English-language or mathematical order. 
!           Thus Assert.GreaterOrEqual( x, y ) asserts that x is greater than or equal to y ( x >= y ). 
! ..."


OperatorTypeEnum       EQUATE(Enum)
OperatorType:Unknown   EQUATE(0)
OperatorType:Unary     EQUATE(1)
OperatorType:Binary    EQUATE(2)


!------ BinaryOperators
Is:StartsWith          EQUATE('StartsWith')
Is:Contains            EQUATE('Contains')
Is:EndsWith            EQUATE('EndsWith')

Is:EqualTo             EQUATE('=')
Is:NotEqualTo          EQUATE('<>')
Is:GreaterThan         EQUATE('>')
Is:GreaterThanOrEqual  EQUATE('>=')
Is:LessThan            EQUATE('<')
Is:LessThanOrEqual     EQUATE('<=')
!------ BinaryOperators - Aliases
Is:EQ                  EQUATE(Is:EqualTo           )
Is:NE                  EQUATE(Is:NotEqualTo        )
Is:GT                  EQUATE(Is:GreaterThan       )
Is:GE                  EQUATE(Is:GreaterThanOrEqual)
Is:LT                  EQUATE(Is:LessThan          )
Is:LE                  EQUATE(Is:LessThanOrEqual   )
!------ UnaryOperators
!Is:Null                EQUATE('IsNull')
!Is:NotNull             EQUATE('IsNotNull')
Is:True                EQUATE('IsTrue')  !really IsNotFalse
Is:False               EQUATE('IsFalse')


StatusEnum             EQUATE(Enum)
Status:NotRun          EQUATE(0)
Status:Pass            EQUATE(1)  !Compatible with DCL_ClarionTest_Status_Pass
Status:Fail            EQUATE(2)  !Compatible with DCL_ClarionTest_Status_Fail
Status:Ignore          EQUATE(3)  !Compatible with DCL_ClarionTest_Status_Ignore
Status:Inconclusive    EQUATE(4)
Status:Running         EQUATE(5)
Status:Missing         EQUATE(6)


CwUnit_gtResult        GROUP,TYPE
Status                       StatusEnum
Output                       ANY 
Data1                        ANY !Copied from gtTestCase.Data1    !Be Careful, about One Test having an effect on another
Data2                        ANY !Copied from gtTestCase.Data2    !Be Careful, about One Test having an effect on another
                       END


CwUnit_ctResult CLASS(CwUnit_gtResult),TYPE,MODULE('ctOneResult.clw'),LINK('ctOneResult.clw')
CONSTRUCT        PROCEDURE
DESTRUCT         PROCEDURE

StatusToString   PROCEDURE(),STRING
StatusToString   PROCEDURE(LONG Status),STRING
DefaultOutput    PROCEDURE(*? LHS, STRING Operator, <*? RHS>),STRING,VIRTUAL
!---
SetStatus        PROCEDURE(LONG NewStatus, STRING Operator, <? Output>, ? DefaultOutput )
SetStatus        PROCEDURE(LONG NewStatus, <? Output>)
Pass             PROCEDURE(                <? Output>)
Fail             PROCEDURE(                <? Output>)
Ignore           PROCEDURE(                <? Output>)
Inconclusive     PROCEDURE(                <? Output>)
!---


GetOperatorType  PROCEDURE(STRING Operator),OperatorTypeEnum

Evaluate         PROCEDURE(*? Actual, STRING  UnaryOperator         ),BOOL !UnaryOperator
Evaluate         PROCEDURE(*? LHS   , STRING       Operator, ? RHS  ),BOOL !BinaryOperator

PassesWhen       PROCEDURE(? LHS   , STRING       Operator, <? RHS>, <? Passed>, <? Failed> ),StatusEnum,PROC
FailsWhen        PROCEDURE(? LHS   , STRING       Operator, <? RHS>, <? Passed>, <? Failed> ),StatusEnum,PROC
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
StartsWith       PROCEDURE(? LookFor , ? LookIn         , <? Passed>, <? Failed> )
Contains         PROCEDURE(? LookFor , ? LookIn         , <? Passed>, <? Failed> )
EndsWith         PROCEDURE(? LookFor , ? LookIn         , <? Passed>, <? Failed> )

!IsNullToString   PROCEDURE(*? Object),STRING
!IsNull           PROCEDURE(           *? Object         , <? Passed>, <? Failed> )
!IsNotNull        PROCEDURE(           *? Object         , <? Passed>, <? Failed> )
            END
!With Strings in mind, caller can handle CLIP() and UPPER()


