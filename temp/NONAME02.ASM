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
;Equivalente … fun‡Æo 09h da int 21h
;Retorna Eax ->flag de Estado
;--------------------------------------------------------------------

_ShowStr Proc Near
         Arg @Sel:dword, @Ofs:Dword

         If PreserveRegsOnCall
            Push Eax Ecx Edx Esi Edi es
         EndIf
            mov es,word ptr @Sel
            mov edi,@Ofs
            mov eax,'$'
            mov ecx,-1
            cld
            repne scasb
            neg ecx
            dec ecx
            cmp ecx,_DosLibBufSize              ;ser  o buffer pequeno?
            jg @@quit                           ;se sim aborta
            mov esi,@ofs
            mov dx,es
            mov es,_DosLibBufSel
            xor edi,edi
            push ds
            mov ds,dx
            rep movsb
            pop ds
            mov ax,_DosLibBufSeg
            Mov _RmDS,ax
            xor edx,edx
            mov eax,0900h
            call _ExecRmInt,21h

         @@quit:
         If PreserveRegsOnCall
            Pop es edi esi edx ecx eax
         EndIf
           ret
       EndP


EndSegment32
End