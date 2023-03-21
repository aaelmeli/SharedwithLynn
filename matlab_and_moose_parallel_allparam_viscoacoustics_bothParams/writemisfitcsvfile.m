function []=writemisfitcsvfile(misfit)
global inputs
Inputs=inputs;
% write the real of the misfit for the adjoint solve
Tablemisfit_real = array2table(misfit.real);
Tablemisfit_real.Properties.VariableNames(1:4)={'x','y','z','value'};

char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);
filename='adjoint_real_force.csv';
dirfilename=append(char1,char2,'\',filename);
writetable(Tablemisfit_real,dirfilename);
adjointdirectoryname='_adjoint_viscoacoustics_waves';
bashcmd = 'bash -c '; % WSL
runcmd = ['" cd ' directoryname ' && cp ' filename ' /home/aaelmeli/projects/first_test/' directoryname '/' adjointdirectoryname '"'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
%% write the imaginary part of the misfit for the adjoint solve (\\\MAKE SURE///
%that you took the (CONJUGATE) of the misfit!!!
Tablemisfit_imag = array2table(misfit.imag);
Tablemisfit_imag.Properties.VariableNames(1:4)={'x','y','z','value'};
filename='adjoint_imag_force.csv';
dirfilename=append(char1,char2,'\',filename);

writetable(Tablemisfit_imag,dirfilename);
bashcmd = 'bash -c '; % WSL
runcmd = ['" cd ' directoryname ' && cp ' filename ' /home/aaelmeli/projects/first_test/' directoryname '/' adjointdirectoryname '"'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end