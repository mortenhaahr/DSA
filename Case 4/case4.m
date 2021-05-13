%% Opgave 1:
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')

% Generering af chirp signal:
fs = 48e03;
fstart = 100;
fstop = 3e03;
sweep_length = 100;
t = 0:1/fs:sweep_length/fs-1/fs;
t_last = t(sweep_length);
sweep_sig = chirp(t, fstart, t_last, fstop);

figure();
plot(t, sweep_sig, '*-');
title(['Chirp signal in time domain']);
xlabel('Time [s]');
ylabel('Amplitude');


% Eksempel på skrivning af array til fil, som kan læses ind i CrossCore
powShort = 2^15; % Samme som shift med 15 bits
fid=fopen('sweep_sig_500_s.dat', 'w');
for i=1:length(sweep_sig)-1
    fprintf(fid, '%d,\n', toRealNumber(sweep_sig(i), powShort)); 
end
fprintf(fid, '%d\n', toRealNumber(sweep_sig(i+1), powShort));   % Uden ","-tegn
fclose(fid);


%% Opgave 4 - analysedel
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')

% Init:

fs = 48e03;

signal_0 = importdata("sweep_sig_100_s.dat");
signal_0 = [signal_0; zeros(4800 - length(signal_0), 1)];

signal_50 = importdata("sonar_50_cm.dat");
signal_100 = importdata("sonar_100_cm.dat");
signal_150 = importdata("sonar_150_cm.dat");
signal_200 = importdata("sonar_200_cm.dat");

mean_factor = abs(mean(signal_50))/abs(mean(signal_0));

signal_0_amplified = signal_0.*mean_factor; % Forstærk teoretisk output signal, så det ligner de andre

% Tidsdomæne

receive_length = 4800;
t_axis = 0:1/fs:receive_length/fs-1/fs;

figure();
plot(t_axis, signal_0_amplified, '*-');
hold on;
plot(t_axis, signal_50, '*-');
plot(t_axis, signal_100, '*-');
plot(t_axis, signal_150, '*-');
plot(t_axis, signal_200, '*-');
hold off;

zoom = [0, 0.01];
title(['Chirp signal in time domain zoomed in around ', num2str(zoom(1)), 's - ', num2str(zoom(2)), 's.'] );
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);
legend('output signal (amplified)', '50 cm', '100 cm', '150 cm', '200 cm');


figure();
subplot(5,1,1);
plot(t_axis, signal_0, 'b*-');
zoom = [0, 0.008];
title(['Chirp signal in time domain zoomed in around ', num2str(zoom(1)), 's - ', num2str(zoom(2)), 's.'] );
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);
legend('output signal (amplified)');
subplot(5,1,2);
plot(t_axis, signal_50, 'g*-');
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);
legend('50 cm');
subplot(5,1,3);
plot(t_axis, signal_100, 'y*-');
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);
legend('100 cm');
subplot(5,1,4);
plot(t_axis, signal_150, 'c*-');
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);
legend('150 cm');
subplot(5,1,5);
plot(t_axis, signal_200, 'r*-');
xlabel('Time [s]');
ylabel('Amplitude');
xlim(zoom);
legend('200 cm');


% Frekvensdomæne

Signal_0 = fft(signal_0_amplified);
Signal_50 = fft(signal_50);
Signal_100 = fft(signal_100);
Signal_150 = fft(signal_150);
Signal_200 = fft(signal_200);

f_axis = 0:fs/receive_length:fs-fs/receive_length;
figure();
plot(f_axis, abs(Signal_0), '*-');
hold on;
%plot(f_axis, abs(Signal_50), '*-');
%plot(f_axis, abs(Signal_100), '*-');
%plot(f_axis, abs(Signal_150), '*-');
%plot(f_axis, abs(Signal_200), '*-');
hold off;
title('Chirp signal in frequency domain');
xlabel('Frequency [Hz]');
ylabel('Magnitude');
legend('output signal', '50 cm', '100 cm', '150 cm', '200 cm');

% Krydskorrelation
[crossCorr_50, lag_50] = myXCorr(signal_50', signal_0);
[crossCorr_100, lag_100] = myXCorr(signal_100', signal_0);
[crossCorr_150, lag_150] = myXCorr(signal_150', signal_0);
[crossCorr_200, lag_200] = myXCorr(signal_200', signal_0);
[crossCorr, lag] = xcorr(signal_50, signal_0); % Anvendes til at sammenligne matlabs xcorr med myXCorr

tau_axis = lag_200/fs; % in seconds
[~, tau_diff_samples] = max(crossCorr_200);
tau_diff_seconds = tau_axis(tau_diff_samples);
distInM = (tau_diff_seconds*343);

figure;
stem(lag_50, crossCorr_50);
%plot(tau, crossCorr_50);
hold on;
stem(lag, crossCorr);
legend("myCrossCorr", "xcorr");
hold off;

figure;
stem(lag_100, crossCorr_100);
figure;
stem(lag_150, crossCorr_150);
figure;
stem(lag_200, crossCorr_200);


