function [ hdr, data ] = elan2edf( fname)

[data,~,~, hdr.frequency,hdr.samples, hdr.ns, hdr.label,~, hdr.units] = eeg2mat(fname ,1, 'all', 'all');

end

