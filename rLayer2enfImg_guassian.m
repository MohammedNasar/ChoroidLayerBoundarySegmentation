function enfImg = rLayer2enfImg_guassian(rLayer,a0,b0)
a = a0*size(rLayer,2);
b = b0*size(rLayer,2);
% a = 0.02*size(rLayer,2);
% b = 0.05*size(rLayer,2);
mu = a*b;
sigma = sqrt(a*b^2);
x = 5:size(rLayer,2);
% pd = makedist('HalfNormal','mu',1,'sigma',sigma);
% y = pdf(x,pd);
y = 1*normpdf(x,mu,sigma);
enfImg = zeros(size(rLayer,1),size(rLayer,3));
for i = 1:size(rLayer,1)
    for j = 1:size(rLayer,3)
        ascan = rLayer(i,x,j);
%         ascan = double(rLayer(i,x,j));
        enfImg(i,j) = mean(ascan.*y);
    end
end

