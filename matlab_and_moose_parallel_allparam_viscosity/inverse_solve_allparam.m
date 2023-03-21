clear all 
close all
clc
global inputs syntheticdata output
inputs.moosesyntheticinputfilename='synthetic_elastic_waves';%without the extension '.i' so that i can add which push number, for single push, we can add '.i' here
inputs.mooseforwardinputfilename='forward_elastic_waves'; %without the extension '.i' so that i can add which push number, for single push, we can add '.i' here
inputs.mooseadjointinputfilename='adjoint_elastic_waves.i';
inputs.moosegradientinputfilename='compute_gradient_elastic_waves.i';

% inputs.moosesyntheticinputfilename='synthetic_viscoelastic_waves';%without the extension '.i' so that i can add which push number, for single push, we can add '.i' here
% inputs.mooseforwardinputfilename='forward_viscoelastic_waves'; %without the extension '.i' so that i can add which push number, for single push, we can add '.i' here
% inputs.mooseadjointinputfilename='adjoint_viscoelastic_waves.i';
% inputs.moosegradientinputfilename='compute_gradient_viscoelastic_waves.i';

% inputs.moosesyntheticinputfilename='synthetic_viscosity_waves';%without the extension '.i' so that i can add which push number, for single push, we can add '.i' here
% inputs.mooseforwardinputfilename='forward_viscosity_waves'; %without the extension '.i' so that i can add which push number, for single push, we can add '.i' here
% inputs.mooseadjointinputfilename='adjoint_viscosity_waves.i';
% inputs.moosegradientinputfilename='compute_gradient_viscosity_waves.i';

% names of directories that contain the data fpr each frequency 
inputs.moosesyntheticdirectory='_synthetic_elastic_waves'; 
inputs.mooseforwarddirectory='_forward_elastic_waves';
inputs.mooseadjointdirectory='_adjoint_elastic_waves';
inputs.moosegradientdirectory='grad_computation_elastic_waves';



% inputs.moosesyntheticdirectory='_synthetic_viscoelastic_waves';
% inputs.mooseforwarddirectory='_forward_viscoelastic_waves';
% inputs.mooseadjointdirectory='_adjoint_viscoelastic_waves';
% inputs.moosegradientdirectory='grad_computation_viscoelastic_waves';



inputs.materialfilename=["storage_modulus_dist.txt";"loss_modulus_dist.txt"];% %in case of inverting for E and eta
% inputs.materialfilename=["storage_modulus_dist.txt"];% the file the allways has material distribution - parameters estimates

% inputs.materialderivativefilename=["storage_modulus_dist_differentiated.txt"]; % will be used when we use parameterization other than E_r, e.g. (log(E_r) or sqrt(E_r))
inputs.materialderivativefilename=["storage_modulus_dist_differentiated.txt";"loss_modulus_dist_differentiated.txt"]; %in case inverting for both E and eta
inputs.elatsticmaterialderivativeconst=log(10); %that constant is needed as a multiplier to the E_r when the parameter is log(E_r)

inputs.omega_bar=15000; % needed to compute G= G_eff *(1+ i*omega/omega_bar, G_r=G_eff*1, G_i=G_eff*omega/omega_bar
inputs.mesh.dim=2;
inputs.mesh.nx=60;
inputs.mesh.ny=60;
inputs.mesh.xmin=0;
inputs.mesh.ymin=0;
inputs.mesh.xmax=0.03;
inputs.mesh.ymax=.03;
inputs.nrcv=40; % number of receivers
inputs.mesh.dx=(inputs.mesh.xmax-inputs.mesh.xmin)/inputs.mesh.nx;
inputs.mesh.dy=(inputs.mesh.ymax-inputs.mesh.ymin)/inputs.mesh.ny;
inputs.npush=1; %number of the push used. This is when we use multi-acquisition simultaneously in the inversion.
inputs.freqs=50:100:650; %the frequency range, in Hz.↔
output.wavefieldoutputfilename_real='_wavefield_real_rcv'; %name of the file that contains the synthetic/forward real wavefield
output.wavefieldoutputfilename_imag='_wavefield_imag_rcv'; %name of the file that contains the syntheticpa/forward imaginary wavefield
% output.wavefieldoutputdirectoryname='_synthetic_elastic_waves';

filename_param1 = 'initial_guess.xlsx';
filename_param2 = 'initial_guess_param2.xlsx';
initial_guess1=xlsread(filename_param1);
initial_guess2=xlsread(filename_param2);

nx=60;nz=60;
inputs.nparamx=nx;
inputs.nparamz=nz;
xmin=0;xmax=0.03;zmin=0;zmax=0.03;dx=xmax/nx;dz=zmax/nz;
x = (xmin+dx/2:(xmax-xmin-dx)/(nx-1):xmax-dx/2).';
z = (zmin+dz/2:(zmax-zmin-dz)/(nz-1):zmax-dz/2).';
velocity1 = log10(15e3)*ones(nx).';
velocity2 = log10(3).*ones(nx).';
[X, Z] = meshgrid(x,z);
x0 = xmax/2;
z0 = zmax/2;
r0 = 0.004;
R=r0; %this is the radius of the R.O.I, this contains the parameters to be considered in inversion
ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0;
theta1=pi()/1;
theta2=pi()/4;
x1=0.013;
z1=0.013;
r1=0.001;
x2=0.017;
z2=0.015;
r1=0.001;
ind1 = sqrt(((X-x1)*cos(theta1)+(Z-z1)*sin(theta1)).^2+((X-x1)*sin(theta1)-(Z-z1)*cos(theta1)).^2) <= r1;
ind2 = sqrt(((X-x2)*cos(theta1)+(Z-z2)*sin(theta1)).^2+((X-x2)*sin(theta1)-(Z-z2)*cos(theta1)).^2) <= r1;
velocity1(ind)=log10(45e3);
velocity1(ind1)=log10(60e3);
velocity1(ind2)=log10(30e3);
ind_inversion=sqrt((X-x0).^2+(Z-z0).^2) <= R;% indicies of the inversion parameters.
map_param = zeros(nx,nz);
k=0;
element_ID=zeros(60,60);% matrix contains the element ids same as moose ids
for i=1:nx
    for j=1:nz
        k=k+1;
        element_ID(nz-i+1,j)=k;
    end
end
map_param(ind_inversion)=element_ID(ind_inversion); %this is matrix that contains the element ids corresponds to the inversion parameters.
% map_param=element_ID; %in case we invert for all parameters in the space.
k=1;l=1;
nparam=0;
for i=1:nx
    for j=1:nz
      if(map_param(nz-i+1,j)~=0)
        row=nz-i+1; column=j;id=map_param(nz-i+1,j);
        nparam=nparam+1;
        parameters_map(k,:)=[row,column,id];
        k=k+1;
      end
    end
end
%initial guess
% params01=15e3.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% params01=log10(15e3).*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% params01=log10(initial_guess1); %in case the initial guess is taken from a file (usually this is used in multi_frequeuncy, multi_acquisition inversion)
% params02=2.*ones(616,1);
% params02=180e3.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% params02=log10(1).*ones(inputs.mesh.nx*inputs.mesh.ny,1); % here we consider the log10() of the viscosity Pa.s 
% params02=log10(initial_guess2);
% params0=[params01;params02]; %in case of inverting for E and eta
% params0=[params02]; %in case of inverting for E only
% for (i=1:616)
%     row=parameters_map(i,1); column=parameters_map(i,2);
%     velocity(row,column)=params0(i);
% end
ind = sqrt((X-x0).^2+(Z-z0).^2) <= R;
inputs.velocity1=velocity1;
inputs.velocity2=velocity2;
%in case you invert for specific parameters located at (ind), uncomment the
%following two lines.
inputs.velocity1(ind)=-1;
inputs.velocity2(ind)=-1;
inputs.parameters_map=parameters_map;
inputs.map_param=map_param;
params=[];
for i=1:nx
        row=inputs.velocity1(nz-i+1,:);
        params=[params;row'];
end
background_parameter_index_vector=find(params~=-1); 
inclusion_parameter_index_vector=find(params==-1); 
parameter_index_vector=find(params==-1); %uncomment if you will invert
% for specific parameters represented by (-1) in the param
% parameter_index_vector=[1:1:length(params)]';%uncomment if you will
% invert for the entire ROI
inputs.parameter_index_vector=parameter_index_vector;
% in case we invert for subset of the ROI, we need to use parameter_index_vector
params01=log10(initial_guess1(parameter_index_vector));
% params01=log10(15e3).*ones(nparam,1);
% params02=initial_guess2(parameter_index_vector);
params02=log10(9).*ones(nparam,1);
% params02=log10(initial_guess2(inclusion_parameter_index_vector));
% params0=[params01;params0]; %in case of inverting for E and eta
params0=[params01]; %in case of inverting for E only


% inclusion_E=initial_guess1(inclusion_parameter_index_vector);
% inclusion_eta=initial_guess2(inclusion_parameter_index_vector);
% background_E=initial_guess1(background_parameter_index_vector);
% background_eta=initial_guess2(background_parameter_index_vector);
% inclusion_average_E=mean(inclusion_E);
% inclusion_average_eta=mean(inclusion_eta);
% background_average_E=mean(background_E);
% background_average_eta=mean(background_eta);
% params01(inclusion_parameter_index_vector)=log10(inclusion_average_E);
% params01(background_parameter_index_vector)=log10(background_average_E);
% params02(inclusion_parameter_index_vector)=log10(inclusion_average_eta);
% params02(background_parameter_index_vector)=log10(background_average_eta);
% params01=log10(inclusion_average_E).*ones(nparam,1);
% params02=log10(inclusion_average_eta).*ones(nparam,1);
% params0=[params02];
% params0=[params01];
inputs.params0=params0;
inputs.params02=params02; % in case we need to fix viscosity, i need this to be used when writing the viscosity file which depend on this and frequency
% param1=80000.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% we may have some particular distributions of E and eta used for the
% synthetic measurements generation
param1=log10(15e3).*ones(inputs.mesh.nx*inputs.mesh.ny,1);
param2=log10(3).*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% param2=(5.3).*ones(616,1);
% param2=(80e3).*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% param=[param1;param2];
param=[param1];
% param=[param2];

%based on the number of frequecies, makedir on wsl such that each frequency
%has its own directory
nfreq=length(inputs.freqs);
% spmd(nfreq)
preprocessor(); %produce folders per number of frequencies, 
%put in it all required inputs, executables (forward, adjoint, grad,
%synthetic, material file name/freq, etc...
% end
syntheticdatasolve(param);


objective=@computeobjectiveandgradient;
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','SpecifyObjectiveGradient',true, 'TolFun',1e-11,'MaxIterations',99);
% options = optimoptions(@fmincon,'Display','iter','SpecifyObjectiveGradient',true,'HessianFcn',[],'HessianMultiplyFcn',[],'HessianApproximation','lbfgs','SubproblemAlgorithm','cg', 'TolFun',1e-9,'MaxIterations',400);
tic;
[params,fval,exitflag,outputs]=fminunc(objective,params0,options);


% params1lb=1e3.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% params2lb=0.1e3.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% 
% params1ub=50e3.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% params2ub=250e3.*ones(inputs.mesh.nx*inputs.mesh.ny,1);
% lb=[params1lb;params2lb];
% ub=[params1ub;params2ub];
% [x,fval,exitflag,output]=fmincon(objective,params0,[],[],[],[],lb,ub,[],options);
toc;