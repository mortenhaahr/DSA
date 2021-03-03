%%
clf; clear; clc; close all;
%set(0,'DefaultFigureWindowStyle','docked')
set(0,'DefaultFigureWindowStyle','normal')
%

%% Opgave 1 a - FSK Generation
fstart = 1000; %Hz
fstop = 2000; %Hz
symbolDuration = 0.5; %Seconds
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