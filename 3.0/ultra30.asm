BAUD600     = $05CC
BAUD700     = $04F7
BAUD800     = $0458 
BAUD900     = $03DB
BAUD990     = $0381
BAUD1150    = $0303
BAUD1400    = $0278
BAUD2000    = $01B8
PCRSR       = $CB
    ORG $2100
    ICL  'BASE/SYS_EQUATES.M65'
    ICL 'KEM2.ASM'
    ICL 'MEM.ASM'
    ICL 'HEXASCII.ASM'
DLS
:3  .BY $70
    .BY $46
    .WO SHOW
    .BY $70
:22  .BY $02
    .BY $41
    .WO DLS
;************************************************
; DEFINICION DEL DISPLAY
; PARA DIRECTORIO
;************************************************
?DIR
:3	.BY $70
    .BY $46
	.WO ???DIR
	.BY $70
:9    .BY $02
	.BY $41
	.WO ?DIR
SHOW
    .SB " "
    .SB +128,"dogdark"
    .SB "  softwares "
    .SB +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
    .SB "| DOGCOPY ULTRA V 3.0 BY  DOGDARK 2024 |"
    .SB +32,"ARRRRRRRRRRRRRRRRRWRRRRRRRRRRRRRRRRRRRRD"
    .SB "|MEMORIA          |             "
MUESTROMEMORIA
    .SB "*******|"
    .SB "|BANCOS           |                  "
MUESTROBANCOS
    .SB "**|"
    .SB "|SISTEMA A GRABAR |              "
MUESTROSISTEMA
    .SB "NHP600|"
    .SB "|VELOCIDAD BAUDIO |                "
MUESTROVELOCIDAD
    .SB "0600|"
    .SB "|PORTB EN USO     |                 "
MUESTROPORTB
    .SB "***|"
    .SB "|BYTES POR BLOQUE |                 "
MUESTROBYTESPORBLOQUE
    .SB "128|"
    .SB "|BYTES LEIDOS     |             "
MUESTROBYTESLEIDOS
    .SB "*******|"
    .SB "|BLOQUES A GRABAR |                "
MUESTROBLOQUESAGRABAR
    .SB "****|"
    .SB "|TITULO 01        |"
TITULO01
    .SB "********************|"
    .SB "|TITULO 02        |"
TITULO02
    .SB "********************|"
    .SB     "|FUENTE           |"
FUENTE  
    .SB "********************|"
    .SB +32,"ZRRRRRRRRRRRRRRRRRXRRRRRRRRRRRRRRRRRRRRC"
MUESTRODATA
    .SB "DATA************************************"  ;40
    .SB "****************************************"  ;80
    .SB "****************************************"  ;120
    .SB "****************************************"  ;160
    .SB "****************************************"  ;200
    .SB "****************************************"  ;240
    .SB "*************************************FIN"  ;280
;************************************************
;VALORES PARA PANTALLA DIRECTORIO
;************************************************
???DIR
	.SB "     DIRECTORIO     "
??DIR
:10	.SB "                                        "
SISTEMA
    .BY 0
RY
    .BY 0,0,0
?FUENTE
	.BYTE '                    '
ALL
	.BYTE 'D:*.*',$9B
NHP600
    .SB "NHP600"
NHP700
    .SB "NHP700"
NHP800
    .SB "NHP800"
NHP900
    .SB "NHP900"
NHPSTAC
    .SB "  STAC"
NHPULTRA
    .SB " ULTRA"
NHPSUPER
    .SB " SUPER"
NHPEXTRA
    .SB " EXTRA"
VEL600
    .SB "0600"
VEL700
    .SB "0700"
VEL800
    .SB "0800"
VEL900
    .SB "0900"
VELSTAC
    .SB "0990"
VELULTRA
    .SB "1150"
VELSUPER
    .SB "1400"
VELEXTRA
    .SB "2000"
BYTESPORBLOQUE
    .BY 0
BYTE128
    .SB "128"
BYTE255
    .SB "255"
;************************************************
;FUNCIONES DEL SISTEMA
;************************************************
CALCULOMEMORIA
    JSR LIMPIOVAL
    LDA MEMORIA
    STA VAL
    LDA MEMORIA+1
    STA VAL+1
    LDA MEMORIA+2
    STA VAL+2
    JSR BIN2BCD
    LDY #7
    LDX #6
CALCULOMEMORIA1
    LDA RESATASCII,Y
    STA MUESTROMEMORIA,X
    DEY
    DEX
    BPL CALCULOMEMORIA1
    RTS
CUALPORTB
    JSR LIMPIOVAL
    LDA PORTB
    STA VAL
    JSR BIN2BCD
    LDY #7
    LDX #2
CUALPORTB1
    LDA RESATASCII,Y
    STA MUESTROPORTB,X
    DEY
    DEX
    BPL CUALPORTB1
    RTS
CUANTOSBANCOS
    JSR LIMPIOVAL
    LDA BANKOS
    STA VAL
    JSR BIN2BCD
    LDY #7
    LDX #1
CUANTOSBANCOS1
    LDA RESATASCII,Y
    STA MUESTROBANCOS,X
    DEY
    DEX
    BPL CUANTOSBANCOS1
    RTS
LIMPIOFUENTE
    LDX #19
    LDA #$00
LIMPIOFUENTE1
    STA FUENTE,X
    DEX
    BPL LIMPIOFUENTE1
    RTS
LIMPIODATA
    LDA #$00
    LDX #39
LIMPIODATA1
    STA MUESTRODATA,X
    STA MUESTRODATA+40,X
    STA MUESTRODATA+80,X
    STA MUESTRODATA+120,X
    STA MUESTRODATA+160,X
    STA MUESTRODATA+200,X
    STA MUESTRODATA+240,X
    DEX
    BPL LIMPIODATA1
    RTS
LIMPIOBYTESCARGADOS
    LDA #$10
    LDX #6
LIMPIOBYTESCARGADOS1
    STA MUESTROBYTESLEIDOS,X
    DEX
    BPL LIMPIOBYTESCARGADOS1
    RTS
LIMPIOBLOQUESCARGADOS
    LDA #$10
    LDX #3
LIMPIOBLOQUESCARGADOS1
    STA MUESTROBLOQUESAGRABAR,X
    DEX
    BPL LIMPIOBLOQUESCARGADOS1
    RTS
RESETER
    JSR CALCULOMEMORIA
    JSR CUALPORTB
    JSR CUANTOSBANCOS
    LDX #19
    LDA #$00
RESETER1
    STA TITULO01,X
    STA TITULO02,X
    DEX
    BPL RESETER1
    JSR LIMPIOFUENTE
    JSR LIMPIODATA
    JSR LIMPIOBYTESCARGADOS
    JSR LIMPIOBLOQUESCARGADOS
    LDA #63
    STA TITULO01
    STA TITULO02
    STA FUENTE
    RTS
;************************************************
;FUNCION QUE NOS PERMITE PODER CONVERTIR UN BYTE
;EN ATASCII, USADO PARA INGRESO DE TITULOS Y
;FUENTE, NO TIENE LIMITACIONES MAYORES EN LAS
;PULSACIONES DEL TECLADO
;************************************************
ASCINT
	CMP #32
	BCC ADD64
	CMP #96
	BCC SUB32
	CMP #128
	BCC REMAIN
	CMP #160
	BCC ADD64
	CMP #224
	BCC SUB32
	BCS REMAIN
ADD64
	CLC
	ADC #64
	BCC REMAIN
SUB32
	SEC
	SBC #32
REMAIN
	RTS
;************************************************
;GENERA UNA LIMPIEZA TOTAL DEL DISPLAY DEL
;DIRECTORIO
;************************************************
CLS
	LDX # <??DIR
	LDY # >??DIR
	STX PCRSR
	STY PCRSR+1
	LDY #$00
	LDX #$00
?CLS
	LDA #$00
	STA (PCRSR),Y
	INY
	BNE ??CLS
	INX
	INC PCRSR+1
??CLS
	CPY #104	;$68
	BNE ?CLS
	CPX #$01
	BNE ?CLS
	RTS
;************************************************
;FUNCION QUE ABRE PERIFERICOS
;************************************************
OPEN
	LDX #$10
	LDA #$03
	STA $0342,X
	LDA # <?FUENTE
	STA $0344,X
	LDA # >?FUENTE
	STA $0345,X
	LDA #$04
	STA $034A,X
	LDA #$80
	STA $034B,X
	JSR $E456
	DEY
	BNE DIR
	RTS
;************************************************
;FUNCION QUE CIERRA PERIFERICOS
;************************************************
CLOSE
	LDX #$10
	LDA #$0C
	STA $0342,X
	JMP $E456
;************************************************
;MUESTRA EL DIRECTORIO EN PANTALLA
;************************************************
DIR
	JSR CLOSE
	JSR CLS
	LDX # <?DIR
	LDY # >?DIR
	STX $0230
	STY $0231
	LDX # <??DIR
	LDY # >??DIR
	STX PCRSR
	STY PCRSR+1
	
;	
	LDX #$10
	LDA #$03
	STA $0342,X
	LDA # <ALL
	STA $0344,X
	LDA # >ALL
	STA $0345,X
	LDA #$06
	STA $034A,X
	LDA #$00
	STA $034B,X
	JSR $E456
	LDA #$07
	STA $0342,X
	LDA #$00
	STA $0348,X
	STA $0349,X
	STA RY
	STA RY+1
LEDIR
	JSR $E456
	BMI ?EXIT
	CMP #155
	BEQ EXIT
	JSR ASCINT
	LDY RY
	STA (PCRSR),Y
	INC RY
	BNE F0
	INC PCRSR+1
	INC RY+1
F0
	LDY RY+1
	CPY #$01
	BNE F1
	LDY RY
	CPY #104	;$68
	BCC F1
	JSR PAUSE
	INC RY
F1
	JMP LEDIR
EXIT
;	INC RY
	INC RY
	INC RY
	JMP LEDIR
?EXIT
	JSR CLOSE
	JSR PAUSE
	JSR CLS
	PLA
	PLA
	JMP START
PAUSE
	LDA 53279
	CMP #$06
	BNE PAUSE
	JSR CLS
	LDA #$00
	STA RY
	STA RY+1
	LDA # <??DIR
	STA PCRSR
	LDA # >??DIR
	STA PCRSR+1
	LDX #$10
	RTS
;************************************************
;RUTINA QUE NOS PERMMITE PODER INGRESAR INFORMA-
;CION A UN CAMPO ESPECIFICO YA ANTES DECLARADO
;MOSTRANDO UN CURSOR EN FORMA PARPADEANTE
;************************************************
;
;************************************************
;CURSOR PARPADEANTE
;************************************************
FLSH
	LDY RY
	LDA (PCRSR),Y
	EOR #63
	STA (PCRSR),Y
	LDA #$10
	STA $021A
	RTS
;************************************************
;ABRE PERIFERICO TECLADO
;************************************************
OPENK
	LDA #255
	STA 764
	LDX #$10
	LDA #$03
	STA $0342,X
	STA $0345,X
	LDA #$26
	STA $0344,X
	LDA #$04
	STA $034A,X
	JSR $E456
	LDA #$07
	STA $0342,X
	LDA #$00
	STA $0348,X
	STA $0349,X
	STA RY
	RTS
;************************************************
;RUTINA QUE LEE LO TECLEADO
;************************************************
RUTLEE
	LDX # <FLSH
	LDY # >FLSH
	LDA #$10
	STX $0228
	STY $0229
	STA $021A
	JSR OPENK
GETEC
	JSR $E456
	CMP #$7E
	BNE C0
	LDY RY
	BEQ GETEC
	LDA #$00
	STA (PCRSR),Y
	LDA #63		;$3F
	DEY
	STA (PCRSR),Y
	DEC RY
	JMP GETEC
C0
	CMP #155	;$9B
	BEQ C2
	JSR ASCINT
	LDY RY
	STA (PCRSR),Y
	CPY #20		;#14
	BEQ C1
	INC RY
C1
	JMP GETEC
C2
	JSR CLOSE
	LDA #$00
	STA $021A
	LDY RY
	STA (PCRSR),Y
	RTS






;************************************************
;MUESTRA EL DIRECTORIO EN PANTALLA
;************************************************
;************************************************
;DISPLAY DE INICIO DEL PROGRAMA Y FUNCIONALIDAD
;DIRECTA A TODAS SUS FUNCIONES
;************************************************
DOS
	JMP ($0C)
@START
	JSR DOS
START
    LDA #<DLS
    STA $230
    LDA #>DLS
    STA $231
    LDA #$80
    STA 710
    STA 712
    JSR RESETER

//***********************************************
// Vamos a poner una interrupcion VBI aqui
//***********************************************
	LDY #<VBI
	LDX #>VBI
	LDA #$07	; Diferida
	JSR SETVBV	;Setea

;************************************************
;INGRESAMOS EL TITULO 01
;************************************************
	LDX # <TITULO01
	LDY # >TITULO01
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE

;************************************************
;INGRESAMOS EL TITULO 01
;************************************************
	LDX # <TITULO02
	LDY # >TITULO02
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE

;************************************************
;INGRESAMOS EL TITULO 01
;************************************************
	LDX # <FUENTE
	LDY # >FUENTE
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
	LDY RY
	CPY #1
	BEQ OPENPER
	LDY #19
CONV
	LDA FUENTE,Y
	BEQ ?REMAIN
	AND #$7F
	CMP #64
	BCC ADD32
	CMP #96
	BCC SUB64
	BCS ?REMAIN
ADD32
	CLC
	ADC #32
	BCC OKLET
SUB64
	SEC
	SBC #64
?REMAIN
	LDA #$9B
OKLET
	STA ?FUENTE,Y
	DEY
	BPL CONV
OPENPER
    JSR OPEN
    LDA #$00
    STA 710





















    JMP *
INICIO
    JSR KEM			;COPIO LA ROM A LA RAM
    JSR MEM
	LDX # <@START
	LDY # >@START
	LDA #$03
	STX $02
	STY $03
	STA $09
	LDY #$FF
	STY $08
	INY   
	STY $0244
	LDX #0
	STX SISTEMA		;SETEO SISTEMA
    JMP START

//Ponemos la rutina VBI aqui al final
.proc VBI
FIN_SISTEMA=$07	//Desde 0 a 7
FIN_BLOQUES=$01 //desde 0 a 2 
	LDA CONSOL
	CMP CONSOL_ANTERIOR
	BEQ FIN
	STA CONSOL_ANTERIOR
	CMP #$05
	BEQ ESSELECT
    CMP #$06
    BEQ ESSTART
	CMP #$03 	//OPTION??
	BNE FIN		//NO!!
	LDX SISTEMA
	CPX #FIN_SISTEMA
	BNE NO_FIN_SISTEMA
	LDX #$FF
NO_FIN_SISTEMA
	INX
	STX SISTEMA
	LDA #<NHP600
	LDY #>NHP600
	CPX #$00
	BEQ SIGUE_VEO
	LDA #<NHP700
	LDY #>NHP700
	CPX #$01
	BEQ SIGUE_VEO
	LDA #<NHP800
	LDY #>NHP800
	CPX #$02
	BEQ SIGUE_VEO
	LDA #<NHP900
	LDY #>NHP900
	CPX #$03
	BEQ SIGUE_VEO
	LDA #<NHPSTAC
	LDY #>NHPSTAC
    CPX #$04
	BEQ SIGUE_VEO
	LDA #<NHPULTRA
	LDY #>NHPULTRA
    CPX #$05
	BEQ SIGUE_VEO
	LDA #<NHPSUPER
	LDY #>NHPSUPER
    CPX #$06
	BEQ SIGUE_VEO
	LDA #<NHPEXTRA
	LDY #>NHPEXTRA
SIGUE_VEO
	STA LOOP_COPIA+1
	STY LOOP_COPIA+2
	LDY #$05
LOOP_COPIA
	LDA NHP600,Y
	STA MUESTROSISTEMA,Y
    DEY
	BPL LOOP_COPIA
    JMP SIGUE_VEO1
FIN
	JMP $E462
ESSTART
    JMP START
CONSOL_ANTERIOR
	.BY $00
ESSELECT
    LDX BYTESPORBLOQUE
	CPX #FIN_BLOQUES
	BNE NO_FIN_BLOQUES
	LDX #$FF
NO_FIN_BLOQUES
    INX
	STX BYTESPORBLOQUE
    LDA #<BYTE128
	LDY #>BYTE128
	CPX #$00
	BEQ SIGUE_VEO_BLOQUES
    LDA #<BYTE255
	LDY #>BYTE255
SIGUE_VEO_BLOQUES
    STA LOOP_COPIA_BLOQUES+1
    STY LOOP_COPIA_BLOQUES+2
    LDY #2
LOOP_COPIA_BLOQUES
    LDA BYTE128,Y
    STA MUESTROBYTESPORBLOQUE,Y
    DEY
    BPL LOOP_COPIA_BLOQUES
    JMP FIN
;CAMBIAMOS BYTE POR BLOQUES
	JMP START
SIGUE_VEO1
    LDA #<VEL600
    LDY #>VEL600
    CPX #0
    BEQ SIGUE_VEO2
    LDA #<VEL700
    LDY #>VEL700
    CPX #1
    BEQ SIGUE_VEO2
    LDA #<VEL800
    LDY #>VEL800
    CPX #2
    BEQ SIGUE_VEO2
    LDA #<VEL900
    LDY #>VEL900
    CPX #3
    BEQ SIGUE_VEO2
    LDA #<VELSTAC
    LDY #>VELSTAC
    CPX #4
    BEQ SIGUE_VEO2
    LDA #<VELULTRA
    LDY #>VELULTRA
    CPX #5
    BEQ SIGUE_VEO2
    LDA #<VELSUPER
    LDY #>VELSUPER
    CPX #6
    BEQ SIGUE_VEO2
    LDA #<VELEXTRA
    LDY #>VELEXTRA
SIGUE_VEO2
    STA LOOP_COPIA2+1
    STY LOOP_COPIA2+2
    LDY #3
LOOP_COPIA2
    LDA VEL600,Y
    STA MUESTROVELOCIDAD,Y
    DEY
    BPL LOOP_COPIA2
    JMP FIN
.endp
    RUN INICIO