 	 	INCLUDE('Time.equ'),ONCE
 	 	
gtDateTimeLong			GROUP,TYPE
Date								LONG
Time								LONG
								END
								

Static_DateTimeLong     CLASS(),TYPE,MODULE('ctDateTimeLong.CLW'),LINK('ctDateTimeLong.CLW')
Zero                       PROCEDURE(      *gtDateTimeLong DT)
Now                        PROCEDURE(      *gtDateTimeLong DT)
ToString                   PROCEDURE(CONST *gtDateTimeLong DT),STRING
NowAsString                PROCEDURE(),STRING

AsSpan                     PROCEDURE(      *gtDateTimeLong outDTSpan, CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd)
SpanToString               PROCEDURE(                                 CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd),STRING
SpanTicks                  PROCEDURE(                                 CONST *gtDateTimeLong inDTStart, CONST *gtDateTimeLong inDTEnd),STRING
AsTicks                    PROCEDURE( CONST *gtDateTimeLong DT),STRING
								END


ctDateTimeLong          CLASS(Static_DateTimeLong),TYPE,MODULE('ctDateTimeLong.CLW'),LINK('ctDateTimeLong.CLW')
DT                         LIKE(gtDateTimeLong)
!-----
Zero                       PROCEDURE()
Now                        PROCEDURE()
ToString                   PROCEDURE(),STRING
NewNow                     PROCEDURE(),*ctDateTimeLong
NewZero                    PROCEDURE(),*ctDateTimeLong
AsTicks                    PROCEDURE(),STRING
								END

	
	