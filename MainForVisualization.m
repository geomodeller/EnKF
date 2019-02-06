% %%%%%%%%% visulization %%%%%%%%%%
% i=size(Atime,2);
% % i=10;
% %% Make Directody
% if ~exist('Result')
% mkdir('Result');
% end
% 
% %% Perm Field
% 
% tmp_log=log(refPermx);
% max_num=floor(max(tmp_log))+3;
% min_num=int16(min(tmp_log))-1;
% figure; DrawParameter(tmp_log,nx,ny,'Reference',max_num,min_num);
% 
% temp_log=log(reshape(enPermx, ngrid, NofRealization));
% MeanPara=mean(temp_log, 2);
% figure; DrawParameter(MeanPara, nx, ny,'En. Mean (INI)',max_num,min_num);
% 
% temp=log(reshape(enPermx_(:,i), ngrid, NofRealization));
% MeanPara_=mean(temp, 2);
% figure; DrawParameter(MeanPara_, nx, ny,'En. Mean (Result)',max_num,min_num);

% %% Perm Field each ensemble
% 
% % data를 불러와 정리
% % 
% tmp=reshape(enPermx_,[ngrid,20,size(Atime,2)]);
% tmp=log(tmp(:,:,end));       
% 
% % 
% % 각 En의 perm map 을 그려봄
% for j= 1:2
%     fig=figure(j);
%     set(fig,'Position',[300,300,1500,450]);
%     hold on
%     for i=1:10
%         
%         subplot(2,5,i)
%         DrawParameter_eachEn(tmp(:,i),nx,ny,['En._ ' num2str(i+(j-1)*10) 'Perm.'],max_num,min_num);
%         hold on
%     end
%     savefig(['Result' '/' num2str((j-1)*10) 'to' num2str(j*10)]);
%     close
%     hold off
%     
% end
% 
% tmp=reshape(enPermx,ngrid,20);
% tmp=log(tmp(:,:,end));       
% 
% 
% % 각 En의 perm map 을 그려봄
% for j= 1:2
%     fig=figure(j);
%     set(fig,'Position',[300,300,1500,450]);
%     hold on
%     for i=1:10
%         
%         subplot(2,5,i)
%         DrawParameter_eachEn(tmp(:,i),nx,ny,['En._ ' num2str(i+(j-1)*10) 'Perm.'],max_num,min_num);
%         hold on
%     end
%     savefig(['Result' '/' num2str((j-1)*10) 'to' num2str(j*10) '_ini']);
%     close
%     hold off
%     
% end
% 
% 
% %% future production
% 
% max_wopr=500;
% max_FOPT=6000000;
% max_FWPT=10000;
% 
% figure; DrawDynamic_1(WOPR_P, refWOPR_P, Ptime, Nofobservedwell,'WOPR',0,max_wopr);
% figure; DrawDynamic_1(WOPR_P_INI, refWOPR_P, Ptime, Nofobservedwell,'WOPR(INI)',0,max_wopr);
% figure; DrawDynamic_1(WWCT_P, refWWCT_P, Ptime, Nofobservedwell,'WWCT',0,1);
% figure; DrawDynamic_1(WWCT_P_INI, refWWCT_P, Ptime, Nofobservedwell,'WWCT(INI)',0,1);


Field=[FOPT_P; FWPT_P];
Field_ini=[FOPT_P_INI; FWPT_P_INI];
  tmp=max([max(max(FOPT_P)),max(max(FOPT_P_INI)),max(max(refField(:,1)))]);
  tmp2=max([max(max(FWPT_P)),max(max(FWPT_P_INI)),max(max(refField(:,2)))]);
% figure; DrawDynamicField(Field, refField, Ptime, 'TOTAL', 0, max_FOPT, 0, max_FWPT);
% figure; DrawDynamicField(Field_ini, refField, Ptime, 'TOTAL(INI)', 0, max_FOPT, 0, max_FWPT);

% figure; DrawDynamicField_RF(Field, refField, Ptime, 'TOTAL', 0, max_FOPT, 0, max_FWPT);
figure; DrawDynamicField_RF(Field_ini, refField, Ptime, 'TOTAL(INI)', 0, max_FOPT, 0, max_FWPT);


%% RMS
% for i = 1:532
%     EnMean_Perm(i,:)=exp(EnMean(i,:));
% end
% for k = 1 : 10
%     for i=1:100
%         for j=1:532
%             En_Err(j+532*(i-1),k)= EnMean_Perm(j,k)-enPermx_(j+532*(i-1),k);
%         end
%     end
% end
% 
% En_Err_S = (En_Err.*En_Err); En_Err_MS = sum (En_Err_S,1)/100/532; En_RMS = En_Err_MS.^0.5;
% 
% 
% plot(1:1:10,En_RMS,'-r','linewidth',2);
% title('En과 EnMean 사이의 RMS','fontsize',15); xlabel('교정횟수','fontsize',15);
% savefig('result/RMS_error'); save Result_with_Mean; close;
% %% Cy (Error Cov.)
% 
% plot(1:1:10,Cy(:),'-r','linewidth',2)
% 
% title('추정오차공분산(평균)','fontsize',20)
% xlabel('교정 횟수','fontsize',15)
% savefig('result/Cy')
% close
% 
% plot(1:1:10,Cy_square(:),'-r','linewidth',2)
% title('추정오차공분산(평균)','fontsize',20)
% xlabel('교정 횟수','fontsize',15)
% savefig('result/Cy')
% close
% 
% %% 히스토그램
% xbins=[-2 -1 0 1 2 3 4 5 6 7 8 9]; %히스토그램 구간 나누기
% figure; Histogramfield(refPermx',xbins, 'Reference')
% figure; Histogramfield(MeanPara',xbins, 'Initial parameter')
% figure; Histogramfield(MeanPara_,xbins, 'Upadated Parameter')
