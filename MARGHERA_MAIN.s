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
	LEA	DUMMY,A0
	LEA	COPPER\.BplPtrs+2,A1
	BSR.W	PokePtrs
	;LEA	bypl*he(A0),A0
	LEA	BGR,A0
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	bypl*he(A0),A0
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	bypl*he(A0),A0
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	bypl*he(A0),A0
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs
	LEA	bypl*he(A0),A0
	LEA	8(A1),A1		; -8 bytes on .exe!
	BSR.W	PokePtrs

	; #### CPU INTENSIVE TASKS BEFORE STARTING MUSIC
	MOVE.L	#COPPER,COP1LC(A6)	; ## POINT COPPERLIST ##
;********************  main loop  ********************
MainLoop:
	MOVE.W	#rasterST,D0	;No buffering, so wait until raster
	BSR.W	WaitRaster	;is below the Display Window.
	;###########################################################

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

FRAME_STROBE:	DC.B 0,0
FRAME_COUNT:	DC.W 0

;*******************************************************************************
	SECTION	ChipData,DATA_C	;declared data that must be in chipmem
;*******************************************************************************

DUMMY:	INCBIN "dummy_320x256x1.raw"

COPPER:	; #### COPPERLIST ####################################################
	DC.W FMODE,$0000	; Slow fetch mode, remove if AGA demo.
	DC.W DIWSTRT,$2C81	; 238h display window top, left | DIWSTRT - 11.393
	DC.W DIWSTOP,$1CC1	; and bottom, right.	| DIWSTOP - 11.457
	DC.W DDFSTRT,$0038	; Standard bitplane dma fetch start
	DC.W DDFSTOP,$00D0	; and stop for standard screen.
	DC.W BPLCON3,$0C00	; (AGA compat. if any Dual Playf. mode)
	DC.W BPL1MOD,$0	; BPL1MOD	 Bitplane modulo (odd planes)
	DC.W BPL2MOD,$0	; BPL2MOD Bitplane modulo (even planes)
	;DC.W BPLCON1,$00	; SCROLL REGISTER (AND PLAYFIELD PRI)

	.Palette:
	DC.W $0180,$0000,$0182,$0111,$0184,$0B06,$0186,$0F1A
	DC.W $0188,$0F2C,$018A,$0F5F,$018C,$0F3F,$018E,$0D2E
	DC.W $0190,$0E0E,$0192,$0C0C,$0194,$0706,$0196,$0F8F
	DC.W $0198,$0B0C,$019A,$0C4F,$019C,$080A,$019E,$092E
	DC.W $01A0,$060A,$01A2,$0C6F,$01A4,$0406,$01A6,$0204
	DC.W $01A8,$085F,$01AA,$052E,$01AC,$0F16,$01AE,$011C
	DC.W $01B0,$0016,$01B2,$003C,$01B4,$015E,$01B6,$058F
	DC.W $01B8,$0ECF,$01BA,$016F,$01BC,$008F,$01BE,$01BF

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
	DC.W $180,$012
	DC.W $4207,$FFFE
	DC.W $180,$013
	DC.W $4307,$FFFE
	DC.W $180,$012
	DC.W $4407,$FFFE
	DC.W $180,$013
	DC.W $4F07,$FFFE
	DC.W $180,$003
	DC.W $5007,$FFFE
	DC.W $180,$013
	DC.W $5307,$FFFE
	DC.W $180,$003
	DC.W $5507,$FFFE
	DC.W $180,$013
	DC.W $5607,$FFFE
	DC.W $180,$003
	DC.W $5E07,$FFFE
	DC.W $180,$103
	DC.W $7207,$FFFE
	DC.W $180,$203
	DC.W $8607,$FFFE
	DC.W $180,$303
	DC.W $8707,$FFFE
	DC.W $180,$203
	DC.W $8807,$FFFE
	DC.W $180,$303
	DC.W $9A07,$FFFE
	DC.W $180,$403
	DC.W $9B07,$FFFE
	DC.W $180,$303
	DC.W $9C07,$FFFE
	DC.W $180,$403
	DC.W $A407,$FFFE
	DC.W $180,$503
	DC.W $A807,$FFFE
	DC.W $180,$513
	DC.W $A907,$FFFE
	DC.W $180,$613
	DC.W $AE07,$FFFE
	DC.W $180,$713
	DC.W $AF07,$FFFE
	DC.W $180,$723
	DC.W $B307,$FFFE
	DC.W $180,$823
	DC.W $B707,$FFFE
	DC.W $180,$833
	DC.W $B807,$FFFE
	DC.W $180,$933
	DC.W $BD07,$FFFE
	DC.W $180,$A33
	DC.W $BF07,$FFFE
	DC.W $180,$A43
	DC.W $C207,$FFFE
	DC.W $180,$B43
	DC.W $C607,$FFFE
	DC.W $180,$B53
	DC.W $C707,$FFFE
	DC.W $180,$C53
	DC.W $CC07,$FFFE
	DC.W $180,$D53
	DC.W $CD07,$FFFE
	DC.W $180,$D63
	DC.W $D207,$FFFE
	DC.W $180,$E63
	DC.W $D407,$FFFE
	DC.W $180,$E62
	DC.W $D607,$FFFE
	DC.W $180,$E52
	DC.W $D707,$FFFE
	DC.W $180,$E62
	DC.W $D807,$FFFE
	DC.W BPL1MOD,-1*bypl*3	; BPL1MOD Bitplane modulo (odd planes)
	DC.W BPL2MOD,-1*bypl*3	; BPL2MOD Bitplane modulo (even planes)
	DC.W $180,$E52
	DC.W $E407,$FFFE
	DC.W $180,$D52
	DC.W $E507,$FFFE
	DC.W $180,$D42
	DC.W $E807,$FFFE
	DC.W $180,$C42
	DC.W $EB07,$FFFE
	DC.W $180,$B42
	DC.W $EF07,$FFFE
	DC.W $180,$A42
	DC.W $F207,$FFFE
	DC.W $180,$A32
	DC.W $F307,$FFFE
	DC.W $180,$932
	DC.W $F607,$FFFE
	DC.W $180,$832
	DC.W $F907,$FFFE
	DC.W $180,$732
	DC.W $FD07,$FFFE
	DC.W $180,$632
	DC.W $FE07,$FFFE
	DC.W $180,$622
	DC.W $FFDF,$FFFE ; PAL FIX
	DC.W $107,$FFFE
	DC.W $180,$522
	DC.W $507,$FFFE
	DC.W $180,$422
	DC.W $807,$FFFE
	DC.W $180,$322
	DC.W $B07,$FFFE
	DC.W $180,$312
	DC.W $C07,$FFFE
	DC.W $180,$212
	DC.W $1007,$FFFE
	DC.W $180,$112
	DC.W $1307,$FFFE
	DC.W $180,$012
	DC.W $1907,$FFFE
	DC.W $180,$011
	DC.W $1A07,$FFFE
	DC.W $180,$012
	DC.W $1B07,$FFFE
	DC.W $180,$011
	DC.W $2707,$FFFE
	DC.W $180,$111
	DC.W $2807,$FFFE
	DC.W $180,$011
	DC.W $2907,$FFFE
	DC.W $180,$111
	DC.W $FFFF,$FFFE ; END COPPER LIST

;*******************************************************************************
	SECTION ChipBuffers,BSS_C	;BSS doesn't count toward exe size
;*******************************************************************************

BGR:		DS.B he*bypl*1
PF1:		DS.B he*bypl*2
PF2:		DS.B he*bypl*3

END
