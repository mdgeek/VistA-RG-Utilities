RGUTRPRT ;RI/CBMI/DKM - Routine Pretty Print Program ;03-Mar-2015 14:24;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 N R,C,D,P,N,M,L,X,Y,B,W,Z,S,A,F,T,Q
 D HOME^%ZIS,TITLE^RGUT("Routine Pretty Print")
 X ^%ZOSF("RSEL")
 I $O(^UTILITY($J,0))="" W "No routines selected.",!! K ^UTILITY($J) Q
 D ^%ZIS
 Q:POP
 X ^%ZOSF("UCI")
 S A=Y,R=0,C="     >>> ",W=IOM-$L(C)-1,M=$L(C)+1,B=$$UND^RGUT(W),T=$E(IOST,1,2)="C-",F=$S(T:IOF,1:""""""),Q=0
 F  S R=$O(^UTILITY($J,R)) Q:R=""  D
 .I IO'=IO(0) U IO(0) W !,"Printing "_R_"..."
 .U IO
 .S D=$$ENTRY^RGUTDT($H),P=0,$Y=IOSL,S=0
 .X "ZL @R F N=1:1 S L=$T(+N) Q:'$L(L)  S ^UTILITY($J,R,N)=L,S=S+$L(L)+2"
 .S S="("_$$FMTNUM^RGUT(S)_" bytes)"
 .F N=0:0 S N=$O(^UTILITY($J,R,N)) Q:'N  D  Q:Q
 ..S L=^(N),X=$P(L," "),L=X_$E("        ",$L(X)+1,8)_" "_$P(L," ",2,999),Z=""
 ..F  Q:L=""!Q  D
 ...S X=$E(L,1,W),L=$E(L,W+1,999)
 ...D:IOSL-2<$Y HDR
 ...Q:Q
 ...W Z,?M,X,!
 ...S Z=C
 K ^UTILITY($J)
 D ^%ZISC
 Q
HDR I P,T R "Press enter to continue...",Q:$G(DTIME,300) S Q=Q["^"!'$T Q:Q
 S P=P+1,$Y=0
 W @F,!?M,A,$$CTR(R),$$RJ("Page "_P),!
 W ?M,$G(^DD("SITE")),$$CTR(S),$$RJ(D),!
 W ?M,B,!!
 S:P=1 F=IOF
 Q
CTR(X) W ?(IOM-$L(X)\2+M),X
 Q ""
RJ(X) W ?(IOM-$L(X)),X
 Q ""
