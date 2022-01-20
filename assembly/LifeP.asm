IDEAL
MODEL small
STACK 5000h

DATASEG
	GAME_BOARD db 2500 dup(0)
	BOARD_TOTAL_SIZE dw 2500
	BOARD_ROW_SIZE db 50
	BOARD_ROW_SIZE_DW dw 50
	BOARD_ROW_SIZE_MINUS_ONE db 49
	NEIGHBORS_COUNTER db 0
	X_CORD_TEMP db 0
	Y_CORD_TEMP db 0
	ENTER_CHAR db 10
	GENERATIONS dw 100
	X dw 0
	Y dw 0
	COLOR_ALIVE db 15	; White color
	COLOR_DEAD db 0		; Black color

CODESEG

proc Draw
	push bp
	mov bp, sp
 	
 	;Graphic mode
	mov ax, 13h
	int 10h

	mov [X], 0
	mov [Y], 0
	

	mov si, [bp+4]				; bp+4: offset GAME_BOARD
	mov cx, [BOARD_TOTAL_SIZE]	; cx - total cells counter
	xor bx, bx 					; bx - current cell index

LOOP_PRINT:
	
	cmp [X], 50	; Checking if row over
	jne ALIVE_OR_DEAD
	add [Y], 1					; Enter (going down a row)
	mov [X], 0					

ALIVE_OR_DEAD:
	; Save current cell index and how many are in a row
	push bx
	push cx			

	;Checking if cell is alive
	cmp [byte ptr si+bx], 1h
	je PRINT_ONE

PRINT_ZERO:
	mov al, [COLOR_DEAD]		; Printing dead cell
	jmp MAINLOGIC

PRINT_ONE:
	mov al, [COLOR_ALIVE]		; Printing live cell

MAINLOGIC:
	xor bx, bx
	
	; Print
	mov bh, 0
	mov cx, [X]
	mov dx, [Y]
	mov ah, 0ch
	int 10h

	inc [X]						; Continue to next cell

	pop cx
	pop bx 

	; Moving to the next cell
	inc bx 						; bx - current cell index

	; Checking if loop is over
	dec cx
	cmp cx, 0
	je PRINT_END_OF_FUNCTION
	jmp LOOP_PRINT

PRINT_END_OF_FUNCTION:
	; End of function
	pop bp
	ret 2
endp Draw 



proc CountNeighbors
	; bp+4: offset GAME_BOARD
	; bp+6: index of cell to count its neighbors

	push bp
	mov bp, sp

	xor ax, ax
	mov si, [bp+4] ; bp+4: offset GAME_BOARD
	
	; Start position
	mov [X_CORD_TEMP], -1
	mov [Y_CORD_TEMP], -1
	mov [NEIGHBORS_COUNTER], 0

COUNT_NEIGHBORS:
	xor cx, cx 
	mov bx, [bp+6] ; bp+6: Current cell index 
	
	; 1D-> 2D cooridinets
	xor dx, dx
	mov ax, bx
	mov bx, [BOARD_ROW_SIZE_DW]
	div bx 		; ax: x, dx: y
	mov cl, al 	; cl: row
	mov ch, dl  ; ch: col
	
	; Get to neighbor
	add cl, [X_CORD_TEMP] ; get to x neighbor's cells index
	add ch, [Y_CORD_TEMP] ; get to y neighbor's cells index

	; Checking if x == -1
	cmp cl, -1
	jne X_CONTINUE_CHECK
	mov cl, [BOARD_ROW_SIZE_MINUS_ONE]
	jmp Y_CHECK
	
X_CONTINUE_CHECK: 
	; Checking if x == 20
	cmp cl, [BOARD_ROW_SIZE]
	jne Y_CHECK
	mov cl, 0

Y_CHECK:
	; Checking if y == -1
	cmp ch, -1
	jne Y_CONTINUE_CHECK
	mov ch, [BOARD_ROW_SIZE_MINUS_ONE]
	jmp CONTINUE_COUNT
	
Y_CONTINUE_CHECK:
	; Checking if y == 20
	cmp ch, [BOARD_ROW_SIZE]
	jne CONTINUE_COUNT
	mov ch, 0

CONTINUE_COUNT:
	; 2D-> 1D 
	mov ax, [BOARD_ROW_SIZE_DW] ; 20x+y
	mul cl
	mov cl, ch
	xor ch, ch
	add ax, cx ; ax: neighbor's position
	
	; Get the neighbor value to NEIGHBORS_COUNTER
	mov bx, ax
	xor cx, cx
	mov cl, [byte ptr si+bx] 	; neighbor's value 
	add [NEIGHBORS_COUNTER], cl

LOOP_CONTROL:
	inc [Y_CORD_TEMP]
	cmp [Y_CORD_TEMP], 2
	jne COUNT_NEIGHBORS
	mov [Y_CORD_TEMP], -1
	inc [X_CORD_TEMP]
	cmp [X_CORD_TEMP], 2
	jne COUNT_NEIGHBORS

	; Subing current cell's value
	xor ax, ax 
	mov bx, [bp+6]
	mov al, [byte ptr si+bx]
	sub [NEIGHBORS_COUNTER], al

	xor ax, ax
	mov al, [NEIGHBORS_COUNTER]

	; End of function
	pop bp
	ret 4
endp CountNeighbors






proc Update
	push bp
	mov bp, sp

	; Local var for temporary matrix
	sub sp, [BOARD_TOTAL_SIZE]
	
	; Getting index ready for loop
	xor ax, ax
	mov cx, [BOARD_TOTAL_SIZE]
	mov si, [bp+4] 				; offset GAME_BOARD
	xor bx, bx 					; index of current cell
	
UPDATE_LOOP:
  	push bx ; Save bx value
	push cx ; Save cx value
	
	mov si ,[bp+4] 		; bp+4: GAME_BOARD
	push bx 			; current index
	push si 			; offset GAME_BOARD
	call CountNeighbors ; result will be at al

	pop cx ; Get cx back
	pop bx ; Get bx back

	mov si ,[bp+4] 			; bp+4: GAME_BOARD
	cmp [byte ptr si+bx], 1 ; Checking if current cell value is 1
	jne CELL_IS_DEAD

CELL_IS_ALIVE:
	; If neighbor value X==2 or X==3 make it alive
	cmp al, 2
	jb KILL_CELL
	cmp al, 3
	ja KILL_CELL 
	mov dl, 1h
	jmp NEXT

KILL_CELL:
	; Kill cell
	mov dl, 0
	jmp NEXT

CELL_IS_DEAD:
	; Checking is neighbor value is 3, if yes relive the cell
	cmp al, 3
	jne KILL_CELL
	mov dl, 1

NEXT:
	; Moving cells value to temp matrix, checking to see if loop is over
	mov si, bp
	sub si, [BOARD_TOTAL_SIZE]
	mov [byte ptr ss:si+bx], dl
	inc bx
	dec cx
	cmp cx, 0
	ja UPDATE_LOOP

	; Getting index ready for loop
	xor dx, dx
	xor bx, bx
	mov cx, [BOARD_TOTAL_SIZE]

MOVING_INTO_GAME_BOARD:

	; Copy temp matrix to real
	mov si, bp
	sub si, [BOARD_TOTAL_SIZE]
	mov dl, [byte ptr ss:si+bx]
	mov si, [bp+4]
	mov [byte ptr si+bx], dl
	inc bx
	loop MOVING_INTO_GAME_BOARD

	; End of function
	add sp, [BOARD_TOTAL_SIZE]
	pop bp
	ret 2
endp Update



START:
	; Fixing dataseg register
	mov ax, @data
	mov ds, ax

	; Init first configuration
	mov [GAME_BOARD + 24], 1
	mov [GAME_BOARD + 72], 1
	mov [GAME_BOARD + 74], 1
	mov [GAME_BOARD + 112], 1
	mov [GAME_BOARD + 113], 1
	mov [GAME_BOARD + 120], 1
	mov [GAME_BOARD + 121], 1
	mov [GAME_BOARD + 134], 1
	mov [GAME_BOARD + 135], 1
	mov [GAME_BOARD + 161], 1
	mov [GAME_BOARD + 165], 1
	mov [GAME_BOARD + 170], 1
	mov [GAME_BOARD + 171], 1
	mov [GAME_BOARD + 184], 1
	mov [GAME_BOARD + 185], 1
	mov [GAME_BOARD + 200], 1
	mov [GAME_BOARD + 201], 1
	mov [GAME_BOARD + 210], 1
	mov [GAME_BOARD + 216], 1
	mov [GAME_BOARD + 220], 1
	mov [GAME_BOARD + 221], 1
	mov [GAME_BOARD + 250], 1
	mov [GAME_BOARD + 251], 1
	mov [GAME_BOARD + 260], 1
	mov [GAME_BOARD + 264], 1
	mov [GAME_BOARD + 266], 1
	mov [GAME_BOARD + 267], 1
	mov [GAME_BOARD + 272], 1
	mov [GAME_BOARD + 274], 1
	mov [GAME_BOARD + 310], 1
	mov [GAME_BOARD + 316], 1
	mov [GAME_BOARD + 324], 1
	mov [GAME_BOARD + 361], 1
	mov [GAME_BOARD + 365], 1
	mov [GAME_BOARD + 412], 1
	mov [GAME_BOARD + 413], 1	


	; MAIN LOOP
	mov cx, [GENERATIONS]

MAIN_LIFE_LOOP:
	push cx ; counter
	
	; Update
	mov bx, offset GAME_BOARD
	push bx
	call Update 

  	; Draw
	mov bx, offset GAME_BOARD
	push bx  
	call Draw

	; Sleep for x sec
	;mov ah, 86h
	;mov cx, 0h
	;mov dx, 4240h
	;int 15h

	pop cx ; counter
  	loop MAIN_LIFE_LOOP

EXIT:
	mov ax, 4C00h
	int 21h

END start