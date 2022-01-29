 % MATLAB script for Illustrative Example uniform_ex1.m
clc;clear;close all
% echo on
global q

% Se genera una señal semoidal con rango de 0 a 2pi cada pi/100
t      = [0:pi/100:2*pi];
m      = 10 * sin(t);

% Se muestrea esa señal a pi/4 
t_samp = [0:pi/4  :2*pi];
m_samp = 10 * sin(t_samp)

% Se muestra la señal original
figure(1)
plot (t,m,'-b','linewidth', 2)
hold on
% Se pone encima de la señal, los valores muestreados
stem (t_samp,m_samp, '--ro')
hold on 
legend('señal original','señal muestreada');
axis([0 2*pi -15 15])
 
L=16; %Niveles de cuantización que se desean. 
[sqnr,m_quan,code]=uniform_pcm(m_samp,L) %Devuelve la SNR, los valores reales descuantizados y palanbra binaria
 
figure(2)
plot (t,m/max(m),'-b','linewidth', 2)
hold on
stem (t_samp,m_samp/max(m), '--ro')
hold on 
for i=1:L
    plot (t,q(i)* ones(1,length(t)),'--g');hold on
end
legend('señal original normalizada','señal muestreada normalizada');
axis([0 2*pi -1.5 1.5])
echo off
