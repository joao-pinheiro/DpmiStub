;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
;
; Macros de Segmentos
;
;####################################################################

;====================================================================

Segment16      Macro
               Assume CS:Text16, Ds:Text16
               Text16 Segment Para Public Use16
               Align 4
               ENDM

EndSegment16   Macro
               Text16 Ends
               EndM

;====================================================================

Segment32      Macro
               Stack32 Segment public Para Use32
               Stack32 Ends
               Assume CS:Text32, DS:Text32, SS:Stack32
               Text32 Segment public para Use32
               Align 8
               Endm

EndSegment32   Macro
               Text32 Ends
               Endm

;====================================================================

