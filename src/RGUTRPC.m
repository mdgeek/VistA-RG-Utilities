RGUTRPC ;RI/CBMI/DKM - RPC Encapsulations for RGUT routines ;03-Mar-2015 14:24;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 ; RPC: RGUTDIC
DIC(RGDATA,RGBM,RGCMD,RGARG) ;
 S RGDATA(0)=$$ENTRY^RGUTDIC(RGBM,RGCMD)
 Q
 ; RPC: RGUTSTX
MSYNTAX(RGDATA,RGCODE,RGOPT) ;
 S RGDATA=$$ENTRY^RGUTSTX(RGCODE,.RGOPT)
 Q
 ; RPC: Return a group of entries from a file
 ; RGFN   = File #
 ; RGFROM = Starting entry (default is null)
 ; RGDIR  = Direction (default = 1)
 ; RGSCN  = Screening logic (optional)
 ; RGMAX  = Maximum entries (default = 20)
 ; RGXRF  = Cross reference (default = B)
FILGET(RGDATA,RGFN,RGFROM,RGDIR,RGSCN,RGMAX,RGXRF) ;
 N RGIEN,RGGBL,RGTOT,Y
 S RGFROM=$G(RGFROM),RGDIR=$S($G(RGDIR)<0:-1,1:1),RGMAX=$G(RGMAX,20),RGXRF=$G(RGXRF,"B"),RGSCN=$G(RGSCN),RGGBL=$$ROOT^DILFD(RGFN,,1),RGTOT=0
 Q:'$L(RGGBL)
 F  Q:RGTOT'<RGMAX  S RGFROM=$O(@RGGBL@(RGXRF,RGFROM),RGDIR),RGIEN=0 Q:'$L(RGFROM)  D
 .F  S RGIEN=$O(@RGGBL@(RGXRF,RGFROM,RGIEN)) Q:'RGIEN  D
 ..Q:'$D(@RGGBL@(RGIEN,0))
 ..I $L(RGSCN) S Y=RGIEN X RGSCN E  Q
 ..S RGTOT=RGTOT+1,@RGDATA@(RGTOT)=RGIEN_U_RGFROM
 Q
 ; RPC: Show all or selected entries for a file
 ; RGGBL = File # or closed global reference
 ; RGIEN = Optional list of IENs to retrieve (default=ALL)
 ;          May be passed as single IEN or array with IENs as subscripts
FILENT(RGDATA,RGGBL,RGIEN) ;
 N RGG,RGX
 S:RGGBL=+RGGBL RGGBL=$$ROOT^DILFD(RGGBL,,1)
 S RGDATA=$$TMPGBL
 Q:'$L(RGGBL)
 S:$G(RGIEN) RGIEN(+RGIEN)=""
 S RGG=$S($D(RGIEN):"RGIEN",1:RGGBL),RGIEN=0
 F  S RGIEN=$O(@RGG@(RGIEN)) Q:'RGIEN  D
 .S RGX=$P($G(@RGGBL@(RGIEN,0)),U)
 .S:$L(RGX) @RGDATA@(RGIEN)=RGIEN_U_RGX
 Q
 ; RPC: Show IEN of next/previous entry in a file
FILNXT(RGDATA,RGGBL,RGIEN) ;
 N RGD
 S:RGGBL=+RGGBL RGGBL=$$ROOT^DILFD(RGGBL,,1)
 I RGIEN<0 S RGIEN=-RGIEN,RGD=-1
 E  S RGD=1
 S RGDATA=+$O(@RGGBL@(RGIEN),RGD)
 Q
 ; RPC: Convert date input to FM format
STRTODAT(DATA,VAL,FMT) ;
 N %DT,X,Y
 I VAL'["@",VAL[" " S VAL=$TR(VAL," ","@")
 I VAL["@",$TR($P(VAL,"@",2),":0")="" S $P(VAL,"@",2)="00:00:01"
 S %DT=$G(FMT,"TS"),X=VAL
 D ^%DT
 S DATA=$S(Y>0:Y,1:"")
 Q
 ; Return reference to temp global
TMPGBL(X) ;EP
 K ^TMP("RGUTRPC"_$G(X),$J) Q $NA(^($J))
 ; Register/unregister RPCs within a given namespace to a context
REGNMSP(NMSP,CTX,DEL) ;EP
 N RPC,IEN,LEN
 S LEN=$L(NMSP),CTX=+$$GETOPT(CTX)
 I $G(DEL) D
 .S IEN=0
 .F  S IEN=$O(^DIC(19,CTX,"RPC","B",IEN)) Q:'IEN  D
 ..I $E($G(^XWB(8994,IEN,0)),1,LEN)=NMSP,$$REGRPC(IEN,CTX,1)
 E  D
 .Q:LEN<2
 .S RPC=NMSP
 .F  D:$L(RPC)  S RPC=$O(^XWB(8994,"B",RPC)) Q:NMSP'=$E(RPC,1,LEN)
 ..F IEN=0:0 S IEN=$O(^XWB(8994,"B",RPC,IEN)) Q:'IEN  I $$REGRPC(IEN,.CTX)
 Q
 ; Register/unregister an RPC to/from a context
 ; RPC = IEN or name of RPC
 ; CTX = IEN or name of context
 ; DEL = If nonzero, the RPC is unregistered (defaults to 0)
 ; Returns -1 if already registered; 0 if failed; 1 if succeeded
REGRPC(RPC,CTX,DEL) ;EP
 S RPC=+$$GETRPC(RPC)
 Q $S(RPC<1:0,1:$$REGMULT(19.05,"RPC",RPC,.CTX,.DEL))
 ; Add/remove a context to/from the ITEM multiple of another context.
REGCTX(SRC,DST,DEL) ;EP
 S SRC=+$$GETOPT(SRC)
 Q $S('SRC:0,1:$$REGMULT(19.01,10,SRC,.DST,.DEL))
 ; Add/delete an entry to/from a specified OPTION multiple.
 ; SFN = Subfile #
 ; NOD = Subnode for multiple
 ; ITM = Item IEN to add
 ; CTX = Option to add to
 ; DEL = Delete flag (optional)
REGMULT(SFN,NOD,ITM,CTX,DEL) ;
 N FDA,IEN
 S CTX=+$$GETOPT(CTX)
 S DEL=+$G(DEL)
 S IEN=+$O(^DIC(19,CTX,NOD,"B",ITM,0))
 Q:'IEN=DEL -1
 K ^TMP("DIERR",$J)
 I DEL S FDA(SFN,IEN_","_CTX_",",.01)="@"
 E  S FDA(SFN,"+1,"_CTX_",",.01)=ITM
 D UPDATE^DIE("","FDA")
 S FDA='$D(^TMP("DIERR",$J)) K ^($J)
 Q FDA
 ; Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
REGPROT(P,C,ERR) ;EP
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 Q:$Q $G(ERR)=""
 Q
 ; Remove nonexistent RPCs from context
CLNRPC(CTX) ;EP
 N IEN
 S CTX=+$$GETOPT(CTX)
 F IEN=0:0 S IEN=$O(^DIC(19,CTX,"RPC","B",IEN)) Q:'IEN  D:'$D(^XWB(8994,IEN)) REGRPC(IEN,CTX,1)
 Q
 ; Return IEN of option
GETOPT(X) ;EP
 N Y
 Q:X=+X X
 S Y=$$FIND1^DIC(19,"","X",X)
 W:'Y "Cannot find option "_X,!!
 Q Y
 ; Return IEN of RPC
GETRPC(X) ;EP
 N Y
 Q:X=+X X
 S Y=$$FIND1^DIC(8994,"","X",X)
 W:'Y "Cannot find RPC "_X,!!
 Q Y
