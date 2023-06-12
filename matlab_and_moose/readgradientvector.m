function [gradientvecotr]=readgradientvector()

char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

runcmd = ['cd  /home/elmeabde/sawtooth1/projects/first_test/' directoryname '/grad_computation_viscoelastic_waves && cp  _gradient_0002.csv /home/elmeabde/sawtooth1/projects/matlabMooseWrapper/matlab_and_moose/' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end

filename = ['/home/elmeabde/sawtooth1/projects/first_test/' directoryname '/grad_computation_viscoelastic_waves/_gradient_0002.csv'];
A=readmatrix(filename);
gradientvecotr=A(:,2);
end