clear all 
close all

global inputs syntheticdata output
inputs.moosesyntheticinputfilename='cantilever_2d_heterogeneous.i';
inputs.mooseforwardinputfilename='forward_input.i';
inputs.mooseadjointinputfilename='adjoint_input.i';
inputs.moosegradientinputfilename='compute_grad.i';
inputs.materialfilename='data1.txt';% the file the allways has material distribution - parameters estimates 
inputs.mesh.dim=2;
inputs.mesh.nx=100;
inputs.mesh.ny=100;
inputs.mesh.xmin=0;
inputs.mesh.ymin=0;
inputs.mesh.xmax=1;
inputs.mesh.ymax=1;
inputs.mesh.dx=(inputs.mesh.xmax-inputs.mesh.xmin)/inputs.mesh.nx;
inputs.mesh.dy=(inputs.mesh.ymax-inputs.mesh.ymin)/inputs.mesh.ny;

output.wavefieldoutputfilename='_wavefieldrcv_0002.csv';
output.wavefieldoutputdirectoryname='_synthetic_data';
params=10.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
syntheticdatasolve(params);
%initial parameters
params0=1.*ones(inputs.mesh.nx*inputs.mesh.ny,1);

objective=@computeobjectiveandgradient;
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','SpecifyObjectiveGradient',true, 'TolFun',1e-3,'MaxIterations',40);
tic;
[params,fval,exitflag,output]=fminunc(objective,params0,options);
toc;








% [grad]=readgradientvector();
% bashcmd = 'bash -c '; % WSL
% runcmd = ['" cp adjoint_input_force.csv /home/aaelmeli/projects/first_test/_adjoint_input"'];
% status = system([bashcmd runcmd]);
% if (status ~= 0)
%     error(['Run bash cmd error: ' num2str(status)]);
% end
% 
% trial=1:1:10000;
% params=10.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% %write the parameters file.
% writematerialfile(params);
% %convert the parameters file from dos to unix format
% convertdos2unix(inputs.materialfilename);
% %copy the material file to moose application directory
% copy2linux(inputs.materialfilename);
% %execute moose application - compute the forward solution
% executemoose(inputs.mooseforwardinputfilename);
% %get the forward solution
% % output.wavefieldoutputdirectoryname='outputs_exodus';
% % output.wavefieldoutputfilename='all_u_0002.csv';
% % 
% % convertdos2unix(inputs.materialfilename);
% % [wavefieldatreceivers]=readwavefieldoutput(output.wavefieldoutputfilename);