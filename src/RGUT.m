RGUT ;RI/CBMI/DKM - General purpose utilities;09-Mar-2015 10:10;DKM
 ;;3.0;RG UTILITIES;**1**;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 ; Replaces delimited arguments in string, returning result
MSG(%RGTXT,%RGDLM,%RGRPL) ;EP
 N %RGZ1,%RGZ2
 I $$NEWERR^%ZTER N $ET S $ET=""
 S:$G(%RGDLM)="" %RGDLM="%"
 S %RGZ2="",@$$TRAP^RGUTOS("M1^RGUT")
 S:$G(%RGRPL,1) %RGTXT=$TR(%RGTXT,"~","^")
 F  Q:%RGTXT=""  D
 .S %RGZ2=%RGZ2_$P(%RGTXT,%RGDLM),%RGZ1=$P(%RGTXT,%RGDLM,2),%RGTXT=$P(%RGTXT,%RGDLM,3,999)
 .I %RGZ1="" S:%RGTXT'="" %RGZ2=%RGZ2_%RGDLM
 .E  X "S %RGZ2=%RGZ2_("_%RGZ1_")"
M1 Q %RGZ2
 ; Case-insensitive string comparison
 ; Returns 0: X=Y, 1: X>Y, -1: X<Y
STRICMP(X,Y) ;EP
 S X=$$UP^XLFSTR(X),Y=$$UP^XLFSTR(Y)
 Q $S(X=Y:0,X]]Y:1,1:-1)
 ; Output an underline X bytes long
UND(X) ;EP
 Q $$REPEAT^XLFSTR("-",$G(X,$G(IOM,80)))
 ; Truncate a string if > Y bytes long
TRUNC(X,Y) ;EP
 Q $S($L(X)'>Y:X,1:$E(X,1,Y-3)_"...")
 ; Formatting for singular/plural
SNGPLR(RGNUM,RGSNG,RGPLR) ;EP
 N RGZ
 S RGZ=RGSNG?.E1L.E,RGPLR=$G(RGPLR,RGSNG_$S(RGZ:"s",1:"S"))
 Q $S('RGNUM:$S(RGZ:"no ",1:"NO ")_RGPLR,RGNUM=1:"1 "_RGSNG,1:RGNUM_" "_RGPLR)
 ; Convert code to external form from set of codes
SET(RGCODE,RGSET) ;EP
 N RGZ,RGZ1
 F RGZ=1:1:$L(RGSET,";") D  Q:RGZ1'=""
 .S RGZ1=$P(RGSET,";",RGZ),RGZ1=$S($P(RGZ1,":")=RGCODE:$P(RGZ1,":",2),1:"")
 Q RGZ1
 ; Replace each occurrence of RGOLD in RGSTR with RGNEW
SUBST(RGSTR,RGOLD,RGNEW) ;EP
 N RGP,RGL1,RGL2
 S RGNEW=$G(RGNEW),RGP=0,RGL1=$L(RGOLD),RGL2=$L(RGNEW)
 F  S RGP=$F(RGSTR,RGOLD,RGP) Q:'RGP  D
 .S RGSTR=$E(RGSTR,1,RGP-RGL1-1)_RGNEW_$E(RGSTR,RGP,9999)
 .S RGP=RGP-RGL1+RGL2
 Q RGSTR
 ; Trim leading (Y=-1)/trailing (Y=1)/leading & trailing (Y=0) spaces
TRIM(X,Y) ;EP
 N RGZ1,RGZ2
 S Y=+$G(Y),RGZ1=1,RGZ2=$L(X)
 I Y'>0 F RGZ1=1:1 Q:$A(X,RGZ1)'=32
 I Y'<0 F RGZ2=RGZ2:-1 Q:$A(X,RGZ2)'=32
 Q $E(X,RGZ1,RGZ2)
 ; Format a number with commas
FMTNUM(RGNUM) ;EP
 N RGZ,RGZ1,RGZ2,RGZ3
 S:RGNUM<0 RGNUM=-RGNUM,RGZ2="-"
 S RGZ3=RGNUM#1,RGNUM=RGNUM\1
 F RGZ=$L(RGNUM):-3:1 S RGZ1=$E(RGNUM,RGZ-2,RGZ)_$S($D(RGZ1):","_RGZ1,1:"")
 Q $G(RGZ2)_$G(RGZ1)_$S(RGZ3:RGZ3,1:"")
 ; Return true if the result is numeric
ISNUM(X) Q:X=+X 1
 Q $L(X)&(X'=".")&(X?0.N0.1"."0.N)
 ; Convert X to base Y padded to length L
BASE(X,Y,L) ;EP
 Q:(Y<2)!(Y>62) ""
 N RGZ,RGZ1
 S RGZ1="",X=$S(X<0:-X,1:X)
 F  S RGZ=X#Y,X=X\Y,RGZ1=$C($S(RGZ<10:RGZ+48,RGZ<36:RGZ+55,1:RGZ+61))_RGZ1 Q:'X
 Q $S('$G(L):RGZ1,1:$$REPEAT^XLFSTR(0,L-$L(RGZ1))_$E(RGZ1,1,L))
 ; Convert a string to its SOUNDEX equivalent
SOUNDEX(RGVALUE) ;EP
 N RGCODE,RGSOUND,RGPREV,RGCHAR,RGPOS,RGTRANS
 S RGCODE="01230129022455012623019202"
 S RGSOUND=$C($A(RGVALUE)-(RGVALUE?1L.E*32))
 S RGPREV=$E(RGCODE,$A(RGVALUE)-64)
 F RGPOS=2:1 S RGCHAR=$E(RGVALUE,RGPOS) Q:","[RGCHAR  D  Q:$L(RGSOUND)=4
 .Q:RGCHAR'?1A
 .S RGTRANS=$E(RGCODE,$A(RGCHAR)-$S(RGCHAR?1U:64,1:96))
 .Q:RGTRANS=RGPREV!(RGTRANS=9)
 .S RGPREV=RGTRANS
 .S:RGTRANS'=0 RGSOUND=RGSOUND_RGTRANS
 Q $E(RGSOUND_"000",1,4)
 ; Display formatted title
TITLE(RGTTL,RGVER,RGFN) ;EP
 I '$D(IOM) N IOM,IOF S IOM=80,IOF="#"
 S RGVER=$G(RGVER,"1.0")
 S:RGVER RGVER="Version "_RGVER
 U $G(IO,$I)
 W @IOF,$S(IO=IO(0):$C(27,91,55,109),1:""),*13,$$ENTRY^RGUTDT(+$H_","),?(IOM-$L(RGTTL)\2),RGTTL,?(IOM-$L(RGVER)),RGVER,!,$S(IO=IO(0):$C(27,91,109),1:$$UND),!
 W:$D(RGFN) ?(IOM-$L(RGFN)\2),RGFN,!
 Q
 ; Display required header for menus
MNUHDR(PKG,VER) ;EP
 Q:$D(ZTQUEUED)
 Q:$E($G(IOST),1,2)'="C-"
 N X,%ZIS,IORVON,IORVOFF,MNU
 S MNU=$P($G(XQY0),U,2),MNU(0)=$P($G(XQY0),U),VER=$G(VER)
 S X=$$GETPKG($S($L($G(PKG)):PKG,1:MNU(0)))
 I $L(X) D
 .S PKG=$P(X,U,2),X=$P(X,U,3)
 .I $L(X),'$L(VER) S VER=$$VERSION^XPDUTL(X)
 S:VER VER="Version "_VER
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF,!?(IOM-$L(MNU)\2),MNU,!
 Q
 ; Execute menu action, preserving menu headers
MNUEXEC(EXEC,PAUSE) ;EP
 D MNUHDR()
 X EXEC
 R:$G(PAUSE)&'$D(ZTQUEUED) !,"Press ENTER or RETURN to continue...",PAUSE:$G(DTIME,300),!
 Q
 ; Action for editing parameters from menu
MNUPARAM(PARAM) ;EP
 D MNUEXEC("D EDITPAR^XPAREDIT($G(PARAM,$P(XQY0,U)))")
 Q
 ; Action for editing parameter template from menu
MNUTEMPL(TMPL) ;EP
 D MNUEXEC("D TEDH^XPAREDIT($G(TMPL,$P(XQY0,U)),""BA"")")
 Q
 ; Return package reference from namespace
 ; Returns ien^pkg name^pkg namespace
GETPKG(NAME) ;EP
 N PKG,IEN
 S PKG=NAME
 F  S PKG=$O(^DIC(9.4,"C",PKG),-1) Q:$E(NAME,1,$L(PKG))=PKG
 S IEN=$S($L(PKG):+$O(^DIC(9.4,"C",PKG,0)),1:0)
 Q $S(IEN:IEN_U_$P(^DIC(9.4,IEN,0),U)_U_PKG,1:"")
 ; Create a unique 8.3 filename
UFN(Y) ;EP
 N X
 S Y=$E($G(Y),1,3),X=$$BASE($R(100)_$J_$TR($H,","),36,$S($L(Y):8,1:11))_Y
 Q $E(X,1,8)_"."_$E(X,9,11)
 ; Return formatted SSN
SSN(X) ;EP
 Q $S(X="":X,1:$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,12))
 ; Performs security check on patient access
DGSEC(Y) ;EP
 N DIC
 S DIC(0)="E"
 D ^DGSEC
 Q $S(Y<1:0,1:Y)
 ; Displays spinning icon to indicate progress
WORKING(RGST,RGP,RGS) ;EP
 Q:'$D(IO(0))!$D(ZTQUEUED) 0
 N RGZ
 S RGZ(0)=$I,RGS=$G(RGS,"|/-\"),RGST=+$G(RGST)
 S RGST=$S(RGST<0:0,1:RGST#$L(RGS)+1)
 U IO(0)
 W:'$G(RGP) *8,*$S(RGST:$A(RGS,RGST),1:32)
 R *RGZ:0
 U RGZ(0)
 Q RGZ=94
 ; Ask for Y/N response
ASK(RGP,RGD,RGZ) ;EP
 S RGD=$G(RGD,"N")
 S RGZ=$$GETCH(RGP_"? ","YN",,,,RGD)
 S:RGZ="" RGZ=$E(RGD)
 W !
 Q $S(RGZ[U:"",1:RGZ="Y")
 ; Pause for user response
PAUSE(RGP,RGX,RGY) ;EP
 Q $$GETCH($G(RGP,"Press RETURN or ENTER to continue..."),U,.RGX,.RGY)
 ; Single character read
GETCH(RGP,RGV,RGX,RGY,RGT,RGD) ;EP
 N RGZ,RGC
 W:$D(RGX)!$D(RGY) $$XY($G(RGX,$X),$G(RGY,$Y))
 W $G(RGP),$E($G(RGD)_" "),*8
 S RGT=$G(RGT,$G(DTIME,999999)),RGD=$G(RGD,U),RGC=""
 S:$D(RGV) RGV=$$UP^XLFSTR(RGV)_U
 F  D  Q:'$L(RGZ)
 .R RGZ#1:RGT
 .E  S RGC=RGD Q
 .W *8
 .Q:'$L(RGZ)
 .S RGZ=$$UP^XLFSTR(RGZ)
 .I $D(RGV) D
 ..I RGV[RGZ S RGC=RGZ
 ..E  W *7,*32,*8 S RGC=""
 .E  S RGC=RGZ
 W !
 Q RGC
 ; Position cursor
XY(DX,DY) ;EP
 D:$G(IOXY)="" HOME^%ZIS
 S DX=$S(+$G(DX)>0:+DX,1:0),DY=$S(+$G(DY)>0:+DY,1:0),$X=0
 X IOXY
 S $X=DX,$Y=DY
 Q ""
 ; Parameterized calls to date routines
DT(RGD,RGX) ;EP
 N %D,%P,%C,%H,%I,%X,%Y,RGZ
 D DT^DILF($G(RGX),RGD,.RGZ)
 W:$D(RGZ(0)) RGZ(0),!
 Q $G(RGZ,-1)
DTC(X1,X2) ;EP
 N X3
 S X2=$$DTF(X1)+X2,X1=X1\1,X3=X2\1,X2=X2-X3
 S:X2<0 X3=X3-1,X2=X2+1
 Q $$FMADD^XLFDT(X1,X3)+$J($$DTT(X2),0,6)
DTD(X1,X2) ;EP
 Q $$FMDIFF^XLFDT(X1\1,X2\1)+($$DTF(X1)-$$DTF(X2))
DTF(X) S X=X#1*100
 Q X\1*3600+(X*100#100\1*60)+(X*10000#100)/86400
DTT(X) S X=X*86400
 Q X\3600*100+(X#3600/3600*60)/10000
 ; Save buffer to routine
 ; RTN = Routine name
 ; BUF = Buffer containing routine contents (terminal subscript must be 0).
 ; KILL = If true, delete buffer after completion
RTNSAVE(RTN,BUF,KILL) ;
 N XCM,XCN,DIE,X
 S XCN=0,DIE=BUF,X=RTN
 S:$E(DIE,$L(DIE))=")" $E(DIE,$L(DIE))=","
 X ^%ZOSF("SAVE")
 K:$G(KILL) @BUF
 Q
 ; Copy one routine to another
RTNCOPY(SRC,DST) ;
 N BUF,X,Y
 Q:'$L($T(+0^@SRC))
 S BUF=$$TMPGBL^RGUTRPC("RTN")
 F X=1:1 S Y=$T(+X^@SRC) Q:'$L(Y)  S @BUF@(X,0)=Y
 D RTNSAVE(DST,BUF,1)
 Q
 ; Delete a routine
RTNDEL(RTN) ;
 D RTNSAVE(RTN,$$TMPGBL^RGUTRPC("RTN"),1)
 Q
