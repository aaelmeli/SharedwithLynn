% This function if returning the value of the objective functional and the
% gradient vector
function [function_value_all,gradient_vector_all]=computeobjectiveandgradient(params)
global inputs output syntheticdata
%loop over all frequencies
nfreq=length(inputs.freqs);
function_value=0;
gradient_vector_ifreq=zeros(length(inputs.params0),1);
gradient1_vector_ifreq=zeros(length(inputs.params0)/2,1);
gradient2_vector_ifreq=zeros(length(inputs.params0)/2,1);
Inputs=inputs;
Output=output;
nrcv=inputs.nrcv;
%In parallel - execute moose application - compute the forward solution
    storage_filename=inputs.materialfilename(1);
    loss_filename=inputs.materialfilename(2);
storage_derivative_filename=inputs.materialderivativefilename(1);%in case of using parameterization other than E_r (e.g. Log(E_r) or sqrt(E_r))
loss_derivative_filename=inputs.materialderivativefilename(2);

forwardinputfilename=inputs.mooseforwardinputfilename;
adjointinputfilename=inputs.mooseadjointinputfilename;
gradientinputfilename=inputs.moosegradientinputfilename;
Syntheticdata.real=syntheticdata.real;
Syntheticdata.imag=syntheticdata.imag;    
freqs=inputs.freqs;
spmd(length(inputs.freqs))
% for ifreq=1:nfreq
frequncy=freqs(labindex);
% frequncy=freqs(ifreq);
%write the parameters file.
% writematerialfile(params,2*pi()*frequncy,Inputs); %do I need to pass the labindex as well
writematerialfilesimultaneousparam(params,2*pi()*frequncy,Inputs);
%convert the parameters file from dos to unix format
filename.storage=storage_filename;
filename.storagederivative=storage_derivative_filename;
filename.loss=loss_filename;
filename.lossderivative=loss_derivative_filename;

convertdos2unix(filename);% all files

function_value=0;
for ipush=1:Inputs.npush %start looping over pushed
sytheticdata_freq.real=Syntheticdata.real(:,ipush,labindex);
sytheticdata_freq.imag=Syntheticdata.imag(:,ipush,labindex);
    pushno = int2str(ipush);
    forwardinputfilename=append(Inputs.mooseforwardinputfilename,'_p',pushno,'.i'); % it is better to pass the ipush to a the excutemoose() and pass the ipush to the input through command line and not to hard write it.
    executemoose(forwardinputfilename,frequncy);%solve for the forward solution
outputipush.wavefieldoutputfilename_real=Output.wavefieldoutputfilename_real;
outputipush.wavefieldoutputfilename_imag=Output.wavefieldoutputfilename_imag;
outputipush.wavefieldoutputfilename_real=append(outputipush.wavefieldoutputfilename_real,'_p',pushno,'_0002.csv'); % we do not have to do this for every push since pushes are executed in series 
outputipush.wavefieldoutputfilename_imag=append(outputipush.wavefieldoutputfilename_imag,'_p',pushno,'_0002.csv');

% Inside the following function, call another function to read the output wavefield, then use it to compute the objective function value
[value]=computeobjectivevalue(labindex,Inputs.mooseforwarddirectory,outputipush,sytheticdata_freq);
function_value=function_value+value;
% function_value=function_value+computeobjectivevalue(labindex,Inputs.mooseforwarddirectory,outputipush,sytheticdata_freq);%pass labindex, only compute the corresponding objective function
% writemisfitcsvfile(misfit,ipush);
% adjointinputfilename=append(Inputs.mooseadjointinputfilename,'_p',pushno,'.i'); 
executemoose(adjointinputfilename,frequncy);%solve for the adjoint solution
moosepostprocess(gradientinputfilename);%postprocess for the gradient computation
% [grad1]=readgradientvector();
% [grad1,grad2]=readgradientvector();
% grad1_ifreq=2.*grad1;
% grad2_ifreq=2.*grad2;
% grad1_ifreq=grad1;
% grad2_ifreq=grad2;
grad_ifreq=2.*readgradientvector();
% gradient1_vector_ifreq=gradient1_vector_ifreq+grad1_ifreq(Inputs.parameter_index_vector);
% gradient2_vector_ifreq=gradient2_vector_ifreq+grad2_ifreq(Inputs.parameter_index_vector);
% gradient_vector_ifreq=[gradient1_vector_ifreq;gradient2_vector_ifreq];
% gradient_vector_ifreq=gradient_vector_ifreq+grad1_ifreq(Inputs.parameter_index_vector);
gradient_vector_ifreq=gradient_vector_ifreq+grad_ifreq(Inputs.parameter_index_vector);% see the formulation to see why we multiply by 2.
function_value_all_freq=gcat(function_value);
gradient_vector_all_freq=gcat(gradient_vector_ifreq);
end % end looping over pushes
end 
function_value_all=sum(function_value_all_freq{:,1});
gradient_vector_all=sum(gradient_vector_all_freq{:,1},2);
%combine the gradients and the objective function values from all workers
%(summ all of them)!
end