function [ Y ] = DrawDynamicField_RF( D, refD, time, name, a, b,c,d)

[Nofrealization, Noftime]=size(D);
Nofrealization=Nofrealization/2;
ylabelName={'FOPT[STB]','FWPT[STB]'};
titleName={'Field Oil Production Total', 'Field Water Production Total'};
for i=1:1
%     subplot(2, 1, i);
    hold on;
    % En
    X=time;
    Y=D((i-1)*Nofrealization+1:i*Nofrealization, 1:Noftime);
    Y=Y./(1335.7*16384)*10;
    plot(time, Y(1:20,1:40), 'color', [0.5 0.5 0.5],'LineWidth', 0.1);
    
    % mean En
    tmp=Y';
    DynamicMean=mean(tmp, 2);
    plot(time,DynamicMean, '-b', 'LineWidth', 3);
    % REF
    refD=refD/(1335.7*16384)*10;
    plot(time, refD(:,i), '-r', 'LineWidth', 3);
    
    tmp_max= max(time);
    tmp_min= 100;
%     if i == 1
%         axis([tmp_min tmp_max a b]);
%     else
%         axis([tmp_min tmp_max c d]);
%     end
    
    title('Recovery Factor', 'fontsize',15)
    xlabel('Time[day]','fontsize',10)
    ylabel('RF', 'fontsize',10)
end
hold off;
savefig(['RESULT/' name]);
close
end

