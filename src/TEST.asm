ORG 100H

    JMP BEGIN

ENEMYA_CLR DB 00001110B
ENEMYA_Y DW 30
    
ENEMY1 DW 1, 30

ENEMY2 DW 1, 70

ENEMY3 DW 1, 110

ENEMY4 DW 1, 150

ENEMY5 DW 1, 190

XPOINTER DW 2

    
    DIRECTION DB 1
    
    TEMP DB 0
    
    SHIP_CNT DB 1
    
    DELAY_CNT DB 20  

    
        
    
    
;-------------------MACROS-------------------

;--------------------------------------------
ELinePixel MACRO X,Y,CLR, CNT 
local Next
    mov cx, CNT
NEXT:
  
    push cx
    PixelON BX,ENEMYA_Y,ENEMYA_CLR
    pop cx
    INC BX
    LOOP NEXT
    SUB X, 20 
      
    
ENDM

;--------------------------------------------
ENEMYPIXEL MACRO ARRAY
LOCAL NEXT
    MOV BX, OFFSET ARRAY
    ADD BX, XPOINTER
    MOV BX, [BX]
    
    MOV AX, ENEMYA_Y
    ADD AX, 8        
NEXT:
    INC ENEMYA_Y
    PUSH AX
    ELINEPIXEL BX, ENEMYA_Y, ENEMYA_CLR, 20
    POP AX
    CMP ENEMYA_Y, AX
    JNE NEXT
    SUB ENEMYA_Y, 8
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


BEGIN:

CALL GRAFIGMODE
MLOOP:

    CALL OBJECTPRINT
    CMP ENEMYA_Y, 150
    JAE END
    MOV BX, OFFSET ENEMY1
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 20
    JA A
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
A:    
    MOV BX, OFFSET ENEMY2
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 20
    JA B
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
B:
     MOV BX, OFFSET ENEMY3
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 20
    JA C
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
C:
    MOV BX, OFFSET ENEMY4
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 20
    JA D
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
D: 
    MOV BX, OFFSET ENEMY5
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 20
    JA E
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
E:


    MOV BX, OFFSET ENEMY1
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 280
    JB F
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
F:    
    MOV BX, OFFSET ENEMY2
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 280
    JB G
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
G:  
    MOV BX, OFFSET ENEMY3
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 280
    JB H
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
H:  
    MOV BX, OFFSET ENEMY4
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 280
    JB I
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
I:   
    MOV BX, OFFSET ENEMY5
    ADD BX, XPOINTER
    MOV BX, [BX]       
    CMP BX, 280
    JB J
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
J: 
        
    LONGDELAY DELAY_CNT
    CALL DELWINDOW
    CMP DIRECTION, 1
    JE MOVELEFT
    JNE MOVERIGHT

JMP MLOOP

DIRCNG:
PUSHA
    MOV AL, DIRECTION
	MOV AH, TEMP
	MOV DIRECTION, AH
	MOV TEMP, AL
	ADD ENEMYA_Y, 10
POPA

RET
    
MOVERIGHT:
	ADD [ENEMY1+2], 2
	ADD [ENEMY2+2], 2
	ADD [ENEMY3+2], 2
	ADD [ENEMY4+2], 2
	ADD [ENEMY5+2], 2
	JMP MLOOP
	
MOVELEFT:
	SUB [ENEMY1+2], 2
	SUB [ENEMY2+2], 2
	SUB [ENEMY3+2], 2
	SUB [ENEMY4+2], 2
	SUB [ENEMY5+2], 2
	JMP MLOOP

	 
	 
   
;--------------------KEYBOARD-------------------- 



;----------------GAME---------------------- 
        





;----------------SIDE PROGRAMS-------------

PRINTMESSAGE:
    MOV AH, 9
    INT 21H
    RET
    

GRAFIGMODE:
    MOV AX, 13H
    INT 10H     
    RET



            
PressKey:

    Mov ah,7
    Int 21h  
    Ret
    
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

GotoXY:
                
    Mov Ah,2 
    Mov Bh,0
    Mov Dl,10
    Mov Dh,10
    INT	10h
    Ret
    

    
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




OBJECTPRINT:

    ENEMYPIXEL ENEMY1
    ENEMYPIXEL ENEMY2
    ENEMYPIXEL ENEMY3
    ENEMYPIXEL ENEMY4
    ENEMYPIXEL ENEMY5

RET

CHECKSWITCH:

RET

END:

    MOV AH, 4CH
    INT 21H
            
         
;----------------SIDE PROGRAMS-------------