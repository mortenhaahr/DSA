clf; clear; clc; close all;

fs = 48e03;
fstart = 100;
fstop = 3e03;
sweep_length = 100;
t = 0:1/fs:sweep_length/fs-1/fs;
t_last = t(sweep_length);
sweep_sig = chirp(t, fstart, t_last, fstop);

signal_50 = importdata("sonar_50_cm.dat");
signal_100 = importdata("sonar_100_cm.dat");
signal_150 = importdata("sonar_150_cm.dat");
signal_200 = importdata("sonar_200_cm.dat");

% figure;
% plot(signal_50);
% hold on;
% plot(signal_100);
% plot(signal_150);
% plot(signal_200);
% legend("50", "100", "150", "200");
% 
figure;
[c, lags] = xcorr(sweep_sig, signal_200);
stem(lags,c);
hold on;
[d, lag] = myXCorr(sweep_sig, signal_200');
stem(lag, d);
legend("xcorr", "myXCorr");
