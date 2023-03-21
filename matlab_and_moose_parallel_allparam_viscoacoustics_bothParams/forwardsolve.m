function [real,imag]=forwardsolve(params,frequncy)

% Syntheticdata=syntheticdata;
real=[];
imag=[];
   
bashcmd = 'bash -c '; % WSL
runcmd = ['" cd  /home/aaelmeli/projects/first_test && /home/aaelmeli/mambaforge3/envs/moose/bin/mpiexec -n 4 ./first_test-opt  -i  synthetic_viscoelastic_waves2.i freq=' num2str(frequncy) ' eta_i=' num2str(params(1,1)) ' eta=' num2str(params(2,1)) ' > NULL "'];

status = system([bashcmd runcmd]);

if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end

A=readmatrix('\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\_synthetic_viscoelastic_waves\_wavefield_real_rcv_0002.csv');
real=A(:,2);
A=readmatrix('\\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\_synthetic_viscoelastic_waves\_wavefield_imag_rcv_0002.csv');
imag=A(:,2);
end
