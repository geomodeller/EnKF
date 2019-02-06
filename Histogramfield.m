function Histogramfield(value,xbins,name)

    hist(value',xbins);
    hold on
    h=findobj(gca, 'Type', 'patch');
    set(gca,'YLim',[0 300],'YTick',[0:50:300],  'XLim', [0 300], 'XTick', [0:50:300],'FontSize', 15);
    set(h(1), 'FaceColor', 'w', 'EdgeColor', 'k','LineWidth', 2.5, 'facealpha',0);
    
    xlabel('Permeability [md]', 'fontsize',15)
    ylabel('Frequency', 'fontsize',15)
    title([name],'fontsize',15)
    legend('frequency')

hold off;
savefig(['RESULT/histogram_'  name ]);
close
end