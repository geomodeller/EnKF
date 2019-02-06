function [ WOPR, WWCT, FOPT, FWPT ] = GetDynamicPrediction( filename, time, Index, Nofobservedwell, Rtime )

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

for i = 1:8 
    fgetl(fid);
end
Dynamic=fscanf(fid, '%f', [10 NofRtime*Nofobservedwell]);
Dynamic=Dynamic';
index=Index(2, 1:Noftime);
indexTime=time(index==1);
for i=1:size(indexTime,2)
    for j=1:Nofobservedwell
        WWCT(i, j)=Dynamic(Dynamic(:,1)==indexTime(i), (1+j));
    end
end
WWCT=reshape(WWCT, 1, size(indexTime,2)*Nofobservedwell );

for i = 1:8 
    temp=fgetl(fid);
end
Dynamic=fscanf(fid, '%f', [3 NofRtime*2+1]);
Dynamic=Dynamic';
for i=1:Noftime
    FOPT(i)=Dynamic(Dynamic(:,1)==time(i), 2);
    FWPT(i)=Dynamic(Dynamic(:,1)==time(i), 3);
end

fclose(fid);

end

