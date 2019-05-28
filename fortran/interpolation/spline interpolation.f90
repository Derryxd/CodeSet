!Program name: SPLINE 
!Input variables: 
!M: vertical levels to be interpolated 
!N: vertical levels of observed data. 
!X(N): 1-dimensional array storing height or pressure or Ln(p) etc. 
!    of observed data 
!Y(N): 1-dimensional array storing observed data (say temperature) 
!T(M): 1-dimensional array storing height or pressure or Ln(p) etc. 
 !    of levels to be interpolated 
!Output variables: 
!SS(M): 1-dimensional array storing interpolated data (say temperature) 

!***************************************************************** 
!*       THIS SUBROUTINE IS VERTICAL INTERPOLATIONAL PROGRAM.    * 
!***************************************************************** 
SUBROUTINE SPLINE(M,N,X,Y,T,SS,SS1) 
DIMENSION X(N),Y(N),S2(N),H(N),H1(N),B(N),C(N),DELY(N),S3(N),DELSQY(N),T(M),SS(M),SS1(M) 
N1=N-1 
DO I=1,N1 
H(I)=X(I+1)-X(I) 
DELY(I)=(Y(I+1)-Y(I))/H(I) 
enddo
DO I=2,N1 
H1(I)=H(I-1)+H(I) 
B(I)=0.5*H(I-1)/H1(I) 
DELSQY(I)=(DELY(I)-DELY(I-1))/H1(I) 
S2(I)=2.0*DELSQY(I) 
C(I)=3.0*DELSQY(I) 
enddo 
S2(1)=0.0 
S2(N)=0.0 
DO 30 JJ=1,26 
DO 30 I=2,N1 
S2(I)=(C(I)-B(I)*S2(I-1)-(0.5-B(I))*S2(I+1)-S2(I))*1.0717968+S2(I) 
30      CONTINUE 
DO 40 I=1,N1 
40      S3(I)=(S2(I+1)-S2(I))/H(I) 
DO 50 J=1,M 
I=1 
IF((T(J)-X(I)).LE.0.0) GOTO 17 
IF((T(J)-X(N)).LT.0.0) GOTO 57 
GOTO 59 
56      IF((T(J)-X(I)).LT.0.0) GOTO 60 
IF((T(J)-X(I)).EQ.0.0) GOTO 17 
57      I=I+1 
GOTO 56 
59      I=N 
60      I=I-1 
17      HT1=T(J)-X(I) 
HT2=T(J)-X(I+1) 
PROD=HT1*HT2 
DELSQS=(2.0*S2(I)+S2(I+1)+HT1*S3(I))/6.0 
SS(J)=Y(I)+HT1*DELY(I)+PROD*DELSQS 
SS1(J)=DELY(I)+(HT1+HT2)*DELSQS+PROD*S3(I)/6.0 
50      CONTINUE 
RETURN 
END