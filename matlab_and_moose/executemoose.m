function []=executemoose(filename,frequncy)

char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

nthreads=1;
runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && /apps/local/mvapich2/2.3.7-1-gcc-8.4.0/bin/mpiexec -n 8 ./first_test-opt  -i  ' num2str(filename) ' freq=' num2str(frequncy) ' > NULL '];
% runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && /apps/local/mvapich2/2.3.7-1-gcc-8.4.0/bin/mpiexec -n 6 ./first_test-opt  -i  ' num2str(filename) ' freq=' num2str(frequncy) ' --n-threads=' num2str(nthreads) '  > NULL '];
% runcmd = ['" dos2unix -n ' num2str(filename) ' ' num2str(filename) '> NULL "'];% converts the ASCII file from DOS format to UNIX format
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
end