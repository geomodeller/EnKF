function Parameters=GetParameters(filename, BoolofChannel, k_sand, k_clay)

fid = fopen(filename, 'r');
for i=1:2
    fgetl(fid);
end
Parameters = fscanf(fid, '%f', inf);
fclose(fid);

if BoolofChannel
    index_sand=(Parameters(:, 1)==1);
    Parameters(index_sand)=k_sand;
    index_clay=(Parameters(:, 1)==0);
    Parameters(index_clay)=k_clay;
else
    Parameters=exp(Parameters);
end

end