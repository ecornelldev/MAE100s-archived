function y = mynormpdf(x,mu,sigma)
% calculates the value of the pdf with mean mu and covariance sigma at
% point x


    N = length(x);
    x = reshape(x,1,N);
    mu = reshape(mu,1,N);
    idx = ~isnan(x) & ~isnan(mu);
    x = x(idx);
    mu = mu(idx);
    sigma(:,find(~idx)) = [];
    sigma(find(~idx),:) = [];
    n = length(mu);
    exponent = -.5.*(x-mu)*inv(sigma)*(x-mu)';
    y = (1/((2*pi)^(n/2).*sqrt(det(sigma))))*exp(exponent);
    if isempty(y) || isnan(y)
        y = 0;
    end
end
