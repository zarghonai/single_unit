function [magnitude_outcome] = magnitude_outcome_calc(data,varargin)
%make a function where data is the input and the output is an array
%of the magnitude of wins and losses
%don't want it continuous in the sense that when you switch from a win to a
%loss it's going to start again at 0 and not continue from where you were
%% block 1
n_trials = length(data.block_one.choices);
for t = 2:n_trials
%rewards block    
    if contains(data.block_order{1},'pos')
        if data.block_one.outcomes(1) == 1
            block1_total(1) = 10;
        elseif data.block_one.outcomes(1) == 0
            block1_total(1) = 0;
        end
        if data.block_one.outcomes(t) == 1
            block1_outcome = 10;
        elseif data.block_one.outcomes(t) == 0
            block1_outcome = 0;
        end
        if data.block_one.outcomes(t) == data.block_one.outcomes(t-1)
            block1_total(t) = block1_total(t-1) + block1_outcome;
        end
        if data.block_one.outcomes(t) ~= data.block_one.outcomes(t-1)
            block1_total(t) = block1_outcome;
        end
    end
%punishment block
    if contains(data.block_order{1},'neg')
        if data.block_one.outcomes(1) == 1
            block1_total(1) = 0;
        elseif data.block_one.outcomes(1) == 0
            block1_total(1) = -10;
        end
        if data.block_one.outcomes(t) == 1
            block1_outcome = 0;
        elseif data.block_one.outcomes(t) == 0
            block1_outcome = -10;
        end
        if data.block_one.outcomes(t) == data.block_one.outcomes(t-1)
            block1_total(t) = block1_total(t-1) + block1_outcome;
        end
        if data.block_one.outcomes(t) ~= data.block_one.outcomes(t-1)
            block1_total(t) = block1_outcome;
        end
    end
%mixed block
    if contains(data.block_order{1},'mixed')
        if data.block_one.outcomes(1) == 1
            block1_total(1) = 10;
        elseif data.block_one.outcomes(1) == 0
            block1_total(1) = -10;
        end
        if data.block_one.outcomes(t) == 1
            block1_outcome = 10;
        elseif data.block_one.outcomes(t) == 0
            block1_outcome = -10;
        end
        if data.block_one.outcomes(t) == data.block_one.outcomes(t-1)
            block1_total(t) = block1_total(t-1) + block1_outcome;
        end
        if data.block_one.outcomes(t) ~= data.block_one.outcomes(t-1)
            block1_total(t) = block1_outcome;
        end
    end
end

%% block 2
n_trials = 35;
for t = 2:n_trials
%rewards block    
    if contains(data.block_order{2},'pos')
        if data.block_two.outcomes(1) == 1
            block2_total(1) = 10;
        elseif data.block_two.outcomes(1) == 0
            block2_total(1) = 0;
        end
        if data.block_two.outcomes(t) == 1
            block2_outcome = 10;
        elseif data.block_two.outcomes(t) == 0
            block2_outcome = 0;
        end
        if data.block_two.outcomes(t) == data.block_two.outcomes(t-1)
            block2_total(t) = block2_total(t-1) + block2_outcome;
        end
        if data.block_two.outcomes(t) ~= data.block_two.outcomes(t-1)
            block2_total(t) = block2_outcome;
        end
    end
%punishment block
    if contains(data.block_order{2},'neg')
        if data.block_two.outcomes(1) == 1
            block2_total(1) = 0;
        elseif data.block_two.outcomes(1) == 0
            block2_total(1) = -10;
        end
        if data.block_two.outcomes(t) == 1
            block2_outcome = 0;
        elseif data.block_two.outcomes(t) == 0
            block2_outcome = -10;
        end
        if data.block_two.outcomes(t) == data.block_two.outcomes(t-1)
            block2_total(t) = block2_total(t-1) + block2_outcome;
        end
        if data.block_two.outcomes(t) ~= data.block_two.outcomes(t-1)
            block2_total(t) = block2_outcome;
        end
    end
%mixed block
    if contains(data.block_order{2},'mixed')
        if data.block_two.outcomes(1) == 1
            block2_total(1) = 10;
        elseif data.block_two.outcomes(1) == 0
            block2_total(1) = -10;
        end
        if data.block_two.outcomes(t) == 1
            block2_outcome = 10;
        elseif data.block_two.outcomes(t) == 0
            block2_outcome = -10;
        end
        if data.block_two.outcomes(t) == data.block_two.outcomes(t-1)
            block2_total(t) = block2_total(t-1) + block2_outcome;
        end
        if data.block_two.outcomes(t) ~= data.block_two.outcomes(t-1)
            block2_total(t) = block2_outcome;
        end
    end
end

%% block 3
n_trials = 35;
for t = 2:n_trials
%rewards block    
    if contains(data.block_order{3},'pos')
        if data.block_three.outcomes(1) == 1
            block3_total(1) = 10;
        elseif data.block_three.outcomes(1) == 0
            block3_total(1) = 0;
        end
        if data.block_three.outcomes(t) == 1
            block3_outcome = 10;
        elseif data.block_three.outcomes(t) == 0
            block3_outcome = 0;
        end
        if data.block_three.outcomes(t) == data.block_three.outcomes(t-1)
            block3_total(t) = block3_total(t-1) + block3_outcome;
        end
        if data.block_three.outcomes(t) ~= data.block_three.outcomes(t-1)
            block3_total(t) = block3_outcome;
        end
    end
%punishment block
    if contains(data.block_order{3},'neg')
        if data.block_three.outcomes(1) == 1
            block3_total(1) = 0;
        elseif data.block_three.outcomes(1) == 0
            block3_total(1) = -10;
        end
        if data.block_three.outcomes(t) == 1
            block3_outcome = 0;
        elseif data.block_three.outcomes(t) == 0
            block3_outcome = -10;
        end
        if data.block_three.outcomes(t) == data.block_three.outcomes(t-1)
            block3_total(t) = block3_total(t-1) + block3_outcome;
        end
        if data.block_three.outcomes(t) ~= data.block_three.outcomes(t-1)
            block3_total(t) = block3_outcome;
        end
    end
%mixed block
    if contains(data.block_order{3},'mixed')
        if data.block_three.outcomes(1) == 1
            block3_total(1) = 10;
        elseif data.block_three.outcomes(1) == 0
            block3_total(1) = -10;
        end
        if data.block_three.outcomes(t) == 1
            block3_outcome = 10;
        elseif data.block_three.outcomes(t) == 0
            block3_outcome = -10;
        end
        if data.block_three.outcomes(t) == data.block_three.outcomes(t-1)
            block3_total(t) = block3_total(t-1) + block3_outcome;
        end
        if data.block_three.outcomes(t) ~= data.block_three.outcomes(t-1)
            block3_total(t) = block3_outcome;
        end
    end
end

%% put it all together
magnitude_outcome = [block1_total block2_total block3_total]';

