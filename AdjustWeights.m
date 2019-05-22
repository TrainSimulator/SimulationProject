function weights = AdjustWeights(weights, idx, pos, level)
%% Adjust neighbourhood weights
if pos
    weights(idx) = weights(idx) + 2;
end
% totalneighbours = length(weights);
% nneighbourhoods = 30;
% % Change sign based on improvement or not 
% if pos
%     sign = 1;
% else
%     sign = -1;
% end
% 
% if level == 2
%     weights = weights - sign * 1;
%     weights(idx) = weights(idx) + sign * (totalneighbours + 1);
% else
%     weights(1:nneighbourhoods) = weights(1:nneighbourhoods) - sign * 1;
%     weights(idx) = weights(idx) + sign * (nneighbourhoods + 1);
% end
end
