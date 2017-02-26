function [ data, hypname ] = import_hypno( EDF )

% Import hypnogram
[ hypname, hyppath ] = uigetfile({'*.txt';'*.hyp'}, 'Select Hypno File');
fprintf('HYP File\t\t:\t %s\n', hypname)

[~, ~, ext] = fileparts([hyppath hypname]);

if strcmp(ext, '.txt');
    
    % TXT HYPNOGRAM FILE
    hypno   = importdata( [hyppath, hypname] );
    hypno   = hypno.data;
    %.Resample to get one value per second
    s_hypno = (length(EDF.m_data) / EDF.ds_freq) / length(hypno);
    hypno   = kron(hypno, ones(s_hypno, 1));
    
    %..Switch values in vector
    %   SleepViz default:
    %   Art=-1, W=0, N1=1, N2=2, N3=3, REM=4
    %   Dreams Spindle Database
    %   Wake=5, REM=4, N1=3, N2=2, N3=1, N4=0
    
    W   = find(hypno == 5);
    N1  = find(hypno == 3);
    N2  = find(hypno == 2);
    N3  = find(hypno == 1 | hypno == 0);
    REM = find(hypno == 4);
    
    hyp_tmp = -ones(length(hypno), 1);
    hyp_tmp(W) = 0; hyp_tmp(N1) = 1; hyp_tmp(N2) = 2;
    hyp_tmp(N3) = 3; hyp_tmp(REM) = 4;
    
    data = hyp_tmp;
    
elseif strcmp(ext, '.hyp')
    
    % ELAN HYPNOGRAM FILE
    hypno = importdata( [hyppath hypname] );
    hypno = hypno.textdata(5:end, 1);
    hypno = str2double(hypno);
    
    hypno(hypno == -2)  =   -1;
    hypno(hypno == 4)   =   3;
    hypno(hypno == 5)   =   4;
    
    data = hypno;
    
end


end

