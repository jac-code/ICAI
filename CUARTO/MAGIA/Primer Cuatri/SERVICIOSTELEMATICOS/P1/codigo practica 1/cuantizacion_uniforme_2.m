% MATLAB script for Illustrative Example uniform_ex2.m
clc;clear;close all
echo on
 
t_samp = [0:0.01:10];
m_samp = sin(t_samp);

figure
%Se presenta la señal y sus muestras
h= plot(t_samp,m_samp);
set(h, 'Marker','+')

pause
 
[sqnr_8L,m_quan_8L,code_8L]=uniform_pcm(m_samp,8);
[sqnr_16L,m_quan_16L,code_16L]=uniform_pcm(m_samp,16);
 
pause   % Press a key to see the SQNR for L = 8.
sqnr_8L
 
pause   % Press a key to see the SQNR for L = 16.
sqnr_16L
 
pause   % Press a key to see the plot of the signal and its 
        % quantized versions.
        
figure
t = t_samp; m = m_samp;
plot(t,m,'-',t,m_quan_8L,'-.',t,m_quan_16L,'-',t,zeros(1,length(t)), ...
    'linewidth', 2)
legend('Original','Cuantizada (L=8)','Cuantizada (L=16)','Location', ...
    'SouthEast');
 
% pause % Press a key to see the first 5 samples, corresponding quanited   
%       % values, and corresponding codewords with 8 quantization levels
%m(1:5)
%m_quan_8L(1:5)
%code_8L(1:5,:)
% 
 %pause % Press a key to see the first 5 samples, corresponding quanited  
%       % values, and corresponding codewords with 16 quantization levels
 %m(1:5)
 %m_quan_16L(1:5)
% code_16L(1:5,:)
%echo off
