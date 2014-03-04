	INCLUDE(       'ctQueue.inc'),ONCE
   INCLUDE(    'ctTestDlls.inc'),ONCE  !for gtDLL_Info
   INCLUDE('ctDateTimeLong.inc'),ONCE   
   INCLUDE(  'ctFileHelper.inc'),ONCE

gtResultSets    GROUP,TYPE
SetID     			LONG 
Started           &ctDateTimeLong
Finished          &ctDateTimeLong
DLLFileHelper     &ctFileHelper  
!DLL_Info          &gtDLL_Info
!WorkDirectory     CSTRING(FILE:MaxFilePath)
Status            LONG  
					 END
					 
qtResultSets    QUEUE(gtResultSets),TYPE
					 END
			 
ctResultSets CLASS(ctQueue),TYPE,MODULE('ctResultSets.clw'),LINK('ctResultSets.clw')
Q                             &qtResultSets
NextID                        LIKE(gtResultSets.SetID)
!----------
CONSTRUCT                      PROCEDURE()
DESTRUCT                       PROCEDURE()
Del                            PROCEDURE,DERIVED
Description                    PROCEDURE(),STRING,DERIVED
Starting                       PROCEDURE(*ctFileHelper DLLFileHelper),LONG !Returns SetID
Finished                       PROCEDURE()
       END


