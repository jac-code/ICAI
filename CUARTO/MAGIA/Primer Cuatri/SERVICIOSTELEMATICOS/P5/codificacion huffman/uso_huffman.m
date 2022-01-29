
close all
clear all

alfabeto={'0' '1' '2' '3' '4' '5' '6' '7'};
p=[ 0.08 0.08 0.08 0.16 0.12 0.12 0.24 0.12];

[arbol, tabla]=hufftree(alfabeto, p);

tabla;

pause

%Codificacion

mensaje= {'1' '3' '4' '5' '6' '0' '0' '3' '4' '3' '7' '6' '1' '2'} 
codificado=huffencode(mensaje, tabla)

pause
 
decodificado=huffdecode(codificado,arbol)

pause

