function []=syntheticdatasolve(params)
global inputs syntheticdata output
Inputs=inputs;
Output=output;
nrcv=inputs.nrcv;
% Syntheticdata=syntheticdata;
real=zeros(nrcv,length(inputs.freqs));
imag=zeros(nrcv,length(inputs.freqs));
data=zeros(nrcv,1);
%In parallel - execute moose application - compute the forward solution

    storage_filename=inputs.materialfilename(1);
    loss_filename=inputs.materialfilename(2);
    storage_derivative_filename=inputs.materialderivativefilename(1);
    loss_derivative_filename=inputs.materialderivativefilename(2);
    
    syntheticinputfilename=inputs.moosesyntheticinputfilename;
    
    
freqs=inputs.freqs;
tic;
spmd(length(inputs.freqs))
% for ifreq=1:length(inputs.freqs)
%     frequncy=freqs(ifreq);
frequncy=freqs(labindex);
%write the parameters file.
% writematerialfile(params,2*pi()*frequncy,Inputs); %do I need to pass the labindex as well
writematerialfilesimultaneousparam(params,2*pi()*frequncy,Inputs); 
%convert the parameters file from dos to unix format
filename.storage=storage_filename;
filename.loss=loss_filename;
filename.storagederivative=storage_derivative_filename;
filename.lossderivative=loss_derivative_filename;
convertdos2unix(filename);%converts storage and loss files to unix and transfer them to windows 
% convertdos2unix(loss_filename);%loss
% % %copy the material file to moose application directory
% copy2linux(storage_filename);%storage
% copy2linux(loss_filename);%loss
for ipush=1:Inputs.npush % start looping over pushes
    pushno = int2str(ipush);
    syntheticinputfilename=append(Inputs.moosesyntheticinputfilename,'_p',pushno,'.i'); 
executemoose(syntheticinputfilename,frequncy);
%get real wavefield
%in case of noisy measurements, add noise here
wavefieldoutputfilename_real=append(Output.wavefieldoutputfilename_real,'_p',pushno,'_0002.csv'); %this takes care of multiple pushes
data=readwavefieldoutput(Inputs.moosesyntheticdirectory,wavefieldoutputfilename_real);
real(:,ipush,labindex)=data(:,1);
%get imaginary wavefield
wavefieldoutputfilename_imag=append(Output.wavefieldoutputfilename_imag,'_p',pushno,'_0002.csv'); %this takes care of multiple pushes
data=readwavefieldoutput(Inputs.moosesyntheticdirectory,wavefieldoutputfilename_imag);
imag(:,ipush,labindex)=data(:,1);

Real=gcat(real(:,:,labindex),3);% all processors have same combined matirx (this is similar to sending and receiving data across all workers).
Imag=gcat(imag(:,:,labindex),3);
end %end looping over pushes
% end
end
toc;
syntheticdata.real=Real{:,:,:};
syntheticdata.imag=Imag{:,:,:};
end