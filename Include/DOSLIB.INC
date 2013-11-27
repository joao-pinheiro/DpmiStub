;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
; Biblioteca de Fun‡äes de Ficheiros - Ficheiro de Include
;
;
;####################################################################

Segment32
;====================================================================

;Modos de Abertura de Ficheiro

FReadOnly  Equ 00h
FWriteOnly Equ 01h
FReadWrite Equ 02h

;====================================================================

Global _DosLibBufSeg:word
Global _DosLibBufSel:word
Global _DosLibBufSize:Dword

;====================================================================

Global _InitDosLib:Near
Global _DisposeDosLib:Near

Global _ShowStr:Near

Global _Fopen:Near
Global _FClose:Near
Global _FNew:Near
Global _FRead:Near
Global _FWrite:Near
Global _FSeek:Near
Global _FileSize:Near

;====================================================================
EndSegment32
