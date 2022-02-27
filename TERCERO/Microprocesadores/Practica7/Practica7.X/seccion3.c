#include <xc.h> 
#include <stdint.h> 
#include "UART1.h" 
#include "Pic32Ini.h" 
#include <string.h> 

#define BAUDIOS 9600

void analizarCadena(char *c); 
int hex2int(char ch); 

//Al trabajar con cadenas no puedes igualar del tir�n - CORREGIR CADENAS 
int main (void) {
	char cad[100];
	InicializarUART1(BAUDIOS);
	int i = 0;
	char c;
  
    INTCONbits.MVEC = 1; // habilitar interrupciones
    asm(" ei");

    while(1){
    	c = getcUART();
        if(c != '\0'){
        	cad[i] = c;
            i++;
            if(c == '\n'){
                 analizarCadena(cad); 
                 i = 0;
            }
        }
    }
}

void analizarCadena(char *c) { 
	int pin = hex2int(c[5]); 
	char res[20] = "OK\n";
	//char *res = malloc(20); strcpy(res, "OK\n");
	int val_port = 0; 
	int valor = 0; 
	//Así da error el primer PD,C,0,0 que haces pero después bien ¿?
	 
	if(strncmp(c, "PD",2)==0){ //TRIS 
		valor = hex2int(c[7]);
		if((strncmp(c+3,"A",1)==0)){ 
			if(valor==0){ 
				TRISA &= ~(1 << pin); 
			}else if(valor==1){ 
				TRISA |= 1 << pin; 
			}else{ 
			strcpy(res,"Error\n"); 
			} 
		}else if((strncmp(c+3,"B",1)==0)){ 
			if(valor==0){ 
				TRISB &= ~(1 << pin); 
			}else if(valor==1){ 
				TRISB |= 1 << pin; 
			}else{ 
				strcpy(res,"Error\n"); 
			}
		}else if((strncmp(c+3,"C",1)==0)){ 
			if(valor==0){ 
				TRISC &= ~(1 << pin); 
			}else if(valor==1){ 
				TRISC |= 1 << pin; 
			}else{ 
				strcpy(res,"Error\n"); 
			} 
		}else{ 
			strcpy(res,"Error\n"); 
		} 
	}else if(strncmp(c, "PI",2)==0){ //PORT 
		if((strncmp(c+3,"A",1)==0)){ 
			if(((PORTA >> pin) & 1)==1){
				strncpy(res,c,3); //PI,
			    char num[2] = "1";
			    strcat(res,num);
			    strcat(res,"\n");
			}else if(((PORTA >> pin) & 1)==0){
				strncpy(res,c,3); //PI,
			    char num[2] = "0";
			    strcat(res,num);
			    strcat(res,"\n");
			}else{
				strcpy(res,"Error\n");
			}
		}else if((strncmp(c+3,"B",1)==0)){ 
			if(((PORTB >> pin) & 1)==1){
				strncpy(res,c,3); //PI,
			    char num[2] = "1";
			    strcat(res,num);
			    strcat(res,"\n");
			}else if(((PORTB >> pin) & 1)==0){
				strncpy(res,c,3); //PI,
			    char num[2] = "0";
			    strcat(res,num);
			    strcat(res,"\n");
			}else{
				strcpy(res,"Error\n");
			}
		}else if((strncmp(c+3,"C",1)==0)){ 
			if(((PORTC >> pin) & 1)==1){
				strncpy(res,c,3); //PI,
			    char num[2] = "1";
			    strcat(res,num);
			    strcat(res,"\n");
			}else if(((PORTC >> pin) & 1)==0){
				strncpy(res,c,3); //PI,
			    char num[2] = "0";
			    strcat(res,num);
			    strcat(res,"\n");
			}else{
				strcpy(res,"Error\n");
			}
		}else{ 
			strcpy(res,"Error\n"); 
		} 
	}else if(strncmp(c, "PO",2)==0){ //LAT 
		valor = hex2int(c[7]);
		if((strncmp(c+3,"A",1)==0)){ 
			if(valor==0){ 
				LATA &= ~(1 << pin); 
			}else if(valor==1){ 
				LATA |= 1 << pin; 
			}else{ 
				strcpy(res,"Error\n"); 
			} 
		}else if((strncmp(c+3,"B",1)==0)){ 
			if(valor==0){ 
				LATB &= ~(1 << pin); 
			}else if(valor==1){ 
				LATB |= 1 << pin; 
			}else{ 
				strcpy(res,"Error\n"); 
			} 
		}else if((strncmp(c+3,"C",1)==0)){ 
			if(valor==0){ 
				LATC &= ~(1 << pin); 
			}else if(valor==1){ 
				LATC |= 1 << pin; 
			}else{ 
				strcpy(res,"Error\n"); 
			} 
		}else{ 
			strcpy(res,"Error\n"); 
		} 
	}else{ 
		strcpy(res,"Error\n"); 
	} 
	putsUART(res); 
} 
  
int hex2int(char ch) { 
    if (ch >= '0' && ch <= '9'){ 
        return ch - '0'; 
    } 
    if (ch >= 'A' && ch <= 'F'){ 
        return ch - 'A' + 10; 
    } 
    if (ch >= 'a' && ch <= 'f'){ 
        return ch - 'a' + 10; 
    } 
    return -1; 
} 