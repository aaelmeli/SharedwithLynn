%this function write the current estimate of the parameters into an ASCII
%file to be read by moose. This file must named  material_distributin.data
function []=writematerialfile(params0,omega)
global inputs
params=[];
velocity=inputs.velocity;
for i=1:length(inputs.parameters_map)
    row=inputs.parameters_map(i,1); column=inputs.parameters_map(i,2);
    velocity(row,column)=params0(i);
end
for i=1:inputs.nparamx
        row=velocity(inputs.nparamz-i+1,:);
        params=[params;row']; 
end

    dx=inputs.mesh.dx;
    dy=inputs.mesh.dy;
    xmin=inputs.mesh.xmin;
    xmax=inputs.mesh.xmax;
    ymin=inputs.mesh.ymin;
    ymax=inputs.mesh.ymax;
    xcoord=xmin:dx:xmax-dx;
    ycoord=ymin:dy:ymax-dy;
if inputs.mesh.dim==3
    dz=inputs.mesh.dz;
    zmin=inputs.mesh.zmin;
    zmax=inputs.mesh.zmax;
    zcoord=zmin:dz:zmax-dz;
end 
% write the storage material file 
    fileID1=fopen('E:\3D_SWE_MOOSE\matlab_and_moose\storage_modulus_dist.txt','wt'); %TODO: the name of the file needed to be dynamic
    fileID2=fopen('E:\3D_SWE_MOOSE\matlab_and_moose\loss_modulus_dist.txt','wt'); %TODO: the name of the file needed to be dynamic
    fprintf(fileID1,'%s\n\n','AXIS X');
    fprintf(fileID2,'%s\n\n','AXIS X');
    nx=length(xcoord);
    for i=1:nx
    fprintf(fileID1,'%.6f',xcoord(i));
    fprintf(fileID2,'%.6f',xcoord(i));
    fprintf(fileID1,' ');
    fprintf(fileID2,' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID1,'%s\n\n','AXIS Y');
    fprintf(fileID2,'%s\n\n','AXIS Y');
    ny=length(ycoord);
    for i=1:ny
    fprintf(fileID1,'%.6f',ycoord(i));
    fprintf(fileID2,'%.6f',ycoord(i));
    fprintf(fileID1,' ');
    fprintf(fileID2,' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
if inputs.mesh.dim==3
    fprintf(fileID1,'%s\n','AXIS Z');
    fprintf(fileID2,'%s\n','AXIS Z');
    fprintf(fileID1,'%.6f\n',zcoord);
    fprintf(fileID2,'%.6f\n',zcoord);
end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    fprintf(fileID1,'%s\n\r','DATA');
    fprintf(fileID2,'%s\n\r','DATA');
%     fprintf(fileID,'\n');
    ndata=length(params);
    for i=1:ndata
%         if(inputs.params0(i)==10)
%             params(i)=10;
%         end
    fprintf(fileID1,'%.6f',params(i));
    fprintf(fileID2,'%.6f',params(i)*(omega/inputs.omega_bar));
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    end
    fclose(fileID1);
     fclose(fileID2);
end