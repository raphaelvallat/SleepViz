function SleepViz( EDF )

%% ----------------------
%% Main parameters
%% ----------------------

% Default parameters EEG
time_period      =   EDF.plot.DefaultTimePeriod;
amplitude        =   EDF.plot.DefaultAmplitude;
nb_chan          =   length(EDF.channels);
ds_freq          =   EDF.ds_freq;

fprintf('\nTime period \t:\t %d sec', time_period );
fprintf('\nLength \t\t\t:\t %d epochs', length(EDF.m_data)/ds_freq/time_period );
fprintf('\nSampling rate \t:\t %d Hz (downsampled by %d)\n', EDF.ds_freq, EDF.ds_factor);

% Default parameters figure
fig         = figure('units','normalized','outerposition',[0 0.05 1 0.95]);
fig.Name    = EDF.filename;

set(gcf,'color','w');

% Compute display variables
ad_beg          =   1;
ad_end          =   ad_beg + (ds_freq * time_period - 1);
adresse         =   ad_beg:ad_end;
nb_epochs       =   length(EDF.m_data) / (time_period * ds_freq);
curr_epoch      =   [ 'Page : ', int2str(ad_beg), '/', int2str(nb_epochs)];

if EDF.plot.plot_hypno && EDF.plot.plot_spectro
    nb_plot = nb_chan + 2;
elseif EDF.plot.plot_hypno || EDF.plot.plot_spectro
    nb_plot = nb_chan + 1;
else
    nb_plot = nb_chan;
end

H = {};
H_ax = {};
DefautWidth = 0.92;

%% ----------------------
%% Plot channels
%% ----------------------

for i = 1:nb_chan
    H_ax{i} = subplot(nb_plot,1,i);
    set(gca, 'Position', [ H_ax{i}.Position(1)-0.07 H_ax{i}.Position(2) DefautWidth H_ax{i}.Position(4)+0.02 ] );
    H{i} = plot(EDF.m_data(EDF.channels(i), adresse), 'k', 'LineWidth', 0.75);
    
    box off
    grid on
    set(gca, 'Color', [ 0.99 0.99 0.99 ]);
    set(gca, 'GridColor', [ 0.3 0.3 0.3 ], 'GridAlpha', 0.1);
    set(gca, 'XColor', 'w');
    
    set(gca, 'Xlim', [0 length(adresse)]);
    set(gca, 'Ylim', [-amplitude amplitude]);
    
    set(gca,'XTick', 0:EDF.ds_freq:length(adresse))
    
    set(gca,'XTickLabel','')
    set(gca, 'Ytick', [-amplitude amplitude]);
    set(gca, 'YTickLabel', ['', '']);
    set(gca, 'TickLength', [0, 0]);
    
    title(EDF.hdr.label{1,EDF.channels(i)},'Units', 'normalized', 'Position', [-0.04 0.5], 'FontWeight', 'normal');
    
end

%% ----------------------
%% GRAPHICAL
%% ----------------------

% Create slider
sld = uicontrol('Style', 'slider',...
    'Min',1,'Max',nb_epochs,'Value',1,...
    'Units', 'normalized', ...
    'Position', [H_ax{1}.Position(1)-0.005 0.02 DefautWidth+0.015 0.04],...
    'sliderStep',([1, 1] / (nb_epochs - 1)), ...
    'Callback', @deplace);

% Top of the page Textbox
YPos_textbox = 0.95;
Height_textbox = 0.04;

textbox1    =   uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [0.2 YPos_textbox  0.1 Height_textbox ], 'FontSize', 14, 'BackgroundColor', 'w', ...
    'String', curr_epoch);

textbox_amplitude = uicontrol('Style', 'pushbutton', 'Units', 'normalized' , ...
                                'Position', [0.35 YPos_textbox+0.005  0.1 Height_textbox ], ...
                                'BackgroundColor', [0.97 0.97 0.97 ], ...
                                'FontSize', 14, 'String', 'Amplitude', ...
                                'Callback', @table_amplitude);


%% ----------------------
%% Plot time_frequency (use C3)
%% ----------------------

if EDF.plot.plot_spectro
    
    fprintf('Spectrogram \t:\t %s (%i seconds - overlap: %.2f)', EDF.hdr.label{EDF.plot.elec_spectro}, EDF.plot.spectro_window, EDF.plot.spectro_overlap);
    
    bins    =   EDF.plot.spectro_window * ds_freq;
    overlap =   bins * EDF.plot.spectro_overlap;
    
    H_spec  = subplot(nb_plot, 1, nb_chan+1);
    
    set(gca, 'Position', [ H_ax{1}.Position(1) H_spec.Position(2)-0.01 DefautWidth H_ax{1}.Position(4) ] );
    
    spectrogram(EDF.m_data(EDF.plot.elec_spectro, :) ,bins, overlap , [], ds_freq, 'yaxis');
    
    colorbar off
    caxis([0 30]);
    ylim([0.1 20]);
    box on
    grid off
    set(gca, 'ytick', [0.1 20]);
    set(gca, 'TickLength', [0 0]);
    set(gca, 'XColor', 'w');
    ylabel('');
    colormap(hot(30))
    
    
end

%% ----------------------
%% Hypnogram
%% ----------------------

if EDF.plot.plot_hypno
    
    hypno_ds = EDF.hypno(1:time_period:end, :);
    
    % Textbox
    switch hypno_ds(ad_beg)
        case 0
            curr_sleep_stage = 'Wake';
        case 1
            curr_sleep_stage = 'N1';
        case 2
            curr_sleep_stage = 'N2';
        case 3
            curr_sleep_stage = 'N3';
        case 4
            curr_sleep_stage = 'REM';
        case -1
            curr_sleep_stage = 'Art';
    end
    
    textbox_stage = uicontrol('Style', 'text', 'Units', 'normalized', ...
        'Position', [0.5 YPos_textbox  0.2 Height_textbox ], 'BackgroundColor', 'w', ...
        'FontSize', 14, 'String', ['Current stage : ', curr_sleep_stage]);
    
    % Plot Hypno
    H_hyp = subplot(nb_plot, 1, nb_plot);
    set(gca, 'Position', [ H_ax{1}.Position(1) H_hyp.Position(2)-0.025 DefautWidth H_ax{1}.Position(4) ] );
    plot(EDF.hypno, 'k', 'LineWidth', 1);
    box off
    grid on
    set(gca, 'Ylim', [-1 5 ]);
    set(gca,'Ydir','reverse')
    set(gca, 'YTick', [-1 0 1 2 3 4 5 ]);
    set(gca, 'YTickLabel', { 'Art', 'W', 'N1', 'N2', 'N3', 'REM', ''}, 'FontSize', 9);
    set(gca, 'TickLength', [0.002 0]);
    len_hyp     = length(EDF.hypno);
    len_hyp_ds  = len_hyp / EDF.plot.DefaultTimePeriod;
    set(gca, 'Xlim', [1 len_hyp]);
    set(gca, 'XTick', [ 1 len_hyp/2 len_hyp ]);
    set(gca, 'XTickLabel', '' );
    set(gca, 'XMinorGrid', 'on');
end


%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% Callback functions
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    function deplace(~,~)
        
        % Update variables
        ad_beg          =   uint32(get(sld,'Value')-1) * (time_period * ds_freq);
        ad_end          =   ad_beg + (ds_freq * time_period - 1);
        adresse         =   ad_beg:ad_end;
        curr_epoch      =   ['Page : ' int2str(ad_beg / (time_period * ds_freq) + 1), '/', int2str(nb_epochs)];
        
        % Update plot
        for jj = 1:nb_chan
            if ad_beg > 0; set(H{jj}, 'YData', EDF.m_data(EDF.channels(jj), adresse));
            elseif ad_beg ==0; set(H{jj}, 'YData', EDF.m_data(EDF.channels(jj), adresse+1)); end;
        end
        
        % Update textbox
        set(textbox1, 'String', curr_epoch);
        
        if EDF.plot.plot_hypno
            
            switch hypno_ds(ad_beg/(time_period * ds_freq) + 1)
                case 0
                    curr_sleep_stage = 'Wake';
                case 1
                    curr_sleep_stage = 'N1';
                case 2
                    curr_sleep_stage = 'N2';
                case 3
                    curr_sleep_stage = 'N3';
                case 4
                    curr_sleep_stage = 'REM';
                case -1
                    curr_sleep_stage = 'Art';
            end
            
            set(textbox_stage, 'String', ['Current stage : ', curr_sleep_stage]);
            
        end
        
    end

    function table_amplitude(~,~)
        
        f = figure;
        t = uitable(f)
        d = {};
        for ij = 1:length(EDF.channels)
            d = [d; {EDF.hdr.label{EDF.channels(ij)}, EDF.plot.amplitude(ij)}];
        end
        t.Data = d;
        t.ColumnName = {'Channel','Amplitude'};
        t.ColumnEditable = [ false true ];
        t.CellEditCallback = @new_amplitude;
        
    end

    function new_amplitude(~, eventdata)
        
        idx = eventdata.Indices(1);
        EDF.plot.amplitude(idx) = eventdata.NewData;
        set(H_ax{idx}, 'YLim', [-EDF.plot.amplitude(idx) EDF.plot.amplitude(idx)]);
        set(H_ax{idx}, 'YTick', [-EDF.plot.amplitude(idx) EDF.plot.amplitude(idx)]);
        
    end

end



