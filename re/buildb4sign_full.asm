0x10015f170  sub      sp, sp, #0xc0
0x10015f174  stp      x28, x27, [sp, #0x60]
0x10015f178  stp      x26, x25, [sp, #0x70]
0x10015f17c  stp      x24, x23, [sp, #0x80]
0x10015f180  stp      x22, x21, [sp, #0x90]
0x10015f184  stp      x20, x19, [sp, #0xa0]
0x10015f188  stp      x29, x30, [sp, #0xb0]
0x10015f18c  add      x29, sp, #0xb0
0x10015f190  mov      x19, x2
0x10015f194  mov      x22, x1
0x10015f198  mov      x23, x0
0x10015f19c  mov      x8, #-0x2000000000000000
0x10015f1a0  stp      xzr, x8, [sp, #0x50]
0x10015f1a4  ldr      x20, [x0, #0x10]
0x10015f1a8  cbz      x20, #0x10015f1f8
0x10015f1ac  mov      x0, x23
0x10015f1b0  bl       #0x10025a2e8
0x10015f1b4  mov      x0, x20
0x10015f1b8  mov      x1, #0
0x10015f1bc  bl       #0x100071d6c
0x10015f1c0  mov      x21, x0
0x10015f1c4  add      x0, sp, #0x28
0x10015f1c8  add      x1, x21, #0x20
0x10015f1cc  mov      x2, x20
0x10015f1d0  mov      x3, x23
0x10015f1d4  bl       #0x10015d000
0x10015f1d8  mov      x24, x0
0x10015f1dc  ldp      x0, x1, [sp, #0x28]
0x10015f1e0  ldp      x2, x3, [sp, #0x38]
0x10015f1e4  ldr      x4, [sp, #0x48]
0x10015f1e8  bl       #0x1000ac408
0x10015f1ec  cmp      x24, x20
0x10015f1f0  b.eq     #0x10015f200
0x10015f1f4  brk      #1
0x10015f1f8  adrp     x21, #0x1003be000
0x10015f1fc  ldr      x21, [x21, #0x8f0]
0x10015f200  stp      x22, x19, [sp, #8]
0x10015f204  str      x21, [sp, #0x28]
0x10015f208  add      x0, sp, #0x28
0x10015f20c  mov      x21, #0
0x10015f210  bl       #0x10012874c
0x10015f214  ldr      x0, [sp, #0x28]
0x10015f218  cbnz     x21, #0x10015f3d8
0x10015f21c  str      x0, [sp, #0x18]
0x10015f220  ldr      x28, [x0, #0x10]
0x10015f224  cbz      x28, #0x10015f33c
0x10015f228  mov      w19, #0x6973
0x10015f22c  movk     w19, #0x6e67, lsl #16
0x10015f230  ldr      x8, [sp, #0x18]
0x10015f234  add      x22, x8, #0x28
0x10015f238  mov      x27, #-0x1c00000000000000
0x10015f23c  b        #0x10015f29c
0x10015f240  mov      x26, #0
0x10015f244  mov      x25, #-0x2000000000000000
0x10015f248  mov      x0, x24
0x10015f24c  bl       #0x10025a2d0
0x10015f250  add      x20, sp, #0x28
0x10015f254  mov      x0, x26
0x10015f258  mov      x1, x25
0x10015f25c  bl       #0x100259754
0x10015f260  mov      x0, x25
0x10015f264  bl       #0x10025a2d0
0x10015f268  add      x20, sp, #0x28
0x10015f26c  mov      w0, #0x26
0x10015f270  mov      x1, #-0x1f00000000000000
0x10015f274  bl       #0x100259754
0x10015f278  ldp      x0, x21, [sp, #0x28]
0x10015f27c  add      x20, sp, #0x50
0x10015f280  mov      x1, x21
0x10015f284  bl       #0x100259754
0x10015f288  mov      x0, x21
0x10015f28c  bl       #0x10025a2d0
0x10015f290  add      x22, x22, #0x10
0x10015f294  subs     x28, x28, #1
0x10015f298  b.eq     #0x10015f33c
0x10015f29c  ldp      x25, x24, [x22, #-8]
0x10015f2a0  cmp      x25, x19
0x10015f2a4  ccmp     x24, x27, #0, eq
0x10015f2a8  b.eq     #0x10015f290
0x10015f2ac  mov      x0, x25
0x10015f2b0  mov      x1, x24
0x10015f2b4  mov      w2, #0x6973
0x10015f2b8  movk     w2, #0x6e67, lsl #16
0x10015f2bc  mov      x3, #-0x1c00000000000000
0x10015f2c0  mov      w4, #0
0x10015f2c4  bl       #0x100259d3c
0x10015f2c8  tbnz     w0, #0, #0x10015f290
0x10015f2cc  stp      x25, x24, [sp, #0x28]
0x10015f2d0  mov      x0, x24
0x10015f2d4  mov      w1, #2
0x10015f2d8  bl       #0x10025a2f4
0x10015f2dc  add      x20, sp, #0x28
0x10015f2e0  mov      w0, #0x3d
0x10015f2e4  mov      x1, #-0x1f00000000000000
0x10015f2e8  bl       #0x100259754
0x10015f2ec  ldr      x8, [x23, #0x10]
0x10015f2f0  cbz      x8, #0x10015f240
0x10015f2f4  mov      x0, x23
0x10015f2f8  bl       #0x10025a2e8
0x10015f2fc  mov      x0, x25
0x10015f300  mov      x1, x24
0x10015f304  mov      x20, x23
0x10015f308  bl       #0x10008e3b8
0x10015f30c  tbz      w1, #0, #0x10015f328
0x10015f310  ldr      x8, [x23, #0x38]
0x10015f314  add      x8, x8, x0, lsl #4
0x10015f318  ldp      x26, x25, [x8]
0x10015f31c  mov      x0, x25
0x10015f320  bl       #0x10025a2e8
0x10015f324  b        #0x10015f330
0x10015f328  mov      x26, #0
0x10015f32c  mov      x25, #-0x2000000000000000
0x10015f330  mov      x0, x23
0x10015f334  bl       #0x10025a2d0
0x10015f338  b        #0x10015f248
0x10015f33c  ldr      x0, [sp, #0x18]
0x10015f340  bl       #0x10025a4b0
0x10015f344  mov      x8, #0x6170
0x10015f348  movk     x8, #0x7373, lsl #16
0x10015f34c  movk     x8, #0x6f77, lsl #32
0x10015f350  movk     x8, #0x6472, lsl #48
0x10015f354  mov      x9, #0x3d
0x10015f358  movk     x9, #0xe900, lsl #48
0x10015f35c  stp      x8, x9, [sp, #0x28]
0x10015f360  add      x20, sp, #0x28
0x10015f364  ldp      x22, x19, [sp, #8]
0x10015f368  mov      x0, x22
0x10015f36c  mov      x1, x19
0x10015f370  bl       #0x100259754
0x10015f374  ldp      x0, x21, [sp, #0x28]
0x10015f378  add      x20, sp, #0x50
0x10015f37c  mov      x1, x21
0x10015f380  bl       #0x100259754
0x10015f384  mov      x0, x21
0x10015f388  bl       #0x10025a2d0
0x10015f38c  ldp      x2, x20, [sp, #0x50]
0x10015f390  mov      x0, x22
0x10015f394  mov      x1, x19
0x10015f398  mov      x3, x20
0x10015f39c  bl       #0x10012da74
0x10015f3a0  mov      x19, x0
0x10015f3a4  mov      x21, x1
0x10015f3a8  mov      x0, x20
0x10015f3ac  bl       #0x10025a2d0
0x10015f3b0  mov      x0, x19
0x10015f3b4  mov      x1, x21
0x10015f3b8  ldp      x29, x30, [sp, #0xb0]
0x10015f3bc  ldp      x20, x19, [sp, #0xa0]
0x10015f3c0  ldp      x22, x21, [sp, #0x90]
0x10015f3c4  ldp      x24, x23, [sp, #0x80]
0x10015f3c8  ldp      x26, x25, [sp, #0x70]
0x10015f3cc  ldp      x28, x27, [sp, #0x60]
0x10015f3d0  add      sp, sp, #0xc0
0x10015f3d4  ret      