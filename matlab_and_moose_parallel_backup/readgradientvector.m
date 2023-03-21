function [gradientvecotr1,gradientvecotr2]=readgradientvector()
bashcmd = 'bash -c '; % WSL
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

runcmd = ['"cd /home/aaelmeli/projects/first_test/' directoryname '/grad_computation_viscoelastic_waves && cp  _gradient1_0002.csv /mnt/e/3D_SWE_MOOSE/matlab_and_moose_parallel_backup/' directoryname ' && cp  _gradient2_0002.csv /mnt/e/3D_SWE_MOOSE/matlab_and_moose_parallel_backup/' directoryname ' > NULL "'];
status = system([bashcmd runcmd]); 
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end

filename=['\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\' directoryname '\grad_computation_viscoelastic_waves\_gradient1_0002.csv'];
A1=readmatrix(filename);
filename=['\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\' directoryname '\grad_computation_viscoelastic_waves\_gradient2_0002.csv'];
A2=readmatrix(filename);
gradientvecotr1=[A1(:,2)];
gradientvecotr2=[A2(:,2)];
end