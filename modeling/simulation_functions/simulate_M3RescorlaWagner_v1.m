% As an input, this function will take:
%   - number of trials
%   - the mean reward for each bandit
%   - learning rate alpha
%   - softmax parameter beta

% As an output, this function will return:
%   - the sequence of actions chosen by the model
%   - the sequence of rewards received by the model (0/1)

function [a, r] = simulate_M3RescorlaWagner_v1(T, mu, alpha, beta, reversal_trials)

% initialise Q values for each of the two options
Q = [0.5 0.5];

% loop over trials
for t = 1:T
    if any(reversal_trials(:) == t)
        mu = flip(mu); 
    end
    
    % compute choice probabilities using softmax formula
    p = exp(beta*Q) / sum(exp(beta*Q));
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    r(t) = rand < mu(a(t));
    
    % update values using prediction error term
    delta = r(t) - Q(a(t));
    
    Q(a(t)) = Q(a(t)) + alpha * delta;

end

