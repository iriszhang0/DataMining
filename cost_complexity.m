function [cost] = cost_complexity(R,n,C)
weight = length(R.I)/n;
[~,~,r] = classproperty(C,R.I);
cost = weight*r;
end

