
!Region Notices
! ================================================================================
! Notice : Copyright (C) 2016-2017, Monolith Custom Computing, Inc.
!          Distributed under MIT (https://opensource.org/licenses/MIT) 
! 
!    This file is part of Monolith-Common (https://github.com/MarkGoldberg/MonolithCC-Common) 
! 
!    MonolithCC-Common is free software: you can redistribute it and/or modify 
!    it under the terms of the MIT License as published by 
!    the Open Source Initiative. 
! 
!    MonolithCC-Common is distributed in the hope that it will be useful, 
!    but WITHOUT ANY WARRANTY; without even the implied warranty of 
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
!    MIT License for more details. 
! 
!    You should have received a copy of the MIT License 
!    along with MonolithCC-Common.  If not, see <https://opensource.org/licenses/MIT>. 
! ================================================================================
!EndRegion Notices


  MAP
ftProc_Long    PROCEDURE(LONG   xUserData),TYPE
ftProc_String  PROCEDURE(STRING xUserData),TYPE
ftProc_StarAny PROCEDURE(*?     xUserData),TYPE

ftProc_Long_QBuf    PROCEDURE(LONG   xUserData, STRING xQueueBuffer),TYPE
ftProc_String_QBuf  PROCEDURE(STRING xUserData, STRING xQueueBuffer),TYPE
ftProc_StarAny_QBuf PROCEDURE(*?     xUserData, STRING xQueueBuffer),TYPE

  END
