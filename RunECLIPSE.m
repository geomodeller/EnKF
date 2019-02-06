function y=RunECLIPSE(eclDataFile)
% EnKF���� �� En �������� �ִ� data ���ϵ����� ���� �ּҹ޾ƿ�.

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
