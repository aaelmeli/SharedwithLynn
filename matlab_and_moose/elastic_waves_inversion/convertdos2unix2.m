function []=convertdos2unix2(filename)
bashcmd = 'bash -c '; % WSL
%copy from windows to wsl-moose to perform moose-windows commands
runcmd = ['" cd /home/aaelmeli/projects/first_test && mv ' num2str(filename) ' ' num2str(filename) ' > NULL ']
% runcmd = ['" dos2unix ' num2str(filename) ' ' num2str(filename) ' "'];% converts the ASCII file from DOS format to UNIX format
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end