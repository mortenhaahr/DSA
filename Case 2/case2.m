%%
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')
%

%% Opgave 1 a - FSK Generation
fstart = 1000; %Hz
fstop = 5000; %Hz
symbolDuration = 0.20; %Seconds
fsample = 44100; %Hz
string = 'Hello World!';

x = FSKgenerator(string, fstart, fstop, symbolDuration, fsample);
%

%% Opgave 1 b - Signal analysis
close all;
%soundsc(fskSig, fsample);

N = length(x);
t_axis = 0:1/fsample:N/fsample-1/fsample;
figure();
plot(t_axis, x, '*-');
title('FSK signal in time Domain at shifting point');
xlabel('Time [s]');
ylabel('Amplitude');
xlim([0.498 0.502]);

X = fft(x);
f_axis = 0:fsample/N:fsample-fsample/N;
figure();
subplot(2, 1, 1);
stem(f_axis ,abs(X));
title('DFT of FSK signal');
xlabel('Frequency [Hz]');
ylabel('Magnitude');

subplot(2, 1, 2);
stem(f_axis ,abs(X));
xlim([1000 1500]);
title('DFT of FSK signal zoomed in between start/stop limit');
xlabel('Frequency [Hz]');
ylabel('Magnitude');

charFreq = [];
for i = 1:length(string)
    charFreq = [charFreq double(string(i))*(fstop-fstart)/256+fstart]; % Calculates frequency of every letter in string and pushes it back in array
end

%

%% Opgave 1 c - Spectrogram
close all;
n = fsample*symbolDuration;
figure();
spectrogram(x, blackman(n), 0, n, fsample,'yaxis');
ylim([fstart/1000 fstop/1000]);
%

%% Mortens legehus
clf; clear; clc; close all;
[x, fsample] = audioread('lydsignal_0.wav');
%soundsc(x, fsample);
x = x(:,1);

% Test to see if X_ours calculates the same as X_matlab
X_matlab = fft(x);

X_ours = zeros(1, 251);
for i = 1:250
    X_ours = specifiedBinDFT(x, i);
    display(num2str(X_ours) + " " + num2str(X_matlab(i)));
end


%% Opgave 2:
clf; clear; clc; close all;
[x, fsample] = audioread('lydsignal_0.wav');
x = x(:,1);

% STFT Manual:
fstart = 1000; %Hz
fstop = 2000; %Hz
symbolDuration = 0.5;

decodedString = FSKDecoder(x, fstart, fstop, fsample, symbolDuration);

%% Opgave 3:
clf; clear; clc; close all;
[x, fsample] = audioread('lydsignal_0.wav'); % Change this for other values.
% Note: Some distances are not nice because of noise in the start.

x = x(1:24000); % Only looking at the first symbol

N = length(x);
Xabs = abs(fft(x));
X_powerspectrum = (Xabs.*Xabs)/(N*N);
X_powerdb = 10*log10(X_powerspectrum);


SNR_ours = mySNR(x);
SNR_matlab = snr(x);


f_axis = 0:fsample/N:fsample-fsample/N;
figure();
plot(f_axis,X_powerdb,'*');
title('DFT of FSK signal');
xlabel('Frequency [Hz]');
ylabel('Power [dB]');

%% Opgave 3 plots:
clf; clear; clc; close all;
[x0, fsample] = audioread('lydsignal_0.wav'); 
[x50, fsample] = audioread('lydsignal_50cm.wav'); 
[x100, fsample] = audioread('lydsignal_100cm.wav'); 
[x150, fsample] = audioread('lydsignal_150cm.wav'); 
[x200, fsample] = audioread('lydsignal_200cm.wav'); 
[x250, fsample] = audioread('lydsignal_250cm.wav'); 

x0 = x0(1:24000); % Only looking at the first symbol
x50 = x50(1:24000); % Only looking at the first symbol
x100 = x100(1:24000); % Only looking at the first symbol
x150 = x150(1:24000); % Only looking at the first symbol
x200 = x200(1:24000); % Only looking at the first symbol
x250 = x250(1:24000); % Only looking at the first symbol



snr0 = mySNR(x0);
snr50 = mySNR(x50);
snr100 = mySNR(x100);
snr150 = mySNR(x150);
snr200 = mySNR(x200);
snr250 = mySNR(x250);

snr_v = [snr0, snr50, snr100, snr150, snr200, snr250];

N = 6;
step = 50;
x_axis = 0:step:N*step-step;
figure()
stem(x_axis,snr_v);
title('SNR with distance');
xlabel('Distance [cm]');
ylabel('SNR [dB]');

%% Opgave 4
clf; clear; clc; close all;
[x, fsample] = audioread('lydsignal_0.30sec.wav');

% STFT Manual:
fstart = 1000; %Hz
fstop = 2000; %Hz
symbolDuration = 0.30;

decodedString = FSKDecoder(x, fstart, fstop, fsample, symbolDuration);