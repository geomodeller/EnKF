function [  ] = SetPermx(i, permx, ngrid, filename )
fid = fopen(filename, 'w');
fprintf(fid, '%s \n', 'PERMX');
fprintf(fid, '%d \n', permx(ngrid*(i-1)+1 : ngrid*(i-1)+ngrid));
fprintf(fid, '/');
fclose(fid);
end