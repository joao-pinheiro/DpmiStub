;####################################################################
;
; Dpmi Xtender v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
;
;####################################################################

Include ..\include\Defs.Inc

;====================================================================
.286
.Model Large,pascal
.stack InitialStack

;====================================================================

Include ..\include\Segs.Inc
Include ..\include\Structs.Inc

;====================================================================

                Segment16

;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

CopyrightMsg    db 'DPMI Stub v1.0b',0ah,0dh
		db 'Programmed by Joao Pinheiro (c) 2000'
                db 0ah,0dh,'$' 

InitErro01      db 'Nao existe memoria suficiente!',7,0ah,0dh,'$'

DpmiErro01	db 'Dpmi Host not found!',7,0ah,0dh,'$'
DpmiErro02	db 'Dpmi Host doesnt support 32 bit clients!'
		db 7,0ah,0dh,'$'
DpmiErro04      db 'Error on Switch to Dpmi!',7,0ah,0dh,'$'
DpmiErro05      db 'Error Allocating Descriptors!',7,0ah,0dh,'$'

DpmiVersionMsg  db 'Found Dpmi host v'
DpmiVersionH    db 0,'.'
DpmiVersionL    db 0,0,0ah,0dh,'$'

;--------------------------------------------------------------------
PspSegment      Dw 0               ;Segmento do Psp do programa
Dpmi_PdSize     Dw 0               ;Tamanho da PdSize em paragr
Dpmi_Entry      Dw 0,0             ;Far Ptr DpmiEntry
RmRegs          DpmiRegisters <>   ;Registos para mudanca de modo

StructStart     = $
Stack16Seg      Dw 0               ;Segmento da Stack16
Stack32Seg      Dw 0               ;Segmento da Stack32

InternalBuffer  Dw 0               ;Segmento do buffer interno
DosHeapBlock    Dw 0               ;Segmento do Bloco a reservar

SelPsp          Dw 0               ;Selector do Psp
SelCode16       Dw 0               ;Selector do Code16
SelData16       Dw 0               ;Selector do Data16
SelStack16      Dw 0               ;Selector do Stack16
SelData32       Dw 0               ;Selector do Data32 
SelCode32       Dw 0               ;Selector de code32
SelStack32      Dw 0               ;Selector de stack32
SelData0        Dw 0               ;Selector do Data0
SelCode0        Dw 0               ;Selector de code0

Dpmi_Version    Dw 0               ;Versao do dpmi
Dpmi_Flags      Dw 0               ;Flags de dpmi
Dpmi_Cpu        Db 0               ;Tipo de cpu
Dpmi_MasterPic  Db 0               ;virtual master interrupt controller base interrupt
Dpmi_SlavePic   Db 0               ;virtual slave interrupt controller base interrupt
Dpmi_SelIncVal  Dw 0               ;Valor de incremento aos selectors

;--------------------------------------------------------------------

StructSize = $ - StructStart

;####################################################################

PrintMsg Macro msg
         
         push dx ax
         mov dx,offset Msg
	 mov ah,09h
	 int 21h
	 pop ax dx

         EndM 

Quit	Macro Code

	Mov ah,4ch
	Mov al,Code
	Int 21h

        EndM

;####################################################################

;--------------------------------------------------------------------
;Início do programa
;--------------------------------------------------------------------

Start:
        Push cs                         ;Assegura q DS = Cs
        Pop Ds
        Push es
        pop PspSegment			;Salva Psp
        PrintMsg CopyrightMSG           ;Exibe msg de copyright

        Mov Bx,ProgSize                 ;Seta o Tamanho do PSP
        mov ah,4ah
        int 21h

        Mov bx,ReservedBlock/16         ;Aloca os diversos blocos 
        Add bx,DosHeapBlockSize/16
        Add bx,(RmStackSize + PmStackSize)/16
        mov ah,48h
        int 21h
        Mov InternalBuffer,ax
        Jnc @StartLabel_a2

  @StartLabel_a1:
        PrintMsg InitErro01
        Quit 1   

  @StartLabel_a2:
        Add ax,ReservedBlock/16         ;Seta as variaveis
        mov DosHeapBlock,ax             ;dos diversos segmentos de mem
        Add ax,DosHeapBlockSize/16
        Mov Stack16Seg,ax
        Add ax,RmStackSize/16
        Mov Stack32Seg,ax

        Mov dx,RmStackSize              ;Prepara-se pra mudanca de stacks
        cli                             ;Muda as stacks
        mov ss,stack16seg
        mov sp,dx
        xor bp,bp
        sti

;--------------------------------------------------------------------

  @StartLabel_a3:
        Mov ax,1687h                    ;verifica se existe DPMI
	int 2fh
	or ax,ax
        jz @StartLabel_a4

	PrintMsg DpmiErro01
        Quit 2

  @StartLabel_a4:
        Mov Dpmi_Version,Dx             ;Salva as vars necessarias
        Push Bx
        Mov Dpmi_pdSize,si
	Mov Dpmi_entry,Di
	Mov Dpmi_entry+2,Es

        add dh,48                       ;Exibe a msg de versao
        Mov DpmiVersionH,dh
        xor ax,ax
        mov al,dl
        mov bl,10
        div bl
        add al,48
        add ah,48
        Mov DpmiVersionL,al
        Mov DpmiVersionL+1,ah
        PrintMsg DpmiVersionMsg

        Pop Bx
        or bx,1                         ;ve se suporta 32 bit
        Jnz @StartLabel_a5

        PrintMsg DpmiErro02
        Quit 2

;--------------------------------------------------------------------
  @StartLabel_a5:
        .386P

        Mov bx,Dpmi_PdSize              ;aloca a mem para Dpmi
        cmp Bx,0
        Je @StartLabel_a6
        Mov ah,48h
        int 21h
        jc @StartLabel_a1               ;se falhou, aborta

  @StartLabel_a6:
        Mov es,ax                       ;prepara-se pra iniciar DPMI
        mov ax,1                        ;em 32 bit
        call dword ptr cs:dpmi_Entry    ;inicia
        jnc @StartLabel_a7

        push cs                         ;Restaura DS
        pop ds
        PrintMsg DpmiErro04
        Quit 3

;--------------------------------------------------------------------
  @StartLabel_a7:                       ;codigo em pm
        Mov SelPsp,Es                   ;Salva os novos selectors
        Mov Selcode16,cs
        Mov SelData16,Ds
        Mov SelStack16,ss

        Mov ax,400h                     ;Obtem dpmi flags
        int 31h
        Mov Dpmi_Flags,Bx
        Mov Dpmi_Cpu,Cl
        Mov Dpmi_MasterPic,Dh
        Mov Dpmi_SlavePic,Dl

        Mov ax,3                        ;Obtem Selector IncVal
        Int 31h
        mov Dpmi_SelIncVal, Ax

        Xor Ax,ax                       ;Aloca os descriptors de sistema
        Mov cx,3                        ;3 Descriptors
        Int 31h
        jnc @StartLabel_a9

        mov dx,offset DpmiErro05
        Call quiterror

  @StartLabel_a9:
        mov SelCode32,ax                ;Seta o selector de Code32
        mov dx,ax
        add ax,Dpmi_SelIncVal           ;Avanca para o proximo
        mov SelStack32,ax               ;Seta o selector de Stack32
        add ax,Dpmi_SelIncVal           ;Avanca para o proximo
        mov SelCode0,ax                 ;Seta o selector de Code0

;-------------------------------------------------------Code32/Data32
        Mov bx,cs                       ;Obtem os cpl bits de code16
        Lar cx,bx
        And ch,01100000b                ;isola os CPL bits        
        mov cl,ch
        push cx cx                      ;salva CPL
        or cl,10011011b                 ;Descr de code, present
        mov ch,40h                      ;Descr Use32

        mov bx,dx                       ;selector code32
        mov ax,09h                      ;Seta access rights
        int 31h

        mov ecx,text32                  ;calcula o limite
        shl ecx,4
        push ecx
        add ecx,offset Final32
        mov dx,cx
        shr ecx,16                      ;em cx:dx
        mov ax,08h                      ;seta o limite
        int 31h

        pop ecx
        mov ax,07h
        mov dx,cx
        shr ecx,16
        int 31h                         ;seta a base do descriptor

        mov ax,0ah                      ;cria alias de code32
        int 31h
        mov SelData32,ax                ;Salva Data32

;---------------------------------------------------------Code0/Data0
        pop cx                          ;obtem iopl
        or cl,10011011b                 ;Descr de code, present
        mov ch,0c0h                     ;Descr Use32,page aligned
        mov bx,SelCode0                 ;selector code0
        mov ax,09h                      ;Seta access rights
        int 31h

        mov cx,0ffffh
        mov dx,0ffffh
        mov ax,08h                      ;seta o limite
        int 31h                         ;a base sera 0

        mov ax,0ah                      ;cria alias de code0
        int 31h
        mov SelData0,ax                 ;salva data0

;-------------------------------------------------------------Stack32
        pop cx
        or cl,10010011b                 ;Descr de dados present
        mov ch,40h                      ;Descr Use32
        mov bx,SelStack32               ;Access rights de Stack32
        mov ax,09h
        int 31h

        movzx ecx,Stack32Seg            ;Calcula a Base
        Shl ecx,4
        push ecx
        mov dx,cx
        shr ecx,16
        mov ax,07h                      ;Seta a base
        int 31h

        pop ecx                         ;Calcula o limite
        mov edx,PmStackSize
        add ecx,edx
        mov dx,cx
        shr ecx,16
        mov ax,08h                      ;Seta o limite
        int 31h

;--------------------------------------------------------------------
        Movzx Edx,SelCode32
        Mov Ebx, offset Start32
        push edx
        push ebx
        push SelData32
        push ds
        pop fs ds
        db 66h                          ;32 bit retf
        retf
        quit 0

;-------------------------------------------------------------------
;-------------------------------------------------------------------

QuitError:
        Mov ax,stack16Seg
        mov bx,RmStackSize
        Mov RmRegs._dx,dx
        Mov RmRegs._ss,ax
        mov rmregs._sp,bx
        mov rmRegs._bp,0
        lahf
        shr ax,8
        mov rmRegs._flags,ax
        mov cx,text16
        mov dx,offset @QuitMsgErro
        mov rmregs._Cs,cx
        mov rmregs._ds,cx
        mov rmregs._es,cx
        mov rmregs._ip,dx
        mov ax,0301h
        xor bx,bx
        xor cx,cx
        push ds
        pop es
        mov edi,offset rmregs
        int 31h

        quit 10

 @QuitMsgErro:
        Mov ah,09h
        int 21h

        Quit 4
;--------------------------------------------------------------------

EndSegment16

;====================================================================

        .386P
        Assume Fs:Text16
        Segment32

;--------------------------------------------------------------------
;Estrutura copiada de Text16

CopyStructLabel = $

_Stack16Seg      Dw 0               ;Segmento da Stack16
_Stack32Seg      Dw 0               ;Segmento da Stack32
_InternalBuffer  Dw 0               ;Segmento do buffer interno
_DosHeapBlock    Dw 0               ;Segmento do Bloco a reservar
_SelPsp          Dw 0               ;Selector do Psp
_SelCode16       Dw 0               ;Selector do Code16
_SelData16       Dw 0               ;Selector do Data16
_SelStack16      Dw 0               ;Selector do Stack16
_SelData32       Dw 0               ;Selector do Data32 
_SelCode32       Dw 0               ;Selector de code32
_SelStack32      Dw 0               ;Selector de stack32
_SelData0        Dw 0               ;Selector do Data0
_SelCode0        Dw 0               ;Selector de code0
_Dpmi_Version    Dw 0               ;Versao do dpmi
_Dpmi_Flags      Dw 0               ;Flags de dpmi
_Dpmi_Cpu        Db 0               ;Tipo de cpu
_Dpmi_MasterPic  Db 0               ;virtual master interrupt controller base interrupt
_Dpmi_SlavePic   Db 0               ;virtual slave interrupt controller base interrupt
_Dpmi_SelIncVal  Dw 0               ;Valor de incremento aos selectors

;--------------------------------------------------------------------

_InternBufLinAddx    dd 0          ;Linear addx do internalbuffer
_DosHeapBlockLinAddx dd 0          ;Linear addx do initblock

;--------------------------------------------------------------------

Public _Stack16Seg,_Stack32Seg,_InternalBuffer,_DosHeapBlock
Public _SelPsp,_SelCode16,_SelData16,_SelStack16,_SelData32
Public _SelCode32,_SelStack32,_SelData0,_SelCode0,_Dpmi_Version
Public _Dpmi_Flags,_Dpmi_Cpu,_Dpmi_MasterPic,_Dpmi_SlavePic
Public _Dpmi_SelIncVal,_InternBufLinAddx,_DosHeapBlockLinAddx

;====================================================================
;====================================================================

Message macro msg

        mov edx,offset msg
        mov ah,09h
        Int 21h

       Endm

;--------------------------------------------------------------------
;entra com fs=Text16, ds=text32
;--------------------------------------------------------------------
Start32:
     push ds ds fs                      ;copia a estrutura
     pop ds es                          ;de dados de text16
     mov ecx,StructSize
     mov esi,offset StructStart
     Mov edi,offset CopyStructLabel
     cld
     rep movsb
     pop ds
;--------------------------------------------------------------------
     Cli                           ;Muda para stack32
     Mov esp,PmStackSize           ;Calcula o Stack Frame
     movzx eax,stack32Seg
     xor ebp,ebp
     mov ss,_SelStack32
     Sti

;--------------------------------------------------------------------
     Movzx edx,internalbuffer      ;calcula os enderecos lineares
     Movzx ebx,DosHeapBlock
     shl edx,4
     shl ebx,4
     Mov _InternBufLinAddx,edx
     Mov _DosHeapBlockLinAddx,ebx
;--------------------------------------------------------------------
     If UseExceptionHandlers
         Call InitExceptionHandlers
     EndIf
;--------------------------------------------------------------------

;Modulo principal

Extrn _Main:proc

      Call _Main

      quit al

;--------------------------------------------------------------------
;--------------------------------------------------------------------
ExcepNumber     Dw 0                   ;Numero da excepcao
;--------------------------------------------------------------------

ExceptionHandler Macro Nome, Numero

           Align 4
      Nome Proc Far

           Push edi esi
           Push gs fs es ds                         ;Salva os Registos
           Push edx ecx ebx eax
           pushfd                                   ;flags tb    
           mov ax,900h                              ;Cli
           int 31h
           mov ds,cs:_Seldata32                     ;seta ds = text32
           Mov eax,numero                           ;Seta var do numero
           mov ds:ExcepNumber,ax                    ;da exception a tratar    
           mov ebx,offset ExceptionTable
           shl eax,3                                ;calcula o offset
                                                    ;na exception table
           add ebx,eax
           call fword ptr  [ebx]                    ;executa o handler

           mov ax,901h                              ;Sti
           int 31h
           popfd                                    ;restaura regs
           pop eax ebx ecx edx                      ;
           pop ds es fs gs
           pop esi edi
           ret

         Endp
        ENDM

;---------------------------------------------------------------------
;Vectores das exceptions----------------------------------------------

ExceptionTable dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0
               dd offset DefaultHandler, 0 , offset DefaultHandler, 0

;Mensagens das Exceptions---------------------------------------------

Exp00Msg       Db 0Ah,0Dh,'EXCEPTION 00h - Divis„o por zero.',0Ah,0Dh,7,'$'
Exp01Msg       Db 0Ah,0Dh,'EXCEPTION 01h - Debug TRAP.',0Ah,0Dh,7,'$'
Exp02Msg       Db 0Ah,0Dh,'EXCEPTION 02h - Ocorreu uma NMI.',0Ah,0Dh,7,'$'
Exp03Msg       Db 0Ah,0Dh,'EXCEPTION 03h - Interrup‡„o de 1 byte.',0Ah,0Dh,7,'$'
Exp04Msg       Db 0Ah,0Dh,'EXCEPTION 04h - Ocorreu um Overflow.',0Ah,0Dh,7,'$'
Exp05Msg       Db 0Ah,0Dh,'EXCEPTION 05h - Erro de BOUND.',0Ah,0Dh,7,'$'
Exp06Msg       Db 0Ah,0Dh,'EXCEPTION 06h - Opcode inv lido.',0Ah,0Dh,7,'$'
Exp07Msg       Db 0Ah,0Dh,'EXCEPTION 07h - FPU nao disponivel.',0Ah,0Dh,7,'$'
Exp08Msg       Db 0Ah,0Dh,'EXCEPTION 08h - Erro de DOUBLE FAULT.',0Ah,0Dh,7,'$'
Exp09Msg       Db 0Ah,0Dh,'EXCEPTION 09h - FPU segment overrun.',0Ah,0Dh,7,'$'
Exp0AMsg       Db 0Ah,0Dh,'EXCEPTION 0Ah - TSS inv lido.',0Ah,0Dh,7,'$'
Exp0BMsg       Db 0Ah,0Dh,'EXCEPTION 0Bh - Segmento n„o presente.',0Ah,0Dh,7,'$'
Exp0CMsg       Db 0Ah,0Dh,'EXCEPTION 0Ch - Erro de Stack.',0Ah,0Dh,7,'$'
Exp0DMsg       Db 0Ah,0Dh,'EXCEPTION 0Dh - General Protection Fault.',0Ah,0Dh,7,'$'
Exp0EMsg       Db 0Ah,0Dh,'EXCEPTION 0Eh - Page Fault.',0Ah,0Dh,7,'$'
Exp0FMsg       Db 0Ah,0Dh,'EXCEPTION 0Fh - Erro de FPU.',0Ah,0Dh,7,'$'

ExpMsgTable     dd offset Exp00Msg, offset Exp01Msg,offset Exp02Msg
                dd offset Exp03Msg, offset Exp04Msg,offset Exp05Msg
                dd offset Exp06Msg, offset Exp07Msg,offset Exp08Msg
                dd offset Exp09Msg, offset Exp0AMsg,offset Exp0BMsg
                dd offset Exp0CMsg, offset Exp0DMsg,offset Exp0EMsg
                dd offset Exp0FMsg

;Exception Handlers do Sistema----------------------------------------

ExceptionHandler Exception00,00h
ExceptionHandler Exception01,01h
ExceptionHandler Exception02,02h
ExceptionHandler Exception03,03h
ExceptionHandler Exception04,04h
ExceptionHandler Exception05,05h
ExceptionHandler Exception06,06h
ExceptionHandler Exception07,07h
ExceptionHandler Exception08,08h
ExceptionHandler Exception09,09h
ExceptionHandler Exception0A,0Ah
ExceptionHandler Exception0B,0Bh
ExceptionHandler Exception0C,0Ch
ExceptionHandler Exception0D,0Dh
ExceptionHandler Exception0E,0Eh
ExceptionHandler Exception0F,0Fh

;Tabela dos offsets dos exception Handlers

ExceptionHandlerTable dd Offset Exception00, Offset Exception01
                      dd Offset Exception02, Offset Exception03
                      dd Offset Exception04, Offset Exception05
                      dd Offset Exception06, Offset Exception07
                      dd Offset Exception08, Offset Exception09
                      dd Offset Exception0A, Offset Exception0B
                      dd Offset Exception0C, Offset Exception0D
                      dd Offset Exception0E, Offset Exception0F

      
;--------------------------------------------------------------------
; Inicia as variaveis relacionadas com as exceptions
;--------------------------------------------------------------------

InitExceptionHandlers Proc Near

        xor eax,eax                             ;Preenche a tbl de handlers
        mov ax,cs
        Mov esi,offset ExceptionTable + 4
        mov ecx,16
        cld

   @FillLoop:
        mov dword ptr [esi],eax
        add esi,8
        loop @FillLoop

        xor ebx,ebx                             ;Agora seta os
        xor ecx,ecx                             ;novos exception vectors
        mov cx,cs
        mov eax,0203h
        mov esi,offset ExceptionHandlerTable

    @SetVecsLoop:
        mov edx,dword ptr [esi]
        int 31h                                 ;nao verifica se 
        add esi,4                               ;falha
        inc bx
        cmp bx,0fh
        jng @SetVecsLoop
        ret

       Endp

;--------------------------------------------------------------------
;Handler default de todas as excepcoes
;--------------------------------------------------------------------

DefaultHandler Proc Far

        movzx ebx,ExcepNumber                   ;procura na msg table
        shl ebx,2
        add ebx,offset ExpMsgTable
        mov edx,[ebx]
        mov ah,09h
        int 21h
        call DumpRegisters

        quit 99                                 ;sai com error code=99
        ret                                     ;por seguranca
     Endp

;--------------------------------------------------------------------
;Rotinas de Conversao de binario pra String--------------------------

BaseNumber  dd 16         ;Base do Num a ser convertido para string
FieldLen    dw 8          ;Tamanho do Campo
PadChar     db '0'        ;Caracter de PAD
Suffix      db 'h'        ;Sufixo

;--------------------------------------------------------------------
;Converte um numero inteiro numa string
;--------------------------------------------------------------------

Int2Str Proc Near
        Arg @n:dword, @so:dword

        uses eax,ebx,ecx,edx,esi,edi,es
        mov es,cs:_SelData32                    ;string de destino
        mov edi,@so                             ;em text32
        mov eax,@n
        movzx edx,fieldlen                      ;posiciona-se no fim
        add edi,edx
        mov dl,suffix
        mov byte ptr [edi],dl                   ;poe o sufixo
        mov ecx,baseNumber

   @@MainLoop:
        dec edi
        xor edx,edx
        div Ecx
        add dl,'0'
        mov byte ptr [edi],dl
        cmp dl,'9'
        jbe @@MainLoop1
        add byte ptr [edi],7

   @@MainLoop1:
        cmp edi,@so                             ;esgotou o n de caracteres
        je @@IntQuit                            ;disponiveis na string?
        cmp eax,0                               ;chegamos ao fim?
        jne @@MainLoop

   @@IntLoop2:                                  ;preenche o restante
        mov al,padchar                          ;com pad
        mov ecx,@so
        sub edi,ecx                             ;quantos faltam?
        xchg edi,ecx
        cld
        rep stosb

   @@IntQuit:
        ret

     Endp

;--------------------------------------------------------------------
;Rotinas de Dump dos Registos----------------------------------------

DumpRegsScr    db 0dh,0ah
               db'---------------] Registos [--------------'
               db 0dh,0ah,'EAX:'
RegDumpEax     db '00000000h EBX:' 
RegDumpEbx     db '00000000h ECX:' 
RegDumpEcx     db '00000000h',0dh,0ah
               db 'EDX:'
RegDumpEdx     db '00000000h ESI:'
RegDumpEsi     db '00000000h EDI:'
RegDumpEdi     db '00000000h',0dh,0ah,0dh,0ah
               db 'CS:' 
RegDumpCs      db '0000h EIP:'
RegDumpEip     db '00000000h',0dh,0ah
               db 'DS:'
RegDumpDs      db '0000h ES:'
RegDumpEs      db '0000h FS:'
RegDumpFs      db '0000h GS:'
RegDumpGs      db '0000h',0dh,0ah
               db 'SS:'     
RegDumpSS      db '0000h ESP:'
RegDumpEsp     db '00000000h'
               db 0dh,0ah,0dh,0ah  
               db 'EFLAGS:' 
RegDumpEflags  db '00000000h',0dh,0ah
               db'-----------------------------------------'
               db 0dh,0ah,'$'

;--------------------------------------------------------------------
;Exibe no ecra os valores dos registos salvos no stack frame
;--------------------------------------------------------------------

DumpRegisters proc near

        mov BaseNumber,16                       ;Seta os parametros de
        Mov FieldLen,8                          ;conversao numerica
        Mov PadChar,48
        mov ebx,esp                             ;stack frame
        add ebx,12                              ;zona de ret's
        mov eax, ss:[ebx+64]                    ;comeca o dump
        mov edi,offset RegDumpEflags            ;do conteudo dos registos
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+4]                     ;Eax
        mov edi,offset RegDumpEax               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+8]                     ;Ebx
        mov edi,offset RegDumpEbx               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+12]                    ;Ecx
        mov edi,offset RegDumpEcx               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+16]                    ;Edx
        mov edi,offset RegDumpEdx               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+36]                    ;Esi
        mov edi,offset RegDumpEsi               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+40]                    ;Edi
        mov edi,offset RegDumpEdi               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+56]                    ;eip
        mov edi,offset RegDumpEip               
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+68]                    ;esp
        mov edi,offset RegDumpEsp               
        Call Int2Str,eax,edi

        Mov FieldLen,4      

        mov eax, ss:[ebx+60]                    ;cs
        mov edi,offset RegDumpCs
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+20]                    ;ds
        mov edi,offset RegDumpDs                
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+24]                    ;es
        mov edi,offset RegDumpEs                
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+28]                    ;fs
        mov edi,offset RegDumpFs                
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+32]                    ;gs
        mov edi,offset RegDumpGs                
        Call Int2Str,eax,edi
        mov eax, ss:[ebx+72]                    ;ss
        mov edi,offset RegDumpss                
        Call Int2Str,eax,edi

        mov edx,offset DumpRegsScr
        mov ah,09h
        int 21h
        ret

      Endp

Final32:
;--------------------------------------------------------------------
EndSegment32

End Start
