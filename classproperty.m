function [p,c,r] = classproperty(data,label)
% number of data points in R
n = size(label,2);
% most frequent value 
c = mode(data(label));
class = unique(data);
k = size(class,2);
p = zeros(1,k);
for i = 1:k
    % number of data points in R that belongs to class i 
    n_i = size(find(data(label)==class(i)),2);
    p(i) = n_i/n;
end
% misclassification error 
r = 1- p(c);
end

