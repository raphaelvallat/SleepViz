function tools_gui( SV )

ftool         = figure('units','normalized','outerposition',[0.5 0.5 0.2 0.4]);
ftool.Name    = 'Tools';

set(gcf,'color',[ 0.3 0.3 0.3 ]);

uicontrol('Style', 'pushbutton', 'Units', 'normalized' , ...
    'Position', [0.1 0.8  0.8 0.12 ], ...
    'BackgroundColor', [0.97 0.97 0.97 ], ...
    'FontSize', 14, 'String', 'REMs Detection', ...
    'Callback', @run_rem_detect);

uicontrol('Style', 'pushbutton', 'Units', 'normalized' , ...
    'Position', [0.1 0.65  0.8 0.12 ], ...
    'BackgroundColor', [0.97 0.97 0.97 ], ...
    'FontSize', 14, 'String', 'Compute Sleep Stats', ...
    'Callback', @run_sleep_stats);

uicontrol('Style', 'pushbutton', 'Units', 'normalized' , ...
    'Position', [0.1 0.5  0.8 0.12 ], ...
    'BackgroundColor', [0.97 0.97 0.97 ], ...
    'FontSize', 14, 'String', 'ECG Analysis', ...
    'Callback', @run_ecg);

uicontrol('Style', 'pushbutton', 'Units', 'normalized' , ...
    'Position', [0.1 0.35  0.8 0.12 ], ...
    'BackgroundColor', [0.97 0.97 0.97 ], ...
    'FontSize', 14, 'String', 'Filter Signal', ...
    'Callback', @run_filter);

uicontrol('Style', 'pushbutton', 'Units', 'normalized' , ...
    'Position', [0.1 0.2  0.8 0.12 ], ...
    'BackgroundColor', [0.97 0.97 0.97 ], ...
    'FontSize', 14, 'String', 'Compute ICA', ...
    'Callback', @run_ica);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function run_rem_detect(~,~)
       
       compute_rems( SV );
             
    end


    function run_sleep_stats(~,~)
       
       compute_sleep_stats( SV );
             
    end


    function run_ecg(~,~)
       
       compute_ecg( SV );
             
    end

  function run_filter(~,~)
       
       bp_filter( SV );
                    
  end

  function run_ica(~,~)
       
       compute_ica( SV );
                    
    end


end

