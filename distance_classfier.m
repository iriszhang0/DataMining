benign = find(I_Label == 1);
malignant = find(I_Label == 2);
X_training_benign = Data_WCD_Matrix(:,benign(1:50));
X_training_malignant = Data_WCD_Matrix(:,malignant(1:50));
X_testing_benign = Data_WCD_Matrix(:,benign(51:212));
X_testing_malignant = Data_WCD_Matrix(:,malignant(51:357));

X_testing = [X_testing_benign X_testing_malignant];
[tn,tp]= size(X_testing)
I_testing = ones(tp,1);
for i = 163:tp
    I_testing(i) = 2; 
end
% distance classifier 
I_distance = ones(1,tp);
Xb_c_bar = 1/50*sum(X_training_benign');
Xm_c_bar = 1/50*sum(X_training_malignant');
for i =1:tp
    norm_b = norm(X_testing(:,i)-Xb_c_bar',2);
    norm_m = norm(X_testing(:,i)-Xm_c_bar',2);
    if norm_b> norm_m
        I_distance(1,i)= 2;
    end
end


C = zeros(2,2);
C_11 = 0;
C_12 = 0;
C_21 = 0;
C_22 = 0;
for i = 1:tp
    if (I_testing(i,1) == 1 & I_distance(1,i) == 1)
        C_11 = C_11+1;
    end
    if (I_testing(i,1) == 1 & I_distance(1,i) == 2)
        C_12 = C_12+1;
    end
    if (I_testing(i,1) == 2 & I_distance(1,i) == 1)
        C_21 = C_21+1;
    end
    if (I_testing(i,1) == 2 & I_distance(1,i) == 2)
        C_22 = C_22+1;
    end
end
C = [C_11 C_12; C_21 C_22]
