RGUTIN0 ;RI/CBMI/DKM - Platform-dependent operations;01-Apr-2015 09:11;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 ; Return version #
VER() Q $P($T(+2),";",3)
CVTFN(RGFIL,RGROOT) ;
 N RGZ,RGZ1,RGD
 S RGD=$$DIRDLM,RGROOT=$G(RGROOT)
 S:$E(RGROOT,$L(RGROOT))=$E(RGD,3) RGROOT=$E(RGROOT,1,$L(RGROOT)-1)
 S RGZ=$L(RGFIL,"/"),RGZ1=$P(RGFIL,"/",1,RGZ-1),RGFIL=$P(RGFIL,"/",RGZ)
 S:$L(RGZ1) RGROOT=RGROOT_$E(RGD,$S($L(RGROOT):2,1:1))_$TR(RGZ1,"/.-",$E(RGD,2))
 Q RGROOT_$S($L(RGROOT):$E(RGD,3),1:"")_RGFIL
 ; Set right margin
RM(X) ;EP
 X ^%ZOSF("RM")
 Q
ETRAP() Q $$NEWERR^%ZTER
 ; Return UCI
UCI(P) N Y
 X ^%ZOSF("UCI")
 Q $S($G(P):$P(Y,",",P),1:Y)
 ; Open a host file
OPENX(X1,X2) ;EP
 D OPEN(.X1,.X2)
 Q X1
