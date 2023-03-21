function [x]=inclusion2D(p,mesh)%this function is to take input of two parameters and map it to the FEM parameters.
nx=mesh.nx;nz=mesh.ny;
xmin=mesh.xmin;xmax=mesh.xmax;zmin=mesh.zmin;zmax=mesh.xmax;dx=xmax/nx;dz=zmax/nz;
x = (xmin+dx/2:(xmax-xmin-dx)/(nx-1):xmax-dx/2).';
z = (zmin+dz/2:(zmax-zmin-dz)/(nz-1):zmax-dz/2).';
velocity = p(1,1)*ones(nx).';
[X, Z] = meshgrid(x,z);
x0 =0.015;
z0 =0.015;
r0 = 0.007; %the median/average radius 
ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0+1/800*sin(6*atan((Z-z0)./(X-x0)));
%%+1/1000*cos(0*atan((Z-z0)./(X-x0)));
velocity(ind) = p(2,1);
ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0+1/1200*sin(3.5*atan((Z-z0)./(X-x0)));
velocity(ind) = p(2,1);
r0 = 0.006375;
ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0+1/300*sin(8*atan((Z-z0)./(X-x0)));
velocity(ind) = p(2,1);
% r0 = 0.5;
% ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0+1/10*sin(6*atan((Z)./(X)));
% velocity(ind) = sqrt(p(2,1)/rho); 
% velocity2=velocity;
% r0 = 0.5;
% ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0+1/15*sin(3.5*atan((Z)./(X)));
% velocity(ind) =  sqrt(p(2,1)/rho);
%% make it irregular shape.
% r0 = 0.45;
% ind = sqrt((X-x0).^2+(Z-z0).^2) <= r0+1/5*sin(8*atan((Z)./(X)));
% velocity(ind) =  sqrt(p(2,1)/rho);

filepat='E:\One_Subdomain_FEP\GitlaB-one-subdomain-case-checking\Inputs\true';
fileID=fopen('E:\One_Subdomain_FEP\GitlaB-one-subdomain-case-checking\Inputs\true\true.txt','wt');
fprintf(fileID,'%s\n','MODEL_GEN');
fprintf(fileID,'%s\n','UNIFORM');
fprintf(fileID,'%d %d\n',size(velocity,1), size(velocity,1));
fprintf(fileID,'%f %f\n',xmax/size(velocity,1), zmax/size(velocity,1));
numrows=size(velocity,1);
numcols=size(velocity,2);
k=1;
for i=numrows:-1:1
    datai=velocity(i,:)';
    coli=zeros(numcols,1); rowi=zeros(numcols,1);
    rowi(:)=k;
    coli=(1:numcols)';
    A=[rowi coli datai];
    for j=1:numcols
    fprintf(fileID,'%d %d %.12f\r\n',A(j,:));
    end
    k=k+1;
end
fprintf(fileID,'%s\n','_END_DATA_');
fclose(fileID);
end