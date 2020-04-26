I = [1:35, 71:105, 141:175];
[n,l] = size(I);
%% Growing Tree 
R(1).I=(I);
[p,c,r] = classproperty(C,R(1).I);
% initialization
R(1).p = p;
R(1).j = NaN;
R(1).s = NaN; 
R(1).left = NaN;
R(1).right = NaN; 
PureNodes = [];
MixedNodes =[1];
count = 1;
% iteration 
while length(MixedNodes)>0
    % pick a rectangle and find the optimal splitting
    index = MixedNodes(1);
    I_index = R(index).I;
    X_index = seedsdata(:,I_index);
    [s,j] = splitting(I_index,C,seedsdata);
    % assign new leaves 
    R(index).j = j;
    R(index).s = s;
    R(index).left = count+1;
    R(index).right = count+2;
    I_left = I_index(find(X_index(j,:)<=s));
    [p_left, c_left, r_left] = classproperty(C,I_left);
    R(count+1).I= I_left;
    R(count+1).p = p_left;
    R(count+1).j = NaN;
    R(count+1).s = NaN; 
    R(count+1).left = NaN;
    R(count+1).right = NaN; 
    % check if the new leaves are pure or mixed 
    if r_left ==0 
        % pure leaf
        PureNodes = [PureNodes, count+1];
    else
        % mixed leaf 
        MixedNodes = [MixedNodes, count+1];
    end
    I_right = setdiff(I_index,I_left);
    [p_right,c_right,r_right]= classproperty(C,I_right);
    R(count+2).I= I_right;
    R(count+2).p = p_right;
    R(count+2).j = NaN;
    R(count+2).s = NaN; 
    R(count+2).left = NaN;
    R(count+2).right = NaN; 
    % check if the new leaves are pure or mixed 
    if r_right ==0 
        % pure leaf
        PureNodes = [PureNodes, count+2];
    else
        % mixed leaf
        MixedNodes = [MixedNodes, count+2];
    end
    % remove the rectangle just split from the leaf first
    MixedNodes = MixedNodes(2:end);
    count = count+2; % number of noeds in the current tree 
end
%% Pruning tree
% initialization 
R_current = R; 
nodes_num= length(R_current);
T = cell(1,nodes_num);
T{1,1} = R;
count = 2; 
alpha_s = zeros(1,nodes_num);

while length(R_current)~=1
   nodes_num= length(R_current);
   % define successor matrix A and genealogy matrix G 
   A = zeros(nodes_num,nodes_num);
   G = zeros(nodes_num,nodes_num);
   for k = 1:nodes_num
       i = R_current(k).left;
       j = R_current(k).right; 
       if ~isnan(i)
           % the node k is not a leaf
           A(k,i) = 1;
           A(k,j) = 1;
       end
   end
   G = A; 
   A_next = A;
   ite = 1; 
   while (norm(A_next,'fro')>0)
       % keep iterating untill the profuct vanishes 
       A_next = A*A_next;
       G = G+A_next;
       ite = ite +1;  
   end
   I_leaf = [];
   for k = 1:length(R_current)
       if sum(G(k,:))==0
           I_leaf = [I_leaf k];
       end
   end
   alpha = zeros(1,nodes_num);
   % compute alpha for all non-leaf nodes 
   for i =1:nodes_num
       if sum(G(i,:))==0
           alpha(i)=inf;
       else
           % identify leaves below node i 
           Ii = find(G(i,:)==1);
           leaf_j = intersect(Ii,I_leaf);
           leaf_n = length(leaf_j);
           % compute misclassification error or each leaf
           mis_node = cost_complexity(R_current(i),size(I,2),C);
           mis_leaf = 0; 
           for k = 1:leaf_n
               mis_leaf = mis_leaf + cost_complexity(R_current(k),size(I,2),C);
           end
           alpha(i) = (mis_node-mis_leaf)/(leaf_n-1);
       end
   end
   % find minimum alpha
   [a_min,j_min] = min(alpha);
   child = find(G(j_min,:)==1);
   % prune tree with minimum alpha
   R_current(j_min).left = NaN;
   R_current(j_min).right = NaN; 
   for c=length(child):-1:1
       R_current=R_current([1:child(c)-1,child(c)+1:length(R_current)]);
   end
   for k = 1:length(R_current)
       for m = length(child):-1:1
           if R_current(k).left>child(m)
               R_current(k).left= R_current(k).left-1;
           end
            if R_current(k).right>child(m)
               R_current(k).right= R_current(k).right-1;
            end
       end
   end
   T{count} = R_current; 
   alpha_s(count)= a_min; 
   count=count+1;
end

%% test
I_test = [36:70, 106:140, 176:210];
classify = zeros(length(T),length(I_test));
for t = 1:length(T)
    tree_current = T{t};
    if isempty(tree_current)
        break
    end
    for i = 1:length(I_test) 
        R_current = tree_current(1);
        i_current = I_test(i);
        x_current = seedsdata(:,i_current);
        while ~isnan(R_current.left)
            if x_current(R_current.j)<= R_current.s
                R_current = tree_current(R_current.left);
            else
                R_current = tree_current(R_current.right);
            end
        end
        [val class]= max(R_current.p);
        classify(t,i)= class; 
    end
end

specificity=zeros(1,length(T));
for i=1:length(T)
    num_correct=0;
    for j=1:length(I_test)
        if classify(i,j)==C(I_test(j))
            num_correct=num_correct+1;
        end
    end
    specificity(i)=num_correct/length(I_test);
end
        
        

    
    