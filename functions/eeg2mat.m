function [m_data,m_events,v_label_selected,s_fs,s_nb_samples_all,s_nb_channel_all,v_label_all,v_channel_type_all,v_channel_unit_all,str_ori_file1,str_ori_file2] = eeg2mat(filename,s_sample_start,s_sample_stop,v_channel_list,varargin)
%% function 
%        [m_data,m_events,v_label_selected,s_fs,s_nb_samples_all,s_nb_channel_all,v_label_all,v_channel_type_all,v_channel_unit_all,str_ori_file1,str_ori_file2] = eeg2mat(filename,s_sample_start,s_sample_stop,v_channel_list,varargin)
%
% filename           : input filename '.eeg' with the complete path
% s_sample_start     : sample number at the beginning of reading window
%                      = 1 to start at the first sample
% s_sample_stop      : sample number at the end of the reading window
%                      ='all' to  select all samples after s_sample_start
% v_channel_list     : vector of selected channels (rank in the eeg file)
%                      ='all' to select all channels
% OPTIONAL :
%          *  'save',mat_name : to save all the results in a .mat file named mat_name.mat
%          
%
% m_data             : data recorded by the selected channels (units as in the .eeg file), 1 channel per line, 1 sample per column
% m_events           : Table with the events (samples and event codes)
% v_label_selected   : name of the selected channels
% s_fs               : Sampling frequency (Hz)
% s_nb_samples_all   : Total number of samples per channel in eeg file
% s_nb_channel_all   : Total number of channels
% v_label_all        : Name of all channels (with numbers in elec.dat)
% v_channel_type_all : Sensor types (EEG, MEG, ...)
% v_channel_unit_all : Sensor units (µV, fT, ...)
% str_ori_file1      : Acquisition system
% str_ori_file2      : Acquisition place
%
% V01 Emmanuel Maby, le 23/10/2009
%
% V02 Emmanuel Maby, le 06/11/2009
%%
% V03 Emmanuel Maby, le 13/01/2010
%
% V04 Emmanuel Maby, le 05/03/2010
% Added parameter => s_nb_samples_all : Total number of samples per channel in eeg file
% v1.05 (09-08-2010) PEA
% Minor change : version number to follow Elan rules.
flag_save = 0;
if ~isempty(varargin)
    for i_arg=1:length(varargin)
        if strcmpi(varargin{i_arg},'save');
            flag_save = 1;
            mat_name = varargin{i_arg+1};
        end
    end
end


[path, file, ext] = fileparts(filename);
lg_ext=length(ext);

if ext =='.eeg'
    a_eegfile=filename;
else
    error('Error : File format must be  ".eeg"')

end


%
% -**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
% -**--**--**--         EEG.ENT FILE READING        --**--**--**--**
% -**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**

%OPENING the .EEG.ENT  file
a_entfile=[a_eegfile '.ent'];
f_ent=fopen(a_entfile,'r');


% eeg data Version
a_version=fgetl(f_ent);

switch a_version
    case 'V3',
        nboct=4;
        formread='int32';

    case 'V2',
        nboct=2;
        formread='int16';
end


% Acquisition system
str_ori_file1=fgetl(f_ent);
% Acquisition place
str_ori_file2=fgetl(f_ent);



%--------------------
a_line=fgetl(f_ent); % Recording time
a_line=fgetl(f_ent);
a_line=fgetl(f_ent);
a_line=fgetl(f_ent);
a_line=fgetl(f_ent);

s_sampleperiod_s=str2num(fgetl(f_ent));
s_fs=round(1/s_sampleperiod_s); % sampling frequency in Hz

s_nb_channel_all=str2num(fgetl(f_ent)); %number of channels
[ent_text]=textread(a_entfile,'%s','delimiter','\n','emptyvalue',NaN);

for j=1:size(ent_text,1)
    if (isempty(ent_text{j}))
        ent_text{j}='Unknown';
    end
end

v_channel_type_all = ent_text(11+s_nb_channel_all:10+2*s_nb_channel_all);
v_channel_unit_all = ent_text(11+(2*s_nb_channel_all):10+(3*s_nb_channel_all));

OFF_SET1=10+(3*s_nb_channel_all);
OFF_SET2=10+(4*s_nb_channel_all);
OFF_SET3=10+(5*s_nb_channel_all);
OFF_SET4=10+(6*s_nb_channel_all);
Gain=[];
v_NAMCHAN_Ent=ent_text(11:10+s_nb_channel_all);









for i=1:s_nb_channel_all
    MinAn=sscanf(cell2mat(ent_text(OFF_SET1+i)),'%f');
    MaxAn=sscanf(cell2mat(ent_text(OFF_SET2+i)),'%f');
    MinNum=sscanf(cell2mat(ent_text(OFF_SET3+i)),'%f');
    MaxNum=sscanf(cell2mat(ent_text(OFF_SET4+i)),'%f');
    Gain(i)=(MaxAn-MinAn)/(MaxNum-MinNum);
    v_label_all{i}=v_NAMCHAN_Ent{i};
end


%CLOSING the .EEG.ENT file
fclose(f_ent);
% -**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
% -**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
% -**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**





if (isstr(v_channel_list))
    if v_channel_list=='all'
        v_channel_list=1:s_nb_channel_all-2;
    end
end

for i=1:length(v_channel_list)
    v_label_selected{i}=v_label_all{v_channel_list(i)};
end



%OPENING the .EEG file
f_in=fopen(a_eegfile,'r','ieee-be');



%Number of samples
fseek(f_in,0,1);
nbbits=ftell(f_in);
s_nb_samples_all=nbbits/(nboct*s_nb_channel_all);
frewind(f_in);





% get the data for this latency
fseek(f_in,(s_sample_start-1)*s_nb_channel_all*nboct,-1);

if ischar(s_sample_stop)
    if s_sample_stop == 'all'
        NbSample_AftLatency = s_nb_samples_all-s_sample_start+1;
    end
else
    NbSample_AftLatency=s_sample_stop-s_sample_start+1;
end



m_readbrut=fread(f_in,[s_nb_channel_all,NbSample_AftLatency],formread);
m_data=diag(Gain(v_channel_list))*m_readbrut(v_channel_list,:); % Data values after multiplication by Gain




% Read Num2 channels to compute m_events matrix
m_Num2 = m_readbrut(end,:);
i_event=find(m_Num2 ~=0);
m_events  = ([i_event;m_Num2(i_event)])';




%CLOSING the .EEG file
fclose(f_in);




% save data if necessary
if flag_save == 1
    save(mat_name,'m_data','m_events','v_label_selected','s_fs','s_nb_samples_all','s_nb_channel_all','v_label_all','v_channel_type_all','v_channel_unit_all','str_ori_file1','str_ori_file2');
end
