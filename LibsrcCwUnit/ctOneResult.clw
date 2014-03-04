
   MEMBER
   MAP
   END
   INCLUDE('ctOneResult.inc'),ONCE

!==============================================================================
ctOneResult.CONSTRUCT        PROCEDURE
	CODE
	CLEAR(SELF.Output)
!==============================================================================
ctOneResult.DESTRUCT         PROCEDURE
 	CODE
 	CLEAR(SELF.Output) !<-- is this needed ?
 	
 	
!==============================================================================
ctOneResult.StatusToString   PROCEDURE()!,STRING
	CODE
	RETURN SELF.StatusToString(SELF.Status)
	
!==============================================================================
ctOneResult.StatusToString   PROCEDURE(LONG Status)!,STRING
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

 	


!==============================================================================
ctOneResult.DefaultOutput    PROCEDURE(? LHS, STRING Operator, <? RHS>)!,STRING!,VIRTUAL
   CODE
   IF OMITTED(RHS)
		RETURN Operator & '(' & LHS & ')'
   END
	RETURN 'Actual['& LHS &'] ' &  Operator & ' ['& RHS &']'


! !==============================================================================
ctOneResult.SetStatus        PROCEDURE(LONG NewStatus, STRING Operator, <? Output>, ? DefaultOutput )
    CODE
    IF OMITTED(Output)
       SELF.SetStatus(NewStatus, DefaultOutput)
    ELSE
       SELF.SetStatus(NewStatus, Output)
    END
!==============================================================================
ctOneResult.SetStatus        PROCEDURE(LONG NewStatus, <? Output>)   
   CODE
   SELF.Status = NewStatus
   IF ~OMITTED(Output) 
       SELF.Output = Output 
   END   
!==============================================================================
ctOneResult.Pass             PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Pass, Output)
   
!==============================================================================
ctOneResult.Fail             PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Fail , Output)
!==============================================================================
ctOneResult.Ignore           PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Ignore, Output)

!==============================================================================
ctOneResult.Inconclusive     PROCEDURE(<? Output>)
   CODE
   SELF.SetStatus(Status:Inconclusive, Output)



!==============================================================================
ctOneResult.Is               PROCEDURE(? Actual, STRING Operator,        <? Passed>, <? Failed> )
   CODE
   CASE Operator
     OF Op:IsTrue             ; SELF.PassFail( CHOOSE(         Actual     ) , Actual, Operator, ,Passed, Failed)     
     OF Op:IsFalse            ; SELF.PassFail( CHOOSE(     NOT Actual     ) , Actual, Operator, ,Passed, Failed)     
     OF Op:IsNull             ; SELF.PassFail( CHOOSE( ADDRESS(Actual) = 0) , Actual, Operator, ,Passed, Failed)     
     OF Op:IsNotNull          ; SELF.PassFail( CHOOSE( ADDRESS(Actual)<> 0) , Actual, Operator, ,Passed, Failed)     
   ELSE                       ; SELF.Inconclusive('Unknown Operator['& Operator &'] Failed['& Failed &']')
   END

!==============================================================================
ctOneResult.Is               PROCEDURE(? LHS, STRING Operator, ? RHS, <? Passed>, <? Failed> )
   !LHS - Left  Hand Side
   !RHS - Right Hand Side
   CODE
   CASE Operator
     OF Op:EqualTo            ; SELF.PassFail( CHOOSE( LHS  = RHS)                        , LHS, Operator, RHS, Passed, Failed)
     OF Op:NotEqualTo         ; SELF.PassFail( CHOOSE( LHS <> RHS)                        , LHS, Operator, RHS, Passed, Failed)
     OF Op:GreaterThan        ; SELF.PassFail( CHOOSE( LHS >  RHS)                        , LHS, Operator, RHS, Passed, Failed)
     OF Op:GreaterThanOrEqual ; SELF.PassFail( CHOOSE( LHS >= RHS)                        , LHS, Operator, RHS, Passed, Failed)
     OF Op:LessThan           ; SELF.PassFail( CHOOSE( LHS <= RHS)                        , LHS, Operator, RHS, Passed, Failed)
     OF Op:LessThanOrEqual    ; SELF.PassFail( CHOOSE( LHS <= RHS)                        , LHS, Operator, RHS, Passed, Failed)
     OF Op:StartsWith         ; SELF.PassFail( CHOOSE( SUB(RHS, 1, SIZE(LHS)) = LHS   )   , LHS, Operator, RHS, Passed, Failed)
     OF Op:Contains           ; SELF.PassFail( CHOOSE( INSTRING(LHS, RHS, 1, 1)      )    , LHS, Operator, RHS, Passed, Failed) 
     OF Op:EndsWith           ; SELF.PassFail( CHOOSE( SUB(RHS, -SIZE(LHS), -1) = LHS )   , LHS, Operator, RHS, Passed, Failed) 
   ELSE                       ; SELF.Inconclusive('Unknown Operator['& Operator &'] Failed['& Failed &']')
   END

!==============================================================================
ctOneResult.PassFail    PROCEDURE(BOOL TestPassed, ? LHS, STRING Operator, <? RHS>, <? Passed>, <? Failed> )
   CODE
   IF TestPassed
      SELF.Pass(Passed)   
   ELSE
      SELF.Fail(Failed)      
   END
   IF SELF.Output = ''
      SELF.Output = SELF.DefaultOutput(LHS, Operator, RHS) 
   END

!==============================================================================
ctOneResult.Equal       PROCEDURE(? Expected, ? Actual, <? Passed>, <? Failed> )            
   CODE
   SELF.PassFail( CHOOSE(Actual = Expected), Expected, Op:EqualTo, Passed, Failed)

!==============================================================================
ctOneResult.NotEqual    PROCEDURE(? Expected, ? Actual, <? Passed>, <? Failed> )            
   CODE
   SELF.PassFail( CHOOSE(Actual <> Expected), Expected, Op:NotEqualTo, Passed, Failed)

!==============================================================================
ctOneResult.Greater          PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual >  CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual > CompareTo)  , Actual, Op:GreaterThan, CompareTo,   Passed, Failed)

!==============================================================================
ctOneResult.GreaterOrEqual   PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual >= CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual >= CompareTo)  , Actual, Op:GreaterThanOrEqual, CompareTo,   Passed, Failed)

!==============================================================================
ctOneResult.Less             PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual <  CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual < CompareTo)  , Actual, Op:LessThan, CompareTo,   Passed, Failed)
   
!==============================================================================
ctOneResult.LessOrEqual      PROCEDURE( ? Actual, ? CompareTo, <? Passed>, <? Failed> ) !Pass when:  Actual <= CompareTo
   CODE
   SELF.PassFail( CHOOSE(Actual <= CompareTo)  , Actual, Op:LessThanOrEqual, CompareTo,   Passed, Failed)

!==============================================================================
ctOneResult.IsTrue           PROCEDURE(            ? Actual, <? Passed>, <? Failed> )
DidTestPass BOOL,AUTO
   CODE
   IF Actual
      DidTestPass = TRUE
   ELSE
      DidTestPass = FALSE
   END
   SELF.PassFail(  DidTestPass,Actual, Op:IsTrue    ,     ,    Passed, Failed)   
!==============================================================================
ctOneResult.IsFalse          PROCEDURE(            ? Actual, <? Passed>, <? Failed> )
DidTestPass BOOL,AUTO
   CODE
   IF Actual
      DidTestPass = FALSE
   ELSE
      DidTestPass = TRUE
   END
   SELF.PassFail(  DidTestPass,Actual, Op:IsFalse    ,     ,    Passed, Failed)   
!==============================================================================
ctOneResult.IsNull           PROCEDURE(           *? Actual, <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( ADDRESS(Actual) = 0) , Actual, Op:IsNull,  ,   Passed, Failed)   

!==============================================================================
ctOneResult.IsNotNull        PROCEDURE(           *? Actual, <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( ADDRESS(Actual) <> 0) , Actual, Op:IsNotNull,  ,   Passed, Failed)   

!==============================================================================
ctOneResult.StartsWith        PROCEDURE(? LookFor , ? LookIn , <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( SUB(LookIn, 1, SIZE(LookFor)) = LookFor) , LookFor, Op:StartsWith, LookIn  ,   Passed, Failed)   


!==============================================================================
ctOneResult.Contains          PROCEDURE(? LookFor , ? LookIn , <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( INSTRING(LookFor, LookIn, 1, 1) ), LookFor, Op:Contains, LookIn  ,   Passed, Failed)   

   
!==============================================================================
ctOneResult.EndsWith          PROCEDURE(? LookFor , ? LookIn , <? Passed>, <? Failed> )
   CODE
   SELF.PassFail( CHOOSE( SUB(LookIn, -SIZE(LookFor), -1) = LookFor ) , LookFor, Op:EndsWith, LookIn  ,   Passed, Failed)   

