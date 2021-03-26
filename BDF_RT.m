%% RT script, takes the BDF files, grabs the stimulus type, ISI and RT. Organizes it by ISI and plots it in bar plots (organized in bins).
%% created by Douwe Horsthuis (douwehorsthuis@gmail.com) on 2/9/2021
clear variables
eeglab
close all
min_rt = 100; % in ms
max_rt = 1200;% in ms
type = {'bdf'}; % either bdf or set (choose .set if you have
name_savefile = 'How_to_name_the_full_data_set'; %How_to_name_the_full_data_set
% This defines the set of subjects
group = { 'TD'  }; % previous script had 2 groups, they can be added here if needed , but also change the names of line 25 and 27 according
blocks= 1; %amount of blocks/logfiles everyone did
home_path  = 'filepath_to_data'; %place data & binlist is
save_path  = 'filepath_to_save'; %place you want to save data

cond_type={'B1(3)' 'B2(4)' 'B3(5)' 'B4(5)' 'B5(4)' 'B6(3)' 'B7(3)'}; %these are the bins you created in the binlist (bin number followed by first trigger number)
new_cond_type = {'cond1' 'cond1' 'cond1' 'cond2' 'cond2' 'cond2' 'cond2'}; %these will be the new names of the bins, to make it more clear.
condition_type = {'cond1' 'cond2'}; %how ever many conditions you want to plot can be assigned here

for g_l=1:length(group)
    switch group{g_l} %both groups
        case 'TD' %rename these to the correct groups
            subject_list = {'all_file_ids' 'can_be_of_mulitple_people' };% all the ID numbers for the participants
        case 'SZ' %rename these to the correct groups
            subject_list = {'you can add here all the ID numbers for the second group if it exists'};% previous script had 2 groups
    end
    nsubj = length(subject_list);
    for s=1:nsubj % all participants
        fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{s});
        if strcmp(type, 'bdf')
            if blocks == 1
                EEG = pop_biosig([home_path  subject_list{s} '.bdf'], 'ref',[ ] ,'refoptions',{'keepref' 'off'}); %
            else
                for bdf_bl = 1:blocks
                    EEG = pop_biosig([home_path  subject_list{s} '_' num2str(bdf_bl) '.bdf'], 'ref',[ ] ,'refoptions',{'keepref' 'off'}); %
                    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
                end
                EEG = pop_mergeset( ALLEEG, [1:blocks], 0);
                EEG = pop_saveset( EEG, 'filename',[subject_list{s} '.set'],'filepath',home_path);
                [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            end
            
            EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
            EEG  = pop_binlister( EEG , 'BDF', [home_path 'binlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' );
            RT_data = {EEG.EVENTLIST.eventinfo.item; EEG.EVENTLIST.eventinfo.code; EEG.EVENTLIST.eventinfo.binlabel; EEG.EVENTLIST.eventinfo.codelabel; EEG.EVENTLIST.eventinfo.time}.';
            EEG = pop_saveset( EEG, 'filename', [name_savefile '.set'], 'filepath',home_path);
        else
            EEG = pop_loadset('filename', [name_savefile '.set'], 'filepath', home_path , 'loadmode', 'all');
            RT_data = {EEG.EVENTLIST.eventinfo.item; EEG.EVENTLIST.eventinfo.code; EEG.EVENTLIST.eventinfo.binlabel; EEG.EVENTLIST.eventinfo.codelabel; EEG.EVENTLIST.eventinfo.time}.';
        end
        RT_org = RT_data;
        non_stim = 0;
        gr_1 = 0;
        gr_2 = 0;
        gr_3 = 0;
        for i=3:length(RT_data)-2
            for cond= 1:length(cond_type)
                if  strcmp(RT_data{i,3}, cond_type{cond}) %
                    RT_data{i,6} = (RT_data{i,5} - RT_data{(i-2),5})*1000; %isi previous
                    RT_data{i,7} = (RT_data{i+2,5} - RT_data{i,5})*1000; %isi -next
                    RT_data{i,8} = (RT_data{(i+1),5} - RT_data{i,5})*1000; %rt
                    RT_data{i,3} = new_cond_type{cond};
                    gr_1 = gr_1 + 1;
                end
            end
        end
        bad_data = [];
        for i=1:length(RT_data)
            if  isempty(RT_data{i,6}) %looking for all the rows that have no rt/isi etc.
                bad_data= [bad_data; i];
            end
        end
        RT_data(bad_data,:)= [];
        bad_data = [];
        for i=1:length(RT_data)
            if  RT_data{i,8}<min_rt || RT_data{i,8}>max_rt %deleting all the RTs that are too long and too short
                bad_data= [bad_data; i];
            end
        end
        RT_data(bad_data,:)= [];
        
    end
    colNames = {'trial_n','trigger','bin' 'event_lable' 'time(s)' 'previous_isi(ms)' 'upcoming_isi(ms)' 'rt(ms)'};
    RT_Table = array2table(RT_data,'VariableNames',colNames);
    writetable(RT_Table,[save_path 'rt_data.xlsx'],'Sheet',group) %
end