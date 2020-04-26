function I_pca = PCA_classifier(X,I,P)
    [n,p]=size(X);
    clusters=unique(I);
    num_clusters=size(clusters,2);
    I_pca=zeros(1,p);

    for i=1:p
        norms=zeros(1,num_clusters);
        for k=1:num_clusters
            norms(k)=norm(P{k}*X(:,i), 2);
        end  
        [~,j]=max(norms);
        I_pca(i)=clusters(j);
    end
end
