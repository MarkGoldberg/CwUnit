
	!INCLUDE('WinEQU.clw),ONCE
!UINT              EQUATE(UNSIGNED)	
	
gtFnsplit   		GROUP,TYPE
_Path         			CSTRING(FILE:MaxFilePath) !255)            !Used by FnSplit
_Drive        			CSTRING(FILE:MaxFilePath) !255) ! 12) ! 2) !Used by FnSplit
_Dir          			CSTRING(FILE:MaxFilePath) !255)!64)        !Used by FnSplit
_Name         			CSTRING(FILE:MaxFilePath) !255)! 8)        !Used by FnSplit
_Ext          			CSTRING(FILE:MaxFilePath) !255)! 3)        !Used by FnSplit !bug? where is '.' held?
            		END
qtFileList  		QUEUE,TYPE
FName           		STRING(FILE:MaxFilePath)
            		END

!----------------------------------
!For API Call:  GetDriveType
DRIVE_UNKNOWN     EQUATE(0)
DRIVE_NO_ROOT_DIR EQUATE(1)
DRIVE_REMOVABLE   EQUATE(2)
DRIVE_FIXED       EQUATE(3)
DRIVE_REMOTE      EQUATE(4)
DRIVE_CDROM       EQUATE(5)
DRIVE_RAMDISK     EQUATE(6)
!----------------------------------


StaticFilesHelper	CLASS,TYPE,MODULE('FilesHelper.clw'),LINK('FilesHelper.clw')
EnsureEndsWith          PROCEDURE(  STRING Current, STRING EndsWith),STRING

FnSplit                 PROCEDURE(*gtFnSplit xaInfo)
FnSplit                 PROCEDURE(  STRING xPath, <*STRING xaDrive>, <*STRING xaDir>, <*STRING xaName>, <*STRING xaExt>)
ToString                PROCEDURE(CONST *gtFnSplit SpiltFile, STRING Delimiter),STRING

AbsoluteFileName        PROCEDURE(*gtFnSplit xaInfo),STRING
DriveDir                PROCEDURE(  STRING xPath),STRING
BaseName                PROCEDURE(  STRING xPath),STRING
Extension               PROCEDURE(  STRING xPath),STRING

GetDriveType            PROCEDURE(  STRING xRootPathName),UNSIGNED !UINT

GetTempPath             PROCEDURE(), STRING
GetTempFileName         PROCEDURE(  STRING xPrefix                    ),STRING
GetTempFileName         PROCEDURE(  STRING xPrefix, STRING sDirectory ),STRING

Exists                  PROCEDURE(STRING FileName),BOOL

FILE:Multi_ToFileListQ  PROCEDURE(STRING xsFileList, *qtFileList xaFileListQ, STRING xsDelim) !assumes FILE:Multi notation:  folder|file1.txt|file2.txt
DropIDFile_ToFileListQ  PROCEDURE(STRING xsFileList, *qtFileList xaFileListQ, STRING xsDelim) !assumes ~FILE notation
						END
						
						
ctFilesHelper			CLASS(StaticFilesHelper),TYPE,MODULE('FilesHelper.clw'),LINK('FilesHelper.clw')
SplitInfo            	LIKE(gtFnsplit)
SetFileName          	PROCEDURE(STRING newFileName)
AbsoluteFileName        PROCEDURE(),STRING
Exists               	PROCEDURE(),BOOL
DriveDir                PROCEDURE(),STRING
BaseName                PROCEDURE(),STRING
Extension               PROCEDURE(),STRING
ToString                PROCEDURE(<STRING Delimiter>),STRING
						END
						