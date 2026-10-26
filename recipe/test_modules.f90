! uses the intrinsic modules, which flang-rt provides since LLVM 23
program test_modules
  use iso_fortran_env
  use iso_c_binding
  implicit none
  integer(c_int) :: i
  real(real64) :: x
  i = 42
  x = real(i, c_double)
  if (int(x, int64) /= 42_int64) error stop 1
  print *, compiler_version()
end program test_modules
