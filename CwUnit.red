

-- *.inc = LibsrcCwUnit ; Libsrc
-- *.clw = LibsrcCwUnit ; Libsrc
-- *.equ = LibsrcCwUnit ; Libsrc
-- *.int = LibsrcCwUnit ; Libsrc

-- *.inc = .\LibsrcCwUnit ; .\Libsrc
-- *.clw = .\LibsrcCwUnit ; .\Libsrc
-- *.equ = .\LibsrcCwUnit ; .\Libsrc
-- *.int = .\LibsrcCwUnit ; .\Libsrc

-- *.inc = %THISDIR%\LibsrcCwUnit ; %THISDIR%\Libsrc
-- *.clw = %THISDIR%\LibsrcCwUnit ; %THISDIR%\Libsrc
-- *.equ = %THISDIR%\LibsrcCwUnit ; %THISDIR%\Libsrc
-- *.int = %THISDIR%\LibsrcCwUnit ; %THISDIR%\Libsrc


-- ASSUMES RedirectionMacro[CwUnit] is set in Tools.Options.Clarion.ClarionForWindows.Versions.[<AppropriateVersion>].Tab[RedirectionFile]
*.inc = %CwUnit%\LibsrcCwUnit ; %CwUnit%\Libsrc
*.clw = %CwUnit%\LibsrcCwUnit ; %CwUnit%\Libsrc
*.equ = %CwUnit%\LibsrcCwUnit ; %CwUnit%\Libsrc
*.int = %CwUnit%\LibsrcCwUnit ; %CwUnit%\Libsrc


[Debug]
-- Add paths that are only effective when Debug configuration is being built
-- eg *.exe = exe\debug

[Release]
-- Add paths that are only effective when Release configuration is being built
-- eg *.exe = exe\release

[Common]
-- Add paths that are effective for all configurations
-- eg *.exe = exe


