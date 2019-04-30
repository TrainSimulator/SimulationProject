

function DrawSalesman(x, problem)

DIM = size(x,2);

X_MIN = min(problem.CITIES(:, 1));
X_MAX = max(problem.CITIES(:, 1));

Y_MIN = min(problem.CITIES(:, 2));
Y_MAX = max(problem.CITIES(:, 2));


X_MIN = X_MIN - 0.1 * (X_MAX - X_MIN);
X_MAX = X_MAX + 0.1 * (X_MAX - X_MIN);

Y_MIN = Y_MIN - 0.1 * (Y_MAX - Y_MIN);
Y_MAX = Y_MAX + 0.1 * (Y_MAX - Y_MIN);


plotData = zeros(DIM + 1, 2);
for i = 1 : DIM
	city = problem.CITIES(x(i), :);
	plotData(i, :) = city;
end
plotData(DIM + 1, :) = problem.CITIES(x(1), :);

plot(plotData(:, 1), plotData(:, 2),'-ok');

end