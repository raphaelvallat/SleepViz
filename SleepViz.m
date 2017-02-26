% SleepViz
% Version 0.2 (Feb. 2017)
%
% Authors: Raphael Vallat
%
% Description:
%   SleepViz is a simple Matlab graphic user interface for visualization of
%   polysomnographic data.

clearvars
close all
addpath(genpath(pwd));

SV = [];

[SV.filename, SV.path ] = uigetfile({'*.edf';'*.eeg'}, 'Select the EEG file');

fprintf('\n=================================================================');
fprintf('\nEEG File\t\t:\t %s\n', SV.filename)

%% Load EEG
[~, ~, ext] = fileparts([SV.path SV.filename]);

if strcmp(ext, '.eeg');
    [ SV.hdr, SV.m_data ] = elan2edf([SV.path, SV.filename]);
elseif strcmp(ext, '.edf')
    [SV.hdr, SV.m_data]   = edfread([SV.path, SV.filename]);
end

SV.channels = listdlg('PromptString','Select channels to plot',...
    'SelectionMode','multiple',...
    'ListSize', [200 400], ...
    'Name', 'Channel Selection', ...
    'ListString',SV.hdr.label);

% User input
prompt = {  'Apply downsampling to 100 Hz [1/0]:', ...
    'Plot spectrogram [1/0] (requires Signal Processing Toolbox)', ...
    'Plot hypnogram [1/0] (requires *.txt / *.hyp file' };
dlg_title = 'SleepViz Parameters';
num_lines = 1;
defaultans = {'1','1','1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

% Apply downsampling
SV.downsample               =   logical(str2double(answer{1}));

% Plot spectrogram (requires Signal Processing Toolbox)
SV.plot.plot_spectro        =   logical(str2double(answer{2}));

% Plot Hypnogram (requires .txt or .hyp file)
SV.plot.plot_hypno          =  logical(str2double(answer{3}));


% Downsample to 100 Hz
SV.sfreq               =   SV.hdr.frequency(1);

if SV.downsample;
    SV.ds_factor       =   SV.sfreq / 100;
else
    SV.ds_factor       =   1;
end

SV.ds_freq             =   SV.sfreq / SV.ds_factor;
SV.m_data              =   SV.m_data( :, 1:SV.ds_factor:end );

% Visualisation variables
SV.plot.DefaultTimePeriod   =   30;        % Visualization period (default=30 sec)
SV.plot.DefaultAmplitude    =   150;
SV.plot.amplitude           =   SV.plot.DefaultAmplitude * ones(length(SV.channels), 1);
SV.plot.YLim                =   [ -SV.plot.DefaultAmplitude SV.plot.DefaultAmplitude ];

%% Spectrogram parameters
SV.plot.spectro_window      =   10;        % specify windows (sec) for FFT calculation
SV.plot.spectro_overlap     =   0.9;       % Number of overlap (range 0 - 0.99)

if SV.plot.plot_spectro
    SV.plot.elec_spectro    =   listdlg('PromptString','Select spectrogram channel',...
                                        'SelectionMode','single',...
                                        'ListSize', [200 400], ...
                                        'Name', 'Spectrogram', ...
                                        'ListString',SV.hdr.label);
end

%% Hypnogram parameters
if SV.plot.plot_hypno;
    [ SV.hypno, SV.hypnoname ] = import_hypno(SV);
end


%% Load GUI
main_gui ( SV );

fprintf('\n=================================================================\n');

clearvars -except SV

% EOF