#include "ax12func.h"
#include <mega128.h>
#include <stdio.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7

#define TXC 6
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

unsigned char brzina_servo_H, brzina_servo_L, ugao_servo_H, ugao_servo_L, valLow, valHigh;
unsigned char sum=0;
unsigned char checksum=0;
unsigned char greska;
unsigned char IdServoGreska;
char paket1, paket2, paket4, paket6, paket7;
extern char moving, positionLow, positionHigh;

void prijem_paketa (void)
{
    paket1=getchar();
    paket2=getchar();    
    IdServoGreska=getchar();    
    paket4=getchar();      
    greska=getchar();  
    paket6=getchar();                
}

void prijem_paketaMoving(void)
{
    paket1=getchar();
    paket2=getchar();      
    IdServoGreska=getchar();    
    paket4=getchar();      
    greska=getchar(); 
    moving=getchar(); 
    paket7=getchar();                  
}

void prijem_paketaPosition(void)
{
    paket1=getchar();
    paket2=getchar();      
    IdServoGreska=getchar();    
    paket4=getchar();      
    greska=getchar(); 
    positionLow=getchar(); 
	positionHigh=getchar(); 
    paket7=getchar();                  
}

void blokiranje_predaje(void)                        //funkcija koja blokira predaju u trenutku kada 
{                                                      // posaljemo ceo paket
    while ( !( UCSR0A & (1<<TXC)) )   ;    //kada se posalje ceo paket onda se bit 6 registra UCSRA
    UCSR0B.3=0;                            // setuje na 1, potom se UCSRB.3 stavlja na 0, a to je bit koji
    UCSR0A.6=1;                            //iskljuci TxD i taj pin pinovo postaje PD1, a on je inicijalizovan
} 

void oslobadjanje_predaje(void)                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
{
    UCSR0B.3=1;                            //TxD se opet ukljucuje tako sto se UCSRB.3 bit setuje
}
                                                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
void oslobadjanje_prijema(void)                 
{
    UCSR0B.4=1;                         // bit koji kontrolise oslobadjanje i blokiranje prijema   
} 
        
void blokiranje_prijema(void)                 
{
    UCSR0B.4=0;                            
}     

/*********************AX12 funkcije*********************/
void ax12_goto(int ID, short pozicija1,short brzina1)
{                  
    ugao_servo_H=(char)(pozicija1>>8);                    
    ugao_servo_L=(char)(pozicija1&0x00FF);
    
    brzina_servo_H=(char)(brzina1>>8);
    brzina_servo_L=(char)(brzina1&0x00FF);
    
    sum=0x28 + ID + brzina_servo_H + brzina_servo_L + ugao_servo_H + ugao_servo_L;
    checksum=~sum;
        
    blokiranje_prijema();
    oslobadjanje_predaje();
        
    putchar(0xff);             
    putchar(0xff);
    putchar(ID);
    putchar(0x07);
    putchar(0x03);
    putchar(0x1e);
    putchar(ugao_servo_L);
    putchar(ugao_servo_H);
    putchar(brzina_servo_L);
    putchar(brzina_servo_H);
    putchar(checksum);
                
    blokiranje_predaje();       
    oslobadjanje_prijema();
        
    prijem_paketa();
        
    oslobadjanje_predaje();
}

void ax12_moving_status(int ID) //slanje poruke za dobijanja stanja moving
{ 
    sum = ID+0x04+0x02+0x2e+0x01;//suma iinfo=2xStart+ID+lenght+iw+add
    checksum=~sum;
               
    blokiranje_prijema();
    oslobadjanje_predaje();
            
    putchar(0xff);             
    putchar(0xff);
    putchar(ID);
    putchar(0x04);	//LENGTH
    putchar(0x02);	//INSTRUCTION READ
    putchar(0x2e);	//ADRESS
    putchar(0x01);	//LENGTH READ
    putchar(checksum);
            
    blokiranje_predaje();         
    oslobadjanje_prijema();
                        
    prijem_paketaMoving();
            
    oslobadjanje_predaje();                        
}  

void ax12_position_status(int ID) //slanje poruke za dobijanja pozicije
{ 
    sum = ID+0x04+0x02+0x24+0x02;//suma iinfo=2xStart+ID+lenght+iw+add
    checksum=~sum;
               
    blokiranje_prijema();
    oslobadjanje_predaje();
            
    putchar(0xff);             
    putchar(0xff);
    putchar(ID);
    putchar(0x04); 	//LENGTH
    putchar(0x02);	//INSTRUCTION READ	
    putchar(0x24);	//ADRESS
    putchar(0x02);	//LENGTH READ
    putchar(checksum);
            
    blokiranje_predaje();         
    oslobadjanje_prijema();
                   
    prijem_paketaPosition();  
          
    oslobadjanje_predaje();  
}
void ax12_alarm_shutdown(int ID)
{     
    sum=ID+0x04+0x03+0x12+0x24;
    checksum=~sum;
      
    blokiranje_prijema();
    oslobadjanje_predaje();
      
    putchar(0xff);  //START
    putchar(0xff);  //START
    putchar(ID);  //ID
    putchar(0x04);  //LENGTH
    putchar(0x03);  ///WRITE
    putchar(0x12);  //ADRESS
    putchar(0x24);  //VALUE
	putchar(checksum); //CHECKSUM
}
void ax12_torque_enable(int ID)	//ukljucuje moment
{     
    
    sum=0x01+0x05+0x03+0x18+0x01+0x00;
    checksum=~sum;
	
    blokiranje_prijema();
    oslobadjanje_predaje();
      
    putchar(0xff);  //START
    putchar(0xff);  //START
    putchar(ID);    //ID
    putchar(0x05);  //LENGTH
    putchar(0x03);  ///WRITE
    putchar(0x18);  //ADRESS
    putchar(0x01);  //VALUE
    putchar(0x00);  //VALUE
    putchar(checksum); //CHECKSUM

	blokiranje_predaje();       
    oslobadjanje_prijema();
        
    prijem_paketa();
        
    oslobadjanje_predaje();
}
void ax12_torque_limit(int ID, int value) //podesavanje maksimalnog momenta
{     
	valHigh=(char)(value>>8);                    
    valLow=(char)(value&0x00FF);
      
    sum=ID+0x05+0x03+0x22+valLow+valHigh;
    checksum=~sum; 
    
	blokiranje_prijema();
    oslobadjanje_predaje();

    putchar(0xff);  //START
    putchar(0xff);  //START
    putchar(ID);  	//ID
    putchar(0x05);  //LENGTH
    putchar(0x03);  ///WRITE
    putchar(0x22);  //ADRESS
    putchar(valLow);  //VALUE
    putchar(valHigh);  //VALUE 
    putchar(checksum);
	
	blokiranje_predaje();       
    oslobadjanje_prijema();
        
    prijem_paketa();
        
    oslobadjanje_predaje();
    

}
void ax12_id_set(int ID)	//podesavanje IDa servoa
{
     char sum, checksum;
     sum=0xfe+0x04+0x03+0x03+ID;
     checksum=~sum;

     putchar(0xff);  //START
     putchar(0xff);  //START
     putchar(0xfe);  //ID
     putchar(0x04);  //LENGTH
     putchar(0x03);  ///WRITE
     putchar(0x03);  //ADRESS
     putchar(ID);  //VALUE
     putchar(checksum); //CHECKSUM
	 
	blokiranje_predaje();       
    oslobadjanje_prijema();
        
    prijem_paketa();
        
    oslobadjanje_predaje();
}
void ax12_reset(int ID) //reset na fabricko podesavanje
{
    sum=ID+0x02+0x06;
    checksum=~sum;

    
    blokiranje_prijema();
    oslobadjanje_predaje();
   
    putchar(0xff);  //START
    putchar(0xff);  //START
    putchar(ID);  	//ID
    putchar(0x02);  //LENGTH
    putchar(0x06);  //reset
    putchar(checksum); //CHECKSUM

}