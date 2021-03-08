function [y] = recursive_MA(x,M, N)
%RECURSIVE_MA Filters a signal using a recursive moving average
%   Input: x = signal, M = filter order, N = signal length.
%   Output: y = filtered signal.
%   Version 0.1

xmem = zeros(1, M); % initialize vector of last M samples memory
ymem = 0; % Memory for last output
y = zeros(1, N-1); % Vector containing all output values

for n=1:N
    y(n)= 1/M.* (x(n) - xmem(end)) + ymem; % Calculation of output value
    xmem = [x(n), xmem(1:end-1)]; %Pushing current sample value in sample memory
    ymem = y(n); % Assigning last output memory variable to current output
end
end

