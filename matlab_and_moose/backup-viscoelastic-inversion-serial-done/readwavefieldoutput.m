function [wavefieldatreceivers]=readwavefieldoutput(filename)A=xlsread(filename);wavefieldatreceivers=A(:,2:end);end