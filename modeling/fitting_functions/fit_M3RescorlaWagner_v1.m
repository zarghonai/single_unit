% As an input, enter the sequences of actions and rewards.
% As an output, extract the fitted parameter values, the 
% loglikelihood LL of the fit and its BIC criterion.

function [Xfit_rw, LL, BIC] = fit_M3RescorlaWagner_v1(a, r)

% call the function that calculate the likelihood using Model3
obFunc = @(x) lik_M3RescorlaWagner_v1(a, r, x(1), x(2));

% initialise starting points
X0 = [rand exprnd(1)];

% specify options for fmincon
LB = [0 0];
UB = [1 50];

% gradient descent
[Xfit_rw, NegLL] = fmincon(obFunc, X0, [], [], [], [], LB, UB);

% do not forget to invert the sign of loglikelihood
LL = -NegLL;

% Bayesian information criterion, including number of trials (here entered
% as length of the sequence of actions) and number of parameters (here
% entered as length of starting points)
BIC = length(X0) * log(length(a)) + 2*NegLL;