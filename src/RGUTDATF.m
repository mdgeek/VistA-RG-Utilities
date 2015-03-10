RGUTDATF ;RI/CBMI/DKM - Date Formatter;03-Mar-2015 14:24;DKM
 ;;3.0;RG UTILITIES;;Feb 20, 2015;Build 98
 ;;1.0;SERIALIZATION FRAMEWORK;;14-March-2014;Build 1
 ; DATE = FM date/time
 ; FMT = Date format (follows Java spec)
FMTDATE(DATE,FMT) ;
 N X,C,I,E,Y,D,L
 S D=DATE+17000000*1000000000,(C,E,X)="",L=0
 F I=1:1:$L(FMT) D
 .S C=$E(FMT,I)
 .I C="'" D
 ..I $E(FMT,I+1)=C S I=I+1
 ..E  S L='L,C=""
 .I 'L,$L(C),"GyYMwWDdFEuaHkKhmsSzZX"[C D
 ..I $E(E)=C S E=E_C Q
 ..D FLUSH
 ..S E=C
 .E  D FLUSH(C)
 D FLUSH
 Q X
FLUSH(C) S:$L(E) X=X_$$FMT(E),E=""
 S:$D(C) X=X_C
 Q
PAD(V,L) N X
 S V=+V,P=L-$L(V)
 S:P>0 X="",$P(X,0,P+1)=V
 Q $G(X,V)
FMT(E) N L
 S L=$L(E)
 Q $$@("FMT"_$E(E))
 ; Era designator
FMTG() Q "AD"
 ; Year
FMTy() Q $$PAD($E(D,$S(L=2:3,1:1),4),L)
 ; Week year
FMTY() Q $$FMTy
 ; Month in year
FMTM() N M
 S M=+$E(D,5,6)
 Q:L<3 $$PAD(M,L)
 S M=$P("January^February^March^April^May^June^July^August^September^October^November^December",U,M)
 Q $S(L=3:$E(M,1,L),1:M)
 ; Week in year
FMTw() Q $$PAD($$FMTD-1\7+1,L)
 ; Week in month
FMTW() Q $$PAD($E(D,7,8)-1\7+1,L)
 ; Day in year
FMTD() Q $$PAD($$FMDIFF^XLFDT(DATE,DATE\10000*10000+101)+1,L)
 ; Day in month
FMTd() Q $$PAD($E(D,7,8),L)
 ; Day of week in month
FMTF() Q ""
 ; Day name in week
FMTE() N W
 S W=$$DOW^XLFDT(DATE)
 Q $S(L<4:$E(W,1,3),1:W)
 ; Day number of week (1=Monday...7=Sunday)
FMTu() N N
 S N=$$DOW^XLFDT(DATE,1)
 Q $$PAD($S(N=0:7,1:N),L)
 ; AM/PM marker
FMTa() Q $S($E(DATE,9,10)<12:"AM",1:"PM")
 ; Hour in day (0-23)
FMTH() Q $$PAD($E(D,9,10),L)
 ; Hour in day (1-24)
FMTk() Q $$PAD($E(D,9,10),L)
 ; Hour in AM/PM (0-11)
FMTK() N H
 S H=+$E(D,9,10)
 Q $$PAD($S(H=12:0,H=24:0,H>12:H-12,1:H),L)
 ; Hour in AM/PM (1-12)
FMTh() N H
 S H=+$E(D,9,10)
 Q $$PAD($S(H>12:H-12,1:H),L)
 ; Minute in hour
FMTm() Q $$PAD($E(D,11,12),L)
 ; Second in minute
FMTs() Q $$PAD($E(D,13,14),L)
 ; Millisecond
FMTS() Q $$PAD($E(D,15,17),L)
 ; Time zone (general)
FMTz() N TZ
 S TZ=$G(^XMB("TIMEZONE"))
 I $L(TZ),L>3 D
 .S TZ=$O(^XMB(4.4,"B",TZ,0)),TZ=$P($G(^XMB(4.4,+TZ,0)),U,2)
 .S:$L(TZ) TZ=$$TITLE^XLFSTR(TZ_" TIME")
 Q TZ
 ; Time zone (RFC 822)
FMTZ() Q $$TZ^XLFDT
 ; Time zone (ISO 8601)
FMTX() N TZ
 S TZ=$$TZ^XLFDT
 Q $S(L=1:$E(TZ,1,3),L=2:$E(TZ,1,5),1:$E(TZ,1,3)_":"_$E(TZ,4,5))
