function P = PCA(X,I,m)
    %% PART 0: INITIALIZE VARIABLES
    clusters=unique(I);
    num_clusters=size(clusters,2);

    x=cell(1,num_clusters);

    %% PART 1: PARTITION X INTO SUBMATRICES BY ANNOTATION
    for i=1:num_clusters
        x{i}=X(:,I==clusters(i));
    end

    %% PART 2: SVD/PROJECT EACH CLUSTER
    u=cell(1,num_clusters);
    d=cell(1,num_clusters);
    v=cell(1,num_clusters);
    %Compute SVD of each cluster
    for i=1:num_clusters
        [U,D,V]=svd(x{i});
        u{i}=U;
        d{i}=D;
        v{i}=V;
    end

    %Calculate rank-m projector for each cluster
    P=cell(1,num_clusters);
    for i=1:num_clusters
        P{i}=u{i}(:, 1:m) * u{i}(:, 1:m)';
    end
end
