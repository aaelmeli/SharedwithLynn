function []=copy2linux(filename)
bashcmd = 'bash -c '; % WSL
runcmd = ['" cp ' num2str(filename) '  /home/aaelmeli/projects/first_test" > NULL '];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end