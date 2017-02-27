%% Visualization tool for REMS automatic detection
% Author: Raphael Vallat
% Last update: 28/10/2016

function plot_rems( comp1_filt, comp2_filt, locs_comp1, locs_comp2, overlay_REMs_comp1, overlay_REMs_comp2, idx_unique_conc, sfreq, filter_type)

time_period     =   30;

ad_deb          =   1;
ad_fin          =   ad_deb + (sfreq * time_period - 1);
adresse         =   ad_deb:ad_fin;
REMs_comp1      =   find(ad_deb < locs_comp1 & locs_comp1 < ad_fin);
REMS_comp2      =   find(ad_deb < locs_comp2 & locs_comp2 < ad_fin);
REMs_conc       =   find(ad_deb < idx_unique_conc & idx_unique_conc < ad_fin);

nb_pages        =   length(comp1_filt) / (time_period * sfreq);
nb_REMs_comp1   =   ['Comp 1   : ', num2str(length(REMs_comp1))];
nb_REMs_comp2   =   ['Comp 2   : ', num2str(length(REMS_comp2))];
nb_REMs_conc    =   ['Concomit : ', num2str(length(REMs_conc))];
sum_unique      =   ['Unique   : ', num2str(length(REMs_comp1) + length(REMS_comp2) - length(REMs_conc)) ];

scrsz           =   get(groot,'ScreenSize');

figure('units','normalized','outerposition',[0 0.05 1 0.95]);
set(gcf,'color','w');

% Plot component 1
subplot(2,1,1);
p1 = plot(comp1_filt(adresse), 'k', 'LineWidth', 2.5);

box on
grid on
title('Filtered EOG component 1');
set(gca, 'Xlim', [0 length(adresse)]);
set(gca,'XTick',[0, length(adresse)/6 length(adresse)/3 length(adresse)/2 length(adresse)/1.5 length(adresse)/1.2 length(adresse)])
set(gca,'XTickLabel',{'0', num2str(time_period/6), num2str(time_period/3), num2str(time_period/2), num2str(time_period/1.5), num2str(time_period/1.2), num2str(time_period)})
ylim([-20 20]);
xlabel('');
ylabel('');
hold on
p2 = plot(overlay_REMs_comp1(adresse), 'r', 'LineWidth', 3.5);

hold off

% Plot component 2
subplot(2,1,2);
p3 = plot(comp2_filt(adresse), 'k', 'LineWidth', 2.5);
box on
grid on
title('Filtered EOG component 2');
set(gca, 'Xlim', [0 length(adresse)]);
set(gca,'XTick',[0, length(adresse)/6 length(adresse)/3 length(adresse)/2 length(adresse)/1.5 length(adresse)/1.2 length(adresse)])
set(gca,'XTickLabel',{'0', num2str(time_period/6), num2str(time_period/3), num2str(time_period/2), num2str(time_period/1.5), num2str(time_period/1.2), num2str(time_period)})
ylim([-20 20]);
xlabel('Time (sec)');
ylabel('Amplitude (Z-score)');
hold on
p4 = plot(overlay_REMs_comp2(adresse), 'r', 'LineWidth', 3);
hold off

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% GUI textbox and controls
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

textbox_width   =   0.1;
textbox_height  =   0.05;
textbox_x       =   0.01;
textbox_y       =   0.9;

% Create slider
sld = uicontrol('Style', 'slider',...
    'Min',1,'Max',nb_pages,'Value',1,...
    'Units', 'normalized', ...
    'Position', [ 0.2 0.01 0.6 0.03 ],...
    'sliderStep',([1, 1] / (nb_pages - 1)), ...
    'Callback', @deplace);

pos1        =   [textbox_x+0.9 textbox_y-0.9 textbox_width textbox_height ];
pages       =   [int2str(ad_deb), '/', int2str(nb_pages)];                              % Page number
textbox1    =   uicontrol('Style', 'text', 'Units', 'normalized', 'Position', pos1, 'FontSize', 18, 'BackgroundColor', 'w');

pos2        =   [ textbox_x textbox_y-0.05 textbox_width textbox_height ];                         % Number of saccades (comp 1)
textbox2    =   uicontrol('Style', 'text', 'Units', 'normalized', 'Position', pos2, 'FontSize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', 'w');

pos3        =   [ textbox_x textbox_y-0.1 textbox_width textbox_height ];         % Number of saccades (comp 2)
textbox3    =   uicontrol('Style', 'text', 'Units', 'normalized','Position', pos3, 'FontSize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', 'w');

pos4        =   [ textbox_x textbox_y-0.15 textbox_width textbox_height ];      % Number of concomitant saccades
textbox4    =   uicontrol('Style', 'text','Units', 'normalized', 'Position', pos4,  'FontSize', 12, 'HorizontalAlignment', 'left','BackgroundColor', 'w');

pos5        =   [ textbox_x textbox_y-0.2 textbox_width textbox_height ];        % Number of unique saccades
textbox5    =   uicontrol('Style', 'text', 'Units', 'normalized','Position', pos5,  'FontSize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', 'w');

pos6        =   [ textbox_x textbox_y-0.25 textbox_width textbox_height ];        % Sampling rate
textbox6    =   uicontrol('Style', 'text', 'Units', 'normalized','Position', pos6, 'FontSize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', 'w');

pos7        =   [ textbox_x textbox_y-0.3 textbox_width textbox_height ];        % Filter Type
textbox7    =   uicontrol('Style', 'text', 'Units', 'normalized','Position', pos7, 'FontSize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', 'w');

set(textbox1, 'String', pages);
set(textbox2, 'String', nb_REMs_comp1);
set(textbox3, 'String', nb_REMs_comp2);
set(textbox4, 'String', nb_REMs_conc);
set(textbox5, 'String', sum_unique);
set(textbox6, 'String', ['Sampling :  ', num2str(sfreq)]);
set(textbox7, 'String', ['Filter   :  ', filter_type]);


% Draw lines or peaks
flag        = 1;        % default = line
b           = uicontrol('Style','togglebutton', 'Units', 'normalized', 'FontSize', 12, 'BackgroundColor', [0.9 0.9 0.9]);
b.Position  = [ textbox_x textbox_y-0.85 textbox_width textbox_height ];
set(b, 'String', 'Saccades');
set(b, 'Callback', @affiche);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Callback functions
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    function deplace(~,~)
        
        % Update variables
        ad_deb          =   (get(sld,'Value')-1) * (30 * sfreq);
        ad_fin          =   ad_deb + (sfreq*30 - 1);
        adresse         =   ad_deb:ad_fin;
        pages           =   [num2str((ad_deb / (30 * sfreq)) + 1), '/', num2str(nb_pages)];
        
        REMs_comp1      =   find(ad_deb < locs_comp1 & locs_comp1 < ad_fin);
        REMS_comp2      =   find(ad_deb < locs_comp2 & locs_comp2 < ad_fin);
        REMs_conc       =   find(ad_deb < idx_unique_conc & idx_unique_conc < ad_fin);
        nb_REMs_comp1   =   ['Comp 1    :   ', num2str(length(REMs_comp1))];
        nb_REMs_comp2   =   ['Comp 2    :   ', num2str(length(REMS_comp2))];
        nb_REMs_conc    =   ['Concomit  :   ', num2str(length(REMs_conc))];
        sum_unique      =   ['Unique    :   ', num2str(length(REMs_comp1) + length(REMS_comp2) - length(REMs_conc)) ];
        
        
        if ad_deb > 0;
            set(p1, 'YData', comp1_filt(adresse));       % ICA comp 1
            set(p3, 'YData', comp2_filt(adresse));       % ICA comp 2
            % Overlay
            if flag == 1
                set(p2, 'YData', overlay_REMs_comp1(adresse));
                set(p4, 'YData', overlay_REMs_comp2(adresse));
            elseif flag == 0
                set(p2, 'XData', locs_comp1(REMs_comp1)-ad_deb);
                set(p2, 'YData', comp1_filt(locs_comp1(REMs_comp1)));
                
                set(p4, 'XData', locs_comp2(REMS_comp2)-ad_deb);
                set(p4, 'YData', comp2_filt(locs_comp2(REMS_comp2)));
            end
            
        elseif ad_deb ==0;
            set(p1, 'YData', comp1_filt(adresse+1));       % ICA comp 1
            set(p3, 'YData', comp2_filt(adresse+1));       % ICA comp 2
            
            if flag == 1
                set(p2, 'YData', overlay_REMs_comp1(adresse+1));
                set(p4, 'YData', overlay_REMs_comp2(adresse+1));
            elseif flag == 0
                set(p2, 'XData', locs_comp1(REMs_comp1)-ad_deb);
                set(p2, 'YData', comp1_filt(locs_comp1(REMs_comp1)));
                
                set(p4, 'XData', locs_comp2(REMS_comp2)-ad_deb);
                set(p4, 'YData', comp2_filt(locs_comp2(REMS_comp2)));
            end
            
        end;
                
        % Update textbox
        set(textbox2, 'String', nb_REMs_comp1);
        set(textbox3, 'String', nb_REMs_comp2);
        set(textbox4, 'String', nb_REMs_conc);
        set(textbox5, 'String', sum_unique);
        set(textbox1, 'String', pages);
        
    end


    function affiche(~,~)
        
        % Flag = 0 --> Peaks
        % Flag = 1 --> Lines
        
        if strcmp((get(b, 'String')), 'Saccades') == 1;
            
            set(b, 'String', 'Peaks');
            flag = 0;
            
            set(p2, 'XData', locs_comp1(REMs_comp1)-ad_deb);
            set(p2, 'YData', comp1_filt(locs_comp1(REMs_comp1)));
            set(p2, 'Marker', 'o');
            set(p2, 'LineStyle', 'none');
            
            set(p4, 'XData', locs_comp2(REMS_comp2)-ad_deb);
            set(p4, 'YData', comp2_filt(locs_comp2(REMS_comp2)));
            set(p4, 'Marker', 'o');
            set(p4, 'LineStyle', 'none');
            
        elseif strcmp((get(b, 'String')), 'Peaks') == 1;
            
            set(b, 'String', 'Saccades');
            flag = 1;
            
            set(p2, 'Marker', 'none');
            set(p2, 'LineStyle', '-');
            set(p2, 'XData', 1:(30*sfreq) );
            set(p2, 'YData', overlay_REMs_comp1(adresse));
            
            set(p4, 'Marker', 'none');
            set(p4, 'LineStyle', '-');
            set(p4, 'XData', 1:(30 * sfreq) );
            set(p4, 'YData', overlay_REMs_comp2(adresse));
        end
        
    end

end
