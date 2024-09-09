;********** relevant blitter registers **********
;base reg $dff000
CUSTOM	= $DFF000

BLTDDAT	= $000	;result of the last word. used for bob collision detection and 
		;MFM decoding
DMACONR	= $002	;bit 14=blitter busy flag

;NEW...
FMODE	= $1FC
DIWSTRT	= $08E
DIWSTOP	= $090
DDFSTRT	= $092
DDFSTOP	= $094
POTINP	= $016

;blitter operation setup
BLTCON0	= $040
BLTCON1	= $042
BLTAFWM	= $044
BLTALWM	= $046

;sources, destination, and size
BLTCPTH	= $048
BLTCPTL	= $04A
BLTBPTH	= $04C
BLTBPTL	= $04E
BLTAPTH	= $050
BLTAPTL	= $052
BLTDPTH	= $054
BLTDPTL	= $056

BLTSIZE	= $058

;ECS/AGA registers
BLTCON0L	= $05A
BLTSIZV	= $05C
BLTSIZH	= $05E

;modulos
BLTCMOD	= $060	
BLTBMOD	= $062
BLTAMOD	= $064
BLTDMOD	= $066

;data to replace sources
BLTCDAT	= $070	
BLTBDAT	= $072
BLTADAT	= $074

BPLCON0	= $100
BPLCON1	= $102
BPLCON2	= $104
BPLCON3	= $106
BPL1MOD	= $108
BPL2MOD	= $10A

;bit 6: enable blitter DMA - bit 10: give blitter priority over the CPU
DMACON	= $096

;Interrupt enable bits (clear or set bits)
INTENA	= $09A
INTENAR	= $01C
INTREQ	= $09C
INTREQR	= $01E

VPOSR	= $004
VHPOSR	= $006
VPOSW	= $02A

COP1LC	= $080
COP2LC	= $084

COPJMP1	= $088
COPJMP2	= $08A

COP1LCH	= $080
COP1LCL	= $082
COP2LCH	= $084
COP2LCL	= $086

;BPLPT	= $0E0