% This function if returning the value of the objective functional and the
% gradient vector
function [functio_nvalue,gradient_vector]=computeobjectiveandgradient(params)
WriteMaterialFileWsl(params);
executemoose();
% Inside the following function, call another function to read the output wavefield, then use it to compute the objective function value
functio_nvalue=computeobjectivevalue();
gradient_vector=ReadGradientVectorWsl();
end