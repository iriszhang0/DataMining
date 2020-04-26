benign = find(I_Label == 1);
malignant = find(I_Label == 2);
X_training_benign = Data_WCD_Matrix(:,benign(1:50));
X_training_malignant = Data_WCD_Matrix(:,malignant(1:50));
X_testing_benign = Data_WCD_Matrix(:,benign(51:212));
X_testing_malignant = Data_WCD_Matrix(:,malignant(51:357));

X_training = [X_training_benign X_training_malignant];
I_training = ones(1,100)
for i = 51:100
    I_training(i) = 2; 
end
X_testing = [X_testing_benign X_testing_malignant];
[tn,tp]= size(X_testing);
I_testing = ones(1,tp);
for i = 163:tp
    I_testing(i) = 2; 
end

[I_knn3]= KNN(X_training,I_training, X_testing, I_testing, 3);

C = zeros(2,2);
C_11 = 0;
C_12 = 0;
C_21 = 0;
C_22 = 0;
for i = 1:tp
    if (I_testing(1,i) == 1 & I_knn3(1,i) == 1)
        C_11 = C_11+1;
    end
    if (I_testing(1,i) == 1 & I_knn3(1,i) == 2)
        C_12 = C_12+1;
    end
    if (I_testing(1,i) == 2 & I_knn3(1,i) == 1)
        C_21 = C_21+1;
    end
    if (I_testing(1,i) == 2 & I_knn3(1,i) == 2)
        C_22 = C_22+1;
    end
end
C = [C_11 C_12; C_21 C_22]


[I_knn4]= KNN(X_training,I_training, X_testing, I_testing, 4);
D = zeros(2,2);
D_11 = 0;
D_12 = 0;
D_21 = 0;
D_22 = 0;
for i = 1:tp
    if (I_testing(1,i) == 1 & I_knn4(1,i) == 1)
        D_11 = D_11+1;
    end
    if (I_testing(1,i) == 1 & I_knn4(1,i) == 2)
        D_12 = D_12+1;
    end
    if (I_testing(1,i) == 2 & I_knn4(1,i) == 1)
        D_21 = D_21+1;
    end
    if (I_testing(1,i) == 2 & I_knn4(1,i) == 2)
        D_22 = D_22+1;
    end
end
D = [D_11 D_12; D_21 D_22]

[I_knn5]= KNN(X_training,I_training, X_testing, I_testing, 5);
E = zeros(2,2);
E_11 = 0;
E_12 = 0;
E_21 = 0;
E_22 = 0;
for i = 1:tp
    if (I_testing(1,i) == 1 & I_knn5(1,i) == 1)
        E_11 = E_11+1;
    end
    if (I_testing(1,i) == 1 & I_knn5(1,i) == 2)
        E_12 = E_12+1;
    end
    if (I_testing(1,i) == 2 & I_knn5(1,i) == 1)
        E_21 = E_21+1;
    end
    if (I_testing(1,i) == 2 & I_knn5(1,i) == 2)
        E_22 = E_22+1;
    end
end
E = [E_11 E_12; E_21 E_22]

