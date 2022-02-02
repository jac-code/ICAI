%% Autocorrelation Matrix

[x,~] = audioread("PDS_P7_3A_LE1_G2_x_n.wav");

[r_x,lags] = xcorr(x);

% Orden del filtro
M = 10;

% Matriz de índices de correlación
corr_indexes = (0:M)-(0:M)';
corr_indexes = corr_indexes(:);

% Matriz de correlación
Rx = zeros(length(corr_indexes),1);
for i = 1:length(corr_indexes)
    Rx(i) = r_x(lags==corr_indexes(i));
end
Rx = reshape(Rx,M+1,M+1);

% Valor máximo del paso del algoritmo LMS
[U, V] = eig(Rx/Rx(1,1)); % La matriz de autocorrelación se normaliza con respecto a la potencia de ruido para calcular los autovalores normalizados
mu_max = 1/max(max(V));

%% Vector de Correlación Cruzada

[d,~] = audioread("PDS_P7_3A_LE1_G2_d_n.wav");

[r_dx, lags] = xcorr(d,x);

corr_indexes = (0:M)';

Rdx = zeros(length(corr_indexes),1);
for i = 1:length(corr_indexes)
    Rdx(i) = r_dx(lags==corr_indexes(i));
end

%% Filtro de Wiener

W = inv(Rx)*Rdx;
