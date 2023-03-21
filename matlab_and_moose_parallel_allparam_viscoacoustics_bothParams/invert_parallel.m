close all
clear all
clc

spmd(2)
%   for id = (1:100)+(labindex-1)*100
    % do some computation
    
    bashcmd = 'bash -c '; % WSL
    filename='par';
    directoryname='trial';
    chr = int2str(labindex);
   labindex
    chr2='.txt';
    directoryname=append(directoryname,chr);
    filename=append(filename,chr,chr2);
    %copy the file contains the real wavefiled data
    runcmd = ['"cp ' filename ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose/' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
%   end
end