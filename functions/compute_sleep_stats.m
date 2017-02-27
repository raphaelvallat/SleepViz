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
SStats.TST     = [];           % N1 + N2 + N3 + REM
SStats.TST_N2  = [];           % N2 + N3 + REM
SStats.W       = [];           % Wake in TIB
SStats.N1      = [];           % N1 in TIB
SStats.N2      = [];
SStats.N3      = [];
SStats.REM      = [];

SStats.Lat_N1  = [];           % Sleep Onset (1st N1, in min)
SStats.Lat_N2  = [];           % First N2 - in min
SStats.Lat_N3  = [];           % First N3 - in min
SStats.Lat_REM = [];           % First REM - in min

SStats.Perc_W  = [];           % Perc of N1 in Total Dark Time
SStats.Perc_N1 = [];
SStats.Perc_N2 = [];
SStats.Perc_N3 = [];
SStats.Perc_REM = [];

% ----------------------------------------------------------------------

hypno = SV.hypno;

%% Compute stats
TIB     = numel(hypno);
AWA     = max(find(hypno > 0)) + 1;
hypno_s = hypno(min(find(hypno > 0)):AWA-1);
SPT     = length(hypno_s);
WASO    = length(hypno_s(hypno_s == 0));
TST     = SPT - WASO;
SE      = TST / AWA * 100;

%..Sleep duration
W       = length(hypno(hypno == 0));
N1      = length(hypno(hypno == 1));
N2      = length(hypno(hypno == 2));
N3      = length(hypno(hypno == 3));
REM     = length(hypno(hypno == 4));
TST_N2  = N2 + N3 + REM;

%..Sleep percentages (of Total Dark Time)
Perc_W  = W / AWA;
Perc_N1 = N1 / AWA;
Perc_N2 = N2 / AWA;
Perc_N3 = N3 / AWA;
Perc_REM = REM / AWA;

%..Sleep latencies
if ~isempty(find(hypno == 1)); Lat_N1  = min(find(hypno == 1)); else Lat_N1 = NaN; end
if ~isempty(find(hypno == 2)); Lat_N2  = min(find(hypno == 2)); else Lat_N2 = NaN; end
if ~isempty(find(hypno == 3)); Lat_N3  = min(find(hypno == 3)); else Lat_N3 = NaN; end
if ~isempty(find(hypno == 4)); Lat_REM = min(find(hypno == 4)); else Lat_REM = NaN; end


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

% Plot results table
plot_sleep_stats (SStats);

end


