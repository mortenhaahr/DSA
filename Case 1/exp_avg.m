function [y] = exp_avg(x,alpha, N)
%EXP_AVG Filters a signal using an exponential average filter
%   Input: x = signal, alpha = filter coefficient, N = signal length.
%   Output: y = filtered signal.
%   Version 0.1
ymem = 0;
y = zeros(1, N);
for n=1:N-1
    y(n) = alpha*x(n) + (1 - alpha)*ymem;
    ymem = y(n);
end
end

