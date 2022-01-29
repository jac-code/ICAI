function NPS = Nivel_presion_sonora(F,FDE)
%NIVEL_PRESION_SONORA Nivel de presión sonora en cada subbanda.
%
%   NPS=NIVEL_PRESION_SONORA(F,FDE)
%   Determina el nivel de presión sonora para cada subbanda (vector NPS).
%   El vector F es la densidad espectral de potencia normalizada.
%   FDE es la matriz de factores de escala (3 por subbanda).
%
%   Ver también ANALISIS_FFT, FACTORES_ESCALA.

% Halla el máximo entre los 3 factores de escala de cada subbanda.
MAXFDE = max(FDE);

% Encuentra el valor máximo de las líneas de frecuencia para cada subbanda
% (componentes del vector XKI).
XKI = [];
for k = 1:16:512,
   Xk = max(F(k:k+15));
   XKI = [XKI; Xk];
end

% Calcula el nivel de presión sonora por subbanda (vector NPS).
for i = 1:32,
   NPS(i) = max(XKI(i),20*log10(MAXFDE(i)*32768)-10);
end