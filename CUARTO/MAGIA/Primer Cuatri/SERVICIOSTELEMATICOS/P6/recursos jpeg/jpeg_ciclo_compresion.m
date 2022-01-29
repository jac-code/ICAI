% function jpeg_resultado = jpeg_ciclo_compresion(original)
clear all
close all

%Lectura de la imagen
original=imread('crane.png');
original = im2double(original);
original(

figure, imshow(original);
% Matrices de Transformación
dct_matriz = dctmtx(8);
dct = @(block_struct) dct_matriz * block_struct.data* dct_matriz';
idct = @(block_struct) dct_matriz' * block_struct.data* dct_matriz;

% Tablas de quantización
q_max = 255;
q_y = [16 11 10 16 124 140 151 161;
12 12 14 19 126 158 160 155;
14 13 16 24 140 157 169 156;
14 17 22 29 151 187 180 162;
18 22 37 56 168 109 103 177;
24 35 55 64 181 104 113 192;
49 64 78 87 103 121 120 101;
72 92 95 98 112 100 103 199] ;

q_c = [17 18 24 47 99 99 99 99 ;
18 21 26 66 99 99 99 99 ;
24 26 56 99 99 99 99 99 ;
47 66 99 99 99 99 99 99 ;
99 99 99 99 99 99 99 99 ;
99 99 99 99 99 99 99 99 ;
99 99 99 99 99 99 99 99 ;
99 99 99 99 99 99 99 99] ;

%Orden análisis para zigzag
    order = [1 9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
        41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
        43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
        45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
        62 63 56 64];
    
    ZigZag_Order = uint8([
            1  9  2  3  10 17 25 18
            11 4  5  12 19 26 33 41
            34 27 20 13 6  7  14 21 
            28 35 42 49 57 50 43 36 
            29 22 15 8  16 23 30 37
            44 51 58 59 52 45 38 31 
            24 32 39 46 53 60 61 54 
            47 40 48 55 62 63 56 64]);

% Escala las matrices de cuantización según un factor de escala
qf = 75 ;
if qf < 50
    q_scale = floor (5000/ qf) ;
else
    q_scale = 200 - 2 * qf;
end

q_y = round (q_y * q_scale / 100);
q_c = round (q_c * q_scale / 100);

% RGB a YCbCr
ycc = rgb2ycbcr(im2double (original)) ;

% Submuestrear y reducir crominancia
cb = conv2(ycc(:,:,2),[ 1 1 ; 1 1]) ./ 4.0;
cr = conv2(ycc(:,:,3),[ 1 1 ; 1 1]) ./ 4.0;
cb = cb(2:2: size(cb,1), 2 : 2 : size(cb,2));
cr = cr(2:2: size(cr,1), 2 : 2 : size(cr,2));
y = ycc(:,:,1);


% DCT con escalado antes de cuantización
y = blockproc(y,[8 8],dct).*q_max;
cb = blockproc(cb, [8 8], dct ) .* q_max;
cr = blockproc(cr, [8 8], dct ) .* q_max;


% Cuantizacion de los coeficientes DCT
y = blockproc(y,[8 8],@(block_struct) round(round(block_struct.data)./q_y));
cb = blockproc(cb,[8 8],@(block_struct) round(round(block_struct.data)./q_c));
cr = blockproc(cr,[8 8],@(block_struct) round(round(block_struct.data)./q_c));

mask = [1   1   1   1   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        1   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
y = blockproc(y,[8 8],@(block_struct) mask .* block_struct.data);
cb = blockproc(cb,[8 8],@(block_struct) mask .* block_struct.data);
cr = blockproc(cr,[8 8],@(block_struct) mask .* block_struct.data);

%ZIGZAG DE LOS BLOQUES
    %prueba=zigzag(y(1:8,1:8));
    %runLengthCode(prueba)
bloques = im2col(y, [8 8], 'distinct');  % Pone los bloques de 8x8 en columnas
xb = size(bloques, 2);                   % Coge el numero de bloques
bloques_zigzag = bloques(order, :);      % Reordena elementos columna

coef_DC= bloques_zigzag(1,:);
coef_AC= bloques_zigzag(2:63,:);

%CODIFICACION HUFFMAN DE coeficientes USANDO CODIFICACION DPCM 
%se necesitan las funciones huffman_dc y huffman_ac
% ESTO COMENTADO FUNCIONA

%stream=[];
%dpcm(1,1)=coef_DC(1);
%stream=cat(2,stream,huffman_dc(dpcm(1,1)),huffman_ac(coef_AC(:, 1)));
%for m=2:xb
%    dpcm(m,1)=coef_DC(m)-coef_DC(m-1);
%    stream=cat(2,stream,huffman_dc(dpcm(m,1)),huffman_ac(coef_AC(:,m)));
%end
   
eob = max(bloques_zigzag(:)) + 1;               % Create end-of-block symbol
r = zeros(numel(bloques_zigzag) + size(bloques_zigzag, 2), 1);
count = 0;
for j = 1:xb                       % Process 1 block (col) at a time
   i = max(find(bloques_zigzag(:, j)));         % Find last non-zero element
   if isempty(i)                   % No nonzero block values
      i = 0;
   end
   p = count + 1;
   q = p + i;
   r(p:q) = [bloques_zigzag(1:i, j); eob];      % Truncate trailing 0's, add EOB,
   count = count + i + 1;          % and add to output vector
end

r((count + 1):end) = [];           % Delete unusued portion of r
quality=1;
[zm, zn] = size(y); 
z           = struct;
z.size      = uint16([zm zn]);
z.numblocks = uint16(xb);
z.quality   = uint16(quality * 100);

% hacer mex unravel.c (previamente)
z.huffman   = mat2huff(r);




%DECODIFICACION JPEG %%%%%%%%%%%%%%%%%%%%%%%

pause

rev = order;                          % Calcula orden inverso
for k = 1:length(order)
   rev(k) = find(order == k);
end

q_y = double(z.quality) / 100 * q_y;  % Recupera calidad si fue disminuida.
xb = double(z.numblocks);             % Recupera número de bloques.
sz = double(z.size);
xn = sz(2);                           % Recupera columnas.
xm = sz(1);                           % Recupera filas.
x = huff2mat(z.huffman);              % Decodifica Huffman.
eob = max(x(:));                      % Coge el símbolo de fin de bloque

cero = zeros(64, xb);   k = 1;        % Construye columnas bloque copiando
for j = 1:xb                          % valores sucesivos desde x 
   for i = 1:64                       % en columnas de cero, cambiando 
      if x(k) == eob                  % a la siguiente columna si
         k = k + 1;   break;          % se encuentra un símbolo de fin de bloque (EOB).
      else
         cero(i, j) = x(k);
         k = k + 1;
      end
   end
end

cero = cero(rev, :);                           % Restaura orden
x = col2im(cero, [8 8], [xm xn], 'distinct');  % Forma bloques en la matriz
x = blkproc(x, [8 8], 'x .* P1', q_y);         % Desnormaliza con DCT
t = dctmtx(8);                                 % Coge bloques de 8 x 8 de la DCT
x = blkproc(x, [8 8], 'P1 * x * P2', t', t);   % Calcula bloque DCT-1
x = uint8(x + 128);                            % cambia nivel



% Descuantizacion de los coeficientes DCT
y = blockproc(y,[8 8],@(block_struct) block_struct.data.* q_y);
cb = blockproc(cb,[8 8],@(block_struct) block_struct.data.* q_c);
cr = blockproc(cr,[8 8],@(block_struct) block_struct.data.* q_c);

% Inversa de la DCT
y = blockproc(y./q_max, [8 8], idct);
cb = blockproc(cb./q_max, [8 8], idct);
cr = blockproc(cr./q_max, [8 8], idct);


% Reconstruir la imagen
filtro_recupera_1d = [ 1 3 3 1 ] / 4;
filtro_recupera = filtro_recupera_1d'*filtro_recupera_1d;

cb = conv2(filtro_recupera,upsample(upsample(padarray(cb,[1 1],'replicate'),2)',2)');
cb = cb(4:size(cb,1)-4, 4:size(cb,2)-4);

cr = conv2(filtro_recupera,upsample(upsample(padarray(cr,[1 1],'replicate'),2)',2)');
cr = cr(4:size(cr,1)- 4,4:size(cr,2) - 4);

% Concatena canales y recupera
imagen_rec = ycbcr2rgb(cat(3,y,cb,cr));

figure(5), imshow(imagen_rec);


energia_imagen_original = sum( original(:,:,1).^2 );
imagen_ruido = sum( (original(:,:,1)-imagen_rec(:,:,1)).^2 );
SNR = energia_imagen_original/ imagen_ruido;