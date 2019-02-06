function [  ] = DrawDynamic_1( Dynamic, refD, time, Nofobservedwell,name, a, b)

tmp=Dynamic'; refD=refD';
DynamicMean=mean(tmp, 2);

for i=1:1
    hold on;
    % En
    X=time;
    Y=Dynamic(:, size(time,2)*(i-1)+1:size(time,2)*i);
    plot(time, Y, 'color', [0.5, 0.5, 0.5], 'LineWidth', 0.1);
    % mean En
    plot(time, DynamicMean(size(time,2)*(i-1)+1:size(time,2)*i, 1), '-b', 'LineWidth', 2);
    % REF
    plot(time, refD(size(time,2)*(i-1)+1:size(time,2)*i, 1), '-r', 'LineWidth', 2);
    
%     axis([0 3000 a b]);
    xlabel('Time[day]','fontsize', 10);
    ylabel(name,'fontsize',10);
    title([name ' of Prod #' num2str(i)],'fontsize', 10);
    hold off;
end
savefig(['RESULT/' name]);
close;
end

