function [Prototype,best_match_index] = SOM(X,k)
[n,p]=size(X);
% Define a 2-d lattice Q.
lattice_width = sqrt(k);
q1 = [1:lattice_width]'*ones(1,lattice_width);
q2 = ones(lattice_width,1)*[1:lattice_width];
Q = [q1(:) q2(:)];
% Define the distance squared matrix
D2 = zeros(k,k);
for j = 1:k
    for l = 1:k
        D2(j,l) = (norm(Q(j,:) - Q(l,:)))^2;
    end
end
% Set Tmax to be the maximum number of iterations
Tmax = 1000 *k;
% initialization 
t = 0;
T_0 = 1000;
alpha_0 = 0.9;
alpha_1 = 0.01;
gamma_0 = lattice_width/3;
gamma_1 = 0.5;
best_match_index = zeros(1,p);
% random prototypes
Prototype = rand(n,k);
% iteration 
while t<=Tmax
    % Find the best matching unit among the current prototypes
    i = randi([1 p]);
    x_vector = X(:,i);
    match = zeros(1,k);
    for j = 1:k
      match(1,j)= (norm(Prototype(:,j)-x_vector))^2;
    end
    [~,match_t_index] = min(match);
    best_match_index(1,i) = match_t_index;
    % Compute the current changing parameters
    alpha_t = max(alpha_0.*(1-t/T_0),alpha_1);
    gamma_t = max(gamma_0.*(1-t/T_0),gamma_1);
    % Compute the neighborhood matrix 
    H = zeros(k);
    for l = 1:k
       for j = 1:k
           H(l,j)= exp((-1/(2*(gamma_t)^2))* D2(l,j));  
       end
    end
    % update all prototype 
    for l = 1:k
        for j = 1:k
            Prototype(:,j) = Prototype(:,j)+ alpha_t * H(j,match_t_index)*(x_vector-Prototype(:,j));
        end
    end
    t = t+1;
end
end

