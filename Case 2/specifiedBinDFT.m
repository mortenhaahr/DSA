function [X] = specifiedBinDFT(x, bin)
N = length(x);
x = x';
X = zeros(1, N);
    for m = 1:N
    X(m) = x(m)*exp(-1j*2*pi*(m-1)*(bin-1)/N);
    end
    
X = sum(X);
end
