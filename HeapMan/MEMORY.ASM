;####################################################################
;
; Dpmi Xtender v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
; Gerenciador de mem¢ria
;
; Aqui est∆o as rotinas do heap manager simples. As rotinas poder∆o
; parecer um tanto elaboradas, mas isso Ç devido Ö m† programaá∆o.
; Os blocos s∆o alocados com o mÇtodo de first-Fit e o tamanho m°nimo
; do bloco Ç de 8 bytes. As alocaá‰es ser∆o todas alinhadas a 8 bytes.
; O espaáo de heap dever† estar alinhado a 16 bytes.
; N∆o existe rotina de redimensionamento n∆o-destrutivo de blocos,
; visto na pr†tica eu n∆o lhe dar grande uso :))
;
; Este c¢digo pode ser utilizado total ou parcialmente em aplicaá‰es
; n∆o-comerciais desde que seja dado o devido crÇdito ao autor numa
; parte _vis°vel_ da aplicaá∆o.
;
;####################################################################

.386
.Model Large,pascal

Include ..\include\Stub.inc
Include ..\include\Defs.Inc
Include ..\include\Structs.Inc
Include ..\include\Structs.Inc
;====================================================================

MemBlockId = 0B1ADFCEh          ;Id de bloco alocado
MemAlign   = 8                  ;valor de alinhamento de Mem

;====================================================================

        Segment32
include ..\include\debug.inc ;temporario
;====================================================================

FreeBlock Struc
            NextBlock     dd 0       ;Pr¢ximo bloco
            BlockSize     dd 0       ;Tamanho do bloco
            PrevBlock     dd 0       ;Bloco anterior
            PrevFreeBlock dd 0       ;Bloco livre anterior
FreeBlock Ends

AllocBlock Struc
             BlockID      dd 0       ;Identificador de bloco
             BlockSize    dd 0 	     ;Tamanho do Bloco
             PrevBlock	  dd 0       ;Bloco anterior
             NotUsed	  dd 0       ;pad
AllocBlock Ends

;====================================================================

Public _HeapBase,_HeapTop,_HeapSelector,_HeapHead

_HeapBase       dd 0                 ;Base da heap
_HeapTop        dd 0                 ;topo da heap (Base+Tamanho)
_HeapSelector   dw 0                 ;Selector da Heap

_HeapHead       dd 0                 ;1ß Bloco Livre

;====================================================================
;====================================================================

AllocB Macro reg,prev,size
        Ifidni <reg> , <edi>
           mov [reg][AllocBlock.BlockID],MemBlockID
           mov [reg][AllocBlock.PrevBlock],prev
           Ifnb <size>
              mov [reg][AllocBlock.BlockSize],size
           EndIf
       Else
           mov es:[reg][AllocBlock.BlockID],MemBlockID
           mov es:[reg][AllocBlock.PrevBlock],prev
           Ifnb <size>
              mov es:[reg][AllocBlock.BlockSize],size
           EndIf
       EndIf
       Endm

;--------------------------------------------------------------------

FreeB  Macro reg,Next,Prev,PrevFree,Size
       Ifidni <Reg> , <edi>
          mov [reg][FreeBlock.NextBlock],Next
          mov [reg][FreeBlock.PrevBlock],Prev
          mov [reg][FreeBlock.PrevFreeBlock],PrevFree
          Ifnb <Size>
             mov [reg][FreeBlock.BlockSize],Size
          EndIf
       Else
          mov es:[reg][FreeBlock.NextBlock],Next
          mov es:[reg][FreeBlock.PrevBlock],Prev
          mov es:[reg][FreeBlock.PrevFreeBlock],PrevFree
          Ifnb <Size>
             mov es:[reg][FreeBlock.BlockSize],Size
          EndIf
       EndIf
       Endm

;====================================================================
;====================================================================
;--------------------------------------------------------------------
; Rotina usada por GetMem para partir os Blocos
; Entrada:  Edi-> Bloco livre a partir
;           Ecx-> Novo Tamanho
;           Es->  Selector
; Sa°da:
;           Edi-> Novo Bloco com tamanho Ecx alocado
;           Esi-> Fragmento de bloco marcado como Livre
;--------------------------------------------------------------------

BlockSplit Proc Near

        mov eax,[edi][FreeBlock.PrevFreeBlock]
        mov ebx,[edi][FreeBlock.BlockSize]
        Push [edi][FreeBlock.PrevFreeBlock]
        mov edx,[edi][FreeBlock.PrevBlock]
        AllocB edi,edx,ecx                      ;Aloca o Bloco
        mov esi,edi                             ;calcula o offset do
        add esi,ecx                             ;bloco resultante
        add esi,16                              ;em Esi
        sub ebx,ecx                             ;calcula o tamanho
        sub ebx,16                              ;do novo bloco
        pop edx
        FreeB esi,nil,edi,edx,ebx               ;Marca o novo bloco
        add ebx,esi
        add ebx,16
        cmp ebx,_HeapTop                        ;Ç o £ltimo bloco?
        jb @@BlockSplit_a1
        mov _heapHead,Esi                       ;sim,seta heaphead
        jmp @@BlockSplitQuit

    @@BlockSplit_a1:
        mov es:[esi][FreeBlock.NextBlock],Ebx   ;n∆o, actualiza

    @@BlockSplit_FindFree:
        cmp es:[ebx][AllocBlock.BlockId],MemBlockId
        jne @@AllocFoundNextFree
        add ebx,[ebx][AllocBlock.BlockSize]
        add ebx,16
        cmp ebx,_heaptop
        jb @@BlockSplit_FindFree
        jmp @@BlockSplitQuit

    @@AllocFoundNextFree:
        mov es:[ebx][FreeBlock.PrevFreeBlock],esi

    @@BlockSplitQuit:
        ret

      EndP

;--------------------------------------------------------------------
;
; Inicializa a Heap
; _InitHeap(Offset Base, Tamanho, Selector:dword)
;
;--------------------------------------------------------------------
Public _InitHeap

_InitHeap Proc far
          Arg @HeapBase:dword,@HeapSize:dword,@HeapSel:dword


     If PreserveRegsOnCall
          Push Eax Ecx Edi es
     EndIf
          mov eax,@heapsel              ;Selector da heap
          mov _HeapSelector,ax
          mov es,ax                     ;es na heap
          mov edi,@HeapBase             ;Seta a Base
          Mov _Heapbase,Edi
          mov ecx,edi
          add ecx,@HeapSize             ;calcula o topo
          mov _HeapTop,ecx
          mov _HeapHead,edi             ;seta o 1ß nodo
          mov ecx,@HeapSize
          sub ecx,size FreeBlock        ;calcula tamanho real da heap
          mov [edi][FreeBlock.NextBlock],nil
          mov [edi][FreeBlock.Blocksize],ecx
          mov [edi][FreeBlock.PrevBlock],nil
          Mov [edi][FreeBlock.PrevFreeBlock],nil
     If PreserveRegsOnCall
          Pop es edi ecx eax
     EndIf
         ret

        EndP

;--------------------------------------------------------------------
;
; Aloca 1 Bloco de Mem¢ria da Heap
; _GetMem(Tamanho:Dword)
; Retorna em ax:edx o selector:offset do bloco de mem¢ria
;
;--------------------------------------------------------------------
Public _GetMem

_GetMem Proc
        Arg @Size:Dword

     If PreserveRegsOnCall
        Push ebx ecx esi edi es
     EndIf
        Mov ecx,@Size
        mov es,_HeapSelector
        xor eax,eax
        xor edx,edx
        xor ebx,ebx
        jecxz @@Quit
        test Ecx,MemAlign-1                     ;Alinha o tamanho a alocar
        jz @@No_Align                           ;pelo valor de MemAlign
        and ecx,Not MemAlign-1
        add ecx,MemAlign

    @@No_Align:
        mov esi,_HeapHead                       ;obtÇm o 1ß bloco
        mov edi,nil

    @@FindSuitableBlock:
        mov eax,edi
        mov edi,esi
        cmp edi,nil                             ;se for nil sai
        je @@Quit                               ;sem alocar nada
        mov esi,[Edi][FreeBlock.PrevFreeBlock]
        cmp [edi][FreeBlock.BlockSize],ecx
        jb @@FindSuitableBlock

        Mov ebx,[edi][FreeBlock.BlockSize]
        mov esi,[edi][FreeBlock.BlockSize]
        sub ebx,ecx
        cmp ebx,24                              ;s¢ parte se a diferenáa
        jbe @@NoSplit                           ;for > 8 bytes

        call BlockSplit
        jmp @@QuitOk

    @@NoSplit:
        mov edx,[edi][Freeblock.PrevBlock]      ;aloca o bloco
        mov ebx,[edi][FreeBlock.PrevFreeBlock]
        AllocB Edi,edx,esi
        cmp eax,nil
        je @@quitOk
        mov esi,eax
        mov es:[esi][FreeBlock.PrevFreeBlock],ebx

    @@QuitOk:
        mov edx,edi
        add edx,16                              ;valor a retornar
        xor eax,eax
        mov ax,es

    @@Quit:
     If PreserveRegsOnCall
        Pop es edi esi ecx ebx
     EndIf
        Ret

     EndP

;--------------------------------------------------------------------
;
; Liberta 1 bloco de mem¢ria alocado por GetMem
; _FreeMem(Bloco:Dword)
;
;--------------------------------------------------------------------
Public _FreeMem

_FreeMem Proc
         Arg @Block:dword

     If PreserveRegsOnCall
         Push eax ebx ecx edx esi edi es
     EndIf
         mov es,_HeapSelector
         Mov edi,@block                         ;Prepara-se pra analisar o bloco
         cmp edi,0
         je @@FreeQuit

         sub edi,16                             ;in°cio da zona reservada
         cmp dword ptr [edi],MemBlockId         ;Ç bloco v†lido?
         jne @@FreeQuit
         mov ebx,edi

    @BlockFree_a1:
        mov ebx,es:[ebx][AllocBlock.PrevBlock]  ;Ve se o bloco anterior est† livre
        cmp ebx,nil
        je @Found_PrevFree
        cmp es:[ebx][AllocBlock.BlockID],MemBlockID
        jne @Found_PrevFree                      ;se sim,usa-o
        jmp @BlockFree_a1

    @Found_PrevFree:                            ;o bloco prev vem em ebx
        mov esi,[edi][AllocBlock.BlockSize]     ;calcula offset
        mov ecx,[edi][AllocBlock.BlockSize]     ;tamanho em ecx
        add esi,edi                             ;do pr¢ximo bloco
        add esi,16                              ;em esi
        cmp ebx,[edi][AllocBlock.PrevBlock]     ;se o anterior = anterior livre
        jne @TryToMergeNext
        cmp ebx,nil                             ;se n∆o for NIL
        je @TryToMergeNext
        mov edi,ebx                             ;funde os 2 blocos
        add ecx,[edi][FreeBlock.BlockSize]
        add ecx,16
        mov ebx,[ebx][FreeBlock.PrevFreeBlock]  ;e actualiza edx

    @TryToMergeNext:
        cmp esi,_heaptop                        ;ve se existe pr¢ximo
        jb @CheckNextBlock
        mov esi,nil                             ;ou se Ç nil
        jmp @MarkAsFree

    @CheckNextBlock:
        cmp es:[esi][AllocBlock.BlockId],MemBlockID
        je @MarkAsFree
        add ecx,es:[esi][FreeBlock.BlockSize]   ;funde com o pr¢ximo
        add ecx,16
        mov esi,es:[esi][FreeBlock.NextBlock]

    @MarkAsFree:
        mov eax,[edi][FreeBlock.PrevBlock]
        FreeB edi,esi,eax,ebx,ecx

    @FreeBlock_a2:
        cmp esi,nil                             ;se for o £ltimo
        jne @FreeBlock_a3
        mov _HeapHead,edi
        jmp @@FreeQuit

    @FreeBlock_a3:
        mov es:[esi][AllocBlock.PrevBlock],edi  ;seta o prevblock
        xchg esi,edi

    @LoopNextFree:
        cmp [edi][AllocBlock.BlockId],MemBlockId
        jne @FoundNextFree
        add edi,[edi][AllocBlock.BlockSize]
        add edi,16
        cmp edi,_heaptop
        jb @LoopNextFree
        jmp @@FreeQuit

    @FoundNextFree:
        mov [edi][FreeBlock.PrevFreeBlock],esi

    @@FreeQuit:
     If PreserveRegsOnCall
        pop es edi esi edx ecx ebx eax
     EndIf
        ret

       EndP

;--------------------------------------------------------------------
;
; Devolve a quantidade de mem¢ria livre na heap
; _MemAvail()
; Retorna: edx-> mem¢ria livre
;          eax-> tamanho do maior bloco livre
;
;--------------------------------------------------------------------
Public _MemAvail

_MemAvail Proc

     If PreserveRegsOnCall
        Push Edi Ebx es
     EndIf
        mov es,_HeapSelector
        mov edi,_HeapHead
        xor edx,edx
        xor eax,eax

     @@LoopFreeMem:
        cmp edi,nil
        je @@quitGetFreeMem
        mov ebx,[edi][FreeBlock.BlockSize]          ;obtÇm o tamanho
        add edx,ebx                                 ;e adiciona a edx
        cmp ebx,eax                                 ;và se Ç o maior bloco
        jbe @@NoEaxSwitch
        xchg eax,ebx                                ;se sim, actualiza eax

     @@NoEaxSwitch:
        mov edi,[edi][FreeBlock.PrevFreeBlock]
        jmp @@LoopFreeMem

     @@QuitGetFreeMem:
     If PreserveRegsOnCall
        Pop es ebx edi
     EndIf
        ret

      Endp

;--------------------------------------------------------------------

        EndSegment32

;--------------------------------------------------------------------
End
