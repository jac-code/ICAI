function UEM = Umbral_enmasc_minimo(UEG,MAP)
%UMBRAL_ENMASC_MINIMO Calcula el umbral de enmascaramiento mínimo.
%
%   UEM=UMBRAL_ENMASC_MINIMO(UEG,MAP)
%   Retorna en el vector UEM el valor mínimo del umbral de enmascaramiento
%   global para cada una de las 32 subbandas.
%   
%   El vector UEG es el umbral de enmascaramiento global obtenido con
%   UMBRAL_ENMASC_GLOBAL. El vector MAP es el mapeo entre las líneas de
%   frecuencia y su índice para la matriz UA en la función UMBRAL_ABSOLUTO.
%
%   Ver también UMBRAL_ENMASC_GLOBAL, UMBRAL_ABSOLUTO.

% Extrae del umbral de enmascaramiento global (vector UEG), su valor mínimo
% en cada subbanda (vector UEM).
for n = 1:32,
   UEM(n) = min(UEG(MAP((n-1)*16+1):MAP((n-1)*16+16)));
end