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

colSep  BYTE " | ", 0
rowSep  BYTE "---+---+---", 0Dh, 0Ah, 0

; ------------------------------------------------------------
.code
main PROC
    print_str welcome
    call draw_board

    ; (game loop goes here in later commits)

    print_str goodbye
    call WaitMsg                ; "Press any key to continue..."
    exit

; ------------------------------------------------------------
; draw_board: prints the 3x3 board from the board array
; Receives: nothing   Returns: nothing
; ------------------------------------------------------------
draw_board PROC
    pushad
    mov  esi, OFFSET board
    mov  ecx, 3                 ; 3 rows
row_loop:
    mov  al, ' '
    call WriteChar
    mov  al, [esi]
    call WriteChar
    print_str colSep
    mov  al, [esi+1]
    call WriteChar
    print_str colSep
    mov  al, [esi+2]
    call WriteChar
    call Crlf
    add  esi, 3                 ; next row
    cmp  ecx, 1
    je   skip_sep               ; no separator after last row
    print_str rowSep
skip_sep:
    loop row_loop
    popad
    ret
draw_board ENDP

main ENDP
END main
