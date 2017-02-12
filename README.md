# SleepViz

A simple tool for visualization of polysomnographic data

3 plotting components :
- Polysomnographic data (EEG, EOG, EMG, ECG)
- Spectrogram (requires Matlab Signal Processing Toolbox) 
- Hypnogram (*.txt / *.hyp)

Release notes version 0.1
- added support for [EDF format](http://www.edfplus.info/) using [edfread](https://fr.mathworks.com/matlabcentral/fileexchange/31900-edfread?requestedDomain=www.mathworks.com) by Brett Shoelson
- added support for [Elan file format](http://elan.lyon.inserm.fr/)
- added single-channel amplitude
- added support for hypnogram in Elan .hyp or .txt files

# Tutorial 

Please see this short tutorial [on my website](https://raphaelvallat.github.io/SleepViz.html)

# Examples

Example include EDF files from two different sources

- [PhysioNet Sleep-EDF Database](https://physionet.org/physiobank/database/sleep-edfx/)
- [DREAMS Sleep Spindles Database](http://www.tcts.fpms.ac.be/~devuyst/Databases/DatabaseSpindles/)
- Elan: Nap polysomnographic data from my PhD experiment



Please see this short tutorial [on my website](https://raphaelvallat.github.io/SleepViz.html)