function [wavefieldatreceivers,coord]=readwavefieldoutput(moosedirectory,mooseoutputfilename)
char1='_freq';
char2=int2str(labindex);
directoryname=append(char1,char2);
filename=append(directoryname,'/',moosedirectory,'/',mooseoutputfilename);
% \\wsl$\Ubuntu-20.04\home\aaelmeli\projects\first_test\_freq1\_forward_viscoelastic_waves
% tic;
A = readmatrix(['/home/elmeabde/sawtooth1/projects/first_test/' filename '']);
% toc;
wavefieldatreceivers=A(:,2);
coord=A(:,3:end);
end