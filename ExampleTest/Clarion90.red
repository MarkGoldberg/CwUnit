
-- Add paths that are effective for all configurations
-- eg *.exe = exe
-- The redirection system has an order of precedence where a line has priority over later lines

[Debug]
-- Add paths that are only effective when Debug configuration is being built
-- eg *.exe = exe\debug

[Release]
-- Add paths that are only effective when Release configuration is being built
-- eg *.exe = exe\release

[Common]
-- Add paths that are effective for all configurations
-- eg *.exe = exe

*.inc = ..\LibsrcCwUnit ; ..\Libsrc
*.clw = ..\LibsrcCwUnit ; ..\Libsrc
*.equ = ..\LibsrcCwUnit ; ..\Libsrc
*.int = ..\LibsrcCwUnit ; ..\Libsrc

{include %REDDIR%\%REDNAME% }
