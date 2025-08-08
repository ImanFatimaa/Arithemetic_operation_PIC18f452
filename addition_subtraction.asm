
;in this code there are two sub routeins one for addition and one for subtraction
;after taking 8 bit input from user, addition and subtraction are performed respectively
;in addition if there is a carry generated, it is represented by setting porte of pic to 1
 
LIST P=18F452
#include <p18f452.inc>

result EQU 0x32 ;to store the end_result of addition and subtraction 

ORG 0x00 ;sssigning starting memory location
GOTO START ; to jump onto the main part of the code

;----------------------Addition----------------------------------

;subroutein to perform addition on input taken from user
ADD_1:
    MOVF PORTB, W      ;load 8-bit input 1 from port b to working register
    ADDWF PORTC, W     ;add 8-bit input 2 from PORTC to Working register(having input 1)
    MOVWF result       ;store the result,by moving value stored in working register after addition to file location named as result
    
    ;to check if there was a carry in the addition
    ;if bit in staus register for carry flag is set than it will skip next instruction of jumping onto label no_carry
    BTFSS STATUS, C    ;to check if the carry flag is set, ifit is set it will skip next instruction and will go on instruction of setting porte to 1
    GOTO NO_CARRY      ;if there is no carry, jump to NO_CARRY

    ;setting porte first bit to 1 to indicate the carry flag
    BSF PORTE, 0       ;bit set file here sets the porte first bit to 1, only first bit is set bcz i am only using first bit for output

;if there is no carry generated than it will simply return to the program insruction from where specificed subrouteinis called
NO_CARRY:
    RETURN

;----------------------Subtraction----------------------------------

;subroutein to perform subtraction on input taken from user
SUB_1:
    MOVF PORTC, W      ;load 8-bit input 1 from port b to working register
    SUBWF PORTB, W     ;sbtract 8-bit input 2 (from PORTC) from Working register(having input 1)
    MOVWF result       ;store the result,by moving value stored in working register after subtraction to file location named as result
    RETURN

;----------------------Delay_Function----------------------------------

;subroutein to give a dealy after displaying one result on output portd
DELAY:
    MOVLW 0xFF             ;loading delay counter to working register
    MOVWF 0x20             ;soring counter at memory location of 0x20
DelayLoop1:
    MOVLW 0xFF             ;loading another delay counter for inner loop into working register
    MOVWF 0x21             ;storing inner loop counter at memory location of 0x21
DelayLoop2:
    DECFSZ 0x21, F         ;decrementing inner counter untill it becomes equal to zero and storing back at its own location in memory
    GOTO DelayLoop2        ;jumping back to inner loop untill the inner loop counter becomes zero
    DECFSZ 0x20, F         ;decrementing outer counter untill it becomes equal to zero and storing back at its own location in memory
    GOTO DelayLoop1        ;jumping back to outer loop untill the outer loop counter becomes zero
    RETURN

;--------------------Main_Program--------------------------------------
START:
    ;configure portb as input for input 1
    MOVLW 0xFF         ;moving 1 to working register 
    MOVWF TRISB        ;moving value from working register to file location basically to set portb as input port

    ;configure portc as input for input 2
    MOVLW 0xFF         ;moving 1 to working register 
    MOVWF TRISC        ;moving value from working register to file location basically to set portc as input port

    ;configure portd as output for resultant output
    CLRF PORTD         ;clearing portd
    MOVLW 0x00         ;moving 0 to working register
    MOVWF TRISD        ;moving value from working register to file location basically to set portd as output port

  ;configure porte as output for resultant output
    CLRF PORTE         ;clearing porte
    MOVLW 0x00         ;moving 0 to working register
    MOVWF TRISE        ;moving value from working register to file location basically to set porte as output port

  ;configure porta as output for resultant output
    CLRF PORTA         ;clearing porta
    MOVLW 0x00         ;moving 0 to working register
    MOVWF TRISA        ;moving value from working register to file location basically to set porta as output port

MAIN_LOOP:
 ;--------------------calling addition subroutein------------------------------

    CALL ADD_1         ;calling subrouteine add_1 to perform addition
    MOVF result, W     ;loading result of addition stored in file location result into a working register
    MOVWF PORTD        ;loading output of addition from working register to portd for output display purpose
    CALL DELAY         ;waiting for sometime to differ between different results by creating a delay of our own choice by calling delay subroutein

;--------------------calling subtraction subroutein------------------------------
    CALL SUB_1         ;calling subrouteine sub_1 to perform subtraction
    MOVF result, W     ;loading result of subtraction stored in file location result into a working register
    MOVWF PORTD        ;loading output of subtraction from working register to portd for output display purpose
    CALL DELAY         ;waiting for sometime to differ between different results by creating a delay of our own choice by calling delay subroutein

    GOTO MAIN_LOOP         ;to repeat process infinetely

    END ; ending the program
