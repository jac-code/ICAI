%% Práctica 5- Cuantificación de los coeficientes de un filtro
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

polinomio_a1 = poly(raices_a1_q);
polinomio_a2 = poly(raices_a2_q);
polinomio_a3 = poly(raices_a3_q);
polinomio_a4 = poly(raices_a4_q);

matriz_coeficientes_raices_b = [polinomio_b1;polinomio_b2;polinomio_b3;polinomio_b4];
matriz_coeficientes_raices_a = [polinomio_a1;polinomio_a2;polinomio_a3;polinomio_a4];
matriz_coeficientes_raices_final = [matriz_coeficientes_raices_b, matriz_coeficientes_raices_a];

%% Análisis general
%% a)
raices_num = roots(Num);
raices_den = roots(Den);
raices_num_q1 = roots(num_q);
raices_den_q1 = roots(den_q);

matriz_num_a = repmat(raices_num,1,length(raices_num_q1));
matriz_den_a = repmat(raices_den,1,length(raices_den_q1));

matriz_num_b = repmat(raices_num_q1.',length(raices_num),1);
matriz_den_b = repmat(raices_den_q1.',length(raices_den),1);

dc_num_coef = abs(matriz_num_a-matriz_num_b);
dc_den_coef = abs(matriz_den_a-matriz_den_b);

dc_num_coef = dc_num_coef.';
dc_den_coef = dc_den_coef.';

[MATRIX1, I1] = min(dc_num_coef);
[MATRIX2, I2] = min(dc_den_coef);

for i=1:length(I1)
    indice_num=I1(i);
    indice_den=I2(i);
    for j=1:length(I1)
        if(j~=i && I1(j)~=0 && indice_num==I1(j)&& MATRIX1(j)>MATRIX1(i))
            I1(j)=0;
        end
        if(j~=i && I2(j)~=0 && indice_den==I2(j)&& MATRIX2(j)>MATRIX2(i))
            I2(j)=0;
        end
    end
end

ecm_num_coef = 0;
ecm_den_coef = 0;

%Ahora ya puedo calcular la suma porque conozco la correspondencia entre el
%cero normal y el cero cuantificado
for i=1:length(raices_num)
   if(I1(i)~=0)
       ecm_num_coef=ecm_num_coef+(MATRIX1(i)^2);
   else
       ecm_num_coef=ecm_num_coef+(abs(raices_num(i))^2);
   end
   
   if(I2(i)~=0)
       ecm_den_coef=ecm_den_coef+MATRIX2(i)^2;
   else
       ecm_den_coef=ecm_den_coef+(abs(raices_den(i))^2);
   end
end

ecm_coef=(1/(M*2))*(ecm_num_coef+ecm_den_coef);


matriz_num_a = repmat(raices_num,1,length(raices_num_q));
matriz_den_a = repmat(raices_den,1,length(raices_den_q));

matriz_num_b = repmat(raices_num_q.',length(raices_num),1);
matriz_den_b = repmat(raices_den_q.',length(raices_den),1);

dc_num_secciones = abs(matriz_num_a-matriz_num_b).';
dc_den_secciones = abs(matriz_den_a-matriz_den_b).';

[MATRIX1, I1] = min(dc_num_secciones);
[MATRIX2, I2] = min(dc_den_secciones);

for i=1:length(I1)
    indice_num=I1(i);
    indice_den=I2(i);
    for j=1:length(I1)
        if(j~=i && I1(j)~=0 && indice_num==I1(j)&& MATRIX1(j)>MATRIX1(i))
            I1(j)=0;
        end
        if(j~=i && I2(j)~=0 && indice_den==I2(j)&& MATRIX2(j)>MATRIX2(i))
            I2(j)=0;
        end
    end
end

ecm_num_secciones = 0;
ecm_den_secciones = 0;

for i=1:length(raices_num)
   if(I1(i)~=0)
       ecm_num_secciones = ecm_num_secciones+MATRIX1(i)^2;
   else
       ecm_num_secciones = ecm_num_secciones+(abs(raices_num(i))^2);
   end
   
   if(I2(i)~=0)
       ecm_den_secciones = ecm_den_secciones+MATRIX2(i)^2;
   else
       ecm_den_secciones = ecm_den_secciones+(abs(raices_den(i))^2);
   end
end

ecm_secciones = (1/(M*2))*(ecm_num_secciones+ecm_den_secciones);


raices_num_q_raices = [raices_b1_q; raices_b2_q; raices_b3_q; raices_b4_q];
raices_den_q_raices = [raices_a1_q; raices_a2_q; raices_a3_q; raices_a4_q];

matriz_num_a = repmat(raices_num,1,length(raices_num_q_raices));
matriz_den_a = repmat(raices_den,1,length(raices_den_q_raices));

matriz_num_b = repmat(raices_num_q_raices.',length(raices_num),1);
matriz_den_b = repmat(raices_den_q_raices.',length(raices_den),1);

den_num_raices = abs(matriz_num_a-matriz_num_b).';
den_den_raices = abs(matriz_den_a-matriz_den_b).';

[MATRIX1, I1] = min(den_num_raices);
[MATRIX2, I2] = min(den_den_raices);

for i=1:length(I1)
    indice_num=I1(i);
    indice_den=I2(i);
    for j=1:length(I1)
        if(j~=i && I1(j)~=0 && indice_num==I1(j)&& MATRIX1(j)>MATRIX1(i))
            I1(j)=0;
        end
        if(j~=i && I2(j)~=0 && indice_den==I2(j)&& MATRIX2(j)>MATRIX2(i))
            I2(j)=0;
        end
    end
end

ecm_num_raices = 0;
ecm_den_raices = 0;

for i=1:length(raices_num)
   if(I1(i)~=0)
       ecm_num_raices = ecm_num_raices+MATRIX1(i)^2;
   else
       ecm_num_raices = ecm_num_raices+(abs(raices_num(i))^2);
   end
   
   if(I2(i)~=0)
       ecm_den_raices = ecm_den_raices+MATRIX2(i)^2;
   else
       ecm_den_raices = ecm_den_raices+(abs(raices_den(i))^2);
   end
end

ecm_raices = (1/(M*2))*(ecm_num_raices+ecm_den_raices);

%% b)
[h1, f1] = freqz(sos, 5000, Fs);
[h2, f2] = freqz(num_q, den_q, 5000, Fs);
[h3, f3] = freqz(matriz_coeficientes_final,5000, Fs);
[h4, f4] = freqz(matriz_coeficientes_raices_final, 5000, Fs);

h1dB=mag2db(abs(h1*g));
h2dB=mag2db(abs(h2*g));
h3dB=mag2db(abs(h3*g));
h4dB=mag2db(abs(h4*g));

figure;
hold on;
plot(f1, h1dB);
plot(f2, h2dB);
plot(f3, h3dB);
plot(f4, h4dB);
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
title('Respuesta en frecuencia');
grid on;
legend('Original','Cuantificación coeficientes', 'Cuantificación secciones de segundo orden', 'Cuantificación raíces')

figure;
hold on;
plot(f1, h1dB);
plot(f3, h3dB);
plot(f4, h4dB);
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
title('Banda de paso');
axis([0 3500 -1 1]);
grid on;
legend('Original', 'Cuantificación secciones de segundo orden', 'Cuantificación raíces');

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
legend('Original', 'Cuantificación secciones de segundo orden', 'Cuantificación raíces');

%% c)
h1_angle = unwrap(angle(h1));
h2_angle = unwrap(angle(h2));
h3_angle = unwrap(angle(h3));
h4_angle = unwrap(angle(h4));

figure;
hold on;
plot(f1, h1_angle);
plot(f2, h2_angle);
plot(f3, h3_angle);
plot(f4, h4_angle);
axis([0 5000 -12 2]);
xlabel('Frecuencia[Hz]');
ylabel('Fase [rad]');
title('Fase de la respuesta en frecuencia');
grid on;
legend('Original','Cuantificación coeficientes', 'Cuantificación secciones de segundo orden', 'Cuantificación raíces')

%% d)
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
title('Cuantificación coeficientes');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;

subplot(2,2,3);
zplane(raices_num_q, raices_den_q);
axis([-1.1 1.1 -1.1 1.1]);
title('Secciones de segundo orden cuantificadas');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;

subplot(2,2,4);
zplane(raices_num_q_raices,raices_den_q_raices);
axis([-1.1 1.1 -1.1 1.1]);
title('Raíces cuantificadas');
ylabel('Eje imaginario');
xlabel('Eje real');
grid on;