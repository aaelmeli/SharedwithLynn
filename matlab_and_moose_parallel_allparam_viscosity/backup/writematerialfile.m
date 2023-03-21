%this function write the current estimate of the parameters into an ASCII
%file to be read by moose. This file must named  material_distributin.data
function []=writematerialfile(params)
global inputs
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
    fileID=fopen('E:\3D_SWE_MOOSE\matlab_and_moose\data1.txt','wt');
    fprintf(fileID,'%s\n\n','AXIS X');
    nx=length(xcoord);
    for i=1:nx
    fprintf(fileID,'%.6f',xcoord(i));
    fprintf(fileID,' ');
    end
    fprintf(fileID,'\n\n');
    fprintf(fileID,'%s\n\n','AXIS Y');
    ny=length(ycoord);
    for i=1:ny
    fprintf(fileID,'%.6f',ycoord(i));
    fprintf(fileID,' ');
    end
    fprintf(fileID,'\n\n');
if inputs.mesh.dim==3
    fprintf(fileID,'%s\n','AXIS Z');
    fprintf(fileID,'%.6f\n',zcoord);
end
    fprintf(fileID,'\n\n');
    fprintf(fileID,'%s\n\r','DATA');
%     fprintf(fileID,'\n');
    ndata=length(params);
    for i=1:ndata
    fprintf(fileID,'%.6f',params(i));
    fprintf(fileID,'\n\n');
    end
    fclose(fileID);
end