  MEMBER()
  MAP
  END
  INCLUDE('ctTimedResults.inc'),ONCE

!=====================================
ctTimedResults.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.Q     &= NEW qtTimedResult
  SELF.BaseQ &= SELF.Q

!=====================================
ctTimedResults.DESTRUCT                       PROCEDURE()
  CODE


!=====================================
ctTimedResults.Del                            PROCEDURE!,DERIVED
  CODE
  DISPOSE(SELF.Q.OneResult)
  DISPOSE(SELF.Q.Started)
  DISPOSE(SELF.Q.Finished)
  PARENT.Del()
!=====================================
ctTimedResults.Description                    PROCEDURE()!,STRING,DERIVED
  CODE
  RETURN 'ctTimedResults'
	
!=====================================
ctTimedResults.Starting                      PROCEDURE(LONG ResultSetID)
  CODE
  CLEAR(SELF.Q)
  SELF.Q.OneResult         &= NEW ctOneResult
  SELF.Q.ResultSetID		    = ResultSetID
  SELF.Q.Started           &= NEW ctDateTimeLong !SELF.Q.Started.NewNow()
  SELF.Q.Started.Now()
  SELF.Q.Finished          &= NEW ctDateTimeLong !SELF.Q.Finished.NewZero()
  SELF.Q.Finished.Zero()
  ADD(SELF.Q)

!=====================================
ctTimedResults.Finished                       PROCEDURE()
  CODE
  SELF.Q.Finished.Now()
  PUT(SELF.Q)

