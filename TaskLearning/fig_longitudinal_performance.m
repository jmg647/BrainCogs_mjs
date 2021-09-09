function figs = fig_longitudinal_performance( subjects, vars_cell )

% vars = struct('pCorrect',false,'pOmit',false,'mean_velocity',false);
for i = 1:numel(vars_cell)
    vars{i} = vars_cell{i};
end

setup_figprops('placeholder'); %Customize for performance plots
figs = gobjects(0);

%Plotting params
lineWidth = 1;
shadeOffset = 0.2;
transparency = 0.2;

%Colors
cbrew = brewColorSwatches;
colors = setPlotColors(cbrew);
colors.mean_stuckTime = cbrew.orange;
colors.mean_velocity = cbrew.green;

% Plot Performance as a function of Training Day
% one panel for each subject

%Load performance data
% for the future let's parse relevant data before saving as MAT
prefix = 'Performance';

for i = 1:numel(subjects)
    %Performance as a function of training day
    figs(i) = figure(...
        'Name',join([prefix, subjects(i).ID, string(vars)],'_'));
    tiledlayout(1,1);
    ax = nexttile();
    hold on;
    
    % Shade according to different phases of training
    levels = cellfun(@min,{subjects(i).sessions.level});
    values = unique(levels(isfinite(levels)));
    for j = 1:numel(values)
        pastLevels = levels >= values(j);% Sessions at each level
        shading(j) = shadeDomain(find(pastLevels),...
            ylim, shadeOffset, colors.level(values(j),:), transparency);
    end
        
    %Line at 0.5 for proportional quantities
    X = 1:numel(subjects(i).sessions);
    if all(ismember(vars,{'pCorrect','pCorrect_conflict','pOmit'}))
        plot([0,X(end)+1],[0.5, 0.5],...
            ':k','LineWidth',1);
    end

    yyax = {'left','right'};
    for j = 1:numel(vars)
        %Dual Y-axes or 0.5 line for proportional quantities
        if numel(vars)>1 && any(~ismember(vars,...
                {'pCorrect','pCorrect_conflict','pOmit'}))
            yyaxis(ax,yyax{j});
            ax.YAxis(j).Color = colors.(vars{j});
        end
        
        p(j) = plot(X, [subjects(i).sessions.(vars{j})],...
            '.','MarkerSize',20,'Color',colors.(vars{j}),...
            'LineWidth',lineWidth,'LineStyle','none');
        
        marker = {'o','o','_'};
        faceColor = {colors.(vars{j}),'none','none'};
        if numel(vars)>1 %&& isequal(colors.(vars{j}),colors.(vars{j-1}))
            set(p(j),'Marker',marker{j},...
                'MarkerSize',8,...
                'MarkerFaceColor',faceColor{j},...
                'LineWidth',lineWidth);
            if j==numel(vars)
                if isequal(vars,{'pCorrect','pCorrect_conflict'})
                    if  ~all(isnan([subjects(i).sessions.pCorrect_conflict]))
                        legend(p,{'All','Conflict'},'Location','northwest');
                    end
                else
                    legendVars = cellfun(@(C) ~all(isnan([subjects(i).sessions.(C)])), vars);
                    legend(p,vars{legendVars},'Location','northwest');
                end
            end
        end
        
        switch vars{j}
            case {'pCorrect','pCorrect_conflict'}
                ylabel('Accuracy');
                ylim([0, 1]);
            case {'pOmit','pConflict','pStuck'}
                ylabel('Proportion of trials');
                ylim([0, 1]);
            case 'mean_velocity'
                ylabel('Mean velocity (cm/s)');
            case 'mean_stuckTime'
                ylabel('Proportion of time spent stuck');
                ylim([0, 1]);
            case 'mean_pSkid'
                ylabel('Proportion of maze spent skidding');
                ylim([0, 1]);
            case 'nCompleted'
                ylabel('Number of completed trials');
        end
    end

    
    %Axes scale
    ax.PlotBoxAspectRatio = [3,2,1];
    xlim([0, max(X)+1]);
    
    %Labels and titles
    xlabel('Session number');
    
    title(subjects(i).ID,'interpreter','none');
    
    %Adjust height of shading as necessary
    newVert = [max(ylim(ax(1))),max(ylim(ax(1))),min(ylim(ax(1))),min(ylim(ax(1)))];
    for j = 1:numel(shading)
        shading(j).Vertices(:,2) = newVert;
    end
    clearvars shading
end
end %End main fcn

function p = shadeDomain( xVals, yLims, shadeOffset, color, transparency )

if isempty(xVals)
    return
end

%Find start and end of each block
startVal = xVals(logical([1, diff(xVals)-1]));
endVal = xVals(logical([diff(xVals)-1, 1]));

%Color patchs
for i = 1:numel(startVal)
    X = [startVal(i)-shadeOffset, endVal(i)+shadeOffset];
    X = [X, fliplr(X)];
    Y = [yLims(2),yLims(2),yLims(1),yLims(1)];
    p = patch(X, Y, color,'EdgeColor','none',...
        'FaceAlpha',transparency);
end

end