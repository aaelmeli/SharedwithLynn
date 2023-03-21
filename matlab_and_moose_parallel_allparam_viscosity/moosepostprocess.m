function []=moosepostprocess(filename)

bashcmd = 'bash -c '; % WSL
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

runcmd = ['" cd  /home/aaelmeli/projects/first_test/' directoryname ' && ./first_test-opt  -i  ' num2str(filename) ' > trash "'];
% runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end

% bashcmd = 'bash -c '; % WSL
% char1='_freq';
% char2=int2str(labindex);
% directoryname=append(char1,char2);
% 
% runcmd = ['" cd  /home/aaelmeli/projects/first_test/' directoryname ' && ./first_test-opt  -i  ' num2str(filename) ' freq=' num2str(frequncy) ' > NULL "'];
% % runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format
% 
% status = system([bashcmd runcmd]);
% 
% if (status ~= 0)
%     error(['Run bash cmd error: ' num2str(status)]);
% end

end