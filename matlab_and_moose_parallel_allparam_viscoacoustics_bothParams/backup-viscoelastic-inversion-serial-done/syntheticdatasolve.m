function []=syntheticdatasolve(params)
global inputs syntheticdata output

%execute moose application - compute the forward solution
nfreq=length(inputs.freqs);
for ifreq=1:nfreq
frequncy=inputs.freqs(ifreq);

%write the parameters file.
writematerialfile(params,2*pi()*frequncy);
%convert the parameters file from dos to unix format
convertdos2unix(inputs.materialfilename(1));%storage
convertdos2unix(inputs.materialfilename(2));%loss
%copy the material file to moose application directory
copy2linux(inputs.materialfilename(1));%storage
copy2linux(inputs.materialfilename(2));%loss

executemoose(inputs.moosesyntheticinputfilename,frequncy);
copy2windows(output);
[data]=readwavefieldoutput(output.wavefieldoutputfilename_real);
syntheticdata.real(:,ifreq)=data(:,1);
[data]=readwavefieldoutput(output.wavefieldoutputfilename_imag);
syntheticdata.imag(:,ifreq)=data(:,1);
end
end