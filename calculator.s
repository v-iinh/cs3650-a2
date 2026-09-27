# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %r8b
  movq a, %rax
  movq b, %r9

  cmpb $'+', %r8b
  je .Ladd
  cmpb $'-', %r8b
  je .Lsubtract
  cmpb $'*', %r8b
  je .Lmultiply
  cmpb $'/', %r8b
  je .Ldivide

  # Operation not supported
  movq $unknown_operation_fmt, %rdi
  xorb %al, %al
  call printf
  movl $1, %eax
  jmp .Ldone

.Ladd:
  addq %r9, %rax
  jmp .Lprint_result

.Lsubtract:
  subq %r9, %rax
  jmp .Lprint_result

.Lmultiply:
  imulq %r9, %rax
  jmp .Lprint_result

.Ldivide:
  testq %r9, %r9
  je .Ldivision_by_zero

  cqto
  idivq %r9
  jmp .Lprint_result

.Ldivision_by_zero:
  movq $division_by_zero_fmt, %rdi
  xorb %al, %al
  call printf
  movl $1, %eax
  jmp .Ldone

.Lprint_result:
  movq $output_fmt, %rdi
  movq %rax, %rsi
  xorb %al, %al
  call printf
  xorl %eax, %eax

.Ldone:

  # Function epilogue
  leave
  ret


# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
unknown_operation_fmt:
  .asciz "Unknown operation\n"
division_by_zero_fmt:
  .asciz "Division by zero\n"
scanf_fmt: 
  .asciz "%ld %c %ld"

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

