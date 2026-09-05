ORG 100H

    JMP BEGIN

                                                                                                                                                          

    HERO_X DW 90
    HERO_Y DW 160
    SHOT_X DW 90
    SHOT_Y DW 160
    ENEMY_X DW 90
    ENEMY_Y DW 20
    SCOUNTER DW 3
    COLOR DB 00001010b
    SCOLOR DB 00001100B
    ECOLOR DB 00001110b
    COUNTER Dw 20
    SPACE EQU 39H
    ESC EQU 1BH
    RIGHT EQU 4DH
    LEFT EQU  4BH
    
        
    DIRECTION DB 1
    TEMP DB 0 
    
    SHIP_CNT DB 1
    
    DELAY_CNT DB 20
    
    
    MAINMENU db 'mainmenu.bmp',0
    MAINHANDLE dw ?
    MAINHeader db 54 dup (0)
    MAINPalette db 256*4 dup (0)
    MAINScrLine db 320 dup (0)
    ErrorMsg db 'Error', 13, 10,'$'
    
    STORY db 'STORY.bmp',0
    STORYHANDLE dw ?
    STORYHeader db 54 dup (0)
    STORYPalette db 256*4 dup (0)
    STORYScrLine db 320 dup (0)
    
    
;-------------------MACROS-------------------

;--------------------------------------------
ELinePixel MACRO X,Y,CLR, CNT 
local Next
    Mov BX, X
    mov cx, counter
NEXT:
  
    push cx
    PixelON ENEMY_X,ENEMY_Y,ECOLOR
    pop cx
    INC X
    LOOP NEXT
    SUB X, 20 
      
    
ENDM

;--------------------------------------------
ENEMYPIXEL MACRO X, Y, CLR
LOCAL NEXT
    MOV AX, ENEMY_Y
    ADD AX, 8        
NEXT:
    INC Y
    PUSH AX
    ELINEPIXEL ENEMY_X, ENEMY_Y, ECOLOR, COUNTER
    POP AX
    CMP Y, AX
    JNE NEXT
    SUB Y, 8
ENDM


;--------------------HERO------------------- 
;--------------------------------------------
PixelON MACRO X,Y,CLR
	Mov Cx,X       ;y
	Mov Dx,Y       ;x 
	Mov Al,CLR
	Mov AH,0CH
    Int 10h
     
    ENDM
;--------------------------------------------
LinePixel MACRO X,Y,CLR, CNT 
local Next
    Mov BX, X
    mov cx, counter
NEXT:
  
    push cx
    PixelON HERO_X,HERO_Y,COLOR
    pop cx
    INC X
    LOOP NEXT
    SUB X, 20 
      
    
ENDM

;--------------------------------------------
CUBEPIXEL MACRO X, Y, CLR
LOCAL NEXT        
NEXT:
    INC Y
    LINEPIXEL HERO_X, HERO_Y, COLOR, COUNTER
    CMP Y, 168
    JNE NEXT
    SUB Y, 8
ENDM
;--------------------------------------------    
;--------------------HERO--------------------
;--------------------SHOT--------------------
SLinePixel MACRO X,Y,CLR, CNT 
local Next
    Mov BX, X
    mov cx, SCOUNTER
NEXT:
  
    push cx
    PixelON SHOT_X,SHOT_Y,SCOLOR
    pop cx
    INC X
    LOOP NEXT
    SUB X, 3 
      
    
ENDM

;--------------------------------------------
SHOTPIXEL MACRO X, Y, CLR
LOCAL NEXT
    MOV AX, Y
    ADD AX, 8        
NEXT: 
    INC Y
    PUSHA 
    SLINEPIXEL SHOT_X, SHOT_Y, COLOR, SCOUNTER
    POPA
    CMP Y, AX     
    JNE NEXT
    SUB Y, 8
ENDM
                                             
    
;--------------------SHOT--------------------  

DELAY MACRO
PUSH CX
    MOV CX, 2000
    LOOP $
POP CX    
ENDM 

LONGDELAY MACRO TIME
LOCAL AGAIN
PUSHA    
    MOV AL, TIME
    MOV AH, 0
AGAIN:
    DELAY     
    DEC AX
    JNZ AGAIN
POPA    
ENDM


;-------------------MACROS------------------- 

;-------------------BITMAP-------------------
OpenFile MACRO FILENAME, FILEHANDLE
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filename
int 21h
mov [filehandle], ax


ENDM



ReadHeader MACRO FILEHANDLE, HEADER
; Read BMP file header, 54 bytes
mov ah,3fh
mov bx, [filehandle]
mov cx,54
mov dx,offset Header
int 21h

endM
    
ReadPalette MACRO PALETTE
; Read BMP file color palette, 256 colors * 4 bytes (400h)
mov ah,3fh
mov cx,400h
mov dx,offset Palette
int 21h

endM    

CopyPal MACRO PALETTE
LOCAL PALLOOP    
; Copy the colors palette to the video memory registers
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
mov si,offset Palette
mov cx,256
mov dx,3C8h
mov al,0
; Copy starting color to port 3C8h
out dx,al
; Copy palette itself to port 3C9h
inc dx
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB.
mov al,[si+2] ; Get red value.
shr al,2 ; Max. is 255, but video palette maximal
 ; value is 63. Therefore dividing by 4.
out dx,al ; Send it.
mov al,[si+1] ; Get green value.
shr al,2
out dx,al ; Send it.
mov al,[si] ; Get blue value.
shr al,2
out dx,al ; Send it.
add si,4
loop PalLoop

endM


CopyBitmap MACRO SCRLINE
    LOCAL PrintBMPLoop
; BMP graphics are saved upside-down.
; Read the graphic line by line (200 lines in VGA format),
; displaying the lines from bottom to top.
mov ax, 0A000h
mov es, ax
mov cx,200
PrintBMPLoop:
push cx
; di = cx*320, point to the correct screen line
mov di,cx
shl cx,6
shl di,8
add di,cx
; Read one line
mov ah,3fh
mov cx,320
mov dx,offset ScrLine
int 21h
; Copy one line into video memory
cld ; Clear direction flag, for movsb
mov cx,320
mov si,offset ScrLine 
rep movsb ; Copy line to the screen
 ;rep movsb is same as the following code:
 ;mov es:di, ds:si
 ;inc si
 ;inc di
 ;dec cx
 ... ;loop until cx=0
pop cx
loop PrintBMPLoop

endM
;-------------------BITMAP-------------------   
    
    
BEGIN:
CALL GRAFIGMODE

CALL MAINBACK

CALL MOUSEWORK 
     

ESC:    
    CMP DX, 160
    JB COLUMN12
    JMP MOUSE
COLUMN12:
    CMP CX, 330
    JA COLUMN22
    JMP MOUSE                       
COLUMN22:
    CMP CX, 565
    JMP MOUSE 
    
CALL END

;----------------GAME----------------------

GAMESTART:

CALL GRAFIGMODE
MLOOP:

    CALL READ
    JNZ KEYRETRIEVE

    CALL OBJECTPRINT
    CMP ENEMY_Y, 150
    JAE END       
    CMP ENEMY_X, 20
    JA CONTIN
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMY_Y, 10
	
CONTIN:
    CMP ENEMY_X, 300
	JB CONTIN2
	MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMY_Y, 10
CONTIN2:        
    LONGDELAY DELAY_CNT
    CALL DELWINDOW
    CMP DIRECTION, 1
    JE MOVELEFT
    JNE MOVERIGHT

	   

KEYPROCESS:
    CMP AH, RIGHT
    JNE NEXT
    CALL BORDERCHECKR
    CALL MOVEHR
NEXT:
    CMP AH,LEFT
    JNE NEXT2
    CALL BORDERCHECKL
    CALL MOVEHL
NEXT2:
    CMP AH, SPACE
    JNE NEXT3
    CALL SHOT
NEXT3:     
    CALL DELWINDOW
	JMP MLOOP
	
	 
	 
   
;--------------------KEYBOARD-------------------- 



;----------------GAME---------------------- 
        





;----------------SIDE PROGRAMS-------------

PRINTMESSAGE:
    MOV AH, 9
    INT 21H
    RET
    
READ:
    MOV AH, 01H
    INT 16H
    RET
KEYRETRIEVE:
    MOV AH, 00
    INT 16H
    JMP KEYPROCESS
    
GRAFIGMODE:
    MOV AX, 13H
    INT 10H     
    RET


SPLACE:
PUSHA
    MOV AX, HERO_X
    MOV SHOT_X, AX
    MOV AX, HERO_Y
    MOV SHOT_Y, AX
POPA
RET    

SHOT:
CALL SPLACE
PUSHA
SMOVE:
                                                            
    SHOTPIXEL SHOT_X, SHOT_Y, COLOR
    CALL OBJECTPRINT
    
    CMP ENEMY_X, 300
    JB A
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMY_Y, 10
A:
    CMP ENEMY_X, 20
    JA B
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMY_Y, 10

B:
	CMP DIRECTION, 0
	JNE C
	ADD ENEMY_X, 1
C:	
	CMP DIRECTION, 1
	JNE D
	SUB ENEMY_X, 1
D:
    	
	    
    CALL HITCHECK
;---------TEST----------
    MOV AL, DELAY_CNT
    MOV AH, 0
    MOV BL, 2
    DIV BL
;---------TEST----------    
    LONGDELAY AL
    CALL DELWINDOW
    SUB SHOT_Y, 2
    CMP SHOT_Y, 0
    JA SMOVE
POPA
RET 
            
PressKey:

    Mov ah,7
    Int 21h  
    Ret

GotoXY:
                
    Mov Ah,2 
    Mov Bh,0
    Mov Dl,10
    Mov Dh,10
    INT	10h
    Ret
    
    
MOVERIGHT:
	ADD ENEMY_X, 2
	JMP MLOOP
	
MOVELEFT:
	SUB ENEMY_X, 2
	JMP MLOOP

MOVERIGHT2:
	ADD ENEMY_X, 2
	RET
	
MOVELEFT2:
	SUB ENEMY_X, 2
	RET	
	 
    
PixelXY:
	Mov AH,0CH
    Int 10h
    Ret 
TextMode:
    Mov ah,3
    Int 10h  
    Ret
PrintString:

    Mov ah,9
    Int 21h  
    Ret
MOVEHR:
    ADD HERO_X, 2
    RET
MOVEHL:
    SUB HERO_X, 2
    RET
BORDERCHECKR:
    CMP HERO_X, 290
    JAE NEXT2
    RET    
BORDERCHECKL:
    CMP HERO_X , 10
    JBE NEXT2
    RET
DELWINDOW:
    PUSHA
    MOV AH, 06H
    MOV AL, 25
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 40
    INT 10H
    POPA
RET


HITCHECK: 
PUSHA
    MOV BH, 0
    MOV CX, [SHOT_X]
    MOV DX, [SHOT_Y]
    MOV AH, 0DH
    INT 10H
    CALL CLRCMP
POPA
RET

CLRCMP:
    CMP AL, ECOLOR
    JNE DELSHIP
    DEC SHIP_CNT
    CALL LEVELCNG
DELSHIP:
RET 

LEVELCNG:
    CMP SHIP_CNT, 0
    JNE SKIPE
    SUB DELAY_CNT, 2
    ADD SHIP_CNT, 1
    MOV ENEMY_X, 90
    MOV ENEMY_Y, 20
    JMP MLOOP

SKIPE:    
RET

STORYBACK:

CALL DELWINDOW

OpenFile STORY, STORYHANDLE
ReadHeader STORYHANDLE, STORYHEADER
ReadPalette STORYPALETTE
CopyPal STORYPALETTE
CopyBitmap STORYSCRLINE

    mov ax,0h
    int 33h
    MOV AX, 01H
    INT 33H
MOUSE2:
    mov ax,3h
    int 33h
    CMP BX, 1
    JE MCHECKS2
    CMP BX, 0
    JE MOUSE
MCHECKS2:
    CMP DX, 143
    JA BUTTONROW1
    JMP MOUSE2
BUTTONROW1:
    CMP DX, 178
    JB BUTTONROW2
    JMP MOUSE2
BUTTONROW2:
    CMP CX, 10
    JA CHECK1
    JMP MOUSE2
CHECK1:
    CMP CX,302
    JB CHECK2
    JMP MOUSE2
CHECK2:
    CMP CX, 110
    JB BEGIN
    CMP CX, 208
    JA GAMESTART

RET

MAINBACK:
OpenFile MAINMENU, MAINHANDLE
ReadHeader MAINHANDLE, MAINHEADER
ReadPalette MAINPALETTE
CopyPal MAINPALETTE
CopyBitmap MAINSCRLINE
RET

MOUSEWORK:
    mov ax,0h
    int 33h
    MOV AX, 01H
    INT 33H
MOUSE:
    mov ax,3h
    int 33h
    CMP BX, 1
    JE MCHECKS
    CMP BX, 0
    JE MOUSE
MCHECKS: 
    CMP CX, 10
    JA BUTTONCOLUMN1
    JMP MOUSE 
BUTTONCOLUMN1:
    CMP CX, 200
    JB BUTTONCHECK
    JMP MOUSE
BUTTONCHECK:
    CMP DX, 10
    JA NEXTCHECK
NEXTCHECK:
    CMP DX, 145
    JB EXITCHECK
    JMP MOUSE
EXITCHECK:
    CMP DX, 105
    JA End
PLAYCHECK:  
    CMP DX, 65
    JB STORYBACK
RULESCHECK:
    CMP DX, 60
    JA RULESCHECK2
    JMP MOUSE
RULESCHECK2:
    CMP DX,97
;    JB RULES
    JMP MOUSE
        
RET

OBJECTPRINT:
    CUBEPIXEL HERO_X, HERO_Y, COLOR
    CMP SHIP_CNT, 0
    JE SKIP
    ENEMYPIXEL ENEMY_X, ENEMY_Y, ECOLOR
SKIP:

RET



END:

    MOV AH, 4CH
    INT 21H
            
         
;----------------SIDE PROGRAMS-------------