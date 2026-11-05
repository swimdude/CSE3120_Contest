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

promptA BYTE "Player ", 0
promptB BYTE ", pick a cell (1-9): ", 0
badMsg  BYTE "Invalid or taken cell, try again.", 0Dh, 0Ah, 0
tieMsg Byte "The game is a tie!", 0Dh, 0Ah, 0
winMsg BYTE " wins the game!", 0Dh, 0Ah, 0

; Board: 9 cells, row-major. ' ' = empty, 'X' / 'O' = taken.
board   BYTE 9 DUP(' ')

; Game state
current BYTE 'X'                ; whose turn it is
moves   DWORD 0                 ; number of moves played

winner BYTE ' '        ;stores winner

colSep  BYTE " | ", 0
rowSep  BYTE "---|---|---", 0Dh, 0Ah, 0

; ------------------------------------------------------------
.code
main PROC
    print_str welcome
    call draw_board

    mov  ecx, 9                 ; 9 moves because tic tac toe has 9 grids
test_loop:
    call get_move
    call Crlf
    call draw_board

    call check_winner
    cmp winner, ' '
    jne game_won

    loop test_loop

    cmp moves, 9
    je game_tie
    jmp game_end

game_won:
    mov al, winner
    call WriteChar
    print_str winMsg
    jmp game_end

game_tie:
    print_str tieMsg

game_end:
    print_str goodbye
    call WaitMsg                ; "Press any key to continue..."
    exit
main ENDP

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

; ------------------------------------------------------------
; get_move: prompts current player, validates, places mark on board
; Receives: nothing   Returns: nothing (board updated)
; ------------------------------------------------------------
get_move PROC
    push ebx
retry:
    print_str promptA
    mov  al, current
    call WriteChar
    print_str promptB
    call ReadInt
    jo   bad                    ; non-numeric input sets OF
    cmp  eax, 1
    jb   bad
    cmp  eax, 9
    ja   bad
    dec  eax                    ; 1-9 -> 0-8
    cmp  board[eax], ' '
    jne  bad                    ; cell already taken
    mov  bl, current
    mov  board[eax], bl

    inc moves                ; counts moves

    cmp current, 'X'
    je change_to_o

    mov current, 'X'
    jmp move_done

change_to_o:
    mov current, 'O'

move_done:
    pop ebx
    ret
    
bad:
    print_str badMsg
    jmp  retry
get_move ENDP

check_winner Proc
    mov al, board[0]
    cmp al, ' '
    je check_row2

    cmp al, board[1]
    jne check_row2

    cmp al, board[2]
    jne check_row2

    mov winner, al
    jmp check_done

check_row2:
    mov al, board[3]
    cmp al, ' '
    je check_row3

    cmp al, board[4]
    je check_row3

    cmp al, board[5]
    je check_row3

    mov winner
    jmp check_done

check_row3:
    mov al, board[6]
    cmp al, ' '
    je check_col1

    mov al, board[7]
    cmp al, ' '
    je check_col1

    mov al, board[8]
    cmp al, ' '
    je check_col1

    mov winner, al
    jmp check_done

check_col1:
    mov al, board[0]
    cmp al, ' '
    je check_col2

    mov al, board[3]
    jne check_col2

    mov al, board[6]
    jne check_col2

    mov winner, al
    jmp check_done

check_col2
    mov al, board[1]
    cmp al, ' '
    je check_col3

    cmp al, board[4]
    jne check_col3

    cmp al, board[7]
    jne check_col3

    move winner, al
    jmp check_done

check_col3:
    mov al, board[2]
    cmp al, ' '
    je check_diag1

    cmp al, board[5]
    jne check_diag1

    cmp al, board[8]
    jne check_diag1

    move winner, al
    jmp check_done

check_diag1:
    mov al, board[0]
    cmp al, ' '
    je check_diag2

    cmp al, board[4]
    jne check_diag2

    cmp al, board[8]
    jne check_diag2

    move winner, al
    jmp check_done


check_diag2:
    mov al, board[2]
    cmp al, ' '
    je check_done

    cmp al, board[4]
    jne check_done

    cmp al, board[6]
    jne check_done

    move winner, al
    jmp check_done


check_done:
    ret
check_winner ENDP

END main
