// Assembly code for addition, subtraction, multiplication, and division

//Proceso de Suma
.global add
add:
    push r29
    push r28 
    mov r29, r24     
    mov r28, r22 

    ; Validación de números negativos

    mov r0, 0    
    cp r29, r0                 ; Compara numero1 con cero
    brlt add_negative          ; Salta a add_negative si numero1 es menor que cero
    brge add_positive          ; Salta a add_positive si numero1 es mayor o igual a cero

add_negative:
    neg r29                    ; Obtiene el valor positivo de numero1
    cp r28, r29      
    jmp add_positive           ; Salta a add_negative si el valor absoluto de numero1 es mayor a numero2

    ; Continuacion de si el valor absoluto de numero1 es menor a numero2

    sub r28, r29               ; Al ser negativo supone que se haga una resta
    mov r24,r28
    jmp add_end       

add_positive:
    add r29,r28
    mov r24,r29  
    jmp add_end 

add_end:
    pop r28
    pop r29
    ret


//Proceso de Resta
.global subtract
substract:
    push r29
    push r28
    mov r29, r24     
    mov r28, r22 

    ; Validación de números negativos

    mov r0, 0   
    cp r29, r0                ; Compara numero1 con cero
    brlt substract_negative   ; Salta a substract_negative si numero1 es menor que cero
    brge substract_positive   ; Salta a substract_positive si numero1 es mayor o igual a cero

substract_negative:
    cp r28, r29      
    jmp substract_positive    ; Salta a substract_positive si numero1 es mayor a numero2
    
    ; Continuacion de si numero1 es menor a numero2

    sub r28, r29              ; Se resta de manera inversa
    neg r28                   ; Se obtiene el nagtivo del resultado
    mov r24,r28
    jmp substract_end       

substract_positive:
    sub r29,r28
    mov r24,r29  
    jmp substract_end 

substract_end:
    pop r28
    pop r29
    ret




//Proceso de Multplicacion
.global multiply
multiply:
    push r29
    push r28
    mov r29, r24     
    mov r28, r22 

    ; Validación de números negativos

    mov r0, 0     
    cp r29, r0                    ; Compara numero1 con cero
    brlt num1_negative            ; Salta a num1_negative si numero1 es menor que cero
    brge num1_positive            ; Salta a num1_positive si numero1 es mayor o igual a cero

num1_negative:
    cp r28, r0                    ; Compara numero2 con cero
    brlt multiply_num2_negative   ; Salta a multiply_num2_negative si numero2 es menor que cero
    brge multiply_num2_positive   ; Salta a multiply_num2_positive si numero2 es mayor o igual a cero 

multiply_num2_negative:           ; Al ser ambos negativos se los cambia a positivos para multiplicarlos
    neg r29                   
    neg r28
    mul r29, r28
    mov r29,r0
    mov r24,r29
    jmp multiply_end 

multiply_num2_positive:           ; Solo el numero 1 es negativo, por lo que la respuesta es negativa
    neg r29                   
    mul r29, r28
    mov r29,r0
    neg r29
    mov r24,r29
    jmp multiply_end 

num1_positive:
    cp r28, r0                  ; Compara numero2 con cero
    brlt multiply_negative      ; Salta a multiply_negative si numero2 es menor que cero
    brge multiply_positive      ; Salta a multiply_positive si numero2 es mayor o igual a cero 

multiply_positive:              ; Ambos numeros son positivos
    mul r29, r28
    mov r29,r0
    mov r24,r29
    jmp multiply_end

multiply_negative:              ; Solo el numero 2 es negativo, por lo que la respuesta es negativa
    neg r28                   
    mul r29, r28
    mov r29,r0
    neg r29
    mov r24,r29
    jmp multiply_end 

multiply_end:
    pop r28
    pop r29
    ret


//Proceso de Division
.global divide
divide:
    push r29
    push r28
    mov r29, r24     
    mov r28, r22 

    ; Validación de números negativos

    mov r0, 0     
    cp r29, r0                    ; Compara numero1 con cero
    brlt num1_negative            ; Salta a num1_negative si numero1 es menor que cero
    brge num1_positive            ; Salta a num1_positive si numero1 es mayor o igual a cero

num1_negative:
    cp r28, r0                    ; Compara numero2 con cero
    brlt divide_num2_negative     ; Salta a multiply_num2_negative si numero2 es menor que cero
    brge divide_num2_positive     ; Salta a multiply_num2_positive si numero2 es mayor o igual a cero 

divide_num2_negative:             ; Al ser ambos negativos se los cambia a positivos para multiplicarlos
    neg r29                   
    neg r28
    call divide_process

divide_num2_positive:             ; Solo el numero 1 es negativo, por lo que la respuesta es negativa
    neg r29
    call divide_process

num1_positive:
    cp r28, r0                    ; Compara numero2 con cero
    brlt divide_negative          ; Salta a multiply_negative si numero2 es menor que cero
    brge divide_positive          ; Salta a multiply_positive si numero2 es mayor o igual a cero 

divide_positive:                  ; Ambos numeros son positivos
    call divide_process

divide_negative:                  ; Solo el numero 2 es negativo, por lo que la respuesta es negativa
    neg r28                   
    call divide_process



.global divide_process
divide_process:
    clr r0                        ; Limpiar el registro R0 (se utiliza para almacenar el cociente)
    clr r1                        ; Limpiar el registro R1 (se utiliza para almacenar el residuo)
    cp r29, r28                   ; Comparar el dividendo con el divisor
    brlt divide_end               ; Si el dividendo es menor que el divisor, saltar al final

divide_loop:
    sub r29, r28                  ; Restar el divisor al dividendo
    inc r0                        ; Incrementar el cociente
    cp r29, r28                   ; Comparar el dividendo actualizado con el divisor
    brge divide_loop              ; Si el dividendo actualizado es mayor o igual al divisor, repetir el bucle

divide_end:
    mov r24,r0        
    pop r28           
    pop r29       
    ret              



