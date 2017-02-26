function compute_sleep_stats( SV )

% DEFINE SStats STRUCTURE
% ----------------------------------------------------------------------
SStats         = [];
SStats.name    = SV.hypnoname;
SStats.date    = date;
SStats.units   = 'minutes';
SStats.TIB     = [];           % Total Hypno Duration
SStats.AWA     = [];           % Total Dark Time (without post-awakening)
SStats.SPT     = [];           % Elapsed time from N1 --> AWA
SStats.WASO    = [];           % Wake in SPT
SStats.SE      = [];           % TST / AWA
SStats.TST     = [];           % N1 + N2 + N3
SStats.TST_N2  = [];           % N2 + N3
SStats.W       = [];           % Wake in TIB
SStats.N1      = [];           % N1 in TIB
SStats.N2      = [];
SStats.N3      = [];
SStats.REM      = [];

SStats.Lat_N1  = [];           % Sleep Onset (1st N1, in min)
SStats.Lat_N2  = [];           % First N2 - in min
SStats.Lat_N3  = [];           % First N3 - in min
SStats.Lat_REM = [];           % First N3 - in min

SStats.Perc_W  = [];           % Perc of N1 in AWA (TDT)
SStats.Perc_N1 = [];
SStats.Perc_N2 = [];
SStats.Perc_N3 = [];
SStats.Perc_REM = [];

% ----------------------------------------------------------------------

hypno = SV.hypno;

%% Compute stats
TIB     = numel(hypno);

Lat_N1  = min(find(hypno == 1));
AWA     = max(find(hypno > 0)) + 1;
hypno_s = hypno(Lat_N1:AWA-1);
SPT     = length(hypno_s);
WASO    = length(hypno_s(hypno_s == 0));
TST     = SPT - WASO;
SE      = TST / AWA * 100;

%..N2 and N3 latencies
if ~isempty(find(hypno == 2)); Lat_N2  = min(find(hypno == 2)); else Lat_N2 = NaN; end
if ~isempty(find(hypno == 3)); Lat_N3  = min(find(hypno == 3)); else Lat_N3 = NaN; end
if ~isempty(find(hypno == 4)); Lat_REM  = min(find(hypno == 4)); else Lat_REM = NaN; end

W       = length(hypno(hypno == 0));
N1      = length(hypno(hypno == 1));
N2      = length(hypno(hypno == 2));
N3      = length(hypno(hypno == 3));
REM     = length(hypno(hypno == 4));
TST_N2  = N2 + N3;

Perc_W  = W / AWA;
Perc_N1 = N1 / AWA;
Perc_N2 = N2 / AWA;
Perc_N3 = N3 / AWA;
Perc_REM = REM / AWA;


%% Convert in minutes / percentage
Sleep       = [ TIB AWA SPT TST WASO TST_N2 ] / 60;
Stages      = [ W N1 N2 N3 REM ] / 60;
Latencies   = [ Lat_N1 Lat_N2 Lat_N3 Lat_REM ] / 60;
Perc        = [ Perc_W Perc_N1 Perc_N2 Perc_N3 Perc_REM ] * 100;


%% Append to SStats global variables
% Sleep basics
SStats.TIB         = [ SStats.TIB ; Sleep(1) ];
SStats.AWA         = [ SStats.AWA ; Sleep(2) ];
SStats.SPT         = [ SStats.SPT ; Sleep(3) ];
SStats.TST         = [ SStats.TST ; Sleep(4) ];
SStats.WASO        = [ SStats.WASO ; Sleep(5) ];
SStats.TST_N2      = [ SStats.TST_N2 ; Sleep(6) ];
SStats.SE          = [ SStats.SE ; SE ];

%..Duration in minutes
SStats.W           = [ SStats.W ; Stages(1) ];
SStats.N1          = [ SStats.N1 ; Stages(2) ];
SStats.N2          = [ SStats.N2 ; Stages(3) ];
SStats.N3          = [ SStats.N3 ; Stages(4) ];
SStats.REM         = [ SStats.REM ; Stages(5) ];

%..Duration in percentages
SStats.Perc_W      = [ SStats.Perc_W ; Perc(1) ];
SStats.Perc_N1     = [ SStats.Perc_N1 ; Perc(2) ];
SStats.Perc_N2     = [ SStats.Perc_N2 ; Perc(3) ];
SStats.Perc_N3     = [ SStats.Perc_N3 ; Perc(4) ];
SStats.Perc_REM    = [ SStats.Perc_REM ; Perc(5) ];

%..Latencies
SStats.Lat_N1      = [ SStats.Lat_N1 ; Latencies(1) ];
SStats.Lat_N2      = [ SStats.Lat_N2 ; Latencies(2) ];
SStats.Lat_N3      = [ SStats.Lat_N3 ; Latencies(3) ];
SStats.Lat_REM     = [ SStats.Lat_REM ; Latencies(4) ];


fprintf('\n');

%% Export to MAT file
outfile  = [ SV.path 'SleepStats_' SV.hypnoname '.mat' ];
save(outfile, 'SStats');

fprintf('\nSleep Stats results file saved at:\n%s\n', outfile);

%% Display results
f = figure('Units', 'normalized', 'Position',[0.5 0.3 0.4 0.5]);

% Create the column and row names in cell arrays 

liste_var   = [ SStats.TIB SStats.AWA SStats.SPT SStats.WASO SStats.SE SStats.TST SStats.TST_N2 ...
                SStats.W SStats.N1 SStats.N2 SStats.N3 SStats.REM SStats.Perc_N1 SStats.Perc_N2 SStats.Perc_N3 ...
                SStats.Perc_REM SStats.Lat_N1 SStats.Lat_N2 SStats.Lat_N3 SStats.Lat_REM ]';
            
name_var    = { 'TIB', 'TDT', 'SPT', 'WASO', 'SE', 'TST', 'TST_N2', 'W', 'N1', 'N2', 'N3', 'REM', ...
                '%N1', '%N2', '%N3', '%REM', 'Lat_N1', 'Lat_N2', 'Lat_N3', 'Lat_REM' }; 
  
description = { 'Time in Bed', 'Total Dark Time', 'Sleep Period Time', 'Wake after sleep onset', 'Sleep Efficiency (%)', ...
                'Total Sleep Time', 'Total Sleep Time (only N2 sleep)', 'Wake (min)', 'N1 (min)', 'N2 (min)', ...
                'N3 (min)', 'REM (min)', 'Percentage of N1 in TDT', 'Percentage of N2 in TDT','Percentage of N3 in TDT', ...
                'Percentage of REM in TDT', 'N1 Latency (min)', 'N2 Latency (min)', 'N3 Latency (min)', 'REM Latency (min)' }';
                
dat = [ num2cell(liste_var) cellstr(description) ];

fprintf('');
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


