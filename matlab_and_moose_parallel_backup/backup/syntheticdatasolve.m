function []=syntheticdatasolve(params)
global inputs syntheticdata output
%write the parameters file.
writematerialfile(params);
%convert the parameters file from dos to unix format
convertdos2unix(inputs.materialfilename);
%copy the material file to moose application directory
copy2linux(inputs.materialfilename);
%execute moose application - compute the forward solution
executemoose(inputs.moosesyntheticinputfilename);
copy2windows(output);
[data]=readwavefieldoutput(output.wavefieldoutputfilename);
syntheticdata=data(:,1);
end