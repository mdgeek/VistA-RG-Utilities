RGUTREG ;RI/CBMI/DKM - Various registration actions ;03-Mar-2015 14:24;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 ; Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
REGPROT(P,C,ERR) ;
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
