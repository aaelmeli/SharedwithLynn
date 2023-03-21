clc
close all
clear all



nx=30;nz=30;
xmin=0;xmax=0.03;zmin=0;zmax=0.03;dx=xmax/nx;dz=zmax/nz;
x = (xmin+dx/2:(xmax-xmin-dx)/(nx-1):xmax-dx/2).';
z = (zmin+dz/2:(zmax-zmin-dz)/(nz-1):zmax-dz/2).';
velocity1 = log10(5e3)*ones(nx).';
velocity2 = log10(1).*ones(nx).';
[X, Z] = meshgrid(x,z);
x0 = xmax/2;
z0 = zmax/2;
r0 = 0.005;
R=r0; %this is the radius of the R.O.I, this contains the parameters to be considered in inversion
ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0;
theta1=pi()/1;
theta2=pi()/4;
x1=0.015;
z1=0.015;
r1=0.002;
x2=0.015;
z2=0.015;
r2=0.007;
a1=1;
b1=1;
a2=1;
b2=1;
ind1 = sqrt((((X-x1)*cos(theta1)+(Z-z1)*sin(theta1)).^2)/a1^2+(((X-x1)*sin(theta1)-(Z-z1)*cos(theta1)).^2)/b1^2) <= r1;
% ind2 = sqrt((((X-x2)*cos(theta2)+(Z-z2)*sin(theta2)).^2)/a2^2+(((X-x2)*sin(theta2)-(Z-z2)*cos(theta2)).^2)/b2^2) <= r2;
ind2 = sqrt((X-x2).^2+(Z-z2).^2) <= r2;
velocity1(ind2)=log10(26.67e3);
velocity1(ind)=log10(15e3);
velocity1(ind1)=log10(5e3);


velocity1= smoothdata(velocity1,2,'gaussian',6);
velocity1= smoothdata(velocity1,1,'gaussian',6);
pcolor(x,z',velocity1');



omega=50*pi()*2;
nparamx=nx;
nparamz=nz;
params1=[];
params2=[];
for i=1:nparamx
        row1=velocity1(nparamz-i+1,:);
        params1=[params1;row1'];
        row2=velocity2(nparamz-i+1,:);
        params2=[params2;row2']; 
end


    dy=dz;
    ymin=zmin;
    ymax=zmax;
    xcoord=xmin:dx:xmax-dx;
    ycoord=ymin:dy:ymax-dy;


% write the storage material file 
    char1= '_freq';
    char2=int2str(labindex);
    directoryname=append(char1,char2);
    storage_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    loss_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    storage_filename=append(storage_filename,directoryname,'\','shearmodulus_dist.txt');
    loss_filename=append(loss_filename,directoryname,'\','viscosity_dist.txt');

    storage_derivative_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    storage_derivative_filename=append(storage_derivative_filename,directoryname,'\','shearmodulus_dist_differentiated.txt');
    
    loss_derivative_filename='E:\3D_SWE_MOOSE\matlab_and_moose_parallel_allparam_viscoacoustics_bothParams\';
    loss_derivative_filename=append(loss_derivative_filename,directoryname,'\','viscosity_dist_differentiated.txt');
    
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
% if Inputs.mesh.dim==3
%     fprintf(fileID1,'%s\n\n','AXIS Z');
%     fprintf(fileID2,'%s\n\n','AXIS Z');
%     fprintf(fileID3,'%s\n\n','AXIS Z');
%     fprintf(fileID4,'%s\n\n','AXIS Z');
%     nz=length(zcoord);
%     for i=1:nz
%     fprintf(fileID1,'%.6f',zcoord(i));
%     fprintf(fileID2,'%.6f',zcoord(i));
%     fprintf(fileID3,'%.6f',zcoord(i));
%     fprintf(fileID4,'%.6f',zcoord(i));
%     fprintf(fileID1,' ');
%     fprintf(fileID2,' ');
%     fprintf(fileID3,' ');
%     fprintf(fileID4,' ');
%     end
%     fprintf(fileID1,'\n\n');
%     fprintf(fileID2,'\n\n');
%     fprintf(fileID3,'\n\n');
%     fprintf(fileID4,'\n\n');
% end
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
