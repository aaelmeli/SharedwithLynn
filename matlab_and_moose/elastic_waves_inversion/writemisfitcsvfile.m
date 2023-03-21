function []=writemisfitcsvfile(misfit)
% write the real of the misfit for the adjoint solve
Tablemisfit_real = array2table(misfit.real);
Tablemisfit_real.Properties.VariableNames(1:4)={'x','y','z','value'};
writetable(Tablemisfit_real,'adjoint_real_force.csv');
bashcmd = 'bash -c '; % WSL
runcmd = ['" cp adjoint_real_force.csv /home/aaelmeli/projects/first_test/_adjoint_elastic_waves"'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
%% write the imaginary part of the misfit for the adjoint solve (\\\MAKE SURE///
%that you took the (CONJUGATE) of the misfit!!!
Tablemisfit_imag = array2table(misfit.imag);
Tablemisfit_imag.Properties.VariableNames(1:4)={'x','y','z','value'};
writetable(Tablemisfit_imag,'adjoint_imag_force.csv');
bashcmd = 'bash -c '; % WSL
runcmd = ['" cp adjoint_imag_force.csv /home/aaelmeli/projects/first_test/_adjoint_elastic_waves"'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end