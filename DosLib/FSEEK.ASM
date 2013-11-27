;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
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

Global _DosLibBufSeg:Word
Global _DosLibBufSel:Word
Global _DosLibBufSize:Dword

;-----------------------------------------------------------------------
;Posiciona o Filepointer na posi‡Æo TO a partir do in¡cio do ficheiro
;-----------------------------------------------------------------------

Public _FSeek
_Fseek   Proc Near
         Arg @Handle:dword,@To:dword

         If PreserveRegsOnCall
            Push Ebx Ecx Edx
         EndIf
            mov eax,4200h
            mov ebx,@handle
            mov ecx,@to
            mov dx,cx
            shr ecx,16
            call _ExecRmInt,21h
            mov eax,0
            setnc al
         If PreserveRegsOnCall
            Pop Edx Ecx Ebx
         EndIf
            ret
         EndP


EndSegment32
End