0x10015f58c  stp      x28, x27, [sp, #-0x60]!
0x10015f590  stp      x26, x25, [sp, #0x10]
0x10015f594  stp      x24, x23, [sp, #0x20]
0x10015f598  stp      x22, x21, [sp, #0x30]
0x10015f59c  stp      x20, x19, [sp, #0x40]
0x10015f5a0  stp      x29, x30, [sp, #0x50]
0x10015f5a4  add      x29, sp, #0x50
0x10015f5a8  sub      sp, sp, #0x10
0x10015f5ac  mov      x20, x0
0x10015f5b0  mov      x0, #0
0x10015f5b4  bl       #0x100259538
0x10015f5b8  mov      x19, x0
0x10015f5bc  adrp     x21, #0x1003bc000
0x10015f5c0  ldr      x21, [x21, #0xff8]
0x10015f5c4  ldur     x24, [x0, #-8]
0x10015f5c8  ldr      x8, [x24, #0x40]
0x10015f5cc  mov      x9, x8
0x10015f5d0  adrp     x16, #0x1003bc000
0x10015f5d4  ldr      x16, [x16, #0xb30]
0x10015f5d8  blr      x16
0x10015f5dc  mov      x9, sp
0x10015f5e0  add      x8, x8, #0xf
0x10015f5e4  and      x8, x8, #0xfffffffffffffff0
0x10015f5e8  sub      x23, x9, x8
0x10015f5ec  mov      sp, x23
0x10015f5f0  mov      x0, #0
0x10015f5f4  bl       #0x100259550
0x10015f5f8  mov      x22, x0
0x10015f5fc  ldur     x8, [x0, #-8]
0x10015f600  ldr      x8, [x8, #0x40]
0x10015f604  mov      x9, x8
0x10015f608  adrp     x16, #0x1003bc000
0x10015f60c  ldr      x16, [x16, #0xb30]
0x10015f610  blr      x16
0x10015f614  mov      x9, sp
0x10015f618  add      x8, x8, #0xf
0x10015f61c  and      x8, x8, #0xfffffffffffffff0
0x10015f620  sub      x25, x9, x8
0x10015f624  mov      sp, x25
0x10015f628  mov      x0, x20
0x10015f62c  bl       #0x10025a2e8
0x10015f630  bl       #0x1001133f8
0x10015f634  mov      x26, x0
0x10015f638  mov      x27, x1
0x10015f63c  mov      x0, x20
0x10015f640  bl       #0x10025a2d0
0x10015f644  adrp     x0, #0x1003d7000
0x10015f648  add      x0, x0, #0xc60
0x10015f64c  adrp     x2, #0x1003bc000
0x10015f650  ldr      x2, [x2, #0xff0]
0x10015f654  mov      x1, x21
0x10015f658  bl       #0x100005254
0x10015f65c  mov      x28, x0
0x10015f660  mov      x8, x23
0x10015f664  mov      x20, x19
0x10015f668  mov      x0, x19
0x10015f66c  mov      x1, x28
0x10015f670  bl       #0x100259370
0x10015f674  mov      x0, x26
0x10015f678  mov      x1, x27
0x10015f67c  bl       #0x100091450
0x10015f680  mov      x0, x26
0x10015f684  mov      x1, x27
0x10015f688  mov      x2, x23
0x10015f68c  mov      x21, #0
0x10015f690  bl       #0x10015cccc
0x10015f694  mov      x0, x26
0x10015f698  mov      x1, x27
0x10015f69c  bl       #0x100022818
0x10015f6a0  mov      x8, x25
0x10015f6a4  mov      x20, x23
0x10015f6a8  mov      x0, x19
0x10015f6ac  mov      x1, x28
0x10015f6b0  bl       #0x100259364
0x10015f6b4  mov      x0, x26
0x10015f6b8  mov      x1, x27
0x10015f6bc  bl       #0x100022818
0x10015f6c0  ldr      x8, [x24, #8]
0x10015f6c4  mov      x0, x23
0x10015f6c8  mov      x1, x19
0x10015f6cc  blr      x8
0x10015f6d0  adrp     x0, #0x1003d7000
0x10015f6d4  add      x0, x0, #0xc68
0x10015f6d8  adrp     x2, #0x1003bd000
0x10015f6dc  ldr      x2, [x2, #0x18]
0x10015f6e0  adrp     x1, #0x1003bd000
0x10015f6e4  ldr      x1, [x1, #0x10]
0x10015f6e8  bl       #0x100005254
0x10015f6ec  mov      x1, x0
0x10015f6f0  mov      x20, x25
0x10015f6f4  mov      x0, x22
0x10015f6f8  bl       #0x100259844
0x10015f6fc  mov      x19, x0
0x10015f700  bl       #0x10025a4c8
0x10015f704  adrp     x1, #0x1003be000
0x10015f708  ldr      x1, [x1, #0x7e8]
0x10015f70c  mov      w20, #0x10
0x10015f710  mov      w0, #0x10
0x10015f714  bl       #0x10025988c
0x10015f718  str      x20, [x0, #0x10]
0x10015f71c  stp      xzr, xzr, [x0, #0x20]
0x10015f720  stur     x0, [x29, #-0x60]
0x10015f724  ldr      x8, [x19, #0x10]
0x10015f728  cmp      x8, #0x10
0x10015f72c  b.lo     #0x10015f82c
0x10015f730  mov      x0, x19
0x10015f734  bl       #0x10025a4c8
0x10015f738  add      x3, x19, #0x20
0x10015f73c  sub      x20, x29, #0x60
0x10015f740  mov      x0, #0
0x10015f744  mov      w1, #4
0x10015f748  mov      x2, x19
0x10015f74c  mov      w4, #0xc
0x10015f750  mov      w5, #0x21
0x10015f754  bl       #0x10007b784
0x10015f758  mov      x0, x19
0x10015f75c  bl       #0x10025a4b0
0x10015f760  ldr      x8, [x19, #0x10]
0x10015f764  cmp      x8, #8
0x10015f768  b.lo     #0x10015f830
0x10015f76c  mov      x0, x19
0x10015f770  bl       #0x10025a4c8
0x10015f774  add      x3, x19, #0x20
0x10015f778  mov      w0, #4
0x10015f77c  mov      w1, #8
0x10015f780  mov      x2, x19
0x10015f784  mov      w4, #4
0x10015f788  mov      w5, #0x11
0x10015f78c  bl       #0x10007b784
0x10015f790  mov      x0, x19
0x10015f794  bl       #0x10025a4b0
0x10015f798  add      x3, x19, #0x20
0x10015f79c  mov      w0, #8
0x10015f7a0  mov      w1, #0xc
0x10015f7a4  mov      x2, x19
0x10015f7a8  mov      w4, #8
0x10015f7ac  mov      w5, #0x19
0x10015f7b0  bl       #0x10007b784
0x10015f7b4  mov      x0, x19
0x10015f7b8  bl       #0x10025a4b0
0x10015f7bc  add      x3, x19, #0x20
0x10015f7c0  mov      w0, #0xc
0x10015f7c4  mov      w1, #0x10
0x10015f7c8  mov      x2, x19
0x10015f7cc  mov      x4, #0
0x10015f7d0  mov      w5, #9
0x10015f7d4  bl       #0x10007b784
0x10015f7d8  mov      x0, x19
0x10015f7dc  bl       #0x10025a4b0
0x10015f7e0  ldur     x19, [x29, #-0x60]
0x10015f7e4  mov      x0, x19
0x10015f7e8  mov      w1, #0x3025
0x10015f7ec  movk     w1, #0x7832, lsl #16
0x10015f7f0  bl       #0x10015f3e0
0x10015f7f4  mov      x20, x0
0x10015f7f8  mov      x21, x1
0x10015f7fc  mov      x0, x19
0x10015f800  bl       #0x10025a2d0
0x10015f804  mov      x0, x20
0x10015f808  mov      x1, x21
0x10015f80c  sub      sp, x29, #0x50
0x10015f810  ldp      x29, x30, [sp, #0x50]
0x10015f814  ldp      x20, x19, [sp, #0x40]
0x10015f818  ldp      x22, x21, [sp, #0x30]
0x10015f81c  ldp      x24, x23, [sp, #0x20]
0x10015f820  ldp      x26, x25, [sp, #0x10]
0x10015f824  ldp      x28, x27, [sp], #0x60
0x10015f828  ret      