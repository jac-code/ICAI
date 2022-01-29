
clear all 
close all
load timit1 ;
plot(timit1)
title('timit1')
xlabel('Indice de Tiempo, {\it n}');
ylabel('Amplitud');
axis([0 length(timit1) -1 1]);
grid


pause
soundsc(timit1, 16000);
pause

subplot(211), plot(timit1(14501:14900));
subplot(212), plot(timit1(35501:35900));
pause
  
clear all
close all

load digits;
N=300;
x=digits.four1;
soundsc(x)
pause
plot(x);
pause

Px=stpower(x, N); % Calcula la potencia de la señal en una ventana móvil de N muestras
plot(Px)
pause
Zx= stzerocross(x,N);
pause

plot([Px*1e-5 Zx x/N]);

voi = voiunvoi(x,N,0.5,0.5); % Función que busca la zona donde hay voz y donde no
plot(voi);
pause

clear all; close all;
load vowels;

figure(1)
plot(vowels.a_1(2001:2300));
figure(2)
plot(vowels.i_1(2001:2300));
figure(3)
plot(vowels.o_1(2001:2300));
figure(4)
plot(vowels.u_1(2001:2300));

pause

soundsc(vowels.a_1, 10000)
soundsc(vowels.i_1, 10000)
soundsc(vowels.o_1, 10000) 
soundsc(vowels.u_1, 10000)
soundsc(vowels.a_1, 10000)
soundsc(vowels.i_1, 10000)
soundsc(vowels.o_1, 10000) 
soundsc(vowels.u_1, 10000)


pause
soundsc(vowels.myst_1, 10000) 
soundsc(vowels.myst_3, 10000)
pause


