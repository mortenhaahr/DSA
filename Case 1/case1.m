%% Opgave 1
clf; clear; clc; close all;
load('vejecelle_data.mat');
fs = 300; %Hz
T_length = length(vejecelle_data)/fs; % Antal sekunder vi sampler over
N = length(vejecelle_data);
t = [0:1/fs:N/fs-1/fs]; % tidsakse 

figure(10);
plot(t,vejecelle_data, '*', 'MarkerSize', 3)
title('Signal ufiltreret')
ylabel('ADC-værdi')
xlabel('tid [s]')
legend('Vejecelle data');
xlim([0 t(end)]);
grid on;

signal_ubelastet = vejecelle_data(1:1000);
signal_belastet = vejecelle_data(length(vejecelle_data)-999:length(vejecelle_data));

N_ubelastet = length(signal_ubelastet);
N_belastet = length(signal_belastet);

% Estimeret middelværdi:
est_middel_ubelastet = 1/N_ubelastet * sum(signal_ubelastet);
est_middel_belastet = 1/N_belastet * sum(signal_belastet);
% Estimeret varians:
est_var_ubelastet = 1/(N_ubelastet-1)*sum((signal_ubelastet-est_middel_ubelastet).^2);
est_var_belastet = 1/(N_belastet-1)*sum((signal_belastet-est_middel_belastet).^2);
% Estimeret standardafvigelse:
est_std_ubelastet = sqrt(est_var_ubelastet);
est_std_belastet = sqrt(est_var_belastet);


figure(20);
subplot(2,1,1);
histogram(signal_ubelastet);
title('Signal ubelastet')
ylabel('Hyppighed')
xlabel('ADC-værdi')
legend('Vejecelle ubelastet');
grid on;

subplot(2,1,2);
histogram(signal_belastet);
title('Signal belastet')
ylabel('Hyppighed')
xlabel('ADC-værdi')
legend('Vejecelle belastet');
grid on;


bin_ubelastet_res = fs/N_ubelastet;
freq_akse_ubelastet = 0:bin_ubelastet_res:fs-bin_ubelastet_res;
% Bemærk vi har trukket middelværdien fra da dennes energi er meget større
% end støjens enkelte bins:
fft_ubelastet = fft(signal_ubelastet - est_middel_ubelastet); 

figure(30);
stem(freq_akse_ubelastet, abs(fft_ubelastet));
title('FFT af ubelastet vejecelle data');
ylabel('Magnitude');
xlabel('Frekvens (Hz)');

bin_belastet_res = fs/N_belastet;
freq_akse_belastet = 0:bin_belastet_res:fs-bin_belastet_res;
% Bemærk vi har trukket middelværdien fra da dennes energi er meget større
% end støjens enkelte bins:
fft_belastet = fft(signal_belastet - est_middel_belastet);

figure(40);
stem(freq_akse_ubelastet, abs(fft_ubelastet));
title('FFT af belastet vejecelle data');
ylabel('ADC-værdi');
xlabel('Frekvens (Hz)');

% Spørgsmål: Ligner det hvid støj? Det ligner ret godt hvid støj, selvom
% det ikke er helt normalfordelt.

% Spørgsmål: Hvad er afstand imellem bit-niveauer i gram ? (dvs. værdi af
% LSB)

% Forskel mellem de to middelværdier:
diff = est_middel_belastet - est_middel_ubelastet;
% Opløsning (vi ved at loddet vejer 1000 g):
res = 1000/diff;
% Dvs. 1 bit = res gram. res = ~3.36g.

%% Pre-Opgave 2
% Viser filterkarakteristik
clf; clear; clc; close all;

pulse = [1, zeros(1,25)];

% Implementering af midlingsfiltre - der er valgt rekursivt MA.
ma_10 = recursive_MA(pulse, 10, 25);


figure(50);
stem([0:24],ma_10);
title('Plot af pulssvar')
ylabel('Spænding [V]')
xlabel('n')
grid on;

%% Opgave 2:
clf; clear; clc; close all;
load('vejecelle_data.mat');
fs = 300; %Hz
T_length = length(vejecelle_data)/fs; % Antal sekunder vi sampler over
N = length(vejecelle_data);
n = [0:N-1]; % Antal samples

M = 10; % Ændre M for nye billeder

signal_filt = recursive_MA(vejecelle_data, M, N);

% Vi har valgt at tage 900 samples her, for at undgå at se artefaktor med
% at signalet skal finde steady-state i de første samples efter filteret.
s_noload = signal_filt(100:999);
s_load = signal_filt(length(signal_filt)-899:length(signal_filt));

N_noload = length(s_noload);
N_load = length(s_load);

% Estimeret middelværdi:
mean_noload = 1/N_noload * sum(s_noload);
mean_load = 1/N_load * sum(s_load);
% Estimeret varians:
var_noload = 1/(N_noload-1)*sum((s_noload-mean_noload).^2);
var_load = 1/(N_load-1)*sum((s_load-mean_load).^2);
% Estimeret standardafvigelse:
std_noload = sqrt(var_noload);
std_load = sqrt(var_load);

figure(60);
subplot(2,1,1);
histogram(s_noload);
title(['Signal ubelastet M = ' ,num2str(M)])
ylabel('Hyppighed')
xlabel('ADC-værdi')
legend('Vejecelle ubelastet');
grid on;
xlim([1080 1140]);

subplot(2,1,2);
histogram(s_load);
title(['Signal ubelastet M = ' ,num2str(M)])
ylabel('Hyppighed')
xlabel('ADC-værdi')
legend('Vejecelle belastet');
grid on;
xlim([1360 1440]);

% Spørgsmål: Stemmer ændringen af variansen/effekten overens med teorien ?
% Teorien passer ret godt. Ved M = 10 er variansen cirka faldet med en
% faktor 10 (vis flere eksempler i rapport)

% Et krav til max. indsvingnings-tid kunne være 100 millisekunder til et
% praktisk veje-system. Beregn den maksimale længde af jeres FIR
% midlingsfilter.

max_time = 0.1; % [s]
max_order = fs*max_time;

%% Exp-Opgave 2
%Implementér et eksponentielt midlingsfilter. Eksperimenter med α-værdien –
%prøv f.eks. at sætte den meget lavt / højt. Hvad er betydningen af
%α-værdien ?

clf; clear; clc; close all;

pulse = [1, zeros(1,50)];

% Implementering af midlingsfiltre - der er valgt rekursivt MA.
exp1 = exp_avg(pulse, 0.5, length(pulse));
figure(70);
subplot(2,2,1);
stem([0:length(pulse)-1],exp1);
title('Plot af pulssvar \alpha = 0.5')
ylabel('Spænding [V]')
xlabel('n')
grid on;


% Implementering af midlingsfiltre - der er valgt rekursivt MA.
exp2 = exp_avg(pulse, 0.1, length(pulse));
subplot(2,2,2);
stem([0:length(pulse)-1],exp2);
title('Plot af pulssvar \alpha = 0.1')
ylabel('Spænding [V]')
xlabel('n')
grid on;

% Implementering af midlingsfiltre - der er valgt rekursivt MA.
exp3 = exp_avg(pulse, 0.9, length(pulse));
subplot(2,2,3);
stem([0:length(pulse)-1],exp3);
title('Plot af pulssvar \alpha = 0.9')
ylabel('Spænding [V]')
xlabel('n')
grid on;

%% Opgave 2 cont.

% Prøv at sætte α-værdien, således at I får samme støj-reduktion, som for
% jeres 100. ordens FIR midlingsfilter – Kommentér på indsvingnings-tiderne
% (dvs. tiden fra “belastning” til “ingen belastning”).
clf; clear; clc; close all;

load('vejecelle_data');

% Fra bogen side 541:
% alpha = 2/(N + 1), hvor N = FIR filterets orden og hvor N > 3
alpha = 2/(100+1);

N = length(vejecelle_data);
t = [0:1/fs:N/fs-1/fs]; % tidsakse 

signal_filt_exp = exp_avg(vejecelle_data, alpha, N);
signal_filt_fir = recursive_MA(vejecelle_data, 100, N);


% Plottes op imod hinanden.
figure(80);
subplot(2,1,1);
plot(t,signal_filt_exp,'*', 'MarkerSize', 3)
title('Signal filtreret med eksponentielt filter')
ylabel('ADC-værdi')
xlabel('tid [s]')
legend('Vejecelle data');
grid on;
xlim([3.333 4.33]);

subplot(2,1,2);
plot(t,signal_filt_fir,'*', 'MarkerSize', 3)
title('Signal filtreret med rekursivt filter')
ylabel('ADC-værdi')
xlabel('tid [s]')
legend('Vejecelle data');
xlim([3.333 4.33]);
grid on;

%% Opgave 2 cont.
clf; clear; clc; close all;
% Spørgsmål: Hvad vil betydningen af “korrupt data” være ? dvs. fx. et par samples med
% en værdi, som er meget større end alle de andre. Problemet kan til dels
% løses med et såkaldt ”median-filter”
N = 10000;
n = [0:N-1];

u = [zeros(N,1)]; % DC
w = [zeros(N/20,1); 10; zeros(N*19/20-1, 1)]; % korrupt data
x = u + w;

x_filt_1 = recursive_MA(x, N/1000, N);
x_filt_2 = recursive_MA(x, N/100, N);

figure(90);
subplot(2, 2, 1);
stem(n,x)
title('Plot af signal med korrupt data')
ylabel('ADC-værdi')
xlabel('n')
ylim([0 11]);
xlim([N/25 N/15]);
hold on

subplot(2, 2, 2);
stem(n,x_filt_1)
title(['Plot af filtreret signal med korrupt data. M = ', num2str(N/1000)])
ylabel('ADC-værdi')
xlabel('n')
ylim([0 11]);
xlim([N/25 N/15]);
hold on

subplot(2, 2, 3);
stem(n,x_filt_2)
title(['Plot af filtreret signal med korrupt data. M = ', num2str(N/100)])
ylabel('ADC-værdi')
xlabel('n')
ylim([0 11]);
xlim([N/25 N/15]);
hold on

% Svar: Jo mindre filteret er, jo større indflydelse vil hvert enkelt
% korrupt data punkt have.

%% Opgave 3:
clf; clear; clc; close all;

%Tag udgangspunkt i det 100. ordens FIR midlingsfilter. Hvor mange
%betydende cifre kan I medtage i et display, hvis det skal vise vægt i kg
%(op til fx. 5 kg) og hvis støjens spredning (=kvadrat af varians) skal
%ligge på under 1/10 af værdien af det mindst betydende ciffer i displayet
%? Kravet til støjens spredning stilles for at alle viste cifre er
%pålidelige

% Sætter M til 100 i opgave 2 og får følgende:
std_no_load = 2.98408133026240
std_load = 4.22730656201442

res = 3.36 % 3.36 gram pr. bit (fra tidl. opg.)

std_load_10 = std_load*10; % Tager med load fordi det er worst-case
min_acc = std_load_10 * res;

%min_acc = 142. I så fald kan vi have nul betydende cifre, dvs. vi kan kun
%vise i hele kilo.