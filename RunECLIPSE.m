function y=RunECLIPSE(eclDataFile)
% EnKF에서 각 En 폴더마다 있는 data 파일돌리기 위해 주소받아옴.

dos(['eclrun eclipse ' eclDataFile ' > NUL']);
k = 0.;
%judge success or failure of Eclipse run by existence of a RSM file
while ~exist([eclDataFile '.RSM'])
    k = k + 1.0;
    disp(['FLEXLM error: ' num2str(k)]);
    pause(k);
    %rerun Eclipse atfer k seconds when FLEXLM error happens
    dos(['eclrun eclipse ' eclDataFile ' > ERROR.LOG']);
end
