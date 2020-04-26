function [Prototype,I_Prototype] = LVQ(X,I,k,L,Data,I_label)
[n,p]=size(X);
t=1;
N_max = 1000;
alpha_0 = 0.9;
beta = log(10)/N_max;
% initialize prototypes
col= size(Data,2);
P = randperm(col);
selected = P(1:L*k);
Prototype = Data(:,selected);
I_Prototype = I_label(selected,1);
while t< N_max
    % draw a random colume from training matrix 
    i = randi([1 p]);
    x_vector = X(:,i);
    i_vector = I(1,i);
    % Find the nearest prototype vector
    match = zeros(1,L*k);
    for j = 1:L*k
      match(1,j)=(norm(Prototype(:,j)-x_vector))^2;
    end
    [~,match_t_index] = min(match);
    match_t = Prototype(:,match_t_index);
    i_match_t_index = I_Prototype(match_t_index);
    % Compute the current changing parameters
    alpha_t = alpha_0*exp(-beta*t);
    % Update prototype 
    if i_match_t_index == i_vector 
        Prototype(:,match_t_index) = match_t+alpha_t*(x_vector-match_t);
    else
        Prototype(:,match_t_index) = match_t-alpha_t*(x_vector-match_t);
    end
   t=t+1;
end
end

