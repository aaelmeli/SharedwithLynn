function []=preprocessor()
global inputs
% nfreq=length(inputs.freqs);
syntheticdirectory=inputs.moosesyntheticdirectory;
forwarddirectory=inputs.mooseforwarddirectory;
adjointdirectory=inputs.mooseadjointdirectory;
gradientdirectory=inputs.moosegradientdirectory;

sytheticinputfilename=inputs.moosesyntheticinputfilename;
forwardinputfilename=inputs.mooseforwardinputfilename;
adjointinputfilename=inputs.mooseadjointinputfilename;
gradientinputfilename=inputs.moosegradientinputfilename;
spmd(length(inputs.freqs))
    bashcmd = 'start /b bash -c '; % WSL
    directoryname='_freq';
    chr = int2str(labindex);
    directoryname=append(directoryname,chr); 
    
        
    %on windows
    runcmd = ['" mkdir -p ' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
    %on wsl
    runcmd = ['" cd  /home/aaelmeli/projects/first_test && mkdir -p ' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end

    
    %copy the executable into each of the directories, make sure that
    %this executanle has been built using single processor
    runcmd = ['" cd  /home/aaelmeli/projects/first_test && cp first_test-opt /home/aaelmeli/projects/first_test/' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
        runcmd = ['" cd  /home/aaelmeli/projects/first_test && cp ' sytheticinputfilename ' /home/aaelmeli/projects/first_test/' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
        runcmd = ['" cd  /home/aaelmeli/projects/first_test && cp ' forwardinputfilename ' /home/aaelmeli/projects/first_test/' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
        runcmd = ['" cd  /home/aaelmeli/projects/first_test && cp ' adjointinputfilename ' /home/aaelmeli/projects/first_test/' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
        runcmd = ['" cd  /home/aaelmeli/projects/first_test && cp ' gradientinputfilename ' /home/aaelmeli/projects/first_test/' directoryname ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
    %make directories, 
        %on wsl
    runcmd = ['" cd  /home/aaelmeli/projects/first_test/' directoryname ' && mkdir -p ' adjointdirectory ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
    
        runcmd = ['" cd  /home/aaelmeli/projects/first_test/' directoryname ' && mkdir -p ' gradientdirectory ' > NULL "'];
    status = system([bashcmd runcmd]);
    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status)]);
    end
end
end