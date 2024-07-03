function [conditions] = condition_sequence(block_order, pt_id)
%conditions = zeros(105,1);
% if pt_id == "360_2"
%     if contains(block_order(1), 'neg')
%         conditions(1:34) = 2;
%     elseif contains(block_order(1), 'pos')
%         conditions(1:34) = 1;
%     else block_order(1)
%         conditions(1:34) = 3;
%     end
% 
%     if contains(block_order(2), 'neg')
%         conditions(35:69) = 2;
%     elseif contains(block_order(2), 'pos')
%         conditions(35:69) = 1;
%     else block_order(2)
%         conditions(35:69) = 3;
%     end
% 
%     if contains(block_order(3), 'neg')
%         conditions(70:104) = 2;
%     elseif contains(block_order(3), 'pos')
%         conditions(70:104) = 1;
%     else block_order(3)
%         conditions(70:104) = 3;
%     end
% else 
    if contains(block_order(1), 'neg')
        conditions(1:35) = 2;
    elseif contains(block_order(1), 'pos')
        conditions(1:35) = 1;
    else block_order(1)
        conditions(1:35) = 3;
    end
    
    if contains(block_order(2), 'neg')
        conditions(36:70) = 2;
    elseif contains(block_order(2), 'pos')
        conditions(36:70) = 1;
    else block_order(2)
        conditions(36:70) = 3;
    end
    
    if contains(block_order(3), 'neg')
        conditions(71:105) = 2;
    elseif contains(block_order(3), 'pos')
        conditions(71:105) = 1;
    else block_order(3)
        conditions(71:105) = 3;
    end
% end


