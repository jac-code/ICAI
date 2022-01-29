% MATLAB script for Illustrative Example uniform_ex3.m
clc;clear;close all
echo on
 
m_samp = randn(1,500);
L      = 64;
[sqnr,m_quan,code]=uniform_pcm(m_samp,L);
 
pause   % Press a key to see the SQNR.
sqnr
pause   % Press a key to see the first five input values.
m_samp(1:5)
pause   % Press a key to see the first five quantized values.
m_quan(1:5)
pause   % Press a key to see the first five codewords.
code(1:5,:)
echo off
