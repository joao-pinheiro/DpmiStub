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
include ..\include\debug.inc  ;temporario
;=======================================================================

MemblockPool   dd ?    ;Bloco de mem¢ria Dpmi alocado no in¡cio

;-----------------------------------------------------------------------
Msg01 db 'Memoria insuficiente para iniciar o buffer de DOS',0ah,0dh,'$'
Msg02 db 'Nao existe memoria DPMI suficiente.',0ah,0dh,'$'

;=======================================================================

msg macro _msg               ;macro para exibir mensagens
     mov ax,0900h            ;com o servi‡o 09 da int 21h
     mov edx,offset _msg
     int 21h
    EndM

;=======================================================================
;=======================================================================

Prompt1 db 'Digite o nome do ficheiro PCX a abrir:',0ah,0dh,'$'

InpBuf  db 128               ;tamanho do input buffer
pad1    db 0                 ;bytes a relembrar
PcxName db 128 dup(0)        ;nome do ficheiro a abrir

GetPcxName proc Near

           mov ah,09h                   ;exibe a msg
           mov edx,offset prompt1
           int 21h

           mov edx,offset inpbuf        ;lˆ o nome do ficheiro
           mov ah,0ah
           int 21h

           mov es,_seldata32
           mov edi,offset pcxname
           mov ecx,-1
           mov eax,13                   ;carriage return
           cld
           repne scasb                  ;calcula o tamanho da string
           neg ecx
           dec ecx
           mov es:[edi],ah              ;transforma em Asciiz string

           ret
          Endp


;-------------------------------
DpmiGetMem Proc Near
            arg @Size:Dword

         If PreserveRegsOnCall
            Push eax ebx ecx edx esi es
         EndIf
            mov es,_SelData0
            Mov ebx,@Size
            add ebx,4                           ;adiciona espa‡o
            mov cx,bx
            Shr ebx,16
            mov ax,0501h
            int 31h
            jc @@Error
            shl Esi,16                          ;Handle em Esi
            mov si,di
            shl ebx,16                          ;Addx em ebx
            mov bx,cx
            mov edi,ebx                         ;retorna edi
            mov es:[edi],esi                    ;guarda o handle
            add edi,4
            jmp @@Quit

       @@Error:
            Mov edi,nil                         ;retorna com nil

       @@Quit:
         If PreserveRegsOnCall
            Pop es esi edx ecx ebx eax
         EndIf
            ret

           EndP








public _MAIN
_MAIN Proc
 ;Inicializa‡ao da DosLib ------------------------------------------
      Call _InitDosLib,2048     ;inicializa a doslib com um buffer
                                ;de 2048 paragrafos de memoria
      Cmp Eax,1
      je @@Continue01

      msg msg01
      jmp @@Quit01

  @@Continue01:
 ;Inicializa‡ao da heap --------------------------------------------

      Call DpmiGetmem,1048576  ;tenta alocar 1 mb
      mov memBlockpool,edi      ;salva o poss¡vel endere‡o
      cmp edi,nil               ;se nao funcionou, aborta com erro
      jne @@InitHeap

      Msg Msg02
      jmp @@Quit01

  @@InitHeap:
      mov es,_seldata0
      mov es:[edi],edx
      msg msg01
;      mov edi,offset fuck
;      call dumpvalue,edi
;      movzx eax,_seldata32
;      Call _InitHeap pascal,edi,dword(2000),eax    ;inicializa a Heap
      movzx eax,_seldata0
      mov ebx,1048676
      Call _InitHeap pascal,edi,ebx,eax         ;inicializa a Heap

      msg msg01
  ;-----------------------------------------------------------------

  @@Quit02:
      Call _DpmiFreeMem,memblockpool      ;Liberta o bloco de mem da heap

  @@Quit01:
      Ret                                 ;e sai
     Endp

fuck db 2000 dup(0)

EndSegment32

End