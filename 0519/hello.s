	.file	"hello.c"
	.global	a_global
	.data
	.align	2
	.type	a_global, %object
	.size	a_global, 4
a_global:
	.word	10
	.bss
	.align	2
foo_counts.0:
	.space	4
	.text
	.align	2
	.global	foo
	.type	foo, %function
foo:
	@ args = 0, pretend = 0, frame = 4
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #4
	str	r0, [fp, #-16]
	ldr	r2, .L2
	ldr	r3, .L2
	ldr	r3, [r3, #0]
	add	r3, r3, #1
	str	r3, [r2, #0]
	ldr	r3, .L2
	ldr	r2, [r3, #0]
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	mov	r0, r3
	ldmfd	sp, {r3, fp, sp, pc}
.L3:
	.align	2
.L2:
	.word	foo_counts.0
	.size	foo, .-foo
	.section	.rodata
	.align	2
.LC0:
	.ascii	"hello, world!\n\000"
	.align	2
.LC1:
	.ascii	"%s\000"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #8
	ldr	r3, .L8
	str	r3, [fp, #-20]
	mov	r3, #0
	str	r3, [fp, #-16]
.L5:
	ldr	r3, [fp, #-16]
	cmp	r3, #9
	bgt	.L6
	ldr	r0, .L8+4
	ldr	r1, [fp, #-20]
	bl	printf
	ldr	r0, [fp, #-16]
	bl	foo
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
	b	.L5
.L6:
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #12
	ldmfd	sp, {fp, sp, pc}
.L9:
	.align	2
.L8:
	.word	.LC0
	.word	.LC1
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.3"
