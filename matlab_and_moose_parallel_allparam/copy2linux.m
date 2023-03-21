function []=copy2linux(filename)
bashcmd = 'start /b bash -c '; % WSL
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);
runcmd = ['" cd ' directoryname ' && cp ' num2str(filename) '  /home/aaelmeli/projects/first_test/' directoryname ' " '];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end