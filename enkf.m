function [ Para_, Cy,Cy2] = enkf( refD, eclDynamic , Nofrealization, time, Para, nx, ny, nz, Nofobservedwell,  En_mean)

ECL.numOfStaticData=nx*ny*nz;
ES.enSize=Nofrealization;
ECL.numOfOBS=Nofobservedwell;
ECL.sizeOfTSTEP=size(time, 2);
ECL.TotalNumOfOBS=ECL.numOfOBS  * ECL.sizeOfTSTEP;
ES.refOBS=repmat(refD,1,ES.enSize);
ES.numOfStateVector = ECL.TotalNumOfOBS + ECL.numOfStaticData;

%make matrix, Cd
stdErrOfDynamic = 0.01; 
sizeOfCd = ECL.numOfOBS*ECL.sizeOfTSTEP;
ES.Cd(sizeOfCd, sizeOfCd) = 0.;
for i=1:sizeOfCd
    ES.Cd(i,i)=stdErrOfDynamic^2;
end

%make matrix, H
ES.H(ECL.TotalNumOfOBS, ES.numOfStateVector) = 0.;
for i=1:size(ES.H,1)
    ES.H(i, ES.numOfStateVector - (ECL.TotalNumOfOBS - i)) = 1.;
end

%make matrix, En.
logPara=log(Para(1:ES.enSize*ECL.numOfStaticData));
logenM=reshape(logPara, ECL.numOfStaticData, ES.enSize);
enD=eclDynamic';
ES.En = [logenM; enD];
ES.En_Mean=En_mean;
En_Mean =repmat(ES.En_Mean, 1, ES.enSize);

%make matrix, H_Le
ES.Le = 1. / sqrt(ES.enSize - 1) * (ES.En - En_Mean);
H_Le = ES.H*ES.Le;

%get Kalman gain, K
ES.K = ES.Le * H_Le' * inv(H_Le*H_Le' + ES.Cd);

%add stdErroOfDynamic to refOBS
for i=1:ECL.TotalNumOfOBS
    for j=1:ES.enSize
        ES.refOBS(i,j)=ES.refOBS(i,j)+normrnd(0, stdErrOfDynamic);
    end
end

%get assimilated En
ES.En_ = ES.En + ES.K * (ES.refOBS - ES.H * ES.En);

%get updated enM
logenM_=ES.En_(1:ECL.numOfStaticData, 1:ES.enSize);
logPara_=reshape(logenM_, ECL.numOfStaticData*ES.enSize,1);
Para_=exp(logPara_);
Cy=norm(ES.Le,1);
Cy2=norm(ES.Le,2);
end

