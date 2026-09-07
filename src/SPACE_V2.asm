ORG 100H

    JMP BEGIN

;-----------------------VARIABLES------------------                                                                                                                                                          
;-----------------------------
    HERO_X DW 90             ;
    HERO_Y DW 160            ;
    SHOT_X DW 90             ;
    SHOT_Y DW 160            ;
    SCOUNTER DW 3            ;
    COLOR DB 00001010b       ;
    SCOLOR DB 00001100B      ;
    COUNTER Dw 20            ;    OBJECT VARIABLES
                             ;
    ENEMYA_CLR DB 00001110B  ;
    ENEMYA_Y DW 30           ;
    ENEMY1 DW 1, 30          ;
    ENEMY2 DW 1, 70          ;
    ENEMY3 DW 1, 110         ;
    ENEMY4 DW 1, 150         ;
    ENEMY5 DW 1, 190         ;
    XPOINTER DW 2            ;
                             ;
    DIRECTION DB 1           ;
    TEMP DB 0                ;
    SHIP_CNT DB 5            ;
    DELAY_CNT DB 50          ;
    LEFTBORDER DW 20         ;
    RIGHTBORDER DW 300       ;
    BORDERTEMP DW 0          ;
                             ;
                             ;
                             ;
;-----------------------------    
    
;-------------------    
    SPACE EQU 39H   ;
    RIGHT EQU 4DH   ; SCAN CODES 
    LEFT EQU  4BH   ;
;-------------------

    
;------------------------------------    
    MAINMENU db 'mainmenu.bmp',0    ;
    MAINHANDLE dw ?                 ;
    MAINHeader db 54 dup (0)        ;
    MAINPalette db 256*4 dup (0)    ;
    MAINScrLine db 320 dup (0)      ;
    ErrorMsg db 'Error', 13, 10,'$' ;
                                    ;
    filename2 db 'STORY.bmp',0      ;
    filehandle2 dw ?                ;
    Header2 db 54 dup (0)           ;
    Palette2 db 256*4 dup (0)       ;
    ScrLine2 db 320 dup (0)         ;   BITMAP VARIABLES
                                    ;
    black db 'black.bmp',0          ;
    blackhandle dw ?                ;
    bHeader db 54 dup (0)           ;
    bPalette db 256*4 dup (0)       ;
    bScrLine db 320 dup (0)         ;
                                    ;
    rules db 'rules.bmp',0          ;
    ruleshandle dw ?                ;
    rHeader db 54 dup (0)           ;
    rPalette db 256*4 dup (0)       ;
    rScrLine db 320 dup (0)         ;
                                    ;
    GAMEWIN db 'GAMEOVER.bmp',0     ;
    WINHANDLE dw ?                  ;
    WINHeader db 54 dup (0)         ;
    WINPalette db 256*4 dup (0)     ;
    WINScrLine db 320 dup (0)       ;
                                    ;
    GAMELOSE db 'lose.bmp',0        ;
    LOSEHANDLE dw ?                 ;
    LOSEHeader db 54 dup (0)        ;
    LOSEPalette db 256*4 dup (0)    ;
    LOSEScrLine db 320 dup (0)      ;
;------------------------------------                                   

;--------------;    
ESCORE DW 0    ;        
DIGIT1 DW ?    ;   SCORING MECHANISM
DIGIT2 DW ?    ;
DIGIT3 DW ?    ;
;--------------;
;-----------------------VARIABLES------------------


;------------------------------------MACROS---------------------------- 


;-------------------------
VARRESET PROC            ;
                         ;
    MOV ESCORE, 0        ;
    CALL GRAFIGMODE      ;
    MOV COUNTER, 20      ;
    MOV SHIP_CNT, 5      ;
    MOV [ENEMY1], 1      ;
    MOV [ENEMY2], 1      ;
    MOV [ENEMY3], 1      ;
    MOV [ENEMY4], 1      ;
    MOV [ENEMY5], 1      ;
                         ;   RESTARTING VERIABLES
    MOV ENEMYA_Y, 30     ;
    MOV [ENEMY1+2], 30   ;
	MOV [ENEMY2+2], 70   ;
	MOV [ENEMY3+2], 110  ;
	MOV [ENEMY4+2], 150  ;
	MOV [ENEMY5+2], 190  ;
                         ; 
	mov direction, 1     ;
	MOV TEMP, 0          ;
	                     ;
	MOV DELAY_CNT, 50    ;
	RET                  ;
	ENDP VARRESET        ;
;-------------------------

;----------------------------------------------
ELinePixel MACRO X,Y,CLR, CNT                 ;
local Next                                    ;
    mov cx, CNT                               ;
NEXT:                                         ;
                                              ;
    push cx                                   ;
    PixelON BX,ENEMYA_Y,ENEMYA_CLR            ;
    pop cx                                    ;
    INC BX                                    ;
    LOOP NEXT                                 ;
    SUB X, 20                                 ;
                                              ;
                                              ;
ENDM                                          ;
                                              ;
;-------------------------------------------- ;
ENEMYPIXEL MACRO ARRAY                        ;  ENEMY GRAPHICS
LOCAL NEXT                                    ;
    MOV BX, OFFSET ARRAY                      ;
    ADD BX, XPOINTER                          ;
    MOV BX, [BX]                              ;
                                              ;
    MOV AX, ENEMYA_Y                          ;
    ADD AX, 8                                 ;
NEXT:                                         ;
    INC ENEMYA_Y                              ;
    PUSH AX                                   ;
    ELINEPIXEL BX, ENEMYA_Y, ENEMYA_CLR, 20   ;
    POP AX                                    ;
    CMP ENEMYA_Y, AX                          ;
    JNE NEXT                                  ;
    SUB ENEMYA_Y, 8                           ;
ENDM                                          ;
;----------------------------------------------

 
;----------------------------------------------
PixelON MACRO X,Y,CLR                         ;
	Mov Cx,X       ;y                         ;   
	Mov Dx,Y       ;x                         ;
	Mov Al,CLR                                ;
	Mov AH,0CH                                ;
    Int 10h                                   ;
                                              ;
    ENDM                                      ;
;-------------------------------------------- ;
LinePixel MACRO X,Y,CLR, CNT                  ;
local Next                                    ;
    Mov BX, X                                 ;
    mov cx, counter                           ;
NEXT:                                         ;  
                                              ;
    push cx                                   ;
    PixelON HERO_X,HERO_Y,COLOR               ;
    pop cx                                    ;
    INC X                                     ;
    LOOP NEXT                                 ;   HERO GRAPHICS
    SUB X, 20                                 ;
                                              ;
                                              ;
ENDM                                          ;
                                              ;
;-------------------------------------------- ;
CUBEPIXEL MACRO X, Y, CLR                     ;
LOCAL NEXT                                    ;
NEXT:                                         ;
    INC Y                                     ;
    LINEPIXEL HERO_X, HERO_Y, COLOR, COUNTER  ;
    CMP Y, 168                                ;
    JNE NEXT                                  ;
    SUB Y, 8                                  ;
ENDM                                          ;
;----------------------------------------------


;-----------------------------------------------
SLinePixel MACRO X,Y,CLR, CNT                  ;
local Next                                     ;
    Mov BX, X                                  ;
    mov cx, SCOUNTER                           ;
NEXT:                                          ;
                                               ;
    push cx                                    ;
    PixelON SHOT_X,SHOT_Y,SCOLOR               ;
    pop cx                                     ;
    INC X                                      ;
    LOOP NEXT                                  ;
    SUB X, 3                                   ;
                                               ;
                                               ;
ENDM                                           ;
                                               ;  SHOOTING GRAPHICS
;--------------------------------------------  ;
SHOTPIXEL MACRO X, Y, CLR                      ;
LOCAL NEXT                                     ;
    MOV AX, Y                                  ;
    ADD AX, 8                                  ;
NEXT:                                          ;
    INC Y                                      ;
    PUSHA                                      ;
    SLINEPIXEL SHOT_X, SHOT_Y, COLOR, SCOUNTER ;
    POPA                                       ;
    CMP Y, AX                                  ;
    JNE NEXT                                   ;
    SUB Y, 8                                   ;
ENDM                                           ;
;-----------------------------------------------                                             
    




;-----------------------
DELAY MACRO            ;
PUSH CX                ;
    MOV CX, 2000       ;
    LOOP $             ;
POP CX                 ;
ENDM                   ;
                       ;
LONGDELAY MACRO TIME   ;
LOCAL AGAIN            ;
PUSHA                  ;  DELAY CONTROL
    MOV AL, TIME       ;
    MOV AH, 0          ;
AGAIN:                 ;
    DELAY              ;
    DEC AX             ;
    JNZ AGAIN          ;
POPA                   ;
ENDM                   ;
;-----------------------
                                              
;----------------------------------------------
BORDERCHECK MACRO BORDER, BORDERTEMP          ;
LOCAL SKIP                                    ;
LOCAL AGAIN                                   ;
    MOV BL, 200                               ;
AGAIN:                                        ;
    MOV BH, 0                                 ;
    MOV CX, [BORDER]                          ;
    MOV DX, [BORDERTEMP]                      ;
    MOV AH, 0DH                               ;
    INT 10H                                   ;
    CMP AL, ENEMYA_CLR                        ;
    JNE SKIP                                  ;
    MOV AL, DIRECTION                         ;
	MOV AH, TEMP                              ;
	MOV DIRECTION, AH                         ;   
	MOV TEMP, AL                              ;
	ADD ENEMYA_Y, 10                          ;
    JMP BORDERHIT                             ;
SKIP:                                         ;
    INC BORDERTEMP                            ;
    DEC BL                                    ;
    JNZ AGAIN                                 ;
    MOV BORDERTEMP, 0	                      ;
ENDM                                          ;
                                              ;
SBORDERCHECK MACRO BORDER, BORDERTEMP         ;
LOCAL SKIP                                    ;
LOCAL AGAIN                                   ;  GAME BORDERS
    MOV BL, 200                               ;
AGAIN:                                        ;
    MOV BH, 0                                 ;
    MOV CX, [BORDER]                          ;
    MOV DX, [BORDERTEMP]                      ;
    MOV AH, 0DH                               ;
    INT 10H                                   ;
    CMP AL, ENEMYA_CLR                        ;
    JNE SKIP                                  ;
    MOV AL, DIRECTION                         ;
	MOV AH, TEMP                              ;
	MOV DIRECTION, AH                         ;
	MOV TEMP, AL                              ;
	ADD ENEMYA_Y, 10                          ;
    JMP SBORDERHIT                            ;
SKIP:                                         ;
    INC BORDERTEMP                            ;
    DEC BL                                    ;
    JNZ AGAIN                                 ;
    MOV BORDERTEMP, 0	                      ;
ENDM                                          ;
                                              ;
                                              ;
                                              ;
                                              ;
;---------------------------------------------- 

                                              

;------------------------------------MACROS----------------------------




;------------------------PROCCESSES-------------------

;----------------------------------------------
DISPLAYSCORE PROC                             ;
PUSHA                                         ;
    push    cs                                ;
    pop     es                                ;
                                              ;
    XOR BX, BX                                ;
                                              ;
    MOV AX, ESCORE                            ;
    MOV BL, 10                                ;
    DIV BL                                    ;
                                              ;
    MOV BYTE PTR [DIGIT1], AH                 ;
    MOV BYTE PTR [DIGIT2], AL                 ;
                                              ;
    ADD DIGIT1, 48                            ;
                                              ;
                                              ;
                                              ;
    mov     bh, 0    ; page.                  ;
    lea     bp, DIGIT1  ; offset.             ;
    mov     bl, 00001111B ; default attribute.;
    mov     cx, 1   ; char number.            ;
    mov     dl, 4    ; col.                   ;
    mov     dh, 1    ; row.                   ;
    mov     ah, 13h  ; function.              ;
    mov     al, 1    ; sub-function.          ;
    int     10h                               ;
                                              ;
    MOV AX, DIGIT2                            ;  SCORE DISPLAYING
    MOV BL, 10                                ;
    DIV BL                                    ;
                                              ;
    MOV BYTE PTR [DIGIT2], AH                 ;
    MOV BYTE PTR [DIGIT3], AL                 ;
                                              ;
    ADD DIGIT2, 48                            ;
    ADD DIGIT3, 48                            ;
                                              ;
    mov     bh, 0    ; page.                  ;
    lea     bp, DIGIT2  ; offset.             ;
    mov     bl, 00001111B ; default attribute.;
    mov     cx, 1   ; char number.            ;
    mov     dl, 3    ; col.                   ;
    mov     dh, 1    ; row.                   ;
    mov     ah, 13h  ; function.              ;
    mov     al, 1    ; sub-function.          ;
    int     10h                               ;
                                              ;
                                              ;
    mov     bh, 0    ; page.                  ;
    lea     bp, DIGIT3  ; offset.             ;
    mov     bl, 00001111B ; default attribute.;
    mov     cx, 1   ; char number.            ;
    mov     dl, 2    ; col.                   ;
    mov     dh, 1    ; row.                   ;
    mov     ah, 13h  ; function.              ;
    mov     al, 1    ; sub-function.          ;
    int     10h                               ;
POPA                                          ;
RET                                           ;
ENDP DISPLAYSCORE                             ;
;----------------------------------------------

                                             
                                              
                                              
;-------------------MENUS---------------------


;---------------------------------- 
WIN PROC                          ;
                                  ;
OpenFile GAMEWIN, WINHANDLE       ;
ReadHeader WINHANDLE, WINHEADER   ;
ReadPalette WINPALETTE            ;
CopyPal WINPALETTE                ;
CopyBitmap WINSCRLINE             ;
                                  ;
mov ax,0h                         ;
    int 33h                       ;
    MOV AX, 01H                   ;
    INT 33H                       ;
WINMOUSE:                         ;
    mov ax,3h                     ;
    int 33h                       ;
    CMP BX, 1                     ;
    JE WCHECKSR                   ;
    CMP BX, 0                     ;
    JE WINMOUSE                   ;
WCHECKSR:                         ;
    CMP DX, 142                   ;
    JAE WINRCHECK2                ;
    JMP WINMOUSE                  ;
WINRCHECK2:                       ;    WIN MENU
    CMP DX, 178                   ;
    JBE MAINCHECK1                ;
    JMP WINMOUSE                  ;
MAINCHECK1:                       ;
    CMP CX, 10                    ;
    JA MAINCHECK2                 ;
    JMP WINMOUSE                  ;
MAINCHECK2:                       ;
    CMP CX, 210                   ;
    JB BEGIN                      ;
    CMP CX,416                    ;
    JA AGANCHECK2                 ;
AGANCHECK2:                       ;
    CMP CX,608                    ;
    JB GAMESTART                  ;
    JMP WINMOUSE                  ;
                                  ;
RET                               ;
ENDP GAMEWIN                      ;
;----------------------------------


;----------------------------------
LOSE PROC                         ;
                                  ;
OpenFile GAMELOSE, LOSEHANDLE     ;
ReadHeader LOSEHANDLE, LOSEHEADER ;
ReadPalette LOSEPALETTE           ;
CopyPal LOSEPALETTE               ;
CopyBitmap LOSESCRLINE            ;
                                  ;
    mov ax,0h                     ;
    int 33h                       ;
    MOV AX, 01H                   ;
    INT 33H                       ;
LOSEMOUSE:                        ;
    mov ax,3h                     ;
    int 33h                       ;
    CMP BX, 1                     ;
    JE LCHECKSR                   ;
    CMP BX, 0                     ;
    JE LOSEMOUSE                  ;
LCHECKSR:                         ;
    CMP DX, 142                   ;
    JAE LOSERCHECK2               ;
    JMP LOSEMOUSE                 ;
LOSERCHECK2:                      ;
    CMP DX, 178                   ;  LOSE MENU
    JBE LOSECHECK1                ;
    JMP LOSEMOUSE                 ;
LOSECHECK1:                       ;
    CMP CX, 10                    ;
    JA LOSECHECK2                 ;
    JMP LOSEMOUSE                 ;
LOSECHECK2:                       ;
    CMP CX, 210                   ;
    JB EXITSCREEN                 ;
    CMP CX,416                    ;
    JA AGANLOSECHECK2             ;
AGANLOSECHECK2:                   ;
    CMP CX,608                    ;
    JB GAMESTART                  ;
    JMP LOSEMOUSE                 ;
                                  ;
RET                               ;
ENDP LOSE                         ;
;----------------------------------


;-----------------------------------                                  
STORY PROC                         ;
    OpenFile FILENAME2, FILEHANDLE2;
    ReadHeader FILEHANDLE2, HEADER2;
    ReadPalette PALETTE2           ;
    CopyPal PALETTE2               ;
    CopyBitmap SCRLINE2            ;
                                   ;
    mov ax,0h                      ;
    int 33h                        ;
    MOV AX, 01H                    ;
    INT 33H                        ;
STORYMOUSE:                        ;
    mov ax,3h                      ;
    int 33h                        ;
    CMP BX, 1                      ;
    JE MCHECKSR                    ;
    CMP BX, 0                      ;
    JE STORYMOUSE                  ;
MCHECKSR:                          ;
    CMP DX, 142                    ;
    JAE ROWCHECK2                  ;
    JMP STORYMOUSE                 ;
ROWCHECK2:                         ;
    CMP DX, 178                    ;
    JBE NOCHECK1                   ;  STORY MENU
    JMP STORYMOUSE                 ;
NOCHECK1:                          ;
    CMP CX, 10                     ;
    JA NOCHECK2                    ;
    JMP STORYMOUSE                 ;
NOCHECK2:                          ;
    CMP CX, 210                    ;
    JB BEGIN                       ;
    CMP CX,416                     ;
    JA YESCHECK2                   ;
YESCHECK2:                         ;
    CMP CX,608                     ;
    JB GAMESTART                   ;
    JMP STORYMOUSE                 ;
                                   ;
                                   ;
RET                                ;
ENDP STORY                         ;
;-----------------------------------                                  


;------------------------------------
EXITSCREEN PROC                     ;
    OpenFile BLACK, BLACKHANDLE     ;
    ReadHeader BLACKHANDLE, BHEADER ;
    ReadPalette BPALETTE            ;
    CopyPal BPALETTE                ;   EXIT MENU
    CopyBitmap BSCRLINE             ;
                                    ;
                                    ;
                                    ;
    CALL END                        ;
                                    ;
RET                                 ;
ENDP EXITSCREEN                     ;
;------------------------------------

;------------------------------------
MAINBACK PROC                       ;
OpenFile MAINMENU, MAINHANDLE       ;
ReadHeader MAINHANDLE, MAINHEADER   ;
ReadPalette MAINPALETTE             ;
CopyPal MAINPALETTE                 ;
CopyBitmap MAINSCRLINE              ;
                                    ;
    mov ax,0h                       ;
    int 33h                         ;
    MOV AX, 01H                     ;
    INT 33H                         ;
MOUSE:                              ;
    mov ax,3h                       ;
    int 33h                         ;
    CMP BX, 1                       ;
    JE MCHECKS                      ;
    CMP BX, 0                       ;
    JE MOUSE                        ;
MCHECKS:                            ;
    CMP CX, 10                      ;
    JA BUTTONCOLUMN1                ;
    JMP MOUSE                       ;
BUTTONCOLUMN1:                      ;
    CMP CX, 200                     ;
    JB BUTTONCHECK                  ;
    JMP MOUSE                       ;
BUTTONCHECK:                        ;
    CMP DX, 10                      ;  MAIN MENU
    JA NEXTCHECK                    ;
NEXTCHECK:                          ;
    CMP DX, 145                     ;
    JB EXITCHECK                    ;
    JMP MOUSE                       ;
EXITCHECK:                          ;
    CMP DX, 105                     ;
    Jb PLAYCHECK                    ;
    CALL EXITSCREEN                 ;
    CALL END                        ;
PLAYCHECK:                          ;
    CMP DX, 65                      ;
    JAE RULESCHECK                  ;
    CALL STORY                      ;
RULESCHECK:                         ;
    CMP DX, 60                      ;
    JA RULESCHECK2                  ;
    JMP MOUSE                       ;
RULESCHECK2:                        ;
    CMP DX,97                       ;
    JA SKIPRULES                    ;
    CALL RULESSCREEN                ;
SKIPRULES:                          ;
    JMP MOUSE                       ;
                                    ;
RET                                 ;
ENDP MAINBACK                       ;
;------------------------------------



;------------------------------------
rulesSCREEN PROC                    ;
OpenFile RULES, RULESHANDLE         ;
ReadHeader RULESHANDLE, RHEADER     ;
ReadPalette RPALETTE                ;
CopyPal RPALETTE                    ;
CopyBitmap RSCRLINE                 ;
                                    ;
                                    ;
    mov ax,0h                       ;
    int 33h                         ;
    MOV AX, 01H                     ;
    INT 33H                         ;
RULESMOUSE:                         ;
    mov ax,3h                       ;
    int 33h                         ;
    CMP BX, 1                       ;
    JE MCHECKRR                     ;
    CMP BX, 0                       ;
    JE RULESMOUSE                   ;
MCHECKRR:                           ;
    CMP DX, 142                     ;
    JAE SROWCHECK2                  ;  RULES MENU
    JMP RULESMOUSE                  ;
SROWCHECK2:                         ;
    CMP DX, 178                     ;
    JBE SNOCHECK1                   ;
    JMP RULESMOUSE                  ;
SNOCHECK1:                          ;
    CMP CX, 10                      ;
    JA SNOCHECK2                    ;
    JMP RULESMOUSE                  ;
SNOCHECK2:                          ;
    CMP CX, 210                     ;
    JB BEGIN                        ;
    CMP CX,416                      ;
    JA SYESCHECK2                   ;
SYESCHECK2:                         ;
    CMP CX,608                      ;
    JB GAMESTART                    ;
    JMP RULESMOUSE                  ;
                                    ;
RET                                 ;
ENDP rulesSCREEN                    ;
;------------------------------------
;-------------------MENUS---------------------

;-------------------BITMAP--------------------
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

;-------------------BITMAP--------------------  
    
;------------------------PROCCESSES-------------------

    
BEGIN:
CALL GRAFIGMODE

CALL MAINBACK
 
MOV ESCORE, 0     

;----------------GAME----------------------

GAMESTART:

call VARRESET	; RESET VARIABLES

;-------------------------MAIN LOOP---------------
MLOOP:

    CALL READ         ; INPUT WITH NO ECHO INTO BUFFER
    JNZ KEYRETRIEVE
    
    CALL OBJECTPRINT   ;PRINT ALL NEEDED OBJECTS

    CMP ENEMYA_Y, 150  ;IF LOSE
    JB SKIPLOSE
    
    CALL LOSE
    
SKIPLOSE:    


    BORDERCHECK LEFTBORDER, BORDERTEMP     ; GAME SIDE BORDERS
    BORDERCHECK RIGHTBORDER, BORDERTEMP    ;
BORDERHIT:        
    LONGDELAY DELAY_CNT                    ;DELAY BETWEEN PRINTS
    CALL DELWINDOW                         ;CLEAR SCREEN EACH CYCLE
    CMP DIRECTION, 1                     ;ENEMY MOVE DIRECTION
    JE MOVELEFT
    JNE MOVERIGHT

	   
;----------------------------
KEYPROCESS:                 ;
    CMP AH, RIGHT           ;
    JNE NEXT                ;
    CALL BORDERCHECKR       ;
    CALL MOVEHR             ;
NEXT:                       ;
    CMP AH,LEFT             ;
    JNE NEXT2               ;  KEY COMPARE AND RETRIEVAL FROM BUFFER
    CALL BORDERCHECKL       ;
    CALL MOVEHL             ;
NEXT2:                      ;
    CMP AH, SPACE           ;
    JNE NEXT3               ;
    CALL SHOT               ;
NEXT3:                      ;
    CALL DELWINDOW          ;
	JMP MLOOP               ;
;----------------------------

	
;-------------------------MAIN LOOP---------------

        





;----------------SIDE PROGRAMS-------------



;-------------------------------------------
SPLACE:                                    ;
PUSHA                                      ;
    MOV AX, HERO_X                         ;
    MOV SHOT_X, AX                         ;
    MOV AX, HERO_Y                         ;
    MOV SHOT_Y, AX                         ;
    ADD SHOT_X, 8                          ;
POPA                                       ;
RET                                        ;
                                           ;
SHOT:                                      ;
CALL SPLACE                                ;
PUSHA                                      ;
SMOVE:                                     ;
                                           ;                 
    SHOTPIXEL SHOT_X, SHOT_Y, COLOR        ;
    CALL OBJECTPRINT                       ;
                                           ;
    SBORDERCHECK LEFTBORDER, BORDERTEMP    ;
    SBORDERCHECK RIGHTBORDER, BORDERTEMP   ;
    CMP ENEMYA_Y, 150                      ;
    JB SBORDERHIT                          ;
    CALL LOSE                              ;
                                           ;
SBORDERHIT:                                ;
	CMP DIRECTION, 0                       ;
	JNE X                                  ;
	ADD [ENEMY1+2], 2                      ;   SHOT MECHANICS  
	ADD [ENEMY2+2], 2                      ;
	ADD [ENEMY3+2], 2                      ;
	ADD [ENEMY4+2], 2                      ;
	ADD [ENEMY5+2], 2                      ;
X:	                                       ;
	CMP DIRECTION, 1                       ;
	JNE K                                  ;
	SUB [ENEMY1+2], 2                      ;
	SUB [ENEMY2+2], 2                      ;
	SUB [ENEMY3+2], 2                      ;
	SUB [ENEMY4+2], 2                      ;
	SUB [ENEMY5+2], 2                      ;
K:                                         ;
    	                                   ;
	                                       ;
    CALL HITCHECK                          ;
                                           ;
    LONGDELAY DELAY_CNT                    ;
    CALL DELWINDOW                         ;
    SUB SHOT_Y, 4                          ;
    CMP SHOT_Y, 0                          ;
    JA SMOVE                               ;
POPA                                       ;
RET                                        ;
;-------------------------------------------

                                       
;----------------------                                           
MOVERIGHT:            ;
	ADD [ENEMY1+2], 2 ;
	ADD [ENEMY2+2], 2 ;
	ADD [ENEMY3+2], 2 ;
	ADD [ENEMY4+2], 2 ;
	ADD [ENEMY5+2], 2 ;
	JMP MLOOP         ;
	                  ;   ENEMY MECHANICS
MOVELEFT:             ;
	SUB [ENEMY1+2], 2 ;
	SUB [ENEMY2+2], 2 ;
	SUB [ENEMY3+2], 2 ;
	SUB [ENEMY4+2], 2 ;
	SUB [ENEMY5+2], 2 ;
	JMP MLOOP         ;
;----------------------


;--------------------------
MOVEHR:                   ;
    ADD HERO_X, 2         ;
    RET                   ;
MOVEHL:                   ;
    SUB HERO_X, 2         ;
    RET                   ;
BORDERCHECKR:             ;
    CMP HERO_X, 290       ;
    JAE NEXT2             ;
    RET                   ;
BORDERCHECKL:             ;
    CMP HERO_X , 10       ;
    JBE NEXT2             ;
    RET                   ;  HERO MECHANICS
DELWINDOW:                ;  
    PUSHA                 ;
    MOV AH, 06H           ;
    MOV AL, 25            ;
    MOV BH, 00H           ;
    MOV CH, 0             ;
    MOV CL, 0             ;
    MOV DH, 24            ;
    MOV DL, 40            ;
    INT 10H               ;
    POPA                  ;
RET                       ;
;--------------------------


;-----------------------------
HITCHECK:                    ;
PUSHA                        ;
    MOV BH, 0                ;
    MOV CX, [SHOT_X]         ;
    MOV DX, [SHOT_Y]         ;
    MOV AH, 0DH              ;
    INT 10H                  ;
    CALL CLRCMP              ;
POPA                         ;
RET                          ;
                             ;
CLRCMP:                      ;
    CMP AL, ENEMYA_CLR       ;
    JNE DELSHIP              ;
                             ;
    ADD ESCORE, 1            ;
                             ;
    MOV AX, SHOT_X           ;
    CMP AX, [ENEMY5+2]       ;
    JB CHECK2                ;
    MOV [ENEMY5], 0          ;
    DEC SHIP_CNT             ;
    JMP MLOOP                ;
CHECK2:                      ;
    CMP AX, [ENEMY4+2]       ;
    JB CHECK3                ;
    MOV [ENEMY4], 0          ;  SHOT HIT MECHANICS
    DEC SHIP_CNT             ;
    JMP MLOOP                ;
CHECK3:                      ;
    CMP AX, [ENEMY3+2]       ;
    JB CHECK4                ;
    MOV [ENEMY3], 0          ;
    DEC SHIP_CNT             ;
    JMP MLOOP                ;
CHECK4:                      ;
    CMP AX, [ENEMY2+2]       ;
    JB CHECK5                ;
    MOV [ENEMY2], 0          ;
    DEC SHIP_CNT             ;
    JMP MLOOP                ;
CHECK5:                      ;
    MOV [ENEMY1], 0         ;
    DEC SHIP_CNT             ;
                             ;
                             ;
                             ;
                             ;
                             ;
    JMP MLOOP                ;
                             ;
    DELSHIP:                 ;
RET                          ;
;-----------------------------


;-----------------------------
LEVELCNG:                    ;
PUSHA                        ;
                             ;
    SUB DELAY_CNT, 10        ;
                             ;
    MOV SHIP_CNT, 5          ;
    MOV [ENEMY1], 1          ;
    MOV [ENEMY2], 1          ;
    MOV [ENEMY3], 1          ;
    MOV [ENEMY4], 1          ;
    MOV [ENEMY5], 1          ;    LEVEL CHANGE
                             ;
    MOV ENEMYA_Y, 30         ;
    MOV [ENEMY1+2], 30       ;
	MOV [ENEMY2+2], 70       ;
	MOV [ENEMY3+2], 110      ;
	MOV [ENEMY4+2], 150      ;
	MOV [ENEMY5+2], 190      ;
                             ;
POPA                         ;
RET                          ;
;-----------------------------



;------------------------------------
OBJECTPRINT:                        ;
    CALL DISPLAYSCORE               ;
    CUBEPIXEL HERO_X, HERO_Y, COLOR ;
    CMP [ENEMY1], 0                 ;
    JE SKIP1                        ;
    ENEMYPIXEL ENEMY1               ;
SKIP1:                              ;
    CMP [ENEMY2], 0                 ;
    JE SKIP2                        ;
    ENEMYPIXEL ENEMY2               ;
SKIP2:                              ;
    CMP [ENEMY3], 0                 ;
    JE SKIP3                        ;
    ENEMYPIXEL ENEMY3               ;
SKIP3:                              ;
    CMP [ENEMY4], 0                 ;
    JE SKIP4                        ;
    ENEMYPIXEL ENEMY4               ;
SKIP4:                              ;
    CMP [ENEMY5], 0                 ;
    JE SKIP5                        ;
    ENEMYPIXEL ENEMY5               ;  OBJECTS TO PRINT
SKIP5:                              ;
                                    ;
                                    ;
    CMP SHIP_CNT, 0                 ;
    JNE LEVELCNGSKIP                ;
    CALL LEVELCNG                   ;
    LEVELCNGSKIP:                   ;
                                    ;
                                    ;
    CMP ESCORE, 25                  ;
    JNE WINSKIP                     ;
                                    ;
    CALL WIN                        ;
    WINSKIP:                        ;
                                    ;
RET                                 ;
;------------------------------------

;------------------------    
PixelXY:                ;
	Mov AH,0CH          ;
    Int 10h             ;
    Ret                 ;
TextMode:               ;
    Mov ah,3            ;
    Int 10h             ;
    Ret                 ;
PrintString:            ;
                        ;
    Mov ah,9            ;
    Int 21h             ;
    Ret                 ;
                        ;
READ:                   ;
    MOV AH, 01H         ;
    INT 16H             ;
    RET                 ;
KEYRETRIEVE:            ;
    MOV AH, 00          ;
    INT 16H             ;
    JMP KEYPROCESS      ;
                        ;  ASSEMBLY ACTIONS INT
GRAFIGMODE:             ;
    MOV AX, 13H         ;
    INT 10H             ;
    RET                 ;
                        ;
GotoXY:                 ;
                        ;
    Mov Ah,2            ;
    Mov Bh,0            ;
    Mov Dl,10           ;
    Mov Dh,10           ;
    INT	10h             ;
    Ret                 ;
                        ;
                        ;
END:                    ;
                        ;
    MOV AH, 4CH         ;
    INT 21H             ;
;------------------------    
         
;----------------SIDE PROGRAMS-------------