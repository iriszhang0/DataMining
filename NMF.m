function [W,H] = NMF(X,k)
[n,p] = size(X);
eps = 2.22*10^-16;
tau = 0.01;
Tmax = 10^4;
test = 10^5;
% Initialize W and H 
Wc = rand(n,k);
W = Wc;
Hc = rand(k,p);
H = Hc; 
t = 0; 
while t < Tmax && test > tau
% Update W 
W_sub = W*H+eps; 
W_prestep = zeros(n,p);
for i =1:n
    for j = 1:p
       W_prestep(i,j)= X(i,j)./ W_sub(i,j);
    end
end
% W_prestep;
W_step = W_prestep * H';
for i = 1: n
    for j = 1:k
        W(i,j) = W(i,j).* W_step(i,j); 
    end   
end
% Normalize the column sums of W 
D = sum(W);
D_eps_part = 1./(D+eps);
D_eps = diag(D_eps_part);
W = W * D_eps;

% Update H
H_sub = W*H+eps; 
H_prestep = zeros(n,p); 
for i =1:n
    for j = 1:p
       H_prestep(i,j)= X(i,j)./ H_sub(i,j); 
    end
end
H_step = W'* H_prestep;
for i = 1:k
    for j = 1:p
        H(i,j) = H(i,j).* H_step(i,j); 
    end
end
test_1 = norm(W-Wc,'fro')./norm(Wc,'fro');
test_2 = norm(H-Hc,'fro')./norm(Hc,'fro');
test = test_1+test_2;
Wc = W;
Hc = H;
t = t+1; 
end
end

