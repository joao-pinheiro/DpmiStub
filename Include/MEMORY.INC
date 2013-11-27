;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000
;
; Gerenciador de mem¢ria - Ficheiro de Include
;
;####################################################################


Segment32

;Vari veis

Global _HeapBase:Dword
Global _HeapTop:Dword
Global _HeapSelector:Word
Global _HeapHead:Dword

;Proc's

Global _InitHeap:Far
Global _GetMem:Near
Global _FreeMem:Near
Global _MemAvail:Near

EndSegment32

;====================================================================