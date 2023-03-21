function []=writemisfitcsvfile(misfit)
Tablemisfit = array2table(misfit);
Tablemisfit.Properties.VariableNames(1:4)={'x','y','z','value'};
writetable(Tablemisfit,'adjoint_input_force.csv');
bashcmd = 'bash -c '; % WSL
runcmd = ['" cp adjoint_input_force.csv /home/aaelmeli/projects/first_test/_adjoint_input"'];
status = system([bashcmd runcmd]);
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
end