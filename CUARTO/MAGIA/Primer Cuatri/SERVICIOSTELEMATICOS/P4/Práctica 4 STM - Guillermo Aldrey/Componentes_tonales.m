function [BS,LT,LNT] = Componentes_tonales(F,UA,MAP,LBC)
%COMPONENTES_TONALES Encuentra las componentes tonales y no-tonales de la se�al
%   de audio.
%
%   [BS,LT,LNT]=COMPONENTES_TONALES(F,UA,MAP,LBC)
%   La matriz LT lista las componentes tonales y la matriz LNT lista las
%   componentes no-tonales; ambas matrices se componen de dos columnas, la
%   primera proporciona el �ndice de la l�nea de frecuencia y la segunda, el
%   nivel de presi�n sonora de esa l�nea. El vector BS proporciona las banderas
%   para cada una de las 512 l�neas de frecuencia, tal que:
%   - Componente no examinada = 0.
%   - Componente tonal = 1.
%   - Componente no-tonal = 2.
%   - Componente irrelevante = 3.
%
%   F es el vector de densidad espectral de potencia normalizada, obtenido con
%   ANALISIS_FFT. UA es la matriz de umbral absoluto y MAP es el vector de mapeo
%   entre las l�neas de frecuencia y su �ndice para la matriz UA; ambos obtenidos
%   con UMBRAL_ABSOLUTO. LBC es la matriz que contiene los l�mites de las bandas
%   cr�ticas, obtenida con LIMITES_BANDA_CRITICA.
%
%   Ver tambi�n ANALISIS_FFT, UMBRAL_ABSOLUTO, LIMITES_BANDA_CRITICA.

% Inicializa el vector de banderas BS para las 512 l�neas de frecuencia.
BS = zeros(512,1);

% Determina la lista de los m�ximos locales (matriz LML) para las l�neas de
% frecuencia. La primera columna de LML son los �ndices, y la segunda corresponde
% al nivel de presi�n sonora. El an�lisis s�lo es necesario hacerlo para las
% l�neas de frecuencia con �ndice entre 3 y 500, de acuerdo con los requerimientos
% del est�ndar ISO 11172-3, p�gina 112 (mirar los intervalos de k usados para
% generar los intervalos de J, m�s adelante en este mismo archivo; �stos obligan a
% la exclusi�n de �ndices k menores que 2 y mayores que 501).
LML = [];
c = 1;
for k = 3:500,
   if (F(k)>F(k-1) & F(k)>=F(k+1))
      LML(c,1) = k;
      LML(c,2) = F(k);
      c = c+1;
   end
end

% Determina cu�les de los m�ximos locales son componentes tonales y calcula su
% nivel de presi�n sonora (columnas de la matriz LT). Adem�s, asigna para cada
% una de las l�neas de frecuencia analizadas su respectivo valor de bandera en
% el vector BS.
LT = [];
c = 1;
if not(isempty(LML))
   for i = 1:length(LML(:,1)),
      k = LML(i,1);
      tonal = 1;
      
      % Determina el intervalo J que indica cu�ntas frecuencias adyacentes
      % deben ser examinadas, de acuerdo con la posici�n de la l�nea de
      % frecuencia, o sea, de acuerdo con el �ndice k.
      if (2<k & k<63)
         J = [-2,2];
      elseif (63<=k & k<127)
         J = [-3,-2,2,3];
      elseif (127<=k & k<255)
         J = [-6:-2,2:6];
      elseif (255<=k & k<=500)
         J = [-12:-2,2:12];
      else
         tonal = 0;
      end
      
      % Examina las frecuencias adyacentes de acuerdo con el intervalo definido
      % por J, y determina si el m�ximo local es definitivamente una componente
      % tonal.
      for j = J,
         tonal = tonal & (F(k)-F(k+j) >= 7);
      end
      
      % Si F(k) es realmente una componente tonal, entonces lo siguiente se lista:
      %  - �ndice k de la l�nea de frecuencia.
      %  - Nivel de presi�n sonora.
      %  - Bandera tonal.
      if tonal
         LT(c,1) = k;
         LT(c,2) = 10*log10(10^(F(k-1)/10)+10^(F(k)/10)+10^(F(k+1)/10));
         BS(k) = 1; % Bandera de componente tonal = 1.
         for j = [J,-1,1],
            BS(k+j) = 3; % Bandera de componente irrelevante = 3.
         end
         c = c+1;
      end
   end
end

% Dentro de cada banda cr�tica, analiza las restantes l�neas de frecuencia y suma
% sus potencias para determinar el nivel de presi�n sonora de cada componente
% no-tonal (columnas de la matriz LNT). Adem�s, asigna para cada una de estas
% l�neas de frecuencia su respectivo valor de bandera en el vector BS.
LNT = [];
for i = 1:26,
   
   % Para cada banda cr�tica, calcula la potencia en las componentes no-tonales.
   POT = -200;
   PESO = 0; % Usado para calcular la media geom�trica de la banda cr�tica.
   for k = UA(LBC(i,1),1):UA(LBC(i+1,1),1)-1,
      if (BS(k) == 0) % Bandera de componente no examinada = 0.
         POT = 10*log10(10^(POT/10)+10^(F(k)/10));
         PESO = PESO+10^(F(k)/10)*(UA(MAP(k),2)-i);
         BS(k) = 3; % Bandera de componente irrelevante = 3.
      end
   end
   
   % El �ndice de la componente no-tonal es el m�s cercano a la media geom�trica
   % de la banda cr�tica.
   if (POT <= -200)
      IND = round(mean(UA(LBC(i,1),1)+UA(LBC(i+1,1),1)));
   else
      IND = UA(LBC(i,1),1)+round(PESO/10^(POT/10)*...
         (UA(LBC(i+1,1),1)-UA(LBC(i,1),1)));
   end
   
   % Chequea que el �ndice de la componente no-tonal est� dentro de los valores
   % permitidos, o sea, entre 1 y 512.
   if (IND<1)
      IND = 1;
   end
   if (IND>512)
      IND = 512;
   end
   
   % El �ndice de la componente no-tonal no puede coincidir con el �ndice
   % de alguna componente tonal.
   if (BS(IND) == 1)
      IND = IND+1;
   end
   
   % Dentro de cada banda cr�tica, para su componente no-tonal se lista lo
   % siguiente:
   %  - �ndice de la l�nea de frecuencia.
   %  - Nivel de presi�n sonora.
   %  - Bandera no-tonal.
   LNT(i,1) = IND;
   LNT(i,2) = POT;
   BS(IND) = 2;
   
end