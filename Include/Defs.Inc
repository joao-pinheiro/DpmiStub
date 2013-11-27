;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
;
; Equates e definicoes de defaults
;
;####################################################################

;====================================================================

True       = 1
False      = 0
Nil        = -1

;====================================================================
;Atencao! Usar sempre multiplos de 16-------------------------------

ProgSize     = 12000            ;8K de programa
InitialStack = 64               ;Stack Inicial
RmStackSize  = 512              ;Tamanho da Stack de modo real
PmStackSize  = 4096             ;Tamanho da Stack de modo protegido

ReservedBlock  = 0              ;Tamanho do bloco extra a reservar
DosHeapBlockSize = 48000        ;Tamanho do bloco de heap a alocar

UseExceptionHandlers = True     ;Se captura os handlers das excepts
PreserveRegsOnCall   = True     ;Se guarda os registos nas chamadas Ös fns
                                ;se for true, s∆o feitos push/pop dos regs
                                ;que s∆o alterados no decorrer da rotina
                                ;se for false, n∆o s∆o preservados os valores
                                ;de nenhum dos seguintes regs:
                                ;EAX/EBX/ECX/ESI/EDI/ES
                                
                                
