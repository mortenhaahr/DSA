function [SNR_ours] = mySNR(x)
N = length(x);
Xabs = abs(fft(x));
X_powerspectrum = (Xabs.*Xabs)/(N*N); % Powerspectrum calculation with normalization with N*N
X_powerdb = 10*log10(X_powerspectrum); % Powerspectrum to dB
SNR_ours = max(X_powerdb) - median(X_powerdb) - 10*log10(N/2); % SNR calculation
end

