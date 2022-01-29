function [BSR,LTR,LNTR] = Reduccion(LT,LNT,BS,UA,MAP)
%REDUCCION Reduce la cantidad de componentes enmascarantes tonales y no-tonales 
%   de la se�al de audio.
%
%   [BSR,LTR,LNTR]=REDUCCION(LT,LNT,BS,UA,MAP)
%   La matriz LTR lista las componentes tonales y la matriz LNTR lista las 
%   componentes no-tonales; ambas despu�s de disminuir la cantidad de
%   componentes enmascarantes. Las componentes que se encuentran por debajo
%   del m�nimo umbral auditivo, o que su distancia con respecto a otra componente
%   es menor a medio Bark, son eliminadas. Las matrices LTR y LNTR se componen
%   de dos columnas, la primera proporciona el �ndice de la l�nea de frecuencia
%   y la segunda el nivel de presi�n sonora de esa l�nea. El vector BSR
%   proporciona las banderas para cada una de las 512 l�neas de frecuencia,
%   despu�s de realizar la disminuci�n sobre LT y LNT, tal que:
%   - Componente no examinada = 0.
%   - Componente tonal = 1.
%   - Componente no tonal = 2.
%   - Componente irrelevante = 3.
%
%   UA es la matriz de umbral absoluto y MAP es el vector de mapeo entre las
%   l�neas de frecuencia y su �ndice para la matriz UA; ambos obtenidos con
%   UMBRAL_ABSOLUTO. LBC es la matriz de l�mites de las bandas cr�ticas
%   obtenida con LIMITES_BANDA_CRITICA. LT y LNT son las matrices de
%   componentes tonales y de componentes no-tonales, y BS es el vector de 
%   banderas, todos obtenidos con COMPONENTES_TONALES.
%
%   Ver tambi�n UMBRAL_ABSOLUTO, LIMITES_BANDA_CRITICA, COMPONENTES_TONALES.

BSR = BS;

% a) Caso no-tonal y caso tonal, parte I:
%    Elimina las componentes tonales (filas de la matriz LT) o las componentes
%    no-tonales (filas de la matriz LNT) en las cuales el nivel de presi�n sonora
%    est� por debajo del m�nimo umbral auditivo (tercera columna de la matriz
%    UA); y fija en 3 su valor de bandera en el vector BSR.

% Primero, se analiza el caso no-tonal.
LNTR = [];
if not(isempty(LNT))
	for i = 1:26,
	   k = LNT(i,1);
	   if (LNT(i,2) < UA(MAP(k),3))
	   	BSR(k) = 3;
		else
		   LNTR = [LNTR; LNT(i,:)];
	   end
	end
end

% Despu�s, se analiza el caso tonal, parte I.
LTR = [];
if not(isempty(LT))
	for i = 1:length(LT(:,1)),
      k = LT(i,1);
      if (LT(i,2) < UA(MAP(k),3))
		   BSR(k) = 3;
	   else
		   LTR = [LTR; LT(i,:)];
	   end
	end
end

% b) Caso tonal, parte II:
%    Elimina dos o m�s componentes tonales (filas de la matriz LT) cuya distancia
%    respecto a otra componente es menor que medio bark, y fija en 3 su valor de
%    bandera en el vector BSR. Se elimina(n) la(s) componente(s) con menor nivel
%    de presi�n sonora y se conserva la componente con mayor nivel.
if not(isempty(LTR))
   i = 1;
   while (i < length(LTR(:,1))),
      k = LTR(i,1);
      sigk = LTR(i+1,1);
      if (UA(MAP(sigk),2) - UA(MAP(k),2) < 0.5)
         if (LTR(i,2) < LTR(i+1,2))
            % Elimina la componente con �ndice k.
            LTR = LTR([1:i-1,i+1:length(LTR(:,1))],:);
            BSR(k) = 3;
         else
            % Elimina la componente con �ndice k+1.
            LTR = LTR([1:i,i+2:length(LTR(:,1))],:);
            BSR(sigk) = 3;
         end
      end
      i = i+1;
   end
end