RGUTIN19 ;RI/CBMI/DKM - Inits for GT.M (Unix);06-Mar-2015 08:46;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 156
 ;;
 ;=================================================================
 ; Open a host file
OPEN(X1,X2) ;EP
 O X1:@($S("Rr"[$G(X2):"readonly","Ww"[X2:"newversion","Bb"[X2:"stream",1:""))
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
EOF ZM:$ZEOF 150340312
 Q
EOFERR() Q $ZT["IOEOF"
 ; Read a line of data
READ(X,Y) ;EP
 N $ET
 S $ET="",$ZT="G READX"
 U $G(Y,$I)
 Q:$ZEOF 1
 R X:5
 Q:$T 0
READX Q 1
 ; Delete a host file
DELETE(X) ;EP
 O X:(exception="G DELX")
 C X:(delete)
DELX Q
 ; Rename a host file
RENAME(X1,X2) ;EP
 O X1
 C X1:(rename=X2)
 Q
 ; Generate directory listing
DIR(X1,X2,X3) ;EP
 N Z,Z1,FDLM
 S FDLM=$E($$DIRDLM,1)
 S X3=$G(X3,$NA(^UTILITY("DIR",$J)))
 K @X3
 S:'$G(X2) X2=99999999
 F Z=1:1:X2 S Z1=$ZSEARCH(X1) Q:Z1=""  D
 .S Z1=$ZPARSE(Z1,"NAME")_$ZPARSE(Z1,"TYPE")
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
 S X1=$ZSTATUS,X2=$P(X1,",",2),X3=$P(X1,",",4),X1=$P($P(X1,",",3),"-",3)
 Q
 ; Raise an exception
RAISE(X) ;EP
 ZM 150342768:$G(X)
 ; Set error trap
TRAP(X) ;EP
 S $ZYERROR="ZTRAP^RGUTOS"
 Q "$ZT="""_$S($D(X):"G "_X,1:"")_""""
ZTRAP S $ZE=$ZSTATUS
 Q
 ; Return size of a file
SIZE(X) ;EP
 Q 0
 ; Return free disk space
FREE(X) ;EP
 Q 0
 ; Return host ip address
HOSTIP() ;EP
 Q ""
 ; Return host name
HOSTNAME() ;EP
 Q ""
 ; Return client ip address
CLIENTIP() ;EP
 Q ""
