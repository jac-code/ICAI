function xmin = Distorsion_permitida(SFBT,UA,UEG)
%DISTORSION_PERMITIDA Calcula la distorsi�n permitida, seg�n el modelo psicoac�stico.
%
%   XMIN=DISTORSION_PERMITIDA(SFBT,UA,UEG)
%   XMIN es el vector que contiene las distorsiones permitidas, en cada
%   banda del factor de escala, seg�n las salidas del modelo psicoac�stico.
%
%   SFBT es la tabla de bandas del factor de escala, obtenida en WAV2MP3. UA es
%   la matriz de umbral absoluto obtenida con UMBRAL_ABSOLUTO. El vector UEG es
%   el umbral de enmascaramiento global obtenido con UMBRAL_ENMASC_GLOBAL.
%
%   Ver tambi�n WAV2MP3, UMBRAL_ENMASC_GLOBAL, UMBRAL_ABSOLUTO.

% Almacena en el vector UEGMAP el resultado del mapeo entre 512 l�neas de frecuencia
% y los 130 valores del vector UEG. Primero, se mapea el valor inicial.
UEGMAP(1) = UEG(1);

% Despu�s, se mapean los valores finales.
UEGMAP(UA(130,1):512) = UEG(130);

% Por �ltimo, se mapean todos los dem�s valores.
for i = 2:129,
   UEGMAP(UA(i,1):UA(i+1,1)) = UEG(i);
end

% Encuentra el m�nimo umbral de enmascaramiento (vector MINTHR) para cada una
% de las 21 bandas del factor de escala.
for n = 1:21,
   MINTHR(n) = min(UEGMAP(SFBT(3,n):SFBT(4,n)));
end

% Ajuste del umbral m�nimo para la Capa III. Con este cambio, se notan leves
% mejoras en el sonido de algunos archivos.
MINTHR(1:7) = MINTHR(1:7)+12;
MINTHR(8:14) = MINTHR(8:14)+5;

% Calcula la distorsi�n permitida (vector xmin) para las 21 bandas del factor
% de escala.
xmin = 10.^(MINTHR/20)./SFBT(2,:);