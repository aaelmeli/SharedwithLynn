function []=copy2windows(output)
bashcmd = 'bash -c '; % WSL
directoryname=output.wavefieldoutputdirectoryname;
%copy the file contains the real wavefiled data
filename=output.wavefieldoutputfilename_real;
runcmd = ['"cd /home/aaelmeli/projects/first_test/' num2str(directoryname) ' && cp ' num2str(filename) ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose > NULL "'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end

%copy the file contains the imaginary wavefiled data
filename=output.wavefieldoutputfilename_imag;
runcmd = ['"cd /home/aaelmeli/projects/first_test/' num2str(directoryname) ' && cp ' num2str(filename) ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose > NULL "'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end