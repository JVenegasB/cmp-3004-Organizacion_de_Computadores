// Assembly code for addition, subtraction, multiplication, and division

.global add
add:
    push r29
    push r28

    mov r29,r24
    mov r28, r22

    add r29,r28
    mov r24,r29

    pop r28
    pop r29
    ret

.global addNegative
addNegative:
    push r29
    push r28

    mov r29,r24
    mov r29,r22

    neg r29
    sub r29,r22
    mov r24,r29

    pop r28
    pop r29
    ret 

.global subtract
subtract:
    push r29
    push r28
    
    mov r29,r24
    mov r28, r22

    sub  r29, r28 
    mov r24,r29
    
    
    pop r28
    pop r29
    ret

.global multiply
multiply:
    push r29
    push r28

    mov r29,r24
    mov r28,r22

    mul r29, r28
    mov r29,r0

    mov r24,r29
        
    pop r28
    pop r29
    ret

.global divide
divide:
    push r29
    push r28

    mov r24, r24      ; Move the dividend into register R24 (can be skipped if the dividend is already in R24)
    mov r22, r22      ; Move the divisor into register R22 (can be skipped if the divisor is already in R22)
    clr r0            ; Clear register R0 (used to store the quotient)
    clr r1            ; Clear register R1 (used to store the remainder)
    cp r24, r22       ; Compare the dividend with the divisor
    brlt divide_end   ; If the dividend is less than the divisor, skip the next loop

    pop r28
    pop r29

divide_loop:
    sub r24, r22      ; Subtract the divisor from the dividend
    inc r0            ; Increment the quotient
    cp r24, r22       ; Compare the updated dividend with the divisor
    brge divide_loop  ; If the updated dividend is greater than or equal to the divisor, repeat the loop

divide_end:
    mov r24,r0
    ret