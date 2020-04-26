% k-medoids algorithm 
function [medoids,cluster] = k_medoids(k,D,tau)
% initialization 
  cluster = zeros(1,size(D,2));
  coherence = 10^16;
  MAX_ITER = 100000;
  % picking randomly k data vectors to be the initial medoids
  medoids_index = (floor((size(D,2)).*rand(k,1) + 1)');
  medoids = D(:,medoids_index);
  for r = 1:size(D,2)
      % assign every vector into different clusters
      [val,ind] = min(medoids(r,:));
     cluster(:,r) = ind;
  end
  % computing the corresponding tightness.
  tightness = 0;
  for l = 1:k
      cluster_index = find(cluster==l);
      for j = 1 : size(cluster_index,2)
          tightness = tightness+D(cluster_index(:,j),medoids_index(l));
      end
  end
 % Repeat the initialization 20 times 
 % pick the initial clustering that corresponds to the lowest tightness.
  cluster_t = zeros(1,size(D,2));
  for t = 1:20 
    medoids_index_t = (floor((size(D,2)).*rand(k,1) + 1))';
    medoids_t = D(:,medoids_index_t);
    for r = 1:size(D,2)
      [val,ind_t] = min(medoids_t(r,:));
      cluster_t(:,r) = ind_t;
    end
    tightness_t = 0;
    for l = 1:k
      cluster_index_t = find(cluster==l);
      for j = 1 : size(cluster_index_t,2)
         tightness_t = tightness_t+D(cluster_index_t(:,j),medoids_index_t(l));
      end
    end
    if tightness_t<tightness
       tightness = tightness_t;
       medoids = medoids_t;
       cluster = cluster_t;
    end
  end
  D_m = D(:,medoids_index);
  [q, cluster] = min(D_m,[],2);
   tightness = sum(q.^2);
 % iteration 
 t=0;
 while (coherence > tau && t<MAX_ITER)
     for l = 1: k
       I_{l} = find(cluster == l);
       D_{l} = D(I_{l},I_{l});
       [~,j] = min(sum(D_{l}));
       D_m(:,l) = D(:,j);
       medoids_index(l) = j;
     end
     [q_new, cluster] = min(D_m,[],2);
      Qnew = sum(q_new.^2);
      coherence = abs(Qnew - tightness);
      tightness = Qnew;
      t= t+1;
 end
medoids = D(:,medoids_index);
cluster= cluster';
end