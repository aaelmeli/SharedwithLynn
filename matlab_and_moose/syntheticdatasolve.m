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
        % storage_derivative_filename = inputs.materialderivativefilename(1);
        % loss_derivative_filename = inputs.materialderivativefilename(2);
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
%get the current material (parameters) distribution file
filename.storage=storage_filename;
filename.loss=loss_filename;
%get the derivative of the current material with respect to the parameter
% filename.storagederivative = storage_derivative_filename;
% filename.lossderivative = loss_derivative_filename;

copy2mooseproj(filename); %converts storage and loss files to unix and transfer them to windows
%here, we can add more pushes so that we invert for all the pushes simultaneously
executemoose(syntheticinputfilename,frequncy);
%get the real
data=readwavefieldoutput(Inputs.moosesyntheticdirectory,Output.wavefieldoutputfilename_real);
real_proci=data(:,1);
%get the imag
data=readwavefieldoutput(Inputs.moosesyntheticdirectory,Output.wavefieldoutputfilename_imag);
imag_proci = data(:, 1);
%combine real and imaginary to get the complex wavefield
synth = real_proci + 1i .* imag_proci;
%you may add some awgn noise
% synth= awgn(synth, 10, 'measured'); %add additive white gaussian

%collect the data based on the labindex (or the processors number)
real_(:, labindex) = real(synth(:, :));
imag_(:, labindex) = imag(synth(:, :));
%make all the processors have the same data (entire wavefield over all processors)
Real=gcat(real_(:,labindex));
Imag=gcat(imag_(:,labindex));

end
% end
toc;
syntheticdata.real=Real{:,:};
syntheticdata.imag=Imag{:,:};
end