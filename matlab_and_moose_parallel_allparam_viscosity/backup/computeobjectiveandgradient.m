% This function if returning the value of the objective functional and the
% gradient vector
function [function_value,gradient_vector]=computeobjectiveandgradient(params)
global inputs output
writematerialfile(params);
%convert the parameters file from dos to unix format
convertdos2unix(inputs.materialfilename);
%copy the material file to moose application directory
copy2linux(inputs.materialfilename);
executemoose(inputs.mooseforwardinputfilename);%solve for the forward solution
% Inside the following function, call another function to read the output wavefield, then use it to compute the objective function value
function_value=computeobjectivevalue(output);
executemoose(inputs.mooseadjointinputfilename);%solve for the adjoint solution
executemoose(inputs.moosegradientinputfilename);%posprocess for the gradient computation
gradient_vector=readgradientvector();
end