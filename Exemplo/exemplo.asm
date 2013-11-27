;####################################################################
;
; Dpmi Stub Loader v1.0b
; 
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
; 
; Exemplo 1
;
; copper.asm - Text mode copper routine by Chris Austin
;
;
;####################################################################
  
.model large,pascal           
.386p
Locals
  
Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
                   
  Segment32        

Public _Main

_Main Proc
ReLoop:        ; We repeat this until a key is pressed.
Mov BX,4       ; Number of bars...
Mov DX,3DAh    ; VGA retrace IO port...
Vert1:
In AL,DX       ; Get RETRACE status from port...
Test AL,8      ; See if the retrace is over...
Jz Vert1       ; If not jump back to VERT1
Loopit:
Xor CX,CX      ; Zero CX.
Loop1:
Xor AL,AL      ; Zero AL.
Mov DX,03C8h   ; Set VGA IO port...
Out DX,AL      ; Send the color who's palette we want to change...
Mov DX,03C9h   ; Set VGA IO port.
Mov AL,CL      ; Mov AL, RED part of the palette
Out DX,AL      ; Send it to the VGA IO port...
Xor AL,AL      ; We want the green and blue ZERO so we XOR 'em.
Out DX,AL      ; Send Green.
Out DX,AL      ; Send Blue.
Inc CX         ; Increment CX...
Cmp CX,64      ; Compare CX...
JL Loop1       ; If CX isn't 64 yet then jump back to Loop1
Xor CX,CX      ; Zero CX.
Loop2:
Xor Al,AL      ; Zero AL.
Mov DX,03C8h   ; Set VGA IO port...
Out DX,AL      ; Send the color who's palette we want to change...
Mov DX,03C9h   ; Set VGA IO port...
Mov AL,63      ; Red is 100% on now were doing where it fades to red.
Out DX,AL      ; Ok send it out the register port.
Mov AL,CL      ; Green and blue fading in when it gets to 64 it will be white.
Out DX,AL      ; Send GREEN component.
Out DX,AL      ; Send BLUE component.
Inc CX         ; Increment CX.
Cmp CX,64      ; Compair CX to 64.
JL Loop2       ; If CX is LESS the 64 jump back to the loop.
Mov CX,64      ; Load CX with 64.
Loop3:
Xor AL,AL      ; Zero AL.
Mov DX,03C8h   ; Set VGA IO port...
Out DX,AL      ; Send the color who's palette we want to change...
Mov DX,03C9h   ; Set VGA IO port...
Mov AL,63      ; Red is still 100%.
Out DX,AL      ; Green and Blue fading now ...
Mov AL,CL
Out DX,AL      ; Send green.
Out DX,AL      ; Send blue.
Loop Loop3     ; If CX isn't zero yet loop again.
Mov CX,64
Loop4:
XOR AL,AL      ; Zero AL.
Mov DX,03C8h   ; Set VGA IO port...
Out DX,AL      ; Send the color who's palette we want to change...
Mov DX,03C9h   ; Set VGA IO port...
Mov AL,CL      ; Only the RED is left and that's fading now.
Out DX,AL      ; Send RED.
Xor AL,AL      ; Zero AL.
Out DX,AL      ; Send Green.
Out DX,AL      ; Send Blue.
Loop Loop4     ; If CX isn't zero loop again.
Dec BX         ; Decrement BX (Number of bars..)
JNZ Loopit     ; If it isn't 0 then loop the whole thing again.
;In AL,60h     ;Get keypress.
;Cmp AL,80h
;Ja Reloop
mov ah,1       ;Get keypress.
int 16h
jz Reloop
Xor AH,AH      ; Zero AH
Mov AL,3       ; Set AL to mode (Textmode.)
Int 10h        ; Call VIDEO.
       ret
       Endp     
                
EndSegment32          
end             
