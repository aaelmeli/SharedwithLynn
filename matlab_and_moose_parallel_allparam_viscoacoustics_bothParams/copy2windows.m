function []=copy2windows(Output)
bashcmd = 'start /b bash -c '; % WSL
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

outdirectoryname=Output.wavefieldoutputdirectoryname;
%copy the file contains the real wavefiled data
% filename=Output.wavefieldoutputfilename_real;
runcmd = ['"cd /home/aaelmeli/projects/first_test/' directoryname '/' outdirectoryname ' && cp ' num2str(Output.wavefieldoutputfilename_real) ' ' num2str(Output.wavefieldoutputfilename_imag) ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose_parallel_allparam_viscoacoustics_bothParams/' directoryname ' > NULL "'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
% 
% %copy the file contains the imaginary wavefiled data
% filename=Output.wavefieldoutputfilename_imag;
% runcmd = ['"cd /home/aaelmeli/projects/first_test/' directoryname '/' outdirectoryname ' && cp ' num2str(wavefieldoutputfilename_imag) ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose/' directoryname ' > NULL "'];
% status = system([bashcmd runcmd]);
% if (status ~= 0)
%     error(['Run bash cmd error: ' num2str(status)]);
% end
end