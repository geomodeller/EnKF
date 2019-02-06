tic
%% initial setting
disp('Initial setting')

NofRealization = 20; totalRow=[1:NofRealization]'; 
nx=128;ny=128;nz=1; ngrid=nx*ny*nz; dx=50;dy=50;dz=20;
Nofobservedwell=8; 

Atime=[50:50:800]; Ptime=[50:50:2000]; APtime=[800:50:2000];
AIndex=ones(2, size(Atime, 2)); PIndex=ones(2, size(Ptime, 2)); APIndex=ones(2, size(APtime, 2));
NofAtime=size(Atime, 2);

Modelvariable={'Permx'}; Dynamicvariable={'WOPR'};
NofModelvariable=size(Modelvariable, 2); 
NofDataType=size(Dynamicvariable, 2);
filename='logpermx_M100.DAT';

%% make directories for ensemble
disp('make directories for ensemble')

MakeTstep( Atime(1), 'TSTEP.DAT');
for i=1:NofRealization
    mkdir(['EnKF' int2str(i)]);
    for j=1:(NofAtime+1) 
        copyfile('Forward_Simulation.DATA', ['EnKF' int2str(i) '/' int2str(j) '_Forward_Simulation.DATA']);        
    end    
    copyfile('TSTEP.DAT', ['EnKF' int2str(i) '/' 'TSTEP.DAT']); 
    copyfile('SOLUTION.DAT', ['EnKF' int2str(i) '/' 'SOLUTION.DAT']);    
end

for i=1:NofRealization
    mkdir(['ini' int2str(i)]);
    copyfile('Forward_Simulation.DATA', ['ini' int2str(i) '/Forward_Simulation.DATA']);
    copyfile('refTSTEP.DAT', ['ini' int2str(i) '/' 'TSTEP.DAT']);
    copyfile('SOLUTION.DAT', ['ini' int2str(i) '/' 'SOLUTION.DAT']);    
end

mkdir('ref');
copyfile('Forward_Simulation.DATA', 'ref/Forward_Simulation.DATA');
copyfile('refTSTEP.DAT', 'ref/TSTEP.DAT'); 
copyfile('SOLUTION.DAT', 'ref/SOLUTION.DAT');

%% initial simulation
disp('initial simulation')

permxAll = GetParameters(filename, false);
refPermx = permxAll(1:ngrid);
enPermx = permxAll((ngrid+1):ngrid*(NofRealization+1));
for i=1:NofRealization
    SetPermx(i, enPermx, ngrid, ['EnKF' int2str(i) '/PERMX.DAT']);    
    SetPermx(i, enPermx, ngrid, ['ini' int2str(i) '/PERMX.DAT']);
end
SetPermx(1, refPermx, ngrid, 'ref/PERMX.DAT');

% Reference
RunECLIPSE('ref/Forward_Simulation');
refWOPR_A=GetDynamicAssimilation('ref/Forward_Simulation', Atime, AIndex, Nofobservedwell, Ptime);
[refWOPR_P, refWWCT_P, refFOPT_P, refFWPT_P]=GetDynamicPrediction('ref/Forward_Simulation', Ptime, PIndex, Nofobservedwell, Ptime);
refField=[refFOPT_P', refFWPT_P'];
% Ensembles
for i=1:NofRealization
    RunECLIPSE(['ini' int2str(i) '/Forward_Simulation']);
    WOPR_A(i, :)=GetDynamicAssimilation(['ini' int2str(i) '/Forward_Simulation'], Atime, AIndex, Nofobservedwell, Ptime);
    [WOPR_P_INI(i,:), WWCT_P_INI(i,:), FOPT_P_INI(i,:), FWPT_P_INI(i,:)]=GetDynamicPrediction(['ini' int2str(i) '/Forward_Simulation'], Ptime, PIndex, Nofobservedwell, Ptime);
    if mod(i,10)==0
        disp([num2str(i) '%...']);
    end
end


%% assimilation

for i=1:NofAtime
    disp(['now assimilation step_' num2str(i)]);
    %% prediction step
    for j=1:NofRealization
        if i>1    
            enPermx_now=enPermx_(:, i-1);
            SetPermx(j, enPermx_now, ngrid, ['EnKF' int2str(j) '/PERMX.DAT']);
            dos(['eclrun eclipse ' 'EnKF' int2str(j) '/' int2str(i) '_Forward_Simulation > NUL']);            
        else
            RunECLIPSE(['EnKF' int2str(j) '/' int2str(1) '_Forward_Simulation']);
        end
        [WOPR_A_(j,:), WWCT_A_(j,:), FOPT_A_(j), FWPT_A_(j)]=GetDynamicPrediction(['EnKF' int2str(j) '/' int2str(i) '_Forward_Simulation'], Atime(i), AIndex(:, i), Nofobservedwell, 1);
        WOPR_STEP_(j, Nofobservedwell*(i-1)+1:Nofobservedwell*i)=WOPR_A_(j,:);
        WWCT_STEP_(j, Nofobservedwell*(i-1)+1:Nofobservedwell*i)=WWCT_A_(j,:);
        FOPT_STEP_(j, i)=FOPT_A_(j);
        FWPT_STEP_(j, i)=FWPT_A_(j);
        
        if mod(j,10)==0
            disp([num2str(j) '%...']);
        end
    end
    
    %% assimilation step
    for j=1:Nofobservedwell
        OBS(1,j)=refWOPR_A(1, (NofAtime*NofDataType)*(j-1)+i);        
    end    
   
    MakeTstep( Atime(i), 'TSTEP.DAT');     
    if i>1
        EnMean(:, i)=GetMean(Parameters_, ngrid, WOPR_A_, 'Forward_Simulation', Atime(i), AIndex(:, i), Nofobservedwell, 1);
        [enPermx_(:, i),Cy(i),Cy_square(i)]=enkf(OBS', WOPR_A_, NofRealization, Atime(i), Parameters_, nx, ny, nz, Nofobservedwell, EnMean(:, i));
    else
        EnMean(:, 1)=GetMean(enPermx, ngrid, WOPR_A_, 'Forward_Simulation', Atime(1), AIndex(:, 1), Nofobservedwell, 1);
        [enPermx_(:, 1),Cy(i),Cy_square(i)]=enkf(OBS', WOPR_A_, NofRealization, Atime(1), enPermx, nx, ny, nz, Nofobservedwell, EnMean(:, 1));
    end
    Parameters_=enPermx_(:, i);
    
    %% preparation for next prediction step    
    for j=1:NofRealization
        if i < NofAtime
            MakeTstep( Atime(i+1)-Atime(i),  ['EnKF' int2str(j) '/TSTEP.DAT']); % TSTEP
        end
        MakeSolution(i,  'Forward_Simulation', ['EnKF' int2str(j) '/SOLUTION.DAT']); % SOL.
    end   
end

%% Prediction for Total time
i=size(Atime,2);
disp('Prediction for Total time...')
for j=1:NofRealization
    MakeTstep_P('40*50',  ['EnKF' int2str(j) '/TSTEP.DAT']); % TSTEP
    copyfile('SOLUTION.DAT', ['EnKF' int2str(j) '/SOLUTION.DAT']); % SOL.
end

for j=1:NofRealization
    enPermx_now=enPermx_(:, i);
    SetPermx(j, enPermx_now, ngrid, ['EnKF' int2str(j) '/PERMX.DAT']);
    dos(['eclrun eclipse ' 'EnKF' int2str(j) '/' int2str(i+1) '_Forward_Simulation > NUL']);

    [WOPR_P(j,:), WWCT_P(j,:), FOPT_P(j,:), FWPT_P(j,:)]=GetDynamicPrediction(['EnKF' int2str(j) '/' int2str(i+1) '_Forward_Simulation'], Ptime, PIndex, Nofobservedwell, Ptime);
    if mod(j,10)==0
        disp([num2str(j) '%...']);
    end
end
toc
save EnKF_result
%% ¸¶Áö¸· È½¼ö
i=7;
% Atime=[150, 300, 450, 600, 750, 900, 1050];AIndex=ones(2, size(Atime, 2));
% EnMean_last=GetMean(Parameters_, ngrid, [WOPR_P(:,21) WOPR_P(:,61) WOPR_P(:,101) WOPR_P(:,141) WOPR_P(:,181) WOPR_P(:,221) WOPR_P(:,261) WOPR_P(:,301)], 'Forward_Simulation', Atime(i), AIndex(:, i), Nofobservedwell, 1);
% [Cy_final, Cy_final_squre]=Cy_fin([WOPR_P(:,21) WOPR_P(:,61) WOPR_P(:,101) WOPR_P(:,141) WOPR_P(:,181) WOPR_P(:,221) WOPR_P(:,261) WOPR_P(:,301)], NofRealization, Atime(1), Parameters_,  nx, ny, nz, Nofobservedwell, EnMean_last);
save EnKF_result
%%