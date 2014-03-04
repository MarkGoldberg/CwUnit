	INCLUDE(       'ctQueue.inc'),ONCE
   INCLUDE('ctDateTimeLong.inc'),ONCE
   INCLUDE(   'ctOneResult.inc'),ONCE					 

gtTimedResult   GROUP,TYPE
OneResult         &ctOneResult
ResultSetID		   LONG             !LIKE(gtResultSets.SetID)
Started           &ctDateTimeLong
Finished          &ctDateTimeLong
			 		 END
					 
qtTimedResult   QUEUE(gtTimedResult),TYPE
                END					 


ctTimedResults  CLASS(ctQueue),TYPE,MODULE('ctTimedResults.clw'),LINK('ctTimedResults.clw')
Q                             &qtTimedResult
Del                            PROCEDURE,DERIVED
Description                    PROCEDURE(),STRING,DERIVED

!----------
CONSTRUCT                      PROCEDURE()
DESTRUCT                       PROCEDURE()
Starting                       PROCEDURE(LONG ResultSetID)
Finished                       PROCEDURE()
               END





