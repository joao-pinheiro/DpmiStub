;####################################################################
;
; Dpmi Stub Loader v1.0b
;
; Programado por Joao Pinheiro aka Ancestor (c) 2000 
;
; Definicoes de Externals
;
;####################################################################

Include ..\include\Segs.Inc

Segment32

        Extrn _Stack16Seg:word
        Extrn _Stack32Seg:word     
        Extrn _InternalBuffer:word 
        Extrn _DosHeapBlock:word 
        Extrn _SelPsp:word       
        Extrn _SelCode16:word    
        Extrn _SelData16:word    
        Extrn _SelStack16:word   
        Extrn _SelData32:word    
        Extrn _SelCode32:word    
        Extrn _SelStack32:word    
        Extrn _SelData0:word      
        Extrn _SelCode0:word      
        Extrn _Dpmi_Version:word  
        Extrn _Dpmi_Flags:word    
        Extrn _Dpmi_Cpu:byte      
        Extrn _Dpmi_MasterPic:byte
        Extrn _Dpmi_SlavePic:byte 
        Extrn _Dpmi_SelIncVal:word
        Extrn _InternBufLinAddx:dword
        Extrn _DosHeapBlockLinAddx:dword

EndSegment32

;====================================================================
