@echo on
REM usage: test_flang_rt.bat <LLVM major version> <target triple>
set "LIBDIR=%LIBRARY_LIB%\clang\%~1\lib\%~2"
set "MODDIR=%LIBRARY_LIB%\clang\%~1\finclude\flang\%~2"

REM runtime libraries for the /MT, /MD, /MTd and /MDd flavours of the MSVC runtime
for %%f in (static dynamic static_dbg dynamic_dbg) do (
  if not exist "%LIBDIR%\flang_rt.runtime.%%f.lib" exit /b 1
)

REM intrinsic modules in flang's default search path (<resource dir>\finclude\flang\<triple>)
for %%m in (iso_fortran_env iso_c_binding ieee_arithmetic ieee_exceptions __fortran_builtins) do (
  if not exist "%MODDIR%\%%m.mod" exit /b 1
)

REM flang finds the modules on its own, without -fintrinsic-modules-path;
REM linking and running is tested in flang-activation, which brings lld
flang -c test_modules.f90 -o test_modules.o
if %ERRORLEVEL% NEQ 0 exit /b 1
