function [ y ] = DrawParameter_eachEn( Para, nx, ny, name,max_num, min_num )

for i=1:ny
    image(ny+1-i,:)=Para(nx*(i-1)+1 : nx*i)';
end

h=imagesc(1,1,flipud(image(:,:)));
title(name,'fontsize',15);
% cb=colorbar();
% caxis([min_num max_num]) %이거 조절해야 함☆
% set(cb,'Ticks',[min_num:max_num]);
colormap jet;
axis square
end
