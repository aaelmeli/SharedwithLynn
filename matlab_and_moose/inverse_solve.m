clear all 
close all
clc
global inputs syntheticdata output
inputs.moosesyntheticinputfilename='3D_synthetic_viscoelastic_waves.i';
inputs.mooseforwardinputfilename='3D_forward_viscoelastic_waves.i';
inputs.mooseadjointinputfilename='3D_adjoint_viscoelastic_waves.i';
inputs.moosegradientinputfilename='3D_compute_gradient_viscoelastic_waves.i';

% names of directories that contain the data for each frequency 
inputs.moosesyntheticdirectory='_synthetic_viscoelastic_waves';
inputs.mooseforwarddirectory='_forward_viscoelastic_waves';
inputs.mooseadjointdirectory='_adjoint_viscoelastic_waves';
inputs.moosegradientdirectory='grad_computation_viscoelastic_waves';

inputs.materialfilename=["storage_modulus_dist.txt";"loss_modulus_dist.txt"];% the file the allways has material distribution - parameters estimates 
inputs.omega_bar=15000; % needed to compute G= G_eff *(1+ i*omega/omega_bar, G_r=G_eff*1, G_i=G_eff*omega/omega_bar
inputs.mesh.dim=3;
inputs.mesh.nx=20;
inputs.mesh.ny=20;
inputs.mesh.nz=20;
inputs.mesh.xmin=0;
inputs.mesh.ymin=0;
inputs.mesh.zmin=0;
inputs.mesh.xmax=0.03;
inputs.mesh.ymax=.03;
inputs.mesh.zmax=.03;
inputs.nrcv=315; % number of receivers
% inputs.nrcv=192; % number of receivers
inputs.mesh.dx=(inputs.mesh.xmax-inputs.mesh.xmin)/inputs.mesh.nx;
inputs.mesh.dy=(inputs.mesh.ymax-inputs.mesh.ymin)/inputs.mesh.ny;
inputs.mesh.dz=(inputs.mesh.zmax-inputs.mesh.zmin)/inputs.mesh.nz;

inputs.freqs=200:25:300; %the frequency range, in Hz.
output.wavefieldoutputfilename_real='_wavefield_real_rcv_0002.csv'; %name of the file that contains the synthetic/forward real wavefield
output.wavefieldoutputfilename_imag='_wavefield_imag_rcv_0002.csv'; %name of the file that contains the syntheticpa/forward imaginary wavefield
output.wavefieldoutputdirectoryname='3D_synthetic_viscoelastic_waves';
% params=25.*ones(inputs.mesh.nx*inputs.mesh.ny,1); %here, this can be a function that generate velocity models of any shape (i.e. star shape tumor velocity model)

%initial parameters

nx=20;nz=20;ny=20;
inputs.nparamx=nx;
inputs.nparamz=nz;
inputs.nparamy=ny;
xmin=0;xmax=0.03;
zmin=0;zmax=0.03;
ymin=0;ymax=0.03;
dx=xmax/nx;
dz=zmax/nz;
dy=ymax/ny;
x = (xmin+dx/2:(xmax-xmin-dx)/(nx-1):xmax-dx/2).';%do I need to change this to be consistent with moose input file, i.e (left,left,left) and nodes coordinates
z = (zmin+dz/2:(zmax-zmin-dz)/(nz-1):zmax-dz/2).';
y = (ymin+dy/2:(ymax-ymin-dy)/(ny-1):ymax-dy/2).';
% velocity = sqrt(p(1,1)/rho)*ones(nx).';
velocity = 25*ones(nx,ny,nz);
[X, Y, Z] = meshgrid(x,y,z);
x0 = xmax/2;
z0 = zmax/2;
y0 = ymax/2;
r0 = 0.007;
R=r0; %this is the radius of the R.O.I, this contains the parameters to be considered in inversion
ind = sqrt((X-x0).^2+(Y-y0).^2+(Z-z0).^2) <= r0;
ind_inversion=sqrt((X-x0).^2+(Y-y0).^2+(Z-z0).^2) <= R;% indicies of the inversion parameters.
map_param = zeros(nx,ny,nz);
element_ID=zeros(nx,ny,nz);% matrix contains the element ids same as moose ids
n=0;
for k=1:nz
    for i=1:nx
        for j=1:ny
        n=n+1;
        element_ID(ny-i+1,j,nz-k+1)=n;%this has to follow the numbering of the element in moose
        end
    end
end
map_param(ind_inversion)=element_ID(ind_inversion); %this is matrix that contains the element ids corresponds to the inversion parameters.
nparam=0;
parameters_map=[];
for k=1:nz
    for i=1:nx
        for j=1:ny
            if(map_param(i,j,k)~=0)
                ii=ny-i+1; jj=j; kk= nz-k+1; id=map_param(ii,j,kk);%check this
                nparam=nparam+1;
                parameters_map(nparam,:)=[ii,jj,kk,id];%check this
                
            end
        end
    end
end
%initial guess
params0=50.*ones(nparam,1);
% params0=[1:1:8]';
% for (i=1:616)
%     row=parameters_map(i,1); column=parameters_map(i,2);
%     velocity(row,column)=params0(i);
% end
ind =sqrt((X-x0).^2+(Y-y0).^2+(Z-z0).^2) <= R;
inputs.velocity=velocity;
inputs.velocity(ind)=-1;
inputs.parameters_map=parameters_map;
inputs.map_param=map_param;
params=[];
for k=1:nz
    for i=1:nx
        row=inputs.velocity(nx-i+1,:,nz-k+1);
%         row=inputs.velocity(nz-i+1,:);
        params=[params;row'];
    end    
end
parameter_index_vector=find(params==-1);
inputs.parameter_index_vector=parameter_index_vector;
inputs.params0=params0;
param=80.*ones(nparam,1);
% param=[1:1:8]';

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
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','SpecifyObjectiveGradient',true, 'TolFun',1e-9,'MaxIterations',40);
tic;
[params,fval,exitflag,output]=fminunc(objective,params0,options);
toc;