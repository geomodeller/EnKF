function [ ]= MakeTstep_P(TSTEP, filename)
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', 'TSTEP');
fprintf(fid, '%s /\n', TSTEP);
fclose(fid);
end