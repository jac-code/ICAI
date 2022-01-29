function S = Filtro_subbanda(MAE,C)
%FILTRO_SUBBANDA  Filtro subbanda para el análisis.
%
%   S=FILTRO_SUBBANDA(MAE,C)
%   Obtiene 32 muestras subbanda (vector S), a partir de 32 
%   muestras de audio de entrada PCM (vector MAE).
%   El vector C, almacenado en el archivo Ci.mat, contiene los 
%   coeficientes de la ventana del análisis.

global X

% Búfer FIFO (vector X) de 512 elementos con desplazamientos de a 32 elementos.
X(512:-1:33) = X(480:-1:1);

% Introduce 32 muestras de audio (vector MAE) al búfer FIFO, la primera muestra
% en la posición 32 y la última muestra en la posición 1.
X(32:-1:1) = MAE;

% Multiplica al vector X por los coeficientes de la ventana del análisis (vector C),
% para obtener el vector Z.
Z = C .* X;

% Cálculo parcial para obtener el vector Y de 64 coeficientes.
Y = zeros(1,64);
for i = 1:64,
   Y(i) = sum(Z(i:64:512));
end

% Calcula las 32 muestras subbanda de salida (vector S).
% Haciendo la analogía con el estándar ISO 11172-3, la variable Mik (no calculada
% explícitamente en este código), sería Mik = cos((2*i-1).*fcos).
S = zeros(1,32);
fcos = (-16:47)*pi/64;
for i = 1:32,
   S(i) = sum(cos((2*i-1).*fcos)*Y(:));
end