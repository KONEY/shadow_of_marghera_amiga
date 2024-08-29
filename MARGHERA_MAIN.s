;*** MiniStartup by Photon ***
	INCDIR	"NAS:AMIGA/KONEY/"
	SECTION	"Code",CODE
	INCLUDE	"custom-registers.i"
	INCLUDE	"PhotonsMiniWrapper1.04!.s"
;********** Constants **********
wi		EQU 320
he		EQU 256		; screen height
bpls		EQU 6		; depth
bypl		EQU wi/16*2	; byte-width of 1 bitplane line (40bytes)
bwid		EQU bpls*bypl	; byte-width of 1 pixel line (all bpls)
rasterST		EQU $1C
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
	LEA	COPPER\.BplPtrsBleed+2,A1	
	BSR.W	PokePtrs
	LEA	bypl*he/2(A0),A0
	LEA	16(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	bypl*he/2(A0),A0
	LEA	16(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	LEA	PF1,A0
	LEA	COPPER\.BplPtrsBleed+10,A1
	BSR.W	PokePtrs
	LEA	bypl*he/2(A0),A0
	LEA	16(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	; #### CPU INTENSIVE TASKS BEFORE STARTING MUSIC
	MOVE.L	#COPPER,COP1LC(A6)	; ## POINT COPPERLIST ##
;********************  main loop  ********************
MainLoop:
	;MOVE.W	#rasterST,D0	;No buffering, so wait until raster
	;BSR.W	WaitRaster	;is below the Display Window.
	;###########################################################

	;BSR.W	__RACE_THE_BEAM

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

__SCROLL_X:
	;RTS
	MOVE.W	#%0000000000000000,D2
	BRA.S	.noDesc
	.desc:
	;## DESC ##
	MOVE.W	#%0000000000000010,D2
	;## DESC ##
	.noDesc:
	;RTS
	MOVE.W	#%1001111100001000,D1		; %1000100111110000 +ROL.W	#4,D1
	MOVE.B	D0,D1
	ROR.W	#$4,D1
	;BSR	WaitBlitter
	MOVE.W	#$8400,DMACON(A6)			; BLIT NASTY ENABLE
	MOVE.W	#$0400,DMACON(A6)			; BLIT NASTY DISABLE
	MOVE.W	D1,BLTCON0(A6)			; BLTCON0
	MOVE.W	D2,BLTCON1(A6)
	MOVE.L	#$FFFFFFFF,BLTAFWM(A6)		; THEY'LL NEVER
	MOVE.W	#bypl,BLTAMOD(A6)			; BLTAMOD
	MOVE.W	#bypl,BLTDMOD(A6)			; BLTDMOD

	MOVE.L	A5,BLTAPTH(A6)			; BLTAPT
	MOVE.L	A2,BLTDPTH(A6)
	MOVE.W	#(bpls<<6)+wi/16,BLTSIZE(A6)		; BLTSIZE
	RTS

__RACE_THE_BEAM:
	LEA	LFO_VIBRO,A0
	LEA	LFO_NOSYNC,A1
	MOVE.W	V_LINE_IDX,D6
	MOVE.W	SCROLL_IDX,D0
	ADD.W	#$2,D0
	AND.W	#$3F-1,D0
	MOVE.W	D0,SCROLL_IDX
	;MOVE.W	BPLMOD_IDX,D5
	;AND.W	#$7F-1,D5
	;SUB.W	#$2,D5
	;MOVE.W	D5,BPLMOD_IDX
	CLR.L	D2
	CLR.L	D7		; SYNC IDX
	;MOVE.W	VHPOSR,D4		; for bug?
	;.waitVisibleRaster:
	;MOVE.W	VHPOSR,D4
	;AND.W	#$FF00,D4		; read vertical beam
	;CMP.W	#$3700,D4		; 2C
	;BNE.S	.waitVisibleRaster

	.dummyWait:
	MOVE.W	VPOSR(A6),D1	; Read vert most sig. bits
	BTST	#0,D1
	BNE.S	.dummyWait

	.waitNextRaster:
	MOVE.W	VHPOSR(A6),D2
	AND.W	#$FF00,D2		; read vertical beam
	CMP.W	D4,D2
	BEQ.S	.waitNextRaster

	MOVE.W	VHPOSR(A6),D4	; RACE THE BEAM!
	AND.W	#$FF00,D4		; RACE THE BEAM!

	;SUB.W	#1,D6
	;CMP.W	D6,D2		; 12.032 - #$2F00
	;BNE.S	.noLine2
	;MOVE.W	#$000F,$DFF19A	; WHITE LINE
	;.noLine2:

	CMP.W	#$D800,D2		; 12.032 - #$2F00
	BNE.S	.keepLFO
	LEA	LFO_SINE1,A0
	MOVE.L	#$0F0000FF,$DFF182	; TIKTOK
	BRA.S	.keepLFO2
	.keepLFO:

	;;CMP.W	#$B700,D2		; 12.032 - #$2F00
	;;BNE.S	.keepLFO2
	;;LEA	LFO_SINE2,A0
	.keepLFO2:

	MOVE.W	(A0,D0.W),D3	; 19DEA68E GLITCHA
	TST.W	D7
	BEQ.S	.noSyncShift
	ROR.L	#4,D3
	MOVE.W	(A1,D7.W),D3	; 19DEA68E GLITCHA
	SUB.W	#$2,D7
	ROL.L	#4,D3
	.noSyncShift:
	MOVE.W	D3,BPLCON1(A6)	; 19DEA68E GLITCHA
	ADD.W	#$2,D0
	AND.W	#$3F-1,D0

	MOVE.W	VPOSR(A6),D1	; Read vert most sig. bits
	BTST	#0,D1
	BEQ.W	.waitNextRaster

	;.dontSkip:
	;CMP.W	#$0400,D2		; 12.032 - #$2F00
	CMP.W	#$1F00,D2		; 12.032
	BEQ.W	.waitNextRaster
	;MOVE.W	#0,BPLCON1	; RESET REGISTER
	;MOVE.L	#0,BPL1MOD	; RESET
	RTS

FRAME_STROBE:	DC.B 0,0
FRAME_COUNT:	DC.W 0
NOISE_IDX3:	DC.W 0
NOISE_IDX5:	DC.W 0
BPLMOD_IDX:	DC.W 0
SCROLL_IDX:	DC.W 0
LFO_SINE1:	DC.W 0,1,1,2,2,2,3,4,4,5,5,6,6,7,6,7,6,7,7,6,6,5,5,4,4,3,2,2,2,1,1,0
LFO_SINE2:	DC.W 5,5,4,5,5,4,5,4,5,5,4,4,3,2,3,2,1,0,0,0,1,0,1,2,2,3,4,4,5,4,5,4
LFO_SINE3:	DC.W 2,2,3,3,3,3,3,2,2,2,1,1,1,1,1,2,2,2,3,3,3,3,3,2,2,2,1,1,1,1,1,2
LFO_NOISE:	DC.W 1,4,1,5,2,4,3,5,2,4,2,5,2,4,1,5,1,4,1,5,3,4,2,5,1,4,5,5,4,4,6,5
LFO_VIBRO:	DC.W 4,5,4,5,4,5,4,5,4,5,2,1,2,1,2,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,2
LFO_NOSYNC:	DC.W 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,3,4,7,10,13,15
V_IDX1:		DC.W $2
V_IDX2:		DC.W $32
V_OFFSET:		DC.W 0,40,40,80,80,40,40,0,0,-40,-80,-80,-40,-40,0,0
		DC.W 0,0,40,40,80,80,40,0,-40,-40,-80,-80,-40,-40,-40,0
V_LINE_IDX:	DC.B 0,0

;*******************************************************************************
	SECTION	ChipData,DATA_C	;declared data that must be in chipmem
;*******************************************************************************

BGR:	INCBIN "BGR_320x192x1.raw"
PF1:	INCBIN "PF1_320x128x2.raw"
PF2:	INCBIN "PF2_320x128x3.raw"

COPPER:	; #### COPPERLIST ####################################################
	DC.W FMODE,$0000	; Slow fetch mode, remove if AGA demo.
	DC.W DIWSTRT,$2C81	; 238h display window top, left | DIWSTRT - 11.393
	DC.W DIWSTOP,$1CC1	; and bottom, right.	| DIWSTOP - 11.457
	DC.W DDFSTRT,$0038	; Standard bitplane dma fetch start
	DC.W DDFSTOP,$00D0	; and stop for standard screen.
	DC.W BPLCON3,$0C00	; (AGA compat. if any Dual Playf. mode)
	DC.W BPLCON2,$20	; SCROLL REGISTER (AND PLAYFIELD PRI)
	DC.W BPL1MOD,$00	; BPL1MOD	 Bitplane modulo (odd planes)
	DC.W BPL2MOD,$00	; BPL2MOD Bitplane modulo (even planes)

	.Palette:
	DC.W $0180,$0000,$0182,$0F0F,$0184,$0000,$0186,$0777
	DC.W $0188,$0444,$018A,$0111,$018C,$0322,$018E,$0422
	DC.W $0190,$0000,$0192,$0344,$0194,$0555,$0196,$0222
	DC.W $0198,$0666,$019A,$0888,$019C,$0EED,$019E,$0AA9

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
	.BplPtrsBleed:
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

BLEED:		DS.B he/2*bwid
;BGR:		DS.B he*bypl*1
;PF1:		DS.B he*bypl*2
;PF2:		DS.B he*bypl*3

END
