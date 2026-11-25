0x10015cccc  sub      sp, sp, #0x50
0x10015ccd0  stp      x23, x22, [sp, #0x20]
0x10015ccd4  stp      x20, x19, [sp, #0x30]
0x10015ccd8  stp      x29, x30, [sp, #0x40]
0x10015ccdc  add      x29, sp, #0x40
0x10015cce0  mov      x20, x2
0x10015cce4  adrp     x9, #0x1003bc000
0x10015cce8  ldr      x9, [x9, #0xb40]
0x10015ccec  ldr      x9, [x9]
0x10015ccf0  str      x9, [sp, #0x18]
0x10015ccf4  lsr      x9, x1, #0x3e
0x10015ccf8  cmp      w9, #1
0x10015ccfc  b.gt     #0x10015cdc0
0x10015cd00  cbnz     w9, #0x10015cdd0
0x10015cd04  lsr      x8, x0, #8
0x10015cd08  strb     w0, [sp, #8]
0x10015cd0c  lsr      x9, x0, #0x10
0x10015cd10  lsr      x10, x0, #0x18
0x10015cd14  strb     w8, [sp, #9]
0x10015cd18  strb     w9, [sp, #0xa]
0x10015cd1c  lsr      x8, x0, #0x20
0x10015cd20  lsr      x9, x0, #0x28
0x10015cd24  strb     w10, [sp, #0xb]
0x10015cd28  strb     w8, [sp, #0xc]
0x10015cd2c  lsr      x8, x0, #0x30
0x10015cd30  lsr      x10, x0, #0x38
0x10015cd34  strb     w9, [sp, #0xd]
0x10015cd38  strb     w8, [sp, #0xe]
0x10015cd3c  lsr      x8, x1, #8
0x10015cd40  lsr      x9, x1, #0x10
0x10015cd44  strb     w10, [sp, #0xf]
0x10015cd48  strb     w1, [sp, #0x10]
0x10015cd4c  lsr      x10, x1, #0x18
0x10015cd50  lsr      x11, x1, #0x20
0x10015cd54  strb     w8, [sp, #0x11]
0x10015cd58  strb     w9, [sp, #0x12]
0x10015cd5c  lsr      x8, x1, #0x28
0x10015cd60  lsr      x9, x1, #0x30
0x10015cd64  strb     w10, [sp, #0x13]
0x10015cd68  strb     w11, [sp, #0x14]
0x10015cd6c  add      x10, sp, #8
0x10015cd70  strb     w8, [sp, #0x15]
0x10015cd74  add      x19, x10, w9, uxtb
0x10015cd78  mov      x0, #0
0x10015cd7c  mov      x23, x21
0x10015cd80  bl       #0x100259538
0x10015cd84  mov      x22, x0
0x10015cd88  adrp     x1, #0x1003bc000
0x10015cd8c  ldr      x1, [x1, #0xff8]
0x10015cd90  adrp     x0, #0x1003d7000
0x10015cd94  add      x0, x0, #0xc60
0x10015cd98  adrp     x2, #0x1003bc000
0x10015cd9c  ldr      x2, [x2, #0xff0]
0x10015cda0  bl       #0x100005254
0x10015cda4  mov      x3, x0
0x10015cda8  add      x0, sp, #8
0x10015cdac  mov      x1, x19
0x10015cdb0  mov      x2, x22
0x10015cdb4  bl       #0x100259358
0x10015cdb8  mov      x21, x23
0x10015cdbc  b        #0x10015ce44
0x10015cdc0  cmp      w9, #2
0x10015cdc4  b.ne     #0x10015cdf8
0x10015cdc8  ldp      x9, x10, [x0, #0x10]
0x10015cdcc  b        #0x10015cde0
0x10015cdd0  sxtw     x9, w0
0x10015cdd4  asr      x10, x0, #0x20
0x10015cdd8  cmp      x10, x9
0x10015cddc  b.lt     #0x10015ce70
0x10015cde0  and      x2, x1, #0x3fffffffffffffff
0x10015cde4  mov      x0, x9
0x10015cde8  mov      x1, x10
0x10015cdec  mov      x3, x20
0x10015cdf0  bl       #0x10015ce78
0x10015cdf4  b        #0x10015ce44
0x10015cdf8  mov      x0, #0
0x10015cdfc  mov      x22, x21
0x10015ce00  bl       #0x100259538
0x10015ce04  mov      x19, x0
0x10015ce08  adrp     x1, #0x1003bc000
0x10015ce0c  ldr      x1, [x1, #0xff8]
0x10015ce10  adrp     x0, #0x1003d7000
0x10015ce14  add      x0, x0, #0xc60
0x10015ce18  adrp     x2, #0x1003bc000
0x10015ce1c  ldr      x2, [x2, #0xff0]
0x10015ce20  bl       #0x100005254
0x10015ce24  mov      x3, x0
0x10015ce28  str      xzr, [sp, #8]
0x10015ce2c  stur     xzr, [sp, #0xe]
0x10015ce30  add      x0, sp, #8
0x10015ce34  add      x1, sp, #8
0x10015ce38  mov      x2, x19
0x10015ce3c  bl       #0x100259358
0x10015ce40  mov      x21, x22
0x10015ce44  ldr      x8, [sp, #0x18]
0x10015ce48  adrp     x9, #0x1003bc000
0x10015ce4c  ldr      x9, [x9, #0xb40]
0x10015ce50  ldr      x9, [x9]
0x10015ce54  cmp      x9, x8
0x10015ce58  b.ne     #0x10015ce74
0x10015ce5c  ldp      x29, x30, [sp, #0x40]
0x10015ce60  ldp      x20, x19, [sp, #0x30]
0x10015ce64  ldp      x23, x22, [sp, #0x20]
0x10015ce68  add      sp, sp, #0x50
0x10015ce6c  ret      