INCLUDE Irvine32.inc

print_str MACRO label
    mov  edx, OFFSET label
    call WriteString
ENDM

.data
welcome BYTE "=========================", 0Dh, 0Ah
        BYTE "       TIC-TAC-TOE       ", 0Dh, 0Ah
        BYTE "=========================", 0Dh, 0Ah, 0
goodbye BYTE 0Dh, 0Ah, "Thanks for playing!", 0Dh, 0Ah, 0

; Board: 9 cells, row-major. ' ' = empty, 'X' / 'O' = taken.
board   BYTE 9 DUP(' ')

; Game state
current BYTE 'X'                ; whose turn it is
moves   DWORD 0                 ; number of moves played

; ------------------------------------------------------------
.code
main PROC
    print_str welcome

    ; (game loop goes here in later commits)

    print_str goodbye
    call WaitMsg                ; "Press any key to continue..."
    exit
main ENDP
END main
