% Generate Tables to Record Daily Intake and Weight

function intake = dailyIntakeTable(dirs, experiment, subject)

%Retrieve data from logfiles
data = getMouseData(dirs.data,experiment,subject); %Set 'dataPath' = [] to retrieve from bucket

%Calculate daily reward volume
for i = 1:numel(subject)

    %Unpack
    subjID = subject(i).ID;
    startDate = subject(i).startDate;
    
    %Initialize session variables
    logData = data.(subjID).logs;
    date = zeros(numel(logData),6); 
    rewEarned = NaN(numel(logData),1);
   
    %Get total reward volume for each day by summing blocks
    for j = 1:numel(logData)               
        rewardMiL = 0;
        for k = 1:length(logData(j).block)
            rewardMiL = rewardMiL + logData(j).block(k).rewardMiL;
        end
        date(j,1:3) = logData(j).session.start(1:3); %Remove time
        rewEarned(j,:) = rewardMiL;
    end
    sessionDate = datetime(date,'format','yyyy-MM-dd');
    
    %Table variables
    date = (startDate : sessionDate(end))'; %All set to 00:00:00 for indexing by date
    subject_fullname = repmat(subject(i).ID,numel(date),1);
    earned = NaN(numel(date),1);
    supplementary = NaN(numel(date),1);
    weight = NaN(numel(date),1);
       
    %Load existing table and append new data
    excelPath = fullfile(dirs.save,'Daily_Intake.xls');
    if exist(excelPath,'file') && ismember(subjID,sheetnames(excelPath))
        %Update table
        T = readtable(excelPath,'Sheet',subjID);
        newRows = abs(size(T,1)-size(date,1));
        if size(date,1)>size(T,1)
            %Add rows to existing sheet
            T2 = table(subject_fullname,date,earned,supplementary,weight);
            idx = [false(size(date,1)-newRows,1); true(newRows,1)];
            T = [T; T2(idx,:)];
        else %Fill in missing values
            T.date = (startDate : startDate+size(T,1)-1)';
        end
    else
        T = table(subject_fullname,date,earned,supplementary,weight);
    end
    T.earned(ismember(T.date,sessionDate)) = rewEarned;
    
    intake.(subjID) = T;
    writetable(T,excelPath,'Sheet',subjID);
end

%Concatenate tables for use in DB
catIntakeTables(intake,dirs.save);

%Save as MAT
save(fullfile(dirs.save,'Daily_Intake'),'-struct','intake');