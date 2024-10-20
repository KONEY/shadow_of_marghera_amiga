<?php
## KONEY 2024 ## DEFRAG COPPERLISTS!
## ; https://gradient-blaster.grahambates.com/?points=013@0,113@34,213@62,313@84,413@104,513@120,613@131,713@141,813@150,923@158,b33@165,e73@175,e73@182,403@213,003@238&steps=256&blendMode=linear&ditherMode=orderedMono&target=amigaOcs&ditherAmount=12
## ; https://gradient-blaster.grahambates.com/?points=013@0,113@34,213@62,313@84,413@104,513@120,613@131,713@141,813@150,923@158,b33@165,e73@175,a52@186,723@199,211@210,111@219,011@230,000@237&steps=256&blendMode=linear&ditherMode=blueNoiseMono&target=amigaOcs&ditherAmount=0

$copperLines='
	dc.w $2c07,$fffe
	dc.w $182,$013
	dc.w $4b07,$fffe
	dc.w $182,$113

	dc.w $3b07,$fffe
	dc.w $1ac,$001
	dc.w $3d07,$fffe
	dc.w $1ac,$101
	dc.w $3e07,$fffe
	dc.w $1ac,$201
	dc.w $3f07,$fffe
	dc.w $1ac,$311
	dc.w $4007,$fffe
	dc.w $1ac,$511
	dc.w $4107,$fffe
	dc.w $1ac,$621
	dc.w $4207,$fffe
	dc.w $1ac,$831
	dc.w $4307,$fffe
	dc.w $1ac,$a41

	dc.w $3b07,$fffe
	dc.w $1aa,$012
	dc.w $3d07,$fffe
	dc.w $1aa,$011
	dc.w $3e07,$fffe
	dc.w $1aa,$111
	dc.w $4007,$fffe
	dc.w $1aa,$211
	dc.w $4207,$fffe
	dc.w $1aa,$311
	dc.w $4407,$fffe
	dc.w $1aa,$411
	dc.w $4707,$fffe
	dc.w $1aa,$521
	dc.w $4a07,$fffe
	dc.w $1aa,$621
	dc.w $4b07,$fffe
	dc.w $1aa,$631
	dc.w $4c07,$fffe
	dc.w $1aa,$731
	dc.w $4f07,$fffe
	dc.w $1aa,$841
	dc.w $5107,$fffe
	dc.w $1aa,$941
	dc.w $5407,$fffe
	dc.w $1aa,$a51

	dc.w $3b07,$fffe
	dc.w $1a2,$012
	dc.w $3c07,$fffe
	dc.w $1a2,$111
	dc.w $3e07,$fffe
	dc.w $1a2,$211
	dc.w $4107,$fffe
	dc.w $1a2,$311
	dc.w $4507,$fffe
	dc.w $1a2,$411
	dc.w $4a07,$fffe
	dc.w $1a2,$511
	dc.w $4c07,$fffe
	dc.w $1a2,$510
	dc.w $4e07,$fffe
	dc.w $1a2,$610
	dc.w $5307,$fffe
	dc.w $1a2,$720

	dc.w $3b07,$fffe
	dc.w $1a8,$013
	dc.w $3c07,$fffe
	dc.w $1a8,$113
	dc.w $3d07,$fffe
	dc.w $1a8,$213
	dc.w $3e07,$fffe
	dc.w $1a8,$302
	dc.w $3f07,$fffe
	dc.w $1a8,$412
	dc.w $4007,$fffe
	dc.w $1a8,$512
	dc.w $4107,$fffe
	dc.w $1a8,$612
	dc.w $4207,$fffe
	dc.w $1a8,$712
	dc.w $4407,$fffe
	dc.w $1a8,$811
	dc.w $4507,$fffe
	dc.w $1a8,$911
	dc.w $4607,$fffe
	dc.w $1a8,$a11
	dc.w $4807,$fffe
	dc.w $1a8,$b11
	dc.w $4907,$fffe
	dc.w $1a8,$c21
	dc.w $4b07,$fffe
	dc.w $1a8,$c31
	dc.w $4d07,$fffe
	dc.w $1a8,$c41
	dc.w $4f07,$fffe
	dc.w $1a8,$c51
	dc.w $5107,$fffe
	dc.w $1a8,$c61
	dc.w $5407,$fffe
	dc.w $1a8,$c71

	dc.w $3b07,$fffe
	dc.w $1b8,$003
	dc.w $3f07,$fffe
	dc.w $1b8,$002
	dc.w $4407,$fffe
	dc.w $1b8,$102
	dc.w $4c07,$fffe
	dc.w $1b8,$202
	dc.w $4e07,$fffe
	dc.w $1b8,$201
	dc.w $5007,$fffe
	dc.w $1b8,$301
	dc.w $5207,$fffe
	dc.w $1b8,$400
	dc.w $5507,$fffe
	dc.w $1b8,$500

	dc.w $3b07,$fffe
	dc.w $1b0,$013
	dc.w $4007,$fffe
	dc.w $1b0,$113
	dc.w $4407,$fffe
	dc.w $1b0,$213
	dc.w $4607,$fffe
	dc.w $1b0,$312
	dc.w $4807,$fffe
	dc.w $1b0,$412
	dc.w $4a07,$fffe
	dc.w $1b0,$512
	dc.w $4d07,$fffe
	dc.w $1b0,$612
	dc.w $4f07,$fffe
	dc.w $1b0,$611
	dc.w $5007,$fffe
	dc.w $1b0,$711
	dc.w $5307,$fffe
	dc.w $1b0,$721
	dc.w $5407,$fffe
	dc.w $1b0,$821

	dc.w $3b07,$fffe
	dc.w $1b4,$013
	dc.w $3d07,$fffe
	dc.w $1b4,$113
	dc.w $4007,$fffe
	dc.w $1b4,$213
	dc.w $4207,$fffe
	dc.w $1b4,$302
	dc.w $4507,$fffe
	dc.w $1b4,$402
	dc.w $4907,$fffe
	dc.w $1b4,$502
	dc.w $4c07,$fffe
	dc.w $1b4,$501
	dc.w $4e07,$fffe
	dc.w $1b4,$601
	dc.w $5207,$fffe
	dc.w $1b4,$600
	dc.w $5307,$fffe
	dc.w $1b4,$700

	dc.w $3b07,$fffe
	dc.w $1a6,$013
	dc.w $3d07,$fffe
	dc.w $1a6,$113
	dc.w $3f07,$fffe
	dc.w $1a6,$213
	dc.w $4107,$fffe
	dc.w $1a6,$313
	dc.w $4207,$fffe
	dc.w $1a6,$323
	dc.w $4307,$fffe
	dc.w $1a6,$423
	dc.w $4507,$fffe
	dc.w $1a6,$533
	dc.w $4707,$fffe
	dc.w $1a6,$633
	dc.w $4807,$fffe
	dc.w $1a6,$643
	dc.w $4907,$fffe
	dc.w $1a6,$743
	dc.w $4a07,$fffe
	dc.w $1a6,$853
	dc.w $4c07,$fffe
	dc.w $1a6,$952
	dc.w $4d07,$fffe
	dc.w $1a6,$962
	dc.w $4e07,$fffe
	dc.w $1a6,$a62
	dc.w $4f07,$fffe
	dc.w $1a6,$a72
	dc.w $5007,$fffe
	dc.w $1a6,$b72
	dc.w $5207,$fffe
	dc.w $1a6,$c82
	dc.w $5407,$fffe
	dc.w $1a6,$d91

	dc.w $3b07,$fffe
	dc.w $1a4,$013
	dc.w $3d07,$fffe
	dc.w $1a4,$113
	dc.w $3f07,$fffe
	dc.w $1a4,$213
	dc.w $4007,$fffe
	dc.w $1a4,$322
	dc.w $4107,$fffe
	dc.w $1a4,$422
	dc.w $4207,$fffe
	dc.w $1a4,$432
	dc.w $4307,$fffe
	dc.w $1a4,$532
	dc.w $4407,$fffe
	dc.w $1a4,$542
	dc.w $4507,$fffe
	dc.w $1a4,$642
	dc.w $4607,$fffe
	dc.w $1a4,$742
	dc.w $4707,$fffe
	dc.w $1a4,$752
	dc.w $4807,$fffe
	dc.w $1a4,$852
	dc.w $4a07,$fffe
	dc.w $1a4,$962
	dc.w $4c07,$fffe
	dc.w $1a4,$a72
	dc.w $4e07,$fffe
	dc.w $1a4,$b82
	dc.w $5007,$fffe
	dc.w $1a4,$c82
	dc.w $5107,$fffe
	dc.w $1a4,$c92
	dc.w $5207,$fffe
	dc.w $1a4,$d92
	dc.w $5407,$fffe
	dc.w $1a4,$ea2

	dc.w $5207,$fffe
	dc.w $019E,$0EED

	.PFsScrolling:
	DC.W BPLCON1,$88

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
	dc.w $de07,$fffe
	dc.w $182,$d62
	dc.w $e107,$fffe
	dc.w $182,$c62
	dc.w $e307,$fffe
	dc.w $182,$b52
	dc.w $e607,$fffe
	dc.w $182,$a52
	dc.w $e807,$fffe
	dc.w $182,$a42
	dc.w $e907,$fffe
	dc.w $182,$942
	dc.w $ec07,$fffe
	dc.w $182,$932
	dc.w $ed07,$fffe
	dc.w $182,$832
	dc.w $f007,$fffe
	dc.w $182,$822
	dc.w $f107,$fffe
	dc.w $182,$723
	dc.w $f507,$fffe
	dc.w $182,$612
	dc.w $f707,$fffe
	dc.w $182,$512
	dc.w $f907,$fffe
	dc.w $182,$412
	dc.w $fa07,$fffe
	dc.w $182,$411
	dc.w $fb07,$fffe
	dc.w $182,$311
	dc.w $fd07,$fffe
	dc.w $182,$211
	dc.w $007,$fffe
	dc.w $182,$111
	dc.w $907,$fffe
	dc.w $182,$011

	dc.w $da07,$fffe
	dc.w $19e,$ddc
	dc.w $dd07,$fffe
	dc.w $19e,$cdb
	dc.w $de07,$fffe
	dc.w $19e,$ccb
	dc.w $e107,$fffe
	dc.w $19e,$bca
	dc.w $e207,$fffe
	dc.w $19e,$bba
	dc.w $e507,$fffe
	dc.w $19e,$aba
	dc.w $e607,$fffe
	dc.w $19e,$aaa
	dc.w $e707,$fffe
	dc.w $19e,$aa9
	dc.w $e807,$fffe
	dc.w $19e,$9a9
	dc.w $ea07,$fffe
	dc.w $19e,$999
	dc.w $eb07,$fffe
	dc.w $19e,$998
	dc.w $ec07,$fffe
	dc.w $19e,$898
	dc.w $ee07,$fffe
	dc.w $19e,$888
	dc.w $ef07,$fffe
	dc.w $19e,$887
	dc.w $f007,$fffe
	dc.w $19e,$787
	dc.w $f207,$fffe
	dc.w $19e,$777
	dc.w $f407,$fffe
	dc.w $19e,$776
	dc.w $f507,$fffe
	dc.w $19e,$676
	dc.w $f707,$fffe
	dc.w $19e,$666
	dc.w $f807,$fffe
	dc.w $19e,$665
	dc.w $f907,$fffe
	dc.w $19e,$565
	dc.w $fa07,$fffe
	dc.w $19e,$555
	dc.w $fd07,$fffe
	dc.w $19e,$455
	dc.w $ff07,$fffe
	dc.w $19e,$444
	dc.w $107,$fffe
	dc.w $19e,$344
	dc.w $307,$fffe
	dc.w $19e,$343
	dc.w $407,$fffe
	dc.w $19e,$333
	dc.w $607,$fffe
	dc.w $19e,$233
	dc.w $907,$fffe
	dc.w $19e,$222
	dc.w $b07,$fffe
	dc.w $19e,$122
	dc.w $d07,$fffe
	dc.w $19e,$121
	dc.w $e07,$fffe
	dc.w $19e,$111
	dc.w $1207,$fffe
	dc.w $19e,$011

	dc.w $da07,$fffe
	dc.w $19c,$998
	dc.w $dd07,$fffe
	dc.w $19c,$898
	dc.w $de07,$fffe
	dc.w $19c,$887
	dc.w $e307,$fffe
	dc.w $19c,$786
	dc.w $e507,$fffe
	dc.w $19c,$776
	dc.w $e907,$fffe
	dc.w $19c,$676
	dc.w $eb07,$fffe
	dc.w $19c,$666
	dc.w $ee07,$fffe
	dc.w $19c,$665
	dc.w $ef07,$fffe
	dc.w $19c,$565
	dc.w $f007,$fffe
	dc.w $19c,$555
	dc.w $f407,$fffe
	dc.w $19c,$554
	dc.w $f507,$fffe
	dc.w $19c,$454
	dc.w $f707,$fffe
	dc.w $19c,$444
	dc.w $fb07,$fffe
	dc.w $19c,$443
	dc.w $fc07,$fffe
	dc.w $19c,$343
	dc.w $fe07,$fffe
	dc.w $19c,$333
	dc.w $107,$fffe
	dc.w $19c,$233
	dc.w $507,$fffe
	dc.w $19c,$222
	dc.w $907,$fffe
	dc.w $19c,$122
	dc.w $b07,$fffe
	dc.w $19c,$121
	dc.w $d07,$fffe
	dc.w $19c,$111
	dc.w $1207,$fffe
	dc.w $19c,$011

	dc.w $da07,$fffe
	dc.w $198,$555
	dc.w $e007,$fffe
	dc.w $198,$444
	dc.w $eb07,$fffe
	dc.w $198,$333
	dc.w $f307,$fffe
	dc.w $198,$233
	dc.w $fa07,$fffe
	dc.w $198,$222
	dc.w $107,$fffe
	dc.w $198,$122
	dc.w $607,$fffe
	dc.w $198,$121
	dc.w $807,$fffe
	dc.w $198,$111
	dc.w $1207,$fffe
	dc.w $198,$011

	dc.w $da07,$fffe
	dc.w $196,$444
	dc.w $e007,$fffe
	dc.w $196,$333
	dc.w $ef07,$fffe
	dc.w $196,$222
	dc.w $f107,$fffe
	dc.w $196,$233
	dc.w $f207,$fffe
	dc.w $196,$222
	dc.w $fc07,$fffe
	dc.w $196,$122
	dc.w $207,$fffe
	dc.w $196,$121
	dc.w $507,$fffe
	dc.w $196,$111
	dc.w $1207,$fffe
	dc.w $196,$011

	dc.w $da07,$fffe
	dc.w $194,$333
	dc.w $de07,$fffe
	dc.w $194,$222
	dc.w $f207,$fffe
	dc.w $194,$122
	dc.w $fa07,$fffe
	dc.w $194,$121
	dc.w $ff07,$fffe
	dc.w $194,$111
	dc.w $1207,$fffe
	dc.w $194,$011

	dc.w $da07,$fffe
	dc.w $192,$222
	dc.w $e107,$fffe
	dc.w $192,$111
	dc.w $807,$fffe
	dc.w $192,$011
	dc.w $907,$fffe
	dc.w $192,$111
	dc.w $a07,$fffe
	dc.w $192,$011
	dc.w $b07,$fffe
	dc.w $192,$111
	dc.w $c07,$fffe
	dc.w $192,$011
	dc.w $d07,$fffe
	dc.w $192,$111
	dc.w $e07,$fffe
	dc.w $192,$011
	dc.w $f07,$fffe
	dc.w $192,$111
	dc.w $1007,$fffe
	dc.w $192,$011
	dc.w $1107,$fffe
	dc.w $192,$111
	dc.w $1207,$fffe
	dc.w $192,$011

	dc.w $da07,$fffe
	dc.w $19a,$777
	dc.w $df07,$fffe
	dc.w $19a,$666
	dc.w $e707,$fffe
	dc.w $19a,$555
	dc.w $ef07,$fffe
	dc.w $19a,$444
	dc.w $f407,$fffe
	dc.w $19a,$344
	dc.w $f807,$fffe
	dc.w $19a,$343
	dc.w $f907,$fffe
	dc.w $19a,$333
	dc.w $fc07,$fffe
	dc.w $19a,$233

	dc.w $107,$fffe
	dc.w $19a,$222
	dc.w $607,$fffe
	dc.w $19a,$122
	dc.w $a07,$fffe
	dc.w $19a,$121
	dc.w $b07,$fffe
	dc.w $19a,$111
	dc.w $1207,$fffe
	dc.w $19a,$011

	dc.w $da07,$fffe
	dc.w $18e,$333
	dc.w $df07,$fffe
	dc.w $18e,$222
	dc.w $f307,$fffe
	dc.w $18e,$122
	dc.w $fb07,$fffe
	dc.w $18e,$121
	dc.w $007,$fffe
	dc.w $18e,$111
	dc.w $1007,$fffe
	dc.w $18e,$011
	dc.w $1107,$fffe
	dc.w $18e,$111
	dc.w $1207,$fffe
	dc.w $18e,$011

	dc.w $da07,$fffe
	dc.w $18c,$333
	dc.w $df07,$fffe
	dc.w $18c,$222
	dc.w $f307,$fffe
	dc.w $18c,$122
	dc.w $fb07,$fffe
	dc.w $18c,$121
	dc.w $007,$fffe
	dc.w $18c,$111
	dc.w $1007,$fffe
	dc.w $18c,$011
	dc.w $1107,$fffe
	dc.w $18c,$111
	dc.w $1207,$fffe
	dc.w $18c,$011

	dc.w $da07,$fffe
	dc.w $18a,$112
	dc.w $db07,$fffe
	dc.w $18a,$012
	dc.w $e707,$fffe
	dc.w $18a,$111
	dc.w $e807,$fffe
	dc.w $18a,$011
	dc.w $e907,$fffe
	dc.w $18a,$111
	dc.w $ea07,$fffe
	dc.w $18a,$011
	dc.w $eb07,$fffe
	dc.w $18a,$111
	dc.w $ec07,$fffe
	dc.w $18a,$011
	dc.w $ed07,$fffe
	dc.w $18a,$111
	dc.w $ee07,$fffe
	dc.w $18a,$011
	dc.w $ef07,$fffe
	dc.w $18a,$111
	dc.w $f007,$fffe
	dc.w $18a,$011
	dc.w $f107,$fffe
	dc.w $18a,$111
	dc.w $f207,$fffe
	dc.w $18a,$011
	dc.w $f307,$fffe
	dc.w $18a,$111
	dc.w $f407,$fffe
	dc.w $18a,$001
	dc.w $f507,$fffe
	dc.w $18a,$011
	dc.w $f607,$fffe
	dc.w $18a,$001
	dc.w $f707,$fffe
	dc.w $18a,$011
	dc.w $1007,$fffe
	dc.w $18a,$000
	dc.w $1107,$fffe
	dc.w $18a,$010
	dc.w $1207,$fffe
	dc.w $18a,$011

	dc.w $da07,$fffe
	dc.w $188,$112
	dc.w $db07,$fffe
	dc.w $188,$012
	dc.w $e707,$fffe
	dc.w $188,$111
	dc.w $e807,$fffe
	dc.w $188,$011
	dc.w $e907,$fffe
	dc.w $188,$111
	dc.w $ea07,$fffe
	dc.w $188,$011
	dc.w $eb07,$fffe
	dc.w $188,$111
	dc.w $ec07,$fffe
	dc.w $188,$011
	dc.w $ed07,$fffe
	dc.w $188,$111
	dc.w $ee07,$fffe
	dc.w $188,$011
	dc.w $ef07,$fffe
	dc.w $188,$111
	dc.w $f007,$fffe
	dc.w $188,$011
	dc.w $f107,$fffe
	dc.w $188,$111
	dc.w $f207,$fffe
	dc.w $188,$011
	dc.w $f307,$fffe
	dc.w $188,$111
	dc.w $f407,$fffe
	dc.w $188,$001
	dc.w $f507,$fffe
	dc.w $188,$011
	dc.w $f607,$fffe
	dc.w $188,$001
	dc.w $f707,$fffe
	dc.w $188,$011
	dc.w $1007,$fffe
	dc.w $188,$000
	dc.w $1107,$fffe
	dc.w $188,$010
	dc.w $1207,$fffe
	dc.w $188,$011

	dc.w $da07,$fffe
	dc.w $186,$222
	dc.w $e107,$fffe
	dc.w $186,$111
	dc.w $e207,$fffe
	dc.w $186,$222
	dc.w $e307,$fffe
	dc.w $186,$111
	dc.w $e507,$fffe
	dc.w $186,$222
	dc.w $e607,$fffe
	dc.w $186,$111
	dc.w $ea07,$fffe
	dc.w $186,$222
	dc.w $eb07,$fffe
	dc.w $186,$111
	dc.w $807,$fffe
	dc.w $186,$011
	dc.w $a07,$fffe
	dc.w $186,$111
	dc.w $b07,$fffe
	dc.w $186,$011
	dc.w $c07,$fffe
	dc.w $186,$111
	dc.w $e07,$fffe
	dc.w $186,$011
	dc.w $f07,$fffe
	dc.w $186,$111
	dc.w $1007,$fffe
	dc.w $186,$011
	dc.w $1107,$fffe
	dc.w $186,$111
	dc.w $1207,$fffe
	dc.w $186,$011

	dc.w $da07,$fffe
	dc.w $184,$222
	dc.w $e107,$fffe
	dc.w $184,$111
	dc.w $e207,$fffe
	dc.w $184,$222
	dc.w $e307,$fffe
	dc.w $184,$111
	dc.w $e507,$fffe
	dc.w $184,$222
	dc.w $e607,$fffe
	dc.w $184,$111
	dc.w $ea07,$fffe
	dc.w $184,$222
	dc.w $eb07,$fffe
	dc.w $184,$111
	dc.w $807,$fffe
	dc.w $184,$011
	dc.w $a07,$fffe
	dc.w $184,$111
	dc.w $b07,$fffe
	dc.w $184,$011
	dc.w $c07,$fffe
	dc.w $184,$111
	dc.w $e07,$fffe
	dc.w $184,$011
	dc.w $f07,$fffe
	dc.w $184,$111
	dc.w $1007,$fffe
	dc.w $184,$011
	dc.w $1107,$fffe
	dc.w $184,$111
	dc.w $1207,$fffe
	dc.w $184,$011

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

	DC.W $1307,$FFFE
	.BplPtrsBled2:
	DC.W $E0,0,$E2,0
	DC.W $E4,0,$E6,0
	DC.W $E8,0,$EA,0
	DC.W $EC,0,$EE,0
	DC.W $F0,0,$F2,0
	DC.W $F4,0,$F6,0
	';
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