
#include <mega128.h>
#include <delay.h>

#define START 0xFF            
#define ID1 0x01                         
#define ID2 0x02 
#define ID3 0x03                         
#define ID4 0x04            
#define ID5 0x05                         
#define ID6 0x06 
#define ID7 0x07                         
#define ID8 0x08                         
#define LENGTH 0x07                                  
#define INSTR_WRITE 0x03
#define ADDRESS 0x1E

#define LENGTH_MOV 0x04                             
#define INSTR_WRITE_READ 0x02
#define ADDRESS_MOV 0x2E
#define LENGTH_MOV_READ 0x01//iscitavma jedan char 

#define LENGTH_ERROR 0x02
#define INSTR_WRITE_ERROR 0x01

#define ADDRESS_POS 0x24
#define LENGTH_POS_READ 0x02

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

// Get a character from the USART1 Receiver
#pragma used+
char getchar1(void)
{
char status,data;
while (1)
      {
      while (((status=UCSR1A) & RX_COMPLETE)==0);
      data=UDR1;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      }
}
#pragma used-

// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-

// Standard Input/Output functions
#include <stdio.h>


unsigned char brzina_servo_H, brzina_servo_L, ugao_servo_H, ugao_servo_L;
unsigned char sum=0;
unsigned char checksum=0;
unsigned char greska;
unsigned char IdServoGreska;
char paket1, paket2, paket4, paket6, paket7, moving, positionLow='L', positionHigh='H';

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

void blokiranje_predaje (void)                        //funkcija koja blokira predaju u trenutku kada 
{                                                      // posaljemo ceo paket
    while ( !( UCSR0A & (1<<TXC)) )   ;    //kada se posalje ceo paket onda se bit 6 registra UCSRA
    UCSR0B.3=0;                            // setuje na 1, potom se UCSRB.3 stavlja na 0, a to je bit koji
    UCSR0A.6=1;                            //iskljuci TxD i taj pin pinovo postaje PD1, a on je inicijalizovan
} 

void oslobadjanje_predaje (void)                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
{
    UCSR0B.3=1;                            //TxD se opet ukljucuje tako sto se UCSRB.3 bit setuje
}
                                                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
void oslobadjanje_prijema (void)                 
{
    UCSR0B.4=1;                         // bit koji kontrolise oslobadjanje i blokiranje prijema   
} 
        
void blokiranje_prijema (void)                 
{
    UCSR0B.4=0;                            
}     

/*********************FUNKCIJE SERVOI*********************/
void servo_func(short pozicija1,short brzina1)
{                  
    ugao_servo_H=(char)(pozicija1>>8);                    
    ugao_servo_L=(char)(pozicija1&0x00FF);
    
    brzina_servo_H=(char)(brzina1>>8);
    brzina_servo_L=(char)(brzina1&0x00FF);
    
    sum=0x28 + ID1 + brzina_servo_H + brzina_servo_L + ugao_servo_H + ugao_servo_L;
    checksum=~sum;
        
    blokiranje_prijema();
    oslobadjanje_predaje();
        
    putchar(START);             
    putchar(START);
    putchar(ID1);
    putchar(LENGTH);
    putchar(INSTR_WRITE);
    putchar(ADDRESS);
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


/*******************MOVING****************************/
void servo_moving_func(int IdServoa) //slanje poruke za dobijanja stanja moving
{ 
    sum = IdServoa+LENGTH_MOV+INSTR_WRITE_READ+ADDRESS_MOV+LENGTH_MOV_READ;//suma iinfo=2xStart+id+lenght+iw+add
    checksum=~sum;
               
    blokiranje_prijema();
    oslobadjanje_predaje();
            
    putchar(START);             
    putchar(START);
    putchar(IdServoa);
    putchar(LENGTH_MOV);
    putchar(INSTR_WRITE_READ);
    putchar(ADDRESS_MOV);
    putchar(LENGTH_MOV_READ);
    putchar(checksum);
            
    blokiranje_predaje();         
    oslobadjanje_prijema();
                        
    prijem_paketaMoving();
            
    oslobadjanje_predaje();                        
}  
void servo_position_func(int IdServoa) //slanje poruke za dobijanja stanja moving
{ 
    sum = IdServoa+LENGTH_MOV+INSTR_WRITE_READ+ADDRESS_POS+LENGTH_POS_READ;//suma iinfo=2xStart+id+lenght+iw+add
    checksum=~sum;
               
    blokiranje_prijema();
    oslobadjanje_predaje();
            
    putchar(START);             
    putchar(START);
    putchar(IdServoa);
    putchar(LENGTH_MOV);
    putchar(INSTR_WRITE_READ);
    putchar(ADDRESS_POS);
    putchar(LENGTH_POS_READ);
    putchar(checksum);
            
    blokiranje_predaje();         
    oslobadjanje_prijema();
                   
    prijem_paketaPosition();  
          
    oslobadjanje_predaje();  
}

void servo1_moving_func(unsigned int parametar1)    
{
    servo_moving_func(1);
    
    if(moving==1)
        putchar1('z');           
    else if(moving == 0)
        putchar1('x');
      
}

  // External Interrupt 7 service routine
interrupt [EXT_INT7] void ext_int7_isr(void)
{
servo_position_func(1);
putchar1(positionLow);
putchar1(positionHigh);

}

void main(void)
{

moving = 0;

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: On
// INT6 Mode: Any change
// INT7: On
// INT7 Mode: Any change
EICRA=0x00;
EICRB=0x00;
EIMSK=0xC0;
EIFR=0xC0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 115200
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x05;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 115200
UCSR1A=0x00;
UCSR1B=0x18;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x05;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")
while (1)
      {
        servo_func(500, 120);
          delay_ms(800);
        putchar1(positionLow);
        servo_func(180,120);        
        delay_ms(800);
      }
}
