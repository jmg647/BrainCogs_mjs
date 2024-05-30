function [p, lgd] = plotPsychometric(psychStruct, cueName, colors, title_str)

c.all = colors.black;
c.congruent = colors.gray;
c.conflict = colors.red;

f = string(fieldnames(psychStruct))';
if ~isempty(f)
    for i=1:numel(f)
        %Plot p(right) as f(nCuesR-nCuesL)
        X = psychStruct.(f(i)).(cueName).bins;
        Y = psychStruct.(f(i)).(cueName).pRight;
        p(i) = plot(X,Y,'.',"LineStyle","none","MarkerSize",10,"Color", c.(f(i))); hold on;

        %Plot fit lines
        plot(psychStruct.(f(i)).(cueName).bins, psychStruct.(f(i)).(cueName).curvefit, "Color", c.(f(i)));
    end
        else
        p = plot(1,1);
end

title(title_str);
lgd = legend(p,f);
xlabel('nRightCues-nLeftCues');
ylabel('P(chose right)');
axis square;