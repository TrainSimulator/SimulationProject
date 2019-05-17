function equal = equal_params(params, params_all)
%% Check if parameters are used already
equal = 0;
for i = 1:size(params_all, 1)
    if isequal(params, params_all(i,:))
        equal = 1;
    end
end
end

