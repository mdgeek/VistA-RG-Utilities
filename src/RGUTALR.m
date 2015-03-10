RGUTALR ;RI/CBMI/DKM - Send alert to user(s) via kernel or mail;03-Mar-2015 14:24;DKM
 ;;3.0;RG UTILITIES;;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 ; Send an alert.
 ;   XQAMSG = Message to send
 ;   RGUTSR  = A semicolon-delimited list of users to receive alert.
 ;=================================================================
ALERT(XQAMSG,RGUTSR) ;
 N XQA,XQAOPT,XQAFLG,XQAROU,XQADATA,XQAID
 S @$$TRAP^RGUTOS("EXIT^RGUTALR"),RGUTSR=$G(RGUTSR,"*"),XQAMSG=$TR(XQAMSG,U,"~")
 D ENTRY^RGUTUSR(RGUTSR,.XQA),SETUP^XQALERT:$D(XQA)
EXIT Q
 ;=================================================================
 ; Send a mail message
 ;   RGMSG  = Message to send (single node or array)
 ;   XMY    = A semicolon-delimited list (or array) of users
 ;   XMSUB  = Subject line (optional)
 ;   XMDUZ  = DUZ of sender (optional)
 ;=================================================================
MAIL(RGMSG,XMY,XMSUB,XMDUZ) ;
 N XMTEXT
 S:$D(RGMSG)=1 RGMSG(1)=RGMSG
 S XMTEXT="RGMSG(",@$$TRAP^RGUTOS("EXIT^RGUTALR"),XMY=$G(XMY)
 S:$G(XMSUB)="" XMSUB=RGMSG
 S:$G(XMDUZ)="" XMDUZ=$G(DUZ)
 F  Q:'$L(XMY)  S X=$P(XMY,";"),XMY=$P(XMY,";",2,999) S:$L(X) XMY(X)=""
 D ^XMD:$D(XMY)>9
 Q
