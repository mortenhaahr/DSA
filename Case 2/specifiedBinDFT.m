function [X] = specifiedBinDFT(x, bin_start, bin_stop)
N = length(x);
X = zeros(1, bin_stop-bin_start+1);
for m = bin_stop-bin_start+1:bin_stop
    for n = 1:N
        X(m-bin_start) = X(m-bin_start)+x(n)*exp(-1j*2*pi*(n-1)*(m-1)/N);
    end
end

end
