%For manual exclusion of sessions in which data were compromised by rig problems, etc.

function subjects = excludeBadSessions( subjects, experiment )

fields = ["logs","trials","trialData","sessions"];

switch experiment
    case 'mjs_memoryMaze_NAc_DREADD_performance'
        
        exclude = {...
            "mjs20_439",datetime('2021-04-23');...
            "mjs20_439",datetime('2021-05-04');
            "mjs20_665",datetime('2021-03-11')};
        
    case 'mjs_taskLearning_NAc_DREADD2'
        %**M11 & M12 were switched on 210702...
        exclude = {...
            "mjs20_11",datetime('2021-07-02');...
            "mjs20_12",datetime('2021-07-02');...
            "mjs20_13",datetime('2021-08-06');... %Milk spout leaking...
            "mjs20_15",datetime('2021-08-11');... %Milk spout leaking
            "mjs20_11",datetime('2021-08-18');...
            "mjs20_12",datetime('2021-08-18');...
            "mjs20_13",datetime('2021-08-18');...
            "mjs20_14",datetime('2021-08-18');...
            "mjs20_15",datetime('2021-08-18');...
            "mjs20_16",datetime('2021-08-18');...
            "mjs20_17",datetime('2021-08-18');... %Bug with reward delivery (omitted after error)
            "mjs20_17",datetime('2021-08-26')};   %Mounting apparatus failed (head plate rotated) 
end

for i = 1:size(exclude,1)
    subIdx = [subjects.ID]==exclude{i,1};
    exclSessionIdx = [subjects(subIdx).sessions.session_date]==exclude{i,2};
    for j=1:numel(fields)
        subjects(subIdx).(fields(j)) = subjects(subIdx).(fields(j))(~exclSessionIdx);
    end
end