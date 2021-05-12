%% Opgave 1:
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')

% Generering af chirp signal:
fs = 48e03;
fstart = 100;
fstop = 3e03;
sweep_length = 50;
t = 0:1/fs:sweep_length/fs-1/fs;
t_last = t(sweep_length);
sweep_sig = chirp(t, fstart, t_last, fstop);

figure();
plot(t, sweep_sig, '*-');
title(['Chirp signal in time domain']);
xlabel('Time [s]');
ylabel('Amplitude');

save('sweep_sig.mat', 'sweep_sig');