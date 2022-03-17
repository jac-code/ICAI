%% PRÁCTICA 5
%% Cuantificación de los coeficientes de un filtro
%% a)
load('PDS_P5_3A_LE2_G6.mat');
load('Elliptic.mat');

%% b)
q = quantizer('fixed','round','saturate',[16 8]);

num_q = num2bin(q,Num);
num_q = bin2num(q,num_q);

den_q = num2bin(q,Den);
den_q= bin2num(q, den_q);

%% Secciones de segundo orden
%% a)
[sos, g] = tf2sos(Num, Den); 

%% b)
b1 = sos(1,1:3);
b2 = sos(2,1:3);
b3 = sos(3,1:3);
b4 = sos(4,1:3);

a1 = sos(1,4:6);
a2 = sos(2,4:6);
a3 = sos(3,4:6);
a4 = sos(4,4:6);

%Sometemos a la escala de cuantificación a los coeficientes de las secciones de
%segundo orden. Luego lo volvemos a pasar a formato normal

b1_q = bin2num(q, num2bin(q,b1));
b2_q = bin2num(q, num2bin(q,b2));
b3_q = bin2num(q, num2bin(q,b3));
b4_q = bin2num(q, num2bin(q,b4));

a1_q = bin2num(q, num2bin(q,a1));
a2_q = bin2num(q, num2bin(q,a2));
a3_q = bin2num(q, num2bin(q,a3));
a4_q = bin2num(q, num2bin(q,a4));

raices_num_q = [roots(b1_q);roots(b2_q);roots(b3_q); roots(b4_q)];
raices_den_q = [roots(a1_q); roots(a2_q); roots(a3_q); roots(a4_q)];

% nueva matriz segundo orden --> con valores cuantificados
matriz_coeficientes_b = [b1_q.'; b2_q.'; b3_q.' ;b4_q.'];
matriz_coeficientes_a = [a1_q.'; a2_q.'; a3_q.' ;a4_q.'];
matriz_coeficientes_final = [matriz_coeficientes_b, matriz_coeficientes_a];

%% Raíces en secciones de segundo orden
%% a)
raices_b1 = roots(b1);
raices_b2 = roots(b2);
raices_b3 = roots(b3);
raices_b4 = roots(b4);

raices_a1 = roots(a1);
raices_a2 = roots(a2);
raices_a3 = roots(a3);
raices_a4 = roots(a4);

%% b)
raices_b1_q = bin2num(q,num2bin(q, raices_b1));
raices_b2_q = bin2num(q,num2bin(q, raices_b2));
raices_b3_q = bin2num(q,num2bin(q, raices_b3));
raices_b4_q = bin2num(q,num2bin(q, raices_b4));

raices_a1_q = bin2num(q,num2bin(q, raices_a1));
raices_a2_q = bin2num(q,num2bin(q, raices_a2));
raices_a3_q = bin2num(q,num2bin(q, raices_a3));
raices_a4_q = bin2num(q,num2bin(q, raices_a4));

polinomio_b1 = poly(raices_b1_q);
polinomio_b2 = poly(raices_b2_q);
polinomio_b3 = poly(raices_b3_q);
polinomio_b4 = poly(raices_b4_q);

% Ahora con los del denominador
pol_a1 = poly(raices_a1_q);
pol_a2 = poly(raices_a2_q);
pol_a3 = poly(raices_a3_q);
pol_a4 = poly(raices_a4_q);

% Matrices intermedias y concatenadas para matriz final
matriz_coeficientes_raices_b = [polinomio_b1;polinomio_b2;polinomio_b3;polinomio_b4];
matriz_coeficientes_raices_a = [pol_a1;pol_a2;pol_a3;pol_a4];
matriz_coeficientes_raices_final = [matriz_coeficientes_raices_b, matriz_coeficientes_raices_a];

%% Análisis general
%% a)
raices_num = roots(Num);
raices_den = roots(Den);
raices_num_q1 = roots(num_q);
raices_den_q1 = roots(den_q);

%Creamos una matriz con tantas columnas como raices del
%numerador/denominador cuantificado
%En cada columna se repiten todas los ceros/polos originales

matriz_num_a = repmat(raices_num,1,length(raices_num_q1));
matriz_den_a = repmat(raices_den,1,length(raices_den_q1));

%Creamos una matriz con tantas filas como raices del numerador/denominador original
%En cada fila se repiten todos los ceros/polos del numerador/denominador cuantificado

matriz_num_b = repmat(raices_num_q1.',length(raices_num),1);
matriz_den_b = repmat(raices_den_q1.',length(raices_den),1);

dc_num_caso1 = abs(matriz_num_a-matriz_num_b);
dc_den_caso1 = abs(matriz_den_a-matriz_den_b);

%Nos trasponemos la matriz de distancias para poder usar min por columnas
dc_num_caso1 = dc_num_caso1.';
dc_den_caso1 = dc_den_caso1.';

%Ahora con min tengo en el indice 1 de M la distancia que hay entre el 0
%original al cero cuantificado mas cercano y además se cual es porque se
%guarda la posicion en I

[M1, I1] = min(dc_num_caso1);
[M2, I2] = min(dc_den_caso1);

%Recorro el vector de I y para cada valor busco a ver si hay otro igual
%En caso de que haya otro igual sustituyo por 0 para aquel cuya distancia
%al cero cuantificado sea mayor porque significa que realmente ese 0
%cuantificado no le corresponde

for i=1:length(I1)
    indice_num=I1(i);
    indice_den=I2(i);
    for j=1:length(I1)
        if(j~=i && I1(j)~=0 && indice_num==I1(j)&& M1(j)>M1(i))
            I1(j)=0;
        end
        if(j~=i && I2(j)~=0 && indice_den==I2(j)&& M2(j)>M2(i))
            I2(j)=0;
        end
    end
end

ECM_numerador_caso1 = 0;
ECM_denominador_caso1 = 0;

%Ahora ya puedo calcular la suma porque conozco la correspondencia entre el
%cero normal y el cero cuantificado
for i=1:length(raices_num)
   if(I1(i)~=0)
       ECM_numerador_caso1=ECM_numerador_caso1+(M1(i)^2);
   else
       ECM_numerador_caso1=ECM_numerador_caso1+(abs(raices_num(i))^2);
   end
   
   if(I2(i)~=0)
       ECM_denominador_caso1=ECM_denominador_caso1+M2(i)^2;
   else
       ECM_denominador_caso1=ECM_denominador_caso1+(abs(raices_den(i))^2);
   end
end


ECM_caso1=(1/(M*2))*(ECM_numerador_caso1+ECM_denominador_caso1);


%Repetimos el proceso para los otros dos casos

matriz_num_a=repmat(raices_num,1,length(raices_num_q));
matriz_den_a=repmat(raices_den,1,length(raices_den_q));

matriz_num_b=repmat(raices_num_q.',length(raices_num),1);
matriz_den_b=repmat(raices_den_q.',length(raices_den),1);

dc_num_caso2=abs(matriz_num_a-matriz_num_b).';
dc_den_caso2=abs(matriz_den_a-matriz_den_b).';


[M1, I1]= min(dc_num_caso2);
[M2, I2]=min(dc_den_caso2);


for i=1:length(I1)
    indice_num=I1(i);
    indice_den=I2(i);
    for j=1:length(I1)
        if(j~=i && I1(j)~=0 && indice_num==I1(j)&& M1(j)>M1(i))
            I1(j)=0;
        end
        if(j~=i && I2(j)~=0 && indice_den==I2(j)&& M2(j)>M2(i))
            I2(j)=0;
        end
    end
end

ECM_numerador_caso2=0;
ECM_denominador_caso2=0;

for i=1:length(raices_num)
   if(I1(i)~=0)
       ECM_numerador_caso2=ECM_numerador_caso2+M1(i)^2;
   else
       ECM_numerador_caso2=ECM_numerador_caso2+(abs(raices_num(i))^2);
   end
   
   if(I2(i)~=0)
       ECM_denominador_caso2=ECM_denominador_caso2+M2(i)^2;
   else
       ECM_denominador_caso2=ECM_denominador_caso2+(abs(raices_den(i))^2);
   end
end

%Al ser de orden 8 el filtro hay 16 raices: 8 polos y 8 ceros
ECM_caso2=(1/(M*2))*(ECM_numerador_caso2+ECM_denominador_caso2);


%Ultimo caso
raices_num_cuantificadas3=[raices_b1_q; raices_b2_q; raices_b3_q; raices_b4_q];
raices_den_cuantificadas3=[raices_a1_q; raices_a2_q; raices_a3_q; raices_a4_q];

matriz_num_a=repmat(raices_num,1,length(raices_num_cuantificadas3));
matriz_den_a=repmat(raices_den,1,length(raices_den_cuantificadas3));

matriz_num_b=repmat(raices_num_cuantificadas3.',length(raices_num),1);
matriz_den_b=repmat(raices_den_cuantificadas3.',length(raices_den),1);


dc_num_caso3=abs(matriz_num_a-matriz_num_b).';
dc_den_caso3=abs(matriz_den_a-matriz_den_b).';


[M1, I1]= min(dc_num_caso3);
[M2, I2]=min(dc_den_caso3);


for i=1:length(I1)
    indice_num=I1(i);
    indice_den=I2(i);
    for j=1:length(I1)
        if(j~=i && I1(j)~=0 && indice_num==I1(j)&& M1(j)>M1(i))
            I1(j)=0;
        end
        if(j~=i && I2(j)~=0 && indice_den==I2(j)&& M2(j)>M2(i))
            I2(j)=0;
        end
    end
end

ECM_numerador_caso3=0;
ECM_denominador_caso3=0;

for i=1:length(raices_num)
   if(I1(i)~=0)
       ECM_numerador_caso3=ECM_numerador_caso3+M1(i)^2;
   else
       ECM_numerador_caso3=ECM_numerador_caso3+(abs(raices_num(i))^2);
   end
   
   if(I2(i)~=0)
       ECM_denominador_caso3=ECM_denominador_caso3+M2(i)^2;
   else
       ECM_denominador_caso3=ECM_denominador_caso3+(abs(raices_den(i))^2);
   end
end

ECM_caso3=(1/(M*2))*(ECM_numerador_caso3+ECM_denominador_caso3);



%% Apartado b)

%Con la funcion freqz nos calculamos la respuesta en frecuencia
[h1,f1]=freqz(sos, 5000, Fs);
[h2,f2]=freqz(num_q, den_q, 5000, Fs);
[h3,f3]=freqz(matriz_coeficientes_final,5000, Fs);
[h4,f4]=freqz(matriz_coeficientes_raices_final, 5000, Fs);

%Recuerda que la funcion sos te devuelve la ganancia g
%Hay que multiplicar por dicha ganancia la h para que la grafica sea
%correcta

h1=h1*g;
h4=h4*g;
h3=h3*g;

%Paso las respuestas en frecuencia a dB

h1dB=mag2db(abs(h1));
h2dB=mag2db(abs(h2));
h3dB=mag2db(abs(h3));
h4dB=mag2db(abs(h4));

%Represento las respuestas en frecuencia

figure;
hold on;
plot(f1, h1dB);
plot(f2, h2dB);
plot(f3, h3dB);
plot(f4, h4dB);
xlabel('Frecuencia[Hz]');
ylabel('Magnitud [dB]');
title('Respuesta en frecuencia');
grid on;
legend('original','cuantificación de coeficientes', 'cuantificación secciones de segundo orden', 'cuantificación de raíces')


%Banda de paso de filtro original y cuantificaciones mas ajustadas

figure;
hold on;
plot(f1, h1dB);
plot(f3, h3dB);
plot(f4, h4dB);
xlabel('Frecuencia[Hz]');
ylabel('Magnitud [dB]');
title('Banda de paso');
axis([0 3500 -1 1]);
grid on;
legend('original', 'cuantificación secciones de segundo orden', 'cuantificación de raíces');

%Banda atenuada

figure;
hold on;
plot(f1, h1dB);
plot(f3, h3dB);
plot(f4, h4dB);
xlabel('Frecuencia[Hz]');
ylabel('Magnitud [dB]');
title('Banda atenuada');
axis([5000 6000 -150 -75]);
grid on;
legend('original', 'cuantificación secciones de segundo orden', 'cuantificación de raíces');
%% Apartado c)

%obtenemos la fase y eliminamos saltos con unwrap

h1_phase= unwrap(angle(h1));
h2_phase= unwrap(angle(h2));
h3_phase= unwrap(angle(h3));
h4_phase= unwrap(angle(h4));


%Representamos la fase

figure;
hold on;
plot(f1, h1_phase);
plot(f2, h2_phase);
plot(f3, h3_phase);
plot(f4, h4_phase);
axis([0 5000 -12 2]);
xlabel('Frecuencia[Hz]');
ylabel('Fase [rad]');
title('Fase de la respuesta en frecuencia');
grid on;
legend('original','cuantificación de coeficientes', 'cuantificación secciones de segundo orden', 'cuantificación de raíces')



%% Apartado d)

%Representamos el diagrama de polos y ceros de cada uno de los filtros

figure;

subplot(2,2,1);
zplane(raices_num, raices_den);
axis([-1.1 1.1 -1.1 1.1]);
title('Filtro original');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


subplot(2,2,2);
zplane(raices_num_q1, raices_den_q1);
axis([-1.1 1.1 -1.1 1.1]);
title('Cuantificación de los coeficientes');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


subplot(2,2,3);
zplane(raices_num_q, raices_den_q);
axis([-1.1 1.1 -1.1 1.1]);
title('Secciones cuantificadas');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;


subplot(2,2,4);
zplane(raices_num_cuantificadas3,raices_den_cuantificadas3);
axis([-1.1 1.1 -1.1 1.1]);
title('Raíces cuantificadas');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;

%Representar todo sobre el mismo eje

figure;
hold on;
zplane(raices_num, raices_den);
zplane(raices_num_q1, raices_den_q1);
zplane(raices_num_q, raices_den_q);
zplane(raices_num_cuantificadas3,raices_den_cuantificadas3);
axis([-1.1 1.1 -1.1 1.1]);
title('Comparacion');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;