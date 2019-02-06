function [ WOPR ] = GetDynamicAssimilation( filename, time, Index, Nofobservedwell, Rtime )

Noftime=size(time, 2);
NofRtime=size(Rtime, 2);

fid = fopen([filename '.RSM'], 'r');
for i = 1:9 
    fgetl(fid);
end

Dynamic=fscanf(fid, '%f', [10 NofRtime*Nofobservedwell]);
Dynamic=Dynamic';
index=Index(1, 1:Noftime);
indexTime=time(index==1);
for i=1:size(indexTime,2)
    for j=1:Nofobservedwell
        WOPR(i,j)=Dynamic(Dynamic(:,1)==indexTime(i), (2+j));
    end
end
WOPR=reshape(WOPR, 1, size(indexTime,2)*Nofobservedwell );

fclose(fid);

end