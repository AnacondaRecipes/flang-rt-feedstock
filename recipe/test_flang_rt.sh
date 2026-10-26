#!/bin/bash
# usage: test_flang_rt.sh <LLVM major version>
set -euxo pipefail
major=$1
triple=$(uname -m)-unknown-linux-gnu
libdir=$PREFIX/lib/clang/$major/lib/$triple

# runtime libraries in flang's default, target-specific location
test -f "$libdir/libflang_rt.runtime.a"
test -f "$libdir/libflang_rt.runtime.so"

# intrinsic modules in flang's default search path (<resource dir>/finclude/flang/<triple>)
for mod in iso_fortran_env iso_c_binding ieee_arithmetic ieee_exceptions __fortran_builtins; do
  test -f "$PREFIX/lib/clang/$major/finclude/flang/$triple/$mod.mod"
done

# flang finds the modules on its own, without -fintrinsic-modules-path
flang -c test_modules.f90 -o test_modules.o

# link against the runtime from this package and run
${CC} test_modules.o -L"$libdir" -Wl,-rpath,"$libdir" -lflang_rt.runtime -o test_modules
./test_modules
