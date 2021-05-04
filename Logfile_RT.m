%% RT script, takes the presentation logfiles, grabs the stimulus type, ISI and RT. Organizes it by ISI and plots it in bar plots (organized in bins).
%% created by Douwe Horsthuis (douwehorsthuis@gmail.com) on 2/9/2021
clear variables
logfile =[];
s1_total=[];
bar_bin_total = [];
name_logfile = 'nameofthefile';%this should be the name of your logfile, without the ID.
event_code_start = 'name_of_the_eventcode'; % this should be the name of the event code (column 4) in the logfile, that starts the RT
response_event = 2; % how many rows after the event_code_start should the response happen.
rt_data = [];
min_rt= 100;  %smallest possible RT in milisec
max_rt= 2000; %biggest possible RT in milisec
% This defines the set of subjects
group =  {'TD'} ; % previous script had 2 groups, they can be added here. if you do update check line 22
blocks= 5; %amount of blocks/logfiles everyone did
home_path  = 'data\'; %place data is
save_path  = 'save\'; %place you want to save data
for g_l=1:length(group)
    switch group{g_l} %both groups
        case 'TD'
            subject_list = {'ID' 'ID_participant_2' };% all the ID numbers for the participants
        case 'SZ'
            subject_list = {'you can add here all the ID numbers for the second group if it exists'};% previous script had 2 groups
    end
    nsubj = length(subject_list);
    for s=1:nsubj % all participants
        fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{s});
        logfile = [];
        for bl=1:blocks
            if bl == 1
                logfile_big = importdata([home_path subject_list{s} name_logfile '.log']); %importing logfile
            else
                logfile_big = importdata([home_path subject_list{s} name_logfile num2str(bl-1) '.log']); %importing logfile
            end
            for event=1:length(logfile_big.textdata)
                if strcmp(logfile_big.textdata{event,4}, event_code_start)  && strcmp(logfile_big.textdata{(event+response_event),3}, 'Response')
                    logfile_temp= [(logfile_big.textdata(event,1)),... %ID number
                        (logfile_big.textdata(event,2)),...          %Trial number (will only be odd numbers because each trial is followed by an "iti trial")
                        (logfile_big.textdata(event,4)),...        %Trial info
                        (str2num(logfile_big.textdata{event+response_event,5})-str2num(logfile_big.textdata{event,5}))/10]; %RT   
                    logfile= [logfile;logfile_temp];        
                    
                    
                    %if you need more conditions to include, or perhaps different response you can adapt below.
                    %                 elseif strcmp(logfile_big.textdata{event,4}, 'default') && strcmp(logfile_big.textdata{(event+4),3}, 'Response')&& strcmp(logfile_big.textdata{(event+5),3}, 'Response')
                    %                     logfile_temp= [(logfile_big.textdata(event,1)),... %ID number
                    %                         (logfile_big.textdata(event,2)),...          %Trial number (will only be odd numbers because each trial is followed by an "iti trial")
                    %                         (logfile_big.textdata(event+1,4)),...        %Trial info
                    %                         ((str2num(logfile_big.textdata{event+2,5})-str2num(logfile_big.textdata{event+1,5}))/10),...%ISI
                    %                         (str2num(logfile_big.textdata{event+4,5})-str2num(logfile_big.textdata{event+1,5}))/10,... %RT s1
                    %                         (str2num(logfile_big.textdata{event+5,5})-str2num(logfile_big.textdata{event+2,5}))/10];%RT s2
                    %                         
                    %                     logfile= [logfile;logfile_temp];        %it will have all the results in the data_audio matrix
                    %                 elseif strcmp(logfile_big.textdata{event,4}, 'default') && strcmp(logfile_big.textdata{(event+3),3}, 'Response')&& strcmp(logfile_big.textdata{(event+5),3}, 'Response')
                    %                     logfile_temp= [(logfile_big.textdata(event,1)),... %ID number
                    %                         (logfile_big.textdata(event,2)),...          %Trial number (will only be odd numbers because each trial is followed by an "iti trial")
                    %                         (logfile_big.textdata(event+1,4)),...        %Trial info
                    %                         ((str2num(logfile_big.textdata{event+2,5})-str2num(logfile_big.textdata{event+1,5}))/10),...%ISI
                    %                         (str2num(logfile_big.textdata{event+3,5})-str2num(logfile_big.textdata{event+1,5}))/10,... %RT s1
                    %                         (str2num(logfile_big.textdata{event+5,5})-str2num(logfile_big.textdata{event+2,5}))/10];%RT s2
                    % logfile= [logfile;logfile_temp];        %it will have all the results in the data_audio matrix
                end
            end
        end
        for data_length=1:length(logfile) %looks through the full logfile and saves the data we need
            %   if strcmp(logfile{data_length, 1}, subject_list{s}) && strcmp(logfile{data_length, 3}, s1{difs1}) %if ID matches subj ID + S1 matches s1{difs1}
            if cell2mat(logfile(data_length, 4)) <max_rt && cell2mat(logfile(data_length, 4)) >min_rt %setting max and min RT for s1
                rt_temp = [logfile(data_length, 1), logfile(data_length, 2), logfile(data_length, 3), logfile(data_length, 4)]; %Trial, ID, condition, RT                                                 %s1temp = ID + S1 + S2 + same (1) or diff (0)
                rt_data = [rt_data; rt_temp];
            end
        end
    end
    colNames = {'trial_n','ID','Condition' 'rt(ms)'};
    RT_Table = array2table(rt_data,'VariableNames',colNames);
    writetable(RT_Table,[save_path 'rt_data.xlsx'],'Sheet',string(group)) %
end