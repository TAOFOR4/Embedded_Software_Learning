bits 16                 ; Set the processor to 16-bit real mode

; Initialize data segment and stack
mov ax, 07C0h           ; 07C0h is the memory address where the bootloader is loaded by BIOS
mov ds, ax              ; Set data segment (DS) to 07C0h
mov ax, 07E0h           ; 07E0h is the beginning of the stack segment
mov ss, ax              ; Set stack segment (SS) to 07E0h
mov sp, 2000h           ; Initialize stack pointer (SP) with 8KB stack space

call clearscreen        ; Call subroutine to clear the screen

push 0000h              ; Push argument (cursor position) for movecursor subroutine
call movecursor         ; Call subroutine to move cursor to position (0, 0)
add sp, 2               ; Clean up stack after call (pop argument)

push msg                ; Push address of the string to print
call print              ; Call subroutine to print the string
add sp, 2               ; Clean up stack after call (pop argument)

cli                     ; Disable interrupts to safely halt the CPU
hlt                     ; Halt the CPU, effectively stopping the program

; Clears the entire screen by using the BIOS interrupt 10h
clearscreen:
    push bp             ; Save base pointer
    mov bp, sp          ; Set base pointer to stack pointer
    pusha               ; Push all general-purpose registers to the stack

    mov ah, 07h         ; BIOS function: scroll window up
    mov al, 00h         ; Clear entire window
    mov bh, 07h         ; Set background color (white on black)
    mov cx, 00h         ; Set top-left corner of screen (0, 0)
    mov dh, 18h         ; Set bottom-right corner row (24 rows)
    mov dl, 4Fh         ; Set bottom-right corner column (79 columns, total 80)
    int 10h             ; Call BIOS interrupt to scroll window (effectively clears screen)

    popa                ; Restore general-purpose registers from the stack
    mov sp, bp          ; Restore stack pointer
    pop bp              ; Restore base pointer
    ret                 ; Return from subroutine

; Moves the cursor to a specific position on the screen
movecursor:
    push bp             ; Save base pointer
    mov bp, sp          ; Set base pointer to stack pointer
    pusha               ; Push all general-purpose registers to the stack

    mov dx, [bp+4]      ; Get the cursor position argument from the stack
    mov ah, 02h         ; BIOS function: set cursor position
    mov bh, 00h         ; Set active display page (0, single page mode)
    int 10h             ; Call BIOS interrupt to move the cursor

    popa                ; Restore general-purpose registers from the stack
    mov sp, bp          ; Restore stack pointer
    pop bp              ; Restore base pointer
    ret                 ; Return from subroutine

; Prints a null-terminated string to the screen
print:
    push bp             ; Save base pointer
    mov bp, sp          ; Set base pointer to stack pointer
    pusha               ; Push all general-purpose registers to the stack

    mov si, [bp+4]      ; Get the string pointer from the stack
    mov bh, 00h         ; Set active display page (0, single page mode)
    mov bl, 00h         ; Set text color (foreground only, irrelevant in TTY mode)
    mov ah, 0Eh         ; BIOS function: teletype output (print character to screen)

.char:                  ; Start of character printing loop
    mov al, [si]        ; Load current character from string
    add si, 1           ; Move to the next character in the string
    or al, 0            ; Check if the character is null (0 terminator)
    je .return          ; If null, jump to the return point and exit the loop
    int 10h             ; Call BIOS interrupt to print the character
    jmp .char           ; Jump back to print the next character

.return:                ; End of string reached, return from the subroutine
    popa                ; Restore general-purpose registers from the stack
    mov sp, bp          ; Restore stack pointer
    pop bp              ; Restore base pointer
    ret                 ; Return from subroutine

; The message to be printed on the screen
msg:    db "Oh boy do I sure love assembly!", 0  ; Null-terminated string

; Pad the bootloader to 510 bytes with zeros
times 510-($-$$) db 0

; Boot sector signature, required by BIOS to identify it as bootable
dw 0xAA55              ; Boot signature (0xAA55)
