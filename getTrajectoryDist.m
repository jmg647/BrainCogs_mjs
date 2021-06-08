function trajectories = getTrajectoryDist(subjects)

S = subjects(~cellfun(@isempty,{subjects.testDates_0mg})); %Exclude subjects that didn't meet drug crit

trajectories = struct();

%Session indices
idx.CNOtests = @(subIdx) ismember([S(subIdx).sessions.session_date],...
    [S(subIdx).testDates_0mg, S(subIdx).testDates_5mg, S(subIdx).testDates_10mg]);
idx.sensory = @(subIdx) cellfun(@(Level) all(ismember(Level,4)),{S(subIdx).sessions.level});
idx.memory  = @(subIdx) cellfun(@(Level) all(ismember(Level,5)),...
    {S(subIdx).sessions.level}) & ~idx.CNOtests(subIdx);

for i = 1:numel(S)
        
    traj = struct(); 
    maze = ["sensory","memory"];
    choice = ["left","right"];
    
    for j = 1:numel(maze)
        sesIdx = find(idx.(maze(j))(i));
            for k = 1:numel(sesIdx)
                %Session Date
                traj.(maze(j))(k).session_date = ...
                    S(i).trialData(sesIdx(k)).session_date;
                for kk = 1:numel(choice)
                    trialIdx = ...
                        S(i).trials(sesIdx(k)).(choice(kk)) &...
                        S(i).trials(sesIdx(k)).forward &...
                        ~S(i).trials(sesIdx(k)).exclude; %Tried anonymous function F(subjIdx,sessionIdx) but that was super slow...
                    
                    traj.(maze(j))(k).(choice(kk)) = getTrajectoryStats(S(i),sesIdx(k),trialIdx);
                    
                end
                %Maze Length
                traj.(maze(j))(k).maze_length = size(S(i).trialData(sesIdx(k)).x_trajectory,1);
                %Proportion excluded trials
                traj.(maze(j))(k).pExcluded = 1-(...
                    S(i).sessions(sesIdx(k)).nForward/...
                    S(i).sessions(sesIdx(k)).nCompleted);
            end
    end
   
    trajectories.(S(i).ID) = traj;
end

    function stats = getTrajectoryStats(subj,sessionIdx,trialIdx)
        
        vars = ["x_trajectory","theta_trajectory"];
        
        for i = 1:numel(vars)
            %Raw data from specified sessions
            stats.(vars(i)).data =...
                subj.trialData(sessionIdx).(vars(i))(:,trialIdx);
            %Mean
            stats.(vars(i)).mean =...
                mean(subj.trialData(sessionIdx).(vars(i))(:,trialIdx),2);
            %Standard Deviation
            stats.(vars(i)).std =...
                std(subj.trialData(sessionIdx).(vars(i))(:,trialIdx),0,2);
            %5-number summary
            p = [9,25,50,75,91];
            stats.(vars(i)).fiveNumSummary =...
                prctile(subj.trialData(sessionIdx).(vars(i))(:,trialIdx),p,2);
            %Histogram
            %bins for eg 10% theoretical range
        end