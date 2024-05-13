function bootParams = specBootAvgParams( generalParams )

i = 1;
%Cue responses
%Do cue responses or selectivity differ on correct vs. error trials?
%Contralateral Towers vs. Puffs??
%Tactile vs. Visual Rule?
bootParams(i).trigger = "towers";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["leftTowers"],...
    ["rightTowers"],...
    ["leftTowers","left"],...
    ["leftTowers","right"],...
    ["rightTowers","right"],...
    ["rightTowers","left"]};
i = i+1;

%Left and right cues aligned to cue onsets
bootParams(i).trigger = "puffs";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["leftPuffs"],...
    ["rightPuffs"],...
    ["leftPuffs","left"],...
    ["leftPuffs","right"],...
    ["rightPuffs","right"],...
    ["rightPuffs","left"]};
i = i+1;

%All trials aligned to cueEntry
bootParams(i).trigger = "cueEntry";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    "forward"};
i = i+1;

%Aligned to y-position, no baseline subtraction
bootParams(i).trigger = "cueRegion";
bootParams(i).subtractBaseline = false;
bootParams(i).trialSpec = {...
    ["forward"],...
    ["leftPuffs"],...
    ["rightPuffs"],...
    ["leftTowers"],...
    ["rightTowers"],...
    ["left"],...
    ["right"],...
    ["left","correct"],...
    ["right","correct"],...
    ["correct"],... %"Accuracy"
    ["error"],...
    ["priorCorrect"],...
    ["priorError"],...
    ["priorLeft"],...
    ["priorRight"],...
    ["congruent","left"],...
    ["conflict","left"],...
    ["congruent","right"],...
    ["conflict","right"],...
    ["congruent"],...
    ["conflict"]};
i = i+1;

%Aligned to outcome
bootParams(i).trigger = "outcome";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["correct"],...
    ["error"],...
    ["correct","priorCorrect"],...
    ["correct","priorError"],...
    ["error","priorCorrect"],...
    ["error","priorError"],...
    ["left","correct"],...
    ["right","correct"],...
    ["left","error"],...
    ["right","error"],...
    ["congruent","correct"],...
    ["conflict","correct"],...
    ["congruent","error"],...
    ["conflict","error"]};
i = i+1;

%Left and right cues aligned to first cue onset
bootParams(i).trigger = "firstPuff";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["leftPuffs"],...
    ["rightPuffs"],...
    ["leftPuffs","left"],...
    ["leftPuffs","right"],...
    ["rightPuffs","right"],...
    ["rightPuffs","left"]};
i = i+1;

bootParams(i).trigger = "firstTower";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["leftTowers"],...
    ["rightTowers"],...
    ["leftTowers","left"],...
    ["leftTowers","right"],...
    ["rightTowers","right"],...
    ["rightTowers","left"]};
i = i+1;

%Left and right cues aligned to first cue onset
bootParams(i).trigger = "lastPuff";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["leftPuffs"],...
    ["rightPuffs"],...
    ["leftPuffs","left"],...
    ["leftPuffs","right"],...
    ["rightPuffs","right"],...
    ["rightPuffs","left"]};
i = i+1;

bootParams(i).trigger = "lastTower";
bootParams(i).subtractBaseline = true;
bootParams(i).trialSpec = {...
    ["leftTowers"],...
    ["rightTowers"],...
    ["leftTowers","left"],...
    ["leftTowers","right"],...
    ["rightTowers","right"],...
    ["rightTowers","left"]};
i = i+1;

%Append general params
fields = string(fieldnames(generalParams)); %Some params specified in params_...m may overwrite bootParams(i)
for j = 1:numel(fields)
    if fields(j)=='subtractBaseline' && ~generalParams.subtractBaseline
        continue
    end
    [bootParams(1:numel(bootParams)).(fields{j})] = deal(generalParams.(fields{j}));
end

