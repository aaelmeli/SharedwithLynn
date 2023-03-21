function []=moosepostprocess(filename)
bashcmd = 'bash -c '; % WSL
runcmd = ['" cd  /home/aaelmeli/projects/first_test && ./first_test-opt  -i  ' num2str(filename) ' > NULL "'];
% runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end