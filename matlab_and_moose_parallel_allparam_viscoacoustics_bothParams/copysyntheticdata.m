function []=copysyntheticdata(output)
bashcmd = 'bash -c '; % WSL
directoryname=output.wavefieldoutputdirectoryname;
filename=output.wavefieldoutputfilename;
runcmd = ['"cd /home/aaelmeli/projects/first_test/' num2str(directoryname) ' && cp ' num2str(filename) ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose_parallel_allparam_viscoacoustics_bothParams > NULL "'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end