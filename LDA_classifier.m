function I_lda  = LDA_classifier(x, Q, c, k)
norms=zeros(1,k);
for i=1:k
    norms(i)=norm(Q*x - c{i});
end
[~, j]=min(norms);
I_lda=j;
end
