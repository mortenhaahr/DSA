function [X] = specifiedBinDFT(x, bin)
N = length(x);
x = x'; % Transpose matrix because audio signal is a nx1 matrix compared to 1xn matrix of DFT
X = zeros(1, N);
    for m = 1:N % For loop iterating over all samples of one bin
    X(m) = x(m)*exp(-1j*2*pi*(m-1)*bin/N); % Calculation of DFT without summation (-1 because of DFT indexing starts at 0)
    end
    
X = sum(X); % Summation of all samples to give the output bin
end
