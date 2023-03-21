function [value]=computeobjectivevalue(labindex,mooseforwarddirectory,Output,syntheticdata)%output is a structure that contains the directories & file names of the outputs
% global syntheticdata output
global inputs 
Inputs=inputs;
%copy the output of forward solve (real and imaginary) to the windows
%directory - this for real
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);

bashcmd = 'bash -c '; % WSL
runcmd = ['"cd /home/aaelmeli/projects/first_test/' directoryname '/' mooseforwarddirectory ' && cp  ' Output.wavefieldoutputfilename_real ' ' Output.wavefieldoutputfilename_imag ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose_parallel_allparam_viscoacoustics_bothParams/' directoryname ' > NULL "'];
status = system([bashcmd runcmd]); 
if (status ~= 0)
    error(['Run bash cmd error: ' num2str(status)]);
end
% % ... - this for imaginary
% bashcmd = 'bash -c '; % WSL
% runcmd = ['"cd /home/aaelmeli/projects/first_test/' directoryname '/' mooseforwarddirectory ' && cp  ' Output.wavefieldoutputfilename_imag ' /mnt/e/3D_SWE_MOOSE/matlab_and_moose/' directoryname ' > NULL "'];
% status = system([bashcmd runcmd]); 
% if (status ~= 0)
%     error(['Run bash cmd error: ' num2str(status)]);
% end
[wavefieldatreceivers]=readwavefieldoutput(mooseforwarddirectory,Output.wavefieldoutputfilename_real);
forward_data_real=wavefieldatreceivers(:,1);

[wavefieldatreceivers,coord]=readwavefieldoutput(mooseforwarddirectory,Output.wavefieldoutputfilename_imag);
forward_data_imag=wavefieldatreceivers(:,1);
%% L2 objective function
% error_real=syntheticdata.real-forward_data_real;
% error_imag=syntheticdata.imag-forward_data_imag;
% error=error_real+1i.*error_imag;
% value=0.5*(error'*error);
%% correlation-based objective function
n=1;
u1=forward_data_real+1i*forward_data_imag;
d1=syntheticdata.real+1i*syntheticdata.imag;
ud_correl=((u1'*d1)*(d1'*u1)).^n;
value=(1-(ud_correl)/((norm(d1)*norm(u1)))^(2*n));
factor1=u1'*d1;
factor2=u1'*u1;
alpha=(1-value)/factor1;
beta=(1-value)/factor2;
scaledmisfit=alpha.*d1-beta.*u1;
error_real=real(scaledmisfit);
error_imag=imag(scaledmisfit);

%compute the misfit, these misfits (real and imaginary) will be acting as
%forces in the adjoint problem. when using the CORRELATION Objective
%Function, we will (SCALE) the misfit (synthetic records and the forward
%solve) before backpropagation. This is done through computing alpha and
%beta factors.
misfit.real=[coord,error_real];
%% Donot forget to take the (CONJUGATE) of the misfit
misfit.imag=[coord,-error_imag];% I negated the imaginary part here because I will apply the conjugate of the misfit as a force for the adjoint solve.
writemisfitcsvfile(misfit);%write the misfit in csv, to be backpropagated to compute the adjoint field.
end