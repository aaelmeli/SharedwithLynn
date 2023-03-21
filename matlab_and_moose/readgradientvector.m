function [gradientvecotr]=readgradientvector()
bashcmd = 'bash -c '; % WSL
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

runcmd = ['"cd /home/aaelmeli/projects/first_test/' directoryname '/grad_computation_viscoelastic_waves && cp  _gradient_0002.csv /mnt/e/3D_SWE_MOOSE/matlab_and_moose/' directoryname ' > NULL "'];
status = system([bashcmd runcmd]); 
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end

filename=['\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\' directoryname '\grad_computation_viscoelastic_waves\_gradient_0002.csv'];
A=readmatrix(filename);
gradientvecotr=A(:,2);
end