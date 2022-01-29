function  UEG = Umbral_enmasc_global(UES,UET,UENT)
%UMBRAL_ENMASC_GLOBAL Calcula el umbral de enmascaramiento global.
%
%   UEG=UMBRAL_ENMASC_GLOBAL(UES,UET,UENT)
%   Calcula el umbral de enmascaramiento global (vector UEG) para el subconjunto
%   de líneas de frecuencia definidas en la tabla denominada "Frecuencia, Tasa
%   de Banda Crítica y Umbral Absoluto" para la Capa II a 44.1 kHz, proporcionada
%   por el estándar ISO 11172-3. Éste es la suma (en la escala normal de amplitud
%   cuadrada del espectro) de los umbrales de enmascaramiento individual y del
%   umbral absoluto o umbral en silencio.
%
%   La matriz UET es el efecto enmascarante de las componentes tonales y la matriz
%   UENT es el efecto enmascarante de las componentes no tonales, ambas obtenidas
%   con UMBRALES_ENMASC_INDIVIDUAL. El vector UES es el umbral en silencio, 
%   proporcionado por UMBRAL_ABSOLUTO.
%
%   Ver también UMBRALES_ENMASC_INDIVIDUAL, UMBRAL_ABSOLUTO.
   
% El umbral de enmascaramiento global (vector UEG) se calcula para el subconjunto
% de frecuencias definidas en la tabla denominada "Frecuencia, Tasa de Banda
% Crítica y Umbral Absoluto" para la Capa II a 44.1 kHz, proporcionada por el
% estándar ISO 11172-3. Éste es la suma de las potencias de los correspondientes
% umbrales de enmascaramiento individual (matrices UET y UENT) y el umbral en
% silencio (vector UES).
if not(isempty(UET))
   m = length(UET(:,1));
end
if not(isempty(UENT))
   n = length(UENT(:,1));
end

for i = 1:130
   
   % Para el umbral en silencio.
   t = 10^(UES(i)/10);
   
   % Contribución de las componentes tonales.
   if not(isempty(UET))
	   for j = 1:m,
	      t = t+10^(UET(j,i)/10);
      end
   end

   % Contribución de las componentes no tonales.
   if not(isempty(UENT))
      for j = 1:n,
         t = t+10^(UENT(j,i)/10);
      end
   end
   
   % Umbral de enmascaramiento global.
   UEG(i) = 10*log10(t);
   
end
