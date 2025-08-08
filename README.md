# Arithmetic Operations with Call Operations (PIC18F452 Assembly)

## Abstract
This project implements basic unsigned arithmetic operations (addition, subtraction, multiplication, division) on the **PIC18F452** microcontroller using assembly language. It demonstrates how to write and invoke subroutines with the `call` instruction, detect and handle overflow and carry conditions, and safely manage division-by-zero cases. The assignment emphasizes modular code, efficient use of registers and status flags, and improved debugging practices.

## Objectives
- Implement addition, subtraction, multiplication, and division for **unsigned** numbers in PIC18F452 assembly.
- Demonstrate the use of `call` and `return` for subroutines.
- Detect and handle arithmetic overflow and carry using STATUS register flags.
- Implement safe division that detects division by zero.
- Write clear, efficient, and well-documented assembly code.

## Hardware Target
- **Microcontroller:** PIC18F452
- **Programmer/Board:** e.g., PICkit-compatible development board
- **Power Supply:** Standard MCU power requirements (5V)
- **Clock:** Crystal or resonator as per board specs

## Software Tools
- MPLAB X IDE
- XC8 assembler / MPASM
- MPLAB simulator or PICkit/ICD hardware debugger


## Features
- **Addition:** Unsigned 8-bit addition with carry detection.
- **Subtraction:** Unsigned 8-bit subtraction with borrow detection.
- **Multiplication:** Unsigned 8-bit multiplication with overflow detection (16-bit product).
- **Division:** Unsigned division with division-by-zero check.
- **Subroutines:** Modular implementation using `call` and `return`.
- **Status Flags:** Proper handling of STATUS register flags (C, Z) and custom flags.

## Calling Convention Examples

### Multiplication

; Load operands
movlw   0x12
movwf   OPERAND_A
movlw   0x05
movwf   OPERAND_B

; Call multiplication
call    MUL8

; Result: PROD_L (low byte), PROD_H (high byte)
DIV8
    movf    DIVISOR, W
    bz      DIV_BY_ZERO
    ; Perform division
    return
### Division with Zero Check

DIV_BY_ZERO
    bsf     DIV_ERROR_FLAG, 0
    movlw   0xFF
    movwf   QUOTIENT
    movwf   REMAINDER
    return

## Overflow Detection in Multiplication
; After computing product
movf    PROD_H, W
bz      MUL_NO_OVERFLOW
bsf     MUL_OVERFLOW_FLAG, 0
MUL_NO_OVERFLOW
return

## Testing and Verification
- Normal values: e.g., 10 × 5, 25 + 17, 50 − 20, 100 ÷ 4
- Edge cases: 0 and 255 (8-bit max)
- Overflow cases: addition carry, multiplication high byte non-zero
- Division by zero: verify error flag and safe return values

## Debugging Tips
- Step through code in MPLAB simulator.
- Monitor STATUS register bits (C, Z).
- Initialize registers before subroutine calls.
- Maintain consistent calling conventions.

## Expected Output
- Correct arithmetic results in designated registers.
- Carry flag set for addition overflow, borrow detection for subtraction.
- Multiplication overflow flag set when needed.
- Division-by-zero flag set and safe values returned.

## Future Improvements
- Extend to multi-byte arithmetic (16/32-bit).
- Implement signed arithmetic.
- Optimize multiplication/division algorithms.
- Add UART or LED output for real hardware testing.

