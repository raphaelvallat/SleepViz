function compute_ica( ICA )

 addpath('C:\Users\Raphael\Desktop\These\CONN\eeglab14_0_0b\functions\sigprocfunc');
 
 ICA.channels = listdlg('PromptString','Select channels to compute ICA',...
    'SelectionMode','multiple',...
    'ListSize', [200 400], ...
    'Name', 'Channel Selection', ...
    'ListString',ICA.hdr.label);
 
ICA.m_data = ICA.m_data(ICA.channels,:);

[weights, sphere]          = runica(ICA.m_data);
 
 m_data                    = icavar(ICA.m_data, weights, sphere);
 
 ICA.m_data                = zscore(m_data,0, 2);
 
 % Visualization parameters
 ICA.channels                = 1:size(ICA.m_data, 1);
 ICA.plot.plot_spectro       = 0;
 ICA.plot.plot_hypno         = 0;
 ICA.plot.DefaultAmplitude   = 2;
 ICA.plot.amplitude          = ICA.plot.DefaultAmplitude * ones(length(ICA.channels), 1);
 ICA.plot.YLim               = [ -0.5 ICA.plot.DefaultAmplitude ];
 
 main_gui ( ICA );
 
 % Reconstruct signal
% 
%  bad_comp               = [ 1 3 ];
%  
%  comp_to_keep           = 1:size(m_data, 1);
%  
%  comp_to_keep(bad_comp) = [];
%  
%  m_data                 = icaproj(m_data, weights*sphere, comp_to_keep );


end

% EOF
