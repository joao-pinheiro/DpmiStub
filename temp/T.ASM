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

Segment32
;==================================================================

VbeInfoBlock Struc
  VbeSignature      db 'VBE2'
  VbeVersion        dw ?
  OemStringPtr      dd ?         ;ptr pra OEM String
  Capabilities      db 4 dup(?)  ;
  VideoModePtr      dd ?         ;ptr pra modos de v¡deo
  TotalMemory       dw ?         ;Total de blocos de 64k

  ;-------------------------------Vesa 2.0+
  OemSwRev          dw ?
  OemVendorNamePtr  dd ?
  OemProductNamePtr dd ?
  OemProductRevPtr  dd ?
  Reserved          db 222 dup(?)
  OemData           db 256 dup(?) ;Zona pra strings OEM
VbeInfoBlock Ends

ModeInfoBlock Struc
  ModeAttributes    dw ?
  WinAAttributes    db ?
  WinBAttributes    db ?
  WinGranularity    dw ?
  WinSize           dw ?
  WinASegment       dw ?
  WinBSegment       dw ?
  WinFuncPtr        dd ?
  BytesPerScanLine  dw ?

  ;-------------------------------Vbe 1.2+
  XResolution         dw ?
  YResolution         dw ?
  XCharSize           db ?
  YCharSize           db ?
  NumberOfPlanes      db ?
  BitsPerPixel        db ?
  NumberOfBanks       db ?
  MemoryModel         db ?
  BankSize            db ?      ;tamanho do banco em Kb
  NumberOfImagePages  db ?
  Reserved1           db ?

  ;Direct Color Fields para direct/6 e YUV/7 mem models
  RedMaskSize         db ?      ;tamanho da m scara em bits
  RedFieldPosition    db ?      ;posi‡Æo do bit lsb da mascara
  GreenMaskSize       db ?      ;tamanho da m scara em bits
  GreenFieldPosition  db ?      ;posi‡Æo do bit lsb da mascara
  BlueMaskSize        db ?      ;tamanho da m scara em bits
  BlueFieldPosition   db ?      ;posi‡Æo do bit lsb da mascara
  RsvdMaskSize        db ?      ;tamanho da m scara em bits
  RsvdFieldPosition   db ?      ;posi‡Æo do bit lsb da mascara
  DirectColorModeInfo db ?      ;atributos do modo direct color

  ;-------------------------------Vbe 2.0+
  PhysBasePtr         dd ?      ;endere‡o f¡sico do lfb
  Reserved2           dd ?
  Reserved3           dw ?

  ;-------------------------------Vbe 3.0+
  LinBytesPerScanLine      dw ?   ;bytes por scanline em modos lineares
  BnkNumberOfImagePages    db ?
  LinNumberOfImagePages    db ?
  LinRedMaskSize           db ?
  LinRedFieldPosition      db ?
  LinGreenMaskSize         db ?
  LinGreenFieldPosition    db ?
  LinBlueMaskSize          db ?
  LinBlueFieldPosition     db ?
  LinRsvdMaskSize          db ?
  LinRsvdFieldPosition     db ?
  MaxPixelClock            dd ? ;Freq max do pixel clock em hz

  Reserved4                db 189 dup(?)
ModeInfoBlock Ends
;==================================================================


;==================================================================

_VbeInfo     VbeInfoBlock <>      ;dados do vesa
_ModeInfo    ModeInfoBlock <>     ;dados do modo de video
_VbePresent  db 0                 ;boolean q indica se h  ou nÆo vesa2

;Dados do modo de v¡deo corrente (+ r pido a carregar nos regs)---

_LfbAddx     dd ?                 ;endere‡o _linear_ do Lfb
_LfbSize     dd ?                 ;Tamanho do Lfb em bytes
_Xmax        dw ?                 ;Resolu‡Æo X
_Ymax        dw ?                 ;Resolu‡Æo Y
_ScanLine    dw ?                 ;Tamanho da scanline em bytes

;==================================================================

CheckVesa2 Proc Near

           Mov Ax,4F00h
           mov _RmES,Text32
           mov Edi,Offset _VbeInfo
           Call _ExecRmInt,10h
           Sub ax,4Fh
           mov eax,0
           jnz @@Quit_CheckVesa
           cmp _VbeInfo.VbeVersion, 0200h
           jne @@quit_CheckVesa
           inc eax

    @@Quit_CheckVesa:
           ret
         EndP
;----------------------------------------------------------------
;retorna true/false em Eax

GetModeInfo Proc Near
            Arg @Modo:Dword

            mov eax,04f01h
            mov _RmES,Text32
            mov ecx,@modo
            mov Edi,offset _ModeInfo
            call _ExecRmInt,10h
            sub ax,4fh
            mov eax,0
            jnz @@quit_Getmodeinfo
            test _ModeInfo.ModeAttributes,81h    ; o hw suporta e ‚ LFB?
            jz @@quit_GetModeInfo               ;nopes, baza
            inc Eax

    @@quit_Getmodeinfo:
            ret
         EndP

;------------------------------------------------------------------
; retorna Eax true/false

SetVesaMode Proc Near
            Arg @Mode:Dword

            call GetModeInfo,@mode
            test eax,1
            jz @@Quit_SetMode

            mov eax,4f02h
            mov ebx,@mode
            or Ebx,4000h                ;Seta como LFB e limpa mem
            call _ExecRmInt,10h
            sub ax,4fh
            mov eax,0
            jnz @@quit_SetMode
            ;calcular o tamanho do modo

            mov bx,_ModeInfo.BytesPerScanLine
            movzx eax,_ModeInfo.YResolution
            mov _Ymax,ax
            mov _ScanLine,bx
            mul bx
            shl edx,16
            mov dx,ax                           ;Edx-Bytes de cada frame
            mov _LfbSize,edx
            Mov ebx,_ModeInfo.PhysBasePtr
            Call _DpmiPhysicalMap,Ebx, Edx
            mov _LfbAddx,edi
            mov dx,_ModeInfo.XResolution
            mov _XMax,dx
            mov eax,1

        @@Quit_SetMode:
            ret
          EndP

;==================================================================

TextMode Proc Near

          Mov ax,03h
          int 10h
          ret
         EndP


;cor em al
ClearScreen:
          mov edi,_LfbAddx
          mov es,_seldata0
          mov ah,al
          push ax
          shl eax,16
          pop ax

          mov ecx,_LfbSize
          shr ecx,2
          cld
          rep stosd

          retn


;-------------------------------------------------------------------
;-------------------------------------------------------------------

PcxHdrStruc Struc
         PcxMagic       db ?
         PcxVersion     db ?
         PcxEncoding    db ?
         PcxBitsPixel   db ?
         PcxXmin        dw ?
         PcxYmin        dw ?
         PcxXmax        dw ?
         PcxYmax        dw ?
         PcxHDpi        dw ?
         PcxVDpi        dw ?
         PcxColorMap    db 48 dup(?)
         PcxReserved    db ?
         PcxPlanes      db ?
         PcxScanLineLen dw ?
         PcxPaletteInfo dw ?
         PcxHScreenSize dw ?
         PcxVScreenSize dw ?
PcxHdrStruc Ends


;ds:esi, src
;es:edi, buf target

;/////////////////////////////////////////////////////////////
; Descodifica o Bitmap PCX para ptr Data0:To
;/////////////////////////////////////////////////////////////

DecodePcx8 Proc Near
           Arg @From:Dword,@To:Dword

           push es ds
           xor ecx,ecx
           xor edx,edx
           mov ds,cs:_SelData0       ;assume es:seldata0
           mov esi,@From
           movzx eax,[esi][PcxHdrStruc.PcxXmax]
           movzx ebx,[esi][PcxHdrStruc.PcxYmax]
           mov edi,@to
           sub ax,[esi][PcxHdrStruc.PcxXmin]
           sub bx,[esi][PcxHdrStruc.PcxYmin]
           inc eax
           inc ebx
           mul bx
           Shl Edx,16
           mov dx,ax                 ;Edx - Total de Pixels da Imagem
           add esi,128

       @@Pcx8Loop:
           mov ecx,1
           lodsb
           cmp al,0C0h
           jbe @@Continue
           mov cl,al
           and cl,3Fh
           lodsb
       @@continue:
           sub edx,ecx
           cld
           rep stosb
           cmp edx,0
           jg @@Pcx8Loop
           Jmp @@QuitPcx8

       @@No_Unroll:
           stosb
           dec edx
           jnz @@Pcx8Loop

       @@QuitPcx8:
           pop ds es
           ret
         Endp



Public _Main


v640x400x8  = 100h
v640x480x8  = 101h
v800x600x8  = 103h
v640x480x15 = 110h
v640x480x16 = 111h
v640x480x24 = 112h
v800x600x15 = 113h
v800x600x16 = 114h
v800x600x24 = 115h

PcxFileName db 'c:\temp\tst.pcx',0,0ah,0dh,'$'
PcxFileName2 db 'c:\temp\tst2.pcx',0,0ah,0dh,'$'
fhandle     dd 0
fhandle2     dd 0
memblock    dd 0

_Main Proc
       call _InitDosLib,15*256          ;buffer de 64k

       call CheckVesa2
       call SetVesaMode,112h
       mov al,00h
       call ClearScreen

       mov ax,03h
       int 10h
       mov ds,cs:_seldata32
       mov edx,_lfbsize
       call DumpValue,edx
       jmp @@quitz


       call _Fopen,cs,offset PcxFilename,0
       mov fhandle,eax
       cmp eax,0                                ;se falhou sai
       je @@quitz

       call _FileSize,eax                       ;obt‚m o tamanho
       cmp eax,0
       je @@quitz

       push eax
       call _DpmiGetMem,eax
       mov memblock,edi
       pop eax

       push es eax
       mov es,_seldata0
       mov ecx,eax
       cld
       xor eax,eax
       rep stosb
       pop eax es

       push eax
       mov edi,memblock
       movzx ebx,_SelData0
       call _Fread,fhandle,ebx,Edi,eax     ;lˆ o file
       call _fclose,fHandle
       pop ecx
;-------------------------------------------------------------------

       push ds es
       mov ax,_SelData0
       mov es,ax
       mov esi,Memblock
       mov edi,_LfbAddx
       Call DecodePcx8,Esi,Edi
       pop es ds


      xor eax,eax
      int 16h

 @@quitz:
;      mov ax,03h
;      int 10h
;       call _DpmiFreeMem,memblock
;       call DumpValue,ebx
       retf

       Endp


TheTestProc Proc
        arg @p1:dword,@p2:word,@destS:dword,@desto:dword

        Mov ax,@p2
        cmp ax,_seldata0
        jne @exitproc
        mov es,ax
        Mov edi,0b8000h

;        cmp @dests,1
;        jne @exitProc
;        cmp @desto,2
;        jne @exitproc
        mov ax,45345
        mov eax,1000
        cld
        rep stosw


     @exitproc:
        ret
       Endp
include ..\include\debug.inc


EndSegment32

Segment16

Msggg db 'Modo real','$'

tst:
    mov ax,cs
    mov ds,ax
    mov dx,offset msggg
    mov ah,09h
    int 21h
    clc
    retf


EndSegment16

end
