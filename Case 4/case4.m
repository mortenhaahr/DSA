%% Opgave 1:
clf; clear; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')

% Generering af chirp signal:
fs = 48e03;
fstart = 100;
fstop = 3e03;
sweep_length = 500;
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
    fprintf(fid, '%d,\n', toRealnumber(sweep_sig(i), powShort)); 
end
fprintf(fid, '%d\n', toRealnumber(sweep_sig(i+1), powShort));   % Uden ","-tegn
fclose(fid);

% Funktion for convertering fra double/float til heltal
function y = toRealnumber(x, multFactor)
    y = round(x*multFactor);
    if (y >= multFactor) 
        y = multFactor-1; % Limitering af max værdi
    end
end




