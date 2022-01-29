function LBC = Limites_banda_critica
%LIMITES_BANDA_CRITICA Límites de las Bandas Críticas.
%
%   LBC=LIMITES_BANDA_CRITICA
%   Proporciona, en la matriz LBC, los valores de la tabla "LÍMITES DE LAS BANDAS
%   CRÍTICAS" tal y como está dada en el estándar ISO 11172-3; para la Capa II,
%   y una frecuencia de muestreo de 44.1 kHz.
%   
%   Ver también UMBRAL_ABSOLUTO

% En la matriz LBC se almacena la tabla "Límites de las Bandas Críticas" para la
% Capa II a 44.1 kHz, proporcionada por el estándar ISO 11172-3. Las frecuencias
% corresponden al límite superior de cada banda crítica.

% Índice   |	Frecuencia	| Tasa de Banda Crítica
%					  	(Hz)					  (z)
LBC = [
  1	   		   43.066	 			 0.425
  2	   		   86.133	 			 0.850
  3	  			  129.199	 			 1.273
  5	  			  215.332	 			 2.112
  7	  			  301.465	 			 2.934
 10	  			  430.664	 			 4.124
 13	  			  559.863	 			 5.249
 16	  			  689.063	 			 6.301
 19	  			  818.262	 			 7.274
 22	  			  947.461	 			 8.169
 26	 			 1119.727	 			 9.244
 30	 			 1291.992				10.195
 35	 			 1507.324				11.232
 40	 			 1722.656				12.125
 46	 			 1981.055				13.042
 51	 			 2325.586				14.062
 56	 			 2756.250				15.100
 62	 			 3273.047				16.110
 69	 			 3875.977				17.079
 74	 			 4478.906				17.904
 79	 			 5340.234				18.922
 85	 			 6373.828				19.963
 92	 			 7579.688				20.971
 99    			 9302.344				22.074
105				11369.531				22.984
117				15503.906				24.013
130				19982.813				24.574
];