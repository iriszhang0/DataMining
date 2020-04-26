function [split_value,split_index] = splitting(I,C,X)
n = size(X,1);
m_j = zeros(2,n);
for j = 1:n
    [x,~,~] = unique(X(j,I));
    [x_sorted,~] = sort(x,'ascend');
    p = size(x,2);
    s = zeros(1,p-1);
    m_s = zeros(1,p-1);
    for i = 1:p-1
        % median between X(i) and X(i+1)
        s(i) = 0.5*(x_sorted(i)+x_sorted(i+1));
        % left and right points of the split value 
        I_left = I(find(X(j,I) <= s(i)));
        I_right = I(find(X(j,I) > s(i)));
        c_left = C(I_left);
        c_right = C(I_right);
        cmean_left = sum(c_left)/length(c_left);
        cmean_right = sum(c_right)/length(c_right);
        % mismatch of all X 
        m_s(i) = sum((c_left-cmean_left).^2) + sum((c_right-cmean_right).^2);
    end
    if isempty(s) 
        s = x_sorted(1);
        c = sum(C(I))/length(C(I));
        m_s(1) = sum((C(I)-c).^2);

    end
    % minimize the mismatch for each dimension
    [m_val,index]=min(m_s);
    s_star = s(index);
    m_j(:,j) = [m_val;s_star];    
end
% find the best j and s 
[~,split_index] = min(m_j(1,:));
split_value = m_j(2,split_index);

end

