%this function write the current estimate of the parameters into an ASCII
%file to be read by moose. This file must named  material_distributin.data
function []=writematerialfile(params0,omega,Inputs)
    iter = accumulate(1);
% global inputs
params=[];
velocity=Inputs.velocity;
for i=1:length(Inputs.parameters_map)
    ii=Inputs.parameters_map(i,1); jj=Inputs.parameters_map(i,2);kk=Inputs.parameters_map(i,3);
    velocity(ii,jj,kk)=params0(i); %this is used to cast the inversion parameters into the velocity/material model (to be written in text file).
end
%this is only valid for a structured mesh, the sequence that I follow in parameter indexing is the same as the sequence of element numbering in moose
for k=1:Inputs.nparamz
    for i=1:Inputs.nparamx
        row=velocity(Inputs.nparamx-i+1,:,Inputs.nparamz-k+1);
        params=[params;row']; 
    end
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
    storage_filename = '/home/elmeabde/sawtooth1/projects/matlabMooseWrapper/matlab_and_moose/';
    loss_filename = '/home/elmeabde/sawtooth1/projects/matlabMooseWrapper/matlab_and_moose/';
    storage_filename=append(storage_filename,directoryname,'/',Inputs.materialfilename(1));
    loss_filename=append(loss_filename,directoryname,'/',Inputs.materialfilename(2));

    %write the material files at each function call
    char3 = int2str(iter - 1);
    storage_filename_iter = append(storage_filename, '_', char3);
    loss_filename_iter = append(loss_filename, '_', char3);

    fileID1=fopen(storage_filename,'wt'); %TODO: the name of the file needed to be dynamic
    fileID2=fopen(loss_filename,'wt'); %TODO: the name of the file needed to be dynamic

    fileID5 = fopen(storage_filename_iter, 'wt'); %TODO: the name of the file needed to be dynamic
    fileID6 = fopen(loss_filename_iter, 'wt'); %TODO: the name of the file needed to be dynamic
    
    fprintf(fileID1,'%s\n\n','AXIS X');
    fprintf(fileID2,'%s\n\n','AXIS X');


    fprintf(fileID5, '%s\n\n', 'AXIS X');
    fprintf(fileID6, '%s\n\n', 'AXIS X');
    nx=length(xcoord);
    for i=1:nx
        %write the x-coordinates
    fprintf(fileID1,'%.6f',xcoord(i));
    fprintf(fileID2,'%.6f',xcoord(i));

    fprintf(fileID5, '%.6f', xcoord(i));
    fprintf(fileID6, '%.6f', xcoord(i));
    
    %insert white space

    fprintf(fileID1,' ');
    fprintf(fileID2,' ');

    fprintf(fileID5, ' ');
    fprintf(fileID6, ' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');

    fprintf(fileID5, '\n\n');
    fprintf(fileID6, '\n\n');
    fprintf(fileID1,'%s\n\n','AXIS Y');
    fprintf(fileID2,'%s\n\n','AXIS Y');

    fprintf(fileID5,'%s\n\n','AXIS Y');
    fprintf(fileID6, '%s\n\n', 'AXIS Y');
    ny=length(ycoord);
    for i=1:ny
    fprintf(fileID1,'%.6f',ycoord(i));
    fprintf(fileID2,'%.6f',ycoord(i));

    fprintf(fileID5, '%.6f', ycoord(i));
    fprintf(fileID6, '%.6f', ycoord(i));

    fprintf(fileID1,' ');
    fprintf(fileID2,' ');

    fprintf(fileID5, ' ');
    fprintf(fileID6, ' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');

    fprintf(fileID5, '\n\n');
    fprintf(fileID6, '\n\n');
if Inputs.mesh.dim==3
    fprintf(fileID1,'%s\n\n','AXIS Z');
    fprintf(fileID2,'%s\n\n','AXIS Z');

    fprintf(fileID5, '%s\n\n', 'AXIS Z');
    fprintf(fileID6, '%s\n\n', 'AXIS Z');
    nz=length(zcoord);
    for i=1:nz
    fprintf(fileID1,'%.6f',zcoord(i));
    fprintf(fileID2,'%.6f',zcoord(i));

    fprintf(fileID5,'%.6f',zcoord(i));
    fprintf(fileID6, '%.6f', zcoord(i));

    fprintf(fileID1,' ');
    fprintf(fileID2,' ');

    fprintf(fileID5, ' ');
    fprintf(fileID6, ' ');
    end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');

    fprintf(fileID5, '\n\n');
    fprintf(fileID6, '\n\n');
end
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');

    fprintf(fileID5, '\n\n');
    fprintf(fileID6, '\n\n');

    fprintf(fileID1,'%s\n\r','DATA');
    fprintf(fileID2,'%s\n\r','DATA');

    fprintf(fileID5, '%s\n\r', 'DATA');
    fprintf(fileID6, '%s\n\r', 'DATA');
%     fprintf(fileID,'\n');
    ndata=length(params);
    for i=1:ndata
%         if(Inputs.params0(i)==10)
%             params(i)=10;
%         end
    fprintf(fileID1,'%.6f',params(i));
    fprintf(fileID2,'%.6f',params(i)*(omega/Inputs.omega_bar));
    fprintf(fileID1,'\n\n');
    fprintf(fileID2,'\n\n');
    end
    fclose(fileID1);
     fclose(fileID2);
end

function currentiter = accumulate(iter)
    persistent iternum

    if isempty(iternum)
        iternum = iter;
    else
        iternum = iternum + iter;
    end

    currentiter = iternum;
end
