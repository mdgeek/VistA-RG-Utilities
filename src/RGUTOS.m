RGUTOS ;RI/CBMI/DKM - Platform-dependent operations;01-Apr-2015 09:11;DKM
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
 ;;
 ;=================================================================
 ; Open a host file
OPEN(X1,X2) ;EP
 O X1:$S("Rr"[$G(X2):"RS","Ww"[X2:"WNS","Bb"[X2:"RF",1:""):0
 E  ZT "NOPEN"
 U X1
 S ^TMP("RGUTHFS",$J,X1)=""
 Q
 ; Close a host file
CLOSE(X) ;EP
 C X
 K ^TMP("RGUTHFS",$J,X)
 Q
 ; Close all open host files
CLOSEALL ;EP
 N Z
 S Z=""
 F  S Z=$O(^TMP("RGUTHFS",$J,Z)) Q:Z=""  C Z
 K ^TMP("RGUTHFS",$J)
 Q
EOF ZT:$ZA=-1 "ENDOFFILE"
 Q
EOFERR() Q:$ZE["ENDOFFILE"
 ; Read a line of data
READ(X,Y) ;EP
 N $ET
 S $ET="",$ZT="READX"
 U $G(Y,$I)
 Q:$ZEOF 1
 R X:5
 Q:$T 0
READX Q 1
 ; Delete a host file
DELETE(X) ;EP
 S X=$ZF(-1,"rm """_X_"""")
 Q
 ; Rename a host file
RENAME(X1,X2) ;EP
 S X1=$ZF(-1,"mv """_X1_""" """_X2_"""")
 Q
 ; Make a directory
MKDIR(X) S X='$ZF(-1,"mkdir -p "_X)
 Q:$Q X
 Q
 ; Generate directory listing
DIR(X1,X2,X3) ;EP
 N Z,Z1,FDLM
 S FDLM=$E($$DIRDLM,1)
 S X3=$G(X3,$NA(^UTILITY("DIR",$J)))
 K @X3
 S:'$G(X2) X2=9999999999
 F Z=1:1:X2 S Z1=$ZSEARCH(X1),X1="" Q:Z1=""  D
 .S Z1=$P(Z1,FDLM,$L(Z1,FDLM))
 .S:$TR(Z1,".")'="" @X3@(Z1)=""
 Q
 ; Return path delimiters
DIRDLM() ;EP
 Q "///"
 ; Return default working directory
DEFDIR(X) ;EP
 N FDLM
 S FDLM=$E($$DIRDLM,1)
 S X=$G(X,$P($G(^XTV(8989.3,1,"DEV")),U))
 S:$E(X,$L(X))'=FDLM X=X_FDLM
 Q X
 ; Parse current error
ERR(X1,X2,X3) ;EP
 S X1=$E($P($ZE,">"),2,99),X2=$P($P($ZE,">",2),":"),X3=X1
 S:X2["*" X2=""
 S:$E(X1)="Z" X3=$E(X1,2,99),X1="ZTRAP"
 Q
 ; Raise an exception
RAISE(X) ;EP
 ZT $G(X)
 ; Set error trap
TRAP(X) ;EP
 Q "$ZT="""_$G(X)_""""
 ; Return size of a file
SIZE(X) ;EP
 Q 0
 ; Return free disk space
FREE(X) ;EP
 Q 0
 ; Return host ip address
HOSTIP() ;EP
 Q $P($P($ZU(131,1),","),":",2)
 ; Return host name
HOSTNAME() ;EP
 Q $P($P($ZU(131,1),","),":")
 ; Return client ip address
CLIENTIP() ;EP
 N IP,$ET
 S $ET="S $EC=""""",IP=$ZU(111,0)
 Q $A(IP,1)_"."_$A(IP,2)_"."_$A(IP,3)_"."_$A(IP,4)
