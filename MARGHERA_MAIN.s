;*** MiniStartup by Photon ***
	INCDIR	"NAS:AMIGA/KONEY/"
	SECTION	"Code",CODE
	INCLUDE	"custom-registers.i"
	INCLUDE	"PhotonsMiniWrapper1.04!.s"
;********** Constants **********
sideBleed		EQU 16*2
scrWi		EQU 320
wi		EQU scrWi+sideBleed
he		EQU 256		; screen height
bpls		EQU 6		; depth
bypl		EQU wi/16*2	; byte-width of 1 bitplane line (40bytes)
bwid		EQU bpls*bypl	; byte-width of 1 pixel line (all bpls)
blitHe		EQU 128
bysb		EQU sideBleed/16*2
rasterST		EQU $1C
vSlices		EQU scrWi/16
;*******************************

;********** Demo **********	;Demo-specific non-startup code below.
Demo:			;a4=VBR, a6=Custom Registers Base addr
	;*--- init ---*
	MOVE.L	#VBint,$6C(A4)
	MOVE.W	#$C020,INTENA(A6)
	MOVE.W	#$87E0,DMACON(A6)
	;*--- start copper ---*
	LEA	BGR,A0
	LEA	COPPER\.BplPtrs+2,A1
	BSR.W	PokePtrs
	LEA	BLEED,A0
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	LEA	PF2,A0
	LEA	COPPER\.BplPtrsBled1+2,A1	
	BSR.W	PokePtrs
	LEA	bypl*blitHe(A0),A0
	LEA	16(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	bypl*blitHe(A0),A0
	LEA	16(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	LEA	PF1,A0
	LEA	COPPER\.BplPtrsBled1+10,A1
	BSR.W	PokePtrs
	LEA	bypl*blitHe(A0),A0
	LEA	16(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	LEA	BLEED+blitHe*bypl+bypl,A0
	LEA	COPPER\.BplPtrsBled2+2,A1	
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	; #### CPU INTENSIVE TASKS BEFORE STARTING MUSIC
	;## PF1 ##
	LEA	GFXPF1,A5		; SRC
	LEA	PF1,A3		; DEST
	MOVE.W	#wi/16,D7		; FILL PF1
	.pf1Loop:
	BSR.W	__PREP_BLIT_SLICE
	MOVE.W	#(blitHe*2<<6)+32/16,BLTSIZE(A6)
	LEA	2(A5),A5
	LEA	2(A3),A3
	DBRA	D7,.pf1Loop
	;## PF2 ##
	LEA	GFXPF2,A5		; SRC
	LEA	PF2,A3		; DEST
	MOVE.W	#wi/16,D7		; FILL PF2
	.pf2Loop:
	BSR.W	__PREP_BLIT_SLICE
	MOVE.W	#(blitHe*3<<6)+32/16,BLTSIZE(A6)
	LEA	2(A5),A5
	LEA	2(A3),A3
	DBRA	D7,.pf2Loop
	; ## PRE-POSITIONINGS ##
	ADD.L	#$2,PF1_SLICE_POS
	ADD.L	#$2,PF2_SLICE_POS
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1
	;BSR.W	__SCROLL_PF1

	MOVE.L	#COPPER,COP1LC(A6)	; ## POINT COPPERLIST ##
;********************  main loop  ********************
MainLoop:
	BSR.W	__RACE_THE_BEAM
	;MOVE.W	#rasterST,D0	;No buffering, so wait until raster
	;BSR.W	WaitRaster	;is below the Display Window.
	;###########################################################
	MOVE.L	FRM_NEXT_ADDR,A3
	JSR	(A3)		; EXECUTE SUBROUTINE BLOCK#

	;LEA	GFXPF2,A5		; SRC
	;LEA	PF2+bypl-4,A3	; DEST
	;BSR.W	__PREP_BLIT_SLICE
	;MOVE.W	#(blitHe*3<<6)+32/16,BLTSIZE(A6)

	;*--- main loop end ---*
	BTST	#$6,$BFE001	; POTINP - LMB pressed?
	BNE.S	.skip

	.skip:
	BTST	#$2,POTINP(A6)	; POTINP - RMB pressed?
	BNE.W	MainLoop		; then loop
	;*--- exit ---*
	.exit:
	RTS

;********** Demo Routines **********
PokePtrs:				; EVEN SHRUNKER REFACTOR! :)
	MOVE.L	A0,-(SP)		; Needs EMPTY plane to write addr
	MOVE.W	(SP)+,(A1)	; high word of address
	MOVE.W	(SP)+,4(A1)	; low word of address
	RTS

VBint:				; Blank template VERTB interrupt
	BTST	#5,INTREQR+1(A6)	; CHECK IF IT'S OUR VERTB INT.
	BEQ.S	.notVB
	;*--- DO STUFF HERE ---*
	MOVE.W	#$20,INTREQ(A6)	; POLL IRQ BIT
	MOVE.W	#$20,INTREQ(A6)
	.notVB:	
	RTE

_WipeMEM:		; a1=screen destination address to clear
	BSR	WaitBlitter
	MOVE.L	#$F5A5A5AF,BLTAFWM(A6)	; BLTAFWM
	MOVE.W	#bypl,BLTDMOD(A6)		; for HALF with lines.
	MOVE.W	#$100,BLTCON0(A6)		; set operation type in BLTCON0/1
	MOVE.W	#$000,BLTCON1(A6)
	MOVE.L	A4,BLTDPTH(A6)		; destination address
	MOVE.W	#he+wi/16,BLTSIZE(A6)
	RTS

__RACE_THE_BEAM:
	;LEA	LFO_SINE_AMP,A0
	LEA	LFO_SINE2,A0
	MOVE.W	SCROLL_IDX,D0
	ADD.W	#$2,D0
	AND.W	#$3F-1,D0
	MOVE.W	D0,SCROLL_IDX
	CLR.L	D2
	;CLR.L	D7		; SYNC IDX
	;MOVE.W	#$F,D6		; LFO NEGATIVE AMPLITUDE
	;;MOVE.W	AMP_LINES,D6
	;;MOVE.W	D6,D7
	;MOVE.W	VHPOSR(A6),D4	; for bug?
	;.waitVisibleRaster:
	;MOVE.W	VHPOSR(A6),D4
	;AND.W	#$FF00,D4		; read vertical beam
	;CMP.W	#$3700,D4		; 2C
	;BNE.S	.waitVisibleRaster

	.dummyWait:
	MOVE.W	VPOSR(A6),D1	; Read vert most sig. bits
	BTST	#$0,D1
	BNE.S	.dummyWait

	.waitNextRaster:
	MOVE.W	VHPOSR(A6),D2
	AND.W	#$FF00,D2		; read vertical beam
	CMP.W	D4,D2
	BEQ.S	.waitNextRaster

	MOVE.W	VHPOSR(A6),D4	; RACE THE BEAM!
	AND.W	#$FF00,D4		; RACE THE BEAM!

	CMP.W	#$D800,D2		; 12.032 - #$2F00
	BLO.S	.noSyncShift

	MOVE.W	(A0,D0.W),D3	; 19DEA68E GLITCHA
	ROR.L	#$4,D3
	MOVE.W	(A0,D0.W),D3	; 19DEA68E GLITCHA
	ROL.L	#$4,D3

	MOVE.W	D3,BPLCON1(A6)	; 19DEA68E GLITCHA

	;TST.W	D7
	;BNE.S	.notFourthLine
	;LEA	$20(A0),A0
	;;SUB.W	#$2,D0
	;ADD.W	#$1,D6
	;MOVE.W	D6,D7		; EVERY x LINES...
	;.notFourthLine:
	;SUB.W	#$1,D7		; EVERY x LINES...

	ADD.W	#$2,D0
	AND.W	#$3F-1,D0

	.noSyncShift:
	;MOVE.W	VPOSR(A6),D1	; Read vert most sig. bits
	;BTST	#$0,D1
	;BEQ.W	.waitNextRaster

	MOVE.L	VPOSR(A6),D1
	LSR.L	#1,D1
	LSR.W	#7,D1
	CMP.W	#$138,D1
	BNE.W	.waitNextRaster

	;CMP.W	#$1900,D2		; 12.032
	;BLO.W	.waitNextRaster
	MOVE.W	#$0,BPLCON1(A6)	; RESET REGISTER
	RTS

__SCROLL_PF2:
	LEA	PF2+blitHe*bypl*3-2,A4
	MOVE.W	#$8400,DMACON(A6)			; BLIT NASTY ENABLE
	MOVE.W	#$0400,DMACON(A6)			; BLIT NASTY DISABLE
	;BSR	WaitBlitter
	MOVE.L	#(((2<<12)+%100111110000)<<16)+%10,BLTCON0(A6)
	MOVE.L	#$FFFFFFFF,BLTAFWM(A6)
	MOVE.L	#$0,BLTAMOD(A6)
	MOVE.L	A4,BLTAPTH(A6)
	MOVE.L	A4,BLTDPTH(A6)
	MOVE.W	#(blitHe*3<<6)+wi/16,BLTSIZE(A6)	; BLTSIZE
	MOVE.W	#$98,COPPER\.PFsScrolling+2
	RTS

__SCROLL_PF1:
	LEA	PF1+blitHe*bypl*2-2,A4
	MOVE.W	#$8400,DMACON(A6)			; BLIT NASTY ENABLE
	MOVE.W	#$0400,DMACON(A6)			; BLIT NASTY DISABLE
	MOVE.L	#(((1<<12)+%100111110000)<<16)+%10,BLTCON0(A6)
	MOVE.L	#$FFFFFFFF,BLTAFWM(A6)
	MOVE.L	#$0,BLTAMOD(A6)
	MOVE.L	A4,BLTAPTH(A6)
	MOVE.L	A4,BLTDPTH(A6)
	MOVE.W	#(blitHe*2<<6)+wi/16,BLTSIZE(A6)	; BLTSIZE
	MOVE.W	#$88,COPPER\.PFsScrolling+2
	RTS

__PREP_BLIT_SLICE:
	BSR	WaitBlitter
	MOVE.L	#$07CA0000,BLTCON0(A6)
	MOVE.L	#$FFFF0000,BLTAFWM(A6)
	MOVE.W	#$FFFF,BLTADAT(A6)
	MOVE.W	#bypl-4-bysb,BLTBMOD(A6)
	MOVE.W	#bypl-4,BLTCMOD(A6)
	MOVE.W	#bypl-4,BLTDMOD(A6)
	MOVE.L	A5,BLTBPTH(A6)
	MOVE.L	A3,BLTCPTH(A6)
	MOVE.L	A3,BLTDPTH(A6)
	RTS

_FRAME0:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAME1,FRM_NEXT_ADDR
		RTS
_FRAME1:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAME2,FRM_NEXT_ADDR
		RTS
_FRAME2:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAME3,FRM_NEXT_ADDR
		RTS
_FRAME3:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAME4,FRM_NEXT_ADDR
		RTS
_FRAME4:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAME5,FRM_NEXT_ADDR
		RTS
_FRAME5:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAME6,FRM_NEXT_ADDR
		RTS
_FRAME6:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAME7,FRM_NEXT_ADDR
		RTS
_FRAME7:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAME8,FRM_NEXT_ADDR
		RTS
_FRAME8:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAME9,FRM_NEXT_ADDR
		RTS
_FRAME9:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAMEA,FRM_NEXT_ADDR
		RTS
_FRAMEA:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAMEB,FRM_NEXT_ADDR
		RTS
_FRAMEB:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAMEC,FRM_NEXT_ADDR
		ADD.L	#$2,PF2_SLICE_POS
		SUB.B	#$1,PF2_SLICE_IDX
		TST.B	PF2_SLICE_IDX
		BNE.S	.dontReset
		;MOVE.W	#$00F0,$DFF180
		MOVE.B	#vSlices,PF2_SLICE_IDX
		MOVE.L	#GFXPF2,PF2_SLICE_POS
		.dontReset:
		RTS
_FRAMEC:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAMED,FRM_NEXT_ADDR
		RTS
_FRAMED:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAMEE,FRM_NEXT_ADDR
		BCHG	#$1,FRM_STROBE
		BNE.W	.oddFrame			; #############
		MOVE.L	PF1_SLICE_POS,A5		; SRC
		LEA	PF1+bypl-2,A3		; DEST
		BSR.W	__PREP_BLIT_SLICE
		MOVE.W	#(blitHe*2<<6)+32/16,BLTSIZE(A6)
		BRA.W	.evenFrame
		.oddFrame:			; #############
		ADD.L	#$2,PF1_SLICE_POS
		SUB.B	#$1,PF1_SLICE_IDX
		TST.B	PF1_SLICE_IDX
		BNE.S	.dontReset
		MOVE.W	#$00FF,$DFF180
		MOVE.B	#vSlices,PF1_SLICE_IDX
		MOVE.L	#GFXPF1,PF1_SLICE_POS
		.dontReset:
		.evenFrame:			; #############
		RTS
_FRAMEE:		BSR.W	__SCROLL_PF2
		MOVE.L	#_FRAMEF,FRM_NEXT_ADDR
		RTS
_FRAMEF:		BSR.W	__SCROLL_PF1
		MOVE.L	#_FRAME0,FRM_NEXT_ADDR
		MOVE.L	PF2_SLICE_POS,A5		; SRC
		LEA	PF2+bypl-2,A3		; DEST
		BSR.W	__PREP_BLIT_SLICE
		MOVE.W	#(blitHe*3<<6)+32/16,BLTSIZE(A6)
		RTS

;********** Fastmem Data **********
PF1_SLICE_IDX:	DC.B vSlices
PF2_SLICE_IDX:	DC.B vSlices
PF1_SLICE_POS:	DC.L GFXPF1
PF2_SLICE_POS:	DC.L GFXPF2
FRM_NEXT_ADDR:	DC.L _FRAME0

FRM_COUNT:	DC.W 0
FRM_STROBE:	DC.B 1,0
SCROLL_IDX:	DC.W 0
AMP_LINES:	DC.W 1
LFO_SINE1:	DC.W 7,8,10,11,12,13,13,14,14,15,13,13,12,11,10,8,7,6,4,3,2,1,1,0,1,0,1,1,2,3,4,6
LFO_SINE2:	DC.W 7,9,10,11,13,14,14,15,15,15,14,14,13,11,10,9,7,5,4,3,1,0,0,0,0,0,0,0,1,3,4,5
LFO_SINE3:	DC.W 1,1,2,2,3,4,4,5,5,6,6,7,8,7,8,7,6,7,6,5,5,4,4,3,2,3,2,2,1,1,0,0
LFO_SINE_AMP:	DC.W 1,1,2,2,2,3,3,3,3,3,3,3,2,2,2,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		DC.W 2,3,3,4,4,4,5,5,5,5,5,4,4,4,3,3,2,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1
		DC.W 3,4,5,5,6,6,7,7,7,7,7,6,6,5,5,4,3,2,1,1,0,0,0,0,0,0,0,0,0,1,1,2
		DC.W 4,5,6,7,8,8,9,9,9,9,9,8,8,7,6,5,4,3,2,1,0,0,0,0,0,0,0,0,0,1,2,3
		DC.W 5,6,7,8,9,10,11,11,11,11,11,10,9,8,7,6,5,4,3,2,1,0,0,0,0,0,0,0,1,2,3,4
		DC.W 6,7,9,10,11,12,12,13,13,13,12,12,11,10,9,7,6,5,3,2,1,0,0,0,0,0,0,0,1,2,3,5
		DC.W 7,9,10,11,13,14,14,15,15,15,14,14,13,11,10,9,7,5,4,3,1,0,0,0,0,0,0,0,1,3,4,5
;*******************************************************************************
	SECTION	ChipData,DATA_C	;declared data that must be in chipmem
;*******************************************************************************

BGR:	INCBIN "BGR_320x192x1.raw"
GFXPF1:	INCBIN "PF1_320x128x2.raw"
GFXPF2:	INCBIN "PF2_2_320x128x3.raw"

COPPER:	; #### COPPERLIST ####################################################
	DC.W FMODE,$0000	; Slow fetch mode, remove if AGA demo.
	DC.W DIWSTRT,$2C81	; 238h display window top, left | DIWSTRT - 11.393
	DC.W DIWSTOP,$1CC1	; and bottom, right.	| DIWSTOP - 11.457
	DC.W DDFSTRT,$0030	; Standard bitplane dma fetch start
	DC.W DDFSTOP,$00D0	; and stop for standard screen.
	DC.W BPLCON3,$0C00	; (AGA compat. if any Dual Playf. mode)
	DC.W BPLCON2,$40	; SCROLL REGISTER (AND PLAYFIELD PRI)
	.PFsScrolling:
	DC.W BPLCON1,$88
	DC.W BPL1MOD,bysb-2	; BPL1MOD	 Bitplane modulo (odd planes)
	DC.W BPL2MOD,bysb-2	; BPL2MOD Bitplane modulo (even planes)

	.Palette:
	DC.W $0180,$0000,$0182,$0455,$0184,$0233,$0186,$0233
	DC.W $0188,$0122,$018A,$0122,$018C,$0344,$018E,$0344
	DC.W $0190,$0000,$0192,$0333,$0194,$0344,$0196,$0555
	DC.W $0198,$0666,$019A,$0888,$019C,$0AA9,$019E,$0EED

	.SpritePointers:
	DC.W $0120,0,$122,0
	DC.W $0124,0,$126,0
	DC.W $0128,0,$12A,0
	DC.W $012C,0,$12E,0
	DC.W $0130,0,$132,0
	DC.W $0134,0,$136,0
	DC.W $0138,0,$13A,0
	DC.W $013C,0,$13E,0

	.BplPtrs:
	DC.W $E0,0,$E2,0
	DC.W $E4,0,$E6,0
	DC.W $E8,0,$EA,0
	DC.W $EC,0,$EE,0
	DC.W $F0,0,$F2,0
	DC.W $F4,0,$F6,0		;full 6 ptrs, in case you increase bpls
	DC.W BPLCON0,bpls*$1000+$600	;enable bitplanes

	.Waits:
	DC.W $2B07,$FFFE
	DC.W $182,$012
	DC.W $4207,$FFFE
	DC.W $182,$013
	DC.W $4307,$FFFE
	DC.W $182,$012
	DC.W $4407,$FFFE
	DC.W $182,$013
	DC.W $4F07,$FFFE
	DC.W $182,$003
	DC.W $5007,$FFFE
	DC.W $182,$013
	DC.W $5307,$FFFE
	DC.W $182,$003
	DC.W $5507,$FFFE
	DC.W $182,$013
	DC.W $5607,$FFFE
	DC.W $182,$003
	DC.W $5E07,$FFFE

	DC.W $6B07,$FFFE
	.BplPtrsBled1:
	DC.W $E4,0,$E6,0	; 2
	DC.W $E8,0,$EA,0	; 1
	DC.W $EC,0,$EE,0	; 2
	DC.W $F0,0,$F2,0	; 1
	DC.W $F4,0,$F6,0	; 2	;full 6 ptrs, in case you increase bpls

	DC.W $182,$103
	DC.W $7207,$FFFE
	DC.W $182,$203
	DC.W $8607,$FFFE
	DC.W $182,$303
	DC.W $8707,$FFFE
	DC.W $182,$203
	DC.W $8807,$FFFE
	DC.W $182,$303
	DC.W $9A07,$FFFE
	DC.W $182,$403
	DC.W $9B07,$FFFE
	DC.W $182,$303
	DC.W $9C07,$FFFE
	DC.W $182,$403
	DC.W $A407,$FFFE
	DC.W $182,$503
	DC.W $A807,$FFFE
	DC.W $182,$513
	DC.W $A907,$FFFE
	DC.W $182,$613
	DC.W $AE07,$FFFE
	DC.W $182,$713
	DC.W $AF07,$FFFE
	DC.W $182,$723
	DC.W $B307,$FFFE
	DC.W $182,$823
	DC.W $B707,$FFFE
	DC.W $182,$833
	DC.W $B807,$FFFE
	DC.W $182,$933
	DC.W $BD07,$FFFE
	DC.W $182,$A33
	DC.W $BF07,$FFFE
	DC.W $182,$A43
	DC.W $C207,$FFFE
	DC.W $182,$B43
	DC.W $C607,$FFFE
	DC.W $182,$B53
	DC.W $C707,$FFFE
	DC.W $182,$C53
	DC.W $CC07,$FFFE
	DC.W $182,$D53
	DC.W $CD07,$FFFE
	DC.W $182,$D63
	DC.W $D207,$FFFE
	DC.W $182,$E63
	DC.W $D407,$FFFE
	DC.W $182,$E62
	DC.W $D607,$FFFE
	DC.W $182,$E52
	DC.W $D707,$FFFE
	DC.W $182,$E62
	DC.W $D807,$FFFE
	DC.W BPL1MOD,-1*bypl*3	; BPL1MOD Bitplane modulo (odd planes)
	DC.W BPL2MOD,-1*bypl*3	; BPL2MOD Bitplane modulo (even planes)
	;DC.W BPLCON0,(bpls-1)*$1000+$A00	; HAM!
	DC.W $182,$E52
	DC.W $E407,$FFFE
	DC.W $182,$D52
	DC.W $E507,$FFFE
	DC.W $182,$D42
	DC.W $E807,$FFFE
	DC.W $182,$C42
	DC.W $EB07,$FFFE
	DC.W $182,$B42
	DC.W $EF07,$FFFE
	DC.W $182,$A42
	DC.W $F207,$FFFE
	DC.W $182,$A32
	DC.W $F307,$FFFE
	DC.W $182,$932
	DC.W $F607,$FFFE
	DC.W $182,$832
	DC.W $F907,$FFFE
	DC.W $182,$732
	DC.W $FD07,$FFFE
	DC.W $182,$632
	DC.W $FE07,$FFFE
	DC.W $182,$622
	DC.W $FFDF,$FFFE ; PAL FIX
	DC.W $107,$FFFE
	DC.W $182,$522
	DC.W $507,$FFFE
	DC.W $182,$422
	DC.W $807,$FFFE
	DC.W $182,$322
	DC.W $B07,$FFFE
	DC.W $182,$312
	DC.W $C07,$FFFE
	DC.W $182,$212
	DC.W $D07,$FFFE

	.BplPtrsBled2:
	DC.W $E0,0,$E2,0	; 1
	DC.W $E4,0,$E6,0	; 2
	DC.W $E8,0,$EA,0	; 1
	DC.W $EC,0,$EE,0	; 2
	DC.W $F0,0,$F2,0	; 1
	DC.W $F4,0,$F6,0	; 2

	DC.W $1007,$FFFE
	DC.W $182,$112
	DC.W $1307,$FFFE
	DC.W $182,$012
	DC.W $1907,$FFFE
	DC.W $182,$011
	DC.W $1A07,$FFFE
	DC.W $182,$012
	DC.W $1B07,$FFFE
	DC.W $182,$011
	DC.W $2707,$FFFE
	DC.W $182,$111
	DC.W $2807,$FFFE
	DC.W $182,$011
	DC.W $2907,$FFFE
	DC.W $182,$111
	DC.W $FFFF,$FFFE ; END COPPER LIST

;*******************************************************************************
	SECTION ChipBuffers,BSS_C	;BSS doesn't count toward exe size
;*******************************************************************************

BLEED:		DS.B blitHe*bypl
;BGR:		DS.B he*bypl*1
PF1:		DS.B blitHe*bypl*2
PF2:		DS.B blitHe*bypl*3

END
