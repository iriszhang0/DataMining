function [G1,G2,G3] = GLCM(X)
A_before = double(X);
Max = max(A_before, [], 'all');
A = A_before/Max;
[n1,n2]=size(A);
% define coarsened gray level matrix C
C = zeros(n1,n2);
for i=1:n1
    for j=1:n2
        C(i,j)=ceil(A(i,j)*6);
    end
end

% Define the Gray Level Co-occurence Matrix G 
% offset parameters are (2,2), (3,0), (1,4) 
% (2,2)
C_shift1 = NaN(n1,n2);
C_shift1(1:n1-2,1:n2-2)= C(1+2:n1,1+2:n2);
G1 = zeros(6,6);
for i = 1:6
     Ii=(C==i);
    for j =1:6
       Ij = (C_shift1==j);
       G1(i,j)=sum(sum(Ii.*Ij));
    end
end
S1 = sum(G1,'all');
G1 = G1/S1;
% (3,0)
C_shift2 = NaN(n1,n2);
C_shift2(1:n1-3,1:n2-0)= C(1+3:n1,1+0:n2);
G2 = zeros(6,6);
for i = 1:6
     Ii=(C==i);
    for j =1:6
       Ij = (C_shift2==j);
       G2(i,j)=sum(sum(Ii.*Ij));
    end
end
S2 = sum(G2,'all');
G2 = G2/S2;
% (1,4)
C_shift3 = NaN(n1,n2);
C_shift3(1:n1-1,1:n2-4)= C(1+1:n1,1+4:n2);
G3 = zeros(6,6);
for i = 1:6
     Ii=(C==i);
    for j =1:6
       Ij = (C_shift3==j);
       G3(i,j)=sum(sum(Ii.*Ij));
    end
end
S3 = sum(G3,'all');
G3 = G3/S3;

end

