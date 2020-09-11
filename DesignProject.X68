*-----------------------------------------------------------
* Title      : ECE441 Design Project Part 1
* Written by : Guojun Yang, Annabella Chong
* Date       : APR 04 2019, edited 4-04-19
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:
    MOVEM.L D0-D7/A0-A7,STACK
    LEA     STACK,A7
    MOVEM.L D0-D7/A0-A6,-(A7)
    
    MOVE.L  #BERR,$8 
    MOVE.L  #ADDER,$C
    MOVE.L  #ILLINS,$10
    MOVE.L  #DIV0, $14
    MOVE.L  #CHKER,$18
    MOVE.L  #PRIVER,$20
    MOVE.L  #LINEA,$28
    MOVE.L  #LINEF,$2C
 
    MOVE.L  #WHITE, D1
    MOVE.L  #FONT,D2
    MOVE.B  #21, D0
    TRAP    #15      
    LEA MSG_WELCOME,A5
    LEA MSG_WELCOME_ED,A6
    BSR PRINT
RESET:
    LEA HISTORY_BUFF,A2
    MOVE.B #0,(A2)
    LEA STACK,A7        ;SET(RESET) A7
MAIN:    
    LEA MSG_PROM, A5
    LEA MSG_PROM_ED, A6
    BSR PRINT_C
    BSR INPUT
    BSR INTERPRETER
    BRA MAIN

*------------------SUBROUTINE------------*    
;Standard I/O
;Print WITH carrige return and line feed
;Print string stored within address range marked by A5 and A6
PRINT:
    MOVEM.L D0-D1/A1,-(A7)
    MOVEA.L A5,A1           
    SUBA.L A5,A6            
    MOVE.L A6,D1            
    MOVE.L #0,D0            
    TRAP #15
    MOVEM.L (A7)+,D0-D1/A1
    RTS
;Print WITHOUT carrige return and line feed
;Print string stored within address range marked by A5 and A6
PRINT_C:            
    MOVEM.L D0-D1/A1,-(A7)
    MOVEA.L A5,A1           
    SUBA.L A5,A6            
    MOVE.L A6,D1            
    MOVE.L #1,D0
    TRAP #15
    MOVEM.L (A7)+,D0-D1/A1
    RTS
;Store input string to buffer
;Marked
INPUT:
    MOVEM.L D0-D1/A1,-(A7)
    LEA INPUT_BUFF,A1  ;EVERY WORDS COMES FROM KEYBOARD WILL BE STORED AT BUFF AREA
    MOVE.L #2,D0
    TRAP #15
    ADDA.W D1,A1
    MOVE.B #NULL,(A1)
    CMPI.B #0,D1
    MOVEM.L (A7)+,D0-D1/A1
    RTS

;Determine which command been input and branch accordingly 
INTERPRETER:    
    ;Check if input buffer is empty
    LEA INPUT_BUFF,A1
    CMPI.B #NULL,(A1)
    BEQ INTERPRETER_END
 
    ;Check if it's HELP command
    LEA MSG_CMD_HELP,A5
    LEA MSG_CMD_HELP_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP   
    
    ;Block search
    LEA MSG_CMD_BSCH,A5
    LEA MSG_CMD_BSCH_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ BSCH

    ;Sort by word
    LEA MSG_CMD_SORTW,A5
    LEA MSG_CMD_SORTW_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ SORTW

    ;Addition
    LEA MSG_CMD_ADD,A5
    LEA MSG_CMD_ADD_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ ADD

    ;And
    LEA MSG_CMD_AND,A5
    LEA MSG_CMD_AND_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ AND

    ;Or
    LEA MSG_CMD_OR,A5
    LEA MSG_CMD_OR_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ OR
        
    ;Memory sort by word
    LEA MSG_CMD_SORTW,A5
    LEA MSG_CMD_SORTW_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ SORTW
    
    ;MM 
    LEA MSG_CMD_MM,A5
    LEA MSG_CMD_MM_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ MM
    
    ;MDSP 
    LEA MSG_CMD_MDSP,A5
    LEA MSG_CMD_MDSP_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ MDSP

    ;MS
    LEA MSG_CMD_MS,A5
    LEA MSG_CMD_MS_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ MS
    
    ;BF
    LEA MSG_CMD_BF,A5
    LEA MSG_CMD_BF_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ BF

    ;BMOV
    LEA MSG_CMD_BMOV,A5
    LEA MSG_CMD_BMOV_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ BMOV

    ;BTST
    LEA MSG_CMD_BTST,A5
    LEA MSG_CMD_BTST_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ BTST
    
    ;GO
    LEA MSG_CMD_GO,A5
    LEA MSG_CMD_GO_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ GO
    
    ;DF
    LEA MSG_CMD_DF,A5
    LEA MSG_CMD_DF_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ DF
    
    ;COLOR
    LEA MSG_CMD_COLOR,A5
    LEA MSG_CMD_COLOR_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ COLOR
    
    ;HEX2DEC
    LEA MSG_CMD_HEX2DEC,A5
    LEA MSG_CMD_HEX2DEC_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HEX2DEC

    ;EXIT PROGRAM
    LEA MSG_CMD_EXITP,A5
    LEA MSG_CMD_EXITP_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ EXITP

    ;Recall Last command
    ;Courtesy of your TA make your debug slightly less painful
    LEA MSG_CMD_RC,A5
    LEA MSG_CMD_RC_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ RC

    ;Invalid input
    BSR SYNTAX_ER
INTERPRETER_END:    
    RTS

;Compare strong from A1 to NULL or SPACE 
;With string from A5 to A6
COMPARE:                    
    CMPI.B #SPACE,(A1)      ;Check if end of command(SPACE)
    BEQ COMPARE_CHK_END
    CMPI.B #NULL, (A1)
    BEQ COMPARE_CHK_END     ;Check if end of command(NULL)
    CMPI.B #DOT, (A1)
    BEQ COMPARE_CHK_END
    CMPA.L A5,A6
    BEQ COMPARE_END
    CMP.B (A1)+,(A5)+       
    BNE COMPARE_END         ;If content not the same end
    BRA COMPARE
COMPARE_CHK_END:
    CMPA.L A5,A6
COMPARE_END:
    RTS

; Convert HEX num (D0) to ASCII, length in D2 (Bytes) before use
; ASCII string buffer should start from A6
HEX2ASCII:
    MOVEM.L D1/D3, -(A7)
    ROL.L #2,D2
    ADD.L D2, A6
    MOVE.L D2,D3
HEX2ASCII_LOOP:
    MOVE.L D0, D1
    ANDI.L #$0000000F,D1	;Get last digit (4 bits)
    CMPI.B #10,D1			;Compare with 10
    BGE CONVERT_HEX
    ADDI.B #$30,D1			;Convert to 0-9
    JMP STORE_ASCII
CONVERT_HEX:
    ADDI.B #$37,D1			;Convert to A-F
STORE_ASCII:
    MOVE.B D1, -(A6)		;Store to Stack(self defined stack)
    ROR.L #4,D0
    SUBI.B #1, D2			;Count to 0
    BNE HEX2ASCII_LOOP
    ADD.L D3,A6
    MOVEM.L (A7)+, D1/D3
    RTS
    
; Convert ASCII(START FROM A1) to HEX num (Will be storeed in D0) 
; length will be stored in D2
ASCII2HEX:
    MOVEM.L D1,-(A7)
    CLR.L   D2
    CLR.L   D1
    CLR.L   D0
    CMPI.B #DOLLAR, (A1)    ;Get rid of $ first
    BNE ASCII2HEX_LOOP
    ADDA #1,A1
ASCII2HEX_LOOP:
    MOVE.B (A1)+,D1
    CMPI.B #$30,D1     ;0-9
    BLT SYNTAX_ER
    CMPI.B #$39,D1
    BLE ASCII2HEX_NUM 
    CMPI.B #F_ASC,D1  ;A-F
    BGT SYNTAX_ER
    CMPI.B #A_ASC,D1
    BLT SYNTAX_ER
    SUBI.B #$37,D1
    BRA ASCII2HEX_SUM
ASCII2HEX_NUM    
    SUBI.B #$30,D1
ASCII2HEX_SUM
    ROL.L #4,D0    
    ADD.L D1, D0
    ADDQ.B #1,D2
    CMPI.B #SPACE,(A1)  ;If next char is SPACE or NULL end sub routine
    BEQ ASCII2HEX_END   
    CMPI.B #NULL,(A1)
    BEQ ASCII2HEX_END
    BRA ASCII2HEX_LOOP
ASCII2HEX_END
    ADDQ #1,D2          ;CONVERT DIGIT TO BYTE
    BCLR #0,D2
    ROR.L #1,D2    
    MOVEM.L (A7)+,D1
    RTS

A2HEXC:
    MOVEM.L D1,-(A7)
    CLR.L   D2
    CLR.L   D1
    CLR.L   D0
    CMPI.B #HASH, (A1)    ;Get rid of # first
    BNE ASCII2HEX_LOOP
    ADDA #1,A1
A2HEXC_LOOP:
    MOVE.B (A1)+,D1
    CMPI.B #A_ASC,D1     ;symbols before letters 
    BLT SYNTAX_ER         ; if less than A
    CMPI.B #Z_ASC,D1     ; Z
    BLE A2HEXC_LETTER    ; in range of A-Z
    CMPI.B #Z_ASC,D1     ; if greater than Z, show syntax error 
    BGT SYNTAX_ER
A2HEXC_LETTER
    SUBI.B #$37,D1
A2HEXC_SUM
    ROL.L #4,D0    
    ADD.L D1, D0
    ADDQ.B #1,D2
    CMPI.B #SPACE,(A1)  ;If next char is SPACE or NULL end sub routine
    BEQ A2HEXC_END   
    CMPI.B #NULL,(A1)
    BEQ A2HEXC_END
    BRA A2HEXC_LOOP
A2HEXC_END
    ADDQ #1,D2          ;CONVERT DIGIT TO BYTE
    BCLR #0,D2
    ROR.L #1,D2    
    MOVEM.L (A7)+,D1
    RTS

;Store input buffer
STORE_HIS:
    MOVEM.L A1/A2,-(A7)
    LEA INPUT_BUFF,A1
    LEA HISTORY_BUFF,A2
STORE_HIST_LOOP:
    CMPI.B #0,(A1)
    BEQ STORE_HIS_END
    MOVE.B (A1)+,(A2)+
    BRA STORE_HIST_LOOP
STORE_HIS_END:
    MOVE.B #0,(A2)
    MOVEM.L (A7)+,A1/A2
    RTS  
  
*----------------COMMAND SUBROUTINE----------------------*

*---------------- HELP ----------------------*
;Help
;Print help messages for each individual debugger command
HELP:
    BSR STORE_HIS 
    LEA MSG_HELP,A5
    LEA MSG_HELP_ED,A6  
    BSR PRINT 
    LEA MSG_CMD_FST,A5
    LEA MSG_CMD_LST,A6  
    BSR PRINT 
HELP_LOOP:
    ;Print help console prompt
    LEA MSG_CMD_HELP,A5
    LEA MSG_CMD_HELP_ED,A6
    MOVE.B #LARGER,(A6)+
    BSR PRINT_C
    
    ;User input command to be displayed
    BSR INPUT
    LEA INPUT_BUFF,A1

    ;Check if buffer is empty
    CMPI.B #NULL,(A1)
    BEQ HELP_LOOP
    
    ;Sort memory
    LEA MSG_CMD_SORTW,A5
    LEA MSG_CMD_SORTW_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_SORTW
    
    ;Block search
    LEA MSG_CMD_BSCH,A5
    LEA MSG_CMD_BSCH_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_BSCH
    
    ;Addition
    LEA MSG_CMD_ADD,A5
    LEA MSG_CMD_ADD_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_ADD

    ;And
    LEA MSG_CMD_AND,A5
    LEA MSG_CMD_AND_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_AND
    
    ;Or
    LEA MSG_CMD_OR,A5
    LEA MSG_CMD_OR_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_OR

    ;MS
    LEA MSG_CMD_MS,A5
    LEA MSG_CMD_MS_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_MS
    
    ;MM 
    LEA MSG_CMD_MM,A5
    LEA MSG_CMD_MM_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE 
    BEQ HELP_MM

    ;MDSP
    LEA MSG_CMD_MDSP,A5
    LEA MSG_CMD_MDSP_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_MDSP

    ;BF
    LEA MSG_CMD_BF,A5
    LEA MSG_CMD_BF_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_BF
    
    ;BMOV
    LEA MSG_CMD_BMOV,A5
    LEA MSG_CMD_BMOV_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_BMOV
    
    ;Block search
    LEA MSG_CMD_BTST,A5
    LEA MSG_CMD_BTST_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_BTST

    ;Go
    LEA MSG_CMD_GO,A5
    LEA MSG_CMD_GO_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_GO
    
    ;DF
    LEA MSG_CMD_DF,A5
    LEA MSG_CMD_DF_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_DF
    
    ;COLOR
    LEA MSG_CMD_COLOR,A5
    LEA MSG_CMD_COLOR_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_COLOR

    ;HEX2DEC
    LEA MSG_CMD_HEX2DEC,A5
    LEA MSG_CMD_HEX2DEC_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_HEX2DEC
    
    ;EXIT PROGRAM
    LEA MSG_CMD_EXITP,A5
    LEA MSG_CMD_EXITP_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_EXITP

    
    ;Recall last command
    LEA MSG_CMD_RC,A5
    LEA MSG_CMD_RC_ED,A6
    LEA INPUT_BUFF,A1
    BSR COMPARE
    BEQ HELP_RC
    
    ;Exit help console
    LEA INPUT_BUFF,A1
    CMPI.B #Q_ASC,(A1)
    BEQ HELP_EXIT
    BRA HELP
HELP_EXIT:
    RTS

HELP_SORTW:
    LEA MSG_HELP_SORTW,A5
    LEA MSG_HELP_SORTW_ED,A6
    BSR PRINT
    BRA HELP_LOOP
HELP_BSCH:
    LEA MSG_HELP_BSCH,A5
    LEA MSG_HELP_BSCH_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_ADD:
    LEA MSG_HELP_ADD,A5
    LEA MSG_HELP_ADD_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_AND:
    LEA MSG_HELP_AND,A5
    LEA MSG_HELP_AND_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_OR:
    LEA MSG_HELP_OR,A5
    LEA MSG_HELP_OR_ED,A6
    BSR PRINT
    BRA HELP_LOOP
    
HELP_MM:
    LEA MSG_HELP_MM,A5
    LEA MSG_HELP_MM_ED,A6
    BSR PRINT
    BRA HELP_LOOP
    
HELP_MDSP:
    LEA MSG_HELP_MDSP,A5
    LEA MSG_HELP_MDSP_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_MS:
    LEA MSG_HELP_MS,A5
    LEA MSG_HELP_MS_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_BF:
    LEA MSG_HELP_BF,A5
    LEA MSG_HELP_BF_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_BMOV:
    LEA MSG_HELP_BMOV,A5
    LEA MSG_HELP_BMOV_ED,A6
    BSR PRINT
    BRA HELP_LOOP
    
HELP_BTST:
    LEA MSG_HELP_BTST,A5
    LEA MSG_HELP_BTST_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_GO:
    LEA MSG_HELP_GO,A5
    LEA MSG_HELP_GO_ED,A6
    BSR PRINT
    BRA HELP_LOOP
    
HELP_DF:
    LEA MSG_HELP_DF,A5
    LEA MSG_HELP_DF_ED,A6
    BSR PRINT
    BRA HELP_LOOP
    
HELP_COLOR:
    LEA MSG_HELP_COLOR,A5
    LEA MSG_HELP_COLOR_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_HEX2DEC:
    LEA MSG_HELP_HEX2DEC,A5
    LEA MSG_HELP_HEX2DEC_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_EXITP:
    LEA MSG_HELP_EXITP,A5
    LEA MSG_HELP_EXITP_ED,A6
    BSR PRINT
    BRA HELP_LOOP

HELP_RC:
    LEA MSG_HELP_RC,A5
    LEA MSG_HELP_RC_ED,A6
    BSR PRINT
    BRA HELP_LOOP
    
*-------------- SORTW ----------------------*
;THIS IS WHERE THE FUNCTIONS ARE ACTUALLY IMPLEMENTED
;Sort word
;Sort content as HEX in memory
SORTW:
        BSR STORE_HIS
        CMPI.B #SPACE,(A1)+ ;Test if there's a space after command
        BNE SYNTAX_ER       ;if there's no space, branch to SYNTAX_ER
        BSR ASCII2HEX       ; convert first address to hex
        MOVEA.L D0,A2       ; store in A2
        CMPI.B #SPACE,(A1)+ ; 
        BNE SYNTAX_ER       ;
        BSR ASCII2HEX       ; convert second address to hex
        MOVEA.L D0,A4       ; parse second add to A4 

        CMPI.B  #$44, (A1)+     ; check if next character is A or D 
        BEQ     LOOP            ; if it's D, branch to LOOP
        CMPI.B  #$41, (A1)      ; check if it's A
        BEQ     LOOP            ; branch to loop
        CMPI.B  #$44, (A1)      ; 
        BNE     SYNTAX_ER       ; otherwise, show error message      
        CLR.L   D1              ; clear D1 to set later

LOOP    MOVEA.L A2,A3       ; A3 keeps copy of first add
CMP     CMPI.B  #$41, (A1)  ; check if character is A or D 
        BEQ     SORTASC     ; if it's A, branch to SORTASC, 
        CMPI.B  #$44,(A1)   ; otherwise, branch to SORTDSC
        BEQ     SORTDSC     
        
CONT    TST.B   D1          ;if sorting in descending, D will be set to 1
        BNE     SORTDSC     ;and SORTASC will be skipped 
        
SORTASC  CMP.W   (A3)+,(A3)+ ; compare next two numbers
         BCS.S     SWAP     ; swap if not in ascending order
         BRA       NEXT     ; otherwise, move on to next 
        
SORTDSC  MOVE.B  #$1,D1     ;Set D1 to 1, this shows we're sorting in descending
         MOVEA.L  A4,A5     ;A5 holds a copy of second address 
         CMP.W   (A3)+,(A3)+ ; compare next two numbers
         BHI       SWAP     ; swap if not in descending order 
        
NEXT    SUBQ.L  #2,A3       ; look back at previous number
        CMP.L   A3,A4       ; check to see if done
        BNE     CONT        ; keep comparing if not done
        BRA     DONE        ; else, done
SWAP    MOVE.L  -(A3),D2    ; move both words to register D2
        SWAP.W  D2          ; swap words 
        MOVE.L  D2,(A3)     ; move them back to memory
        BRA     LOOP        ; loop again 
DONE    MOVEM.L (A7)+,D0-D4/A1-A4   ;restore registers
RTS
        BRA MAIN  

*-------------- BLOCK SEARCH ----------------------*
;Block search
BSCH:
    BSR STORE_HIS
    CMPI.B #SPACE,(A1)+ ;Get rid of the space after command
    BNE SYNTAX_ER       
    BSR ASCII2HEX
    MOVE.L D0,A3        ;Parse the first address
    CMPI.B #SPACE,(A1)+ 
    BNE SYNTAX_ER       
    BSR ASCII2HEX
    MOVE.L D0,A4        ;Parse the second address
    CMPA.L A4,A3        ;Check if the first address is smalller
    BGE SYNTAX_ER       
    CMPI.B #SPACE,(A1)+ 
    BNE SYNTAX_ER
    MOVE.L A1,-(A7)
BSCH_LOOP_1:
    MOVE.L (A7),A1      ;
    CMPA.L A3,A4        ;check if done 
    BEQ BSCH_FAILD      ; 
    CMPM.B (A3)+,(A1)+  ; compare pattern to memory 
    BNE BSCH_LOOP_1     ; if they don't match, loop again
    MOVE.L A3,D0        ; else, move address to D0  
    SUBQ #1,D0          
BSCH_LOOP_2:
    CMPA.L A3,A4        ; progresses to this loop only if there is at least one matching letter 
    BLT BSCH_FAILD      ; 
    CMPM.B (A3)+,(A1)+  ; compare pattern to memory 
    BEQ BSCH_LOOP_2     ; if they match, loop again
    CMPI.B #0,-1(A1)    ; Check if end of pattern
    BEQ BSCH_SUCCESS    ; if yes, print success message
    CMPA.L A3,A4        ; if not the end of pattern, 
    BEQ BSCH_FAILD      ; check if there're more characters 
    MOVE.L (A7),A1
    BRA BSCH_LOOP_1     ; if there are more chars, loop again
BSCH_FAILD:
    LEA MSG_BSCH_FAILD,A5       ;prints failure message
    LEA MSG_BSCH_FAILD_ED,A6
    BSR PRINT
    BRA BSCH_END    
BSCH_SUCCESS:
    LEA MSG_BSCH_SUCCESS,A5     ;prints success message and 
    LEA MSG_BSCH_SUCCESS_ED,A6  ;location where pattern was found
    BSR PRINT_C
    LEA OUTPUT_BUFF,A6
    BSR HEX2ASCII
    LEA OUTPUT_BUFF,A5
    BSR PRINT
    BRA BSCH_END
BSCH_END:
    ADDQ #4,A7                  ;reposition stack pointer
    RTS
*-------------- ADD ----------------------*
;Addition
;Add two numbers and display the result
ADD:
    BSR STORE_HIS       ;Store registers
    CMPI.B #SPACE,(A1)+ ;Test if there's a space after command
    BNE SYNTAX_ER       ;otherwise, wrong syntax
    BSR ASCII2HEX       ;convert first number
    MOVE.L D0,A3        ;Parse the first number to A3
    CMPI.B #SPACE,(A1)+ ;
    BNE SYNTAX_ER       
    BSR ASCII2HEX       ;convert second number
    MOVE.L D0,A4        ;Parse the second number to A4
    
    MOVE.L A3,D5        ;D5 holds copy of first number
    ADD.L A4,D5         ;perform ADD operation on both numbers
    MOVE.L D5,D0        ;move sum to D0 to convert back to ASCII

    BSR HEX2ASCII
    BRA PRINT           ;print sum to terminal
    BRA MAIN

*-------------- AND ----------------------*
;Arithmatic and 
;And two hex number bitwise and display the result
AND:
    BSR STORE_HIS      ;Store registers
    CMPI.B #SPACE,(A1)+ ;Test if there's a space after command
    BNE SYNTAX_ER       ; if no space, wrong syntax
    BSR ASCII2HEX       ;convert first number to hex
    MOVE.L D0,D6        ;Parse the first number to D6
    CMPI.B #SPACE,(A1)+ ;
    BNE SYNTAX_ER       ;
    BSR ASCII2HEX       ;convert second number to hex
    MOVE.L D0,D7        ;Parse the second number to D7
    MOVE.L D6,D5        ;D5 holds copy of first number
    AND D7,D5           ;perform AND on first and second number
    MOVE.L D5,D0        ;move sum to D0 to convert back to ASCII
    BSR HEX2ASCII
   
    BRA PRINT           ;print sum to terminal 
    BRA MAIN

*-------------- OR ----------------------*
;Arithmatic or 
;Or two hex number bitwise and display the result
OR: 
    BSR STORE_HIS       ;Store registers
    CMPI.B #SPACE,(A1)+ ;Test if there's a space after command
    BNE SYNTAX_ER       ;if no space, wrong syntax
    BSR ASCII2HEX       ;convert first number to hex
    MOVE.L D0,D6        ;Parse the first number to D6
    CMPI.B #SPACE,(A1)+ ;
    BNE SYNTAX_ER       
    BSR ASCII2HEX       ;convert second number to hex
    MOVE.L D0,D7        ;Parse the second address to D7 
    MOVE.L D6,D5        ;D5 holds copy of first number
    OR D7,D5            ;perform OR operation on both numbers
    MOVE.L D5,D0        ;move sum to D0 to convert back to ASCII 
    BSR HEX2ASCII
    BRA PRINT           ;print sum to terminal 

    RTS
*-------------- MEMORY MODIFY ----------------------*
MM: 
    BSR STORE_HIS
    MOVE.L #$3000,A5
    CMPI.B #SPACE,(A1)+ ;Test if there's a space after command
    BNE SYNTAX_ER       ;if no space, wrong syntax
    BSR ASCII2HEX       ;convert first address to hex(D0)
    MOVE.L D0,A3        ;Parse the first address
    CMPI.B #SPACE,(A1)+ ;Test if there's a space after first address
    BNE SYNTAX_ER       ;if no space, wrong syntax
    CMPI.B #'B',(A1) 
    BEQ MMB
    CMPI.B #'W',(A1) 
    BEQ MMW
    CMPI.B #'L',(A1) 
    BEQ MML
    BRA SYNTAX_ER
    
MMB:
    CLR.L   D0
    MOVE.L  A5,A6
    ADDA.L  #4, A6
    MOVE.B  #2,D2        ; specify length of input 
    MOVE.B (A3),D0       ; Move memory contents to D0 
    BSR HEX2ASCII        ; Convert memory contents to ascii
    
    MOVE.B  #'?',(A6)
    SUBA.L  #12, A6 
    MOVE.B  #'$',(A6)+
    MOVE.L  A3, D0       ; Move memory address to D0
    MOVE.B  #2,D2
    BSR     HEX2ASCII    ; Convert memory address to ascii (A6) 
    CLR.L   D0           ; Clear D0 to store mem contents
    MOVE.B  #$9,(A6)+    ; create a tab 
    ADDA.L #3,A6         ; move pointer to end of output
    BSR PRINT_C            ;prints data between addresses a5 and a6

    MOVE.B  #2,D0       ; read user input 
    TRAP    #15 
    CMPI.B  #0, (A1)     ;read new value 
    BNE     MMBLOOP      ; skip modify
    MOVE.L  A4,A6
    ADDA.L  #1, A3       ; increment A3 if yes 
    BRA     MMB
   
MMBLOOP: 
    CMPI.B  #'.',(A1)  ;else, check if done 
    BEQ     MMEND      ; branch to end 
    CLR     D0          ; otherwise, clear D0 to store hex conversion
    BSR ASCII2HEX       ;convert ot hex 
    MOVE.B  D0,(A3)+    ;put in address location 
    BRA     MMB 
    
MMW: 
    CLR.L   D0
    MOVE.L  A5,A6
    ADDA.L  #6, A6
    MOVE.B  #2,D2        ; specify length of input 
    MOVE.W (A3),D0       ; Move memory contents to D0 
    BSR HEX2ASCII        ; Convert memory contents to ascii
    
    MOVE.B  #'?',(A6)
    SUBA.L  #14, A6 
    MOVE.B  #'$',(A6)+
    MOVE.L  A3, D0       ; Move memory address to D0
    MOVE.B  #2,D2
    BSR     HEX2ASCII    ; Convert memory address to ascii (A6) 
    CLR.L   D0           ; Clear D0 to store mem contents
    MOVE.B  #$9,(A6)+    ; create a tab 
    ADDA.L #5,A6         ; move pointer to end of output

    BSR PRINT_C            ;prints data between addresses a5 and a6
     
    MOVE.W  #2,D0       ; read user input 
    TRAP    #15 
    CMPI.B  #0, (A1)     ;read new value 
    BNE     MMWLOOP      ; skip mem add?
    MOVE.L  A4,A6
    ADDA.L  #2, A3       ; increment A3 if yes 
    BRA     MMW
    
MMWLOOP: 
    CMPI.B  #'.',(A1)  ;else, check if done 
    BEQ     MMEND      ; 
    CLR     D0
    BSR     ASCII2HEX       ;convert ot hex 
    MOVE.W  D0,(A3)+    ;put in address location 
    BRA     MMW 

MML: 
    CLR.L   D0
    MOVE.L  A5,A6
    ADDA.L  #10, A6
    MOVE.B  #2,D2        ; specify length of input 
    MOVE.L (A3),D0       ; Move memory contents to D0 
    BSR HEX2ASCII        ; Convert memory contents to ascii
    
    MOVE.B  #'?',(A6)
    SUBA.L  #18, A6 
    MOVE.B  #'$',(A6)+
    MOVE.L  A3, D0       ; Move memory address to D0
    MOVE.B  #2,D2
    BSR     HEX2ASCII    ; Convert memory address to ascii (A6) 
    CLR.L   D0           ; Clear D0 to store mem contents
    MOVE.B  #$9,(A6)+    ; create a tab 
    ADDA.L #9,A6         ; move pointer to end of output

    BSR PRINT_C            ;prints data between addresses a5 and a6
     
    MOVE.L  #2,D0       ; read user input 
    TRAP    #15 
    CMPI.B  #0, (A1)     ;read new value 
    BNE     MMLLOOP      ; skip mem add?
    MOVE.L  A4,A6
    ADDA.L  #4, A3       ; increment A3 if yes 
    BRA     MML
    
MMLLOOP: 
    CMPI.B  #'.',(A1)  ;else, check if done 
    BEQ     MMEND      ; 
    CLR     D0
    BSR     ASCII2HEX       ;convert ot hex 
    MOVE.L  D0,(A3)+    ;put in address location 
    BRA     MML 

MMEND: 
    
    RTS 
*-------------- MEMORY DISPLAY ----------------------*     
MDSP: 
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+     ;Test if there's a space after command
    CMPI.B  #$24,(A1)+      ; test if $
    BNE     SYNTAX_ER       ; else, wrong syntax
    MOVE.L  A1, A5
    MOVE.L  A5, A6
    BSR     ASCII2HEX       ; convert to hex, first address in D0 
    MOVEA.L D0, A2          ; move to A2 
    CMPI.B  #SPACE,(A1)+    ; test if there's a space/second address
    BEQ     MDSPADD2        ; if yes, branch to mdspadd2
    MOVE.L  A2,A3           ; else, move 1st add to D3 
    ADD.L   #16,A3          ; end address of memory to be printed out 
    BRA     MDSPLOOP        

MDSPADD2
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX       ; convert 2nd add to hex (D0) 
    MOVEA.L D0,A3           ; Move address to A3 
MDSPLOOP
    MOVE.L  #$3000, A6      ;set printing area
    MOVEA.L  A6,A5
    MOVE.B  #'$',(A6)+
    MOVE.L  #2,D2
    MOVE.L  A2, D0          ; move first add to D0
    BSR     HEX2ASCII       ; convert to ASCII      
    MOVE.B  #$3E, (A6)+     ; arrow symbol 
    MOVE.L  #2,D2           ;length of input 
    MOVE.L  (A2)+,D0        ;move memory to D0
    BSR     HEX2ASCII       ;convert to ascii 
    BSR     PRINT
    CMPA.L  A2,A3 
    BGT     MDSPLOOP
    BRA     MDSPEND
MDSPEND
    RTS 
*-------------- MEMORY SET ----------------------*    
MS: ; Memory Set 
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX   
    MOVE.L  D0, A3          ; store first address in A3 
    CMPI.B  #SPACE,(A1)+    ; test if space after address 
    BNE     SYNTAX_ER       ; if no, syntax error
    CMPI.B  #HASH,(A1)+       ; is it #? (for hex)
    BEQ     MSHEX           ; if yes, branch to MSHEX to convert ascii to hex
    SUBQ.L  #1,A1
    
MSASC: 
    MOVE.B  (A1),(A3)+      ;move memory contents to first address and increment 
    CMPI.B  #0, (A1)+       ;see if there're more characters
    BEQ     MSEND           ;if no, end 
    BRA     MSASC           ; else loop
    
MSHEX: 
    BSR     ASCII2HEX       ; convert input to hex 
    CMPI.L  #$FF, D0        ; test size of input 
    BLE     MSBYTE          ; branch to MSBYTE if byte sized
    CMPI.L  #$FFFF, D0      ; branch to MSWORD if word sized
    BLE     MSWORD          
MSLONG: 
    ADDA.L  #4,A3           ; move pointer to end of long 
    MOVE.B  D0,-(A3)        ; copy byte to first address
    ROR.L   #8,D0           ; rotate to get next byte
    MOVE.B  D0,-(A3)        ; copy byte to address
    ROR.L   #8,D0           ;
    SUBA.L  #2,A3
    
MSWORD: 
    ADDA.L  #2,A3           ; move pointer to end of word
    MOVE.B  D0,-(A3)        ; copy byte to first address
    ROR.L   #8,D0
    SUBA.L  #1,A3
MSBYTE: 
    MOVE.B  D0,(A3) 
    BRA     MSEND
MSEND: 
    RTS 
*-------------- BLOCK FILL ----------------------*
BF: ; block fill 
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX   
    BTST.L  #0,D0           ; test if address is even
    BNE     MSG_BF_EVEN       ; if odd address, wrong syntax
    MOVE.L  D0, A3          ; otherwise, store first address in A3 
    CMPI.B  #SPACE,(A1)+    ; test if space after address 
    BNE     SYNTAX_ER
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER
    BSR     ASCII2HEX   
    BTST.L  #0,D0           ; test if address is even
    BNE     MSG_BF_EVEN       ; if odd address, wrong syntax
    MOVE.L  D0, A4          ; otherwise, store second address in A4 
    CMPI.B  #SPACE,(A1)+    ; test if space after 2ND address 
    BNE     SYNTAX_ER
    BSR     ASCII2HEX       ; pattern stored in D0
    CMPI.L  #$FFFF,D0      ; test if word sized, else 
    BGT     HEX2DEC_ER       ; show error message
    MOVE.B  #2,D2           ; LENGTH OF INPUT 
    
BFPATT:
    MOVE.W  D0,(A3)+         ;move pattern to memory location and increase pointer 

BFLOOP: 
    CMPA.L  A3,A4           ;compare first and second add to see if done
    BLE     BFEND           ;branch to BFEND if done         
    BRA     BFPATT          ;else, loop back to BFPATT
BFEND: 
    RTS   
 
*-------------- BLOCK MOVE ----------------------*   
BMOV: ; used to move blocks of memory from one area to another 
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX
    MOVE.L  D0, A2          ; store first address in A2 
    CMPI.B  #SPACE,(A1)+    ; test if space after address 
    BNE     SYNTAX_ER
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER
    BSR     ASCII2HEX   
    MOVE.L  D0, A3          ; store second address in A3
    CMPI.B  #SPACE,(A1)+    ; test if space after address 
    BNE     SYNTAX_ER       ; if no, syntax error
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX
    MOVE.L  D0, A4          ; store third address in A4
BMOVLOOP
    CMPA.L  A2,A3           ;compare addresses to see if done
    BLE     BMOVEND         ;else, loop 
    MOVE.B  (A2)+,(A4)+     ;continue moving memory to destination
    BRA     BMOVLOOP 
BMOVEND 
    RTS
    
*-------------- BLOCK TEST ----------------------*
BTST: 
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+
    BNE     SYNTAX_ER
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX       ; addr1 stored in D0
    MOVE.L  D0, A2          ; store first address in A2 
    CMPI.B  #SPACE,(A1)+    ; test if space after address 
    BNE     SYNTAX_ER
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER
    BSR     ASCII2HEX
    MOVE.L  D0, A3          ; store second address in A3
    CMPA.L  A3,A2        ;Check if the first address is smalller
    BGE     SYNTAX_ER
    CLR     D1

BTSTLOOP: 
    CMPA.L  A2,A3           ; compare 1st and 2nd addr to see if done 
    BLE     BTST_SUCCESS       ; if done, branch to 
    MOVE.B  #$A0, (A2)      ; write A0 to memory add
    MOVE.L  A2, D0          ; store current location to D0 
    MOVE.B  (A2)+,D1         ; load mem content to D1 to test 
    CMPI.B  #$A0, D1        ;check if input matches 
    BNE     BTST_FAILD      ;if does not match, error found 
    BEQ     BTSTLOOP        ; move to next byte to test 
        
BTST_SUCCESS:
    LEA MSG_BTST_SUCCESS,A5     ;print no error message 
    LEA MSG_BTST_SUCCESS_ED,A6
    BSR PRINT
    BRA BTST_END
 
BTST_FAILD:
    LEA MSG_BTST_FAILDLOC,A5
    LEA MSG_BTST_FAILDLOC_ED,A6
    SUBQ.L  #8,A6            ; position pointer to load address
    MOVE.L  #2,D2            ;specify length 
    BSR     HEX2ASCII           ; Addr in A6 
    BSR     PRINT               ; Print location

    LEA MSG_BTST_FAILDEXP,A5
    LEA MSG_BTST_FAILDEXP_ED,A6
    BSR PRINT               ; Print expected value 
    
    LEA MSG_BTST_FAILDRD,A5
    LEA MSG_BTST_FAILDRD_ED,A6
    SUBQ.L  #8,A6 
    BSR     PRINT_C         ;print start of error message
    LEA MSG_BTST_FAILDRD,A5
    LEA MSG_BTST_FAILDRD_ED,A6
    SUBQ.L  #8,A6 
    MOVE.L  #2,D2            ;specify length 
    MOVE.B  D1,D0           ; move memory content to D0 
    BSR HEX2ASCII           ; convert content to ASCII 
    ADDA.L  #17,A5           ; position pointer to print a byte  
    BSR PRINT               ; Print read
    
BTST_END: 
    RTS 
*-------------- GO ----------------------*    
GO: ;execute program
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+
    BNE     SYNTAX_ER
    CMPI.B  #$24,(A1)+      ; test if there's $ 
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     ASCII2HEX       ; addr1 stored in D0
    MOVE.L  D0, A2          ; store first address in A2 
    JSR     (A2) 
    BRA     GO_END
GO_END: 
    RTS 
*-------------- DISPLAY FORMATTED ----------------------*
DF: 
    BSR     STORE_HIS
    LEA     STACK,A2        ;load effective address of stack to A2       
    LEA     MSG_DF_R1, A6      ; store beginning address of DF msg in A6 
    MOVE.L  #16,D4          ;load counter for all registers   
DFNEXT 
    ADD.L   #5, A6          ;position pointer for next register
DFLOOP  
    MOVE.L  (A2)+, D0       ;move register to d0
    MOVE.L  #2,D2           ;specify length of input
    BSR     HEX2ASCII       ; convert to ASCII 
DFLOOP2 
    SUBQ.L  #1, D4          ;decrement total register counter 
    CMPI.B  #0, D4          ;check if done
    BNE     DFNEXT          ;else, loop       
DF_PRINTR 
    LEA     MSG_DF_R1,A5
    LEA     MSG_DF_R1ED,A6
    BSR     PRINT_C         ;print registers
DF_SSUSSR
    LEA     MSG_DF_R2,A6    ;A6 points to start of DF msg 2    
    ADDA.L  #4,A6           ; position pointer
    MOVE.L  A7, D0          ;move stack pointer to D0 
    MOVE.L  #2,D2           ;specify input length
    BSR     HEX2ASCII       ;convert SS 
    ADDA.L  #4,A6           ; position pointer
    LEA     US, A0          ;load user stack pointer 
    MOVE.L  A0,D0
    MOVE.L  #2,D2
    BSR     HEX2ASCII       ;convert US to ascii  
    ADDA.L  #4,A6           ; position pointer
    CLR.L     D0 
    MOVE.W  SR,D0 
    MOVE.L  #1,D2           ;specify input length
    BSR     HEX2ASCII       ;convert SS 
    LEA     MSG_DF_R2,A5
    LEA     MSG_DF_R2ED,A6
    BSR     PRINT_C         ;print US AND SR
    LEA     MSG_DF_R3,A6 
    ADDA.L  #3,A6           ; position pointer
    MOVE.L  #2,D2           ;specify input length
    SUBQ.L  #4,A7 
    MOVE.L  (A7),D0
    BSR     HEX2ASCII       ;convert PC
    LEA     MSG_DF_R3,A5
    LEA     MSG_DF_R3ED,A6
    BSR     PRINT           ;print PC 
DF_END:
    ;LEA     STACK, A7
    BRA     MAIN
*-------------- COLOR CHANGE ----------------------*
COLOR: 
    BSR     STORE_HIS
    CMPI.B  #SPACE,(A1)+    ;test if there's a space
    BNE     SYNTAX_ER       ; if no, syntax error
    BSR     A2HEXC
    CMPI.L  #$00001BED, D0  ; match input to color 
    BEQ     C_RED
    CMPI.L  #$01AFCA5E, D0    
    BEQ     C_PURPLE    
    CMPI.L  #$0011BEF7, D0 
    BEQ     C_GREEN 
    CMPI.L  #$0000BBEA, D0
    BEQ     C_AQUA 
    CMPI.L  #$10ED2D2A, D0 
    BEQ     C_FUCHSIA 
    CMPI.L  #$00011BC2,D0 
    BEQ     C_GRAY 
    CMPI.L  #$022F66A0,D0 
    BEQ     C_YELLOW 
    CMPI.L  #$016BC997,D0 
    BEQ     C_MAROON
    CMPI.L  #$002123DE,D0 
    BEQ     C_WHITE
    BRA     SYNTAX_ER       ;if none of these options were entered, show syntax error
C_RED   
    MOVE.L  #RED, D1        ;change terminal color to red
    BRA     COLOR_ED 
C_YELLOW   
    MOVE.L  #YELLOW, D1     ;change terminal color to yellow
    BRA     COLOR_ED 
C_AQUA    
    MOVE.L  #AQUA, D1       ;change terminal color to aqua
    BRA     COLOR_ED  
C_FUCHSIA    
    MOVE.L  #FUCHSIA, D1    ;change terminal color to fuchsia
    BRA     COLOR_ED    
C_GREEN    
    MOVE.L  #GREEN, D1      ;change terminal color to green
    BRA     COLOR_ED 
C_GRAY    
    MOVE.L  #GRAY, D1       ;change terminal color to gray
    BRA     COLOR_ED 
C_MAROON   
    MOVE.L  #MAROON, D1     ;change terminal color to maroon
    BRA     COLOR_ED 
C_WHITE   
    MOVE.L  #WHITE, D1      ;change terminal color to white 
    BRA     COLOR_ED 
C_PURPLE    
    MOVE.L  #PURPLE, D1     ;change terminal color to purple
COLOR_ED
    MOVE.L  #FONT,D2
    MOVE.B  #21, D0
    TRAP    #15 
    RTS 

DIV0test 
    MOVE.L  #5,D0 
    DIVU    #0,D0 
    
PRIVERR_test
    ANDI.W  #$0700,SR
    BRA     PRIVERR_test
    
CHKERR_test
    MOVE.L  #$55,D6
    MOVE.L  #$77,D7
    CHK.W   D6,D7
    BRA     CHKERR_test

    
*-------------- NUM2ASCII ----------------------*
    
NUM2ASCII
    AND.L   #$0F,D7     ; mask and take smallest hex digit 
    CMPI.B  #$A,D7 
    BLT     N2A_NEXT 
    ADDQ.B  #$7,D7      ; for A-F
N2A_NEXT 
    ADD.B   #$30,D7     ; convert to hex for ASCII 
    RTS 

*-------------- DEC2ASCII ----------------------*      
DEC2ASCII
    MOVE.L  D3,D4       ;Move ASCII to D4 
D2ALOOP
    DIVU    #10,D4      ;Divide by 10 
    MOVE.L  D4,D7       ;Move result to D7 
    SWAP.W  D7          ;swap positions of quotient and remainder 
    BSR     NUM2ASCII   ;convert to ASCII 
    MOVE.B  D7,-(A1)    ;move result to memory backwards (from LSB to MSB)
    AND.L   #$0000FFFF,D4   ;remove the remainder 
    TST.W   D4              ;test to see if done 
    BNE     D2ALOOP         ;if not, loop 
    RTS 

*-------------- HEX2DEC ----------------------*        
HEX2DEC
    CMPI.B  #SPACE,(A1)+    ; verify correct syntax 
    BNE     SYNTAX_ER
    CMPI.B  #$23,(A1)+      ; test if there's # 
            
CONV_H2D          
    BSR     ASCII2HEX       ; convert to hex 
    CMPI.L  #$0000FFFF, D0      ; test if word sized, else 
    BGT     HEX2DEC_ER       ; show error message 
    MOVE.L  D0,D3           ; store hex value in D3 
    BSR     DEC2ASCII         ; convert dec to ascii 
    MOVEA.L A1,A5           ; reposition pointer for printing 
    MOVEA.L A5,A6
    
CONV_PRINT
    CMPI.B  #0,(A6)+        ; move pointer based on length of result
    BEQ     CONV_END        ; branch to end once done 
    BRA     CONV_PRINT      ; else, loop till end 
CONV_END
    BSR PRINT               ;print result
    RTS 
HEX2DEC_ER
    LEA     MSG_HEX2DEC_ER,A5 
    LEA     MSG_HEX2DEC_ERED,A6 
    BSR     PRINT 
    RTS 

*-------------- EXCEPTION HANDLERS ----------------------*
ADDER   
    BSR     STORE_HIS 
    MOVEM.L D0/A0,-(A7) 
    MOVEM.L D1/A0,-(A7) 
    LEA     MSG_ADDER,A5
    LEA     MSG_ADDER_ED,A6 
    BSR     PRINT
    BRA     INT_REG
BERR
    MOVEM.L D0/A1,-(A7) 
    MOVEM.L D1/A0,-(A7) 
    LEA     MSG_BUSER,A5
    LEA     MSG_BUSER_ED,A6 
    BSR     PRINT
    BRA     INT_REG
ILLINS
    MOVEM.L D0/A1,-(A7)
    LEA     MSG_ILLINS,A5
    LEA     MSG_ILLINS_ED,A6 
    BSR     INTER
PRIVER
    MOVEM.L D0/A1,-(A7)
    LEA     MSG_PRIVER,A5
    LEA     MSG_PRIVER_ED,A6 
    BSR     INTER  
DIV0
    MOVEM.L D0/A1,-(A7)
    LEA     MSG_DIV0,A5
    LEA     MSG_DIV0_ED,A6 
    BSR     INTER
CHKER
    MOVEM.L D0/A1,-(A7)
    LEA     MSG_CHKERR,A5
    LEA     MSG_CHKERR_ED,A6 
    BSR     INTER
LINEA
    MOVEM.L D0/A1,-(A7)
    LEA     MSG_LINEA,A5
    LEA     MSG_LINEA_ED,A6 
    BSR     INTER
LINEF
    MOVEM.L D0/A1,-(A7)
    LEA     MSG_LINEF,A5
    LEA     MSG_LINEF_ED,A6 
    BSR     INTER
    
INT_REG
    MOVEA.L A7,A0           
    ADDA.L  #24,A0          ;position pointer to retrieve SSW,BA and IR 
    MOVE.L  #$0000445A,A6   ;position pointer to memory to move SSW
    CLR.L   D0
    MOVE.W  -(A0),D0        ;put ssw in D0
    BSR     HEX2ASCII       ;convert to ASCII  
    SUBQ.L  #4,A6           ;position pointer to insert space between registers
    MOVE.B  #SPACE,-(A6)
    MOVE.L  -(A0),D0        ;move BA into D1 
    MOVE.L  #2,D2           ; specify length of input for hex2ascii
    SUBQ.L  #8,A6           ;position pointer to insert BA
    BSR     HEX2ASCII
    SUBQ.L  #8,A6           ;position pointer 
    MOVE.B  #SPACE,-(A6)    ;insert space between registers 
    CLR.L   D0          
    MOVE.W  -(A0),D0        ;move IR into d1
    MOVE.L  #2,D2
    SUBQ.L  #8,A6
    BSR     HEX2ASCII
    MOVE.L  #$00004450,A5   ;reset the printing area
    MOVE.L  #$00004462,A6
    MOVEM.L (A7)+,D1/A0     ;restore registers 
INTER 
    BSR     PRINT
    BSR     DF              ;print registers 
    MOVEM.L (A7)+,D0/A1
    LEA     STACK,A7 
    RTS
        
;Recall last command    
RC:
    LEA HISTORY_BUFF,A2
    CMPI.B #0,(A2)  ;Check if history buffer is empty
    BNE RC_PROCESS
    LEA MSG_HIS_EMPTY, A5
    LEA MSG_HIS_EMPTY_ED, A6
    BSR PRINT
    RTS
RC_PROCESS:
    LEA INPUT_BUFF, A1
RC_LOOP:    
    CMPI.B #0,(A2)
    MOVE.B (A2)+,(A1)+
    BNE RC_LOOP
RC_END:    
    MOVE A1,A6
    LEA INPUT_BUFF,A5
    BSR PRINT
    BRA INTERPRETER ;Return to interpreter   
    
;Syntax error
;Throw an message indicating syntax error
SYNTAX_ER:
    LEA MSG_WRONG_CMD,A5
    LEA MSG_WRONG_CMD_ED,A6
    BSR PRINT
    LEA MSG_HELP_PROM,A5
    LEA MSG_HELP_PROM_ED,A6
    BSR PRINT
    BRA MAIN
*-------------- EXIT PROGRAM ----------------------*
EXITP: 
    BSR     STORE_HIS
    LEA     MSG_EXITP,A5
    LEA     MSG_EXITP_ED,A6 
    BSR     PRINT
    LEA     STACK,A7
    MOVEM.L (A7)+,D0-D7/A0-A6
    LEA     STACK,A7

    SIMHALT             ; halt simulator    

*----------------COMMON SYMBOLS--------------------------*
BLACK       EQU     $00000000
MAROON      EQU     $00000080
RED         EQU     $000000FF
GREEN       EQU     $0000FF00
YELLOW      EQU     $0000FFFF
GRAY        EQU     $00808080
DBLUE       EQU     $00808000
AQUA        EQU     $00FFFF00
LGRAY       EQU     $00C0C0C0
WHITE       EQU     $00FFFFFF
PURPLE      EQU     $00800080
FUCHSIA     EQU     $00FF00FF
FONT        EQU     $01090000
BUFFSIZE    EQU     $256    ;BUFF SIZE IS EQUAL TO $256
SPACE       EQU	    $20     ;SPACE IN ASCII
CR          EQU     $0D     ;CARRIGE RETURN IN ASCII
LF          EQU     $0A     ;LINE FEED IN ASCII
NULL        EQU     $00     ;NULL
COLON	    EQU     $3A     ; : IN ASCII
COMMA	    EQU	    $2C     ; , IN ASCII
DOT	        EQU	    $2E     ; . IN ASCII
DOLLAR	    EQU	    $24     ; $ IN ASCII
HASH        EQU     $23     ; # IN ASCII
A_ASC	    EQU	    'A'
B_ASC	    EQU	    'B'
D_ASC	    EQU	    'D'
F_ASC       EQU     'F'
G_ASC	    EQU	    'G'
H_ASC	    EQU	    'H'
L_ASC       EQU     'L'
M_ASC	    EQU	    'M'
Q_ASC		EQU		'Q'
S_ASC	    EQU	    'S'
W_ASC       EQU     'W'
Z_ASC       EQU     'Z'
LARGER      EQU     '>'
US          EQU      $00FF0000

*---------------COMMAND MESSAGES------------------*
MSG_CMD_HELP    DC.B    'HELP'
MSG_CMD_HELP_ED:   
	DC.B	CR,LF 
MSG_CMD_FST:
MSG_CMD_SORTW   DC.B    'SORTW'
MSG_CMD_SORTW_ED:
	DC.B	CR,LF
MSG_CMD_BSCH    DC.B    'BSCH'
MSG_CMD_BSCH_ED:
	DC.B	CR,LF
MSG_CMD_ADD     DC.B    'ADD'
MSG_CMD_ADD_ED:
	DC.B	CR,LF
MSG_CMD_AND     DC.B    'AND'
MSG_CMD_AND_ED:
	DC.B	CR,LF
	
MSG_CMD_OR     DC.B    'OR'
MSG_CMD_OR_ED:
	DC.B	CR,LF
	
MSG_CMD_RC     DC.B    '<'
MSG_CMD_RC_ED:
    DC.B    CR,LF

MSG_CMD_MM    DC.B    'MM'
MSG_CMD_MM_ED:
	DC.B	CR,LF
MSG_CMD_MDSP    DC.B    'MDSP'
MSG_CMD_MDSP_ED:
	DC.B	CR,LF
MSG_CMD_MS    DC.B    'MS'
MSG_CMD_MS_ED:
	DC.B	CR,LF

MSG_CMD_BF    DC.B    'BF'
MSG_CMD_BF_ED:
	DC.B	CR,LF
MSG_CMD_BMOV    DC.B    'BMOV'
MSG_CMD_BMOV_ED:
	DC.B	CR,LF

MSG_CMD_BTST    DC.B    'BTST'
MSG_CMD_BTST_ED:
	DC.B	CR,LF

MSG_CMD_GO    DC.B    'GO'
MSG_CMD_GO_ED:
	DC.B	CR,LF

MSG_CMD_DF    DC.B    'DF'
MSG_CMD_DF_ED:
	DC.B	CR,LF

MSG_CMD_COLOR    DC.B    'COLOR'
MSG_CMD_COLOR_ED:
	DC.B	CR,LF

MSG_CMD_HEX2DEC    DC.B    'HEX2DEC'
MSG_CMD_HEX2DEC_ED:
	DC.B	CR,LF

MSG_CMD_EXITP    DC.B    'EXIT'
MSG_CMD_EXITP_ED:
	DC.B	CR,LF
MSG_CMD_LST:

*----------------COMMON MESSAGES------------------*
MSG_WELCOME:
    DC.B 'System initialized. Please input command. Enter HELP for more information.' 
MSG_WELCOME_ED
MSG_PROM:
    DC.B 'ECE441 MONITOR>'
MSG_PROM_ED
MSG_HELP:
    DC.B	'Enter the command you need help with.'
    DC.B 	CR,LF,'Press "Q" to exit.'
MSG_HELP_ED

MSG_BSCH_SUCCESS:
    DC.B 'Content found at: $'
MSG_BSCH_SUCCESS_ED
MSG_BSCH_FAILD:
    DC.B 'Content not found'
MSG_BSCH_FAILD_ED

MSG_BF_EVEN:
    DC.B 'Addresses must be even'
MSG_BF_EVEN_ED

MSG_BTST_SUCCESS:
    DC.B 'No error found.'
MSG_BTST_SUCCESS_ED

MSG_BTST_FAILDLOC:
    DC.B    'Memory error at: $XXXXXXXX' 
MSG_BTST_FAILDLOC_ED
MSG_BTST_FAILDEXP:
    DC.B    'Value expected:A0' 
MSG_BTST_FAILDEXP_ED
MSG_BTST_FAILDRD:
    DC.B    'Value read:XXXXXXXX' 
MSG_BTST_FAILDRD_ED

MSG_DF_R1
    DC.B    '  D0=XXXXXXXX  D1=XXXXXXXX  D2=XXXXXXXX  D3=XXXXXXXX',CR,LF
    DC.B    'D4=XXXXXXXX  D5=XXXXXXXX  D6=XXXXXXXX  D7=XXXXXXXX',CR,LF
    DC.B    'A0=XXXXXXXX  A1=XXXXXXXX  A3=XXXXXXXX  A4=XXXXXXXX',CR,LF
    DC.B    'A4=XXXXXXXX  A5=XXXXXXXX  A6=XXXXXXXX  A7=XXXXXXXX',CR,LF
MSG_DF_R1ED  

MSG_DF_R2
    DC.B    'SS =XXXXXXXX US=XXXXXXXX SR=XXXX '
MSG_DF_R2ED  

MSG_DF_R3
     DC.B    'PC=XXXXXXXX'
MSG_DF_R3ED
MSG_HEX2DEC_ER 
    DC.B     'Value must be word-sized.',CR,LF
MSG_HEX2DEC_ERED


MSG_ADDER 
    DC.B     'Address Error Exception',CR,LF
MSG_ADDER_ED
MSG_BUSER
    DC.B     'Bus Error Exception',CR,LF 
MSG_BUSER_ED 
MSG_ILLINS
    DC.B     'Illegal Instruction Exception',CR,LF
MSG_ILLINS_ED
MSG_PRIVER
    DC.B     'Privilege Error Exception',CR,LF 
MSG_PRIVER_ED 
MSG_DIV0
    DC.B     'Division by Zero',CR,LF
MSG_DIV0_ED
MSG_CHKERR
    DC.B     'Check Exception',CR,LF 
MSG_CHKERR_ED
MSG_LINEA
    DC.B     'Line A Exception',CR,LF 
MSG_LINEA_ED
MSG_LINEF
    DC.B     'Line F Exception',CR,LF
MSG_LINEF_ED

MSG_WRONG_CMD:
    DC.B 'Wrong command'
MSG_WRONG_CMD_ED
MSG_HELP_PROM:
    DC.B	'Enter "HELP" for help info.'
MSG_HELP_PROM_ED
MSG_FINISH:
    DC.B 'Finshed'
MSG_FINISH_ED
MSG_HIS_EMPTY:
    DC.B 'No command to recall.'
MSG_HIS_EMPTY_ED


MSG_EXITP
     DC.B    'Goodbye!'
MSG_EXITP_ED


*--------------HELP MESSAGES----------------------*
;Sort word
MSG_HELP_SORTW:
    DC.B 	'The memory sort function can sort the',CR,LF 
    DC.B	'content (word)in given address range. "A"',CR,LF
    DC.B	'for ascending "D" for descending.',CR,LF 
    DC.B	'of memory will be displayed.',CR,LF
    DC.B	'SORTW <addr1> <addr2> M'
MSG_HELP_SORTW_ED

;Block search
MSG_HELP_BSCH:
    DC.B	'Search for specific pattern (input as string) within',CR,LF 
    DC.B	'a memory range. If found, pint the location of such',CR,LF
    DC.B	'string, if not found print failed promotion.',CR,LF 
    DC.B	'BSCH <addr1> <addr2> string'
    DC.B    'Syntax example:BSCH $5000 $5010 HELLO'
MSG_HELP_BSCH_ED

;Addition
MSG_HELP_ADD:
    DC.B    'Accepts two hex inputs and computes the sum, stores in "destination"',CR,LF 
    DC.B    '(Address of second input)',CR,LF
    DC.B    'ADD <addr1> <addr2>'
MSG_HELP_ADD_ED

;And
MSG_HELP_AND:
    DC.B    'Accepts two hex number inputs and conducts the bitwise AND operation',CR,LF 
    DC.B    'on them, then print the result in hex',CR,LF
    DC.B    'AND <addr1> <addr2>'
MSG_HELP_AND_ED

;Or
MSG_HELP_OR:
    DC.B    'Accepts two hex number inputs and conducts the bitwise OR operation',CR,LF 
    DC.B    'on them, then print the result in hex',CR,LF
    DC.B    'OR <addr1> <addr2>',CR,LF
    DC.B    'Syntax example: OR $5000 $5010'
MSG_HELP_OR_ED

;MM 
MSG_HELP_MM:
    DC.B    'Displays memory and as required, modify data or enter new data',CR,LF
    DC.B    'MM <addr> <size>',CR,LF 
    DC.B    'Syntax example: MM $5000 B'
MSG_HELP_MM_ED  

;MDSP
MSG_HELP_MDSP:
    DC.B    'Accepts two addresses and displays data in memory',CR,LF
    DC.B    'MDSP <addr1> <addr2>',CR,LF
    DC.B    'Syntax example: MDSP $5000 $5010'
MSG_HELP_MDSP_ED
    
;MS
MSG_HELP_MS:
    DC.B    'Alters memory by setting data into the address specified',CR,LF
    DC.B    '<addr1> $<ASCII|hex>' ,CR,LF
    DC.B    'Syntax example(Hex input): MS $5000 #1234',CR,LF
    DC.B    'Syntax example(ASCII input): MS $5000 hello'
MSG_HELP_MS_ED

;BF
MSG_HELP_BF:
    DC.B    'Fills memory starting with word boundary <add1> to <add2>. ',CR,LF
    DC.B    'Both addresses must be even addresses. This command only fills',CR,LF
    DC.B    ' with a word-size (2bytes) data pattern. If an entire word-size',CR,LF
    DC.B    ' data pattern is not entered, the pattern is right justified',CR,LF
    DC.B    ' and leading zeros are inserted.',CR,LF
    DC.B    'BF <addr1> <addr2> [pattern]' ,CR,LF
    DC.B    'Syntax example: BF $5000 $5010 1234'
MSG_HELP_BF_ED

;BMOV
MSG_HELP_BMOV:
    DC.B    'Move (duplicate) blocks of memory from one area to another',CR,LF
    DC.B    'BMOV <addr1.start> <addr1.end> <addr2>',CR,LF 
    DC.B    'Syntax example: BMOV $5000 $5010 $6000'
MSG_HELP_BMOV_ED

MSG_HELP_BTST:
    DC.B    'Test block of memory beginning at <addr1> to <addr2>. ',CR,LF
    DC.B    'If no errors, a success message will be displayed. ',CR,LF
    DC.B    'If an error is detected, the location of the error, ',CR,LF
    DC.B    'the data expected, and the data read of the failing memory ',CR,LF
    DC.B    'will be displayed.',CR,LF
    DC.B    'Syntax example: BTST $5000 $5010' 
MSG_HELP_BTST_ED

;GO
MSG_HELP_GO:
    DC.B    'Starts execution from a given address',CR,LF
    DC.B    'Syntax example: GO $5000' 
MSG_HELP_GO_ED

;DF
MSG_HELP_DF:
    DC.B    'Displays MC68000 processor registers. Displays PC, ',CR,LF
    DC.B    'SR, US, SS, D and A registers.', CR,LF
    DC.B    'Syntax example: DF' 
MSG_HELP_DF_ED

;EXIT
MSG_HELP_EXITP:
    DC.B    'Exits the program. ', CR,LF 
    DC.B    'Syntax example: EXIT'
MSG_HELP_EXITP_ED

;COLORCHG
MSG_HELP_COLOR:
    DC.B    'Changes the color of the terminal text. ',CR,LF 
    DC.B    'Programmed options are: aqua, green, red, maroon, yellow, fushcia, ',CR,LF
    DC.B    'purple, gray and white.',CR,LF 
    DC.B    'Syntax example: COLOR #AQUA'
MSG_HELP_COLOR_ED

MSG_HELP_HEX2DEC:
    DC.B    'Converts a word-sized hexadecimal value to decimal. ',CR,LF 
    DC.B    'Syntax example: HEX2DEC #FFFF'
MSG_HELP_HEX2DEC_ED
    
;Recall command
MSG_HELP_RC:
    DC.B	'Redo last correct command.',CR,LF 
    DC.B	'<'
MSG_HELP_RC_ED:

    ORG $3000
INPUT_BUFF:
    DS.B    BUFFSIZE 
OUTPUT_BUFF:
    DS.B    BUFFSIZE
HISTORY_BUFF:
    DS.B    BUFFSIZE    
ADDR_BUFF:
    DS.B    8
    ORG $4000
    DS.B    1024    ;RESERVE 1KB FOR A7 STACK
STACK:   
    DS.L    20      ;RESERVE 40 BYTES FOR
    
REGISTER_STACK: 
    DS.L    1
REGISTER_PC:   
    DS.L    1
     
    
    END    START



























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
