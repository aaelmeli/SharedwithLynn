function []=copy2mooseproj(filename)

char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);
%copy from windows to wsl-moose to perform moose-windows commands
% runcmd = ['" cd /home/aaelmeli/projects/first_test && dos2unix ' num2str(filename) ' ' num2str(filename) ' "']
% runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format

runcmd = [' cd /home/elmeabde/sawtooth1/projects/matlabMooseWrapper/matlab_and_moose/' directoryname ' && cp ' num2str(filename.storage) ' /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && cp ' num2str(filename.loss) '  /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' > trash ']; % converts the ASCII file from DOS format to UNIX format
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
end