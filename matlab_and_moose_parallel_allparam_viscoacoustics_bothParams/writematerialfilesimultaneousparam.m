%this function write the current estimate of the parameters into an ASCII
%file to be read by moose. This file must named  material_distributin.data
function []=writematerialfilesimultaneousparam(params0,omega,Inputs)
params=[];
params1=[];
params2=[];
size=length(params0);
param1=params0(1:size/2,1); %storage parameter
param2=params0((size/2)+1:end,1); %loss parameter
%  param1=params0; %in case only inverting for E
velocity1=Inputs.velocity1;
velocity2=Inputs.velocity2;
for i=1:length(Inputs.parameters_map)
    row=Inputs.parameters_map(i,1); column=Inputs.parameters_map(i,2);
    velocity1(row,column)=param1(i);
    velocity2(row,column)=param2(i);
end
for i=1:Inputs.nparamx
        row1=velocity1(Inputs.nparamz-i+1,:);
        params1=[params1;row1'];
        row2=velocity2(Inputs.nparamz-i+1,:);
        params2=[params2;row2']; 
end


    dx=Inputs.mesh.dx;
    dy=Inputs.mesh.dy;
    xmin=Inputs.mesh.xmin;
    xmax=Inputs.mesh.xmax;
    ymin=Inputs.mesh.ymin;
    ymax=Inputs.mesh.ymax;
    xcoord=xmin:dx:xmax-dx;
    ycoord=ymin:dy:ymax-dy;
    
if Inputs.mesh.dim==3
    dz=Inputs.mesh.dz;
    zmin=Inputs.mesh.zmin;
    zmax=Inputs.mesh.zmax;
    zcoord=zmin:dz:zmax-dz;
end 

% write the storage material file 
    char1= '_freq';
    char2=int2str(labindex);
    directoryname=append(char1,char2);
    storage_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    loss_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    storage_filename=append(storage_filename,directoryname,'\',Inputs.materialfilename(1));
    loss_filename=append(loss_filename,directoryname,'\',Inputs.materialfilename(2));

    storage_derivative_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    storage_derivative_filename=append(storage_derivative_filename,directoryname,'\',Inputs.materialderivativefilename(1));
    
    loss_derivative_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    loss_derivative_filename=append(loss_derivative_filename,directoryname,'\',Inputs.materialderivativefilename(2));
    
    fileID1=fopen(storage_filename,'wt'); %TODO: the name of the file needed to be dynamic
    fileID2=fopen(loss_filename,'wt'); %TODO: the name of the file needed to be dynamic

    fileID3=fopen(storage_derivative_filename,'wt');
    fileID4=fopen(loss_derivative_filename,'wt');
    
    fprintf(fileID1,'%s\n\n','AXIS X');
    fprintf(fileID2,'%s\n\n','AXIS X');
    fprintf(fileID3,'%s\n\n','AXIS X');
    fprintf(fileID4,'%s\n\n','AXIS X');
    nx=length(xcoord);
    for i=1:nx
    fprintf(fileID1,'%.6f',xcoord(i));
    fprintf(fileID2,'%.6f',xcoord(i));
    fprintf(fileID3,'%.6f',xcoord(i));
    fprintf(fileID4,'%.6f',xcoord(i));
    
    fprintf(fileID1,' ');
    fprintf(fileID2,' ');
    fprintf(fileID3,' ');
    fprintf(fileID4,' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID3,'\n\n');
    fprintf(fileID4,'\n\n');
    
    fprintf(fileID1,'%s\n\n','AXIS Y');
    fprintf(fileID2,'%s\n\n','AXIS Y');
    fprintf(fileID3,'%s\n\n','AXIS Y');
    fprintf(fileID4,'%s\n\n','AXIS Y');
    ny=length(ycoord);
    for i=1:ny
    fprintf(fileID1,'%.6f',ycoord(i));
    fprintf(fileID2,'%.6f',ycoord(i));
    fprintf(fileID3,'%.6f',ycoord(i));
    fprintf(fileID4,'%.6f',ycoord(i));
    
    fprintf(fileID1,' ');
    fprintf(fileID2,' ');
    fprintf(fileID3,' ');
    fprintf(fileID4,' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID3,'\n\n');
    fprintf(fileID4,'\n\n');
if Inputs.mesh.dim==3
    fprintf(fileID1,'%s\n\n','AXIS Z');
    fprintf(fileID2,'%s\n\n','AXIS Z');
    fprintf(fileID3,'%s\n\n','AXIS Z');
    fprintf(fileID4,'%s\n\n','AXIS Z');
    nz=length(zcoord);
    for i=1:nz
    fprintf(fileID1,'%.6f',zcoord(i));
    fprintf(fileID2,'%.6f',zcoord(i));
    fprintf(fileID3,'%.6f',zcoord(i));
    fprintf(fileID4,'%.6f',zcoord(i));
    fprintf(fileID1,' ');
    fprintf(fileID2,' ');
    fprintf(fileID3,' ');
    fprintf(fileID4,' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID3,'\n\n');
    fprintf(fileID4,'\n\n');
end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID3,'\n\n');
    fprintf(fileID4,'\n\n');
    
    fprintf(fileID1,'%s\n\r','DATA');
    fprintf(fileID2,'%s\n\r','DATA');
    fprintf(fileID3,'%s\n\r','DATA');
    fprintf(fileID4,'%s\n\r','DATA');
%     fprintf(fileID,'\n');
    ndata=length(params1);
    for i=1:ndata
    fprintf(fileID1,'%.6f',10^(params1(i))); %10^params(i) because the parameter here is assumed to be log(E_r)
    fprintf(fileID2,'%.6f',10^(params2(i))*(omega));
    fprintf(fileID3,'%.6f',10^(params1(i))*log(10));
    fprintf(fileID4,'%.6f',10^(params2(i))*log(10)*(omega)); %check this
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID3,'\n\n');
    fprintf(fileID4,'\n\n');
    end
    fclose(fileID1);
    fclose(fileID2);
    fclose(fileID3);
    fclose(fileID4);
end