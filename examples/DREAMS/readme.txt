- excerpt1 is from the REMs database (http://www.tcts.fpms.ac.be/~devuyst/Databases/DatabaseREMs/).
It consist of 9 excerpts of 30 minutes of PSG recordings in which rapid eye movements (REMs) were annotated by an experts.

-excerpt 2 and 4 are from the Spindles database (http://www.tcts.fpms.ac.be/~devuyst/Databases/DatabaseSpindles/).
It consist of 8 excerpts of 30 minutes of central EEG channel (extracted from whole-night PSG recordings), annotated independently by two experts in sleep spindles.

REMs database description:
-------------------------------------
Data collected were acquired in a sleep laboratory of a belgium hospital using a digital 32-channel polygraph (BrainnetTM System of MEDATEC, Brussels, Belgium). They consist of 9 excerpts of PSG recordings, coming from 5 healthy subjects. Two EOG channels (P8-A1, P18-A1), three EEG channels (CZ-A1 or C3-A1, FP1-A1 and O1-A1) and one submental EMG channel were recorded. The standard European Data Format (EDF) was used for storing. The sampling frequency was 200Hz. These excerpts of 30 minutes were extracted from whole-night recordings. No care was provided to select epochs free of artifacts, but a special effort was provided to cover all sleep stages. (Indeed, sleep stages were previously scored according to the Rechtschaffen and Kales criteria, but no note of this stages cotation was provided to the scorer during the annotation in REMs). 


Spindles database description:
-------------------------------------
The data were acquired in a sleep laboratory of a belgium hospital using a digital 32-channel polygraph (BrainnetTM System of MEDATEC, Brussels, Belgium). They consist of height polysomnographic recordings coming from patients with different pathologies (dysomnia, restless legs syndrome, insomnia, apnoea/hypopnoea syndrome). Two EOG channels (P8-A1, P18-A1), three EEG channels (CZ-A1 or C3-A1, FP1-A1 and O1-A1) and one submental EMG channel were recorded. The standard European Data Format (EDF) was used for storing. The sampling frequency was 200Hz, 100Hz or 50Hz. A segment of 30 minutes of the central EEG channel was extracted from each whole-night recording for spindles scoring. No effort was made to select good spindle epochs or noise free epochs, in order to reflect reality as well as possible. These excerpts were given independently to two experts for sleep spindles scoring. The second expert only scored the 6 first excerpts. The corresponding whole night recordings were also previously scored in sleep stages according to the Rechtschaffen and Kales criteria,but no note of these stages quotations was given to the scorers.

Hypnograms format:
-------------------------------------
Hypnogram_excerpt.txt: is a textual file containing, in first line, the name "[hypnogram]" followed by one column of integer. These numerical values correspond to the sleep stage (one value per 5 sec) annotated by the expert according to the Rechtschaffen and Kales criteria.
5=wake
4=REM stage
3=sleep stage S1
2=sleep stage S2
1=sleep stage S3
0=sleep stage S4
-1=sleep stage movement
-2 or -3 =unknow sleep stage 