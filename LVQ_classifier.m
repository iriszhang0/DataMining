function [I_LVQ] = LVQ_classifier(X,Prototype,L,k,I_Prototype)
[n,p]=size(X);
I_LVQ=zeros(1,p);
for i=1:p
    x_vector = X(:,i);
    match = zeros(1,L*k);
    for j = 1:L*k
      match(1,j)= (norm(Prototype(:,j)-x_vector))^2;
    end
    [~,match_t_index] = min(match);
    I_LVQ(1,i) = I_Prototype(match_t_index);
end

