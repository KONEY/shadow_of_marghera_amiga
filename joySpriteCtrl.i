	LEA	SPRTKNY,A0
	MOVE.W	$DFF00C,D0
	AND.W	#$0303,D0
	MOVE.W	D0,D1
	ADD.W	D1,D1
	ADD.W	#$0101,D0
	ADD.W	D1,D0

	BTST	#$2,D0
	BEQ.S	.notDown
	BTST.B	#7,$BFE0FF
	BNE.S	.notFireD
	BCHG	#$1,3(A0)		; VSTOP high bit
	BRA.S	.notL
	.notFireD:
	ADD.B	#$1,(A0)
	;ADD.B	#$1,2(A0)
	.notDown:
	BTST	#$A,D0
	BEQ.S	.notUp
	BTST.B	#7,$BFE0FF
	BNE.S	.notFireU
	BCHG	#$2,3(A0)		; VSTART high bit
	BRA.S	.notL
	.notFireU:
	SUB.B	#$1,(A0)
	;SUB.B	#$1,2(A0)
	.notUp:
	BTST	#$1,D0
	BEQ.S	.notR
	BTST.B	#7,$BFE0FF
	BNE.S	.notFireR
	BSET	#$0,3(A0)		; HSTART low bit
	BRA.S	.notR
	.notFireR:
	ADD.B	#$1,1(A0)
	.notR:
	BTST	#$9,D0
	BEQ.S	.notL
	BTST.B	#7,$BFE0FF
	BNE.S	.notFireL
	BCLR	#$0,3(A0)		; HSTART low bit
	BRA.S	.notL
	.notFireL:
	SUB.B	#$1,1(A0)
	.notL:

	BTST	#$6,$BFE001	; POTINP - LMB pressed?
	BNE.S	.noLMB
	CLR.W	$100		; DEBUG | w 0 100 2
	.noLMB: