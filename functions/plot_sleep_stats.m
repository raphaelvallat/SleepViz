function plot_sleep_stats( SStats )

%% Display results
f = figure('Units', 'normalized', 'Position',[0.5 0.3 0.4 0.5]);

% Create the column and row names in cell arrays 

liste_var   = [ SStats.TIB SStats.AWA SStats.SPT SStats.WASO SStats.SE SStats.TST SStats.TST_N2 ...
                SStats.W SStats.N1 SStats.N2 SStats.N3 SStats.REM SStats.Perc_N1 SStats.Perc_N2 SStats.Perc_N3 ...
                SStats.Perc_REM SStats.Lat_N1 SStats.Lat_N2 SStats.Lat_N3 SStats.Lat_REM ]';
            
name_var    = { 'TIB', 'TDT', 'SPT', 'WASO', 'SE', 'TST', 'TST_N2', 'W', 'N1', 'N2', 'N3', 'REM', ...
                '%N1', '%N2', '%N3', '%REM', 'Lat_N1', 'Lat_N2', 'Lat_N3', 'Lat_REM' }; 
  
description = { 'Time in Bed', 'Total Dark Time', 'Sleep Period Time', 'Wake after sleep onset', 'Sleep Efficiency (%)', ...
                'Total Sleep Time', 'Total Sleep Time (excluding N1 sleep)', 'Wake (min)', 'N1 (min)', 'N2 (min)', ...
                'N3 (min)', 'REM (min)', 'Percentage of N1 in TDT', 'Percentage of N2 in TDT','Percentage of N3 in TDT', ...
                'Percentage of REM in TDT', 'N1 Latency (min)', 'N2 Latency (min)', 'N3 Latency (min)', 'REM Latency (min)' }';
                
dat = [ num2cell(liste_var) cellstr(description) ];

% Create the uitable
t = uitable(f,'Data', dat,...
            'ColumnName',{'Stats', 'Description'},... 
            'Units', 'normalized', ...
            'ColumnWidth', {100 300}, ...
            'RowName',name_var);

% Set width and height
t.Position(3) = 0.9;
t.Position(4) = 0.95;


end

