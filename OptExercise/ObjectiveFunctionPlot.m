function ObjectiveFunctionPlot(values,temperatures)

% plot the values for each iteration
plot(values,'-ko');title('Objective function values over iterations');

% plot the best value
best_values = values(1);
for i=1:length(values)
    if(values(i)<best_values(end))
        best_values(i)=values(i);
    else
        best_values(i)=best_values(end);
    end
end
hold on;plot(best_values,'k:');
xlabel('Iteration');legend('iteration value','best value');

% plot the temperature %only for simulated annealing
if ~isempty(temperatures)
    figure(); semilogy(temperatures,'k');xlabel('Iteration'),ylabel('Temperature (log scale)');
end

end