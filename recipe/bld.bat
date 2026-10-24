@echo on

REM LLVM 23 force-includes stl-overrides.h (GNU __attribute__) into every C++ TU; MSVC cl cannot parse it.
REM Use clang-cl from the host clang 23 (clangdev) instead, with the MSVC toolchain environment.
set "CC=%LIBRARY_BIN%\clang-cl.exe"
set "CXX=%LIBRARY_BIN%\clang-cl.exe"

mkdir build
cd build

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE="Release" ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=OFF ^
    -DCMAKE_Fortran_COMPILER=%BUILD_PREFIX%/Library/bin/flang.exe ^
    -DCMAKE_Fortran_COMPILER_WORKS=yes ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_MODULE_PATH=../cmake/Modules ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX%;%LIBRARY_LIB%/clang/%PKG_VERSION% ^
    -DLLVM_EXTERNAL_LIT=%LIBRARY_BIN%/lit ^
    -DLLVM_LIT_ARGS=-v ^
    -DLLVM_CMAKE_DIR=%LIBRARY_LIB%/cmake/llvm ^
    -DLLVM_DIR=%LIBRARY_LIB%/cmake/llvm ^
    -DLLVM_ENABLE_RUNTIMES="flang-rt" ^
    -DFLANG_RT_INCLUDE_TESTS=OFF ^
    -DFLANG_RT_FORTRAN_MODULES=ON ^
    -DRUNTIMES_FORTRAN_MODULES=ON ^
    ..\runtimes
if %ERRORLEVEL% neq 0 exit 1

cmake --build . -j2
if %ERRORLEVEL% neq 0 exit 1

cmake --install .
if %ERRORLEVEL% neq 0 exit 1
