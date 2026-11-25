0x10012b4f8  sub      sp, sp, #0x50
0x10012b4fc  stp      x24, x23, [sp, #0x10]
0x10012b500  stp      x22, x21, [sp, #0x20]
0x10012b504  stp      x20, x19, [sp, #0x30]
0x10012b508  stp      x29, x30, [sp, #0x40]
0x10012b50c  add      x29, sp, #0x40
0x10012b510  mov      x21, x0
0x10012b514  tbz      w1, #0, #0x10012b534
0x10012b518  adrp     x8, #0x1003d8000
0x10012b51c  ldr      x8, [x8, #0x160]
0x10012b520  cmn      x8, #1
0x10012b524  b.ne     #0x10012b600
0x10012b528  adrp     x8, #0x1003d8000
0x10012b52c  add      x8, x8, #0x168
0x10012b530  b        #0x10012b54c
0x10012b534  adrp     x8, #0x1003d8000
0x10012b538  ldr      x8, [x8, #0x150]
0x10012b53c  cmn      x8, #1
0x10012b540  b.ne     #0x10012b618
0x10012b544  adrp     x8, #0x1003d8000
0x10012b548  add      x8, x8, #0x158
0x10012b54c  ldr      x19, [x8]
0x10012b550  mov      x8, #-0x2000000000000000
0x10012b554  stp      xzr, x8, [sp]
0x10012b558  ldr      x23, [x21, #0x10]
0x10012b55c  mov      x8, #0x4000000000000000
0x10012b560  cmn      x23, x8
0x10012b564  b.mi     #0x10012b5fc
0x10012b568  lsl      x22, x23, #1
0x10012b56c  mov      x0, x19
0x10012b570  bl       #0x10025a2e8
0x10012b574  mov      x20, sp
0x10012b578  mov      x0, x22
0x10012b57c  bl       #0x1002596e8
0x10012b580  cbz      x23, #0x10012b5d0
0x10012b584  add      x21, x21, #0x20
0x10012b588  add      x22, x19, #0x20
0x10012b58c  ldrb     w24, [x21], #1
0x10012b590  lsr      x8, x24, #4
0x10012b594  ldr      x9, [x19, #0x10]
0x10012b598  cmp      x9, x8
0x10012b59c  b.ls     #0x10012b5f4
0x10012b5a0  ldr      w0, [x22, x8, lsl #2]
0x10012b5a4  mov      x20, sp
0x10012b5a8  bl       #0x1002596f4
0x10012b5ac  and      x8, x24, #0xf
0x10012b5b0  ldr      x9, [x19, #0x10]
0x10012b5b4  cmp      x9, x8
0x10012b5b8  b.ls     #0x10012b5f8
0x10012b5bc  ldr      w0, [x22, x8, lsl #2]
0x10012b5c0  mov      x20, sp
0x10012b5c4  bl       #0x1002596f4
0x10012b5c8  subs     x23, x23, #1
0x10012b5cc  b.ne     #0x10012b58c
0x10012b5d0  mov      x0, x19
0x10012b5d4  bl       #0x10025a2d0
0x10012b5d8  ldp      x0, x1, [sp]
0x10012b5dc  ldp      x29, x30, [sp, #0x40]
0x10012b5e0  ldp      x20, x19, [sp, #0x30]
0x10012b5e4  ldp      x22, x21, [sp, #0x20]
0x10012b5e8  ldp      x24, x23, [sp, #0x10]
0x10012b5ec  add      sp, sp, #0x50
0x10012b5f0  ret      
0x10012b5f4  brk      #1