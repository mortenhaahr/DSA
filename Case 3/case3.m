%% Opgave 1
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')

% Analyser lydsignal - Find den tone som ønskes fjernet.  Med analyse menes
% at se på tids-signalet, amplitude-spektrum, spektrogram.

[x, fs] = audioread('tale_tone_48000.wav');
%soundsc(x, fs);

N = length(x);
t_axis = 0:1/fs:N/fs-1/fs;
zoom = [0.47, 0.5];
figure();
plot(t_axis, x, '*');
title(['Sound signal in time domain zoomed in around ', num2str(zoom(1)), 's - ', num2str(zoom(2)), 's.'] );
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);

X = fft(x);
f_axis = 0:fs/N:fs-fs/N;
figure();
subplot(2, 1, 1);
stem(f_axis ,abs(X));
title('Sound signal in frequency domain');
xlabel('Frequency [Hz]');
ylabel('Magnitude');

subplot(2, 1, 2);
stem(f_axis ,abs(X));
zoom = [700, 900]; % Hz
xlim(zoom);
title(['Sound signal in frequency domain zoomed in around ', num2str(zoom(1)), 'Hz - ', num2str(zoom(2)), 'Hz.'] );
xlabel('Frequency [Hz]');
ylabel('Magnitude');


[~, bin_tone] = max(abs(X)); % Vores sinus tone bin
freq_tone = bin_tone * fs / N;
w_tone = 2*pi*freq_tone / fs; % rad/s

duration = 0.5;
n = fs*duration;
overlap = n-n/20;
freq_points = fs;
figure();
spectrogram(x, n, overlap, fs, fs,'yaxis');
zoom = [0, 3]; % kHz
title(['Spectrogram of sound signal zoomed in around ', num2str(zoom(1)), 'kHz - ', num2str(zoom(2)), 'kHz. Notice tone around ', num2str(round(freq_tone/10)/100), ' kHz.'] );
ylim(zoom);

save('opgave1.mat', 'fs', 'x', 'freq_tone', 'w_tone');

%% Opgave 2 - Design:
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')
load('opgave1.mat');

% NOTE: I casen skal filteret skitseres

phase_pos = exp(w_tone*1i);
phase_neg = exp(w_tone*-1i);

% Fun fact: A 4th order would've been much better
z_n = [phase_pos; phase_neg;];
z_p = [0.99*phase_pos; 0.99*phase_neg;];

figure()
zplane(z_n, z_p);
title('Pole-zero diagram');
display(z_n);
display(z_p);

% Lav nuller og poler om til koefficienter
% (1 er gain-faktoren)
[b, a] = zp2tf(z_n, z_p, 1); 

% Note: Den er god nok med figurerne.

figure()
freqz(b, a);
title(['Filter characteristic in normalized rad/s'] );

figure()
freqz(b, a, fs, fs);
zoom = [freq_tone-400, freq_tone+400]; % rad/s
title(['Filter characteristic in Hz zoomed in around', num2str(zoom(1)), 'Hz - ', num2str(zoom(2)), 'Hz.'] );
xlim(zoom);

% Note: Svar på spørgsmål: "Er det et ideelt filter ? (hvorfor/hvorfor ikke)"

save('opgave2_design.mat', 'fs', 'x', 'b', 'a');
%% Opgave 2 - filtrer og lyt
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')
load('opgave2_design.mat');

x_filt = filter(b, a, x);
soundsc(x_filt, fs);

N = length(x);
X = fft(x);
X_filt = fft(x_filt);
f_axis = 0:fs/N:fs-fs/N;
figure();
subplot(2, 1, 1);
stem(f_axis ,abs(X));
zoom = [700, 900]; % Hz
xlim(zoom);
title(['Unfiltered sound signal in frequency domain zoomed in around ', num2str(zoom(1)), 'Hz - ', num2str(zoom(2)), 'Hz.'] );
xlabel('Frequency [Hz]');
ylabel('Magnitude');

subplot(2, 1, 2);
stem(f_axis ,abs(X_filt));
zoom = [700, 900]; % Hz
xlim(zoom);
title(['Filtered sound signal in frequency domain zoomed in around ', num2str(zoom(1)), 'Hz - ', num2str(zoom(2)), 'Hz.'] );
xlabel('Frequency [Hz]');
ylabel('Magnitude');
