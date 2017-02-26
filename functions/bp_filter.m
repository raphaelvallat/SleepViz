function SV_filt = bp_filter( SV )

prompt          = {'Enter cutoff frequencies'; 'Butterworth order'};
dlg_title       = 'Bandpass filter';
num_lines       = 1;
defaultans      = {'0.5 20';'3'};
options.Resize  = 'on';
options.WindowStyle='normal';
answer = inputdlg(prompt,dlg_title,num_lines ,defaultans,options);

order       =   str2double(answer{2});
cutoff      =   str2double(strsplit(answer{1},' '));

[b,a]       = butter(order, [cutoff(1) cutoff(2)]/(SV.ds_freq/2), 'bandpass');

SV_filt     = SV;

for i = 1:length(SV.channels)
    
    SV_filt.m_data(SV.channels(i), :) = filter( b, a, SV.m_data(SV.channels(i), :) );
    
end

fprintf('\n=================================================================\n');

main_gui(SV_filt);

fprintf('\n=================================================================\n');


end

