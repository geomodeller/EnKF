function [ ] = MakeSolution(TSTEP, eclDataName, filename)
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', 'RESTART');
fprintf(fid, '%s %d /\n', [int2str(TSTEP) '_' eclDataName], TSTEP);
fclose(fid);
end