function ECG = compute_ecg( SV )

% compute_ecg( SV ) - detect ECG peaks in specified ECG signal

fprintf('\nECG SIGNAL ANALYSIS');


% Main analysis structure
ECG = [];

ECG.chan = listdlg('PromptString','Select ECG channel',...
    'SelectionMode','multiple',...
    'ListSize', [200 400], ...
    'Name', 'Channel Selection', ...
    'ListString',SV.hdr.label);

ECG.data = SV.m_data(ECG.chan,:);

% User input
prompt = {  'Non-linear detrending [1/0]:', ...
    'Time-window (sec)', ...
    'Min Peak distance (Default = 0.6 = 100 BPM)', ...
    'Min Peak Height (STD)', ...
    'Min Peak Prominence', ...
    'Max Peak Width (sec)' };

dlg_title = 'ECG Analysis Info';
num_lines = 1;
defaultans = {'1','30','0.6', '0.5', '500', '0.4' };

answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


ECG.filter        =  logical(str2double(answer{1}));
ECG.time_window   =  str2double(answer{2});

if ECG.filter
    
    % Detrend using non-linear polyfit order 6
    % fr.mathworks.com/help/signal/examples/peak-analysis.html
    [p,s,mu]    = polyfit((1:numel(ECG.data)), ECG.data, 6);
    f_y         = polyval(p,(1:numel(ECG.data)),[],mu);
    ecg_corr    = ECG.data - f_y;
    ECG.data    = ecg_corr;
    
end

%% Computation of Heart Rate
%% ========================================================================

% Main parameters
ECG.minpeakdistance     = str2double(answer{3});              % 60/0.6 = 100 BPM threshold
ECG.minpeakheight       = str2double(answer{4}) * std(ECG.data);
ECG.minpeakprominence   = str2double(answer{5});
ECG.maxpeakwidth        = str2double(answer{6});              % 0.4 sec


[pks, locs] = findpeaks(ECG.data, SV.ds_freq, 'MinPeakDistance', ECG.minpeakdistance, ...
    'MinPeakHeight', ECG.minpeakheight, 'MinPeakProminence', ECG.minpeakprominence ,...
    'MaxPeakWidth', ECG.maxpeakwidth);

ECG.duration_sec = length(ECG.data) /SV.ds_freq;
ECG.duration_ep  = ECG.duration_sec / 30;
ECG.duration_min = ECG.duration_sec / 60;
ECG.mean_bpm     = length(pks) / ECG.duration_min;

fprintf('\n...Mean BPM \t:\t %.1f \n', ECG.mean_bpm);

% Compute HR for the whole nap using 30 sec windows
ECG.nb_peaks    = [];

for hh = 0:ECG.time_window:ECG.duration_sec-ECG.time_window
    ECG.nb_peaks = [ ECG.nb_peaks , length(find(locs(locs >= hh & locs < hh+ECG.time_window))) ];
end

ECG.nb_peaks_min = ECG.nb_peaks(1:2:length(ECG.nb_peaks)) + ECG.nb_peaks(2:2:length(ECG.nb_peaks)) ;

% Save ECG structure
outfile  = [ SV.path 'ECG_' SV.filename '.mat' ];
save(outfile, 'ECG');

fprintf('\nECG mat file saved at:\n%s\n', outfile);


% PLOT
plot_ecg( ECG, SV );

end