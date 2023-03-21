function [real,imag]=forwardsolve(params,frequncy)

% Syntheticdata=syntheticdata;
real=[];
imag=[];
   
bashcmd = 'bash -c '; % WSL
runcmd = ['" cd  /home/aaelmeli/projects/first_test && /home/aaelmeli/mambaforge3/envs/moose/bin/mpiexec -n 4 ./first_test-opt  -i  synthetic_viscoelastic_waves_p1_copy.i freq=' num2str(frequncy) ' meu_i=' num2str(params(1,1)) ' eta_i=' num2str(params(2,1)) ' > NULL "'];

status = system([bashcmd runcmd]);

if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
% pause (3)

A=readmatrix('\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\_synthetic_viscoelastic_waves\_wavefield_real_rcv_p1_0002.csv');
% pause (3)
real=A(:,2);
A=readmatrix('\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\_synthetic_viscoelastic_waves\_wavefield_imag_rcv_p1_0002.csv');
% pause (3)
imag=A(:,2);
end
