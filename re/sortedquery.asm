0x10012da74  stp      x28, x27, [sp, #-0x60]!
0x10012da78  stp      x26, x25, [sp, #0x10]
0x10012da7c  stp      x24, x23, [sp, #0x20]
0x10012da80  stp      x22, x21, [sp, #0x30]
0x10012da84  stp      x20, x19, [sp, #0x40]
0x10012da88  stp      x29, x30, [sp, #0x50]
0x10012da8c  add      x29, sp, #0x50
0x10012da90  sub      sp, sp, #0x20
0x10012da94  mov      x24, x3
0x10012da98  mov      x25, x2
0x10012da9c  mov      x26, x1
0x10012daa0  mov      x27, x0
0x10012daa4  adrp     x0, #0x1003d8000
0x10012daa8  add      x0, x0, #0x140
0x10012daac  adrp     x1, #0x100262000
0x10012dab0  add      x1, x1, #0x28
0x10012dab4  bl       #0x100005294
0x10012dab8  mov      x19, x0
0x10012dabc  ldur     x28, [x0, #-8]
0x10012dac0  ldr      x8, [x28, #0x40]
0x10012dac4  mov      x9, x8
0x10012dac8  adrp     x16, #0x1003bc000
0x10012dacc  ldr      x16, [x16, #0xb30]
0x10012dad0  blr      x16
0x10012dad4  mov      x9, sp
0x10012dad8  add      x10, x8, #0xf
0x10012dadc  and      x12, x10, #0xfffffffffffffff0
0x10012dae0  sub      x20, x9, x12
0x10012dae4  mov      sp, x20
0x10012dae8  mov      x9, x8
0x10012daec  adrp     x16, #0x1003bc000
0x10012daf0  ldr      x16, [x16, #0xb30]
0x10012daf4  blr      x16
0x10012daf8  mov      x8, sp
0x10012dafc  sub      x21, x8, x12
0x10012db00  mov      sp, x21
0x10012db04  mov      x0, #0
0x10012db08  bl       #0x1002593c4
0x10012db0c  stur     x0, [x29, #-0x68]
0x10012db10  ldur     x22, [x0, #-8]
0x10012db14  ldr      x8, [x22, #0x40]
0x10012db18  mov      x9, x8
0x10012db1c  adrp     x16, #0x1003bc000
0x10012db20  ldr      x16, [x16, #0xb30]
0x10012db24  blr      x16
0x10012db28  mov      x9, sp
0x10012db2c  add      x8, x8, #0xf
0x10012db30  and      x8, x8, #0xfffffffffffffff0
0x10012db34  sub      x23, x9, x8
0x10012db38  mov      sp, x23
0x10012db3c  mov      x0, x26
0x10012db40  bl       #0x10025a2e8
0x10012db44  mov      x0, x27
0x10012db48  mov      x1, x26
0x10012db4c  bl       #0x1001086f4
0x10012db50  stp      x0, x1, [x29, #-0x60]
0x10012db54  adrp     x26, #0x1003bc000
0x10012db58  ldr      x26, [x26, #0x688]
0x10012db5c  adrp     x2, #0x1003bc000
0x10012db60  ldr      x2, [x2, #0x678]
0x10012db64  sub      x0, x29, #0x60
0x10012db68  mov      x8, x23
0x10012db6c  mov      x1, x26
0x10012db70  bl       #0x1002593ac
0x10012db74  mov      x0, x24
0x10012db78  bl       #0x10025a2e8
0x10012db7c  mov      x0, x25
0x10012db80  mov      x1, x24
0x10012db84  bl       #0x1001086f4
0x10012db88  stp      x0, x1, [x29, #-0x60]
0x10012db8c  mov      x0, #0
0x10012db90  bl       #0x100259520
0x10012db94  mov      x24, x0
0x10012db98  adrp     x1, #0x1003bc000
0x10012db9c  ldr      x1, [x1, #0xfd0]
0x10012dba0  adrp     x0, #0x1003d5000
0x10012dba4  add      x0, x0, #0x260
0x10012dba8  adrp     x2, #0x1003bc000
0x10012dbac  ldr      x2, [x2, #0xfc0]
0x10012dbb0  bl       #0x100005254
0x10012dbb4  mov      x25, x0
0x10012dbb8  bl       #0x1000913d4
0x10012dbbc  mov      x5, x0
0x10012dbc0  sub      x0, x29, #0x60
0x10012dbc4  mov      x8, x21
0x10012dbc8  mov      x1, x23
0x10012dbcc  mov      x2, x24
0x10012dbd0  mov      x3, x26
0x10012dbd4  mov      x4, x25
0x10012dbd8  bl       #0x100259460
0x10012dbdc  ldp      x0, x1, [x29, #-0x60]
0x10012dbe0  bl       #0x100022818
0x10012dbe4  ldr      x8, [x28, #0x10]
0x10012dbe8  mov      x0, x20
0x10012dbec  mov      x1, x21
0x10012dbf0  mov      x2, x19
0x10012dbf4  blr      x8
0x10012dbf8  bl       #0x10012dc6c
0x10012dbfc  mov      x1, x0
0x10012dc00  mov      x0, x19
0x10012dc04  bl       #0x100259844
0x10012dc08  mov      x20, x0
0x10012dc0c  mov      w1, #1
0x10012dc10  bl       #0x10012b4f8
0x10012dc14  mov      x24, x0
0x10012dc18  mov      x25, x1
0x10012dc1c  mov      x0, x20
0x10012dc20  bl       #0x10025a4b0
0x10012dc24  ldr      x8, [x28, #8]
0x10012dc28  mov      x0, x21
0x10012dc2c  mov      x1, x19
0x10012dc30  blr      x8
0x10012dc34  ldr      x8, [x22, #8]
0x10012dc38  mov      x0, x23
0x10012dc3c  ldur     x1, [x29, #-0x68]
0x10012dc40  blr      x8
0x10012dc44  mov      x0, x24
0x10012dc48  mov      x1, x25
0x10012dc4c  sub      sp, x29, #0x50
0x10012dc50  ldp      x29, x30, [sp, #0x50]
0x10012dc54  ldp      x20, x19, [sp, #0x40]
0x10012dc58  ldp      x22, x21, [sp, #0x30]
0x10012dc5c  ldp      x24, x23, [sp, #0x20]
0x10012dc60  ldp      x26, x25, [sp, #0x10]
0x10012dc64  ldp      x28, x27, [sp], #0x60
0x10012dc68  ret      