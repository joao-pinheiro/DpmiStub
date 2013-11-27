;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
; Inicializa os buffers da int 21h
;
;####################################################################

.model large,pascal
.386p
Locals

Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
Include ..\include\DpmiLib.Inc

  Segment32

Public _DosLibBufSeg, _DosLibBufSel, _DosLibBufSize

;--------------------------------------------------------------------
_DosLibBufSeg  dw 0     ;Segmento do Buffer de DosLib
_DosLibBufSel  dw 0     ;Selector do Buffer
_DosLibBufSize dd 0     ;Tamanho do buffer em Bytes

;--------------------------------------------------------------------
;Aloca o espa‡o pros buffers de DOS
;Retorna Eax ->flag de Estado
;--------------------------------------------------------------------
Public _InitDosLib

_InitDosLib Proc Near
            Arg @BufSize:dword

            If PreserveRegsOnCall
               Push Ebx edx edi
            EndIf
               Mov Edi,@BufSize
               Call _DpmiGetDosMem,Edi
               cmp eax,0
               je @@quit
               Shl Edi,4
               mov _DosLibBufSize,Edi
               mov _DosLibBufSeg,ax
               mov _DosLibBufSel,dx
               mov eax,1

            @@Quit:
            If PreserveRegsOnCall
               Pop edi edx ebx
            EndIf
               ret
            EndP

;--------------------------------------------------------------------
;Liberta o espa‡o reservado para os buffers de DOS
;--------------------------------------------------------------------

Public _DisposeDosLib

_DisposeDosLib Proc Near

            If PreserveRegsOnCall
               Push Ecx eax
            EndIf
               movzx ecx,_DosLibBufSel
               jecxz @@quit
               Call _DpmiFreeDosMem,ecx
               mov _DosLibBufSel,0
               Mov _DosLibBufSeg,0
               Mov _DosLibBufSize,0

            @@Quit:
            If PreserveRegsOnCall
               Pop eax ecx
            EndIf
               ret
            EndP



EndSegment32
End