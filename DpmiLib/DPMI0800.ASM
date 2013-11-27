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

  Segment32

;---------------------------------------------------------------------
; retorna o endere‡o linear correspondente ao endere‡o f¡sico pretendido
; tem q ser endere‡o f¡sico > 1§Mb
; Retorna: Edi -> Endere‡o linear ou Nil
;
;---------------------------------------------------------------------
Public _DpmiPhysicalMap

_DpmiPhysicalMap Proc Near
                 Arg @Addx:Dword,@sizeinbytes:dword

             If PreserveRegsOnCall
                push eax ebx ecx esi
             EndIf
                mov eax,800h
                mov ebx,@addx
                mov esi,@sizeinbytes
                mov cx,bx
                mov di,si
                shr ebx,16
                shr esi,16
                int 31h
                jc @@error
                shl ebx,16
                mov bx,cx
                mov edi,ebx
                jmp @@quit

             @@Error:
                mov edi,nil

             @@quit:
             If PreserveRegsOnCall
                pop esi ecx ebx eax
             EndIf
                ret
             EndP


EndSegment32
End
