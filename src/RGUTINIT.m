RGUTINIT ;RI/CBMI/DKM - Platform specific inits;01-Apr-2015 08:59;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 156
 ;;
 ;=================================================================
PRE N PKG,FDA
 S PKG=$$LKPKG^XPDUTL("RGUT")
 Q:'PKG
 Q:$P(^DIC(9.4,PKG,0),U)="RG UTILITIES"
 S FDA(9.4,PKG_",",.01)="RG UTILITIES"
 D FILE^DIE(,"FDA")
 Q
POST N RGOS,RGH,X
 S U="^",X="ERROR^RGUTINIT",@^%ZOSF("TRAP"),RGOS=$P(^%ZOSF("OS"),U,2)
 I 'RGOS D
 .D HOME^%ZIS,TITLE^RGUT("Platform-Specific Inits",1.6)
 .S RGH(1)="Enter the name of this MUMPS environment for the RG-namespace"
 .S RGH(2)="platform-specific initialization process."
 .S RGOS=$$ENTRY^RGUTLKP("^DD(""OS"")","UX","Operating System: ","B","*","","",0,5,"","","HELP(.RGH)")
 .W !!
 D:RGOS>0 INIT(RGOS)
 Q
INIT(RGOS) ;
 N I,X,Y,Z,N,RGOSZ
 S RGOSZ=$$OSRTN($G(RGOS))
 S:$L(RGOSZ) @("RGOSZ="_RGOSZ)
 I '$L(RGOSZ) D  Q
 .X "ZL RGUTOS1 ZS RGUTOS"
 .D MES("Init not found for specified OS. Will use generic init.")
 S I=0,N="RGUT"
 K ^TMP(N,$J)
 F Z=0,1 F X=$S(Z:3,1:1):1 S Y=$T(+X^@$S(Z:RGOSZ,1:"RGUTIN0")) Q:Y=""  S I=I+1,^TMP(N,$J,I,0)=Y
 S $P(^TMP(N,$J,1,0),";")="RGUTOS "
 D SAVE^RGUTRTN("RGUTOS",$NA(^TMP(N,$J)),1)
 F Z=1:1 S X=$P($T(DEVICE+Z),";;",2,99) Q:X=""  S ^TMP(N,$J,Z)=$$MSG^RGUT(X,"|")
 I $$ENTRY^RGUTIMP($NA(^TMP(N,$J))) D
 .D MES("Unable to install RGUT HFS DEVICE.")
 W !!,"Initialization completed for "_$P(^DD("OS",RGOS,0),"^")_" operating system.",!!
 K ^TMP(N,$J)
 Q
OSRTN(X) Q $P($T(@("OS"_X)),";",4,99)
OS8 ;;MSM;$S($ZV["UNIX":"RGUTIN58",1:"RGUTIN8")
OS16 ;;DSM;"RGUTIN16"
OS18 ;;Cache;$S($ZV["UNIX":"RGUTIN68",1:"RGUTIN18")
OS19 ;;GT.M;"RGUTIN19"
MES(X) D BMES^XPDUTL(X)
 Q
ERROR D MES("An error has occurred during initialization.")
 Q
 ; Return $I for HFS device
HFS() Q $S(RGOS=16:"TEMP.TMP",RGOS=8:51,RGOS=18:"NUL",1:"@")
DEVICE ; Device setup
 ;;:3.5
 ;;.NAME: RGUT HFS DEVICE
 ;;.LOCATION OF TERMINAL: HFS
 ;;.$I: |$$HFS^RGUTINIT|
 ;;.SIGN-ON/SYSTEM DEVICE: N
 ;;.TYPE: HFS
 ;;.SUBTYPE: P-OTHER
 ;;.ASK DEVICE: N
 ;;.ASK PARAMETERS: N
 ;;.ASK HOST FILE: N
 ;;.ASK HFS I/O OPERATION: N
 ;;
