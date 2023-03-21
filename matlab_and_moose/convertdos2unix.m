function []=convertdos2unix(filename)
bashcmd = 'start /b bash -c '; % WSL
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);
%copy from windows to wsl-moose to perform moose-windows commands
% runcmd = ['" cd /home/aaelmeli/projects/first_test && dos2unix ' num2str(filename) ' ' num2str(filename) ' "']
% runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format
runcmd = ['" cd ' directoryname ' && dos2unix -q ' num2str(filename.storage) '  ' num2str(filename.storage) ' && dos2unix -q ' num2str(filename.loss) '  ' num2str(filename.loss) ' "'];% converts the ASCII file from DOS format to UNIX format
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end

runcmd = ['" cd ' directoryname ' && cp ' num2str(filename.storage) '  /home/aaelmeli/projects/first_test/' directoryname ' && cp ' num2str(filename.loss) '  /home/aaelmeli/projects/first_test/' directoryname ' > trash "'];% converts the ASCII file from DOS format to UNIX format
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end