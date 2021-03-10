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
x = x';


% Test to see if X_ours calculates the same as X_matlab
X_matlab = fft(x);
%X_ours = specifiedBinDFT(x,1, 50);

% delta = 0.1;
% for i = 1:length(X_ours)
%     if(abs(X_ours) + delta < abs(X_matlab(i)))
%         display(["X_ours: ", num2str(abs(X_ours)), " X_matlab: ", (abs(X_matlab))]);
%     end
% end

% X_ours = zeros(1, 100);
% for i = 1:100
%     X_ours(i) = specifiedBinDFT(x,i);
% end

for i = 1:length(X_ours)
    display([num2str(X_ours(i)), num2str(X_matlab(i))]);
end

% Split X into blocks for every symbol
X = fft(x);
symbolDuration = 0.5; %Seconds
blockSamples = fsample*symbolDuration;
N_blocks = floor(length(X)/blockSamples);
X_block = zeros(N_blocks, blockSamples);

% for i = 1 : ceil(length(X)/blockSamples)
%     if(i ~= N_blocks-1)
%         if(i == 1)
%             X_block(i,:) = fft(x(i+(i-1)*blockSamples:i*blockSamples));
%         else
%             fft(x(i*blockSamples:i
%         end
%     end
% end

% STFT Manual:
N = blockSamples;
f_axis = 0:fsample/N:fsample-fsample/N;
for i = 1 : blockSamples : N_blocks*blockSamples
    n_block = ceil(i/blockSamples); % Ceil because of 1-indexing
    X_block(n_block,:) = fft(x(i:blockSamples+i-1));
    figure();
    stem(f_axis ,abs(X_block(n_block,:)));
    str = "DFT of FSK signal fra sample " + num2str(i) + " - " + num2str(blockSamples+i-1);
    title(str);
    xlabel('Frequency [Hz]');
    ylabel('Magnitude');
    xlim([1000 1500]);
end

%% Opgave 2:
clf; clear; clc; close all;
[x, fsample] = audioread('lydsignal_0.30sec.wav');
x = x(:,1);

% STFT Manual:
fstart = 1000; %Hz
fstop = 2000; %Hz
symbolDuration = 0.3;

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
[x, fsample] = audioread('supertest.wav');

% STFT Manual:
fstart = 1000; %Hz
fstop = 4000; %Hz
symbolDuration = 0.20;

decodedString = FSKDecoder(x, fstart, fstop, fsample, symbolDuration);