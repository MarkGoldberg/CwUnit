
 MEMBER
 MAP
 END
 INCLUDE('DateTimeLong.inc'),ONCE

!Region Static_DateTimeLong

Static_DateTimeLong.Zero                       PROCEDURE(      *gtDateTimeLong DT)
	CODE
   DT.Date = 0
   DT.Time = 0

Static_DateTimeLong.Now                        PROCEDURE(      *gtDateTimeLong DT)
	CODE
   DT.Date = TODAY()
   DT.Time = CLOCK()
	
Static_DateTimeLong.ToString                   PROCEDURE(CONST *gtDateTimeLong DT)!,STRING
	CODE
   RETURN '['& FORMAT(DT.Date,@D1) &' @ '& FORMAT(DT.Time,@T4) &']'

Static_DateTimeLong.NowAsString                PROCEDURE()!,STRING   
tmpDTL LIKE(gtDateTimeLong)
	CODE
	SELF.Now(tmpDTL)
	RETURN SELF.ToString(tmpDTL)

!EndRegion Static_DateTimeLong


  
 !Region ctDateTimeLong

ctDateTimeLong.Zero                            PROCEDURE()
	CODE   
   SELF.Zero(SELF.DT)
   
ctDateTimeLong.Now                             PROCEDURE()
	CODE
	SELF.Now(SELF.DT)

ctDateTimeLong.ToString                        PROCEDURE()!,STRING
	CODE
	RETURN SELF.ToString(SELF.DT)

ctDateTimeLong.NewNow                     PROCEDURE()!,*ctDateTimeLong
_SELF  &ctDateTimeLong
	CODE
	_SELF &= NEW ctDateTimeLong
	_SELF.Now()
	RETURN _SELF
	
ctDateTimeLong.NewZero                    PROCEDURE()!,*ctDateTimeLong
_SELF  &ctDateTimeLong
	CODE
	_SELF &= NEW ctDateTimeLong
	_SELF.Zero()
	RETURN _SELF

!EndRegion ctDateTimeLong	
   
 
	