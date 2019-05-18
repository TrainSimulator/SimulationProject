function [pareto, improvement] = addToPareto(value, params, pareto, constraints, it)
%% Add a new data point to pareto front
npareto = length(pareto);
improvement = 0;
for i = 1:npareto
    if (value(1) < constraints(i) && value(2) < pareto(i).value(end, 2)) ...
            || (pareto(i).value(end, 1) > constraints(i) && value(1) < pareto(i).value(end, 1))
        pareto(i).value = [pareto(i).value; value];
        pareto(i).params = [pareto(i).params; params];
        pareto(i).iteration = it;
        improvement = 1;
    end
end
end
