function [V,D,Xw] = LDA(X,I,clusters_num)
tau = 10^-16;
[n,p]=size(X);

% calculate the global mean
c = 1/p*sum(X,2);

Xw = [];
for i = 1:clusters_num
    X_{i} = X(:,I==i);
    b = size(X_{i},2);
    % calculate the cluster means
    c_{i} = 1/(b)*sum(X_{i},2);
    Xc_{i} = X_{i} - repmat(c_{i},1,b);
    Xw = [Xw Xc_{i}]; 
end

Sw = Xw * Xw';
Sw = Sw + tau *eye(size(Sw));
Sb = zeros(n,n);

for i = 1:clusters_num
    b2= size(X_{i},2);
    Sb = Sb + b2*(c_{i}-c)*(c_{i}-c)';
end

Sb = Sb + tau*eye(size(Sb));
A = Sw\Sb;
[D,V] = eigs(A,3,'LM');

end

