<?php
## KONEY 2024 ## DEFRAG COPPERLISTS!
## ; https://gradient-blaster.grahambates.com/?points=013@0,113@34,213@62,313@84,413@104,513@120,613@131,713@141,813@150,923@158,b33@165,e73@175,e73@182,403@213,003@238&steps=256&blendMode=linear&ditherMode=orderedMono&target=amigaOcs&ditherAmount=12
$copperLines='
	dc.w $2c07,$fffe
	dc.w $182,$013
	dc.w $4b07,$fffe
	dc.w $182,$113
	dc.w $6607,$fffe
	dc.w $182,$213
	dc.w $7c07,$fffe
	dc.w $182,$313
	dc.w $8f07,$fffe
	dc.w $182,$413
	dc.w $9f07,$fffe
	dc.w $182,$513
	dc.w $ab07,$fffe
	dc.w $182,$613
	dc.w $b507,$fffe
	dc.w $182,$713
	dc.w $be07,$fffe
	dc.w $182,$813
	dc.w $c607,$fffe
	dc.w $182,$913
	dc.w $c907,$fffe
	dc.w $182,$923
	dc.w $cc07,$fffe
	dc.w $182,$a23
	dc.w $cf07,$fffe
	dc.w $182,$b23
	dc.w $d007,$fffe
	dc.w $182,$b33
	dc.w $d207,$fffe
	dc.w $182,$c33
	dc.w $d307,$fffe
	dc.w $182,$c43
	dc.w $d507,$fffe
	dc.w $182,$d43
	dc.w $d607,$fffe
	dc.w $182,$d53
	dc.w $d807,$fffe
	dc.w $182,$e63
	dc.w $da07,$fffe
	dc.w $182,$e73
	dc.w $e507,$fffe
	dc.w $182,$d63
	dc.w $e807,$fffe
	dc.w $182,$c63
	dc.w $e907,$fffe
	dc.w $182,$c53
	dc.w $eb07,$fffe
	dc.w $182,$b53
	dc.w $ed07,$fffe
	dc.w $182,$b43
	dc.w $ee07,$fffe
	dc.w $182,$a43
	dc.w $f107,$fffe
	dc.w $182,$933
	dc.w $f407,$fffe
	dc.w $182,$833
	dc.w $f507,$fffe
	dc.w $182,$823
	dc.w $f707,$fffe
	dc.w $182,$723
	dc.w $f907,$fffe
	dc.w $182,$713
	dc.w $fa07,$fffe
	dc.w $182,$613
	dc.w $fd07,$fffe
	dc.w $182,$503
	dc.w $ff07,$fffe
	dc.w $182,$403
	dc.w $ffdf,$fffe
	dc.w $307,$fffe
	dc.w $182,$303
	dc.w $907,$fffe
	dc.w $182,$203
	dc.w $f07,$fffe
	dc.w $182,$103
	dc.w $1507,$fffe
	dc.w $182,$003

	DC.W $6D07,$FFFE
	.BplPtrsBled1:
	DC.W $E4,0,$E6,0
	DC.W $E8,0,$EA,0
	DC.W $EC,0,$EE,0
	DC.W $F0,0,$F2,0
	DC.W $F4,0,$F6,0

	DC.W $E007,$FFFE
	DC.W BPL1MOD,-1*bypl*3+2
	DC.W BPL2MOD,-1*bypl*3+2

	DC.W $FFDF,$FFFE

	DC.W $1A07,$FFFE
	.BplPtrsBled2:
	DC.W $E0,0,$E2,0
	DC.W $E4,0,$E6,0
	DC.W $E8,0,$EA,0
	DC.W $EC,0,$EE,0
	DC.W $F0,0,$F2,0
	DC.W $F4,0,$F6,0

	DC.W $FFFF,$FFFE';
	$copStart='2C';
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
	//echo "\n".'	.Waits:';
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
	//echo "\n".'	DC.W $FFFF,$FFFE';
	//echo '	; # END COPPER LIST';

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