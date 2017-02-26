function REMs = compute_rems ( SV )

%%%%%%%% USER INPUT

REMs.eog_chan = listdlg('PromptString','Select 2 EOG channels',...
    'SelectionMode','multiple',...
    'ListSize', [200 400], ...
    'Name', 'Channel Selection', ...
    'ListString', SV.hdr.label);


prompt          = {'REM Sleep only? [1/0] (requires hypnogram)','Enter filter type [moving/bandpass]:','Enter threshold:'};
dlg_title       = 'REMs Detection Parameters';
num_lines       = 1;
defaultans      = {'0', 'moving','3'};
options.Resize  = 'on';
options.WindowStyle='normal';

answer = inputdlg(prompt,dlg_title,num_lines ,defaultans,options);

% REM sleep only
REMs.rem_sleep      = logical(str2double(answer{1}));

% ICA parameters
%REMs.compute_ICA    = logical(str2double(answer{2}));

% Moving Average Parameters
REMs.filter_type    = answer{2};
REMs.mov_avg_pts    = 100;

% Derivative
REMs.deriv_pts      = 40;

% Threshold
REMs.threshold      = str2double(answer{3});

% Visualization
REMs.plot           = true;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if REMs.rem_sleep
    REMs.hypno   = kron(SV.hypno, ones(SV.ds_freq, 1));
    REMs.epoch   = find(REMs.hypno == 4);
else
    REMs.epoch = 1:size(SV.m_data,2);
end

%% Start detection

comp1 = SV.m_data(REMs.eog_chan(1), REMs.epoch);
comp2 = SV.m_data(REMs.eog_chan(2), REMs.epoch);

% Initial smoothing of the signal

smooth_fact = REMs.mov_avg_pts / SV.ds_factor;

if strcmp(REMs.filter_type, 'moving');
    %1st method - moving average 100 points (equivalent to lowpass 10 Hz)
    comp1_filt  =   moving_average(comp1', smooth_fact)';
    comp2_filt  =   moving_average(comp2', smooth_fact)';
    
elseif strcmp(REMs.filter_type, 'bandpass');
    % 2nd method - bandpass filter 0.1 - 3 Hz (Andrillon 2015)
    order       =   3;
    lofreq      =   0.1;
    hifreq      =   3;
    [b,a] = butter(order, [lofreq hifreq]/(SV.ds_freq/2), 'bandpass');
    comp1_filt = filter(b, a, comp1);
    comp2_filt = filter(b, a, comp2);
    % obw(comp1_filt, sfreq, [0.1 3])
    
end

% Compute first derivative
% see /fr.mathworks.com/matlabcentral/newsreader/view_thread/61031
step        =   REMs.deriv_pts / SV.ds_factor;
comp1_deriv =   [ zeros(1,step/2), comp1_filt(step+1:length(comp1_filt))-comp1_filt(1:length(comp1_filt)-step), zeros(1,step/2) ];
comp2_deriv =   [ zeros(1,step/2), comp2_filt(step+1:length(comp2_filt))-comp2_filt(1:length(comp2_filt)-step), zeros(1,step/2) ];

% Smooth derivative
comp1_deriv =   moving_average(comp1_deriv', smooth_fact)';
comp2_deriv =   moving_average(comp2_deriv', smooth_fact)';

% Convert to absolute values
comp1_deriv =   abs((comp1_deriv));
comp2_deriv =   abs((comp2_deriv));

comp1_filt  =   zscore(comp1_filt);
comp2_filt  =   zscore(comp2_filt);

%% Computation of REMs
threshold   =   REMs.threshold;

% Comp. 1
thresh_comp1                            =   mean(comp1_deriv) + threshold * std(comp1_deriv);
supra_thresh_comp1                      =   find(comp1_deriv(1,:)>thresh_comp1);
valeur_supra_thresholdc_omp1            =   comp1_deriv(supra_thresh_comp1);
[pks_comp1,locs_comp1]                  =   findpeaks(valeur_supra_thresholdc_omp1, supra_thresh_comp1);

% Comp. 2
thresh_comp2                            =   mean(comp2_deriv) + threshold * std(comp2_deriv);
supra_thresh_comp2                      =   find(comp2_deriv(1,:) > thresh_comp2);
valeur_supra_threshold_comp2            =   comp2_deriv(supra_thresh_comp2);
[pks_comp2,locs_comp2]                  =   findpeaks(valeur_supra_threshold_comp2, supra_thresh_comp2);

% To display REMs on top of ICA component
vecteur_nan_comp1                       =   NaN(1, length(comp1_filt));
vecteur_nan_comp2                       =   NaN(1, length(comp2_filt));
vecteur_nan_comp1(supra_thresh_comp1)   =   1;
vecteur_nan_comp2(supra_thresh_comp2)   =   1;
overlay_REMs_comp1                      =   comp1_filt .* vecteur_nan_comp1;
overlay_REMs_comp2                      =   comp2_filt .* vecteur_nan_comp2;

% Find concomitant REMs
idx_REMs_comp1  =   find(~isnan(vecteur_nan_comp1));
idx_REMs_comp2  =   find(~isnan(vecteur_nan_comp2));

[C,ia,ib]       =   intersect(idx_REMs_comp1, idx_REMs_comp2);

conc_REMs       =   [2 diff(C)];                              % 2 is to count the first concomitant saccade (else not counted in diff)
nb_conc_REMs    =   length(conc_REMs(conc_REMs > 1));         % This number will be substracted to the sum of REMs in comp1 and 2

idx_unique_conc =   C(conc_REMs > 1);                         % Adresses of concomitant REMs

% GUI

if REMs.plot
    
    plot_rems(comp1_filt, comp2_filt, locs_comp1, locs_comp2, overlay_REMs_comp1, overlay_REMs_comp2, idx_unique_conc, SV.ds_freq, REMs.filter_type);
    
end

%% Save to global variable
length_min      =   length(comp1_deriv)/ (60 * SV.ds_freq);
nb_REMs_comp1   =   length(pks_comp1);
nb_REMs_comp2   =   length(pks_comp2);
sum_comps       =   (nb_REMs_comp1 + nb_REMs_comp2) - nb_conc_REMs;
density_comp1   =   nb_REMs_comp1 / length_min;
density_comp2   =   nb_REMs_comp2 / length_min;
density_comps   =   sum_comps / length_min;

% Export results
Res.length      = length_min;

Res.number_EOG1 = nb_REMs_comp1;
Res.number_EOG2 = nb_REMs_comp2;
Res.number_all  = sum_comps;

Res.density_EOG1 = density_comp1;
Res.density_EOG2 = density_comp2;
Res.density_all  = density_comps;

subj_name       = strsplit(SV.filename, '.');
Res.outfile      = [ SV.path 'REMs_detection_' subj_name{1} '_filter_' REMs.filter_type , ...
                    '_thresh_' num2str(REMs.threshold) '.mat' ];

REMs.Res         = Res;

%% Print means
fprintf('\nRAPID EYE MOVEMENTS AUTO-DETECTION\n');
fprintf('-----------------------------------------\n')
fprintf('ANALYSIS INFO\n')
fprintf('EEG File \t:\t%s\n', SV.filename);
fprintf('Duration \t:\t%d minutes\n', Res.length);

if strcmp(REMs.filter_type, 'bandpass')
    fprintf('Filter type\t:\t%s [%.1f %.1f Hz]\n', REMs.filter_type, lofreq, hifreq);
else
    fprintf('Filter type\t:\t%s [%d samples]\n', REMs.filter_type, REMs.mov_avg_pts);
end
fprintf('Threshold \t:\t%d\n', REMs.threshold);
fprintf('Derivative \t:\t%d ms\n', REMs.deriv_pts);

fprintf('\nRESULTS');
fprintf('\nNumber \t\t:\t%d \n', Res.number_all);
fprintf('Density \t:\t%.2f REMs / minutes\n', Res.density_all);
fprintf('Outfile\t\t:\t%s\n', Res.outfile);
fprintf('-----------------------------------------------\n');

save(Res.outfile, 'REMs');

end

