;*** MiniStartup by Photon ***
	INCDIR	"NAS:CODE/shadow_of_marghera_amiga/"
	SECTION	"Code",CODE
	INCLUDE	"custom-registers.i"
	INCLUDE	"med/med_feature_control.i"	; MED CFGs
	INCLUDE	"PhotonsMiniWrapper1.04!.s"
	IFNE MED_PLAY_ENABLE
	INCLUDE	"med/MED_PlayRoutine.i"
	ENDC
;********** Constants **********
sideBleed		EQU 16*2
scrWi		EQU 320
wi		EQU scrWi+sideBleed
he		EQU 256		; screen height
bpls		EQU 6		; depth
bypl		EQU wi/16*2	; byte-width of 1 bitplane line (40bytes)
bwid		EQU bpls*bypl	; byte-width of 1 pixel line (all bpls)
blitHe		EQU 116
bgHe		EQU 180
bysb		EQU sideBleed/16*2
rasterST		EQU $1C
vSlices		EQU scrWi/16
;*******************************

;********** Demo **********	;Demo-specific non-startup code below.
Demo:			;a4=VBR, a6=Custom Registers Base addr
	;*--- init ---*
	IFEQ VBLANK
	MOVE.L	#VBint,$6C(A4)
	ENDC
	MOVE.W	#$C020,INTENA(A6)
	MOVE.W	#$87E0,DMACON(A6)

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

	LEA	BLEED+blitHe*bypl-bypl,A0
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

	;LEA	SPRLIGHT,A0	; SPRT 0-1
	LEA	COPPER\.SpritePointers+2,A1
	;BSR.W	PokePtrs
	LEA	SPRFIRE1,A0	; SPRT 6-6
	LEA	32(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	SPRFIRE2,A0	; SPRT 6-6
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	; #### CPU INTENSIVE TASKS BEFORE STARTING MUSIC
	MOVE.W	#$1000,BLEED+$25*bypl+bypl-6	; Draw pixel for red light

	;## PF1 ##
	MOVE.L	PF1_SLICE_POS,A5	; SRC
	LEA	PF1,A3		; DEST
	MOVE.W	#wi/16,D7		; FILL PF1
	.pf1Loop:
	BSR.W	__PREP_BLIT_SLICE
	MOVE.W	#(blitHe*2<<6)+32/16,BLTSIZE(A6)
	LEA	2(A5),A5
	LEA	2(A3),A3
	DBRA	D7,.pf1Loop
	;## PF2 ##
	MOVE.L	PF2_SLICE_POS,A5	; SRC
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

	JSR	__ADD_BLEED_WORDS

	LEA	LFO_SINE2,A0	; ## COUPLE NYBBLES OF LFO VALUES ##
	MOVE.W	#$1F,D0
	.loop:
	MOVE.W	(A0),D3
	ROR.L	#$4,D3
	MOVE.W	(A0),D3
	ROL.L	#$4,D3
	MOVE.W	D3,(A0)+
	DBRA	D0,.loop
	; #### CPU INTENSIVE TASKS BEFORE STARTING MUSIC

	IFNE MED_PLAY_ENABLE
	;MOVE.W	#%1000000000001100,INTENA(A6)	; Master and lev6	; NO COPPER-IRQ!
	JSR	_startmusic
	ENDC

	;*--- start copper ---*
	MOVE.L	#COPPER,COP1LC(A6)	; ## POINT COPPERLIST ##
;********************  main loop  ********************
MainLoop:
	BSR.W	__RACE_THE_BEAM
	;MOVE.W	#rasterST,D0	;No buffering, so wait until raster
	;BSR.W	WaitRaster	;is below the Display Window.
	;###########################################################
	MOVE.L	FRM_NEXT_ADDR,A3
	JSR	(A3)		; EXECUTE SUBROUTINE BLOCK#

	;INCLUDE "joySpriteCtrl.i"

	;*--- main loop end ---*
	;BTST	#$6,$BFE001	; POTINP - LMB pressed?
	;BNE.S	.skip

	.skip:
	BTST	#$2,POTINP(A6)	; POTINP - RMB pressed?
	BNE.W	MainLoop		; then loop
	;*--- exit ---*
	.exit:
	IFNE MED_PLAY_ENABLE
	; --- quit MED code ---
	MOVEM.L	D0-A6,-(SP)
	JSR	_endmusic
	MOVEM.L	(SP)+,D0-A6
	ENDC
	RTS

;********** Demo Routines **********
PokePtrs:
	MOVE.L	A0,-(SP)		; SUPER SHRUNK REFACTOR! :)
	MOVE.W	(SP)+,(A1)	; high word of address
	MOVE.W	(SP)+,4(A1)	; low word of address
	RTS

VBint:				; Blank template VERTB interrupt
	BTST	#5,CUSTOM+INTREQR+1	; CHECK IF IT'S OUR VERTB INT.
	BEQ.S	.notVB
	;*--- DO STUFF HERE ---*
	MOVE.W	#$20,CUSTOM+INTREQ	; POLL IRQ BIT
	MOVE.W	#$20,CUSTOM+INTREQ
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
	LEA	LFO_SINE2,A0	; NYBBLES PREVIOUSLY COUPLED
	MOVE.W	SCROLL_IDX,D0
	ADD.W	#$2,D0
	AND.W	#$3F-1,D0
	MOVE.W	D0,SCROLL_IDX
	CLR.L	D2

	.dummyWait:
	MOVE.W	VPOSR(A6),D1	; Read vert most sig. bits
	BTST	#$0,D1
	BNE.S	.dummyWait
	LSR.L	#$1,D1
	LSR.W	#$7,D1

	MOVE.W	(A0,D0.W),D3	; PRELOAD INITIAL VALUES
	ADD.W	#$2,D0
	AND.W	#$3F-1,D0

	.waitNextRaster:
	MOVE.W	VHPOSR(A6),D2
	AND.W	#$FF00,D2		; read vertical beam
	CMP.W	D4,D2
	BEQ.S	.waitNextRaster

	MOVE.W	VHPOSR(A6),D4	; RACE THE BEAM!
	AND.W	#$FF00,D4		; RACE THE BEAM!

	CMP.W	#$DF,D1
	BLO.S	.noSyncShift
	ANDI.B	#$1,D1		; ONLY EVEN LINES
	BEQ.S	.noSyncShift	

	MOVE.W	D3,BPLCON1(A6)	; PRELOADED VALUES
	MOVE.W	(A0,D0.W),D3
	;ROR.L	#$4,D3
	;MOVE.W	(A0,D0.W),D3
	;ROL.L	#$4,D3
	ADD.W	#$2,D0
	AND.W	#$3F-1,D0

	;MULS.W	#$5,D7		; DUMMY OPERATIONS
	;DIVS.W	#$7,D7		; DUMMY OPERATIONS

	;TST.W	D7
	;BNE.S	.notFourthLine
	;LEA	$20(A0),A0
	;;SUB.W	#$2,D0
	;ADD.W	#$1,D6
	;MOVE.W	D6,D7		; EVERY x LINES...
	;.notFourthLine:

	.noSyncShift:
	MOVE.L	VPOSR(A6),D1	; REACH SCREEN END
	LSR.L	#$1,D1
	LSR.W	#$7,D1
	CMP.W	#$120,D1
	BNE.W	.waitNextRaster
	;MOVE.W	#$0,BPLCON1(A6)	; RESET REGISTERS
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
	;BSR	WaitBlitter
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

__SPILL_FIRE1:
	LEA	FLAME_FRMS,A0
	MOVE.W	FLAME_FRMS_IDX,D0
	ADD.W	#$4,D0
	MOVE.L	(A0,D0.W),D1
	TST.L	D1
	BNE.S	.notEndOfTable
	MOVE.W	#$0,D0
	MOVE.L	(A0),D1
	.notEndOfTable:
	MOVE.W	D0,FLAME_FRMS_IDX
	MOVE.L	D1,A2

	MOVE.L	FIRE_NEXT_ADDR,A3		; SRC
	LEA	4(A3),A3
	MOVE.L	A3,FIRE_NEXT_ADDR
	LEA	SPRFIRE1\.data,A4		; DEST
	BSR	WaitBlitter
	MOVE.L	#$0DCA0000,BLTCON0(A6)
	MOVE.L	A2,BLTAPTH(A6)
	MOVE.L	A3,BLTBPTH(A6)
	MOVE.L	A4,BLTDPTH(A6)
	MOVE.W	#$0,BLTAMOD(A6)
	MOVE.W	#$0,BLTBMOD(A6)
	MOVE.W	#$0,BLTDMOD(A6)
	MOVE.L	#$FFFFFFFF,BLTAFWM(A6)
	MOVE.W	#($26<<6)+32/16,BLTSIZE(A6)
	RTS

__SPILL_FIRE2:
	LEA	FLAME_FRMS,A0
	MOVE.W	FLAME_FRMS_IDX,D0
	ADD.W	#$4,D0
	MOVE.L	(A0,D0.W),D1
	TST.L	D1
	BNE.S	.notEndOfTable
	MOVE.W	#$0,D0
	MOVE.L	(A0),D1
	.notEndOfTable:
	MOVE.W	D0,FLAME_FRMS_IDX
	MOVE.L	D1,A2

	MOVE.L	FIRE_NEXT_ADDR,A3		; SRC
	LEA	6(A3),A3
	MOVE.L	A3,FIRE_NEXT_ADDR
	LEA	-56(A3),A3
	LEA	SPRFIRE2\.data,A4		; DEST
	BSR	WaitBlitter
	MOVE.L	#$0DCA0000,BLTCON0(A6)
	MOVE.L	A2,BLTAPTH(A6)
	MOVE.L	A3,BLTBPTH(A6)
	MOVE.L	A4,BLTDPTH(A6)
	MOVE.W	#$0,BLTAMOD(A6)
	MOVE.W	#$0,BLTBMOD(A6)
	MOVE.W	#$0,BLTDMOD(A6)
	MOVE.L	#$FFFFFFFF,BLTAFWM(A6)
	MOVE.W	#($26<<6)+32/16,BLTSIZE(A6)

	LEA	BGR,A4
	CMP.L	A4,A3
	BLO.S	.dontResetTexturePointer
	MOVE.L	#_MED_MODULE-40*2048,FIRE_NEXT_ADDR
	.dontResetTexturePointer:
	RTS

_FRAME0:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAME1,FRM_NEXT_ADDR
	RTS
_FRAME1:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE2
	MOVE.L	#_FRAME2,FRM_NEXT_ADDR
	RTS
_FRAME2:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAME3,FRM_NEXT_ADDR
	RTS
_FRAME3:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE1
	MOVE.L	#_FRAME4,FRM_NEXT_ADDR
	RTS
_FRAME4:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAME5,FRM_NEXT_ADDR
	RTS
_FRAME5:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE2
	MOVE.L	#_FRAME6,FRM_NEXT_ADDR
	RTS
_FRAME6:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAME7,FRM_NEXT_ADDR
	RTS
_FRAME7:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE1
	MOVE.L	#_FRAME8,FRM_NEXT_ADDR
	RTS
_FRAME8:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAME9,FRM_NEXT_ADDR
	RTS
_FRAME9:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE2
	MOVE.L	#_FRAMEA,FRM_NEXT_ADDR
	RTS
_FRAMEA:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAMEB,FRM_NEXT_ADDR
	RTS
_FRAMEB:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE1
	MOVE.L	#_FRAMEC,FRM_NEXT_ADDR
	ADD.L	#$2,PF2_SLICE_POS
	SUB.B	#$1,PF2_SLICE_IDX
	TST.B	PF2_SLICE_IDX
	BNE.S	.dontReset
	;MOVE.W	#$00F0,$DFF180
	MOVE.B	#vSlices,PF2_SLICE_IDX
	LEA	PF2_SCREENS,A0
	MOVE.W	PF2_SCR_IDX,D0
	ADD.W	#$4,D0
	MOVE.L	(A0,D0.W),D1
	TST.L	D1
	BNE.S	.notEndOfTable
	MOVE.W	#$0,D0
	MOVE.L	(A0),D1
	.notEndOfTable:
	MOVE.W	D0,PF2_SCR_IDX
	MOVE.L	D1,PF2_SLICE_POS
	.dontReset:
	RTS
_FRAMEC:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAMED,FRM_NEXT_ADDR
	RTS
_FRAMED:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE2
	MOVE.L	#_FRAMEE,FRM_NEXT_ADDR
	BCHG	#$1,FRM_STROBE
	BNE.S	.oddFrame			; #############
	MOVE.L	PF1_SLICE_POS,A5		; SRC
	LEA	PF1+bypl-2,A3		; DEST
	BSR.W	__PREP_BLIT_SLICE
	MOVE.W	#(blitHe*2<<6)+32/16,BLTSIZE(A6)
	BCHG	#$1,FRM_STROBE_INNER	; EVERY TWO STROBE FRAMES
	BNE.S	.evenFrame		; #############
	LEA	COPPER\.Palette+62,A0	; COP COL $01A2
	EOR.W	#$0F00,(A0)		; INVERT VALUE
	BRA.S	.evenFrame
	.oddFrame:			; #############
	ADD.L	#$2,PF1_SLICE_POS
	SUB.B	#$1,PF1_SLICE_IDX
	TST.B	PF1_SLICE_IDX
	BNE.S	.dontReset
	MOVE.B	#vSlices,PF1_SLICE_IDX
	LEA	PF1_SCREENS,A0
	MOVE.W	PF1_SCR_IDX,D0
	ADD.W	#$4,D0
	MOVE.L	(A0,D0.W),D1
	TST.L	D1
	BNE.S	.notEndOfTable
	MOVE.W	#$0,D0
	MOVE.L	(A0),D1
	.notEndOfTable:
	MOVE.W	D0,PF1_SCR_IDX
	MOVE.L	D1,PF1_SLICE_POS
	.dontReset:
	.evenFrame:			; #############
	RTS
_FRAMEE:	BSR.W	__SCROLL_PF2
	MOVE.L	#_FRAMEF,FRM_NEXT_ADDR
	RTS
_FRAMEF:	BSR.W	__SCROLL_PF1
	BSR.W	__SPILL_FIRE1
	MOVE.L	#_FRAME0,FRM_NEXT_ADDR
	MOVE.L	PF2_SLICE_POS,A5		; SRC
	LEA	PF2+bypl-2,A3		; DEST
	BSR.W	__PREP_BLIT_SLICE
	MOVE.W	#(blitHe*3<<6)+32/16,BLTSIZE(A6)
	RTS

__ADD_BLEED_WORDS:
	LEA	BGR_DATA,A0
	LEA	BGR,A1
	MOVE.L	#bgHe-1,D1	; LINES
	.outerLoop:
	MOVE.L	#scrWi/16-1,D0	; SIZE OF SOURCE IN WORDS
	.innerLoop:
	MOVE.W	(A0)+,(A1)+
	DBRA	D0,.innerLoop
	MOVE.L	#$FFFFFFFF,(A1)+	; THE EXTRA WORD RIGHT
	DBRA.W	D1,.outerLoop
	RTS

;********** Fastmem Data **********
FRM_STROBE:	DC.B 1
FRM_STROBE_INNER:	DC.B 0
PF1_SLICE_IDX:	DC.B vSlices
PF2_SLICE_IDX:	DC.B vSlices
PF1_SLICE_POS:	DC.L PF1S1
PF2_SLICE_POS:	DC.L PF2S1
FRM_NEXT_ADDR:	DC.L _FRAME0
FRM_COUNT:	DC.W 0
FLAME_FRMS:	DC.L FLAME_MASK,FLAME_MASK+$26*4,FLAME_MASK+$26*4*2,FLAME_MASK+$26*4*3,FLAME_MASK+$26*4*4,0
FLAME_FRMS_IDX:	DC.W 0
FIRE_NEXT_ADDR:	DC.L _MED_MODULE-40*2048
PF1_SCREENS:	DC.L PF1S1,PF1S2,PF1S3,PF1S4,PF1S5,PF1S6,PF1S7,PF1S8,PF1S1,0
PF1_SCR_IDX:	DC.W 0
PF2_SCREENS:	DC.L PF2S1,PF2S2,PF2S3,PF2S4,PF2S5,PF2S6,PF2S7,PF2S1,PF2S8,PF2S9,PF2SA,PF2SB,0
PF2_SCR_IDX:	DC.W 0
SCROLL_IDX:	DC.W 0
LFO_SINE1:	DC.W 7,8,10,11,12,13,13,14,14,15,13,13,12,11,10,8,7,6,4,3,2,1,1,0,1,0,1,1,2,3,4,6
LFO_SINE2:	DC.W 7,9,10,11,13,14,14,15,15,15,14,14,13,11,10,9,7,5,4,3,1,0,0,0,0,0,0,0,1,3,4,5
;LFO_SINE2:	DC.W (7>>4)+7,99,1010,1111,1313,1414,1414,1515,1515,1515,1414,1414,1313,1111,1010,99,77,55,44,33,11,00,00,00,00,00,00,00,11,33,44,55
LFO_SINE3:	DC.W 1,1,2,2,3,4,4,5,5,6,6,7,8,7,8,7,6,7,6,5,5,4,4,3,2,3,2,2,1,1,0,0
;*******************************************************************************
	SECTION	ChipData,DATA_C	;declared data that must be in chipmem
;*******************************************************************************

MED_MODULE:	INCBIN "med/VIC-20_2024FIX_SPD33.med"
_chipzero:	DC.L 0
_MED_MODULE:

FLAME_MASK:	INCBIN "flame_mask_32x190x1.raw"
SPRFIRE1:	DC.B $3B,$B4,$3B+$27,%00000001	; VSTART $2C-$F2 | HSTART $44 | VSTOP | CTRLBITS
	.data:
	DCB.W $26*2,0
	DC.L 0
SPRFIRE2:	DC.B $41,$B5,$41+$27,%10000000	; VSTART $2C-$F2 | HSTART $44 | VSTOP | CTRLBITS
	.data:
	DCB.W $26*2,0
	DC.L 0

BGR:	DS.W bgHe*2		; DEFINE AN EMPTY AREA FOR THE BLEEDS
BGR_DATA:	INCBIN "BGR_320x180x1.raw"
PF1S1:	INCBIN "PF1-1_320x116x2.raw"
PF1S2:	INCBIN "PF1-2_320x116x2.raw"
PF1S3:	INCBIN "PF1-3_320x116x2.raw"
PF1S4:	INCBIN "PF1-4_320x116x2.raw"
PF1S5:	INCBIN "PF1-5_320x116x2.raw"
PF1S6:	INCBIN "PF1-6_320x116x2.raw"
PF1S7:	INCBIN "PF1-7_320x116x2.raw"
PF1S8:	INCBIN "PF1-8_320x116x2.raw"
PF2S1:	INCBIN "PF2-1_320x116x3.raw"
PF2S2:	INCBIN "PF2-2_320x116x3.raw"
PF2S3:	INCBIN "PF2-3_320x116x3.raw"
PF2S4:	INCBIN "PF2-4_320x116x3.raw"
PF2S5:	INCBIN "PF2-5_320x116x3.raw"
PF2S6:	INCBIN "PF2-6_320x116x3.raw"
PF2S7:	INCBIN "PF2-7_320x116x3.raw"
PF2S8:	INCBIN "PF2-8_320x116x3.raw"
PF2S9:	INCBIN "PF2-9_320x116x3.raw"
PF2SA:	INCBIN "PF2-A_320x116x3.raw"
PF2SB:	INCBIN "PF2-B_320x116x3.raw"

COPPER:	; #### COPPERLIST ####################################################
	DC.W FMODE,$0000	; Slow fetch mode, remove if AGA demo.
	DC.W DIWSTRT,$2C81	; 238h display window top, left | DIWSTRT - 11.393
	DC.W DIWSTOP,$1CC1	; and bottom, right.| DIWSTOP - 11.457
	DC.W DDFSTRT,$0030	; Standard bitplane dma fetch start
	DC.W DDFSTOP,$00D0	; and stop for standard screen.
	DC.W BPLCON3,$0C00	; (AGA compat. if any Dual Playf. mode)
	DC.W BPLCON2,%01000011 ; SCROLL REGISTER (AND PLAYFIELD PRI)
	;.PFsScrolling:
	DC.W BPLCON1,$88
	DC.W BPL1MOD,bysb-2	; BPL1MOD Bitplane modulo (odd planes)
	DC.W BPL2MOD,bysb-2	; BPL2MOD Bitplane modulo (even planes)

	.Palette:
	DC.W $0180,$0000,$0182,$0455,$0184,$0223,$0186,$0223	; PF
	DC.W $0188,$0112,$018A,$0112,$018C,$0334,$018E,$0334	; PF
	DC.W $0190,$0000,$0192,$0333,$0194,$0344,$0196,$0555	; PF
	DC.W $0198,$0666,$019A,$0888,$019C,$0AA9,$019E,$0F00	; PF
	DC.W $01A0,$0EF2,$01A2,$0720,$01A4,$0EA2,$01A6,$0D91
	DC.W $01A8,$0C71,$01AA,$0A51,$01AC,$0A41,$01AE,$0941
	DC.W $01B0,$0821,$01B2,$0900,$01B4,$0700,$01B6,$0600
	DC.W $01B8,$0500,$01BA,$0400,$01BC,$0300,$01BE,$0200
	;.RedLight:
	;$019E,$0EED
	;DC.W $01A2,$0ED2

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
	INCLUDE "cop.i"
	;DC.W $6D07,$FFFE
	;.BplPtrsBled1:
	;DC.W $E4,0,$E6,0	; 2
	;DC.W $E8,0,$EA,0	; 1
	;DC.W $EC,0,$EE,0	; 2
	;DC.W $F0,0,$F2,0	; 1
	;DC.W $F4,0,$F6,0	; 2	;full 6 ptrs, in case you increase bpls

	;DC.W $E007,$FFFE
	;DC.W BPL1MOD,-1*bypl*3+2	; BPL1MOD Bitplane modulo (odd planes)
	;DC.W BPL2MOD,-1*bypl*3+2	; BPL2MOD Bitplane modulo (even planes)

	;DC.W $FFDF,$FFFE ; PAL FIX

	;DC.W $1A07,$FFFE
	;.BplPtrsBled2:
	;DC.W $E0,0,$E2,0	; 1
	;DC.W $E4,0,$E6,0	; 2
	;DC.W $E8,0,$EA,0	; 1
	;DC.W $EC,0,$EE,0	; 2
	;DC.W $F0,0,$F2,0	; 1
	;DC.W $F4,0,$F6,0	; 2

	DC.W $FFFF,$FFFE ; END COPPER LIST

;*******************************************************************************
	SECTION ChipBuffers,BSS_C	;BSS doesn't count toward exe size
;*******************************************************************************

BLEED:		DS.B blitHe*bypl
PF1:		DS.B blitHe*bypl*2
PF2:		DS.B blitHe*bypl*3

END
