function S = Filtro_subbanda(MAE,C)
%FILTRO_SUBBANDA  Filtro subbanda para el an�lisis.
%
%   S=FILTRO_SUBBANDA(MAE,C)
%   Obtiene 32 muestras subbanda (vector S), a partir de 32 
%   muestras de audio de entrada PCM (vector MAE).
%   El vector C, almacenado en el archivo Ci.mat, contiene los 
%   coeficientes de la ventana del an�lisis.

global X

% B�fer FIFO (vector X) de 512 elementos con desplazamientos de a 32 elementos.
X(512:-1:33) = X(480:-1:1);

% Introduce 32 muestras de audio (vector MAE) al b�fer FIFO, la primera muestra
% en la posici�n 32 y la �ltima muestra en la posici�n 1.
X(32:-1:1) = MAE;

% Multiplica al vector X por los coeficientes de la ventana del an�lisis (vector C),
% para obtener el vector Z.
Z = C .* X;

% C�lculo parcial para obtener el vector Y de 64 coeficientes.
Y = zeros(1,64);
for i = 1:64,
   Y(i) = sum(Z(i:64:512));
end

% Calcula las 32 muestras subbanda de salida (vector S).
% Haciendo la analog�a con el est�ndar ISO 11172-3, la variable Mik (no calculada
% expl�citamente en este c�digo), ser�a Mik = cos((2*i-1).*fcos).
S = zeros(1,32);
fcos = (-16:47)*pi/64;
for i = 1:32,
   S(i) = sum(cos((2*i-1).*fcos)*Y(:));
end