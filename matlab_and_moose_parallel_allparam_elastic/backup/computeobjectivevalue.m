function value=computeobjectivevalue(output)%output is a structure that contains the directories & file names of the outputs
global syntheticdata
bashcmd = 'bash -c '; % WSL
runcmd = ['"cd /home/aaelmeli/projects/first_test/_forward_output && cp  ' num2str(output.wavefieldoutputfilename) ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose > NULL "'];
status = system([bashcmd runcmd]); 
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
[wavefieldatreceivers]=readwavefieldoutput(output.wavefieldoutputfilename);
forward_data=wavefieldatreceivers(:,1);
error=syntheticdata-forward_data;
misfit=[wavefieldatreceivers(:,2:end),error];
writemisfitcsvfile(misfit);%write the misfit in csv, to be backpropagated to compute the adjoint field.
value=0.5*(error'*error);
end