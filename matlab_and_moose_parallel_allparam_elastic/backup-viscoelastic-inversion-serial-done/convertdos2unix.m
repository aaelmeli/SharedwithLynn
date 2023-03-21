function []=convertdos2unix(filename)
bashcmd = 'bash -c '; % WSL
%copy from windows to wsl-moose to perform moose-windows commands
% runcmd = ['" cd /home/aaelmeli/projects/first_test && dos2unix ' num2str(filename) ' ' num2str(filename) ' "']
% runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format
runcmd = ['" dos2unix -q ' num2str(filename) '  ' num2str(filename) ' > trash "'];% converts the ASCII file from DOS format to UNIX format
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end