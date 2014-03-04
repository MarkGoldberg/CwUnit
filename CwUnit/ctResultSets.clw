
  MEMBER()
  MAP
  END
  INCLUDE('ctResultSets.inc'),ONCE

!=====================================
ctResultSets.CONSTRUCT                      PROCEDURE()
  CODE
  SELF.Q     &= NEW qtResultSets
  SELF.BaseQ &= SELF.Q
  SELF.NextID = 1
  
!=====================================
ctResultSets.DESTRUCT                       PROCEDURE()
  CODE


!=====================================
ctResultSets.Del                            PROCEDURE!,DERIVED
  CODE
  DISPOSE(SELF.Q.Started)
  DISPOSE(SELF.Q.Finished)
 !DISPOSE(SELF.Q.DLL_Info) !TBD: Injected vs. New'd 
  PARENT.Del()
!=====================================
ctResultSets.Description                    PROCEDURE()!,STRING,DERIVED
  CODE
  RETURN 'ctResultSets'
	
!=====================================
ctResultSets.Starting                       PROCEDURE(*ctFileHelper DLLFileHelper)

  CODE
  !SELF.GetByPtr( SELF.Records() )
  SELF.Q.SetID     			 = SELF.NextID
  SELF.NextID              += 1
  SELF.Q.Started           &= NEW ctDateTimeLong
  SELF.Q.Started.Now()
  SELF.Q.Finished          &= NEW ctDateTimeLong
  SELF.Q.DLLFileHelper     &= DLLFileHelper  !Consider doing a COPY (Injected vs. NEW)
 !SELF.Q.WorkDirectory      = CSTRING(FILE:MaxFilePath)
 
  SELF.Q.Status             = 0 !TODO: Status Enum
  ADD(SELF.Q)
  RETURN SELF.Q.SetID
	
!=====================================
ctResultSets.Finished                       PROCEDURE()
	CODE
	SELF.Q.Status = 1 !TODO: Status Enum
	SELF.Q.Finished.Now()
	PUT(SELF.Q)

