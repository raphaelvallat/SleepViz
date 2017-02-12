% -------------------------------------------------------------------------
% Launch EEGui interface to visualize EEG, spectrogram and hypnogram with
% parameters specified in Params structure
% -------------------------------------------------------------------------
% Author        :      Raphael Vallat
% Last update   :      Februrary 2017
% -------------------------------------------------------------------------

clearvars

addpath(genpath(pwd));

EDF = [];

[EDF.filename, EDF.path ] = uigetfile({'*.edf';'*.eeg'}, 'Select the EEG file');

fprintf('\n=================================================================');
fprintf('\nEEG File\t\t:\t %s\n', EDF.filename)

%% Load EEG
[~, ~, ext] = fileparts([EDF.path EDF.filename]);

if strcmp(ext, '.eeg');
    [ EDF.hdr, EDF.m_data ] = elan2edf([EDF.path, EDF.filename]);    
elseif strcmp(ext, '.edf')
    [EDF.hdr, EDF.m_data]   = edfread([EDF.path, EDF.filename]);
end

EDF.channels = listdlg('PromptString','Select channels to plot',...
    'SelectionMode','multiple',...
    'ListSize', [200 400], ...
    'Name', 'Channel Selection', ...
    'ListString',EDF.hdr.label);

% Downsample to 100 Hz
EDF.sfreq               =   EDF.hdr.frequency(1);
EDF.ds_factor           =   EDF.sfreq / 100;
EDF.ds_freq             =   EDF.sfreq / EDF.ds_factor;
EDF.m_data              =   EDF.m_data( :, 1:EDF.ds_factor:end );

% Visualisation variables
EDF.plot.DefaultTimePeriod   =   30;        % Visualization period (default=30 sec)
EDF.plot.DefaultAmplitude    =   150;
EDF.plot.amplitude           =   EDF.plot.DefaultAmplitude * ones(length(EDF.channels), 1);

EDF.plot.plot_spectro        =   true;      % Plot spectrogram (requires Signal Processing Toolbox)
EDF.plot.plot_hypno          =   true;      % Plot Hypnogram (requires .txt or .hyp file)

EDF.plot.spectro_window      =   10;        % specify windows (sec) for FFT calculation
EDF.plot.spectro_overlap     =   0.95;      % Number of overlap (range 0 - 0.99)

if EDF.plot.plot_spectro
    EDF.plot.elec_spectro       =   listdlg('PromptString','Select spectrogram channel',...
                                            'SelectionMode','single',...
                                            'ListSize', [200 400], ...
                                            'Name', 'Spectrogram', ...
                                            'ListString',EDF.hdr.label);
    
end


EDF.plot.compute_ICA         =   false;
EDF.plot.compute_ECG         =   false;

%% Hypnogram
if EDF.plot.plot_hypno;
    [ EDF.hypno, EDF.hypnoname ] = import_hypno(EDF);
end

%% Load GUI
SleepViz(EDF);

% %% ICA
% %% ------------
%
% if EDF.plot.compute_ICA; [ m_data, m_data_comp ] = compute_ICA(m_data, EDF); end;
%
% %% ECG analysis
% %% ------------
%
% if EDF.plot.compute_ECG; nb_peaks = compute_ECG(m_data, EDF); end

fprintf('\n=================================================================\n');

clearvars -except EDF

% EOF