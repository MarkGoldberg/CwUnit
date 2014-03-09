
   MEMBER
   MAP
   END
   INCLUDE('CtOneResult.inc'),ONCE

!    INCLUDE('ctOutputDebugString.inc'),ONCE
!MOD:ODS      ctOutputDebugString


!==============================================================================
CwUnit_ctResult.CONSTRUCT        PROCEDURE
	CODE
	CLEAR(SELF.Output)
!==============================================================================
CwUnit_ctResult.DESTRUCT         PROCEDURE
   !Q: Do we need to clear the ANY's ? 
   !A: Not sure, but it can't hurt
 	CODE
 	CLEAR(SELF.Output) 
   CLEAR(SELF.Data1)
   CLEAR(SELF.Data2)
 	
 	
!==============================================================================
CwUnit_ctResult.StatusToString   PROCEDURE()!,STRING
	CODE
	RETURN SELF.StatusToString(SELF.Status)
	
!==============================================================================
CwUnit_ctResult.StatusToString   PROCEDURE(LONG Status)!,STRING
Answer CSTRING(20)
 CODE
 CASE Status
	OF Status:NotRun       ; Answer='NotRun'
	OF Status:Pass         ; Answer='Pass'
	OF Status:Fail         ; Answer='Fail'
	OF Status:Ignore       ; Answer='Ignore'
	OF Status:Inconclusive ; Answer='Inconclusive'
	OF Status:Running      ; Answer='Running'
	OF Status:Missing      ; Answer='Missing'
 ELSE                     ; Answer='???('& Status &')'
 END
 RETURN Answer

 	



! !==============================================================================
CwUnit_ctResult.SetStatus        PROCEDURE(LONG NewStatus, STRING Operator, <? Output>, ? DefaultOutput )
    CODE
    IF OMITTED(Output)
       SELF.SetStatus(NewStatus, DefaultOutput)
    ELSE
       SELF.SetStatus(NewStatus, Output)
    END
!==============================================================================
CwUnit_ctResult.SetStatus        PROCEDURE(LONG NewStatus, <? Output>)   
   CODE
   SELF.Status = NewStatus
   IF ~OMITTED(Output) 
       SELF.Output = SELF.Output & Output 
   END   
!==============================================================================
CwUnit_ctResult.Pass             PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Pass, Output)
   
!==============================================================================
CwUnit_ctResult.Fail             PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Fail , Output)
!==============================================================================
CwUnit_ctResult.Ignore           PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Ignore, Output)

!==============================================================================
CwUnit_ctResult.Inconclusive     PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Inconclusive, Output)



!==============================================================================
CwUnit_ctResult.DefaultOutput    PROCEDURE(*? LHS, STRING Operator, <*? RHS>)!,STRING!,VIRTUAL
   CODE
   ! CASE Operator
   !   OF Is:Null    
   ! OROF Is:NotNull ; RETURN SELF.IsNullToString(LHS)
   ! END

   IF OMITTED(RHS) ; RETURN Operator & '(' & LHS & ')'
   END
                     RETURN '['& LHS &'] ' &  Operator & ' ['& RHS &']'



!==============================================================================
CwUnit_ctResult.Evaluate         PROCEDURE(*? Actual, STRING  UnaryOperator)!,BOOL
RetIsTrue BOOL
   CODE
   CASE UnaryOperator
     OF Is:True             ; RetIsTrue =  CHOOSE(     Actual         ) 
     OF Is:False            ; RetIsTrue =  CHOOSE( NOT Actual         )
   ! OF Is:Null             ; RetIsTrue =  CHOOSE(     Actual &= NULL )
   ! OF Is:NotNull          ; RetIsTrue =  CHOOSE( NOT Actual &= NULL )
   ELSE                     ; RetIsTrue =  Status:Inconclusive !<-- a misnomer, but it's as good as anything that's not TRUE or FALSE
   END   
   RETURN RetIsTrue

!==============================================================================
CwUnit_ctResult.Evaluate         PROCEDURE(*? LHS, STRING       Operator, ? RHS)!,BOOL
RetIsTrue BOOL
   CODE
   CASE Operator
     OF Is:EqualTo            ; RetIsTrue = CHOOSE( LHS  = RHS                     )
     OF Is:NotEqualTo         ; RetIsTrue = CHOOSE( LHS <> RHS                     )
     OF Is:GreaterThan        ; RetIsTrue = CHOOSE( LHS >  RHS                     )
     OF Is:GreaterThanOrEqual ; RetIsTrue = CHOOSE( LHS >= RHS                     )
     OF Is:LessThan           ; RetIsTrue = CHOOSE( LHS <= RHS                     )
     OF Is:LessThanOrEqual    ; RetIsTrue = CHOOSE( LHS <= RHS                     )
     OF Is:StartsWith         ; RetIsTrue = CHOOSE( SUB(RHS, 1, SIZE(LHS)) = LHS   )
     OF Is:Contains           ; RetIsTrue = CHOOSE( INSTRING(LHS, RHS, 1, 1)       )
     OF Is:EndsWith           ; RetIsTrue = CHOOSE( SUB(RHS, -SIZE(LHS), -1) = LHS )
   ELSE                       ; RetIsTrue = Status:Inconclusive !<-- a misnomer, but it's as good as anything that's not TRUE or FALSE
   END   
   RETURN RetIsTrue

!==============================================================================
CwUnit_ctResult.GetOperatorType  PROCEDURE(STRING Operator)!,OperatorTypeEnum
RetType OperatorTypeEnum,AUTO
   CODE
   CASE Operator
     OF Is:EqualTo            
   OROF Is:NotEqualTo         
   OROF Is:GreaterThan        
   OROF Is:GreaterThanOrEqual 
   OROF Is:LessThan           
   OROF Is:LessThanOrEqual    
   OROF Is:StartsWith         
   OROF Is:Contains           
   OROF Is:EndsWith           ; RetType = OperatorType:Binary

     OF Is:True     
   OROF Is:False             
  !OROF Is:Null     
  !OROF Is:NotNull            
                              ; RetType = OperatorType:Unary

   ELSE                       ; RetType = OperatorType:Unknown
   END
   RETURN RetType



!==============================================================================
CwUnit_ctResult.PassesWhen       PROCEDURE(? LHS   , STRING       Operator, <? RHS>, <? Passed>, <? Failed> )!,StatusEnum,PROC
RetStatus  StatusEnum,AUTO
   CODE
   CASE SELF.GetOperatorType(Operator)
     OF OperatorType:Binary  ; IF OMITTED(RHS)
                                   RetStatus = Status:Inconclusive
                                   SELF.Inconclusive('Missing 2nd Argument  LHS['& LHS &'] Operator['& Operator &'] Failed['& Failed &']')
                               ELSE
                                    RetStatus = CHOOSE( SELF.Evaluate(LHS, Operator, RHS) = TRUE, Status:Pass, Status:Fail) !Since Operator is confirmed, assume .Evaluate will only return TRUE/FALSE
                                    SELF.PassFail(  CHOOSE( RetStatus = Status:Pass) , LHS, Operator, RHS ,Passed, Failed)    
                               END

     OF OperatorType:Unary   ; IF ~OMITTED(RHS) 
                                   RetStatus = Status:Inconclusive
                                   SELF.Inconclusive('Extra Argument in Expression( ['& LHS &'] ['& Operator &'] ['& RHS &'] Failed['& Failed &']')     
                               ELSE
                                    RetStatus = CHOOSE( SELF.Evaluate(LHS, Operator) = TRUE, Status:Pass, Status:Fail)  !Since Operator is confirmed, assume .Evaluate will only return TRUE/FALSE
                                    SELF.PassFail(  CHOOSE( RetStatus = Status:Pass) , LHS, Operator,  ,Passed, Failed)     
                               END

     OF OperatorType:Unknown ; RetStatus = Status:Inconclusive
                               SELF.Inconclusive('Unknown Operator['& Operator &'] Failed['& Failed &']')
   END
   RETURN RetStatus



!==============================================================================
CwUnit_ctResult.FailsWhen       PROCEDURE(? LHS   , STRING       Operator, <? RHS>, <? Passed>, <? Failed> )!,StatusEnum,PROC
RetStatus  StatusEnum,AUTO
   CODE
   CASE SELF.GetOperatorType(Operator)
     OF OperatorType:Binary  ; IF OMITTED(RHS)
                                   RetStatus = Status:Inconclusive
                                   SELF.Inconclusive('Missing 2nd Argument  LHS['& LHS &'] Operator['& Operator &'] Failed['& Failed &']')

                               ELSE                                                      ! v--------- the differernce from .PassesWhen
                                    RetStatus = CHOOSE( SELF.Evaluate(LHS, Operator, RHS) <> TRUE, Status:Pass, Status:Fail) !Since Operator is confirmed, assume .Evaluate will only return TRUE/FALSE
                                    SELF.PassFail(  CHOOSE( RetStatus = Status:Pass) , LHS, Operator, RHS ,Passed, Failed)    
                               END

     OF OperatorType:Unary   ; IF ~OMITTED(RHS) 
                                   RetStatus = Status:Inconclusive
                                   SELF.Inconclusive('Extra Argument in Expression( ['& LHS &'] ['& Operator &'] ['& RHS &'] Failed['& Failed &']')     

                               ELSE                                                 ! v--------- the differernce from .PassesWhen
                                    RetStatus = CHOOSE( SELF.Evaluate(LHS, Operator) <> TRUE, Status:Pass, Status:Fail)  !Since Operator is confirmed, assume .Evaluate will only return TRUE/FALSE
                                    SELF.PassFail(  CHOOSE( RetStatus = Status:Pass) , LHS, Operator,  ,Passed, Failed)     
                               END

     OF OperatorType:Unknown ; RetStatus = Status:Inconclusive
                               SELF.Inconclusive('Unknown Operator['& Operator &'] Failed['& Failed &']')
   END
   RETURN RetStatus



!==============================================================================
CwUnit_ctResult.PassFail    PROCEDURE(BOOL TestPassed, ? LHS, STRING Operator, <? RHS>, <? Passed>, <? Failed> )
   CODE
   IF TestPassed
      IF Passed = ''
            SELF.Pass( SELF.DefaultOutput(LHS, Operator, RHS) )
      ELSE
            SELF.Pass( Passed )
      END
   ELSE
      IF Failed = ''
            SELF.Fail( SELF.DefaultOutput(LHS, Operator, RHS) )
      ELSE
            SELF.Fail( Failed )      
      END
   END

!==============================================================================
CwUnit_ctResult.Equal       PROCEDURE(? Expected, ? Actual, <? Passed>, <? Failed> )            
   CODE
   SELF.PassFail( CHOOSE(Actual = Expected), Expected, Is:EqualTo, Passed, Failed)

!==============================================================================
CwUnit_ctResult.NotEqual    PROCEDURE(? Expected, ? Actual, <? Passed>, <? Failed> )            
   CODE
   SELF.PassFail( CHOOSE(Actual <> Expected), Expected, Is:NotEqualTo, Passed, Failed)

!==============================================================================
CwUnit_ctResult.Greater          PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual >  CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual > CompareTo)  , Actual, Is:GreaterThan, CompareTo,   Passed, Failed)

!==============================================================================
CwUnit_ctResult.GreaterOrEqual   PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual >= CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual >= CompareTo)  , Actual, Is:GreaterThanOrEqual, CompareTo,   Passed, Failed)

!==============================================================================
CwUnit_ctResult.Less             PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual <  CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual < CompareTo)  , Actual, Is:LessThan, CompareTo,   Passed, Failed)
   
!==============================================================================
CwUnit_ctResult.LessOrEqual      PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual <= CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual <= CompareTo)  , Actual, Is:LessThanOrEqual, CompareTo,   Passed, Failed)

!==============================================================================
CwUnit_ctResult.IsTrue           PROCEDURE(            ? Actual, <? Passed>, <? Failed> )
DidTestPass BOOL,AUTO
   CODE
   IF Actual
      DidTestPass = TRUE
   ELSE
      DidTestPass = FALSE
   END
   SELF.PassFail(  DidTestPass,Actual, Is:True    ,     ,    Passed, Failed)   
!==============================================================================
CwUnit_ctResult.IsFalse          PROCEDURE(            ? Actual, <? Passed>, <? Failed> )
DidTestPass BOOL,AUTO
   CODE
   IF Actual
      DidTestPass = FALSE
   ELSE
      DidTestPass = TRUE
   END
   SELF.PassFail(  DidTestPass,Actual, Is:False    ,     ,    Passed, Failed)   





!==============================================================================
CwUnit_ctResult.StartsWith        PROCEDURE(? LookFor , ? LookIn , <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( SUB(LookIn, 1, SIZE(LookFor)) = LookFor) , LookFor, Is:StartsWith, LookIn  ,   Passed, Failed)   


!==============================================================================
CwUnit_ctResult.Contains          PROCEDURE(? LookFor , ? LookIn , <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( INSTRING(LookFor, LookIn, 1, 1) ), LookFor, Is:Contains, LookIn  ,   Passed, Failed)   

   
!==============================================================================
CwUnit_ctResult.EndsWith          PROCEDURE(? LookFor , ? LookIn , <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( SUB(LookIn, -SIZE(LookFor), -1) = LookFor ) , LookFor, Is:EndsWith, LookIn  ,   Passed, Failed)   



!------- I have not figured out how to make these work ------
! !==============================================================================
!CwUnit_ctResult.IsNullToString   PROCEDURE(*? Object)!,STRING
!   CODE
!   RETURN CHOOSE( Object &= NULL, 'Null', 'ADDRESS('& ADDRESS(Object) &')' )
!==============================================================================
!CwUnit_ctResult.IsNull           PROCEDURE(           *? Object, <? Passed>, <? Failed> ) 
!   CODE
!   MOD:ODS.Add('ctOneResult - IsNull ['& CHOOSE( Object &= NULL, 'NULL','NON-NULL') &']')
!
!   SELF.PassFail( CHOOSE(     Object &= NULL) , Object, Is:Null   ,  ,   Passed, Failed)   
!
!!==============================================================================
!CwUnit_ctResult.IsNotNull        PROCEDURE(           *? Object, <? Passed>, <? Failed> )
!   CODE
!   MOD:ODS.Add('ctOneResult - IsNotNull ['& CHOOSE( Object &= NULL, 'NULL','NON-NULL') &']')
!   SELF.PassFail( CHOOSE( NOT Object &= NULL) , Object, Is:NotNull,  ,   Passed, Failed)   

