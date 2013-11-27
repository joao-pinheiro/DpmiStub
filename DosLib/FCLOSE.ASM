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

;--------------------------------------------------------------------
;Fecha 1 Ficheiro
;--------------------------------------------------------------------

Public _FClose

_FClose Proc Near
        Arg @Handle:dword

       If PreserveRegsOnCall
          Push Eax Ebx
       EndIf
          mov eax,3e00h
          mov ebx,@handle
          call _ExecRmInt,21h
       If PreserveRegsOnCall
          Pop Ebx Eax
       EndIf
        ret
      EndP



EndSegment32
End