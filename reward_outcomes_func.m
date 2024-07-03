function [reward_outcomes, outcomes1, outcomes2, outcomes3] = reward_outcomes_func(data)
n_blocks = 3;
for i = 1:n_blocks
    %block 1
    if contains(data.block_order{1}, 'pos')
        outcomes1 = data.block_one.outcomes;
        wins1 = find(outcomes1 == 1);
        outcomes1(wins1) = 10; 
    elseif contains(data.block_order{1}, 'neg')
        outcomes1 = data.block_one.outcomes;
        loss1 = find(outcomes1 == 0);
        outcomes1(loss1) = -10;
        wins1 = find(outcomes1 == 1);
        outcomes1(wins1) = 0;
    else contains(data.block_order{1}, 'mix')
        outcomes1 = data.block_one.outcomes;
        wins1 = find(outcomes1 == 1);
        outcomes1(wins1) = 10;
        loss1 = find(outcomes1 == 0);
        outcomes1(loss1) = -10;
    end
    %block 2
    if contains(data.block_order{2}, 'pos')
        outcomes2 = data.block_two.outcomes;
        wins2 = find(outcomes2 == 1);
        outcomes2(wins2) = 10; 
    elseif contains(data.block_order{2}, 'neg')
        outcomes2 = data.block_two.outcomes;
        loss2 = find(outcomes2 == 0);
        outcomes2(loss2) = -10;
        wins2 = find(outcomes2 == 1);
        outcomes2(wins2) = 0;
    else contains(data.block_order{2}, 'mix')
        outcomes2 = data.block_two.outcomes;
        wins2 = find(outcomes2 == 1);
        outcomes2(wins2) = 10;
        loss2 = find(outcomes2 == 0);
        outcomes2(loss2) = -10;
    end  
    %block 3
    if contains(data.block_order{3}, 'pos')
        outcomes3 = data.block_three.outcomes;
        wins3 = find(outcomes3 == 1);
        outcomes3(wins3) = 10; 
    elseif contains(data.block_order{3}, 'neg')
        outcomes3 = data.block_three.outcomes;
        loss3 = find(outcomes3 == 0);
        outcomes3(loss3) = -10;
        wins3 = find(outcomes3 == 1);
        outcomes3(wins3) = 0;
    else contains(data.block_order{3}, 'mix')
        outcomes3 = data.block_three.outcomes;
        wins3 = find(outcomes3 == 1);
        outcomes3(wins3) = 10;
        loss3 = find(outcomes3 == 0);
        outcomes3(loss3) = -10;
    end       
end

reward_outcomes = [outcomes1' outcomes2' outcomes3']';
