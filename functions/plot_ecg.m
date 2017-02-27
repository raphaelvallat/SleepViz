function plot_ecg( ECG, SV )

    % Figure 1 : ECG Peaks Detection
    position_fig            =   [0  0 0.95 0.5];
    fig                     =   figure('Units', 'normalized', 'Position', position_fig);
    fig.Name                =   SV.filename;
    h                       =   axes;
    
    findpeaks(ECG.data, SV.ds_freq, 'MinPeakDistance', ECG.minpeakdistance, ...
        'MinPeakHeight', ECG.minpeakheight, 'MinPeakProminence', ECG.minpeakprominence ,...
        'MaxPeakWidth', ECG.maxpeakwidth, 'Annotate', 'peaks');
    
    xlim([1 30])
    ylim([mean(ECG.data)-5*std(ECG.data) mean(ECG.data)+5*std(ECG.data)]);
    set(gca,'XTick', 1:30)
    set(gca,'YTick', [mean(ECG.data)-5*std(ECG.data) 0 mean(ECG.data)+5*std(ECG.data)])
    set(gca,'YTickLabels', { '-5 SD', 'Mean', '5 SD' })
    set(gca,'XTickLabels', strsplit(num2str(1:30)))
    set(gca, 'GridColor', [ 0.4 0.4 0.4 ]);
    grid on
    h.Position = [ 0.05 0.25 0.9 0.7 ];
   
    title('ECG Peaks Detection');
    ylabel('ECG Amplitude (mV)');
    xlabel('Time (sec)');
    
    % Create slider
    sld = uicontrol('Style', 'slider', 'Min',1,'Max', ECG.duration_ep,'Value',1,'Units', 'normalized', ...
        'Position', [ 0.25 0.05 0.5 0.1 ], ...
        'sliderStep',([1, 1] / (ECG.duration_ep - 1)), ...
        'Callback', @deplace);
    
    % Figure 2
    % BPM across time
    fig2 = figure;
    fig2.Name = SV.filename;
    if SV.plot.plot_hypno; subplot(2,1,1); end;
    plot(ECG.nb_peaks_min, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
    hold on
    plot(moving_average(ECG.nb_peaks_min', 4)', 'LineWidth', 2.5, 'Color', 'k');
    ylim([50 90]);
    xlim([1 ECG.duration_min]);
    ylabel('Beats per minute');
    xlabel('Time (min)');
    
    % Hypnogram
    if SV.plot.plot_hypno;
        subplot(2,1,2)
        plot(SV.hypno, 'k', 'LineWidth', 1);
        ylabel('Sleep stage');
        xlabel('Time (min)');
        box off
        grid on
        set(gca, 'Ylim', [-1 5 ]);
        set(gca,'Ydir','reverse')
        set(gca, 'YTick', [-1 0 1 2 3 4 5 ]);
        set(gca, 'YTickLabel', { 'Art', 'W', 'N1', 'N2', 'N3', 'REM', ''});
        set(gca, 'XTickLabel', '');
        set(gca, 'TickLength', [0.002 0]);
        len_hyp     = length(SV.hypno);
        len_hyp_ds  = len_hyp / SV.plot.DefaultTimePeriod;
        set(gca, 'Xlim', [1 len_hyp]);
        set(gca, 'XMinorGrid', 'on');
    end;
    
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%% Callback functions
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    function deplace(~,~)
        
        % Update variables
        ad_sld = uint32(get(sld,'Value')-1) * 30;
        
        % Update plot
        set(h, 'Xlim', [ad_sld ad_sld+29 ]);
        set(gca,'XTick', ad_sld:ad_sld+29)
        
    end

end

