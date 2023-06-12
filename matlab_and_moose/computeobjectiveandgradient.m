% This function if returning the value of the objective functional and the
% gradient vector
function [function_value_all,gradient_vector_all]=computeobjectiveandgradient(params)
global inputs output syntheticdata
%loop over all frequencies
nfreq=length(inputs.freqs);
function_value=0;
gradient_vector_ifreq=zeros(length(inputs.params0),1);
Inputs=inputs;
Output=output;
nrcv=inputs.nrcv;
%In parallel - execute moose application - compute the forward solution
    storage_filename=inputs.materialfilename(1);
    loss_filename=inputs.materialfilename(2);
forwardinputfilename=inputs.mooseforwardinputfilename;
adjointinputfilename=inputs.mooseadjointinputfilename;
gradientinputfilename=inputs.moosegradientinputfilename;
Syntheticdata.real=syntheticdata.real;
Syntheticdata.imag=syntheticdata.imag;    
freqs=inputs.freqs;
spmd(length(inputs.freqs))
% for ifreq=1:nfreq
frequncy=freqs(labindex);

%write the parameters file.
writematerialfile(params,2*pi()*frequncy,Inputs); %do I need to pass the labindex as well
%convert the parameters file from dos to unix format
filename.storage=storage_filename;
filename.loss=loss_filename;
copy2mooseproj(filename); %storage
% convertdos2unix(loss_filename);%loss
% %copy the material file to moose application directory
% copy2linux(storage_filename);%storage
% copy2linux(loss_filename);%loss
sytheticdata_freq.real=Syntheticdata.real(:,labindex);
sytheticdata_freq.imag=Syntheticdata.imag(:,labindex);

executemoose(forwardinputfilename,frequncy);%solve for the forward solution


% Inside the following function, call another function to read the output wavefield, then use it to compute the objective function value
function_value=function_value+computeobjectivevalue(labindex,Inputs.mooseforwarddirectory,Output,sytheticdata_freq);%pass labindex, only compute the corresponding objective function

executemoose(adjointinputfilename,frequncy);%solve for the adjoint solution
moosepostprocess(gradientinputfilename);%postprocess for the gradient computation
grad_ifreq=2.*readgradientvector();
% grad_ifreq=readgradientvector();
gradient_vector_ifreq=gradient_vector_ifreq+grad_ifreq(Inputs.parameter_index_vector);% see the formulation to see why we multiply by 2.
function_value_all_freq=gcat(function_value);
gradient_vector_all_freq=gcat(gradient_vector_ifreq);
end
function_value_all=sum(function_value_all_freq{:,1});
gradient_vector_all=sum(gradient_vector_all_freq{:,1},2);
%combine the gradients and the objective function values from all workers
%(summ all of them)!
end