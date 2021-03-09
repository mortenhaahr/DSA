%%
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')
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
soundsc(x, fsample);
%%
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
[x, fsample] = audioread('lydsignal.wav');
%soundsc(x, fsample);
x = x';


% Test to see if X_ours calculates the same as X_matlab
X_matlab = fft(x);
X_ours = specifiedBinDFT(x,1, 50);

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
[x, fsample] = audioread('lydsignal.wav');


% STFT Manual:
fstart = 1000; %Hz
fstop = 2000; %Hz
symbolDuration = 0.5;

blockSamples = fsample*symbolDuration;
N_blocks = floor(length(x)/blockSamples);
for i = 1 : blockSamples : N_blocks*blockSamples
    n_block = ceil(i/blockSamples); % Ceil because of 1-indexing
    x_block = x(i:i+blockSamples);
    [symbol, symbolValue, freq] = FSKDecoder(x_block, fstart, fstop, fsample);
    display("Symbol: " + num2str(symbol) + " Value: " + num2str(symbolValue) + " Freq: " + num2str(freq));
end

% Opgave C:
% Vi beregner kun 500 bins, (bin_n_max - bin_n_min i Decoder), da vi ved
% vores signal er herinde under.
% Hvis ellers vores DFT var mere optimal, ville det være meget hurtigere
% end at beregne det hele.

%% Opgave 3:
clf; clear; clc; close all;
[x, fsample] = audioread('lydsignal.wav');

x = x(1:24000); % Only looking at the first symbol

N = length(x);

Xabs = fft(abs(x));
X_power = abs((Xabs.*Xabs)/(N*N));
X_power = 10*log10(X_power);

f_axis = 0:fsample/N:fsample-fsample/N;
figure();
plot(f_axis,X_power,'*');
title('DFT of FSK signal');
xlabel('Frequency [Hz]');
ylabel('Power [dB]');
xlim([1000 2000]);