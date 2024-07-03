function [a, r] = simulate_M1random_v1(T, mu, b, reversal_trials)

% T = number of trials, i.e. 105
% mu = reward probability of each option, i.e. [0.2, 0.8]
% b = bias parameter i.e. 0.5 (no bias) 

for t = 1:T
    if any(reversal_trials(:) == t)
        mu = flip(mu); 
    end
    % compute choice probabilities
    p = [b 1-b];
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    r(t) = rand < mu(a(t));
    
end
