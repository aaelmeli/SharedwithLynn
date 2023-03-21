function []=syntheticdatasolve(params)
global inputs syntheticdata output
Inputs=inputs;
Output=output;
nrcv=inputs.nrcv;
% Syntheticdata=syntheticdata;
real_=zeros(nrcv,length(inputs.freqs));
imag_=zeros(nrcv,length(inputs.freqs));
data=zeros(nrcv,1);
%In parallel - execute moose application - compute the forward solution

    storage_filename=inputs.materialfilename(1);
    loss_filename=inputs.materialfilename(2);
    syntheticinputfilename=inputs.moosesyntheticinputfilename;
    
freqs=inputs.freqs;
nfreq=length(freqs);
tic;
spmd(length(inputs.freqs))
% for ifreq=1:nfreq
frequncy=freqs(labindex);
% frequncy=freqs(ifreq);
%write the parameters file.
writematerialfile(params,2*pi()*frequncy,Inputs); %do I need to pass the labindex as well
%convert the parameters file from dos to unix format
filename.storage=storage_filename;
filename.loss=loss_filename;
convertdos2unix(filename);%converts storage and loss files to unix and transfer them to windows 
% convertdos2unix(loss_filename);%loss
% % %copy the material file to moose application directory
% copy2linux(storage_filename);%storage
% copy2linux(loss_filename);%loss

executemoose(syntheticinputfilename,frequncy);
% copy2windows(Output);

data=readwavefieldoutput(Inputs.moosesyntheticdirectory,Output.wavefieldoutputfilename_real);
% data=[data{:}];
real_temp=data(:,1);
data=readwavefieldoutput(Inputs.moosesyntheticdirectory,Output.wavefieldoutputfilename_imag);
imag_temp=data(:,1);
complex_temp=real_temp+1i.*imag_temp;
data(:,1)=awgn(complex_temp,10,'measured'); %add additive white gaussian
real_(:,labindex)=real(data(:,1));
imag_(:,labindex)=imag(data(:,1));
Real=gcat(real_(:,labindex));% all processors have same combined matirx (this is similar to sending and receiving data across all workers).
Imag=gcat(imag_(:,labindex));

end
% end
toc;
syntheticdata.real=Real{:,:};
syntheticdata.imag=Imag{:,:};
end