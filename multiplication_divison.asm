
;in this code there are two sub routeins one for multiplication and one for division
;after taking 8 bit input from user, multiplication and division are performed respectively
;in division if divisor is zero than led at porte is turned on, it is represented by setting porte of pic to 1
;porte first bit is set to 1 to indicate that division by zero is not possible
;in division quotient and remainder are shown at different ports 
;quotient is displayed on portd while remainder is displayed on porta
;in case of multiplication there is chances of number exceeding 8 bits
;exceeding of bits is possible because when two 8 bits number are multiplied their range increases
;to show correct result of multiplication lower 8 bits are displayed on portd 
;the upper bits of multiplication is displayed over porta

LIST P=18F452
#include <p18f452.inc>
temp_num1  EQU 0x30  ;memory location reserved for temporary storage of input 1 in multiplication
temp_num2  EQU 0x31  ;memory location reserved for temporary storage of input 2 in multiplication
result     EQU 0x32  ;to store lower 8 bits of result of multiplication and in case of division to store quotient
result2    EQU 0x33  ;to store upper 8 bits of result of multiplication and in case of division to store remainder but because of only 7 pins available we are omitting one bit
carry      EQU 0x34  ;temporary carry in multiplication to help in code to check if resultant of multiplication has exceeded 8 bits


ORG 0x00 ;sssigning starting memory location
GOTO START ;to jump onto the main part of the code

;---------------------Division----------------------------------
;subroutein for division of two numbers
DIV_1:                 ;division by repeated subtractions
    CLRF result        ;clearing result to avoid garbage values
    MOVF PORTB, W      ;loading dividend from portb to working register 
    MOVWF 0x31         ;storing dividend temporarily at memory location 0x31
    MOVF PORTC, W      ;loading divisor from portc into working register

    BTFSS PORTC, 0     ;to check if bit in portc are zero, if it is not zero it will skip next instruction else it will jump to div_zero
    GOTO DIV_ZERO      ;on having divisor equals to zero jumping at label div_zero

DIV_Quotient:          ;for calculation of division quotient
    MOVF 0x31,W        ;loading dividend into working register
    MOVWF 0x32         ;storing dividend into memory location 0x32 for keeping track of remainder
    MOVF PORTC, W      ;loading portc value basically divisor into working register
    SUBWF 0x31, F      ;subtracting divisor from dividend and storing back into same location
    BTFSS STATUS, C    ;to check if on dividing the remainder is negative if it is negative jumping on the label div_remainder else skipping the jump on specified label
    GOTO DIV_Remainder ;ending division if on subtraction dividend beocme negative

    INCF result, F     ;after each subtraction quotient is incremented to get correct disvison quotient
    GOTO DIV_Quotient  ;jumping back to label untill division is completely done

DIV_Remainder:         ;for calculation of division remainder
    MOVF 0x32, W       ;loading remainder into working register
    ANDLW 0x7F         ;omitting 1 most significant bit because the port available at a are only 7
    MOVWF result2      ;storing remainder into result2 to display on porte
    RETURN             ;returning to instruction from where call to subroutein is made

DIV_ZERO:
    BSF PORTE, 0      ;if divisor is zero led at porte is turned on because first bit of porte is set to 1
    RETURN             ;returning to instruction from where call to subroutein is made

;-----------------------------MULTIPLICATION--------------------------
MUL_1:
    CLRF    result         ;clearing result to avoid garbage values
    CLRF    result2        ;clearing result2 to avoid garbage values
    CLRF    carry          ;clearing carry to avoid garbage values

    MOVF    PORTB, W       ;loading num1 from portb into working register
    MOVWF   temp_num1      ;storing num1 in temporary memory location temp_num1
    MOVF    PORTC, W       ;loading num2 from portb into working register
    MOVWF   temp_num2      ;storing num2 in temporary memory location temp_num2

REPEAT_ADD:
    MOVF    result, W      ;loading current result basically zero to working register
    ADDWF   temp_num1, W   ;adding number 1 to working register and storing in working register
    MOVWF   result         ;storing the new result after addition into same location for repeated addition

    ;to check for overflow (carry flag) and handle upper 8 bits
    MOVF    result, W      ;loading lower 8 bits to working register
    CPFSLT  result2        ;value in working register is compared with result2 to check if it is smaller or not if smaller next instruction is skipped
    BTFSS   STATUS, C      ;if value in working register is not smaller than it is checked if carry flag is set or not
    MOVWF   carry          ;if there is carry store the carry in the memory location intialiazed with name of carry
    MOVF    carry, W       ;moving the value at memory locaton carry into working register
    ADDWF   result2, F     ;adding the value stored in memory location at carry with working register and storing at same location

    DECFSZ  temp_num2, F   ;decrementing number 2 to keep check on how many time we have to perform addition
    GOTO    REPEAT_ADD     ;repeat addition untill the number 2 is equal to zero

MUL_DONE:
 RETURN             ;returning to instruction from where call to subroutein is made

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
 ;--------------------calling multiplication subroutein------------------------------
    CALL MUL_1         ;calling subrouteine mul_1 to perform multiplication
    MOVF result, W     ;loading lower 8 bits of multiplication stored in file location result into a working register
    MOVWF PORTD        ;loading lower 8 bits of multiplication from working register to portd for output display purpose
    MOVF result2, W    ;loading upper 8 bits of multiplication stored in file location result into a working register
    MOVWF PORTA        ;loading upper 8 bits of multiplication from working register to porta for output display purpose
    CALL DELAY         ;waiting for sometime to differ between different results by creating a delay of our own choice by calling delay subroutein
;--------------------calling divison subroutein------------------------------
    CALL DIV_1         ;calling subrouteine div_1 to perform divison 
    MOVF result, W     ;loading quotient of divison stored in file location result into a working register
    MOVWF PORTD        ;loading quotient of divison from working register to portd for output display purpose
    MOVF result2, W    ;loading reaminder of divison stored in file location result into a working register
    MOVWF PORTA        ;loading reaminder of divison from working register to porta for output display purpose
    CALL DELAY         ;waiting for sometime to differ between different results by creating a delay of our own choice by calling delay subroutein
    GOTO MAIN_LOOP         ;to repeat process infinetely
    END ; ending the program
