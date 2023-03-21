function [gradientvecotr]=readgradientvector()
bashcmd = 'bash -c '; % WSL
runcmd = ['"cd /home/aaelmeli/projects/first_test/grad_computation_viscoelastic_waves && cp  _gradient_0002.csv /mnt/e/3D_SWE_MOOSE/matlab_and_moose > NULL "'];
status = system([bashcmd runcmd]); 
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
filename='_gradient_0002.csv';
A=xlsread(filename);
gradientvecotr=A(:,2);
end