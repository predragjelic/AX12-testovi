
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 11,059000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _moving=R5
	.DEF _positionLow=R4
	.DEF _positionHigh=R7
	.DEF _brzina_servo_H=R6
	.DEF _brzina_servo_L=R9
	.DEF _ugao_servo_H=R8
	.DEF _ugao_servo_L=R11
	.DEF _valLow=R10
	.DEF _valHigh=R13
	.DEF _sum=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int7_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x20010:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x0C
	.DW  _0x20010*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <ax12func.h>
;
;#define sensor1 PINA.0
;#define sensor2 PINA.1
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#define TXC 6
;
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 002F {

	.CSEG
; 0000 0030 char status,data;
; 0000 0031 while (1)
;	status -> R17
;	data -> R16
; 0000 0032       {
; 0000 0033       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0034       data=UDR1;
; 0000 0035       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 0036          return data;
; 0000 0037       }
; 0000 0038 }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 003E {
_putchar1:
; 0000 003F while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
_0xA:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0xA
; 0000 0040 UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0000 0041 }
	JMP  _0x2060001
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;char moving, positionLow, positionHigh;
;
;  // External Interrupt 7 service routine
;interrupt [EXT_INT7] void ext_int7_isr(void)
; 0000 004B {
_ext_int7_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004C ax12_position_status(1);
	CALL SUBOPT_0x0
	RCALL _ax12_position_status
; 0000 004D putchar1(positionLow);
	ST   -Y,R4
	RCALL _putchar1
; 0000 004E putchar1(positionHigh);
	ST   -Y,R7
	RCALL _putchar1
; 0000 004F 
; 0000 0050 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void main(void)
; 0000 0053 {
_main:
; 0000 0054 bit radi;
; 0000 0055 
; 0000 0056 // Input/Output Ports initialization
; 0000 0057 // Port A initialization
; 0000 0058 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0059 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005A PORTA=0x00;
;	radi -> R15.0
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 005B DDRA=0x00;
	OUT  0x1A,R30
; 0000 005C 
; 0000 005D // Port B initialization
; 0000 005E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0060 PORTB=0x00;
	OUT  0x18,R30
; 0000 0061 DDRB=0x00;
	OUT  0x17,R30
; 0000 0062 
; 0000 0063 // Port C initialization
; 0000 0064 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0065 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0066 PORTC=0x00;
	OUT  0x15,R30
; 0000 0067 DDRC=0x00;
	OUT  0x14,R30
; 0000 0068 
; 0000 0069 // Port D initialization
; 0000 006A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 006B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 006C PORTD=0x00;
	OUT  0x12,R30
; 0000 006D DDRD=0x00;
	OUT  0x11,R30
; 0000 006E 
; 0000 006F // Port E initialization
; 0000 0070 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0071 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0072 PORTE=0x00;
	OUT  0x3,R30
; 0000 0073 DDRE=0x00;
	OUT  0x2,R30
; 0000 0074 
; 0000 0075 // Port F initialization
; 0000 0076 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0077 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0078 PORTF=0x00;
	STS  98,R30
; 0000 0079 DDRF=0x00;
	STS  97,R30
; 0000 007A 
; 0000 007B // Port G initialization
; 0000 007C // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 007D // State4=T State3=T State2=T State1=T State0=T
; 0000 007E PORTG=0x00;
	STS  101,R30
; 0000 007F DDRG=0x00;
	STS  100,R30
; 0000 0080 
; 0000 0081 // Timer/Counter 0 initialization
; 0000 0082 // Clock source: System Clock
; 0000 0083 // Clock value: Timer 0 Stopped
; 0000 0084 // Mode: Normal top=0xFF
; 0000 0085 // OC0 output: Disconnected
; 0000 0086 ASSR=0x00;
	OUT  0x30,R30
; 0000 0087 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0088 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0089 OCR0=0x00;
	OUT  0x31,R30
; 0000 008A 
; 0000 008B // Timer/Counter 1 initialization
; 0000 008C // Clock source: System Clock
; 0000 008D // Clock value: Timer1 Stopped
; 0000 008E // Mode: Normal top=0xFFFF
; 0000 008F // OC1A output: Discon.
; 0000 0090 // OC1B output: Discon.
; 0000 0091 // OC1C output: Discon.
; 0000 0092 // Noise Canceler: Off
; 0000 0093 // Input Capture on Falling Edge
; 0000 0094 // Timer1 Overflow Interrupt: Off
; 0000 0095 // Input Capture Interrupt: Off
; 0000 0096 // Compare A Match Interrupt: Off
; 0000 0097 // Compare B Match Interrupt: Off
; 0000 0098 // Compare C Match Interrupt: Off
; 0000 0099 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 009A TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 009B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 009C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 009D ICR1H=0x00;
	OUT  0x27,R30
; 0000 009E ICR1L=0x00;
	OUT  0x26,R30
; 0000 009F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A0 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A1 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A3 OCR1CH=0x00;
	STS  121,R30
; 0000 00A4 OCR1CL=0x00;
	STS  120,R30
; 0000 00A5 
; 0000 00A6 // Timer/Counter 2 initialization
; 0000 00A7 // Clock source: System Clock
; 0000 00A8 // Clock value: Timer2 Stopped
; 0000 00A9 // Mode: Normal top=0xFF
; 0000 00AA // OC2 output: Disconnected
; 0000 00AB TCCR2=0x00;
	OUT  0x25,R30
; 0000 00AC TCNT2=0x00;
	OUT  0x24,R30
; 0000 00AD OCR2=0x00;
	OUT  0x23,R30
; 0000 00AE 
; 0000 00AF // Timer/Counter 3 initialization
; 0000 00B0 // Clock source: System Clock
; 0000 00B1 // Clock value: Timer3 Stopped
; 0000 00B2 // Mode: Normal top=0xFFFF
; 0000 00B3 // OC3A output: Discon.
; 0000 00B4 // OC3B output: Discon.
; 0000 00B5 // OC3C output: Discon.
; 0000 00B6 // Noise Canceler: Off
; 0000 00B7 // Input Capture on Falling Edge
; 0000 00B8 // Timer3 Overflow Interrupt: Off
; 0000 00B9 // Input Capture Interrupt: Off
; 0000 00BA // Compare A Match Interrupt: Off
; 0000 00BB // Compare B Match Interrupt: Off
; 0000 00BC // Compare C Match Interrupt: Off
; 0000 00BD TCCR3A=0x00;
	STS  139,R30
; 0000 00BE TCCR3B=0x00;
	STS  138,R30
; 0000 00BF TCNT3H=0x00;
	STS  137,R30
; 0000 00C0 TCNT3L=0x00;
	STS  136,R30
; 0000 00C1 ICR3H=0x00;
	STS  129,R30
; 0000 00C2 ICR3L=0x00;
	STS  128,R30
; 0000 00C3 OCR3AH=0x00;
	STS  135,R30
; 0000 00C4 OCR3AL=0x00;
	STS  134,R30
; 0000 00C5 OCR3BH=0x00;
	STS  133,R30
; 0000 00C6 OCR3BL=0x00;
	STS  132,R30
; 0000 00C7 OCR3CH=0x00;
	STS  131,R30
; 0000 00C8 OCR3CL=0x00;
	STS  130,R30
; 0000 00C9 
; 0000 00CA // External Interrupt(s) initialization
; 0000 00CB // INT0: Off
; 0000 00CC // INT1: Off
; 0000 00CD // INT2: Off
; 0000 00CE // INT3: Off
; 0000 00CF // INT4: Off
; 0000 00D0 // INT5: Off
; 0000 00D1 // INT6: On
; 0000 00D2 // INT6 Mode: Any change
; 0000 00D3 // INT7: On
; 0000 00D4 // INT7 Mode: Any change
; 0000 00D5 EICRA=0x00;
	STS  106,R30
; 0000 00D6 EICRB=0x00;
	OUT  0x3A,R30
; 0000 00D7 EIMSK=0xC0;
	LDI  R30,LOW(192)
	OUT  0x39,R30
; 0000 00D8 EIFR=0xC0;
	OUT  0x38,R30
; 0000 00D9 
; 0000 00DA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00DB TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 00DC 
; 0000 00DD ETIMSK=0x00;
	STS  125,R30
; 0000 00DE 
; 0000 00DF // USART0 initialization
; 0000 00E0 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00E1 // USART0 Receiver: On
; 0000 00E2 // USART0 Transmitter: On
; 0000 00E3 // USART0 Mode: Asynchronous
; 0000 00E4 // USART0 Baud Rate: 115200
; 0000 00E5 UCSR0A=0x00;
	OUT  0xB,R30
; 0000 00E6 UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00E7 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 00E8 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 00E9 UBRR0L=0x05;
	LDI  R30,LOW(5)
	OUT  0x9,R30
; 0000 00EA 
; 0000 00EB // USART1 initialization
; 0000 00EC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00ED // USART1 Receiver: On
; 0000 00EE // USART1 Transmitter: On
; 0000 00EF // USART1 Mode: Asynchronous
; 0000 00F0 // USART1 Baud Rate: 115200
; 0000 00F1 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 00F2 UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 00F3 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 00F4 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 00F5 UBRR1L=0x05;
	LDI  R30,LOW(5)
	STS  153,R30
; 0000 00F6 
; 0000 00F7 // Analog Comparator initialization
; 0000 00F8 // Analog Comparator: Off
; 0000 00F9 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00FA ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00FB SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00FC 
; 0000 00FD // ADC initialization
; 0000 00FE // ADC disabled
; 0000 00FF ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0100 
; 0000 0101 // SPI initialization
; 0000 0102 // SPI disabled
; 0000 0103 SPCR=0x00;
	OUT  0xD,R30
; 0000 0104 
; 0000 0105 // TWI initialization
; 0000 0106 // TWI disabled
; 0000 0107 TWCR=0x00;
	STS  116,R30
; 0000 0108 
; 0000 0109 // Global enable interrupts
; 0000 010A #asm("sei")
	sei
; 0000 010B while (1)
_0xD:
; 0000 010C       {
; 0000 010D         delay_ms(200);
	CALL SUBOPT_0x1
; 0000 010E            radi=1;
; 0000 010F            ax12_goto(1, 192, 1023);
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x2
; 0000 0110 
; 0000 0111            while(radi) {
_0x10:
	SBRS R15,0
	RJMP _0x12
; 0000 0112                 if(sensor1){
	SBIS 0x19,0
	RJMP _0x13
; 0000 0113                     ax12_position_status(1);
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
; 0000 0114                     radi=0;
; 0000 0115                     putchar1(positionHigh);
; 0000 0116                     putchar1(positionLow);
; 0000 0117                     putchar1(0x13);
; 0000 0118                     }
; 0000 0119            }
_0x13:
	RJMP _0x10
_0x12:
; 0000 011A 
; 0000 011B            delay_ms(200);
	CALL SUBOPT_0x1
; 0000 011C            radi=1;
; 0000 011D            ax12_goto(1, 831, 1023);
	LDI  R30,LOW(831)
	LDI  R31,HIGH(831)
	CALL SUBOPT_0x2
; 0000 011E 
; 0000 011F          while(radi) {
_0x14:
	SBRS R15,0
	RJMP _0x16
; 0000 0120                 if(sensor1){
	SBIS 0x19,0
	RJMP _0x17
; 0000 0121                     ax12_position_status(1);
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
; 0000 0122                     radi=0;
; 0000 0123                     putchar1(positionHigh);
; 0000 0124                     putchar1(positionLow);
; 0000 0125                     putchar1(0x13);
; 0000 0126                     }
; 0000 0127            }
_0x17:
	RJMP _0x14
_0x16:
; 0000 0128       }
	RJMP _0xD
; 0000 0129 }
_0x18:
	RJMP _0x18
;#include "ax12func.h"
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;
;#define TXC 6
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;unsigned char brzina_servo_H, brzina_servo_L, ugao_servo_H, ugao_servo_L, valLow, valHigh;
;unsigned char sum=0;
;unsigned char checksum=0;
;unsigned char greska;
;unsigned char IdServoGreska;
;char paket1, paket2, paket4, paket6, paket7;
;extern char moving, positionLow, positionHigh;
;
;void prijem_paketa (void)
; 0001 0032 {

	.CSEG
_prijem_paketa:
; 0001 0033     paket1=getchar();
	CALL SUBOPT_0x4
; 0001 0034     paket2=getchar();
; 0001 0035     IdServoGreska=getchar();
; 0001 0036     paket4=getchar();
; 0001 0037     greska=getchar();
; 0001 0038     paket6=getchar();
	STS  _paket6,R30
; 0001 0039 }
	RET
;
;void prijem_paketaMoving(void)
; 0001 003C {
; 0001 003D     paket1=getchar();
; 0001 003E     paket2=getchar();
; 0001 003F     IdServoGreska=getchar();
; 0001 0040     paket4=getchar();
; 0001 0041     greska=getchar();
; 0001 0042     moving=getchar();
; 0001 0043     paket7=getchar();
; 0001 0044 }
;
;void prijem_paketaPosition(void)
; 0001 0047 {
_prijem_paketaPosition:
; 0001 0048     paket1=getchar();
	CALL SUBOPT_0x4
; 0001 0049     paket2=getchar();
; 0001 004A     IdServoGreska=getchar();
; 0001 004B     paket4=getchar();
; 0001 004C     greska=getchar();
; 0001 004D     positionLow=getchar();
	MOV  R4,R30
; 0001 004E 	positionHigh=getchar();
	RCALL _getchar
	MOV  R7,R30
; 0001 004F     paket7=getchar();
	RCALL _getchar
	STS  _paket7,R30
; 0001 0050 }
	RET
;
;void blokiranje_predaje(void)                        //funkcija koja blokira predaju u trenutku kada
; 0001 0053 {                                                      // posaljemo ceo paket
_blokiranje_predaje:
; 0001 0054     while ( !( UCSR0A & (1<<TXC)) )   ;    //kada se posalje ceo paket onda se bit 6 registra UCSRA
_0x20003:
	SBIS 0xB,6
	RJMP _0x20003
; 0001 0055     UCSR0B.3=0;                            // setuje na 1, potom se UCSRB.3 stavlja na 0, a to je bit koji
	CBI  0xA,3
; 0001 0056     UCSR0A.6=1;                            //iskljuci TxD i taj pin pinovo postaje PD1, a on je inicijalizovan
	SBI  0xB,6
; 0001 0057 }
	RET
;
;void oslobadjanje_predaje(void)                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
; 0001 005A {
_oslobadjanje_predaje:
; 0001 005B     UCSR0B.3=1;                            //TxD se opet ukljucuje tako sto se UCSRB.3 bit setuje
	SBI  0xA,3
; 0001 005C }
	RET
;                                                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
;void oslobadjanje_prijema(void)
; 0001 005F {
_oslobadjanje_prijema:
; 0001 0060     UCSR0B.4=1;                         // bit koji kontrolise oslobadjanje i blokiranje prijema
	SBI  0xA,4
; 0001 0061 }
	RET
;
;void blokiranje_prijema(void)
; 0001 0064 {
_blokiranje_prijema:
; 0001 0065     UCSR0B.4=0;
	CBI  0xA,4
; 0001 0066 }
	RET
;
;/*********************AX12 funkcije*********************/
;void ax12_goto(int ID, short pozicija1,short brzina1)
; 0001 006A {
_ax12_goto:
; 0001 006B     ugao_servo_H=(char)(pozicija1>>8);
;	ID -> Y+4
;	pozicija1 -> Y+2
;	brzina1 -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ASRW8
	MOV  R8,R30
; 0001 006C     ugao_servo_L=(char)(pozicija1&0x00FF);
	LDD  R30,Y+2
	MOV  R11,R30
; 0001 006D 
; 0001 006E     brzina_servo_H=(char)(brzina1>>8);
	LD   R30,Y
	LDD  R31,Y+1
	CALL __ASRW8
	MOV  R6,R30
; 0001 006F     brzina_servo_L=(char)(brzina1&0x00FF);
	LD   R30,Y
	MOV  R9,R30
; 0001 0070 
; 0001 0071     sum=0x28 + ID + brzina_servo_H + brzina_servo_L + ugao_servo_H + ugao_servo_L;
	LDD  R30,Y+4
	SUBI R30,-LOW(40)
	ADD  R30,R6
	ADD  R30,R9
	ADD  R30,R8
	ADD  R30,R11
	CALL SUBOPT_0x5
; 0001 0072     checksum=~sum;
; 0001 0073 
; 0001 0074     blokiranje_prijema();
; 0001 0075     oslobadjanje_predaje();
; 0001 0076 
; 0001 0077     putchar(0xff);
; 0001 0078     putchar(0xff);
; 0001 0079     putchar(ID);
	LDD  R30,Y+4
	ST   -Y,R30
	RCALL _putchar
; 0001 007A     putchar(0x07);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _putchar
; 0001 007B     putchar(0x03);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _putchar
; 0001 007C     putchar(0x1e);
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _putchar
; 0001 007D     putchar(ugao_servo_L);
	ST   -Y,R11
	RCALL _putchar
; 0001 007E     putchar(ugao_servo_H);
	ST   -Y,R8
	RCALL _putchar
; 0001 007F     putchar(brzina_servo_L);
	ST   -Y,R9
	RCALL _putchar
; 0001 0080     putchar(brzina_servo_H);
	ST   -Y,R6
	CALL SUBOPT_0x6
; 0001 0081     putchar(checksum);
; 0001 0082 
; 0001 0083     blokiranje_predaje();
; 0001 0084     oslobadjanje_prijema();
; 0001 0085 
; 0001 0086     prijem_paketa();
	RCALL _prijem_paketa
; 0001 0087 
; 0001 0088     oslobadjanje_predaje();
	RCALL _oslobadjanje_predaje
; 0001 0089 }
	ADIW R28,6
	RET
;
;void ax12_moving_status(int ID) //slanje poruke za dobijanja stanja moving
; 0001 008C {
; 0001 008D     sum = ID+0x04+0x02+0x2e+0x01;//suma iinfo=2xStart+ID+lenght+iw+add
;	ID -> Y+0
; 0001 008E     checksum=~sum;
; 0001 008F 
; 0001 0090     blokiranje_prijema();
; 0001 0091     oslobadjanje_predaje();
; 0001 0092 
; 0001 0093     putchar(0xff);
; 0001 0094     putchar(0xff);
; 0001 0095     putchar(ID);
; 0001 0096     putchar(0x04);	//LENGTH
; 0001 0097     putchar(0x02);	//INSTRUCTION READ
; 0001 0098     putchar(0x2e);	//ADRESS
; 0001 0099     putchar(0x01);	//LENGTH READ
; 0001 009A     putchar(checksum);
; 0001 009B 
; 0001 009C     blokiranje_predaje();
; 0001 009D     oslobadjanje_prijema();
; 0001 009E 
; 0001 009F     prijem_paketaMoving();
; 0001 00A0 
; 0001 00A1     oslobadjanje_predaje();
; 0001 00A2 }
;
;void ax12_position_status(int ID) //slanje poruke za dobijanja pozicije
; 0001 00A5 {
_ax12_position_status:
; 0001 00A6     sum = ID+0x04+0x02+0x24+0x02;//suma iinfo=2xStart+ID+lenght+iw+add
;	ID -> Y+0
	LD   R30,Y
	SUBI R30,-LOW(44)
	CALL SUBOPT_0x5
; 0001 00A7     checksum=~sum;
; 0001 00A8 
; 0001 00A9     blokiranje_prijema();
; 0001 00AA     oslobadjanje_predaje();
; 0001 00AB 
; 0001 00AC     putchar(0xff);
; 0001 00AD     putchar(0xff);
; 0001 00AE     putchar(ID);
	LD   R30,Y
	ST   -Y,R30
	RCALL _putchar
; 0001 00AF     putchar(0x04); 	//LENGTH
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _putchar
; 0001 00B0     putchar(0x02);	//INSTRUCTION READ
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _putchar
; 0001 00B1     putchar(0x24);	//ADRESS
	LDI  R30,LOW(36)
	ST   -Y,R30
	RCALL _putchar
; 0001 00B2     putchar(0x02);	//LENGTH READ
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL SUBOPT_0x6
; 0001 00B3     putchar(checksum);
; 0001 00B4 
; 0001 00B5     blokiranje_predaje();
; 0001 00B6     oslobadjanje_prijema();
; 0001 00B7 
; 0001 00B8     prijem_paketaPosition();
	RCALL _prijem_paketaPosition
; 0001 00B9 
; 0001 00BA     oslobadjanje_predaje();
	RCALL _oslobadjanje_predaje
; 0001 00BB }
	ADIW R28,2
	RET
;void ax12_alarm_shutdown(int ID)
; 0001 00BD {
; 0001 00BE     sum=ID+0x04+0x03+0x12+0x24;
;	ID -> Y+0
; 0001 00BF     checksum=~sum;
; 0001 00C0 
; 0001 00C1     blokiranje_prijema();
; 0001 00C2     oslobadjanje_predaje();
; 0001 00C3 
; 0001 00C4     putchar(0xff);  //START
; 0001 00C5     putchar(0xff);  //START
; 0001 00C6     putchar(ID);  //ID
; 0001 00C7     putchar(0x04);  //LENGTH
; 0001 00C8     putchar(0x03);  ///WRITE
; 0001 00C9     putchar(0x12);  //ADRESS
; 0001 00CA     putchar(0x24);  //VALUE
; 0001 00CB 	putchar(checksum); //CHECKSUM
; 0001 00CC }
;void ax12_torque_enable(int ID)	//ukljucuje moment
; 0001 00CE {
; 0001 00CF 
; 0001 00D0     sum=0x01+0x05+0x03+0x18+0x01+0x00;
;	ID -> Y+0
; 0001 00D1     checksum=~sum;
; 0001 00D2 
; 0001 00D3     blokiranje_prijema();
; 0001 00D4     oslobadjanje_predaje();
; 0001 00D5 
; 0001 00D6     putchar(0xff);  //START
; 0001 00D7     putchar(0xff);  //START
; 0001 00D8     putchar(ID);    //ID
; 0001 00D9     putchar(0x05);  //LENGTH
; 0001 00DA     putchar(0x03);  ///WRITE
; 0001 00DB     putchar(0x18);  //ADRESS
; 0001 00DC     putchar(0x01);  //VALUE
; 0001 00DD     putchar(0x00);  //VALUE
; 0001 00DE     putchar(checksum); //CHECKSUM
; 0001 00DF 
; 0001 00E0 	blokiranje_predaje();
; 0001 00E1     oslobadjanje_prijema();
; 0001 00E2 
; 0001 00E3     prijem_paketa();
; 0001 00E4 
; 0001 00E5     oslobadjanje_predaje();
; 0001 00E6 }
;void ax12_torque_limit(int ID, int value) //podesavanje maksimalnog momenta
; 0001 00E8 {
; 0001 00E9 	valHigh=(char)(value>>8);
;	ID -> Y+2
;	value -> Y+0
; 0001 00EA     valLow=(char)(value&0x00FF);
; 0001 00EB 
; 0001 00EC     sum=ID+0x05+0x03+0x22+valLow+valHigh;
; 0001 00ED     checksum=~sum;
; 0001 00EE 
; 0001 00EF 	blokiranje_prijema();
; 0001 00F0     oslobadjanje_predaje();
; 0001 00F1 
; 0001 00F2     putchar(0xff);  //START
; 0001 00F3     putchar(0xff);  //START
; 0001 00F4     putchar(ID);  	//ID
; 0001 00F5     putchar(0x05);  //LENGTH
; 0001 00F6     putchar(0x03);  ///WRITE
; 0001 00F7     putchar(0x22);  //ADRESS
; 0001 00F8     putchar(valLow);  //VALUE
; 0001 00F9     putchar(valHigh);  //VALUE
; 0001 00FA     putchar(checksum);
; 0001 00FB 
; 0001 00FC 	blokiranje_predaje();
; 0001 00FD     oslobadjanje_prijema();
; 0001 00FE 
; 0001 00FF     prijem_paketa();
; 0001 0100 
; 0001 0101     oslobadjanje_predaje();
; 0001 0102 
; 0001 0103 
; 0001 0104 }
;void ax12_id_set(int ID)	//podesavanje IDa servoa
; 0001 0106 {
; 0001 0107      char sum, checksum;
; 0001 0108      sum=0xfe+0x04+0x03+0x03+ID;
;	ID -> Y+2
;	sum -> R17
;	checksum -> R16
; 0001 0109      checksum=~sum;
; 0001 010A 
; 0001 010B      putchar(0xff);  //START
; 0001 010C      putchar(0xff);  //START
; 0001 010D      putchar(0xfe);  //ID
; 0001 010E      putchar(0x04);  //LENGTH
; 0001 010F      putchar(0x03);  ///WRITE
; 0001 0110      putchar(0x03);  //ADRESS
; 0001 0111      putchar(ID);  //VALUE
; 0001 0112      putchar(checksum); //CHECKSUM
; 0001 0113 
; 0001 0114 	blokiranje_predaje();
; 0001 0115     oslobadjanje_prijema();
; 0001 0116 
; 0001 0117     prijem_paketa();
; 0001 0118 
; 0001 0119     oslobadjanje_predaje();
; 0001 011A }
;void ax12_reset(int ID) //reset na fabricko podesavanje
; 0001 011C {
; 0001 011D     sum=ID+0x02+0x06;
;	ID -> Y+0
; 0001 011E     checksum=~sum;
; 0001 011F 
; 0001 0120 
; 0001 0121     blokiranje_prijema();
; 0001 0122     oslobadjanje_predaje();
; 0001 0123 
; 0001 0124     putchar(0xff);  //START
; 0001 0125     putchar(0xff);  //START
; 0001 0126     putchar(ID);  	//ID
; 0001 0127     putchar(0x02);  //LENGTH
; 0001 0128     putchar(0x06);  //reset
; 0001 0129     putchar(checksum); //CHECKSUM
; 0001 012A 
; 0001 012B }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_checksum:
	.BYTE 0x1
_greska:
	.BYTE 0x1
_IdServoGreska:
	.BYTE 0x1
_paket1:
	.BYTE 0x1
_paket2:
	.BYTE 0x1
_paket4:
	.BYTE 0x1
_paket6:
	.BYTE 0x1
_paket7:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SET
	BLD  R15,0
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ax12_goto

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	CALL _ax12_position_status
	CLT
	BLD  R15,0
	ST   -Y,R7
	CALL _putchar1
	ST   -Y,R4
	CALL _putchar1
	LDI  R30,LOW(19)
	ST   -Y,R30
	JMP  _putchar1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	CALL _getchar
	STS  _paket1,R30
	CALL _getchar
	STS  _paket2,R30
	CALL _getchar
	STS  _IdServoGreska,R30
	CALL _getchar
	STS  _paket4,R30
	CALL _getchar
	STS  _greska,R30
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	MOV  R12,R30
	MOV  R30,R12
	COM  R30
	STS  _checksum,R30
	CALL _blokiranje_prijema
	CALL _oslobadjanje_predaje
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(255)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	CALL _putchar
	LDS  R30,_checksum
	ST   -Y,R30
	CALL _putchar
	CALL _blokiranje_predaje
	JMP  _oslobadjanje_prijema


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

;END OF CODE MARKER
__END_OF_CODE:
