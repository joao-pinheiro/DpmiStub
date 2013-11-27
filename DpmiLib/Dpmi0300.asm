;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
; Biblioteca de Fun‡äes DPMI
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

;--------------------------------------------------------------------
; Executa um int em modo real
; _ExecRmInt(Int:dword)
;--------------------------------------------------------------------

_ExecRmInt Proc Near
           Arg @int:dword

        If PreserveRegsOnCall
           push es
        EndIf
           mov es,cs:_SelData32
           Call SaveRmRegs
           mov ax,0300h                         ;exec Rm Int
           xor cx,cx
           Mov ebx,@int
           mov edi,offset _RmRegs
           int 31h
           Call RestoreRmRegs
        If PreserveRegsOnCall
           pop es
        EndIf
           ret

        EndP

EndSegment32
End
