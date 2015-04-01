RGUTRTN ;RI/CBMI/DKM - Routine management utilities;01-Apr-2015 09:22;DKM
 ;;3.0;RG UTILITIES;**1**;Mar 20, 2007;Build 98
 ;;
 ;=================================================================
 ; Save buffer to routine
 ; RTN = Routine name
 ; BUF = Buffer containing routine contents (terminal subscript must be 0).
 ; KILL = If true, delete buffer after completion
SAVE(RTN,BUF,KILL) ;
 N XCM,XCN,DIE,X
 S XCN=0,DIE=BUF,X=RTN
 S:$E(DIE,$L(DIE))=")" $E(DIE,$L(DIE))=","
 X ^%ZOSF("SAVE")
 K:$G(KILL) @BUF
 Q
 ; Copy one routine to another
 ; SRC = Source routine
 ; DST = Destination routine
COPY(SRC,DST) ;
 N BUF,X,Y
 Q:'$L($T(+0^@SRC))
 S BUF=$$TMPGBL^RGUTRPC("RTN")
 F X=1:1 S Y=$T(+X^@SRC) Q:'$L(Y)  S @BUF@(X,0)=Y
 D SAVE(DST,BUF,1)
 Q
 ; Delete a routine
 ; RTN = Routine to delete
DELETE(RTN) ;
 D SAVE(RTN,$$TMPGBL^RGUTRPC("RTN"),1)
 Q
 ; Test for the presence of a routine or routine and tag
 ; RTN = Routine name with or without a tag.
TEST(RTN) ;
 N TAG,X
 S:RTN[U TAG=$P(RTN,U),RTN=$P(RTN,U,2)
 Q:'$L(RTN)!(RTN'?.1"%"1.AN) 0
 S X=RTN
 X ^%ZOSF("TEST")
 Q $S('$T:0,$G(TAG)="":1,TAG'?.1"%"1.AN:0,1:$T(@TAG^@RTN)'="")
