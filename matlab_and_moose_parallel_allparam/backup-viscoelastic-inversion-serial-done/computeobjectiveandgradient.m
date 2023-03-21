% This function if returning the value of the objective functional and the
% gradient vector
function [function_value,gradient_vector]=computeobjectiveandgradient(params)
global inputs output
%loop over all frequencies
nfreq=length(inputs.freqs);
function_value=0;
gradient_vector=zeros(length(inputs.params0),1);
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

executemoose(inputs.mooseforwardinputfilename,frequncy);%solve for the forward solution
% Inside the following function, call another function to read the output wavefield, then use it to compute the objective function value
function_value=function_value+computeobjectivevalue(ifreq);
executemoose(inputs.mooseadjointinputfilename,frequncy);%solve for the adjoint solution
moosepostprocess(inputs.moosegradientinputfilename);%postprocess for the gradient computation
% grad_all=2.*readgradientvector();
grad_all=readgradientvector();
gradient_vector=gradient_vector+grad_all(inputs.parameter_index_vector);% see the formulation to see why we multiply by 2.
end
end