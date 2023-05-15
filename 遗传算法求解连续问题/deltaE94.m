function DE94= deltaE94(Labstd, Labsample)

K1=0.045;
K2=0.015;

KC=1;
KH=1;
KL=1;

C1=sqrt(Labstd(:,2).^2 + Labstd(:,3).^2);
C2=sqrt(Labsample(:,2).^2 + Labsample(:,3).^2);

SL=1;
SC=1+K1*C1;
SH=1+K2*C1;

DL=Labstd(:,1)-Labsample(:,1);
Da=Labstd(:,2)-Labsample(:,2);
Db=Labstd(:,3)-Labsample(:,3);
DC=C1-C2;
DH=sqrt(abs(Da.^2 + Db.^2 - DC.^2));

DE94 = sqrt( (DL./(KL*SL)).^2 + (DC./(KC*SC)).^2 + (DH./(KH*SH)).^2 );

