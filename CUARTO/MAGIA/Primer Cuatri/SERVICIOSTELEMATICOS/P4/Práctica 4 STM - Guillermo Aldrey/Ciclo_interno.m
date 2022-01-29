function [IX,IS,SHT,overall_bitsum,count1table_select,big_values,region0_count, ...
      region1_count,table_select,qquant,quantanf,rlb,count1,fe,ff] = ...
   Ciclo_interno(XR,system_const,SFBT)
%CICLO_INTERNO Realiza el ciclo para el control de la tasa de bits.
%
%   [IX,IS,SHT,OVERALL_BITSUM,COUNT1TABLE_SELECT,BIG_VALUES,REGION0_COUNT,...
%      REGION1_COUNT,TABLE_SELECT,QQUANT,QUANTANF,RLB,COUNT1,FE,FF]=...
%         CICLO_INTERNO(XR,SYSTEM_CONST,SFBT)
%
%   IX es el vector de valores espectrales cuantizados (sin tener en cuenta el
%   signo de XR). IS es el vector de valores espectrales cuantizados (teniendo
%   en cuenta el signo de XR). SHT es la matriz que contiene las 3 tablas de
%   Huffman seleccionadas para codificar las 3 subregiones de la región
%   big_values. OVERALL_BITSUM representa la cantidad de bits que se usan para
%   codificar los valores cuantizados. COUNT1TABLE_SELECT indica la tabla de
%   Huffman escogida para codificar los cuádruplos de valores pertenecientes a
%   la región count1. BIG_VALUES es la cantidad de valores espectrales, contados
%   por pares, ubicados en las bajas frecuencias. REGION0_COUNT es la cantidad de
%   bandas del factor de escala (disminuidas en 1) incluidas en region0.
%   REGION1_COUNT es la cantidad de bandas del factor de escala (disminuidas
%   en 1) incluidas en region1. TABLE_SELECT es el vector que incluye el número
%   de las tablas de Huffman usadas para codificar region0, region1 y region2.
%   QQUANT y QUANTANF son los valores usados para el intervalo de cuantización.
%   El vector RLB indica cuántos bits deben usarse para codificar cada uno de los
%   valores adicionales en cada una de las 3 subregiones en que se divide big_values
%   (el valor adicional es necesario si el valor máximo de la subregión es mayor
%   que 15). COUNT1 es la cantidad de cuádruplos incluidos en la región count1
%   (región intermedia del vector IX). El vector FE indica el principio de cada
%   una de las 3 subregiones en que se divide big_values. El vector FF indica el
%   final de cada una de las 3 subregiones en que se divide big_values.
%
%   XR es el vector de muestras subbanda obtenido originalmente con ALIASING, y
%   más tarde modificado en CICLO_EXTERNO. SYSTEM_CONST es la constante del sistema,
%   obtenida en WAV2MP3. SFBT es la matriz que proporciona las bandas del factor de
%   escala, obtenida en WAV2MP3.
%
%   Ver también WAV2MP3, ALIASING, CICLO_EXTERNO, HUFFMAN.

% Inicialización de variables.
sfm = exp(sum(log(XR.^2))/576)/(sum(XR.^2)/576); % Calcula la planura espectral.
quantanf = system_const*log(sfm); % Selección del intervalo de cuantización.
qquant = 0; % Selección del intervalo de cuantización.

% Cuantiza los valores del vector XR. En IX se almacenan los valores
% absolutos y en IS se almacenan los valores signados.
IX = round((abs(XR)/(2^((qquant+quantanf)/4))) .^ 0.75 - 0.0946);
IS = sign(XR).*IX;

% Cuando todos los valores del vector IX son cero, se termina el Ciclo Interno.
if IX == 0
   count1table_select = 0;
   big_values = 0;
   region0_count = 0;
   region1_count = 0;
   table_select = zeros(1,3);
   overall_bitsum = 0;
   SHT = zeros(256,6);
   rlb = zeros(1,3);
   count1 = 0;
   fe = ones(1,3);
   ff = ones(1,3);
   return
else
   % Limita a (8191 + 15) el valor máximo de los componentes del vector IX.
   while max(IX) > 8206,
      qquant = qquant+1;
      IX = round((abs(XR)/(2^((qquant+quantanf)/4))) .^ 0.75 - 0.0946);
      IS = sign(XR).*IX;
   end
   
   % Calcula el número de pares de ceros (rzero) en el extremo superior
   % del vector IX.
   rzero = 0;
   for i = 576:-1:1,
      if IX(i) == 0
         rzero = rzero + 0.5;
      else
         break
      end
   end   
   rzero = fix(rzero);
   
   % Calcula el número de cuádruplos de valores (count1) en el vector IX cuyo valor
   % absoluto no es mayor que uno, y que siguen luego de los valores rzero (en la
   % parte intermedia del vector IX).
   count1 = 0;
   for i = 576-rzero*2:-1:1,
      if IX(i) == 0 | IX(i) == 1
         count1 = count1+0.25;
      else
         break
      end
   end
   count1 = fix(count1);
   
   % Calcula el número de pares de valores (big_values) en el extremo inferior
   % del vector IX.
   big_values = (576-rzero*2-count1*4)/2;
   
   % Almacena en bitsum_count1 el número de bits necesario para codificar los
   % valores count1. Además, determina la tabla de Huffman más apropiada para
   % dicha codificación (count1table_select).
   count1table_0 = [1 4 4 5 4 6 5 6 4 5 5 6 5 6 6 6];
   % Calcula los bits que se consumen con la tabla B.
   bitsum_table1 = count1*4;
   % Calcula los bits que se consumen con la tabla A.
   bitsum_table0 = 0;
   for k = big_values*2+1:4:big_values*2+count1*4,
      bitsum_table0 = bitsum_table0+count1table_0(8*IX(k)+4*IX(k+1)+2*IX(k+2)+IX(k+3)+1);
   end
   % Calcula cuántos bits de signo se usan para la región count1.
   count1_signbits = length(find(IX(big_values*2+1:576-rzero*2)));
   % Calcula la cantidad total de bits que consume la región count1,
   % usando la tabla de Huffman que usa menos bits para codificar los
   % cuádruplos count1.
   bitsum_count1 = min(bitsum_table0,bitsum_table1) + count1_signbits;
   if bitsum_table0 < bitsum_table1
      % Escoge la tabla A, proporcionada por el estándar ISO 11172-3.
      count1table_select = 0;
   else
      % Escoge la tabla B, proporcionada por el estándar ISO 11172-3.
      count1table_select = 1;
   end
   
   % Divide la región de los valores big_values en 3 subregiones, cuyos límites
   % deben coincidir con los límites de las bandas del factor de escala incluidas
   % en el tamaño de dicha región. Los valores de region0_count y region1_count
   % obtenidos aquí, no están regidos por los requerimientos del estándar ISO 11172-3.
   if big_values == 0
      bvscfb = 0;
   else
      for i = SFBT,
         if big_values*2 <= i(4)
            break
         end
      end
      bvscfb = i(1);
   end
   region0_count = fix(bvscfb/2);
   region2_count = fix(bvscfb/4);
   region1_count = bvscfb - region0_count - region2_count;
   
   % Encuentra el máximo valor cuantizado de cada subregión (max_region), el
   % cual sirve para calcular linbits (vector rlb). Estos dos valores permiten
   % seleccionar las tablas de Huffman apropiadas (matrices HCTN y HCT) para
   % codificar cada una de las subregiones de big_values. En este paso, se puede
   % dar la posibilidad de hasta tres (3) tablas de Huffman por subregión, para un
   % caso máximo de nueve (9) tablas seleccionadas para big_values. Posteriormente,
   % se realiza la selección de la tabla más apropiada para cada subregión.
   % Adicionalmente, se inicializa apropiadamente la variable bitsum_table, de
   % acuerdo con la cantidad de subregiones en que se divide big_values.
   rlb = zeros(1,3);
   HCTN = zeros(3);
   HCT = zeros(256,18);
   if bvscfb > 3
      % Caso 1. La región big_values se ha dividido en tres (3) subregiones.
      %         Máximo nueve (9), mínimo tres (3) tablas para big_values.
      fe = [1,SFBT(4,region0_count)+1,SFBT(4,region0_count+region1_count)+1];
      ff = [SFBT(4,region0_count),SFBT(4,region0_count+region1_count),big_values*2];
      max_region0 = max(IX(1:ff(1)));
      max_region1 = max(IX(fe(2):ff(2)));
      max_region2 = max(IX(fe(3):ff(3)));
      if max_region0 > 15
         rlb(1) = ceil(log2(max_region0 - 14)); % Cálculo de linbits, region0.
      end
      if max_region1 > 15
         rlb(2) = ceil(log2(max_region1 - 14)); % Cálculo de linbits, region1.
      end
      if max_region2 > 15
         rlb(3) = ceil(log2(max_region2 - 14)); % Cálculo de linbits, region2.
      end
      % Selección de la(s) tabla(s) de Huffman por subregión.
      [HCTN(1,:),HCT(:,1:6)] = Huffman(rlb(1),max_region0);
      [HCTN(2,:),HCT(:,7:12)] = Huffman(rlb(2),max_region1);
      [HCTN(3,:),HCT(:,13:18)] = Huffman(rlb(3),max_region2);
      bitsum_table = ones(3)*inf;
   elseif bvscfb == 1 | bvscfb == 2
      % Caso 2. La región big_values se ha dividido en una (1) subregión.
      %         Máximo tres (3), mínimo una (1) tabla para big_values.
      fe = [1, 1, 1];
      ff = [1, big_values*2, 1];
      max_region1 = max(IX(1:ff(2)));
      if max_region1 > 15
         rlb(2) = ceil(log2(max_region1 - 14)); % Cálculo de linbits, region1.
      end
      % Selección de la(s) tabla(s) de Huffman por subregión.
      [HCTN(2,:),HCT(:,7:12)] = Huffman(rlb(2),max_region1);
      bitsum_table = [zeros(1,3); ones(1,3)*inf; zeros(1,3)];
   elseif bvscfb == 3
      % Caso 3. La región big_values se ha dividido en dos (2) subregiones.
      %         Máximo seis (6), mínimo dos (2) tablas para big_values.
      fe = [1, 5, 1];
      ff = [4, big_values*2, 1];
      max_region0 = max(IX(1:4));
      max_region1 = max(IX(5:ff(2)));
      if max_region0 > 15
         rlb(1) = ceil(log2(max_region0 - 14)); % Cálculo de linbits, region0.
      end
      if max_region1 > 15
         rlb(2) = ceil(log2(max_region1 - 14)); % Cálculo de linbits, region1.
      end
      % Seleccion de la(s) tabla(s) de Huffman por subregión.
      [HCTN(1,:),HCT(:,1:6)] = Huffman(rlb(1),max_region0);
      [HCTN(2,:),HCT(:,7:12)] = Huffman(rlb(2),max_region1);
      bitsum_table = [ones(2,3)*inf; zeros(1,3)];
   elseif bvscfb == 0
      % Caso 4. La región big_values no existe, y por lo tanto, no hay subdivisión.
      fe = [1, 1, 1];
      ff = [1, 1, 1];
      bitsum_table = zeros(3);
   end
   
   % Ajusta los valores de region0_count y region1_count, de acuerdo con los
   % requerimientos del estándar ISO 11172-3.
   if region0_count ~= 0
      region0_count = region0_count - 1;
   end
   if region1_count ~= 0
      region1_count = region1_count - 1;
   end
   
   % A partir de las tablas de Huffman seleccionadas anteriormente (mínimo 1,
   % máximo 3 tablas para cada subregión), escoge aquella que usa menos bits
   % en la codificación (table_select y la matriz SHT), y calcula los bits
   % necesarios para codificar los valores en cada subregión. Por último,
   % calcula overall_bitsum, que es la cantidad total de bits que se usan
   % para codificar los valores cuantizados. Primero, se cargan los valores
   % máximos de las tablas de Huffman.
   maxth = [1 2 3 3 0 4 4 6 6 6 8 8 8 ones(1,19)*16];
   % Después, se realiza el conteo de bits con todas las tablas de Huffman, y
   % almacena el resultado en bitsum_table.
   for j = 1:3,
      for t = 1:3,
         if HCTN(j,t)
            bs = 0;
            for k = fe(j):2:ff(j),
               bs = bs + HCT(maxth(HCTN(j,t)+1)*min(15,IX(k))+ ...
                  min(15,IX(k+1))+1,2*t+6*j-7);
            end
            bitsum_table(j,t) = bs;
         end
      end
      % Selecciona la tabla de Huffman que consume menos bits.
      [min_bitsum,min_bitsum_index] = min(bitsum_table(j,:));
      % Guarda el número de la tabla, en el vector table_select.
      table_select(j) = HCTN(j,min_bitsum_index);
      % Almacena en bitsum_region, la cantidad de bits que consume la subregión.
      bitsum_region(j) = min_bitsum;
      % Calcula la cantidad de bits que consumen los valores mayores que 14.
      rlbsum = length(find(IX(fe(j):ff(j)) > 14))*rlb(j);
      region_linbits_sum(j) = rlbsum;
      % Almacena en la matriz SHT, la tabla de Huffman seleccionada.
      SHT(:,2*j-1:2*j) = HCT(:,2*min_bitsum_index+6*j-7:2*min_bitsum_index+6*j-6);
   end
   % Calcula cuántos bits de signo se usan para la región big_values.
   big_values_signbits = length(find(IX(1:big_values*2)));
   
   % Calcula la cantidad de bits que consume el espectro cuantizado (vector IX).
   overall_bitsum = sum(bitsum_region) + sum(region_linbits_sum) + ...
      big_values_signbits + bitsum_count1;
end