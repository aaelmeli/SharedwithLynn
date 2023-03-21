clear all 
global inputs syntheticdata output
inputs.moosesyntheticinputfilename='synthetic_viscoelastic_waves.i';
inputs.mooseforwardinputfilename='forward_viscoelastic_waves.i';

% names of directories that contain the data fpr each frequency 
inputs.moosesyntheticdirectory='_synthetic_viscoelastic_waves';
inputs.mooseforwarddirectory='_forward_viscoelastic_waves';

inputs.omega_bar=1000; % needed to compute G= G_eff *(1+ i*omega/omega_bar, G_r=G_eff*1, G_i=G_eff*omega/omega_bar


freqs=[500:50:500]'; %the frequency range, in Hz.
output.wavefieldoutputfilename_real='_wavefield_real_rcv_0002.csv'; %name of the file that contains the synthetic/forward real wavefield
output.wavefieldoutputfilename_imag='_wavefield_imag_rcv_0002.csv'; %name of the file that contains the syntheticpa/forward imaginary wavefield
output.wavefieldoutputdirectoryname='_synthetic_viscoelastic_waves';


%initial parameters
nrcv=40;
meu=[1:0.5:12]';
eta=[0.1:0.1:1.8]';
% eta=[1:0.5:12]';
ni=length(meu);
nj=length(eta);
nfreq=length(freqs);
syntheticData.real=zeros(nrcv,nfreq);
syntheticData.imag=zeros(nrcv,nfreq);
%generate the synthetic data
for ifreq=1:nfreq
    params(1,1)=6; %compressional elasticity kPa
    params(2,1)=0.9; %compressional viscosity of Pa.s
    freq=freqs(ifreq,1);
    [real,imag]=forwardsolve(params,freq);
    syntheticData.real(:,ifreq)=real;
    syntheticData.imag(:,ifreq)=imag;
end
        
%compute the forward solution, and compute the misfit
values=zeros(ni,nj);
for i=1:ni
    for j=1:nj
        for ifreq=1:nfreq
            params(1,1)=meu(i,1);
            params(2,1)=eta(j,1);
            freq=freqs(ifreq,1);
            [real,imag]=forwardsolve(params,freq);
            n=1;
            u1=real+1i*imag; %forward
            d1=syntheticData.real(:,ifreq)+1i*syntheticData.imag(:,ifreq);%measurements
%             ud_correl=((u1'*d1)*(d1'*u1)).^n;
%             value=(1-(ud_correl)/((norm(d1)*norm(u1)))^(2*n));
              error=d1-u1;
              value=0.5*(error'*error);
            values(i,j)=value;
        end
    end
end
[X, Y] = meshgrid(meu,eta);
figure(7)
surf(X,Y,values')
matrix.Z=values;
matrix.X=X;
matrix.Y=Y;
save('L2MatIncViscoR7_500HZ.mat','matrix')

