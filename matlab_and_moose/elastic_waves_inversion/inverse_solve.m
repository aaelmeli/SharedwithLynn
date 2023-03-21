clear all 
% close all
clc
global inputs syntheticdata output
inputs.moosesyntheticinputfilename='synthetic_elastic_waves.i';
inputs.mooseforwardinputfilename='forward_elastic_waves.i';
inputs.mooseadjointinputfilename='adjoint_elastic_waves.i';
inputs.moosegradientinputfilename='compute_gradient_elastic_waves.i';
inputs.materialfilename=["youngs_modulus_dist.txt";"loss_modulus_dist.txt"];% the file the allways has material distribution - parameters estimates 
inputs.omega_bar=15000; % needed to compute G= G_eff *(1+ i*omega/omega_bar, G_r=G_eff*1, G_i=G_eff*omega/omega_bar
inputs.mesh.dim=2;
inputs.mesh.nx=60;
inputs.mesh.ny=60;
inputs.mesh.xmin=0;
inputs.mesh.ymin=0;
inputs.mesh.xmax=0.03;
inputs.mesh.ymax=.03;
inputs.mesh.dx=(inputs.mesh.xmax-inputs.mesh.xmin)/inputs.mesh.nx;
inputs.mesh.dy=(inputs.mesh.ymax-inputs.mesh.ymin)/inputs.mesh.ny;

inputs.freqs=400:50:800; %the frequency range, in Hz.
output.wavefieldoutputfilename_real='_wavefield_real_rcv_0002.csv'; %name of the file that contains the synthetic/forward real wavefield
output.wavefieldoutputfilename_imag='_wavefield_imag_rcv_0002.csv'; %name of the file that contains the syntheticpa/forward imaginary wavefield
output.wavefieldoutputdirectoryname='_synthetic_elastic_waves';
params=25.*ones(inputs.mesh.nx*inputs.mesh.ny,1); %here, this can be a function that generate velocity models of any shape (i.e. star shape tumor velocity model)

%initial parameters

nx=60;nz=60;
inputs.nparamx=nx;
inputs.nparamz=nz;
xmin=0;xmax=0.03;zmin=0;zmax=0.03;dx=xmax/nx;dz=zmax/nz;
x = (xmin+dx/2:(xmax-xmin-dx)/(nx-1):xmax-dx/2).';
z = (zmin+dz/2:(zmax-zmin-dz)/(nz-1):zmax-dz/2).';
% velocity = sqrt(p(1,1)/rho)*ones(nx).';
velocity = 25*ones(nx).';
[X, Z] = meshgrid(x,z);
x0 = xmax/2;
z0 = zmax/2;
r0 = 0.007;
R=r0; %this is the radius of the R.O.I, this contains the parameters to be considered in inversion
ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0;
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
map_param(:,:)=element_ID; %comment this if you want to limit the inversion to the inclusion location
k=1;l=1;
for i=1:nx
    for j=1:nz
      if(map_param(nz-i+1,j)~=0)
        row=nz-i+1; column=j;id=map_param(nz-i+1,j);
        parameters_map(k,:)=[row,column,id];
        k=k+1;
      end
    end
end
%initial guess
params0=25.*ones(3600,1);
% for (i=1:616)
%     row=parameters_map(i,1); column=parameters_map(i,2);
%     velocity(row,column)=params0(i);
% end
ind = sqrt((X-x0).^2+(Z-z0).^2) <= R;
inputs.velocity=velocity;
inputs.velocity(ind)=50;
inputs.parameters_map=parameters_map;
inputs.map_param=map_param;
params=[];
for i=1:nx
        row=inputs.velocity(nz-i+1,:);
        params=[params;row'];
        
end
parameter_index_vector=find(params==-1);
inputs.parameter_index_vector=parameter_index_vector;
inputs.params0=params;
param=80.*ones(616,1);
syntheticdatasolve(params);


objective=@computeobjectiveandgradient;
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','SpecifyObjectiveGradient',true, 'TolFun',1e-9,'MaxIterations',100);
tic;



% A = [];
% b = [];
% Aeq = [];
% beq = [];
% lb = 25.*ones(3600,1);
% ub = 100.*ones(3600,1);
% nonlcon=[];
% [params,fval,exitflag,output] = fmincon(objective,params,A,b,Aeq,beq,lb,ub,nonlcon,options);
[params,fval,exitflag,output]=fminunc(objective,params,options);
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