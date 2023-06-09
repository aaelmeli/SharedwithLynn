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
    % directoryname='_freq';
    % chr = int2str(labindex);
    % directoryname=append(directoryname,chr); 
    directoryname = '_freq';
    chr = int2str(labindex);
    directoryname = append(directoryname, chr);
    runcmd = [' mkdir -p  ' directoryname '  > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end

    
    %do the same in moose project
    runcmd = [' cd /home/elmeabde/sawtooth1/projects/first_test && mkdir -p ' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    %copy the executable into each of the directories, make sure that
    %this executable has been built using single processor
    runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test && cp  first_test-opt  ' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test && cp  ' sytheticinputfilename ' ' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test && cp  ' forwardinputfilename ' ' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test && cp  ' adjointinputfilename ' ' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test && cp ' gradientinputfilename ' ' directoryname ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    %make directories, 
        %on wsl
        
    
        runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && mkdir -p ' syntheticdirectory ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
        runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && mkdir -p ' forwarddirectory ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
    runcmd = [' cd  /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && mkdir -p ' adjointdirectory ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
    
        runcmd = [' cd /home/elmeabde/sawtooth1/projects/first_test/' directoryname ' && mkdir -p ' gradientdirectory ' > NULL '];
    [status, cmderrmsg] = unix(runcmd);

    if (status ~= 0)
        error(['Run bash cmd error: ' num2str(status) ' ' cmderrmsg]);
    end
end
end