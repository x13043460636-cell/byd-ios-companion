0x1001557a0  stp      d9, d8, [sp, #-0x70]!
0x1001557a4  stp      x28, x27, [sp, #0x10]
0x1001557a8  stp      x26, x25, [sp, #0x20]
0x1001557ac  stp      x24, x23, [sp, #0x30]
0x1001557b0  stp      x22, x21, [sp, #0x40]
0x1001557b4  stp      x20, x19, [sp, #0x50]
0x1001557b8  stp      x29, x30, [sp, #0x60]
0x1001557bc  add      x29, sp, #0x60
0x1001557c0  sub      sp, sp, #0x40
0x1001557c4  mov      x19, x20
0x1001557c8  stp      x1, x0, [x29, #-0x98]
0x1001557cc  mov      x24, #0x65
0x1001557d0  movk     x24, #0xe900, lsl #48
0x1001557d4  mov      x27, #0x6177
0x1001557d8  movk     x27, #0x6374, lsl #16
0x1001557dc  movk     x27, #0x4968, lsl #32
0x1001557e0  movk     x27, #0x656d, lsl #48
0x1001557e4  mov      x0, #0
0x1001557e8  bl       #0x1002582e4
0x1001557ec  ldur     x8, [x0, #-8]
0x1001557f0  stp      x0, x8, [x29, #-0x88]
0x1001557f4  ldr      x8, [x8, #0x40]
0x1001557f8  mov      x9, x8
0x1001557fc  adrp     x16, #0x1003bc000
0x100155800  ldr      x16, [x16, #0xb30]
0x100155804  blr      x16
0x100155808  mov      x9, sp
0x10015580c  add      x8, x8, #0xf
0x100155810  and      x8, x8, #0xfffffffffffffff0
0x100155814  sub      x25, x9, x8
0x100155818  mov      sp, x25
0x10015581c  adrp     x23, #0x1003be000
0x100155820  ldr      x23, [x23, #0x8f0]
0x100155824  mov      x0, x23
0x100155828  bl       #0x100078394
0x10015582c  mov      x20, x0
0x100155830  stur     x23, [x29, #-0x70]
0x100155834  ldp      x21, x28, [x19, #0x10]
0x100155838  add      x1, x24, #4
0x10015583c  mov      x0, x27
0x100155840  mov      x2, x23
0x100155844  bl       #0x10010abd0
0x100155848  mov      x26, x0
0x10015584c  mov      x0, x28
0x100155850  bl       #0x10025a2e8
0x100155854  tbnz     w26, #0, #0x100155898
0x100155858  adrp     x3, #0x1003be000
0x10015585c  ldr      x3, [x3, #0x8f0]
0x100155860  mov      w0, #0
0x100155864  mov      w1, #1
0x100155868  mov      w2, #1
0x10015586c  bl       #0x100070390
0x100155870  mov      x23, x0
0x100155874  ldp      x22, x8, [x0, #0x10]
0x100155878  add      x26, x22, #1
0x10015587c  cmp      x22, x8, lsr #1
0x100155880  b.hs     #0x100155e30
0x100155884  str      x26, [x23, #0x10]
0x100155888  add      x8, x23, x22, lsl #4
0x10015588c  add      x9, x24, #4
0x100155890  stp      x27, x9, [x8, #0x20]
0x100155894  stur     x23, [x29, #-0x70]
0x100155898  mov      x22, #0x646e
0x10015589c  movk     x22, #0xea00, lsl #48
0x1001558a0  mov      x26, #0x6177
0x1001558a4  movk     x26, #0x6374, lsl #16
0x1001558a8  movk     x26, #0x4d68, lsl #32
0x1001558ac  movk     x26, #0x646f, lsl #48
0x1001558b0  mov      x0, x20
0x1001558b4  bl       #0x10025a48c
0x1001558b8  mov      x4, x0
0x1001558bc  stur     x20, [x29, #-0x78]
0x1001558c0  add      x3, x24, #4
0x1001558c4  sub      x20, x29, #0x78
0x1001558c8  mov      x0, x21
0x1001558cc  mov      x1, x28
0x1001558d0  mov      x2, x27
0x1001558d4  bl       #0x100073470
0x1001558d8  ldur     x20, [x29, #-0x78]
0x1001558dc  stur     x20, [x29, #-0x68]
0x1001558e0  ldp      x28, x21, [x19, #0x20]
0x1001558e4  add      x1, x22, #0x7f7
0x1001558e8  mov      x0, x26
0x1001558ec  mov      x2, x23
0x1001558f0  bl       #0x10010abd0
0x1001558f4  mov      x27, x0
0x1001558f8  mov      x0, x21
0x1001558fc  bl       #0x10025a2e8
0x100155900  tbnz     w27, #0, #0x100155938
0x100155904  mov      x0, x23
0x100155908  bl       #0x10025a48c
0x10015590c  tbz      w0, #0, #0x100155e50
0x100155910  ldp      x27, x8, [x23, #0x10]
0x100155914  add      x20, x27, #1
0x100155918  cmp      x27, x8, lsr #1
0x10015591c  b.hs     #0x100155e70
0x100155920  str      x20, [x23, #0x10]
0x100155924  add      x8, x23, x27, lsl #4
0x100155928  add      x9, x22, #0x7f7
0x10015592c  stp      x26, x9, [x8, #0x20]
0x100155930  stur     x23, [x29, #-0x70]
0x100155934  ldur     x20, [x29, #-0x68]
0x100155938  mov      x27, #0x6177
0x10015593c  movk     x27, #0x6374, lsl #16
0x100155940  movk     x27, #0x4268, lsl #32
0x100155944  movk     x27, #0x6172, lsl #48
0x100155948  mov      x0, x20
0x10015594c  bl       #0x10025a48c
0x100155950  mov      x4, x0
0x100155954  stur     x20, [x29, #-0x78]
0x100155958  add      x3, x22, #0x7f7
0x10015595c  sub      x20, x29, #0x78
0x100155960  mov      x0, x28
0x100155964  mov      x1, x21
0x100155968  mov      x2, x26
0x10015596c  bl       #0x100073470
0x100155970  ldur     x20, [x29, #-0x78]
0x100155974  stur     x20, [x29, #-0x68]
0x100155978  ldp      x21, x28, [x19, #0x30]
0x10015597c  mov      x0, x27
0x100155980  mov      x1, #0x646e
0x100155984  movk     x1, #0xea00, lsl #48
0x100155988  mov      x2, x23
0x10015598c  bl       #0x10010abd0
0x100155990  mov      x26, x0
0x100155994  mov      x0, x28
0x100155998  bl       #0x10025a2e8
0x10015599c  tbnz     w26, #0, #0x1001559d0
0x1001559a0  mov      x0, x23
0x1001559a4  bl       #0x10025a48c
0x1001559a8  tbz      w0, #0, #0x100155e90
0x1001559ac  ldp      x26, x8, [x23, #0x10]
0x1001559b0  add      x20, x26, #1
0x1001559b4  cmp      x26, x8, lsr #1
0x1001559b8  b.hs     #0x100155eb0
0x1001559bc  str      x20, [x23, #0x10]
0x1001559c0  add      x8, x23, x26, lsl #4
0x1001559c4  stp      x27, x22, [x8, #0x20]
0x1001559c8  stur     x23, [x29, #-0x70]
0x1001559cc  ldur     x20, [x29, #-0x68]
0x1001559d0  mov      x26, #0x6177
0x1001559d4  movk     x26, #0x6374, lsl #16
0x1001559d8  movk     x26, #0x4e68, lsl #32
0x1001559dc  movk     x26, #0x6d61, lsl #48
0x1001559e0  mov      x0, x20
0x1001559e4  bl       #0x10025a48c
0x1001559e8  mov      x4, x0
0x1001559ec  stur     x20, [x29, #-0x78]
0x1001559f0  sub      x20, x29, #0x78
0x1001559f4  mov      x0, x21
0x1001559f8  mov      x1, x28
0x1001559fc  mov      x2, x27
0x100155a00  mov      x3, #0x646e
0x100155a04  movk     x3, #0xea00, lsl #48
0x100155a08  bl       #0x100073470
0x100155a0c  ldur     x20, [x29, #-0x78]
0x100155a10  stur     x20, [x29, #-0x68]
0x100155a14  ldp      x21, x27, [x19, #0x40]
0x100155a18  mov      x0, x26
0x100155a1c  mov      x1, #0x65
0x100155a20  movk     x1, #0xe900, lsl #48
0x100155a24  mov      x2, x23
0x100155a28  bl       #0x10010abd0
0x100155a2c  mov      x28, x0
0x100155a30  mov      x0, x27
0x100155a34  bl       #0x10025a2e8
0x100155a38  tbnz     w28, #0, #0x100155a6c
0x100155a3c  mov      x0, x23
0x100155a40  bl       #0x10025a48c
0x100155a44  tbz      w0, #0, #0x100155ed0
0x100155a48  ldp      x22, x8, [x23, #0x10]
0x100155a4c  add      x20, x22, #1
0x100155a50  cmp      x22, x8, lsr #1
0x100155a54  b.hs     #0x100155ef0
0x100155a58  str      x20, [x23, #0x10]
0x100155a5c  add      x8, x23, x22, lsl #4
0x100155a60  stp      x26, x24, [x8, #0x20]
0x100155a64  stur     x23, [x29, #-0x70]
0x100155a68  ldur     x20, [x29, #-0x68]
0x100155a6c  mov      x0, x20
0x100155a70  bl       #0x10025a48c
0x100155a74  mov      x4, x0
0x100155a78  stur     x20, [x29, #-0x78]
0x100155a7c  sub      x20, x29, #0x78
0x100155a80  mov      x0, x21
0x100155a84  mov      x1, x27
0x100155a88  mov      x2, x26
0x100155a8c  mov      x3, #0x65
0x100155a90  movk     x3, #0xe900, lsl #48
0x100155a94  bl       #0x100073470
0x100155a98  ldur     x8, [x29, #-0x78]
0x100155a9c  stur     x8, [x29, #-0x68]
0x100155aa0  ldr      x21, [x19, #0x60]
0x100155aa4  mov      x8, x25
0x100155aa8  bl       #0x1002582d8
0x100155aac  mov      x20, x25
0x100155ab0  bl       #0x10025829c
0x100155ab4  mov      v8.16b, v0.16b
0x100155ab8  ldp      x1, x8, [x29, #-0x88]
0x100155abc  ldr      x8, [x8, #8]
0x100155ac0  mov      x0, x25
0x100155ac4  blr      x8
0x100155ac8  mov      x8, #0x400000000000
0x100155acc  movk     x8, #0x408f, lsl #48
0x100155ad0  fmov     d0, x8
0x100155ad4  fmul     d0, d8, d0
0x100155ad8  fmov     x8, d0
0x100155adc  and      x8, x8, #0x7fffffffffffffff
0x100155ae0  mov      x9, #0x7fefffffffffffff
0x100155ae4  cmp      x8, x9
0x100155ae8  b.gt     #0x100155e20
0x100155aec  mov      x8, #1
0x100155af0  movk     x8, #0xc3e0, lsl #48
0x100155af4  fmov     d1, x8
0x100155af8  fcmp     d0, d1
0x100155afc  b.le     #0x100155e24
0x100155b00  mov      x8, #0x43e0000000000000
0x100155b04  fmov     d1, x8
0x100155b08  fcmp     d0, d1
0x100155b0c  b.pl     #0x100155e28
0x100155b10  fcvtzs   x8, d0
0x100155b14  adds     x8, x21, x8
0x100155b18  b.vs     #0x100155e2c
0x100155b1c  mov      x26, #0x6174
0x100155b20  movk     x26, #0x706d, lsl #16
0x100155b24  movk     x26, #0xec00, lsl #48
0x100155b28  mov      x27, #0x6572
0x100155b2c  movk     x27, #0x5471, lsl #16
0x100155b30  movk     x27, #0x6d69, lsl #32
0x100155b34  movk     x27, #0x7365, lsl #48
0x100155b38  stur     x8, [x29, #-0x78]
0x100155b3c  adrp     x0, #0x1003be000
0x100155b40  ldr      x0, [x0, #0x7b8]
0x100155b44  adrp     x1, #0x1003be000
0x100155b48  ldr      x1, [x1, #0x7c0]
0x100155b4c  sub      x20, x29, #0x78
0x100155b50  bl       #0x100259d24
0x100155b54  mov      x21, x0
0x100155b58  mov      x28, x1
0x100155b5c  mov      x0, x27
0x100155b60  mov      x1, x26
0x100155b64  mov      x2, x23
0x100155b68  bl       #0x10010abd0
0x100155b6c  tbnz     w0, #0, #0x100155b9c
0x100155b70  mov      x0, x23
0x100155b74  bl       #0x10025a48c
0x100155b78  tbz      w0, #0, #0x100155f10
0x100155b7c  ldp      x22, x8, [x23, #0x10]
0x100155b80  add      x20, x22, #1
0x100155b84  cmp      x22, x8, lsr #1
0x100155b88  b.hs     #0x100155f30
0x100155b8c  str      x20, [x23, #0x10]
0x100155b90  add      x8, x23, x22, lsl #4
0x100155b94  stp      x27, x26, [x8, #0x20]
0x100155b98  stur     x23, [x29, #-0x70]
0x100155b9c  mov      x24, #0x6556
0x100155ba0  movk     x24, #0x7372, lsl #16
0x100155ba4  movk     x24, #0x6f69, lsl #32
0x100155ba8  movk     x24, #0xef6e, lsl #48
0x100155bac  mov      x25, #0x6177
0x100155bb0  movk     x25, #0x6374, lsl #16
0x100155bb4  movk     x25, #0x4168, lsl #32
0x100155bb8  movk     x25, #0x7070, lsl #48
0x100155bbc  ldur     x20, [x29, #-0x68]
0x100155bc0  mov      x0, x20
0x100155bc4  bl       #0x10025a48c
0x100155bc8  mov      x4, x0
0x100155bcc  stur     x20, [x29, #-0x78]
0x100155bd0  sub      x20, x29, #0x78
0x100155bd4  mov      x0, x21
0x100155bd8  mov      x1, x28
0x100155bdc  mov      x2, x27
0x100155be0  mov      x3, x26
0x100155be4  bl       #0x100073470
0x100155be8  ldur     x8, [x29, #-0x78]
0x100155bec  stur     x8, [x29, #-0x68]
0x100155bf0  mov      x0, x25
0x100155bf4  mov      x1, x24
0x100155bf8  mov      x2, x23
0x100155bfc  bl       #0x10010abd0
0x100155c00  tbz      w0, #0, #0x100155c0c
0x100155c04  ldur     x22, [x29, #-0x90]
0x100155c08  b        #0x100155c3c
0x100155c0c  mov      x0, x23
0x100155c10  bl       #0x10025a48c
0x100155c14  ldur     x22, [x29, #-0x90]
0x100155c18  tbz      w0, #0, #0x100155f50
0x100155c1c  ldp      x21, x8, [x23, #0x10]
0x100155c20  add      x20, x21, #1
0x100155c24  cmp      x21, x8, lsr #1
0x100155c28  b.hs     #0x100155f70
0x100155c2c  str      x20, [x23, #0x10]
0x100155c30  add      x8, x23, x21, lsl #4
0x100155c34  stp      x25, x24, [x8, #0x20]
0x100155c38  stur     x23, [x29, #-0x70]
0x100155c3c  mov      x26, #0x6177
0x100155c40  movk     x26, #0x6374, lsl #16
0x100155c44  movk     x26, #0x4f68, lsl #32
0x100155c48  movk     x26, #0x73, lsl #48
0x100155c4c  ldur     x20, [x29, #-0x68]
0x100155c50  mov      x0, x20
0x100155c54  bl       #0x10025a48c
0x100155c58  mov      x4, x0
0x100155c5c  stur     x20, [x29, #-0x78]
0x100155c60  sub      x20, x29, #0x78
0x100155c64  mov      w0, #0x3734
0x100155c68  movk     w0, #0x30, lsl #16
0x100155c6c  mov      x1, #-0x1d00000000000000
0x100155c70  mov      x2, x25
0x100155c74  mov      x3, x24
0x100155c78  bl       #0x100073470
0x100155c7c  ldur     x8, [x29, #-0x78]
0x100155c80  stur     x8, [x29, #-0x68]
0x100155c84  mov      x0, x26
0x100155c88  mov      x1, #-0x1900000000000000
0x100155c8c  mov      x2, x23
0x100155c90  bl       #0x10010abd0
0x100155c94  tbnz     w0, #0, #0x100155cc8
0x100155c98  mov      x0, x23
0x100155c9c  bl       #0x10025a48c
0x100155ca0  tbz      w0, #0, #0x100155f90
0x100155ca4  ldp      x21, x8, [x23, #0x10]
0x100155ca8  add      x20, x21, #1
0x100155cac  cmp      x21, x8, lsr #1
0x100155cb0  b.hs     #0x100155fb0
0x100155cb4  str      x20, [x23, #0x10]
0x100155cb8  add      x8, x23, x21, lsl #4
0x100155cbc  mov      x9, #-0x1900000000000000
0x100155cc0  stp      x26, x9, [x8, #0x20]
0x100155cc4  stur     x23, [x29, #-0x70]
0x100155cc8  ldur     x20, [x29, #-0x68]
0x100155ccc  mov      x0, x20
0x100155cd0  bl       #0x10025a48c
0x100155cd4  mov      x4, x0
0x100155cd8  stur     x20, [x29, #-0x78]
0x100155cdc  mov      x0, #0x4e41
0x100155ce0  movk     x0, #0x5244, lsl #16
0x100155ce4  movk     x0, #0x494f, lsl #32
0x100155ce8  movk     x0, #0x44, lsl #48
0x100155cec  sub      x20, x29, #0x78
0x100155cf0  mov      x1, #-0x1900000000000000
0x100155cf4  mov      x2, x26
0x100155cf8  mov      x3, #-0x1900000000000000
0x100155cfc  bl       #0x100073470
0x100155d00  ldur     x20, [x29, #-0x78]
0x100155d04  stur     x20, [x29, #-0x68]
0x100155d08  cbz      x22, #0x100155d20
0x100155d0c  sub      x20, x29, #0x70
0x100155d10  mov      x0, x22
0x100155d14  ldur     x1, [x29, #-0x98]
0x100155d18  bl       #0x100160460
0x100155d1c  ldur     x20, [x29, #-0x68]
0x100155d20  mov      w23, #0x6973
0x100155d24  movk     w23, #0x6e67, lsl #16
0x100155d28  ldp      x21, x19, [x19, #0x10]
0x100155d2c  mov      x0, x19
0x100155d30  bl       #0x10025a2e8
0x100155d34  mov      x0, x20
0x100155d38  mov      x1, x21
0x100155d3c  mov      x2, x19
0x100155d40  bl       #0x10015f170
0x100155d44  mov      x21, x0
0x100155d48  mov      x22, x1
0x100155d4c  mov      x0, x19
0x100155d50  bl       #0x10025a2d0
0x100155d54  ldur     x19, [x29, #-0x70]
0x100155d58  mov      w0, #0x6973
0x100155d5c  movk     w0, #0x6e67, lsl #16
0x100155d60  mov      x1, #-0x1c00000000000000
0x100155d64  mov      x2, x19
0x100155d68  bl       #0x10010abd0
0x100155d6c  tbnz     w0, #0, #0x100155da0
0x100155d70  mov      x0, x19
0x100155d74  bl       #0x10025a48c
0x100155d78  tbz      w0, #0, #0x100155fd0
0x100155d7c  ldp      x24, x8, [x19, #0x10]
0x100155d80  add      x20, x24, #1
0x100155d84  cmp      x24, x8, lsr #1
0x100155d88  b.hs     #0x100155ff0
0x100155d8c  str      x20, [x19, #0x10]
0x100155d90  add      x8, x19, x24, lsl #4
0x100155d94  mov      x9, #-0x1c00000000000000
0x100155d98  stp      x23, x9, [x8, #0x20]
0x100155d9c  ldur     x20, [x29, #-0x68]
0x100155da0  mov      x0, x20
0x100155da4  bl       #0x10025a48c
0x100155da8  mov      x4, x0
0x100155dac  stur     x20, [x29, #-0x78]
0x100155db0  sub      x20, x29, #0x78
0x100155db4  mov      x0, x21
0x100155db8  mov      x1, x22
0x100155dbc  mov      w2, #0x6973
0x100155dc0  movk     w2, #0x6e67, lsl #16
0x100155dc4  mov      x3, #-0x1c00000000000000
0x100155dc8  bl       #0x100073470
0x100155dcc  ldur     x20, [x29, #-0x78]
0x100155dd0  mov      x0, x19
0x100155dd4  mov      x1, x20
0x100155dd8  bl       #0x1001601b4
0x100155ddc  mov      x21, x0
0x100155de0  mov      x22, x1
0x100155de4  mov      x0, x20
0x100155de8  bl       #0x10025a4b0
0x100155dec  mov      x0, x19
0x100155df0  bl       #0x10025a2d0
0x100155df4  mov      x0, x21
0x100155df8  mov      x1, x22
0x100155dfc  sub      sp, x29, #0x60
0x100155e00  ldp      x29, x30, [sp, #0x60]
0x100155e04  ldp      x20, x19, [sp, #0x50]
0x100155e08  ldp      x22, x21, [sp, #0x40]
0x100155e0c  ldp      x24, x23, [sp, #0x30]
0x100155e10  ldp      x26, x25, [sp, #0x20]
0x100155e14  ldp      x28, x27, [sp, #0x10]
0x100155e18  ldp      d9, d8, [sp], #0x70
0x100155e1c  ret      
0x100155e20  brk      #1
0x100155e24  brk      #1
0x100155e28  brk      #1
0x100155e2c  brk      #1
0x100155e30  cmp      x8, #1
0x100155e34  cset     w0, hi
0x100155e38  mov      x1, x26
0x100155e3c  mov      w2, #1
0x100155e40  mov      x3, x23
0x100155e44  bl       #0x100070390
0x100155e48  mov      x23, x0
0x100155e4c  b        #0x100155884
0x100155e50  ldr      x8, [x23, #0x10]
0x100155e54  add      x1, x8, #1
0x100155e58  mov      w0, #0
0x100155e5c  mov      w2, #1
0x100155e60  mov      x3, x23
0x100155e64  bl       #0x100070390
0x100155e68  mov      x23, x0
0x100155e6c  b        #0x100155910
0x100155e70  cmp      x8, #1
0x100155e74  cset     w0, hi
0x100155e78  mov      x1, x20
0x100155e7c  mov      w2, #1
0x100155e80  mov      x3, x23
0x100155e84  bl       #0x100070390
0x100155e88  mov      x23, x0
0x100155e8c  b        #0x100155920
0x100155e90  ldr      x8, [x23, #0x10]
0x100155e94  add      x1, x8, #1
0x100155e98  mov      w0, #0
0x100155e9c  mov      w2, #1
0x100155ea0  mov      x3, x23
0x100155ea4  bl       #0x100070390
0x100155ea8  mov      x23, x0
0x100155eac  b        #0x1001559ac
0x100155eb0  cmp      x8, #1
0x100155eb4  cset     w0, hi
0x100155eb8  mov      x1, x20
0x100155ebc  mov      w2, #1
0x100155ec0  mov      x3, x23
0x100155ec4  bl       #0x100070390
0x100155ec8  mov      x23, x0
0x100155ecc  b        #0x1001559bc
0x100155ed0  ldr      x8, [x23, #0x10]
0x100155ed4  add      x1, x8, #1
0x100155ed8  mov      w0, #0
0x100155edc  mov      w2, #1
0x100155ee0  mov      x3, x23
0x100155ee4  bl       #0x100070390
0x100155ee8  mov      x23, x0
0x100155eec  b        #0x100155a48
0x100155ef0  cmp      x8, #1
0x100155ef4  cset     w0, hi
0x100155ef8  mov      x1, x20
0x100155efc  mov      w2, #1
0x100155f00  mov      x3, x23
0x100155f04  bl       #0x100070390
0x100155f08  mov      x23, x0
0x100155f0c  b        #0x100155a58
0x100155f10  ldr      x8, [x23, #0x10]
0x100155f14  add      x1, x8, #1
0x100155f18  mov      w0, #0
0x100155f1c  mov      w2, #1
0x100155f20  mov      x3, x23
0x100155f24  bl       #0x100070390
0x100155f28  mov      x23, x0
0x100155f2c  b        #0x100155b7c
0x100155f30  cmp      x8, #1
0x100155f34  cset     w0, hi
0x100155f38  mov      x1, x20
0x100155f3c  mov      w2, #1
0x100155f40  mov      x3, x23
0x100155f44  bl       #0x100070390
0x100155f48  mov      x23, x0
0x100155f4c  b        #0x100155b8c
0x100155f50  ldr      x8, [x23, #0x10]
0x100155f54  add      x1, x8, #1
0x100155f58  mov      w0, #0
0x100155f5c  mov      w2, #1
0x100155f60  mov      x3, x23
0x100155f64  bl       #0x100070390
0x100155f68  mov      x23, x0
0x100155f6c  b        #0x100155c1c
0x100155f70  cmp      x8, #1
0x100155f74  cset     w0, hi
0x100155f78  mov      x1, x20
0x100155f7c  mov      w2, #1
0x100155f80  mov      x3, x23
0x100155f84  bl       #0x100070390
0x100155f88  mov      x23, x0
0x100155f8c  b        #0x100155c2c
0x100155f90  ldr      x8, [x23, #0x10]
0x100155f94  add      x1, x8, #1
0x100155f98  mov      w0, #0
0x100155f9c  mov      w2, #1
0x100155fa0  mov      x3, x23
0x100155fa4  bl       #0x100070390
0x100155fa8  mov      x23, x0
0x100155fac  b        #0x100155ca4
0x100155fb0  cmp      x8, #1
0x100155fb4  cset     w0, hi
0x100155fb8  mov      x1, x20
0x100155fbc  mov      w2, #1
0x100155fc0  mov      x3, x23
0x100155fc4  bl       #0x100070390
0x100155fc8  mov      x23, x0
0x100155fcc  b        #0x100155cb4
0x100155fd0  ldr      x8, [x19, #0x10]
0x100155fd4  add      x1, x8, #1
0x100155fd8  mov      w0, #0
0x100155fdc  mov      w2, #1
0x100155fe0  mov      x3, x19
0x100155fe4  bl       #0x100070390
0x100155fe8  mov      x19, x0
0x100155fec  b        #0x100155d7c
0x100155ff0  cmp      x8, #1
0x100155ff4  cset     w0, hi
0x100155ff8  mov      x1, x20
0x100155ffc  mov      w2, #1
0x100156000  mov      x3, x19
0x100156004  bl       #0x100070390
0x100156008  mov      x19, x0
0x10015600c  b        #0x100155d8c