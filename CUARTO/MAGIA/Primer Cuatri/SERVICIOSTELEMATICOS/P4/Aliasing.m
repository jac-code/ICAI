function MDCTB = Aliasing(MDCT)
%ALIASING Reduce el aliasing introducido por la MDCT.
%
%   MDCTB=ALIASING(MDCT)
%   Retorna en el vector MDCTB de 576 valores el resultado de la reducci�n del
%   aliasing introducido por el 50% de solapamiento usado al aplicar la MDCT o
%   transformada discreta del coseno modificada.
%
%   El vector MDCT contiene los 576 valores de la transformaci�n obtenida a
%   trav�s de TRANSF_DISCRETA_COSENO.
%
%   Ver tambi�n TRANSF_DISCRETA_COSENO.

MDCTB = [];

% Constantes para el c�lculo mariposa, proporcionadas por el est�ndar
% ISO/IEC 11172-3 (vectores c, cs y ca).
% c = [-0.6; -0.535; -0.33; -0.185; -0.095; -0.041; -0.0142; -0.0037];
% cs = 1 ./ sqrt(1+c .^ 2);
% ca = c ./ sqrt(1+c .^ 2);
cs = [0.85749292571254; 0.88174199731771; 0.94962864910273; 0.98331459249179;
   0.99551781606759; 0.99916055817815; 0.99989919524445; 0.99999315507028];
ca = [-0.51449575542753; -0.47173196856497; -0.31337745420390; -0.18191319961098;
   -0.09457419252642; -0.04096558288530; -0.01419856857247; -0.00369997467376];

% Reducci�n del aliasing o solapamiento a trav�s de 8 c�lculos mariposa. La
% reducci�n se hace en grupos de 18 l�neas de frecuencia (a las 16 primeras se
% les hace reducci�n y a las 2 �ltimas no), empezando en la muestra 11.
MDCTcs = zeros(8,2);
MDCTca = zeros(8,2);
for i = 11:18:551,
   
   % Las l�neas de frecuencia se multiplican por cs y ca.
   MDCTcs = [[MDCT(i+7:-1:i) .* cs] [MDCT(i+8:i+15) .* cs]];
   MDCTca = [[MDCT(i+7:-1:i) .* ca] [MDCT(i+8:i+15) .* ca]];
   
   % El concepto mariposa involucra sumar y restar las l�neas de frecuencia en
   % pares, entregando dos nuevas l�neas de frecuencia por cada par. En total, se
   % reemplazan 16 l�neas de frecuencia (vector MDCTBparcial).
   MDCTBparcial = [MDCTcs(8:-1:1,1)+MDCTca(8:-1:1,2); MDCTcs(:,2)-MDCTca(:,1)];
   
   % Concatenaci�n del resultado anterior con los dos valores de MDCT a los que
   % no se les aplica la reducci�n del aliasing.
   MDCTB = [MDCTB; MDCTBparcial; MDCT(i+16:i+17)];
   
end

% Los primeros 10 y los �ltimos 8 valores de MDCT (que no son incluidos en el
% c�lculo mariposa) se conservan para MDCTB.
MDCTB = [MDCT(1:10); MDCTB; MDCT(569:576)];