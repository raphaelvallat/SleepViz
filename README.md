SleepViz is a simple Matlab graphical user interface for visualization of polysomnographic data.

3 plotting components :
- Polysomnographic data (EEG, EOG, EMG, ECG)
- Spectrogram (requires Matlab Signal Processing Toolbox) 
- Hypnogram (*.txt / *.hyp)

## Doc
Please see this tutorial [on my website](https://raphaelvallat.github.io/SleepViz.html)

## Release notes
Current version: 0.2
- added function to compute sleep statistics from hypnogram (Tools > Compute Sleep Stats)
- added function to apply a simple bandpass filter (Tools > Filter Signal)
- added function to perform an automatic detection of Rapid Eye Movements (REMs) (Tools > REMs Detection)

vers. 0.1
- added support for [EDF format](http://www.edfplus.info/) using [edfread](https://fr.mathworks.com/matlabcentral/fileexchange/31900-edfread?requestedDomain=www.mathworks.com) by Brett Shoelson
- added support for [Elan file format](http://elan.lyon.inserm.fr/)
- added single-channel amplitude
- added support for hypnogram in Elan .hyp or .txt files


## Examples
Example include EDF files from two different sources

- [PhysioNet Sleep-EDF Database](https://physionet.org/physiobank/database/sleep-edfx/)
- [DREAMS Sleep Spindles Database](http://www.tcts.fpms.ac.be/~devuyst/Databases/DatabaseSpindles/)
- Elan: Nap polysomnographic data from my PhD