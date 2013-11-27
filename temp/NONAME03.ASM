;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
;####################################################################

.model large,pascal
.386p
Locals

Include ..\include\Segs.Inc
Include ..\include\Stub.inc
Include ..\include\Defs.Inc
Include ..\include\DpmiLib.Inc
Include ..\include\DosLib.Inc
Include ..\include\Memory.Inc

Segment32

 MemblockPool   dd ?    ;Bloco de mem¢ria Dpmi alocado no in¡cio

;------------------------------------------
Msg01 db 'Nao existe memoria DPMI suficiente.',0ah,0dh,'$'


msg macro _msg               ;macro para exibir mensagens
     mov ax,0900h            ;com o servi‡o 09 da int 21h
     mov edx,offset _msg
     int 21h
    EndM

_Main Proc Near

 ;Inicializa‡ao da heap --------------------------------------------
      Call _DpmiGetmem,1048576  ;tenta alocar 1 mb
      mov memBlockpool,edi
      test edi,edi              ;se nao funcionou, aborta com erro
      jnz @@InitHeap

      Msg Msg1
      jmp @@Quit01

  @@InitHeap:



  @@Quit01:
      Ret
      Endp

