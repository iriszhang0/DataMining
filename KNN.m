function I_knn = KNN(X_train,I_train, X_test, I_test, k)
    num_train=size(I_train,2);
    num_test=size(I_test,2);
    
    I_knn=zeros(1,num_test);
    
    for i=1:num_test
        dist=zeros(1, num_train);
        x_cur=X_test(:,i);
        for j=1:num_train
            dist(j)=sqrt(sum((X_train(:,j)- x_cur).^2));
        end
        [d,ind]=sort(dist);
        k_nearest=I_train(ind(1:k));
      
        I_knn(i)=mode(k_nearest);
    end
end