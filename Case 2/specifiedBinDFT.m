function [X] = specifiedBinDFT(x, bin)
N = length(x);
X = 0;
for m = 1:N % For loop iterating over all samples of one bin
    X = X + x(m)*exp(-1j*2*pi*(m-1)*(bin-1)/N); % Calculation of DFT without summation (-1 because of DFT indexing starts at 0)
end
    
end
