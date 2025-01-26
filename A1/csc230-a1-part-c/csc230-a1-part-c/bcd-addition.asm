; bcd-addition.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (c). In this and other
; files provided through the semester, you will see lines of code
; indicating "DO NOT TOUCH" sections. You are *not* to modify the
; lines within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; In a more positive vein, you are expected to place your code with the
; area marked "STUDENT CODE" sections.

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: Two packed-BCD numbers are provided in R16
; and R17. You are to add the two numbers together, such
; the the rightmost two BCD "digits" are stored in R25
; while the carry value (0 or 1) is stored R24.
;
; For example, we know that 94 + 9 equals 103. If
; the digits are encoded as BCD, we would have
;   *  0x94 in R16
;   *  0x09 in R17
; with the result of the addition being:
;   * 0x03 in R25
;   * 0x01 in R24
;
; Similarly, we know than 35 + 49 equals 84. If 
; the digits are encoded as BCD, we would have
;   * 0x35 in R16
;   * 0x49 in R17
; with the result of the addition being:
;   * 0x84 in R25
;   * 0x00 in R24
;

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).



    .cseg
    .org 0

	; Some test cases below for you to try. And as usual
	; your solution is expected to work with values other
	; than those provided here.
	;
	; Your code will always be tested with legal BCD
	; values in r16 and r17 (i.e. no need for error checking).

	; 94 + 9 = 03, carry = 1
	;ldi r16, 0x94
	;ldi r17, 0x09

	; 86 + 79 = 65, carry = 1
	;ldi r16, 0x86
	;ldi r17, 0x79

	; 35 + 49 = 84, carry = 0
ldi r16, 0x35
ldi r17, 0x49

	; 32 + 41 = 73, carry = 0
;ldi r16, 0x32
;ldi r17, 0x41

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 



lowerNibble:

	ldi r21, 0x0a
	ldi r20, 0b00001111 ; mask to isolate lower nibble
	ldi r31, 0b11110000 ; mask to isolate upper nibble
	ldi r30, 0b00010000 ; carry bit

	mov r18, r16 ; copy entire numbers to new registers 
	mov r19, r17

	and r18, r20 ;masking both numbers to isolate lower nibbles
	and r19, r20

	add r19,r18 ; add two lower nibbles BUT WE HAVE TO TRACK CARRY
	cp r19, r21 ; compare new lower nibble to 10
	brge lowerCarry ;  branch if greater than or equal to 10 so we can carry

	jmp upperNibble 

lowerCarry:

	add r16, r30 ;add our carry bit to upper nibble
	sub r19, r21 ;subtract 10 from lower nibbles result, already accounted for the 10

upperNibble: 

	lsr r16              ;shift both bytes such that the upper nibble becomes the lower. 
	lsr r16				 
	lsr r16
	lsr r16
	lsr r17
	lsr r17
	lsr r17
	lsr r17

	add r17, r16 ;no need to mask already isolated upper. Add both "upper" nibbles 
	cp r17, r21 ;compare new upper nibble to 10, to track carry
	brge upperCarry ;branch if greater or equal to 10 so we can carry

	jmp finish

upperCarry:
		
	ldi r24,0x01 ; set our carry register
	sub r17,r21 ;remove 10 from upper nibbles result, we already carried the 10

finish: 

	lsl r17 ; shift upper nibble back to the actual upper nibble spot
	lsl r17
	lsl r17
	lsl r17

	mov r25, r17
	add r25,r19


; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
bcd_addition_end:
	rjmp bcd_addition_end



; ==== END OF "DO NOT TOUCH" SECTION ==========
