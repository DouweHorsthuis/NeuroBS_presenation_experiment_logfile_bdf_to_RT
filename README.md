# NeuroBS_presenation_RT
Calculation the RT of data from experiments ran in Presentation® (Neurobehavioral Systems) using BDF (biosemi EEG data) or the logfiles created by the program it self

Using one of the two matlab files allows you to calculate the reaction time of your data. 

Logfile_RT - loads all the logfiles of 1 participant, needs the event_code to start counting the RT and needs to know how many stim later the response is. if you need more conditions to include, or perhaps different response you can adapt. Will give you a matlab table and excel table with all RTs

BDF_RT - Needs EEGlab plugin - loads all the BDF files of 1 particpant, needs an binlist (https://github.com/lucklab/erplab/wiki/ERP-Bin-Operations). Will give you a matlab table and excel table with all RTs

