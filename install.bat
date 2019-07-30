SET DIR=%~dp0
SET SETTINGS=%DIR%Settings

RENAME %APPDATA%\Adobe\Lightroom Lightroom_BAK

FOR /R %SETTINGS% %%G in (.)  DO MKLINK /J %APPDATA%\Adobe\CameraRaw\Settings\%%~nxG %SETTINGS%\%%~nxG

MKLINK /J %APPDATA%\Adobe\Lightroom %DIR%Lightroom