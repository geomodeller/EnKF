function [ EnMean ] = GetMean(Parameters, ngrid, Dynamics, eclDataFile, Atime, AIndex, Nofobservedwell, Rtime)

[Nofrealization, Nofparameters]=size(Parameters);
Nofrealization=Nofrealization/ngrid;
Nofdynamic=size(Dynamics, 2);

for i=1:Nofparameters
    enM((i-1)*ngrid+1:i*ngrid,1:Nofrealization)=reshape(Parameters(:,i), ngrid, Nofrealization);
end
enM(1:1*ngrid, 1:Nofrealization)=log(enM(1:1*ngrid, 1:Nofrealization)); 
enD=Dynamics';
En=[enM; enD];

EnMean=mean(En, 2);
permx=EnMean(1:ngrid);
SetPermx(1, exp(permx), ngrid, 'PERMX.DAT');
RunECLIPSE(eclDataFile);
WOPR_A=GetDynamicAssimilation(eclDataFile, Atime, AIndex, Nofobservedwell, Rtime);

EnMean( Nofparameters*ngrid+1: Nofparameters*ngrid+Nofdynamic)=WOPR_A';
end