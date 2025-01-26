; reset-rightmost.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (b). In this and other
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
; Your task: You are to take the bit sequence stored in R16,
; and to reset the rightmost contiguous sequence of set
; by storing this new value in R25. For example, given
; the bit sequence 0b01011100, resetting the right-most
; contigous sequence of set bits will produce 0b01000000.
; As another example, given the bit sequence 0b10110110,
; the result will be 0b10110000.
;
; Your solution must work, of course, for bit sequences other
; than those provided in the example. (How does your
; algorithm handle a value with no set bits? with all set bits?)

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========

	ldi R16, 0b01011100
	;ldi R16, 0b10110110
	;ldi R16, 0b00000000
	;ldi R16, 0b11111111
	;ldi R16, 0b11111101
	


	; THE RESULT **MUST** END UP IN R25

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

; Your solution here.

ldi r17, 0b00000001 ;starting mask at bit 0 
ldi r20, 0b00000000

.def byte = r16
.def current_mask = r17
.def masked_byte = r18
.def final_mask = r19

iterateThrough:

	mov masked_byte, byte ; load given byte 
	and masked_byte, current_mask ;apply mask to byte
	cp current_mask,masked_byte	 ; compare mask and now masked byte
	brne leftShift ;if the mask and masked byte are not equal, it means there is a 0 in the position we are examining with the mask. Shift our mask left so we can examine the next position.

	mov masked_byte, byte ; if the mask and byte are equal, it means there is a 1 in the position we examining with the mask. 
	mov final_mask, current_mask ; Mark that we found a 1 in this position in our final mask
	lsl current_mask ; shift every bit in our mask to the left so we can examine the next position
	jmp sequenceOfOnes

leftShift:

	lsl current_mask ;shift every bit in r17 to the left
	jmp iterateThrough ; jump back to start of loop


sequenceOfOnes:

	mov masked_byte,byte ; load given byte
	and masked_byte, current_mask ; apply mask to byte
	cp masked_byte, r24 ; check if our masked byte is now all zeros, because if it is, then we are now done
	breq finalMask 

	cp masked_byte, current_mask ;compare mask and masked byte
	breq maskChange ;if the mask and masked byte are equal (again), we have found another 1 in this position
	jmp finalMask ;if the mask and masked byte are not equal, our sequence of 1's is now over. Advance to final mask

maskChange:

	add final_mask, current_mask ; add our found 1 to final mask
	lsl current_mask ; once again shift current mask to the left so we can examine the next position
	jmp sequenceOfOnes ; jump back to equal function

finalMask:

	mov r25, byte ; move original byte into final register
	eor r25, final_mask ; apply completed mask to eliminate all 1's that we found



; **** END OF "STUDENT CODE" SECTION ********** 



; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
reset_rightmost_stop:
    rjmp reset_rightmost_stop


; ==== END OF "DO NOT TOUCH" SECTION ==========
