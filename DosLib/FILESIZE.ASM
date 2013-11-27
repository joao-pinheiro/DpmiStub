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
; Devolve em Eax o Tamanho do ficheiro em Bytes
;-----------------------------------------------------------------------

Public _FileSize

_FileSize Proc Near
          Arg @Handle:Dword

         If PreserveRegsOnCall
            Push Ebx Ecx Edx
         EndIf
            mov ebx,@Handle
            mov eax,4201h
            xor ecx,ecx
            xor edx,edx
            call _ExecRmInt,21h
            jc @@Error
            Shl Edx,16
            mov dx,ax
            push edx
            xor ecx,ecx
            xor edx,edx
            mov eax,4202h
            Call _ExecRmInt,21h
            shl edx,16
            mov dx,ax
            Pop Ecx
            push Edx
            mov dx,cx
            mov eax,4200h
            shr ecx,16
            Call _ExecRmInt,21h
            pop Eax
            Jmp @@Quit

        @@Error:
           Xor Eax,Eax

        @@Quit:
        If PreserveRegsOnCall
           Pop Edx Ecx Ebx
        EndIf
           ret
        EndP



EndSegment32
End