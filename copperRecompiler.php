<?php
## KONEY 2024 ## DEFRAG COPPERLISTS!
$copperLines='
	dc.w $2b07,$fffe
	dc.w $180,$f00
	dc.w $3b07,$fffe
	dc.w $180,$e01
	dc.w $4b07,$fffe
	dc.w $180,$d02
	dc.w $5b07,$fffe
	dc.w $180,$c03
	dc.w $6b07,$fffe
	dc.w $180,$b04
	dc.w $7b07,$fffe
	dc.w $180,$a05
	dc.w $8b07,$fffe
	dc.w $180,$906
	dc.w $9b07,$fffe
	dc.w $180,$807
	dc.w $ab07,$fffe
	dc.w $180,$708
	dc.w $bb07,$fffe
	dc.w $180,$609
	dc.w $cb07,$fffe
	dc.w $180,$50a
	dc.w $db07,$fffe
	dc.w $180,$30c

	.BplPtrsBleed:
	DC.W $E4,0,$E6,0	; 2 comment
	dc.w $e8,0,$ea,0	; 1
	dc.W $EC,0,$EE,0	; 2
	DC.W $F0,0,$F2,0	; 1
	DC.w $F4,0,$F6,0	; 2

	Dc.w BPL1MOD,-1*bypl*3	; BPL1MOD Bitplane modulo (odd planes)
	DC.W BPL2MOD,-1*bypl*3	; BPL2MOD Bitplane modulo (even planes)

	dc.w $eb07,$fffe
	dc.w $180,$30c
	dc.w $fb07,$fffe
	dc.w $180,$20d
	dc.w $ffdf,$fffe
	dc.w $b07,$fffe
	dc.w $180,$10e
	dc.w $1b07,$fffe
	DC.W $180,$00F
	dc.w $ffff,$fffe	

	DC.W $6B07,$FFFE

	DC.W $3007,$FFFE
	dc.w $18c,$0cf
	dc.w $6a07,$fffe
	dc.w $18c,$0df
	dc.w $7607,$fffe
	dc.w $18c,$0de
	dc.w $8907,$fffe
	dc.w $18c,$0dd
	dc.w $9a07,$fffe
	dc.w $18c,$0ec
	dc.w $aa07,$fffe
	dc.w $18c,$0eb
	dc.w $b807,$fffe
	dc.w $18c,$0ea
	dc.w $c507,$fffe
	dc.w $18c,$0e9
	dc.w $cc07,$fffe
	dc.w $18c,$0f9
	dc.w $d107,$fffe
	dc.w $18c,$0f8

	dc.w $da07,$fffe
	dc.w $18c,$0f7
	dc.w $e307,$fffe
	dc.w $18c,$0f6
	dc.w $ea07,$fffe
	dc.w $18c,$0f5
	dc.w $eb07,$fffe
	dc.w $18c,$1f5
	dc.w $ef07,$fffe
	dc.w $18c,$1f4
	dc.w $f407,$fffe
	dc.w $18c,$1f3
	dc.w $f707,$fffe
	dc.w $18c,$1f2
	dc.w $f907,$fffe
	dc.w $18c,$1f1
	dc.w $fb07,$fffe
	dc.w $18c,$1f0
	dc.w $18A,$fff
	dc.w $ffdf,$fffe
	dc.w $ffff,$fffe
	dc.w $2b07,$fffe
	dc.w $188,$00f
	dc.w $5307,$fffe
	dc.w $188,$10f
	dc.w $6307,$fffe
	dc.w $188,$20f
	dc.w $6d07,$fffe
	dc.w $188,$30f
	dc.w $8707,$fffe
	dc.w $188,$40f
	dc.w $9607,$fffe
	dc.w $188,$50f
	dc.w $a007,$fffe
	dc.w $188,$60f
	dc.w $a907,$fffe
	dc.w $188,$70f
	dc.w $b407,$fffe
	dc.w $188,$80f
	dc.w $c007,$fffe
	dc.w $188,$90f
	dc.w $ce07,$fffe
	dc.w $188,$a0f
	dc.w $cf07,$fffe
	dc.w $188,$90f
	dc.w $d007,$fffe
	dc.w $188,$a0f
	dc.w $dd07,$fffe
	dc.w $188,$b0f
	dc.w $ec07,$fffe
	dc.w $188,$c0f
	dc.w $fa07,$fffe
	dc.w $188,$d0f
	dc.w $ffdf,$fffe
	dc.w $a07,$fffe
	dc.w $188,$e0f
	dc.w $1a07,$fffe
	dc.w $188,$f0f
	dc.w $ffff,$fffe';
	$copStart='2b';
	$copperList=[];
	$lineIDX=0;
	$copperLines=explode("\n", $copperLines);
	foreach ($copperLines AS $k=>$value){
		$value=trim($value);
		if(!$value && !$k){ continue;	}
		$line=explode('$',$value);
		@$tempHex=dechex(hexdec(trim($line[1])));
		@$line[0]=hexdec(substr(trim($line[1]),0,-3));
		@$line[1]=trim($line[2]);
		$line[2]=$tempHex;
		if(strtoupper($line[1])=='FFFE'){
			# LINE IS A WAIT
			$lineIDX=$line[0];
		}else{
			# LINE IS AN INSTRUCTION
			if($line[0] && !(strpos($line[1],',')!==false)){
				$copperList[$lineIDX]['DCW'][]=
					strtoupper('$'.str_pad($line[2], 4, '0', STR_PAD_LEFT).',$'.str_pad($line[1], 4, '0', STR_PAD_LEFT));
			}else{
				# LINE IS A COMPLEX INSTRUCTION, A LABEL OR AN EMPTY LINE
				if(stripos($value, 'DC.W')!==false){
					if(!$line[1]){
						$value=str_ireplace('dc.w','DC.W',$value);		# CONTAINS CONSTANTS
					}else{
						$value=strtoupper($value);		# A COMPLEX INSTRUCTION?
					}
				}
				$copperList[$lineIDX]['LNS'][]=$value;
			}
		}
	}
	//print_r($copperList);	exit;
	#######################################
	error_reporting(E_ERROR);
	echo "\n".'	.Waits:';
	for($i=hexdec($copStart); $i<hexdec('ff'); $i++){
		if(!array_key_exists($i, $copperList)){	continue;	}
		extractCopLines($i,$copperList[$i]);
	}
	echo "\n".'	DC.W $FFDF,$FFFE';
	echo '	; # PAL FIX';
	for($i=hexdec('00'); $i<hexdec('1c'); $i++){
		if(!array_key_exists($i, $copperList)){	continue;	}
		extractCopLines($i,$copperList[$i]);
	}
	echo "\n".'	DC.W $FFFF,$FFFE';
	echo '	; # END COPPER LIST';

	function extractCopLines($wait,$element){
		GLOBAL $totLines,$copStart;
		echo "\n\t"."DC.W $".strtoupper(str_pad(dechex($wait), 2, '0', STR_PAD_LEFT)).'07'.",".'$FFFE';
		if($wait<hexdec($copStart)){
			$tempLine=$wait+212;
		}else{
			$tempLine=$wait-hexdec($copStart);
		}
		echo '	; # Wait';
		if($tempLine%8==0){	echo ' LN '.($tempLine);	}
		if(count($element['DCW'])){
			echo "\n\t".'DC.W '.implode(',',$element['DCW']);
		}
		foreach($element['LNS'] AS $value){
			echo "\n\t".($value);
		}
	}
	//echo " (".count($copperLines)." | ". count($copperList). ")";
?>

