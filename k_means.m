% k-means algorithm  
function [centroid,partition_index] = k_means(X,k,tau)
% initialization 
partition_index = zeros(1,size(X,2));
coherence = 10^16;
  % picking randomly k data vectors to be the initial medoids
  centroid_index = (floor((size(X,2)).*rand(k,1) + 1))';
  centroid = X(:,centroid_index);
  [q, partition_index] = min(centroid,[],2);
  tightness = sum(q.^2);
  % Repeat the initialization 20 times 
  % pick the initial clustering that corresponds to the lowest tightness.
  partition_index_t = zeros(1,size(X,2));
  for t = 1:20 
    centroid_index_t = (floor((size(X,2)).*rand(k,1) + 1))';
    centroid_t = X(:,centroid_index_t);
    [q_t, partition_index_t] = min(centroid_t,[],2);
    tightness_t = sum(q_t.^2);
    if tightness_t<tightness
       tightness = tightness_t;
       centroid = centroid_t;
       partition_index = partition_index_t;
    end
  end
partition_index = partition_index';
A = zeros(k+2,size(X,2));

% iteration 
while(coherence > tau)
    for i = 1:size(X,2)
        for j = 1:k
            A(j,i) = norm(X(:,i) - centroid(:,j),2);
        end
        [Distance, cluster] = min(A(1:k,i));
        A(k+1,i) = cluster;
        A(k+2,i) = Distance;
    end
    
    for i = 1:k
        num = A(k+1,:) == i;
        centroid(:,i) = mean(X(:,num),2);
    end
     [q_new, cluster] = min(centroid,[],2);
      Qnew = sum(q_new.^2);
      coherence = abs(Qnew - tightness);
      tightness = Qnew;
end
partition_index = A(k+1,:)
end